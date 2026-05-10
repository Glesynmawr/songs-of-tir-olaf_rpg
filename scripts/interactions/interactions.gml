function door_set_open(x_pos, y_pos){
	var vis = other.game_grid[x_pos][y_pos].is_visible;
	var ex  = other.game_grid[x_pos][y_pos].explored;
	
	other.game_grid[x_pos][y_pos] = new tile_open_door();
	
	other.game_grid[x_pos][y_pos].is_visible = vis;
	other.game_grid[x_pos][y_pos].explored   = ex;
}

function door_set_close(x_pos, y_pos){
	var vis = other.game_grid[x_pos][y_pos].is_visible;
	var ex  = other.game_grid[x_pos][y_pos].explored;
	
	other.game_grid[x_pos][y_pos] = new tile_closed_door();
	
	other.game_grid[x_pos][y_pos].is_visible = vis;
	other.game_grid[x_pos][y_pos].explored   = ex;
}




