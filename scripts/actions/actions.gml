
// ACTOR ACTIONS ----------------------------------------------------------------------------------
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
		grid[x_pos][y_pos].index = manager.door_index;
		
		// Create log entry
		var text = $"{self.name} barges through the door.";
		log_add_entry(text, manager.colour_text_main);
	}
	return(true);
}

function action_attack_melee(attacker, defender){
	
	var first_log = "";
	var log_col	  = manager.colour_text_main;
	
	attacker.melee_offset_x = (defender.sprite_x - attacker.sprite_x);
	attacker.melee_offset_y = (defender.sprite_y - attacker.sprite_y);
	
	// COMBAT CALCULATION -------------------------------------------------------------------------
	for (var category = 0; category < array_length(attacker.body_plan); category ++){
		for (var index = 0; index < array_length(attacker.body_plan[category]); index ++){
			
			// Check body part for hand
			if (body_part_is_present(attacker, category, index)){
				
				for (var slot = BODY_PART_STATS.PART_HAND_SLOT; slot < array_length(attacker.body_plan[category][index]); slot ++){
					
					// Initialise combat variables
					var perform_attack			= false;
					var attacker_agility		= attacker.agility;
					var defender_agility		= defender.agility;
					var attacker_empty_hands	= body_part_empty_hand_slot_count(attacker);
					
					// Get attack item
					var melee_item				= variable_clone(attacker.body_plan[category][index][slot]);
					
					// Get attack handedness
					var item_is_in_correct_hand = false;
					if (handedness[0] == category and handedness[1] == index){
						item_is_in_correct_hand = true;
					}
					
					// Re-initialise log entry
					first_log = "";
					
					if (melee_item != noone){
						// Item is held
						
						if (struct_exists(melee_item, "damage")){
							// Item has a damage stat
							
							var item_requires_two_hands = item_check_tag(melee_item, TAG.TWO_HANDED);
							
							// Check if hand does not match handedness
							if (item_is_in_correct_hand){
								if (item_requires_two_hands){
									if (attacker_empty_hands < 1){
										melee_item.damage[1] = round(melee_item.damage[1] * 0.5);
										attacker_agility	 += manager.offhand_agility_penalty;
										first_log += "needs 2 hands! ";
									}
								}
								first_log      += $"{attacker.name} attacks {defender.name} with {attacker.body_plan[category][index][BODY_PART_STATS.PART_NAME]}";
								perform_attack = true;
							}
							else{
							
								var attack_chance = attacker.offhand_attack_chance;
								var roll = random(1);
							
								if (roll <= attack_chance){
									first_log += "off-hand! ";
									first_log += $"{attacker.name} attacks {defender.name} with {attacker.body_plan[category][index][BODY_PART_STATS.PART_NAME]}";
									attacker_agility += manager.offhand_agility_penalty;
									perform_attack   = true;
								}
							}
						}
						else{
							// Item has no damage stat
							if (item_is_in_correct_hand and slot == BODY_PART_STATS.PART_HAND_SLOT){
								if (body_part_has_hand(attacker, category, index)){
									first_log      = $"{attacker.name} attacks {defender.name} with their bare hand";
									perform_attack = true;
								}
							}
						}
					}
					else{
						// No item held
						if (item_is_in_correct_hand and slot == BODY_PART_STATS.PART_HAND_SLOT){
							if (body_part_has_hand(attacker, category, index)){
								first_log      = $"{attacker.name} attacks {defender.name} with their bare hand";
								perform_attack = true;
							}
						}
					}
					
					if (perform_attack){
						
						// Execute to-hit roll
						var attack_hits = combat_get_hit(attacker_agility, defender_agility);
						
						// Attack hits
						if (attack_hits){
							
							// Modify defender state
							if (defender.state == state_idle or defender.state == state_wander){
								defender.state_update = defender.state_react;
							}
							
							first_log += " and hits ";
							particle_create_hit_dust(defender, point_direction(attacker.x_pos, attacker.y_pos, defender.x_pos, defender.y_pos), 5);
							
							// Get hit location
							var hit_loc = combat_get_hit_location(defender);
							if (hit_loc[0] != noone and hit_loc[1] != noone){
								
								// Get attack damage
								if (is_struct(melee_item)){
									if (!struct_exists(melee_item, "damage")){
										melee_item = noone;
									}
								}
								var damage = combat_get_melee_damage(attacker, melee_item);
								
								// Get location armour
								var location_armour = combat_get_location_armour(defender, hit_loc);
								
								// Apply damage
								if (damage > 0){
									damage = max(damage - location_armour, 1);
									set_colour_flash(defender, C_RED, 10);
									first_log += $"causing {damage} damage";
								}
								else{
									set_colour_flash(defender, C_WHITE, 10);
									first_log += "but causes no damage";
								}
								
							}
						}
						else{
							// Attack misses
							first_log += " and misses";
						}
					}
					
					// Create log entries
					if (first_log != ""){
						log_add_entry(first_log, log_col);
					}
				}
			}
		}
	}
}

function action_remove_actor(actor){
	
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
	
	// Player position
	var player_x = manager.actor_registry.player.x_pos;
	var player_y = manager.actor_registry.player.y_pos;
	
	// Distance to player
	var dist = distance_map_player[x_pos][y_pos];
	
	// Visibility of player
	var in_sight = draw_los_line(manager.game_state.game_grid, x_pos, y_pos, player_x, player_y);
	
	if (dist <= range) and (in_sight == true) and (!struct_exists(self, "chase_count")){
		
		if (!player_spotted){
			log_add_entry($"{name} has spotted {manager.actor_registry.player.name}!", manager.colour_text_main);
			player_spotted = true;
		}
		
		switch(demeanour){
			case DEMEANOUR.AGGRESSIVE:	state = state_chase; break;
			case DEMEANOUR.TIMID:		state = state_flee;  break;
		}
		
		if (state == state_chase or state == state_flee){
			chase_count = range * 2;
		}
	}
}

function passive_state_update(){
	if (struct_exists(self, "state_update")){
		if (state_update != noone){
			state = state_update;
			//variable_struct_remove(self, "state_update");
			if (state == state_chase or state == state_flee){
				chase_count = range * 2;
			}
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
function combat_get_hit(attacker_agility, defender_agility){
	
	// Get attack and defence stats
	var att_stat = attacker_agility;
	var def_stat = defender_agility;
	
	// Determine success chance
	var success_chance = 21 - (round(att_stat / (att_stat + def_stat) * 19) + 1);
	
	// Roll dice
	var attack_roll = dice_roll(1, 20, 0);
	
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

function combat_get_melee_damage(attacker, item = noone){
	
	var damage = 0;
	if (item == noone){
		damage = dice_roll(1, 2, -1);
	}
	else{
		damage = dice_roll(item.damage[0], item.damage[1], item.damage[2]);
	}
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




