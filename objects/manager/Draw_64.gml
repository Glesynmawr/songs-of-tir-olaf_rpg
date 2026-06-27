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

//draw_text_outlined($"Game state: {game_state}", 10, 10, c_white, fa_left);
//draw_text_outlined($"Prev state: {game_state_previous}", 10, 17, c_white, fa_left);
//draw_text_outlined($"Cont state: {control_state_previous}", 10, 24, c_white, fa_left);



