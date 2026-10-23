
// INVENTORY INITIALISATION
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

function hit_weights_calculate(actor, body_layout){
	var hit_weights	= [];
	for (var category = 0; category < array_length(body_layout); category ++){
		var category_weight = 0;
		switch(category){
			case BODY_PART_CATEGORY.HEAD: category_weight = 2;  break;
			case BODY_PART_CATEGORY.BODY: category_weight = 10; break;
			case BODY_PART_CATEGORY.ARMS: category_weight = 4;  break;
			case BODY_PART_CATEGORY.LEGS: category_weight = 6;  break;
			default: category_weight = 0;
		}
		var number_of_parts = body_part_count(actor, category);
		if (number_of_parts != 0){
			var weight_per_part = category_weight / number_of_parts;
		}
		
		for (var index = 0; index < array_length(body_layout[category]); index ++){
			if (body_part_is_present(actor, category, index)){
				hit_weights[category][index] = weight_per_part;
			}
		}
	}
	return(hit_weights);
}

function inventory_initialise(){
	var inv;
	
	inv = {
		items:				[],
		selected:			1,
		inv_hover:			0,
		context_menu:		noone,
		equ_hover:			[0, 0, BODY_PART_STATS.PART_SLOT_1],
		slot_select_menu:	noone,
		ammo_cap:			20,
	}
	
	return(inv);
}


// EQUIPMENT CYCLING
function body_part_find_min_slot(actor, category, index){
	var min_slot = BODY_PART_STATS.PART_SLOT_1;
	if (body_part_has_hand(self, category, index)){
		min_slot = BODY_PART_STATS.PART_AUX_SLOT;
	}
	return(min_slot);
}

function body_part_find_next_exists(actor, cat_start, ind_start){
	var cat_count = array_length(actor.body_plan);
	var ind_count = array_length(actor.body_plan[cat_start]);
	
	var cat_current = cat_start;
	var ind_current = ind_start + 1;
	if (ind_current >= ind_count){
		ind_current = 0;
		cat_current ++;
		if (cat_current >= cat_count){
			cat_current = 0;
		}
	}
	repeat(cat_count){
		
		ind_count = array_length(actor.body_plan[cat_current]);
		
		for (var i = ind_current; i < ind_count; i ++){
			if (body_part_is_present(actor, cat_current, i)){
				return([cat_current, i]);
			}
		}
		
		ind_current = 0;
		cat_current ++;
		if (cat_current >= cat_count){
			cat_current = 0;
		}
	}
	return(noone);
}

function body_part_find_prev_exists(actor, cat_start, ind_start){
	var cat_count = array_length(actor.body_plan);
	var ind_count = array_length(actor.body_plan[cat_start]);
	
	var cat_current = cat_start;
	var ind_current = ind_start - 1;
	if (ind_current < 0){
		
		cat_current --;
		if (cat_current < 0){
			cat_current = cat_count - 1;
		}
		ind_count = array_length(actor.body_plan[cat_current]);
		ind_current = ind_count - 1;
	}
	repeat(cat_count){
		
		ind_count = array_length(actor.body_plan[cat_current]);
		
		for (var i = ind_current; i >= 0; i --){
			if (body_part_is_present(actor, cat_current, i)){
				return([cat_current, i]);
			}
		}
		
		cat_current --;
		if (cat_current < 0){
			cat_current = cat_count - 1;
		}
		ind_count = array_length(actor.body_plan[cat_current]);
		ind_current = ind_count - 1;
	}
	return(noone);
}


// MENU INITIALISATION
function context_menu_initialise(){
	
	var content, xx, yy, ww, hh, i;
	
	content = [];
	
	if (inventory.selected == 1 or manager.inventory_display_state == INVENTORY_DISPLAY.EQUIPMENT){
		
		content = ["Drop"];
		if (inventory.items[inventory.inv_hover].stack > 1){
			content[0] += " One";
			array_push(content, "Drop All");
		}
	}
	
	if (manager.inventory_display_state == INVENTORY_DISPLAY.EQUIPMENT){
		array_insert(content, 0, "Hold");
		if (array_length(inventory.items[inventory.inv_hover].slot) > 0){
			array_insert(content, 1, "Equip");
		}
	}
	else if (manager.inventory_display_state == INVENTORY_DISPLAY.CONTAINER){
		if (inventory.selected == 1){
			array_insert(content, 0, "Store");
		}
		else if (inventory.selected == 0){
			array_insert(content, 0, "Take");
		}
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
	if (body_plan[inventory.equ_hover[0]][inventory.equ_hover[1]][inventory.equ_hover[2]].stack > 1){
		array_push(content, "Drop All");
	}
	
	xx = manager.screen_width  / 2;
	yy = manager.screen_height / 2;
		
	ww = 0;
	for (i = 0; i < array_length(content); i ++){
		var w = string_width(content[i]);
		if (w > ww) ww = w;
	}
	
	hh = (array_length(content) * manager.text_height) + (manager.text_height * 4);
	
	inventory.context_menu = [content, xx, yy, ww, hh, 0];
	state = state_context_menu;
}

function equipment_slot_create_list(category, item_slot){
	
	var slot_list = [];
	var actual_slot = item_slot + BODY_PART_STATS.PART_SLOT_1;
	
	for (var index = 0; index < array_length(body_plan[category]); index ++){
		
		if (body_part_is_present(self, category, index)){
			
			var from = array_length(body_plan[category][index]) - 1;
			var to   = BODY_PART_STATS.PART_AUX_SLOT;
			for (var p = from; p >= to; p --){
			
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

function equipment_slot_select_initialise(){
	
	var category  = inventory.items[inventory.inv_hover].slot[0];
	var item_slot = inventory.items[inventory.inv_hover].slot[1];
	
	var list_content = [];
	list_content = equipment_slot_create_list(category, item_slot);
	
	// Set menu position and size
	var xx = manager.screen_width  / 2;
	var yy = manager.screen_height / 2;
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

function equipment_slot_stringify(cat, ind){
	if (cat == BODY_PART_CATEGORY.HEAD){
		if (ind == HEAD_INDEX.HEAD) return("Head");
		if (ind == HEAD_INDEX.FACE) return("Face");
	}
	if (cat == BODY_PART_CATEGORY.BODY){
		if (ind == BODY_INDEX.BODY) return("Body");
		if (ind == BODY_INDEX.BACK) return("Back");
		if (ind == BODY_INDEX.AMMO) return("Ammo");
	}
	if (cat == BODY_PART_CATEGORY.ARMS){
		if (ind == ARMS_INDEX.BRACER) return("Arm");
		if (ind == ARMS_INDEX.GLOVE)  return("Hand");
	}
	if (cat == BODY_PART_CATEGORY.LEGS){
		if (ind == LEGS_INDEX.GREAVE) return("Leg");
		if (ind == LEGS_INDEX.BOOT)   return("Foot");
	}
}

function hold_slot_create_list(){
	
	var slot_list = [];
	
	for (var category = 0;category < array_length(body_plan); category ++){
		for (var index = 0; index < array_length(body_plan[category]); index ++){
			if (body_part_is_present(self, category, index)){
				if (body_part_has_hand(self, category, index)){
					var body_part_text = "Hand - " + body_plan[category][index][BODY_PART_STATS.PART_NAME];
					array_push(slot_list, [body_part_text, category, index, BODY_PART_STATS.PART_HAND_SLOT]);
					
					var body_part_text = "Aux - " + body_plan[category][index][BODY_PART_STATS.PART_NAME];
					array_push(slot_list, [body_part_text, category, index, BODY_PART_STATS.PART_AUX_SLOT]);
				}
			}
		}
	}
	return(slot_list);
}

function hold_slot_select_initialise(){
	
	var list_content = [];
	list_content = hold_slot_create_list();
	
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

function pickup_menu_initialise(actor){
	var items = manager.game_state.game_grid[actor.x_pos][actor.y_pos].items;
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
function inventory_add_item(actor, item, stack){
	var new_item = variable_clone(item);
	new_item.stack = stack;
	
	with (actor){
		
		// Check item has tags
		if (struct_exists(new_item, "tags")){
			
			// Check for STACKABLE tag
			if (item_check_tag(new_item, TAG.STACKABLE)){
			
				// Check for existing item of same type
				if (array_length(inventory.items) > 0){
					for (var i = 0; i < array_length(inventory.items); i ++){
						if (new_item.name == inventory.items[i].name){
							inventory.items[i].stack += stack;
							inv_weight = inventory_get_weight(self);
							actor_set_action_speed(self);
							return(true);
						}
					}
				}
			}
		}
		
		var item_sort	= item.sort_index;
		var item_name   = item.name;
			
		for (i = 0; i < array_length(inventory.items); i ++){
			var inv_slot_sort = inventory.items[i].sort_index;
			var inv_slot_name = inventory.items[i].name;
			
			if (item_sort < inv_slot_sort){
				
				// Insert item into sorted position
				array_insert(inventory.items, i, new_item);
				inv_weight = inventory_get_weight(self);
				actor_set_action_speed(self);
				return(true);
			}
				
			if (inv_slot_sort == item_sort){
				if (item_name < inv_slot_name){
					
					// Insert item into sorted position
					array_insert(inventory.items, i, new_item);
					inv_weight = inventory_get_weight(self);
					actor_set_action_speed(self);
					return(true);
				}
			}
		}
		
		// Push unsorted item onto inventory array
		array_push(inventory.items, new_item);
		inv_weight = inventory_get_weight(self);
		actor_set_action_speed(self);
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
		inv_weight = inventory_get_weight(self);
		actor_set_action_speed(self);
		return(true);
	}
}


// INVENTORY WEIGHTS
function actor_set_action_speed(actor){
	
	with (actor){
		var modifier = 0;
		var total_weight = actor.inv_weight + actor.equ_weight;
	
		if (total_weight > actor.carry_weight){
			modifier = ((total_weight - actor.carry_weight) / actor.carry_weight) * 100;
		}
		action_speed = clamp(action_speed_base - modifier, 10, action_speed_base);
	}
}

function inventory_get_weight(actor){
	with (actor){
		var weight = 0;
		
		var len = array_length(inventory.items);
		for (var i = 0; i < len; i ++){
			weight += inventory.items[i].weight * inventory.items[i].stack;
		}
		
		return(weight);
	}
}

function equipment_get_weight(actor){
	var equ_weight = 0;
	
	with (actor){
		for (var category = 0; category < array_length(body_plan); category ++){
			for (var index = 0; index < array_length(body_plan[category]); index ++){
				for (var slot = 0; slot < array_length(body_plan[category][index]); slot ++){
					if (is_struct(body_plan[category][index][slot])){
						if (struct_exists(body_plan[category][index][slot], "weight")){
							if (!item_check_tag(body_plan[category][index][slot], TAG.NATURAL)){
								equ_weight += body_plan[category][index][slot].weight * body_plan[category][index][slot].stack;
							}
						}
					}
				}
			}
		}
	}
	
	return(equ_weight);
}


// EQUIPMENT INTERACTION
function equipment_add_item(actor, stack, item_struct, dest_cat, dest_ind, dest_slot){
	
	with (actor){
		var new_item = variable_clone(item_struct);
		new_item.stack = stack;
	
		if (body_plan[dest_cat][dest_ind][dest_slot] == noone){
			body_plan[dest_cat][dest_ind][dest_slot] = new_item;
		}
		else{
			var equipped_item_to_remove = variable_clone(body_plan[dest_cat][dest_ind][dest_slot]);
			body_plan[dest_cat][dest_ind][dest_slot] = new_item;
			inventory_add_item(actor, equipped_item_to_remove, equipped_item_to_remove.stack);
		}
		equ_weight = equipment_get_weight(self);
		actor_set_action_speed(self);
	}
}

function equipment_drop_slot(actor, stack, target_cat, target_ind, target_slot){
	
	with (actor){
		body_plan[target_cat][target_ind][target_slot].stack -= stack;
		if (body_plan[target_cat][target_ind][target_slot].stack <= 0){
			body_plan[target_cat][target_ind][target_slot] = noone;
		}
		equ_weight = equipment_get_weight(self);
		actor_set_action_speed(self);
	}
}


// CONTAINER INTERACTION
function container_add_item(actor, container){
	
	var item;
	var len_items = array_length(container.inventory);
	var max_items = container.inventory_max;
	
	if (len_items < max_items){
		item = variable_clone(actor.inventory.items[actor.inventory.inv_hover]);
		array_push(container.inventory, item);
		return(true);
	}
	return(false);
}

function container_take_item(actor, container){
	
	var item_to_take = variable_clone(container.inventory[container.inv_hover]);
	inventory_add_item(actor, item_to_take, item_to_take.stack);
	array_delete(container.inventory, container.inv_hover, 1);
}




