/// @desc Game elements

draw_clear(colour_bg_main);

if (game_state.state_main == game_state_dungeon) or (game_state.state_main == game_state_pause_menu and game_state.state_previous == game_state_dungeon){
	actors_move_sprite();
	// Game layers
	game_draw_grid();
}
else if (game_state.state_main == game_state_world) or (game_state.state_main == game_state_pause_menu and game_state.state_previous == game_state_world){
	actors_move_sprite();
	// Game layers
	game_draw_grid();
}




