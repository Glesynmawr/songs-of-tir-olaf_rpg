
// ANIMATION --------------------------------------------------------------------------------------
function actor_animate(){
	image_index += image_speed;
	if (image_index >= sprite_get_number(sprite)) image_index -= sprite_get_number(sprite);
	return(image_index);
}

function actors_move_sprite(){
	for (var i = 0; i < array_length(actor_registry.actor_list); i ++){
		with (actor_registry.actor_list[i]){
			if (sprite_x != sprite_target_x){
				sprite_x += (sprite_target_x - sprite_x) * manager.actor_move_speed;
			}
			if (sprite_y != sprite_target_y){
				sprite_y += (sprite_target_y - sprite_y) * manager.actor_move_speed;
			}
		}
	}
}


// BODY_PRESET LAYOUT
function body_part_list_copy(preset){
	
	var new_list = [];
	for (var c = 0; c < array_length(body_plan_presets[preset]); c ++){
		
		new_list[c] = [];
		
		for (var i = 0; i < array_length(body_plan_presets[preset][c]); i ++){
			var part_data = body_plan_presets[preset][c][i];
			new_list[c][i] = [];
			array_copy(new_list[c][i], 0, part_data, 0, array_length(part_data));
		}
	}
	
	equipment_initialise(new_list);
	
	return(new_list);
}

function body_part_is_present(actor, category, index){
	return(actor.body_plan[category][index][BODY_PART_STATS.PART_EXISTS]);
}

function body_part_has_hand(actor, category, index){
	return(actor.body_plan[category][index][BODY_PART_STATS.PART_HAS_HAND]);
}

function body_part_count(actor, category){
	var count = 0;
	for (var index = 0; index < array_length(actor.body_plan[category]); index ++){
		if (actor.body_plan[category][index][BODY_PART_STATS.PART_EXISTS] == true){
			count ++;
		}
	}
	return(count);
}

function body_part_equipment_slot_count(actor, category, index){
	return(array_length(actor.body_plan[category][index]) - BODY_PART_STATS.PART_SLOT_1);
}

function body_part_empty_hand_slot_count(actor){
	var free_hand_count = 0;
	for (var category = 0; category < array_length(actor.body_plan); category ++){
		for (var index = 0; index < array_length(actor.body_plan[category]); index ++){
			if (body_part_is_present(actor, category, index)){
				if (body_part_has_hand(actor, category, index)){

					if (!is_struct(actor.body_plan[category][index][BODY_PART_STATS.PART_HAND_SLOT])){
						free_hand_count ++;
					}
				}
			}
		}
	}
	return(free_hand_count);
}

// SPAWNING	 --------------------------------------------------------------------------------------
function spawn_new_actor(actor_type, cell_x, cell_y){
	
	var new_actor = new actor_type();
	
	// Replacement variables
	new_actor.is_visible	= false;
	new_actor.x_pos			= cell_x;
	new_actor.y_pos			= cell_y;
	
	new_actor.colour_fg		= noone;
	new_actor.colour_timer  = 0;
	
	// Sprite and Animation
	new_actor.sprite_x			= cell_x * cell_width;
	new_actor.sprite_y			= cell_y * cell_height;
	new_actor.sprite_target_x	= cell_x * cell_width;
	new_actor.sprite_target_y	= cell_y * cell_height;
	new_actor.melee_offset_x	= 0;
	new_actor.melee_offset_y	= 0;
	
	new_actor.image_index		= irandom(new_actor.sprite);
	new_actor.image_speed		= sprite_get_speed(new_actor.sprite) / game_get_speed(gamespeed_fps);
	new_actor.xscale			= 1;
	
	// Turn structure variables
	new_actor.energy	= 0;
	new_actor.has_acted = false;
	new_actor.is_player = false;
	
	if (actor_type == actor_player){
		actor_registry.player	= new_actor;
		new_actor.is_player		= true;
		new_actor.is_visible	= false;
	}
	else{
		new_actor.world_x = noone;
		new_actor.world_y = noone;
	}
	
	// Inventory
	new_actor.body_plan				= body_part_list_copy(new_actor.body_index);
	new_actor.inventory				= inventory_initialise();
	new_actor.hit_weights			= hit_weights_calculate(new_actor, new_actor.body_plan);
	new_actor.handedness			= [0,0];
	new_actor.offhand_attack_chance = 0.2;
	
	// Starting items
	if (struct_exists(new_actor, "equipment")){
		for (var i = 0; i < array_length(new_actor.equipment); i ++){
			spawn_new_item(item_proboscis, 1, SPAWN_LOC.EQUIPPED, , , new_actor)
		}
	}
	// Push to actor registry
	array_push(actor_registry.actor_list, new_actor);
}


// DESPAWNING -------------------------------------------------------------------------------------
function action_list_clear_all(include_player){
	if (include_player){
		array_resize(manager.actor_registry.action_list, 0);
	}
	else{
		array_resize(manager.actor_registry.action_list, 1);
	}
}

function actor_list_clear_all(include_player){
	if (include_player){
		array_resize(manager.actor_registry.actor_list, 0);
	}
	else{
		array_resize(manager.actor_registry.actor_list, 1);
	}
}


// EFFECTS ----------------------------------------------------------------------------------------
function set_colour_flash(actor, colour, duration){
	with (actor){
		colour_fg		= colour;
		colour_timer	= duration;
	}
}

function flash_timer_reduce(){

	if (colour_timer > 0){
		colour_timer --;
		if (colour_timer <= 0){
			colour_fg = noone;
		}
	}
}




