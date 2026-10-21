/// @desc UI elements

switch(game_state.state_main){
	case game_state_control_menu:	draw_control_menu();	break;
	case game_state_dungeon:		draw_game_ui();			break;
	case game_state_game_over:		draw_game_over_menu();	break;
	case game_state_main_menu:		draw_main_menu();		break;
	case game_state_pause_menu:		draw_pause_menu();		break;
}

if (notification.text != ""){
	draw_notification();
}

draw_ui_particles();

if (transition != noone){
	draw_sprite_tiled_ext(transition_spr, transition.index, 0, 0, 1, 1, transition.colour, 1);
}



	
