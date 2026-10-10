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

if (transition != noone){
	draw_sprite_tiled_ext(transition_spr, transition.index, 0, 0, 1, 1, transition.colour, 1);
}

draw_text(10, 10, string(world_lighting));

var xx = 10;
var yy = 20;

// Current turn
draw_text_outlined($"Turn: {time_system.game_current_time[TIME.TURN]}", xx, yy, colour_text_main);
	
// Current hour
yy += text_height;
draw_text_outlined($"Hour: {time_system.game_current_time[TIME.HOUR]}", xx, yy, colour_text_main);
	
// Current day
yy += text_height;
draw_text_outlined($"Day:  {time_system.game_current_time[TIME.DAY]}", xx, yy, colour_text_main);
	
