
// INVENTORY INITIALISATION
function context_menu_initialise(){
	
	var content, xx, yy, ww, hh, i;
	
	content = ["Hold", "Drop"];
		
	if (array_length(inventory.items[inventory.inv_hover].slot) > 0){
		array_insert(content, 1, "Equip");
	}
		
	yy = 0 + (manager.text_height * 3) + (manager.text_height * inventory.inv_hover);
	xx = manager.screen_width / 2;
		
	ww = 0;
	for (i = 0; i < array_length(content); i ++){
		var w = string_width(content[i]);
		if (w > ww) ww = w;
	}

	hh = (array_length(content) * manager.text_height) + (manager.text_height * 4);
	
	inventory.context_menu = [content, xx, yy, ww, hh, 0];
	state = state_context_menu;
}

function equipment_context_menu_initialise(){
	
	var content, xx, yy, ww, hh, i;
	
	content = ["Remove", "Drop"];
		
	xx = manager.equipment_hovered_x_pos + manager.equipment_box_sprite_size;
	yy = manager.equipment_hovered_y_pos;
		
	ww = 0;
	for (i = 0; i < array_length(content); i ++){
		var w = string_width(content[i]);
		if (w > ww) ww = w;
	}
	
	hh = (array_length(content) * manager.text_height) + (manager.text_height * 4);
	
	inventory.context_menu = [content, xx, yy, ww, hh, 0];
	state = state_context_menu;
}
	
function equipment_initialise(equipment_body_layout){

	for (var cat = 0; cat < array_length(equipment_body_layout); cat ++){
		var len = array_length(equipment_body_layout[cat]);
		
		for (var ind = 0; ind < len; ind ++){
			
			var repeats = 1;
			switch(cat){
				case BODY_PART_CATEGORY.HEAD: repeats = HEAD_INDEX.COUNT; break;
				case BODY_PART_CATEGORY.BODY: repeats = BODY_INDEX.COUNT; break;
				case BODY_PART_CATEGORY.ARMS: repeats = ARMS_INDEX.COUNT; break;
				case BODY_PART_CATEGORY.LEGS: repeats = LEGS_INDEX.COUNT; break;
				default: repeats = 0;
			}
			
			// Add worn equipment slots
			repeat(repeats + 2){
				array_push(equipment_body_layout[cat][ind], noone)
			}
		}
	}
	
	return(equipment_body_layout);
}

function equipment_slot_select_initialise(){
	
	var category  = inventory.items[inventory.inv_hover].slot[0];
	var item_slot = inventory.items[inventory.inv_hover].slot[1];
	
	var list_content = [];
	var len = 3;
	if (len > 0){
		
		list_content = equipment_slot_create_list(category, item_slot);
	}
	
	// Set menu position and size
	var xx = inventory.context_menu[1];
	var yy = inventory.context_menu[2];
	var ww = 0;
	for (var i = 0; i < array_length(list_content); i ++){
		var w = string_width(list_content[i][0]);
		if (w > ww) ww = w;
	}
	var hh = (array_length(list_content) * manager.text_height) + (manager.text_height * 4);
	
	// Set slot selection state
	inventory.slot_select_menu = [list_content, xx, yy, ww, hh, 0];
	state = state_slot_selection;
}

function equipment_slot_create_list(category, item_slot){
	
	var slot_list = [];
	var actual_slot = item_slot + BODY_PART_STATS.PART_SLOT_1;
	
	for (var index = 0; index < array_length(body_plan[category]); index ++){
		
		if (body_part_is_present(self, category, index)){
			
			var from = BODY_PART_STATS.PART_SLOT_1;
			var to   = BODY_PART_STATS.PART_AUX_SLOT + 1;
			for (var p = from; p < to; p ++){
			
				var slot = p;
				if (slot == actual_slot){
					var txt = "Equip to ";
					txt += equipment_slot_stringify(category, item_slot);
					if (body_part_count(self, category) > 1){
						txt += " of " + body_plan[category][index][BODY_PART_STATS.PART_NAME];
					}
					
					array_push(slot_list, [txt, category, index, actual_slot]);
				}
			}
		}
	}
	return(slot_list);
}

function equipment_slot_stringify(cat, ind){
	if (cat == BODY_PART_CATEGORY.HEAD){
		if (ind == HEAD_INDEX.HEAD) return("Head");
		if (ind == HEAD_INDEX.FACE) return("Face");
	}
	if (cat == BODY_PART_CATEGORY.BODY){
		if (ind == BODY_INDEX.BODY) return("Body");
		if (ind == BODY_INDEX.BACK) return("Back");
	}
	if (cat == BODY_PART_CATEGORY.ARMS){
		if (ind == ARMS_INDEX.BRACER) return("Arm");
		if (ind == ARMS_INDEX.GLOVE) return("Hand");
	}
	if (cat == BODY_PART_CATEGORY.LEGS){
		if (ind == LEGS_INDEX.GREAVE) return("Leg");
		if (ind == LEGS_INDEX.BOOT) return("Foot");
	}
}

function inventory_initialise(){
	var inv;
	
	inv = {
		items:				[],
		selected:			1,
		inv_hover:			0,
		context_menu:		noone,
		equ_hover:			[0, 0, BODY_PART_STATS.PART_SLOT_1],
		slot_select_menu:	noone
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
	var new_item = variable_clone(item);
	with (actor){
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
function equipment_add_item(actor, item_struct, dest_cat, dest_ind, dest_slot){
	
	if (actor.body_plan[dest_cat][dest_ind][dest_slot] == noone){
		actor.body_plan[dest_cat][dest_ind][dest_slot] = variable_clone(item_struct);
	}
	else{
		var equipped_item_to_remove = variable_clone(actor.body_plan[dest_cat][dest_ind][dest_slot]);
		actor.body_plan[dest_cat][dest_ind][dest_slot] = variable_clone(item_struct);
		inventory_add_item(actor, equipped_item_to_remove);
	}
}

function equipment_drop_slot(actor, target_cat, target_ind, target_slot){
	
	actor.body_plan[target_cat][target_ind][target_slot] = noone;
}


