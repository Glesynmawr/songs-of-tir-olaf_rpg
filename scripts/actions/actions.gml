
// ACTOR ACTIONS ----------------------------------------------------------------------------------
function action_modify_hit_points(actor, value){
	with (actor){
		hit_points[STAT_TYPE.CURRENT] = min(hit_points[STAT_TYPE.CURRENT] + value, hit_points[STAT_TYPE.BASE]);
		
		if (hit_points[STAT_TYPE.CURRENT] <= 0){
			action_remove_actor(self);
			if (actor == manager.actor_registry.player){
				manager.game_state.state_main = game_state_game_over;
			}
		}
	}
}

function action_move(grid, move_x, move_y){
	
	var grid_w = array_length(grid);
	var grid_h = array_length(grid[0]);
	
	// Get target position
	var x_move, y_move;
	x_move = x_pos + move_x;
	y_move = y_pos + move_y;
	
	// Sprite flipping
	if (move_x > 0) xscale = 1;
	if (move_x < 0) xscale = -1;
	
	// Check target in bounds
	if (x_move < 0 or x_move >= grid_w or y_move < 0 or y_move >= grid_h) return(false);
	
	// Check game_state.game_grid for collision
	if (!grid[x_move][y_move].walkable) return(false);
	
	// Check actors for collision
	var len = array_length(manager.actor_registry.actor_list);
	for (var i = 0; i < len; i ++){
		
		var other_actor = manager.actor_registry.actor_list[i];
		
		var actor_x = other_actor.x_pos;
		var actor_y = other_actor.y_pos;
		
		if (actor_x == x_move and actor_y == y_move){
			
			// Bump target actor
			action_attack_melee(self, other_actor);
			
			return(true);
		}
	}
	
	// Move actor
	x_pos += move_x;
	y_pos += move_y;

	sprite_target_x = x_pos * manager.cell_width;
	sprite_target_y = y_pos * manager.cell_height;
	
	if (grid[x_pos][y_pos].tile == "closed door") or (grid[x_pos][y_pos].tile == "secret door"){
		
		if (self == manager.actor_registry.player){
			if (grid[x_pos][y_pos].tile == "secret door"){
				found_a_secret(self);
			}
		}
			
		cell_replace_tile(x_pos, y_pos, tile_door_open);
		grid[x_pos][y_pos].index = manager.game_state.door_index;
		
		// Create log entry
		var text = $"{self.name} barges through the door.";
		log_add_entry(text, manager.colour_text_main);
	}
	return(true);
}

function action_attack_melee(attacker, defender){
	
	attacker.melee_offset_x = (defender.sprite_x - attacker.sprite_x);
	attacker.melee_offset_y = (defender.sprite_y - attacker.sprite_y);
	var hands_available = body_part_empty_hand_slot_count(attacker);
	
	// COMBAT CALCULATION -------------------------------------------------------------------------
	for (var category = 0; category < array_length(attacker.body_plan); category ++){
		for (var index = 0; index < array_length(attacker.body_plan[category]); index ++){
			
			if (body_part_is_present(attacker, category, index)){
				
				for (var slot = BODY_PART_STATS.PART_HAND_SLOT; slot < array_length(attacker.body_plan[category][index]); slot ++){
					
					var held_item				= variable_clone(attacker.body_plan[category][index][slot]);
					var item_is_weapon			= false;
					
					var attack_damage			= [1, 2, -1];
					var agility_modifier		= 0;
					var damage_multiplier		= 1;
					var empty_hands_needed		= 0;
					var slot_matches_handedness = actor_get_correct_hand(attacker, attacker.handedness, category, index);
					var attack_chance			= 1;
					
					// Check for held weapon and damage values
					if (is_struct(held_item)){
						if (item_check_tag(held_item, TAG.MELEE)){
							if (struct_exists(held_item, "damage")){
								attack_damage	= held_item.damage;
								item_is_weapon	= true;
							}
						}
						// Check for 2 handed weapon
						if (item_check_tag(held_item, TAG.TWO_HANDED)){
							empty_hands_needed = 1;
						}
					}
					// Insufficient hands penalty
					if (hands_available < empty_hands_needed){
						if (item_is_weapon){
							agility_modifier	= -4;
							damage_multiplier	= 0.5;
						}
					}
					// Correct handedness - no weapon
					if (slot_matches_handedness){
						if (slot != BODY_PART_STATS.PART_HAND_SLOT and !item_is_weapon){
							attack_chance = 0;
						}
					}
					else {
						// Incorrect handedness - weapon
						if (item_is_weapon and hands_available >= empty_hands_needed){
							agility_modifier	= -4;
							attack_chance		= attacker.offhand_attack_chance;
							damage_multiplier	= 0.5;
						}
						else {
							// Incorrect handedness - no weapon
							attack_chance		= 0;
						}
					}
					
					// If attack chance is not zero
					if (attack_chance > 0){
						// Perform attack
						var attack_results = combat_attack(attacker, defender, attack_chance, attack_damage, agility_modifier, damage_multiplier, manager.melee_base_hit_modifier);
						
						// Create log entry - attack missed
						if (attack_results == false){
							var txt = $"{attacker.name} attacks {defender.name} but misses";
						}
						else if (is_array(attack_results)){
							
							// Create log entry - attack hits
							var txt = $"{attacker.name} attacks {defender.name} and hits! {attack_results[0]} damage, {attack_results[1]} blocked by armour.";
						}
						log_add_entry(txt, manager.colour_text_main);
					}
				}
			}
		}
	}
}

function action_attack_ranged(attacker, defender){
	
	var hands_available		= body_part_empty_hand_slot_count(attacker);
	var ammo_type_equipped	= noone;
	var ammo_stack			= 0;
	var ammo_item			= attacker.body_plan[BODY_PART_CATEGORY.BODY][0][BODY_PART_STATS.PART_SLOT_1];
	if (is_struct(ammo_item)){
		if (struct_exists(ammo_item, "ammo_type")){
			ammo_type_equipped	= ammo_item.ammo_type;
			ammo_stack			= ammo_item.stack;
		}
	}
	
	// COMBAT CALCULATION -------------------------------------------------------------------------
	for (var category = 0; category < array_length(attacker.body_plan); category ++){
		for (var index = 0; index < array_length(attacker.body_plan[category]); index ++){
			
			if (body_part_is_present(attacker, category, index)){
				
				for (var slot = BODY_PART_STATS.PART_HAND_SLOT; slot < array_length(attacker.body_plan[category][index]); slot ++){
					
					var held_item				= variable_clone(attacker.body_plan[category][index][slot]);
					var item_is_weapon			= false;
					var ammo_matches			= false;
					var attack_damage			= [1, 2, -1];
					var agility_modifier		= 0;
					var damage_multiplier		= 1;
					var empty_hands_needed		= 0;
					var slot_matches_handedness = actor_get_correct_hand(attacker, attacker.handedness, category, index);
					var attack_chance			= 1;
					
					// Check for held weapon and damage values
					if (is_struct(held_item)){
						if (item_check_tag(held_item, TAG.RANGED)){
							if (struct_exists(held_item, "damage")){
								attack_damage	= held_item.damage;
								item_is_weapon	= true;
							}
							if (struct_exists(held_item, "ammo_type")){
								if (held_item.ammo_type == ammo_type_equipped){
									ammo_matches = true;
								}
							}
						}
						// Check for 2 handed weapon
						if (item_check_tag(held_item, TAG.TWO_HANDED)){
							empty_hands_needed = 1;
						}
					}
					// Correct handedness - no weapon
					if (slot_matches_handedness){
						if (slot != BODY_PART_STATS.PART_HAND_SLOT and !item_is_weapon){
							attack_chance = 0;
						}
					}
					else {
						// Incorrect handedness - weapon
						if (item_is_weapon and hands_available >= empty_hands_needed){
							agility_modifier	= -4;
							attack_chance		= attacker.offhand_attack_chance;
							damage_multiplier	= 0.5;
						}
						else {
							// Incorrect handedness - no weapon
							attack_chance		= 0;
						}
					}
					// Insufficient hands penalty
					if (hands_available < empty_hands_needed){
						if (item_is_weapon){
							attack_chance = 0;
						}
					}
					// If attack chance is not zero
					if (attack_chance > 0 and ammo_stack > 0 and ammo_matches){
						// Perform attack
						var attack_results = combat_attack(attacker, defender, attack_chance, attack_damage, agility_modifier, damage_multiplier, manager.range_base_hit_modifier);
						// Decrement ammo stack if attack is made
						if (attack_results != noone){
							equipment_drop_slot(attacker, 1, BODY_PART_CATEGORY.BODY, 0, BODY_PART_STATS.PART_SLOT_1);
						}
						// Create log entry - attack missed
						if (attack_results == false){
							var txt = $"{attacker.name} shoots {defender.name} but misses";
						}
						else if (is_array(attack_results)){
							// Create log entry - attack hits
							var txt = $"{attacker.name} shoots {defender.name} and hits! {attack_results[0]} damage, {attack_results[1]} blocked by armour.";
						}
						log_add_entry(txt, manager.colour_text_main);
						attacker.has_acted = true;
					}
				}
			}
		}
	}
}

function action_remove_actor(actor, create_particles = true){
	
	if (create_particles){
		particle_create_actor_death(actor);
	}
	
	if (actor == manager.actor_registry.player){
		with (manager){
			game_state.direction_indicator = noone;
			game_paused = true;
		}
	}
	
	// Remove from action list
	var index = array_get_index(manager.actor_registry.action_list, actor);
	array_delete(manager.actor_registry.action_list, index, 1);
	
	// Remove from actor list
	index = array_get_index(manager.actor_registry.actor_list, actor);
	array_delete(manager.actor_registry.actor_list, index, 1);
}


// ACTOR PASSIVES ---------------------------------------------------------------------------------
function passive_check_actor_in_los(){
	
	// Get grid and dimentions
	var grid	= manager.game_state.game_grid;
	var ww		= array_length(grid);
	var hh		= array_length(grid[0]);
	
	// Set LoS check limits
	var x_from = max(x_pos - react_range, 0);
	var x_to   = min(x_pos + react_range, ww);
	var y_from = max(y_pos - react_range, 0);
	var y_to   = min(y_pos + react_range, hh);
	
	// Loop through LoS area
	var hostile_list = [];
	var flee_list    = [];
	
	for (var xx = x_from; xx < x_to; xx ++){
		for (var yy = y_from; yy < y_to; yy ++){
			var actor = grid_check_position_contains_actor(xx, yy);
			if (actor != noone and actor != self){
				
				// Check LoS
				var has_los = draw_los_line(manager.game_state.game_grid, x_pos, y_pos, xx, yy);
				
				if (has_los){
					// Get actor reaction
					var reaction = passive_actor_get_reaction(self, actor);
				
					// Push to hostile/flee lists
					if (reaction == state_chase) array_push(hostile_list, actor);
					if (reaction == state_flee)  array_push(flee_list, actor);
				}
			}
		}
	}
	
	// Check for flee targets
	var len = array_length(flee_list);
	if (len > 0){
		target_map = create_distance_map(grid, x_pos, y_pos);
		var nearest_dist = 100;
		var nearest_ind  = noone;
		for (var i = 0; i < len; i ++){
			var dist = target_map[flee_list[i].x_pos][flee_list[i].y_pos];
			if (dist < nearest_dist){
				nearest_dist = dist;
				nearest_ind  = i;
			}
		}
		
		// Set flee target
		target_actor = flee_list[nearest_ind];
		target_x     = target_actor.x_pos;
		target_y     = target_actor.y_pos;
		target_map   = create_distance_map(grid, target_x, target_y);
		
		state = state_flee;
		return;
	}
	
	var len = array_length(hostile_list);
	if (len > 0){
		target_map = create_distance_map(grid, x_pos, y_pos);
		var nearest_dist = 100;
		var nearest_ind  = noone;
		for (var i = 0; i < len; i ++){
			var dist = target_map[hostile_list[i].x_pos][hostile_list[i].y_pos];
			if (dist < nearest_dist){
				nearest_dist = dist;
				nearest_ind  = i;
			}
		}
		
		// Set chase target
		target_actor = hostile_list[nearest_ind];
		target_x     = target_actor.x_pos;
		target_y     = target_actor.y_pos;
		target_map   = create_distance_map(grid, target_x, target_y);
		
		state = state_chase;
		return;
	}
}

function passive_check_for_hostile_mobs(){
	for (var i = 0; i < array_length(manager.actor_registry.actor_list); i ++){
		var actor = manager.actor_registry.actor_list[i];
		if (actor.target_actor == self and actor.state == state_chase){
			return(true);
		}
	}
	return(false);
}

function passive_actor_get_reaction(actor, target){
	
	var standing  = manager.game_state.faction_list[actor.faction][target.faction];
	var demeanour = actor.demeanour;
	
	if (standing <= 1){
		switch(demeanour){
			case DEMEANOUR.AGGRESSIVE:	return(state_chase);
			case DEMEANOUR.PASSIVE:		return(state_chase);
			case DEMEANOUR.TIMID:		return(state_chase);
		}
	}
	else if (standing <= 7){
		switch(demeanour){
			case DEMEANOUR.AGGRESSIVE:	return(state_chase);
			case DEMEANOUR.PASSIVE:		return(state_chase);
			case DEMEANOUR.TIMID:		return(state_flee);
		}
	}
	else if (standing <= 13){
		switch(demeanour){
			case DEMEANOUR.AGGRESSIVE:	return(state_chase);
			case DEMEANOUR.PASSIVE:		return(noone);
			case DEMEANOUR.TIMID:		return(state_flee);
		}
	}
	else if (standing <= 19){
		switch(demeanour){
			case DEMEANOUR.AGGRESSIVE:	return(noone);
			case DEMEANOUR.PASSIVE:		return(noone);
			case DEMEANOUR.TIMID:		return(noone);
		}
	}
	else if (standing <= 20){
		switch(demeanour){
			case DEMEANOUR.AGGRESSIVE:	return(noone);
			case DEMEANOUR.PASSIVE:		return(noone);
			case DEMEANOUR.TIMID:		return(noone);
		}
	}
}

function passive_actor_reset_target(){
	target_actor	= noone;
	target_x		= noone;
	target_y		= noone;
	target_map		= noone;
}

function passive_move_bounce(actor){
	with (actor){
		var xx = sprite_x;
		var yy = sprite_y;
		
		var x_mod = (xx mod manager.cell_width)  / manager.cell_width;
		var y_mod = (yy mod manager.cell_height) / manager.cell_height;
		
		var x_bounce = sin(pi * x_mod);
		var y_bounce = sin(pi * y_mod);
		
		var z_mod = max(x_bounce, y_bounce);
		
		return(z_mod);
	}
}

function passive_state_update(){
	if (struct_exists(self, "state_update")){
		if (state_update != noone){
			state = state_update;
			variable_struct_remove(self, "state_update");
			
			return(true);
		}
	}
	return(false);
}


// DICE ROLL --------------------------------------------------------------------------------------
function dice_roll(dice_count, dice_sides, modifier){
	
	var roll_total = 0;
	
	repeat(dice_count){
		roll_total += irandom_range(1, dice_sides);
	}
	roll_total += modifier;
	
	return(roll_total);
}


// COMBAT ACTIONS ---------------------------------------------------------------------------------
function combat_attack(attacker, defender, attack_chance, damage, agility_modifier, damage_multiplier, hit_modifier){
	
	var attack_made = combat_get_attack_chance(attack_chance);
	if (!attack_made) return(noone);
	
	var attack_hits = combat_get_hit(attacker.agility + agility_modifier, defender.agility, hit_modifier);
	if (!attack_hits) {
		play_sound(attack_miss_00_snd, AUDIO_SETTINGS.SFX_GAIN);
		return(false);
	}
	
	var hit_location = combat_get_hit_location(defender);
	var location_armour = combat_get_location_armour(defender, hit_location);
	var raw_damage = combat_get_damage(damage, damage_multiplier);
	
	if (raw_damage - location_armour <= 0){
		play_sound(attack_blocked_00_snd, AUDIO_SETTINGS.SFX_GAIN);
		particle_create_hit_dust(defender, point_direction(attacker.x_pos, attacker.y_pos, defender.x_pos, defender.y_pos), 3);
		return(false);
	}
	
	play_sound(attack_damage_00_snd, AUDIO_SETTINGS.SFX_GAIN);
	particle_create_hit_dust(defender, point_direction(attacker.x_pos, attacker.y_pos, defender.x_pos, defender.y_pos), 5, C_RED);
	with (defender){
		target_actor = attacker;
		target_x     = attacker.x_pos;
		target_y	 = attacker.y_pos;
		target_map   = create_distance_map(manager.game_state.game_grid, target_x, target_y);
		state_update = state_chase;
	}
	
	action_modify_hit_points(defender, -(raw_damage - location_armour));
	return([raw_damage, location_armour]);
}

function actor_get_correct_hand(actor, main_hand, category, index){
	
	with (actor){
		if (main_hand[0] == category and main_hand[1] == index){
			return(true);
		}
		else return(false);
	}
}

function combat_get_attack_chance(attack_chance){
	
	var roll = random(1);
	if (roll < attack_chance){
		return(true);
	}
	return(false);
}

function combat_get_hit(attacker_agility, defender_agility, modifier){
	
	// Get attack and defence stats
	var att_stat = attacker_agility;
	var def_stat = defender_agility;
	
	// Determine success chance
	var success_chance = 21 - (round(att_stat / (att_stat + def_stat) * 19) + 1);
	
	// Roll dice
	var attack_roll = dice_roll(1, 20, 0) + modifier;
	
	// Success comparison
	if (attack_roll >= success_chance){
		return(true);
	}
	else {
		return(false);
	}
}

function combat_get_hit_location(defender){
	
	var total_weight = 0;
			
	// Get total weights
	for (var i = 0; i < array_length(defender.hit_weights); i ++){
		for (var j = 0; j < array_length(defender.hit_weights[i]); j ++){
			total_weight += defender.hit_weights[i][j];
		}
	}
	
	var selected_category	= noone;
	var selected_index		= noone;
	var rolled_location		= dice_roll(1, total_weight, 0);
	var accumulator			= 0;
	var loop_ended			= false;
			
	for (i = 0; i < array_length(defender.hit_weights); i ++){
		for (j = 0; j < array_length(defender.hit_weights[i]); j ++){
			accumulator += defender.hit_weights[i][j];
			if (rolled_location <= accumulator and !loop_ended){
				selected_category = i;
				selected_index    = j;
				loop_ended = true;
				break;
			}
		}
		if (loop_ended) break;
	}
	return([selected_category, selected_index]);
}

function combat_get_location_armour(defender, hit_loc){
	var location_armour = 0;
	
	for (var slot = BODY_PART_STATS.PART_SLOT_1; slot < array_length(defender.body_plan[hit_loc[0]][hit_loc[1]]); slot ++){
		if (is_struct(defender.body_plan[hit_loc[0]][hit_loc[1]][slot])){
			if (struct_exists(defender.body_plan[hit_loc[0]][hit_loc[1]][slot], "armour")){
				location_armour = defender.body_plan[hit_loc[0]][hit_loc[1]][slot].armour;
			}
		}
	}
	
	location_armour = irandom_range(0, location_armour);
	
	return(location_armour);
}

function combat_get_damage(base_damage, multiplier = 1){
	
	var damage = dice_roll(base_damage[0], base_damage[1], base_damage[2]);
	damage = floor(damage * multiplier)
	return(damage);
}

function player_swap_items(actor){
	with (actor){
		for (var category = 0; category < array_length(body_plan); category ++){
			for (var index = 0; index < array_length(body_plan[category]); index ++){
				var aux_item = variable_clone(body_plan[category][index][BODY_PART_STATS.PART_AUX_SLOT]);
				var hand_item = variable_clone(body_plan[category][index][BODY_PART_STATS.PART_HAND_SLOT]);
			
				body_plan[category][index][BODY_PART_STATS.PART_AUX_SLOT] = hand_item;
				body_plan[category][index][BODY_PART_STATS.PART_HAND_SLOT] = aux_item;
			}
		}
	}
}




