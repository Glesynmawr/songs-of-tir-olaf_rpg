
// PLAYER ACTORS ----------------------------------------------------------------------------------

function actor_rogue()constructor{
	spawn_tile		= noone;
	faction         = FACTION.PLAYER;
	name			= "Doodle";
	sprite			= rogue_spr;
	body_index		= BODY_PRESET.HUMANOID;
	handedness		= [2, 0];
	
	strength		= 5;
	agility			= 5;
	toughness		= 5;
	intelligence	= 5;
	
	hit_points		= 12;
	action_speed	= 100;
	range			= 4;
	react_range		= 0;
	
	state			= state_wander;
	state_base		= state_wander;
	demeanour		= DEMEANOUR.PASSIVE;
	
	equipment		= [];
	world_x			= 0;
	world_y			= 0;
}

#region// MARSH  ZONE -----------------------------------------------------------------------------

function actor_flamingo()constructor{
	spawn_tile		= noone;
	faction         = FACTION.BIRD_PREY
	name			= "Flamingo";
	sprite			= flamingo_spr;
	body_index		= BODY_PRESET.WINGED_BIPED;
	handedness		= [0, 0];
	
	strength		= 2;
	agility			= 5;
	toughness		= 2;
	intelligence	= 2;
	
	action_speed	= 100;
	range			= 6;
	react_range		= 5;
	
	state			= state_wander;
	state_base		= state_wander;
	demeanour		= DEMEANOUR.TIMID;
	
	equipment		= [[item_beak, 1], [item_wings, 1]];
	world_x			= noone;
	world_y			= noone;
}

function actor_marsh_frog()constructor{
	spawn_tile		= "water";
	faction         = FACTION.AMPHIBIAN_PREY;
	name			= "Marsh Frog";
	sprite			= marsh_frog_spr;
	body_index		= BODY_PRESET.QUADRUPED;
	handedness		= [0, 0];
	
	strength		= 3;
	agility			= 3;
	toughness		= 2;
	intelligence	= 2;
	
	action_speed	= 100;
	range			= 2;
	react_range		= 2;
	
	state			= state_wander;
	state_base		= state_wander;
	demeanour		= DEMEANOUR.PASSIVE;
	
	equipment		= [[item_weak_bite, 1]];
	world_x			= noone;
	world_y			= noone;
}

function actor_marsh_turtle()constructor{
	spawn_tile		= noone;
	faction         = FACTION.REPTILE_PREDATOR;
	name			= "Marsh Turtle";
	sprite			= marsh_turtle_spr;
	body_index		= BODY_PRESET.QUADRUPED;
	handedness		= [0, 0];
	
	strength		= 6;
	agility			= 2;
	toughness		= 8;
	intelligence	= 2;
	
	action_speed	= 75;
	range			= 2;
	react_range		= 2;
	
	state			= state_wander;
	state_base		= state_wander;
	demeanour		= DEMEANOUR.AGGRESSIVE;
	
	equipment		= [[item_carapace, 1], [item_weak_bite, 1]];
	world_x			= noone;
	world_y			= noone;
}

#endregion

#region// MARSH DUNGEON ---------------------------------------------------------------------------

function actor_reed_weevil()constructor{
	spawn_tile		= "room";
	faction         = FACTION.AMPHIBIAN_PREY;
	name			= "Reed weevil";
	sprite			= reed_weevil_spr;
	body_index		= BODY_PRESET.QUADRUPED;
	handedness		= [0, 0];
	
	strength		= 1;
	agility			= 2;
	toughness		= 5;
	intelligence	= 2;
	
	action_speed	= 75;
	range			= 3;
	react_range		= 3;
	
	state			= state_wander;
	state_base		= state_wander;
	demeanour		= DEMEANOUR.PASSIVE;
	
	equipment		= [[item_proboscis, 1]];
	world_x			= noone;
	world_y			= noone;
}

function actor_marsh_bat()constructor{
	spawn_tile		= "room";
	faction         = FACTION.MAMMAL_PREY;
	name			= "Marsh bat";
	sprite			= bat_spr;
	body_index		= BODY_PRESET.WINGED_BIPED;
	handedness		= [0, 0];
	
	strength		= 1;
	agility			= 6;
	toughness		= 1;
	intelligence	= 2;
	
	action_speed	= 120;
	range			= 6;
	react_range		= 6;
	
	state			= state_wander;
	state_base		= state_wander;
	demeanour		= DEMEANOUR.AGGRESSIVE;
	
	equipment		= [[item_wings, 1], [item_weak_bite, 1]];
	world_x			= noone;
	world_y			= noone;
}

function actor_marsh_rat()constructor{
	spawn_tile		= "room";
	faction         = FACTION.MAMMAL_PREY;
	name			= "Marsh rat";
	sprite			= rat_spr;
	body_index		= BODY_PRESET.QUADRUPED;
	handedness		= [0, 0];
	
	strength		= 2;
	agility			= 4;
	toughness		= 2;
	intelligence	= 2;
	
	action_speed	= 100;
	range			= 4;
	react_range		= 4;
	
	state			= state_wander;
	state_base		= state_wander;
	demeanour		= DEMEANOUR.AGGRESSIVE;
	
	equipment		= [[item_weak_bite, 1]];
	world_x			= noone;
	world_y			= noone;
}

#endregion




