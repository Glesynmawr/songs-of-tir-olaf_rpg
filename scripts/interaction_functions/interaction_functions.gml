
function tile_interaction(actor, x_pos, y_pos){			
	if (other.game_grid[x_pos][y_pos].tile_script != noone){
		other.game_grid[x_pos][y_pos].tile_script(self, x_pos, y_pos);
		
		return(true);
	}
	return(false);
}

function door_set_open(actor, x_pos, y_pos){
	var text = "";
	
	cell_replace_tile(x_pos, y_pos, tile_door_open);
	
	// Create log entry
	text = $"{actor.name} opens the door.";
	log_add_entry(text, manager.colour_text_main);
}

function door_set_close(actor, x_pos, y_pos){
	
	if (actor.x_pos != x_pos or actor.y_pos != y_pos){
		cell_replace_tile(x_pos, y_pos, tile_door_closed);
	
		// Create log entry
		var text = $"{actor.name} closes the door.";
		log_add_entry(text, manager.colour_text_main);
	}
}

function found_a_secret(actor){
	if (actor == manager.actor_registry.player){
		var text = $"{actor.name} found a secret!";
		log_add_entry(text, c_aqua);
	}
}

function level_ascend(){
	log_add_entry("These are the stairs up.", manager.colour_text_main);
}

function level_descend(){
	log_add_entry("These are the stairs down.", manager.colour_text_main);
}




