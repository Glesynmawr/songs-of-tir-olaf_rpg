/// @desc Game elements

if (game_state == game_state_dungeon) or (game_state == game_state_pause_menu and game_state_previous == game_state_dungeon){
	draw_dungeon();
}
else if (game_state == game_state_world) or (game_state == game_state_pause_menu and game_state_previous == game_state_world){
	draw_world_grid(world_grid);
}




