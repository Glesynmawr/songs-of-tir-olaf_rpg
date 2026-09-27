
// DATA -------------------------------------------------------------------------------------------
function actor_player()constructor{
	faction         = FACTION.PLAYER;
	name			= "Doodle";
	sprite			= rogue_spr;
	range			= 7;
	body_index		= BODY_PRESET.HUMANOID;
	state			= state_ready_for_inputs;
	state_base		= state_ready_for_inputs;
	state_react		= noone;
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
	faction         = FACTION.BIRD_PREY
	name			= "Flamingo";
	sprite			= flamingo_spr;
	range			= 6;
	body_index		= BODY_PRESET.WINGED_BIPED;
	state			= state_wander;
	state_base		= state_wander;
	state_react		= state_flee;
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
	faction         = FACTION.AMPHIBIAN_PREY;
	name			= "Marsh Frog";
	sprite			= marsh_frog_spr;
	range			= 4;
	body_index		= BODY_PRESET.QUADRUPED;
	state			= state_wander;
	state_base		= state_wander;
	state_react		= state_flee;
	demeanour		= DEMEANOUR.PASSIVE;
	chase_persist	= [0, 0];
	hp_flee_percent	= 50;
	strength		= 3;
	agility			= 3;
	hit_points		= [6, 6];
	action_speed	= 75;
	equipment		= [[item_bite, 1]];
}

function actor_marsh_turtle()constructor{
	faction         = FACTION.REPTILE_PREDATOR;
	name			= "Marsh Turtle";
	sprite			= marsh_turtle_spr;
	range			= 3;
	body_index		= BODY_PRESET.QUADRUPED;
	state			= state_idle;
	state_base		= state_idle;
	state_react		= state_chase;
	demeanour		= DEMEANOUR.AGGRESSIVE;
	chase_persist	= [3, 6];
	hp_flee_percent	= 25;
	strength		= 5;
	agility			= 2;
	hit_points		= [8, 8];
	action_speed	= 50;
	equipment		= [[item_carapace, 1], [item_bite, 1]];
}

function actor_reed_weevil()constructor{
	faction         = FACTION.AMPHIBIAN_PREY;
	name			= "Reed weevil";
	sprite			= reed_weevil_spr;
	range			= 6;
	body_index		= BODY_PRESET.QUADRUPED;
	state			= state_wander;
	state_base		= state_wander;
	state_react		= state_chase;
	demeanour		= DEMEANOUR.PASSIVE;
	chase_persist	= [3, 6];
	hp_flee_percent	= 50;
	strength		= 20;
	agility			= 10;
	hit_points		= [6, 6];
	action_speed	= 50;
	equipment		= [[item_proboscis, 1]];
}




