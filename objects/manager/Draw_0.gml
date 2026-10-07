/// @desc Game elements

draw_clear(colour_bg_main);

var draw_grid = false;

switch(game_state.state_main){
	case game_state_dungeon:	draw_grid	= true; break;
	case game_state_game_over:	draw_grid	= true; break;
	case game_state_pause_menu: draw_grid	= true; break;
	case game_state_world:		draw_grid	= true; break;
	
}

if (draw_grid){
	actors_move_sprite();
	// Game layers
	game_draw_grid();
}




