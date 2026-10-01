
// DATA -------------------------------------------------------------------------------------------

#region// MARSH  ZONE -----------------------------------------------------------------------------
function actor_player()constructor{
	faction         = FACTION.PLAYER;
	name			= "Doodle";
	sprite			= rogue_spr;
	range			= 7;
	react_range		= 0;
	body_index		= BODY_PRESET.HUMANOID;
	state			= state_ready_for_inputs;
	state_base		= state_ready_for_inputs;
	demeanour		= DEMEANOUR.PASSIVE;
	chase_persist	= [0, 0];
	strength		= 4;
	agility			= 4;
	hit_points		= [12, 12];
	action_speed	= 100;
	equipment		= [];
	world_x			= 0;
	world_y			= 0;
}

function actor_flamingo()constructor{
	spawn_tile		= noone;
	faction         = FACTION.BIRD_PREY
	name			= "Flamingo";
	sprite			= flamingo_spr;
	range			= 6;
	react_range		= 5;
	body_index		= BODY_PRESET.WINGED_BIPED;
	state			= state_wander;
	state_base		= state_wander;
	demeanour		= DEMEANOUR.TIMID;
	chase_persist	= [0, 0];
	hp_flee_percent	= 100;
	strength		= 2;
	agility			= 5;
	hit_points		= [4, 4];
	action_speed	= 100;
	equipment		= [[item_beak, 1], [item_wings, 1]];
}

function actor_marsh_frog()constructor{
	spawn_tile		= "water";
	faction         = FACTION.AMPHIBIAN_PREY;
	name			= "Marsh Frog";
	sprite			= marsh_frog_spr;
	range			= 2;
	react_range		= 2;
	body_index		= BODY_PRESET.QUADRUPED;
	state			= state_wander;
	state_base		= state_wander;
	demeanour		= DEMEANOUR.PASSIVE;
	chase_persist	= [0, 0];
	hp_flee_percent	= 50;
	strength		= 3;
	agility			= 3;
	hit_points		= [6, 6];
	action_speed	= 50;
	equipment		= [[item_bite, 1]];
}

function actor_marsh_turtle()constructor{
	spawn_tile		= noone;
	faction         = FACTION.REPTILE_PREDATOR;
	name			= "Marsh Turtle";
	sprite			= marsh_turtle_spr;
	range			= 4;
	react_range		= 1;
	body_index		= BODY_PRESET.QUADRUPED;
	state			= state_idle;
	state_base		= state_idle;
	demeanour		= DEMEANOUR.AGGRESSIVE;
	chase_persist	= [3, 6];
	hp_flee_percent	= 25;
	strength		= 5;
	agility			= 1;
	hit_points		= [8, 8];
	action_speed	= 50;
	equipment		= [[item_carapace, 1], [item_bite, 1]];
}

#endregion

#region// MARSH DUNGEON ---------------------------------------------------------------------------
function actor_reed_weevil()constructor{
	spawn_tile		= "room";
	faction         = FACTION.AMPHIBIAN_PREY;
	name			= "Reed weevil";
	sprite			= reed_weevil_spr;
	range			= 3;
	react_range		= 3;
	body_index		= BODY_PRESET.QUADRUPED;
	state			= state_wander;
	state_base		= state_wander;
	demeanour		= DEMEANOUR.PASSIVE;
	chase_persist	= [3, 6];
	hp_flee_percent	= 50;
	strength		= 1;
	agility			= 2;
	hit_points		= [4, 4];
	action_speed	= 50;
	equipment		= [[item_proboscis, 1]];
}

function actor_marsh_bat()constructor{
	spawn_tile		= "room";
	faction         = FACTION.MAMMAL_PREY;
	name			= "Marsh bat";
	sprite			= bat_spr;
	range			= 6;
	react_range		= 6;
	body_index		= BODY_PRESET.WINGED_BIPED;
	state			= state_wander;
	state_base		= state_wander;
	demeanour		= DEMEANOUR.AGGRESSIVE;
	chase_persist	= [3, 6];
	hp_flee_percent	= 50;
	strength		= 1;
	agility			= 6;
	hit_points		= [2, 2];
	action_speed	= 120;
	equipment		= [[item_wings, 1], [item_bite, 1]];
}

function actor_marsh_rat()constructor{
	spawn_tile		= "room";
	faction         = FACTION.MAMMAL_PREY;
	name			= "Marsh rat";
	sprite			= rat_spr;
	range			= 4;
	react_range		= 4;
	body_index		= BODY_PRESET.QUADRUPED;
	state			= state_wander;
	state_base		= state_wander;
	demeanour		= DEMEANOUR.AGGRESSIVE;
	chase_persist	= [3, 6];
	hp_flee_percent	= 50;
	strength		= 2;
	agility			= 4;
	hit_points		= [3, 3];
	action_speed	= 80;
	equipment		= [[item_bite, 1]];
}

#endregion




