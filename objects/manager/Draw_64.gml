/// @desc UI elements

switch(game_state){
	case game_state_control_menu:	draw_control_menu();	break;
	case game_state_dungeon:		draw_game_ui();			break;
	case game_state_main_menu:		draw_main_menu();		break;
}





