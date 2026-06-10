
function spawn_actor(actor_type, cell_x, cell_y){
	
	var new_actor = new actor_type();
	
	// Replacement variables
	new_actor.is_visible	= false;
	new_actor.x_pos			= cell_x;
	new_actor.y_pos			= cell_y;
	
	// Turn structure variables
	new_actor.energy	= 0;
	new_actor.has_acted = false;
	
	// Push to actor registry
	array_push(actor_registry.actor_list, new_actor);
	if (actor_type == actor_player){
		actor_registry.player	= new_actor;
		new_actor.is_visible	= false;
	}
	else{
		new_actor.world_x = noone;
		new_actor.world_y = noone;
	}
	
	// Inventory
	new_actor.inventory = inventory_initialise();
	new_actor.inventory.equipment = equipment_initialise(new_actor.body_plan);
	new_actor.inventory.slot_selection = noone;
}

function actor_player()constructor{
	name			= "Player";
	sprite			= [actor_spr, 0];
	fg				= c_yellow;
	range			= 8;
	body_plan		= [1, 1, 2, 2];
	state			= state_ready_for_inputs;
	strength		= 50;
	agility			= 50;
	armour			= 1;
	hit_points		= 12;
	action_speed	= 100;
	world_x			= 0;
	world_y			= 0;
	
}

function actor_goblin()constructor{
	name			= "Goblin";
	sprite			= [actor_spr, 0];
	fg				= c_lime;
	range			= 6;
	body_plan		= [1, 1, 2, 2];
	state			= state_idle;
	strength		= 20;
	agility			= 20;
	armour			= 0;
	hit_points		= 6;
	action_speed	= 100;
}

function actor_orc()constructor{
	name			= "Orc";
	sprite			= [actor_spr, 0];
	fg				= c_teal;
	range			= 8;
	body_plan		= [1, 1, 2, 2];
	state			= state_idle;
	strength		= 50;
	agility			= 20;
	armour			= 1;
	hit_points		= 12;
	action_speed	= 50;
}

function actor_assassin()constructor{
	name			= "Assassin";
	sprite			= [actor_spr, 0];
	fg				= c_red;
	range			= 6;
	body_plan		= [1, 1, 2, 2];
	state			= state_idle;
	strength		= 20;
	agility			= 50;
	armour			= 0;
	hit_points		= 8;
	action_speed	= 150;
}




