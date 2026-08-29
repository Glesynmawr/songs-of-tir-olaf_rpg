
// DATA -------------------------------------------------------------------------------------------
function actor_player()constructor{
	name			= "Player";
	sprite			= rogue_spr;
	range			= 7;
	body_plan		= [1, 1, 2, 2];
	state			= state_ready_for_inputs;
	strength		= 50;
	agility			= 10;
	armour			= 1;
	hit_points		= 12;
	action_speed	= 100;
	world_x			= 0;
	world_y			= 0;
	
}

function actor_reed_weevil()constructor{
	name			= "Reed weevil";
	sprite			= reed_weevil_spr;
	range			= 6;
	body_plan		= [1, 1, 0, 4];
	demeanour		= DEMEANOUR.AGGRESSIVE;
	state			= state_idle;
	strength		= 20;
	agility			= 0;
	armour			= 0;
	hit_points		= 6;
	action_speed	= 50;
}

