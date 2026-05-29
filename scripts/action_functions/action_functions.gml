
// ACTOR ACTIONS ----------------------------------------------------------------------------------
function action_move(grid, move_x, move_y){
	
	// Get target position
	var x_move, y_move;
	x_move = x_pos + move_x;
	y_move = y_pos + move_y;
	
	// Check game_grid for collision
	if (!grid[x_move][y_move].walkable) return(false);
	
	// Check actors for collision
	var len = array_length(other.actor_registry.actor_list);
	for (var i = 0; i < len; i ++){
		
		var other_actor = other.actor_registry.actor_list[i];
		
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
	
	if (grid[x_pos][y_pos].tile == "closed door") or (grid[x_pos][y_pos].tile == "secret door"){
		
		if (self == manager.actor_registry.player){
			if (manager.game_grid[x_pos][y_pos].tile == "secret door"){
				found_a_secret(self);
			}
		}
			
		cell_replace_tile(x_pos, y_pos, tile_door_open);
		
		// Create log entry
		var text = $"{self.name} barges through the door.";
		log_add_entry(text, manager.text_colour);
	}
	return(true);
}

function action_attack_melee(attacker, defender){
	
	var first_log = "";
	var log_col	  = c_ltgrey;
	var second_log = "";
	
	var att_name = attacker.name;
	var def_name = defender.name;
	
	
	// COMBAT CALCULATION -------------------------------------------------------------------------
	
	// 1) Initialise combat variables
	var attack_hits = combat_get_hit(attacker, defender);
	first_log = $"{att_name} attacks {def_name}";
	
	// 2) Determine if attack hits
	if (!attack_hits){
		first_log += " and misses!";
		log_col = c_aqua;
	}
	else{
		
		// 3) Determine damage dealt
		var damage_modifier = combat_get_melee_damage_modifier(attacker, defender);
		var weapon_damage = round(irandom_range(1, 3) * damage_modifier);
		
		var weapon_damage = max(0, weapon_damage - defender.armour);
		
		defender.hit_points -= weapon_damage;
		
		if (weapon_damage > 0){
			first_log += $" for {weapon_damage} damage!";
			if (defender.armour > 0){
				first_log += $" {defender.armour} damage was blocked by armour.";
			}
			log_col = c_fuchsia;
		}
		else{
			first_log += $" but does not pierce {defender.name}s armour.";
			log_col = c_orange;
		}
		
		// 4) Kill target
		if (defender.hit_points <= 0){
			
			second_log = $"{defender.name} was killed!";
			action_remove_actor(defender);
		}
	}
			
	// Create log entries
	if (first_log != ""){
		
		// Damage log entry
		log_add_entry(first_log, log_col);
	}
	if (second_log != ""){
		
		// Death log entry
		log_add_entry(second_log, manager.text_colour);
	}
}

function action_remove_actor(actor){
	
	if (actor == manager.actor_registry.player){
		with (manager){
			direction_indicator = noone;
			game_paused = true;
		}
	}
	
	// Remove from action list
	var index = array_get_index(manager.action_list, actor);
	array_delete(manager.action_list, index, 1);
	
	// Remove from actor list
	index = array_get_index(manager.actor_registry.actor_list, actor);
	array_delete(manager.actor_registry.actor_list, index, 1);
}

// COMBAT ACTIONS ---------------------------------------------------------------------------------
function combat_get_hit(attacker, defender){
	// 80% base to-hit chance
	var base_hit_chance = 0.8;
	
	// Get attacker agility + bonuses
	var att_agility = attacker.agility;
	
	// Get defender agility + bonuses
	var def_agility = defender.agility;
	
	// Get difference between attacker and defender agility
	var agility_diff = att_agility - def_agility;		
	
	// Difference equals 2% change either way
	var hit_chance = base_hit_chance + (agility_diff * 0.02);	
	
	// Hit chance clamped to prevent auto hit or miss
	hit_chance = clamp(hit_chance, 0.05, 0.95);
	
	// Roll dice
	if (random(1) > hit_chance){
		return(false);
	}
	else return(true);
}

function combat_get_melee_damage_modifier(attacker, defender){
	var base_damage_modifier = 1;
	
	// Get attacker strength + bonuses
	var att_strength = attacker.strength;
	
	// Get defender strength + bonuses
	var def_strength = defender.strength;
	
	// Get difference between attacker and defender strength
	var strength_diff = att_strength - def_strength;
	
	// Difference = 2% change either way
	var damage_modifier = base_damage_modifier + (strength_diff * 0.02);
	
	return(damage_modifier);
}




