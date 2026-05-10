
function spawn_actor(actor_type, cell_x, cell_y){
	
	var new_actor = new actor_type();
	
	new_actor.x_pos = cell_x;
	new_actor.y_pos = cell_y;
	
	array_push(actor_registry.actor_list, new_actor);
	if (actor_type == actor_player){
		actor_registry.player = new_actor;
	}
}

function actor_player()constructor{
	name		= "Player";
	char		= "@";
	fg			= c_yellow;
	bg			= c_black;
	x_pos		= 0;
	y_pos		= 0;
	is_visible  = true;
	range		= 8;
	state		= state_ready_for_inputs;
}

function actor_goblin()constructor{
	name		= "Goblin";
	char		= "g";
	fg			= c_lime;
	bg			= c_black;
	x_pos		= 0;
	y_pos		= 0;
	is_visible  = false;
	range		= 6;
	state		= state_idle;
}


