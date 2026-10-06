
// SHADER SET UP ----------------------------------------------------------------------------------
function set_outline_shader_colour(){
	
	with (manager){
		
		outline_colour = colour_bg_main;
		var r = colour_get_red(outline_colour)   / 255;
		var g = colour_get_green(outline_colour) / 255;
		var b = colour_get_blue(outline_colour)  / 255;

		outline_colour  = [r, g, b, 1.0];
		uni_texel_size	= shader_get_uniform(outline_shd, "utexel_size");
		uni_outline_col = shader_get_uniform(outline_shd, "uRGBA");
	}
}


// PARTILE SET UP ---------------------------------------------------------------------------------
function init_particle_system(){
	particle_count = 0;
	
	globalvar particle_system;
	particle_system = part_system_create();

	part_system_automatic_draw(particle_system, false);

	// PARTICLES ----------------------------------------------------------------------------------
	globalvar part_title_fire;
	part_title_fire = part_type_create();
	part_type_direction(part_title_fire, 90, 90, 0, 7);
	part_type_life(part_title_fire, 45, 180);
	part_type_sprite(part_title_fire, fire_spr, true, true, false);
	part_type_speed(part_title_fire, 0.1, 0.3, 0.001, 0.15);
}

function particle_create_title_fire(particle, x_pos, y_pos){
	var xx = irandom_range(x_pos - 4, x_pos + 4);
	part_particles_create(particle_system, xx, y_pos, particle, 1);
}


// IN-GAME PARTICLES ------------------------------------------------------------------------------
function particle_create_actor_death(actor){
	var dir = irandom(360);
	var count = 3;
	repeat(count){
		dir += 120;
		var part_life = irandom_range(40, 60);
		var new_part = {
			sprite_index:	smoke_spiral_spr,
			image_index:	0,
			x:				(actor.x_pos * manager.cell_width)  + (manager.cell_width / 2) + lengthdir_x(4, dir),
			y:				(actor.y_pos * manager.cell_height) + (manager.cell_height / 2) + lengthdir_y(4, dir),
			direction:		90,
			speed:			0.5,
			life_max:		part_life,			
			life_timer:		part_life 
		}
		array_push(manager.dust_particles, new_part);
	}
}

function particle_create_hit_dust(actor, dir, count){
	repeat(count){
		var part_life = irandom_range(20, 30);
		var new_part = {
			sprite_index:	dust_spr,
			image_index:	0,
			x:				(actor.x_pos * manager.cell_width)  + (manager.cell_width / 2),
			y:				(actor.y_pos * manager.cell_height) + (manager.cell_height / 2),
			direction:		dir + irandom_range(-60, 60),
			speed:			1,
			life_max:		part_life,			
			life_timer:		part_life 
		}
		array_push(manager.dust_particles, new_part);
	}
}

function update_particles(){
	for (var i = array_length(dust_particles) - 1; i >= 0; i --){
		with (dust_particles[i]){
			x += lengthdir_x(speed, direction);
			y += lengthdir_y(speed, direction);
			life_timer --;
			if (life_timer <= 0){
				array_delete(manager.dust_particles, i, 1);
			}
			image_index = ((life_max - life_timer) / life_max) * sprite_get_number(sprite_index);
			speed *= random_range(0.93, 0.99);
		}
	}
}

function draw_particles(offset_x, offset_y){
	for (var i = array_length(dust_particles) - 1; i >= 0; i --){
		with (dust_particles[i]){
			draw_sprite(sprite_index, image_index, (x - offset_x) + manager.ui_x_pos[manager.ui_settings.ui_x_position][1], (y - offset_y));
		}
	}
}

