/// @desc Game elements

if (game_state == game_state_dungeon) or (game_state == game_state_pause_menu and game_state_previous == game_state_dungeon){
	// Game layers
	game_draw_grid();
	
	if (game_paused){
		draw_pause_menu();
	}
	else{
		game_draw_direction_indicator();
	}
}
else if (game_state == game_state_world) or (game_state == game_state_pause_menu and game_state_previous == game_state_world){
	// Game layers
	game_draw_grid();
	
	if (game_paused){
		draw_pause_menu();
	}
	else{
		game_draw_direction_indicator();
	}
}




