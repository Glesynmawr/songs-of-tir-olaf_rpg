/// @desc UI elements

switch(game_state){
	case game_state_control_menu:	draw_control_menu();	break;
	case game_state_main_menu:		draw_main_menu();		break;
	case game_state_pause_menu:		draw_pause_menu();		break;
	case game_state_dungeon:		draw_game_ui();			break;
	case game_state_world:			draw_game_ui();			break;
}

if (transition != noone){
	draw_sprite_tiled_ext(transition_spr, transition.index, 0, 0, 1, 1, transition.colour, 1);
}

draw_text(10, 10, "Draw W: " + string(cells_draw_width));
draw_text(10, 20, "Draw H: " + string(cells_draw_height));


