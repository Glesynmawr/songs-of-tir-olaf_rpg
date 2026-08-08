/// @desc Main loop

particle_count ++;
if (particle_count > 144) particle_count = 0;

if (game_state != noone){
	game_state();
}

if (transition != noone){
	transition_update();
}

ui_anim_flip();




