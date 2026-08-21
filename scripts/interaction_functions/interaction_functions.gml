
function tile_interaction(actor, x_pos, y_pos){			
	if (manager.game_grid[x_pos][y_pos].tile_script != noone){
		manager.game_grid[x_pos][y_pos].tile_script(self, x_pos, y_pos);
		
		return(true);
	}
	return(false);
}

function door_set_open(actor, x_pos, y_pos){
	
	cell_replace_tile(x_pos, y_pos, tile_door_open);
	manager.game_grid[x_pos][y_pos].index = manager.door_index;
	
	// Create log entry
	var text = $"{actor.name} opens the door.";
	log_add_entry(text, manager.colour_text_main);
}

function door_set_close(actor, x_pos, y_pos){
	
	if (actor.x_pos != x_pos or actor.y_pos != y_pos){
		
		cell_replace_tile(x_pos, y_pos, tile_door_closed);
		manager.game_grid[x_pos][y_pos].index = manager.door_index;
	
		// Create log entry
		var text = $"{actor.name} closes the door.";
		log_add_entry(text, manager.colour_text_main);
	}
}

function dungeon_enter(actor, x_pos, y_pos){
	
	with (manager){
		dungeon_entry_x = x_pos;
		dungeon_entry_y = y_pos;
		dungeon_index   = game_grid[x_pos][y_pos].index;
		dungeon_depth   = array_length(game_grid[x_pos][y_pos].dungeon_list);
		current_depth   = 0;
		
		// Create log entry
		var text = $"{actor.name} enters dungeon {dungeon_index} at x {dungeon_entry_x} and y {dungeon_entry_y}. It is {dungeon_depth} floors deep";
		log_add_entry(text, colour_text_main);
		
		transition_set(TRANSITION.GAME_DUNGEON_ENTER, C_BLACK);
	}
}

function found_a_secret(actor){
	if (actor == manager.actor_registry.player){
		var text = $"{actor.name} found a secret!";
		log_add_entry(text, c_aqua);
	}
}

function level_ascend(){
	
	with (manager){
		current_depth --;
	
		if (current_depth < 0){
			transition_set(TRANSITION.GAME_DUNGEON_EXIT, C_BLACK);
		}
		else{
			transition_set(TRANSITION.GAME_DUNGEON_PREV, C_BLACK);
		}
	
		// Create log entry
		var text = $"{actor_registry.player.name} exits dungeon {dungeon_index}";
		log_add_entry(text, colour_text_main);
	}
}

function level_descend(){
	
	with (manager){
		current_depth ++;
	
		transition_set(TRANSITION.GAME_DUNGEON_NEXT, C_BLACK);
	
		// Create log entry
		var text = $"{actor_registry.player.name} descends furthur in dungeon {dungeon_index}";
		log_add_entry(text, colour_text_main);
	}
}




