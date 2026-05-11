
function state_ready_for_inputs(){
	var player_moved = false;

	for (var key = 0; key < array_length(control_key); key ++){
		if (keyboard_check_pressed(control_key[key])){
			
			// Enter MOVEMENT state
			if (key < 8){
				var move_x = other.cell_x_neighbours[key];
				var move_y = other.cell_y_neighbours[key];
		
				action_move(other.game_grid,  move_x,  move_y);
				player_moved = true;
			}
			// Enter INTERACTION state
			if (key == 8){
				state = state_interaction;
			}
		}
	}

	if (player_moved){
		set_player_los(other.game_grid, self);
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
		set_player_los(other.game_grid, self);
	}
}

function state_idle(){
	// Do nothing
}


