/// @desc Draw game

if (game_state == game_state_dungeon){
	draw_dungeon();
}
else if (game_state == game_state_world){
	draw_world_grid(world_grid);
}




