/// @desc Main loop

if (game_state != noone){
	if (transition == noone){
		game_state();
	}
}

if (transition != noone){
	transition_update();
}




