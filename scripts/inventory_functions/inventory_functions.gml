
// INVENTORY INITIALISATION
function context_menu_initialise(){
	
	var content, xx, yy, ww, hh, i;
	
	if (inventory.selected == 1){
		content = inventory.items[inventory.inv_hover].interact;
		yy = 0 + (manager.text_height * 3) + (manager.text_height * inventory.inv_hover);
		xx = manager.screen_width / 2;
		
		ww = 0;
		for (i = 0; i < array_length(content); i ++){
			var w = string_width(content[i]);
			if (w > ww) ww = w;
		}
	}
	else if (inventory.selected == 0){
		
		var type = inventory.equ_hover[0];
		var slot = inventory.equ_hover[1];
		
		if (!is_struct(inventory.equipment[type][slot])) return(false);
		
		var h1 = inventory.equ_hover[0];
		var h2 = inventory.equ_hover[1];
		var type_y = h1 * (manager.text_height * 2);
		var slot_y = h2 * manager.text_height;
		
		content = ["Remove", "Drop"];
		yy = 0 + (manager.text_height * 3) + type_y + slot_y;
		xx = floor(manager.screen_width / 4);
		
		ww = 0;
		for (i = 0; i < array_length(content); i ++){
			var w = string_width(content[i]);
			if (w > ww) ww = w;
		}
	}
	
	hh = (array_length(content) * manager.text_height) + (manager.text_height * 4);
	
	inventory.context_menu = [content, xx, yy, ww, hh, 0];
	
	state = state_context_menu;
}

function equipment_initialise(body_layout){
	var equipment = [];

	// Head and neck
	for (var i = 0; i < body_layout[0]; i ++){
		equipment[EQUIP.HEAD][i] = noone;
		equipment[EQUIP.NECK][i] = noone;
	}
		
	// Body and back
	equipment[EQUIP.BODY][0] = noone;
	equipment[EQUIP.BACK][0] = noone;
		
	// Arms and hands
	for (i = 0; i < body_layout[2]; i ++){
		equipment[EQUIP.ARMS][i] = noone;
		equipment[EQUIP.HAND][i] = noone;
		if (i < 2){
			equipment[EQUIP.GUNS][i] = noone;
		}
	}
	for (i = 0; i < floor(body_layout[2] / 2); i ++){
		equipment[EQUIP.MITT][i] = noone;
	}
		
	// Legs
	for (i = 0; i < floor(body_layout[3] / 2); i ++){
		equipment[EQUIP.FEET][i] = noone;
	}
	
	return(equipment);
}

function inventory_initialise(){
	var inv;
	
	inv = {
		items:			[],
		equipment:		[],
		selected:		1,
		inv_hover:		0,
		equ_hover:		[0, 0],
		context_menu:	noone
	}
	
	return(inv);
}

function pickup_menu_initialise(actor){
	var items = manager.game_grid[actor.x_pos][actor.y_pos].items;
	if (array_length(items) <= 0){
		return(false);
	}
	else{
		pickup_menu		= [];
		pickup_hover	= 0;
		
		for (var i = 0; i < array_length(items); i ++){
			array_push(pickup_menu, items[i]);
		}
		
		state = state_pickup;
	}
}


// INVENTORY INTERACTION
function inventory_add_item(actor, item){
	with (actor){
		var new_item = variable_clone(item);
		array_push(inventory.items, new_item);
		return(true);
	}
}

function inventory_drop_slot(actor, slot, stack){
	with (actor){
		
		inventory.items[slot].stack -= stack;
		if (inventory.items[slot].stack <= 0){
			array_delete(inventory.items, slot, 1);
		}
		var len = array_length(inventory.items)
		if (len > 0){
			if (inventory.inv_hover >= len){
				inventory.inv_hover = len - 1;
			}
		}
		else inventory.inv_hover = 0;
		
		return(true);
	}
}


// EQUIPMENT INTERACTION
function equipment_add_item(actor, item, type, slot){
	
	var new_item = variable_clone(item);
	var empty_prev_slot = false;
	var empty_next_slot = false;
	
	// CHECK ITEM TWO HANDED ----------------------------------------------------------------------
	// Get Item Two Handed Status
	if (array_contains(new_item.tags, TAG.TWO_SLOTS)){
		empty_next_slot = true;
	}
	
	// Check Previous Slot
	if (actor.inventory.equipment[type][slot] == -3){
		empty_prev_slot = true;
	}
	
	if (empty_prev_slot == true){
		
		var prev_slot = slot - 1;
		if (prev_slot < 0) prev_slot = array_length(actor.inventory.equipment[type]) - 1;
		
		if (is_struct(actor.inventory.equipment[type][prev_slot])){
			inventory_add_item(actor, actor.inventory.equipment[type][prev_slot]);
			actor.inventory.equipment[type][prev_slot] = noone;
		}
		else if (actor.inventory.equipment[type][prev_slot] == -3){
			actor.inventory.equipment[type][prev_slot] = noone;
		}
	}
	
	var next_slot = slot + 1;
	if (next_slot >= array_length(actor.inventory.equipment[type])) next_slot = 0;
		
	if (empty_next_slot == true){
		
		if (is_struct(actor.inventory.equipment[type][next_slot])){
			inventory_add_item(actor, actor.inventory.equipment[type][next_slot]);
			actor.inventory.equipment[type][next_slot] = noone;
		}
		else if (actor.inventory.equipment[type][next_slot] == -3){
			actor.inventory.equipment[type][next_slot] = noone;
		}
	}
	else{
		
		if (actor.inventory.equipment[type][next_slot] == -3){
			actor.inventory.equipment[type][next_slot] = noone;
		}
	}
	
	// SET EQUIPMENT ITEM AND REMOVE EXISTING ITEM ------------------------------------------------
	if (is_struct(actor.inventory.equipment[type][slot])){
		inventory_add_item(actor, actor.inventory.equipment[type][slot]);
	}
	actor.inventory.equipment[type][slot] = noone;
	actor.inventory.equipment[type][slot] = new_item;
	if (empty_next_slot){
		actor.inventory.equipment[type][next_slot] = -3;
	}
}

function equipment_drop_slot(actor, type, slot){
	// Reset equipment slot to noone
	actor.inventory.equipment[type][slot] = noone;
	
	var next_slot = slot + 1;
	if (next_slot >= array_length(actor.inventory.equipment[type])) next_slot = 0;
	if (actor.inventory.equipment[type][next_slot] == -3){
		actor.inventory.equipment[type][next_slot] = noone;
	}
}




