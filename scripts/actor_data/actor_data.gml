
// DATA -------------------------------------------------------------------------------------------
function actor_player()constructor{
	name			= "Player";
	sprite			= rogue_spr;
	range			= 7;
	body_index		= BODY_PRESET.HUMANOID;
	state			= state_ready_for_inputs;
	strength		= 50;
	agility			= 10;
	hit_points		= 12;
	action_speed	= 100;
	world_x			= 0;
	world_y			= 0;
	
}

function actor_reed_weevil()constructor{
	name			= "Reed weevil";
	sprite			= reed_weevil_spr;
	range			= 6;
	body_index		= BODY_PRESET.QUADRUPED;
	demeanour		= DEMEANOUR.AGGRESSIVE;
	state			= state_idle;
	strength		= 20;
	agility			= 10;
	hit_points		= 6;
	action_speed	= 50;
}




