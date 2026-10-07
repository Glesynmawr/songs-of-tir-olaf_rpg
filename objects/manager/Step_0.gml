/// @desc Main loop

// Update particles
particle_count ++;
if (particle_count > 144) particle_count = 0;
update_particles();

// Update game state
if (game_state.state_main != noone){
	game_state.state_main();
}

// Update transition
if (transition != noone){
	transition_update();
}

// Update UI animation
ui_anim_flip();




