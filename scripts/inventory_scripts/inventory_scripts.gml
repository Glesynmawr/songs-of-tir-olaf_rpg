
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
	else if (inventory.selected == 1){
		var h1 = inventory.equ_hover[0];
		var h2 = inventory.equ_hover[1];
		var type_y = h1 * (text_height * 2);
		var slot_y = h2 * text_height;
		
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

// Inventory interaction
function inventory_add_item(actor, item){
	with (actor){
		array_push(inventory.items, item);
		return(true);
	}
}

function inventory_drop_slot(actor, slot, stack){
	with (actor){
		
		inventory.items[slot].stack -= stack;
		if (inventory.items[slot].stack <= 0){
			array_delete(inventory.items, slot, 1);
		}
		if (inventory.inv_hover >= array_length(inventory.items)) inventory.inv_hover = array_length(inventory.items) - 1;
		
		return(true);
	}
}

// Equipment interaction


