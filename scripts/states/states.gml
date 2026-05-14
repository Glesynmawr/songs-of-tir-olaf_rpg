
function state_ready_for_inputs(){
	var player_moved = false;
	
	if (keyboard_check_pressed(controls.key_inventory)){
		state = state_inventory;
		exit;
	}
	
	// Direction inputs
	var x_move = keyboard_check(controls.key_right) - keyboard_check(controls.key_left)
	var y_move = keyboard_check(controls.key_down) - keyboard_check(controls.key_up)
	
	var move_dir = input_direction(x_move, y_move);
	if (move_dir != noone){
		
		// Set manager direction indicator
		with (manager_obj) direction_indicator = move_dir;
		
		// Movement
		if (keyboard_check_pressed(controls.key_move_confirm)){
			var xx = manager_obj.cell_x_neighbours[move_dir];
			var yy = manager_obj.cell_y_neighbours[move_dir];
			action_move(manager_obj.game_grid, xx, yy);
			player_moved = true;
		}
		
		// Interaction
		if (keyboard_check_pressed(controls.key_interact_confirm)){
			{
				player_moved = tile_interaction(self, x_pos + x_move, y_pos + y_move);
			}
		}
	}
	else{
		if (manager_obj.direction_indicator != noone){
			manager_obj.direction_indicator = noone;
		}
		if (keyboard_check_pressed(controls.key_interact_confirm)){
			if (array_length(manager_obj.game_grid[x_pos][y_pos].items) > 0){
				pickup_menu_initialise(self);
			}
		}
		else if (keyboard_check_pressed(controls.key_move_confirm)){
			player_moved = tile_interaction(self, x_pos + x_move, y_pos + y_move);
		}
	}

	if (player_moved){
		// Set has-acted flag
		has_acted = true;
		
		// Update player LOS
		set_player_los(other.game_grid, self);
		
		// Update player distance map
		distance_map_player = create_distance_map(x_pos, y_pos);
	}
}

function state_inventory(){
	var len = array_length(inventory.items);
	
	if (keyboard_check_pressed(controls.key_inventory)){
		// Exit INVENTORY state
		state = state_ready_for_inputs;
	}
	else if (keyboard_check_pressed(controls.key_up)){
		// Move up inventory
		inventory.hover --;
		if (inventory.hover < 0){
			inventory.hover += len;
		}
	}
	else if (keyboard_check_pressed(controls.key_down)){
		// Move up inventory
		inventory.hover ++;
		if (inventory.hover >= len){
			inventory.hover -= len;
		}
	}
	else if (keyboard_check_pressed(controls.key_drop)){
		// Spawn item on ground
		spawn_existing_item(inventory.items[inventory.hover], 1, x_pos, y_pos);
		
		// DROP item
		inventory_drop_slot(self, inventory.hover, 1);
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
	if (distance_map_player[x_pos][y_pos] <= range) and (manager_obj.game_grid[x_pos][y_pos].is_visible == true){
		log_add_entry($"{name} has spotted {manager_obj.actor_registry.player.name}!", c_ltgrey);
		state = state_chase;
	}
	
	has_acted = true;
}

function state_chase(){
	
	// Find lowest distance value of neighbours
	var lowest_dist = 10000;
	for (var i = 0; i < 8; i ++){
		var target_x = x_pos + manager_obj.cell_x_neighbours[i];
		var target_y = y_pos + manager_obj.cell_y_neighbours[i];
		
		if (distance_map_player[target_x][target_y] < lowest_dist){
			lowest_dist = distance_map_player[target_x][target_y];
		}
	}
	
	// Make list of unoccupied neighbours with lowest value
	var candidate_list = [];
	for (i = 0; i < 8; i ++){
		var target_x = x_pos + manager_obj.cell_x_neighbours[i];
		var target_y = y_pos + manager_obj.cell_y_neighbours[i];
		
		if (distance_map_player[target_x][target_y] <= lowest_dist){
			array_push(candidate_list, [manager_obj.cell_x_neighbours[i], manager_obj.cell_y_neighbours[i]]);
		}
	}
	
	// Choose movement direction from candidate list
	var len = array_length(candidate_list);
	if (len > 0){
		var choice = irandom(len - 1);
		
		// execute move
		action_move(manager_obj.game_grid, candidate_list[choice][0], candidate_list[choice][1]);
	}
	
	has_acted = true;
}
