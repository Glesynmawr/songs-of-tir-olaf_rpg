
function state_ready_for_inputs(){
	var player_moved = false;
	
	if (keyboard_check_pressed(controls.key_cancel)){
		with (manager){
			pause_menu_hover = 0;
			game_state_previous = game_state;
			game_state = game_state_pause_menu;
			exit;
		}
	}
	
	if (keyboard_check_pressed(controls.key_inventory) and manager.game_state != game_state_world){
		state = state_inventory;
		exit;
	}
	
	// Direction inputs
	var x_move = keyboard_check(controls.key_right) - keyboard_check(controls.key_left)
	var y_move = keyboard_check(controls.key_down) - keyboard_check(controls.key_up)
	
	var move_dir = input_direction(x_move, y_move);
	if (move_dir != noone){
		
		// Set manager direction indicator
		with (manager) direction_indicator = move_dir;
		
		// Movement
		if (keyboard_check(controls.key_move_confirm)){
				if (manager.move_timer <= 0){
				var xx = manager.cell_x_neighbours[move_dir];
				var yy = manager.cell_y_neighbours[move_dir];
				player_moved = action_move(manager.game_grid, xx, yy);
				manager.move_timer = manager.move_timer_max;
			}
			else {
				manager.move_timer --;
			}
		}
		else{
			with (manager){
				if (move_timer != 0){
					move_timer = 0;
				}
			}
		}
		
		// Interaction
		if (keyboard_check_pressed(controls.key_interact_confirm)){
			if (manager.game_grid[x_pos + x_move][y_pos + y_move].tile == "secret door"){
				found_a_secret(self);
			}
			player_moved = tile_interaction(self, x_pos + x_move, y_pos + y_move);
		}
	}
	else{
		
		// Reset direction indicator
		with (manager){
			if (direction_indicator != noone) direction_indicator = noone;
		}
		
		if (keyboard_check_pressed(controls.key_interact_confirm)){
			
			if (struct_exists(manager.game_grid[x_pos][y_pos], "items")){
				if (array_length(manager.game_grid[x_pos][y_pos].items) > 0){
					pickup_menu_initialise(self);
				}
			}
		}
		else if (keyboard_check_pressed(controls.key_move_confirm)){
			if (manager.game_grid == manager.world_map){
				with(manager){
					transition_set(TRANSITION.GAME_ZONE, colour_bg_main);
				}
			}
			else if (manager.game_grid == manager.zone_map[world_x][world_y]){
				with(manager){
					transition_set(TRANSITION.GAME_WORLD, colour_bg_main);
				}
			}
			else player_moved = tile_interaction(self, x_pos + x_move, y_pos + y_move);
		}
	}

	if (player_moved){
		// Set has-acted flag
		has_acted = true;
		
		// Update world position
		if (manager.map_mode == MAP_MODE.WORLD){
			world_x = x_pos;
			world_y = y_pos;
		}
		
		// Check for map edge in zone mode
		if (manager.map_mode ==	MAP_MODE.ZONE){
			if (x_pos == 0){
				if (world_x > 0){
					
					// Reset visibility on current map
					grid_set_visible(manager.game_grid, false)
					
					// Move world grid position
					world_x --;
					
					// Set game_grid to new zone
					goto_zone(world_x, world_y, ZONE_SIZE - 2, y_pos);
				}
			}
			else if (x_pos == ZONE_SIZE - 1){
				if (world_x < array_length(manager.world_map) - 1){
					
					// Reset visibility on current map
					grid_set_visible(manager.game_grid, false)
					
					// Move world grid position
					world_x ++;
					
					// Set game_grid to new zone
					goto_zone(world_x, world_y, 1, y_pos);
				}
			}
			if (y_pos == 0){
				if (world_y > 0){

					// Reset visibility on current map
					grid_set_visible(manager.game_grid, false)
					
					// Move world grid position
					world_y --;
					
					// Set game_grid to new zone
					goto_zone(world_x, world_y, x_pos, ZONE_SIZE - 2);
				}
			}
			else if (y_pos == ZONE_SIZE - 1){
				if (world_y < array_length(manager.world_map[0]) - 1){
					
					// Reset visibility on current map
					grid_set_visible(manager.game_grid, false)
					
					// Move world grid position
					world_y ++;
					
					// Set game_grid to new zone
					goto_zone(world_x, world_y, x_pos, 1);
				}
			}
		}
		
		// Update player LOS
		set_player_los(other.game_grid, self);
		
		// Update player distance map
		distance_map_player = create_distance_map(manager.game_grid, x_pos, y_pos);
	}
}

function state_inventory(){
	var len, slots;
	
	if (keyboard_check_pressed(controls.key_right)) inventory.selected ++;
	if (keyboard_check_pressed(controls.key_left))  inventory.selected --;
	inventory.selected = clamp(inventory.selected, 0, 1);
	
	if (inventory.selected == 1){
		len = array_length(inventory.items);
		
		if (keyboard_check_pressed(controls.key_inventory) or keyboard_check_pressed(controls.key_cancel)){
			// Exit INVENTORY state
			state = state_ready_for_inputs;
		}
		else if (keyboard_check_pressed(controls.key_up)){
			// Move up inventory
			inventory.inv_hover --;
			if (inventory.inv_hover < 0){
				inventory.inv_hover += len;
			}
		}
		else if (keyboard_check_pressed(controls.key_down)){
			// Move down inventory
			inventory.inv_hover ++;
			if (inventory.inv_hover >= len){
				inventory.inv_hover -= len;
			}
		}
		else if (keyboard_check_pressed(controls.key_interact_confirm)){
			if (len > 0 and inventory.context_menu == noone){
				context_menu_initialise();
			}
		}
	}
	else {
		len = array_length(inventory.equipment);
		
		if (keyboard_check_pressed(controls.key_inventory) or keyboard_check_pressed(controls.key_cancel)){
			// Exit INVENTORY state
			state = state_ready_for_inputs;
		}
		else if (keyboard_check_pressed(controls.key_up)){
			// Move up equipment
			
			inventory.equ_hover[1] --;
			if (inventory.equ_hover[1] < 0){
				inventory.equ_hover[0] --;
				if (inventory.equ_hover[0] < 0){
					inventory.equ_hover[0] += len;
				}
				slots = array_length(inventory.equipment[inventory.equ_hover[0]]);
				inventory.equ_hover[1] += slots;
			}
			
		}
		else if (keyboard_check_pressed(controls.key_down)){
			slots = array_length(inventory.equipment[inventory.equ_hover[0]]);
			
			// Move down equipment
			inventory.equ_hover[1] ++;
			if (inventory.equ_hover[1] >= slots){
				inventory.equ_hover[0] ++;
				if (inventory.equ_hover[0] >= len){
					inventory.equ_hover[0] -= len;
				}
				inventory.equ_hover[1] = 0;
			}
		}
		else if (keyboard_check_pressed(controls.key_interact_confirm)){
			if (is_struct(inventory.equipment[inventory.equ_hover[0]][inventory.equ_hover[1]])){
				if (inventory.context_menu == noone){
					context_menu_initialise();
				}
			}
		}
	}
}

function state_context_menu(){
	var len = array_length(inventory.context_menu[0]);
	
	if (keyboard_check_pressed(controls.key_cancel)){
		
		// Exit context menu
		inventory.context_menu = noone;
		state = state_inventory;
	}
	else if (keyboard_check_pressed(controls.key_up)){
		inventory.context_menu[5] --;
		if (inventory.context_menu[5] < 0){
			inventory.context_menu[5] += len;
		}
	}
	else if (keyboard_check_pressed(controls.key_down)){
		inventory.context_menu[5] ++;
		if (inventory.context_menu[5] >= len){
			inventory.context_menu[5] -= len;
		}
	}
	else if (keyboard_check_pressed(controls.key_interact_confirm)){
		
		// Inventory or equipment
		if (inventory.context_menu[0][inventory.context_menu[5]] == "Drop"){
			if (inventory.selected == 0){
				var type = inventory.equ_hover[0];
				var slot = inventory.equ_hover[1];
				spawn_existing_item(inventory.equipment[type][slot], 1, x_pos, y_pos);
				
				equipment_drop_slot(self, type, slot);
			}
			else if (inventory.selected == 1){
				
				// Spawn item on ground
				spawn_existing_item(inventory.items[inventory.inv_hover], 1, x_pos, y_pos);
		
				// DROP item
				inventory_drop_slot(self, inventory.inv_hover, 1);
			}
			// Exit context menu
			inventory.context_menu = noone;
			state = state_inventory;
		}
		else if (inventory.context_menu[0][inventory.context_menu[5]] == "Equip"){
			
			var item_to_equip = variable_clone(inventory.items[inventory.inv_hover]);
			var target_type = item_to_equip.slot[0];
			if (array_length(inventory.equipment[target_type]) > 1){
				// Enter slot selection state
				inventory.context_menu = noone;
				inventory.slot_selection = [target_type, 0];	
				state = state_slot_selection;
			}
			else{
				// Equip item
				inventory_drop_slot(self, inventory.inv_hover, 1);
				equipment_add_item(self, item_to_equip, target_type, 0);
			
				// Exit context menu
				inventory.context_menu = noone;
				state = state_inventory;
			}
		}
		else if (inventory.context_menu[0][inventory.context_menu[5]] == "Remove"){
			// Equipment only
			var item_to_remove = variable_clone(inventory.equipment[inventory.equ_hover[0]][inventory.equ_hover[1]]);
			equipment_drop_slot(self, inventory.equ_hover[0], inventory.equ_hover[1]);
			if (is_struct(item_to_remove)){
				inventory_add_item(self, item_to_remove);
			}
			
			// Exit context menu
			inventory.context_menu = noone;
			state = state_inventory;
		}
	}
}

function state_slot_selection(){
	var len = array_length(inventory.equipment[inventory.slot_selection[0]]);
	if (keyboard_check_pressed(controls.key_cancel)){
		
		// Exit slot select state
		inventory.slot_selection = noone;
		state = state_inventory;
	}
	if (keyboard_check_pressed(controls.key_up)){
		inventory.slot_selection[1] --;
		if (inventory.slot_selection[1] < 0){
			inventory.slot_selection[1] += len;
		}
	}
	if (keyboard_check_pressed(controls.key_down)){
		inventory.slot_selection[1] ++;
		if (inventory.slot_selection[1] >= len){
			inventory.slot_selection[1] -= len;
		}
	}
	if (keyboard_check_pressed(controls.key_interact_confirm)){
		var type = inventory.slot_selection[0];
		var slot = inventory.slot_selection[1];
		var item_to_copy = variable_clone(inventory.items[inventory.inv_hover]);
		equipment_add_item(self, item_to_copy, type, slot);
		inventory_drop_slot(self, inventory.inv_hover, 1);
		
		// Exit slot select state
		inventory.slot_selection = noone;
		state = state_inventory;
	}
}

function state_pickup(){
	var len = array_length(pickup_menu);
	if (keyboard_check_pressed(controls.key_cancel)){
		state = state_ready_for_inputs;
	}
	else if (keyboard_check_pressed(controls.key_up)){
		pickup_hover --;
		if (pickup_hover < 0) pickup_hover += len;
	}
	else if (keyboard_check_pressed(controls.key_down)){
		pickup_hover ++;
		if (pickup_hover >= len) pickup_hover -= len;
	}
	else if (keyboard_check_pressed(controls.key_interact_confirm)){
		// Add item to inventory and remove from menu
		inventory_add_item(self, pickup_menu[pickup_hover]);
		
		// Find item on ground and delete it
		var ind = array_get_index(manager.game_grid[x_pos][y_pos].items, pickup_menu[pickup_hover]);
		array_delete(manager.game_grid[x_pos][y_pos].items, ind, 1);
		
		// Delete item from pickup menu
		array_delete(pickup_menu, pickup_hover, 1);
		
		// Reset menu length
		len = array_length(pickup_menu);
		if (len <= 0){
			state = state_ready_for_inputs;
		}
		if (pickup_hover >= len) pickup_hover --;
	}
}

function state_idle(){
	// Check if player is in range and visible
	if (distance_map_player[x_pos][y_pos] <= range) and (manager.game_grid[x_pos][y_pos].is_visible == true){
		log_add_entry($"{name} has spotted {manager.actor_registry.player.name}!", manager.colour_text_main);
		
		switch(demeanour){
			case DEMEANOUR.AGGRESSIVE: state = state_chase; break;
			case DEMEANOUR.TIMID:      state = state_flee;  break;
		}
		
	}
	
	has_acted = true;
}

function state_chase(){
	
	// Find lowest distance value of neighbours
	var lowest_dist = 10000;
	for (var i = 0; i < 8; i ++){
		var target_x = x_pos + manager.cell_x_neighbours[i];
		var target_y = y_pos + manager.cell_y_neighbours[i];
		
		if (grid_check_position_in_bounds(manager.game_grid, target_x, target_y)){
			if (distance_map_player[target_x][target_y] < lowest_dist){
				lowest_dist = distance_map_player[target_x][target_y];
			}
		}
	}
	
	// Make list of unoccupied neighbours with lowest value
	var candidate_list = [];
	for (i = 0; i < 8; i ++){
		var target_x = x_pos + manager.cell_x_neighbours[i];
		var target_y = y_pos + manager.cell_y_neighbours[i];
		
		if (grid_check_position_in_bounds(manager.game_grid, target_x, target_y)){
			if (distance_map_player[target_x][target_y] <= lowest_dist){
				array_push(candidate_list, [manager.cell_x_neighbours[i], manager.cell_y_neighbours[i]]);
			}
		}
	}
	
	// Choose movement direction from candidate list
	var len = array_length(candidate_list);
	if (len > 0){
		var choice = irandom(len - 1);
		
		// execute move
		action_move(manager.game_grid, candidate_list[choice][0], candidate_list[choice][1]);
	}
	
	has_acted = true;
}

function state_flee(){
		
	// Find lowest distance value of neighbours
	var highest_dist = 0;
	for (var i = 0; i < 8; i ++){
		var target_x = x_pos + manager.cell_x_neighbours[i];
		var target_y = y_pos + manager.cell_y_neighbours[i];
		
		if (grid_check_position_in_bounds(manager.game_grid, target_x, target_y)){
			if (distance_map_player[target_x][target_y] > highest_dist){
				highest_dist = distance_map_player[target_x][target_y];
			}
		}
		else {
			has_acted = true;
			action_remove_actor(self);
			exit;
		}
	}
	
	// Make list of unoccupied neighbours with lowest value
	var candidate_list = [];
	for (i = 0; i < 8; i ++){
		var target_x = x_pos + manager.cell_x_neighbours[i];
		var target_y = y_pos + manager.cell_y_neighbours[i];
		
		if (grid_check_position_in_bounds(manager.game_grid, target_x, target_y)){
			if (distance_map_player[target_x][target_y] >= highest_dist){
				array_push(candidate_list, [manager.cell_x_neighbours[i], manager.cell_y_neighbours[i]]);
			}
		}
	}
	
	// Choose movement direction from candidate list
	var len = array_length(candidate_list);
	if (len > 0){
		var choice = irandom(len - 1);
		
		// Execute move
		action_move(manager.game_grid, candidate_list[choice][0], candidate_list[choice][1]);
	}
	
	has_acted = true;
}




