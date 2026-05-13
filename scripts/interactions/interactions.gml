
function tile_interaction(actor, x_pos, y_pos){			
	if (other.game_grid[x_pos][y_pos].tile_script != noone){
		other.game_grid[x_pos][y_pos].tile_script(self, x_pos, y_pos);
		
		return(true);
	}
	return(false);
}

function door_set_open(actor, x_pos, y_pos){
	cell_replace_tile(x_pos, y_pos, tile_open_door);
	
	// Create log entry
	var text = $"{actor.name} opens the door.";
	log_add_entry(text, c_ltgrey);
}

function door_set_close(actor, x_pos, y_pos){
	cell_replace_tile(x_pos, y_pos, tile_closed_door);
	
	// Create log entry
	var text = $"{actor.name} closes the door.";
	log_add_entry(text, c_ltgrey);
}




