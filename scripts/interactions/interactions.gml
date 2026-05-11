
function door_set_open(actor, x_pos, y_pos){
	var vis = other.game_grid[x_pos][y_pos].is_visible;
	var ex  = other.game_grid[x_pos][y_pos].explored;
	
	other.game_grid[x_pos][y_pos] = new tile_open_door();
	
	other.game_grid[x_pos][y_pos].is_visible = vis;
	other.game_grid[x_pos][y_pos].explored   = ex;
	
	// Create log entry
	var text = $"{actor.name} opens the door.";
	log_add_entry(text, c_ltgrey);
}

function door_set_close(actor, x_pos, y_pos){
	var vis = other.game_grid[x_pos][y_pos].is_visible;
	var ex  = other.game_grid[x_pos][y_pos].explored;
	
	other.game_grid[x_pos][y_pos] = new tile_closed_door();
	
	other.game_grid[x_pos][y_pos].is_visible = vis;
	other.game_grid[x_pos][y_pos].explored   = ex;
	
	// Create log entry
	var text = $"{actor.name} closes the door.";
	log_add_entry(text, c_ltgrey);
}




