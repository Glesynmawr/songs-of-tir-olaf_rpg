
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
		log_add_entry(second_log, manager.colour_text_main);
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


// DICE ROLL --------------------------------------------------------------------------------------
function dice_roll(value){
	return(irandom_range(1, value));
}


// COMBAT ACTIONS ---------------------------------------------------------------------------------
function combat_get_hit(attacker, defender){
	
	// Get attack and defence stats
	var att_stat = attacker.agility;
	var def_stat = defender.agility;
	
	// Determine success chance
	var success_chance = 22 - (round(att_stat / (att_stat + def_stat) * 18) + 2);
	
	// Roll dice
	var attack_roll = dice_roll(10) + dice_roll(10);
	
	// Success comparison
	if (attack_roll >= success_chance){
		var txt = $"Att: {att_stat} - Def: {def_stat} - to hit: {success_chance} - roll: {attack_roll}";
		log_add_entry(txt, C_GREEN);
		return(true);
	}
	else {
		var txt = $"Att: {att_stat} - Def: {def_stat} - to hit: {success_chance} - roll: {attack_roll}";
		log_add_entry(txt, C_RED);
		return(false);
	}
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




