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

//var yy = 10;
//var preset_to_test = 3;
//for (var i = 0; i < array_length(body_plan_presets[preset_to_test]); i ++){
//	for (var p = 0; p < array_length(body_plan_presets[preset_to_test][i]); p ++){
		
//		if (body_plan_presets[preset_to_test][i][p][0]){
//			draw_text(10, yy, body_plan_presets[preset_to_test][i][p][1]);
//			yy += 10;
//		}
//	}
//}


