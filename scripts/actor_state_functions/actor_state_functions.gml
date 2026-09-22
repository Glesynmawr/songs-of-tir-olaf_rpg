
function state_ready_for_inputs(){
	var player_moved = false;
	
	if (keyboard_check_pressed(controls.key_cancel)){
		with (manager){
			pause_menu_hover = 0;
			game_state.state_previous = game_state.state_main;
			game_state.state_main = game_state_pause_menu;
			exit;
		}
	}
	
	if (keyboard_check_pressed(controls.key_inventory) and manager.game_state.state_main != game_state_world){
		state = state_inventory;
		exit;
	}
	
	// Direction inputs
	var x_move = keyboard_check(controls.key_right) - keyboard_check(controls.key_left)
	var y_move = keyboard_check(controls.key_down) - keyboard_check(controls.key_up)
	
	var move_dir = input_direction(x_move, y_move);
	if (move_dir != noone){
		
		// Set manager direction indicator
		with (manager) game_state.direction_indicator = move_dir;
		
		// Movement
		if (keyboard_check(controls.key_move_confirm)){
				if (manager.move_timer <= 0){
				var xx = manager.cell_x_neighbours[move_dir];
				var yy = manager.cell_y_neighbours[move_dir];
				player_moved = action_move(manager.game_state.game_grid, xx, yy);
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
		
		// Interaction with tile in direction
		if (keyboard_check_pressed(controls.key_interact_confirm)){
			if (manager.game_state.game_grid[x_pos + x_move][y_pos + y_move].tile == "secret door"){
				found_a_secret(self);
			}
			player_moved = tile_interaction(self, x_pos + x_move, y_pos + y_move);
		}
	}
	else{
		
		// Reset direction indicator
		with (manager){
			if (game_state.direction_indicator != noone) game_state.direction_indicator = noone;
		}
		
		// Interaction with tile no direction
		if (keyboard_check_pressed(controls.key_interact_confirm)){
			
			// Pickup items
			var items_exist = false;
			if (struct_exists(manager.game_state.game_grid[x_pos][y_pos], "items")){
				if (array_length(manager.game_state.game_grid[x_pos][y_pos].items) > 0){
					items_exist = true;
					pickup_menu_initialise(self);
				}
			}
			if (!items_exist){
				
				// Interact with tile
				player_moved = tile_interaction(self, x_pos, y_pos);
			}
		}
		// TOGGLE WORLD MAP
		else if (keyboard_check_pressed(controls.key_map_mode)){
			if (array_length(manager.actor_registry.actor_list) == 1){
				if (manager.game_state.game_grid == manager.game_state.world_map){
					with(manager){
						transition_set(TRANSITION.GAME_ZONE, colour_bg_main);
					}
				}
				else if (manager.game_state.game_grid == manager.game_state.zone_map[world_x][world_y]){
					with(manager){
						transition_set(TRANSITION.GAME_WORLD, colour_bg_main);
					}
				}
			}
			else{
				player_moved = true;
				var txt = $"{self.name} can't leave with hostiles present!";
				log_add_entry(txt, manager.colour_text_main);
			}
		}
		else if (keyboard_check_pressed(controls.key_item_swap)){
			player_swap_items();
		}
	}

	if (player_moved){
		
		// Increment player turn counter
		 manager.time_system.current_turn += 1;
		
		// Set has-acted flag
		has_acted = true;
		
		// Update world position
		if (manager.game_state.map_mode == MAP_MODE.WORLD){
			world_x = x_pos;
			world_y = y_pos;
		}
		
		// Check for map edge in zone mode
		if (manager.game_state.map_mode ==	MAP_MODE.ZONE){
			if (x_pos == 0){
				if (world_x > 0){
					
					// Reset visibility on current map
					grid_set_visible(manager.game_state.game_grid, false)
					
					// Move world grid position
					world_x --;
					
					// Set game_state.game_grid to new zone
					goto_zone(world_x, world_y, ZONE_SIZE - 2, y_pos);
				}
			}
			else if (x_pos == ZONE_SIZE - 1){
				if (world_x < array_length(manager.game_state.world_map) - 1){
					
					// Reset visibility on current map
					grid_set_visible(manager.game_state.game_grid, false)
					
					// Move world grid position
					world_x ++;
					
					// Set game_state.game_grid to new zone
					goto_zone(world_x, world_y, 1, y_pos);
				}
			}
			if (y_pos == 0){
				if (world_y > 0){

					// Reset visibility on current map
					grid_set_visible(manager.game_state.game_grid, false)
					
					// Move world grid position
					world_y --;
					
					// Set game_state.game_grid to new zone
					goto_zone(world_x, world_y, x_pos, ZONE_SIZE - 2);
				}
			}
			else if (y_pos == ZONE_SIZE - 1){
				if (world_y < array_length(manager.game_state.world_map[0]) - 1){
					
					// Reset visibility on current map
					grid_set_visible(manager.game_state.game_grid, false)
					
					// Move world grid position
					world_y ++;
					
					// Set game_state.game_grid to new zone
					goto_zone(world_x, world_y, x_pos, 1);
				}
			}
		}
		
		// Update player LOS
		set_player_los(other.game_state.game_grid, self);
		
		// Update player distance map
		distance_map_player = create_distance_map(manager.game_state.game_grid, x_pos, y_pos);
	}
}

function state_inventory(){
	var len;
	
	// Toggle between inventory/equipment
	if (keyboard_check_pressed(controls.key_inventory)) inventory.selected = !inventory.selected;
	
	// Exit inventory state
	if (keyboard_check_pressed(controls.key_cancel))    state = state_ready_for_inputs;

	if (inventory.selected == 1){
		len = array_length(inventory.items);
		
		if (keyboard_check_pressed(controls.key_cancel)){
			// Exit INVENTORY state
			state = state_ready_for_inputs;
		}
		else if (keyboard_check(controls.key_up)){
			manager.move_timer --;
			if (manager.move_timer <= 0){
				// Move up inventory
				inventory.inv_hover --;
				if (inventory.inv_hover < 0){
					inventory.inv_hover += len;
				}
				manager.move_timer = manager.move_timer_max;
			}
		}    
		else if (keyboard_check(controls.key_down)){
			manager.move_timer --;
			if (manager.move_timer <= 0){
				// Move down inventory
				inventory.inv_hover ++;
				if (inventory.inv_hover >= len){
					inventory.inv_hover -= len;
				}
				manager.move_timer = manager.move_timer_max;
			}
		}
		else if (keyboard_check_pressed(controls.key_interact_confirm)){
			if (len > 0 and inventory.context_menu == noone){
				context_menu_initialise();
			}
		}
		else{
			if (manager.move_timer != 0){
				manager.move_timer = 0;
			}
		}
	}
	else {
		if (keyboard_check_pressed(controls.key_up)){
			// Move up inventory
			var slot_relative_position = BODY_PART_STATS.PART_AUX_SLOT + (array_length(body_plan[inventory.equ_hover[0]][inventory.equ_hover[1]]) - inventory.equ_hover[2]);
			var prev_slot = body_part_find_prev_exists(self, inventory.equ_hover[0], inventory.equ_hover[1])
			if (prev_slot != noone){
				inventory.equ_hover[0] = prev_slot[0];
				inventory.equ_hover[1] = prev_slot[1];
				
				var new_slot_relative_position = BODY_PART_STATS.PART_AUX_SLOT + (array_length(body_plan[inventory.equ_hover[0]][inventory.equ_hover[1]]) - inventory.equ_hover[2]);
				if (new_slot_relative_position != slot_relative_position){
					inventory.equ_hover[2] += new_slot_relative_position - slot_relative_position;
				}
				
				var min_slot = body_part_find_min_slot(self, inventory.equ_hover[0], inventory.equ_hover[1])
				if (inventory.equ_hover[2] < min_slot) inventory.equ_hover[2] = min_slot;
				
				var max_slot = array_length(body_plan[inventory.equ_hover[0]][inventory.equ_hover[1]]) - 1;
				if (inventory.equ_hover[2] > max_slot){
					inventory.equ_hover[2] = max_slot
				}
			}
		}
		else if (keyboard_check_pressed(controls.key_down)){
			// Move down inventory
			var slot_relative_position = BODY_PART_STATS.PART_AUX_SLOT + (array_length(body_plan[inventory.equ_hover[0]][inventory.equ_hover[1]]) - inventory.equ_hover[2]);
			var next_slot = body_part_find_next_exists(self, inventory.equ_hover[0], inventory.equ_hover[1])
			if (next_slot != noone){
				inventory.equ_hover[0] = next_slot[0];
				inventory.equ_hover[1] = next_slot[1];

				var new_slot_relative_position = BODY_PART_STATS.PART_AUX_SLOT + (array_length(body_plan[inventory.equ_hover[0]][inventory.equ_hover[1]]) - inventory.equ_hover[2]);
				if (new_slot_relative_position != slot_relative_position){
					inventory.equ_hover[2] += new_slot_relative_position - slot_relative_position;
				}
				
				var min_slot = body_part_find_min_slot(self, inventory.equ_hover[0], inventory.equ_hover[1])
				if (inventory.equ_hover[2] < min_slot) inventory.equ_hover[2] = min_slot;
				
				var max_slot = array_length(body_plan[inventory.equ_hover[0]][inventory.equ_hover[1]]) - 1;
				if (inventory.equ_hover[2] > max_slot){
					inventory.equ_hover[2] = max_slot
				}
			}
		}
		else if (keyboard_check_pressed(controls.key_right)){
			var max_slot = array_length(body_plan[inventory.equ_hover[0]][inventory.equ_hover[1]]);
			var min_slot = body_part_find_min_slot(self, inventory.equ_hover[0], inventory.equ_hover[1])
			
			inventory.equ_hover[2] --;
			if (inventory.equ_hover[2] < min_slot){
				inventory.equ_hover[2] = max_slot - 1;
			}
		}
		else if (keyboard_check_pressed(controls.key_left)){
			var max_slot = array_length(body_plan[inventory.equ_hover[0]][inventory.equ_hover[1]]);
			var min_slot = body_part_find_min_slot(self, inventory.equ_hover[0], inventory.equ_hover[1])
			
			inventory.equ_hover[2] ++;
			if (inventory.equ_hover[2] >= max_slot){
				inventory.equ_hover[2] = min_slot;
			}
		}
		else if (keyboard_check_pressed(controls.key_interact_confirm)){
			if (inventory.context_menu == noone){
				equipment_context_menu_initialise();
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
			
			var number_to_drop = 1;
			if (inventory.selected == 1){
				
				// Spawn item on ground
				spawn_existing_item(inventory.items[inventory.inv_hover], number_to_drop, x_pos, y_pos);
		
				// DROP item
				inventory_drop_slot(self, inventory.inv_hover, 1);
			}
			else{
				var target_cat     = inventory.equ_hover[0];
				var target_ind     = inventory.equ_hover[1];
				var target_slot    = inventory.equ_hover[2];
				
				var item_to_move = variable_clone(body_plan[target_cat][target_ind][target_slot]);
				
				spawn_existing_item(item_to_move, , x_pos, y_pos);
				equipment_drop_slot(self, number_to_drop, target_cat, target_ind, target_slot)
			}
			// Exit context menu
			inventory.context_menu = noone;
			state = state_inventory;
		}
		else if (inventory.context_menu[0][inventory.context_menu[5]] == "Drop All"){
			
			var number_to_drop = inventory.items[inventory.inv_hover].stack;
			if (inventory.selected == 1){
				
				// Spawn item on ground
				spawn_existing_item(inventory.items[inventory.inv_hover], number_to_drop, x_pos, y_pos);
		
				// DROP item
				inventory_drop_slot(self, inventory.inv_hover, number_to_drop);
			}
			else{
				var target_cat     = inventory.equ_hover[0];
				var target_ind     = inventory.equ_hover[1];
				var target_slot    = inventory.equ_hover[2];
				
				var item_to_move = variable_clone(body_plan[target_cat][target_ind][target_slot]);
				
				spawn_existing_item(item_to_move, number_to_drop, x_pos, y_pos);
				equipment_drop_slot(self, number_to_drop, target_cat, target_ind, target_slot)
			}
			// Exit context menu
			inventory.context_menu = noone;
			state = state_inventory;
		}
		else if (inventory.context_menu[0][inventory.context_menu[5]] == "Equip"){
			
			// Initialise slot select menu
			equipment_slot_select_initialise();
		}
		else if (inventory.context_menu[0][inventory.context_menu[5]] == "Remove"){
			// Equipment only
			var target_cat     = inventory.equ_hover[0];
			var target_ind     = inventory.equ_hover[1];
			var target_slot    = inventory.equ_hover[2];
				
			var item_to_move = variable_clone(body_plan[target_cat][target_ind][target_slot]);
			
			inventory_add_item(self, item_to_move, item_to_move.stack);
			body_plan[target_cat][target_ind][target_slot] = noone;
			
			// Exit context menu
			inventory.context_menu = noone;
			state = state_inventory;
		}
		else if (inventory.context_menu[0][inventory.context_menu[5]] == "Hold"){
			// Initialise slot select menu
			hold_slot_select_initialise();
		}
	}
}

function state_slot_selection(){
	var len = array_length(inventory.slot_select_menu[0]);
	
	if (keyboard_check_pressed(controls.key_cancel)){
		
		// Exit context menu
		inventory.slot_select_menu = noone;
		state = state_context_menu;
	}
	else if (keyboard_check_pressed(controls.key_up)){
		inventory.slot_select_menu[5] --;
		if (inventory.slot_select_menu[5] < 0){
			inventory.slot_select_menu[5] += len;
		}
	}
	else if (keyboard_check_pressed(controls.key_down)){
		inventory.slot_select_menu[5] ++;
		if (inventory.slot_select_menu[5] >= len){
			inventory.slot_select_menu[5] -= len;
		}
	}
	else if (keyboard_check_pressed(controls.key_interact_confirm)){
		var menu_hover   = inventory.slot_select_menu[5];
		var number_to_move = 1;
		if (struct_exists(inventory.items[inventory.inv_hover], "tags")){
			if (item_check_tag(inventory.items[inventory.inv_hover], TAG.IS_AMMO)){
				number_to_move = inventory.items[inventory.inv_hover].stack;
			}
		}
		
		var item_to_move = variable_clone(inventory.items[inventory.inv_hover]);
		var dest_cat     = inventory.slot_select_menu[0][menu_hover][1];
		var dest_ind     = inventory.slot_select_menu[0][menu_hover][2];
		var dest_slot    = inventory.slot_select_menu[0][menu_hover][3];
		
		equipment_add_item(self, number_to_move, item_to_move, dest_cat, dest_ind, dest_slot)
		inventory_drop_slot(self, inventory.inv_hover, number_to_move);
		
		inventory.context_menu		= noone;
		inventory.slot_select_menu	= noone;
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
		inventory_add_item(self, pickup_menu[pickup_hover], pickup_menu[pickup_hover].stack);
		
		// Find item on ground and delete it
		var ind = array_get_index(manager.game_state.game_grid[x_pos][y_pos].items, pickup_menu[pickup_hover]);
		array_delete(manager.game_state.game_grid[x_pos][y_pos].items, ind, 1);
		
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
	if (distance_map_player[x_pos][y_pos] <= range) and (manager.game_state.game_grid[x_pos][y_pos].is_visible == true){
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
		
		if (grid_check_position_in_bounds(manager.game_state.game_grid, target_x, target_y)){
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
		
		if (grid_check_position_in_bounds(manager.game_state.game_grid, target_x, target_y)){
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
		action_move(manager.game_state.game_grid, candidate_list[choice][0], candidate_list[choice][1]);
	}
	
	has_acted = true;
}

function state_flee(){
		
	// Find lowest distance value of neighbours
	var highest_dist = 0;
	for (var i = 0; i < 8; i ++){
		var target_x = x_pos + manager.cell_x_neighbours[i];
		var target_y = y_pos + manager.cell_y_neighbours[i];
		
		if (grid_check_position_in_bounds(manager.game_state.game_grid, target_x, target_y)){
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
		
		if (grid_check_position_in_bounds(manager.game_state.game_grid, target_x, target_y)){
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
		action_move(manager.game_state.game_grid, candidate_list[choice][0], candidate_list[choice][1]);
	}
	
	has_acted = true;
}




