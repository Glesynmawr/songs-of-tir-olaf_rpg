/// @desc Game elements

if (game_state == game_state_dungeon) or (game_state == game_state_pause_menu and game_state_previous == game_state_dungeon){
	actors_move_sprite();
	// Game layers
	game_draw_grid();
}
else if (game_state == game_state_world) or (game_state == game_state_pause_menu and game_state_previous == game_state_world){
	actors_move_sprite();
	// Game layers
	game_draw_grid();
}




