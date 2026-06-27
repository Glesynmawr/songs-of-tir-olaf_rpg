
function init_particle_system(){
	globalvar particle_system;
	particle_system = part_system_create();

	part_system_automatic_draw(particle_system, false);

	// ATTACK PARTICLES -----------------------------------------------------------------------
	globalvar part_actor_death_smoke;
	part_actor_death_smoke = part_type_create();
	part_type_life(part_actor_death_smoke, 30, 60);
	part_type_speed(part_actor_death_smoke, 0.2, 0.3, 0, 0);
	part_type_direction(part_actor_death_smoke, 90, 90, 0, 0);
	part_type_sprite(part_actor_death_smoke, smoke_spiral_spr, true, true, false);

	globalvar part_title_fire;
	part_title_fire = part_type_create();
	part_type_direction(part_title_fire, 90, 90, 0, 7);
	part_type_life(part_title_fire, 45, 180);
	part_type_sprite(part_title_fire, fire_spr, true, true, false);
	part_type_speed(part_title_fire, 0.13, 0.4, 0, 0.15);
}

function particle_create_title_fire(particle, x_pos, y_pos, quantity){
	repeat(quantity){
		var xx = irandom_range(x_pos - 4, x_pos + 4);
		part_particles_create(particle_system, xx, y_pos, particle, 1);
	}
}

function particle_create_actor(particle_type, grid_x, grid_y, number = 3, dist = 4){
	var i, xx, yy, angle, angle_start;
	
	angle = 360/number;
	angle_start = irandom(360);
	
	for (i = 0; i < number; i ++){
		xx = (grid_x * cell_width)  + (cell_width / 2)  + lengthdir_x(dist, angle_start + (i * angle));
		yy = (grid_y * cell_height) + (cell_height / 2) + lengthdir_y(dist, angle_start + (i * angle));
		part_particles_create(particle_system, xx, yy, particle_type, 1);
	}
}




