
function action_move(grid, move_x, move_y){
	
	// Get target position
	var x_move, y_move;
	x_move = x_pos + move_x;
	y_move = y_pos + move_y;
	
	// Check game_grid for collision
	if (!grid[x_move][y_move].walkable) return(false);
	
	// Check actors for collision
	var len = array_length(other.actor_registry.actor_list);
	for (var i = 0; i < len; i ++){
		
		var actor_x = other.actor_registry.actor_list[i].x_pos;
		var actor_y = other.actor_registry.actor_list[i].y_pos;
		
		if (actor_x == x_move and actor_y == y_move){
			
			// Bump target actor
			
			
			return(false);
		}
	}
	
	// Move actor
	x_pos += move_x;
	y_pos += move_y;
	
	if (grid[x_pos][y_pos].tile == "closed door"){
		grid[x_pos][y_pos] = new tile_open_door();
	}
	return(true);
}