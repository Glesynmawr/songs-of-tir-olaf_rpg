/// @desc Main loop

particle_count ++;
if (particle_count > 144) particle_count = 0;

if (game_state.state_main != noone){
	game_state.state_main();
}

if (transition != noone){
	transition_update();
}

ui_anim_flip();




