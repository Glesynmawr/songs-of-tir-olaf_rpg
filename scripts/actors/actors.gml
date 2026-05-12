
function spawn_actor(actor_type, cell_x, cell_y){
	
	var new_actor = new actor_type();
	
	// Inventory
	new_actor.inventory = inventory_initialise();
	
	// Replacement variables
	new_actor.x_pos		= cell_x;
	new_actor.y_pos		= cell_y;
	
	// Turn structure variables
	new_actor.energy	= 0;
	new_actor.has_acted = false;
	
	// Push to actor registry
	array_push(actor_registry.actor_list, new_actor);
	if (actor_type == actor_player){
		actor_registry.player = new_actor;
	}
}

function actor_player()constructor{
	name			= "Player";
	char			= "@";
	fg				= c_yellow;
	bg				= c_black;
	x_pos			= 0;
	y_pos			= 0;
	is_visible		= true;
	range			= 8;
	state			= state_ready_for_inputs;
	strength		= 4;
	agility			= 4;
	defence			= 2;
	hit_points		= 12;
	action_speed	= 100;
	
}

function actor_goblin()constructor{
	name			= "Goblin";
	char			= "g";
	fg				= c_lime;
	bg				= c_black;
	x_pos			= 0;
	y_pos			= 0;
	is_visible		= false;
	range			= 6;
	state			= state_idle;
	strength		= 2;
	agility			= 2;
	defence			= 0;
	hit_points		= 6;
	action_speed	= 100;
}

function actor_orc()constructor{
	name			= "Orc";
	char			= "O";
	fg				= c_teal;
	bg				= c_black;
	x_pos			= 0;
	y_pos			= 0;
	is_visible		= false;
	range			= 8;
	state			= state_idle;
	strength		= 4;
	agility			= 1;
	defence			= 2;
	hit_points		= 12;
	action_speed	= 50;
}

function actor_assassin()constructor{
	name			= "Assassin";
	char			= "A";
	fg				= c_red;
	bg				= c_black;
	x_pos			= 0;
	y_pos			= 0;
	is_visible		= false;
	range			= 6;
	state			= state_idle;
	strength		= 6;
	agility			= 3;
	defence			= 0;
	hit_points		= 8;
	action_speed	= 150;
}




