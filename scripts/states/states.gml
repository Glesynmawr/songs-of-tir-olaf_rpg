
function state_ready_for_inputs(){
	var player_moved = false;

	for (var key = 0; key < array_length(control_key); key ++){
		if (keyboard_check_pressed(control_key[key])){
			
			// Enter MOVEMENT state
			if (key < 8){
				var move_x = other.cell_x_neighbours[key];
				var move_y = other.cell_y_neighbours[key];
		
				if (action_move(other.game_grid,  move_x,  move_y)){
					player_moved = true;
				}
			}
			// Enter INTERACTION state
			if (key == 8){
				state = state_interaction;
			}
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

function state_interaction(){
	var player_moved = false;
	
	for (var key = 0; key < array_length(control_key); key ++){
		if (keyboard_check_pressed(control_key[key])){
			
			// Interact with neighbour tiles
			if (key < 8){
				
				var interact_x = x_pos + other.cell_x_neighbours[key];
				var interact_y = y_pos + other.cell_y_neighbours[key];
				
				if (other.game_grid[interact_x][interact_y].tile_script != noone){
					other.game_grid[interact_x][interact_y].tile_script(self, interact_x, interact_y);
					
					player_moved = true;
				}
			}
			
			// Exit INTERACTION state
			if (key == 8){
				state = state_ready_for_inputs;
			}
		}
	}
	if (player_moved){
		// Set has-acted flag
		has_acted = true;
		
		// Update player LOS
		set_player_los(other.game_grid, self);
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
