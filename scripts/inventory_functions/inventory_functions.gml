
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
				case BODY_PART_CATEGORY.WING: repeats = WING_INDEX.COUNT; break;
				default: repeats = 0;
			}
			
			repeat(repeats){
				array_push(equipment_body_layout[cat][ind], noone)
			}
		}
	}
	
	return(equipment_body_layout);
}

function inventory_initialise(){
	var inv;
	
	inv = {
		items:			[],
		selected:		1,
		inv_hover:		0,
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





