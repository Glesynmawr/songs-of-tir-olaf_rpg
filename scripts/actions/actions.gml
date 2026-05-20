
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
		cell_replace_tile(x_pos, y_pos, tile_open_door);
		
		// Create log entry
		var text = $"{self.name} barges through the door.";
		log_add_entry(text, manager.text_colour);
	}
	return(true);
}

function action_attack_melee(attacker, defender){
	
	var first_log = "";
	var second_log = "";
	
	var att_name = attacker.name;
	var def_name = defender.name;
	
	
	// COMBAT CALCULATION -------------------------------------------------------------------------
	
	first_log = $"{att_name} attacks {def_name}";
	
	// 1) Initialise combat variables
	var base_hit_chance = 0.8;									// 80% base to-hit chance
	var agility_diff = attacker.agility - defender.agility;		// Get difference between attacker and defender agility
	var hit_chance = base_hit_chance + (agility_diff * 0.02);	// Difference equals 2% change either way depending on difference
	hit_chance = clamp(hit_chance, 0.05, 0.95);
	
	// 2) Determine if attack hits
	if (random(1) > hit_chance){
		first_log += " and misses!";
	}
	else{
		
		// 3) Determine damage dealt
		var weapon_bonus = 0;
		
		var raw_damage = attacker.strength + weapon_bonus;
		var final_damage = max(1, raw_damage - defender.defence);
		
		defender.hit_points -= final_damage;
		first_log += $" for {final_damage} damage! {defender.defence} damage was blocked by armour.";
		
		// 4) Kill target
		if (defender.hit_points <= 0){
			
			second_log = $"{defender.name} was killed!";
			action_remove_actor(defender);
		}
	}
			
	// Create log entries
	if (first_log != ""){
		
		// Damage log entry
		log_add_entry(first_log, manager.text_colour);
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
			game_pause = true;
		}
	}
	
	// Remove from action list
	var index = array_get_index(manager.action_list, actor);
	array_delete(manager.action_list, index, 1);
	
	// Remove from actor list
	index = array_get_index(manager.actor_registry.actor_list, actor);
	array_delete(manager.actor_registry.actor_list, index, 1);
}




