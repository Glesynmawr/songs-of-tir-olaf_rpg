
// ANIMATION --------------------------------------------------------------------------------------
function actor_animate(){
	image_index += image_speed;
	if (image_index >= sprite_get_number(sprite)) image_index -= sprite_get_number(sprite);
	return(image_index);
}

function actors_move_sprite(){
	for (var i = 0; i < array_length(actor_registry.actor_list); i ++){
		with (actor_registry.actor_list[i]){
			if (sprite_x != sprite_target_x){
				sprite_x += (sprite_target_x - sprite_x) * manager.actor_move_speed;
			}
			if (sprite_y != sprite_target_y){
				sprite_y += (sprite_target_y - sprite_y) * manager.actor_move_speed;
			}
		}
	}
}

// SPAWNING	 --------------------------------------------------------------------------------------
function spawn_new_actor(actor_type, cell_x, cell_y){
	
	var new_actor = new actor_type();
	
	// Replacement variables
	new_actor.is_visible	= false;
	new_actor.x_pos			= cell_x;
	new_actor.y_pos			= cell_y;
	
	new_actor.colour_fg		= noone;
	new_actor.colour_bg		= noone;
	new_actor.colour_timer  = 0;
	
	// Sprite and Animation
	new_actor.sprite_x			= cell_x * cell_width;
	new_actor.sprite_y			= cell_y * cell_height;
	new_actor.sprite_target_x	= cell_x * cell_width;
	new_actor.sprite_target_y	= cell_y * cell_height;
	
	new_actor.image_index		= irandom(new_actor.sprite);
	new_actor.image_speed		= sprite_get_speed(new_actor.sprite) / game_get_speed(gamespeed_fps);
	new_actor.xscale			= 1;
	
	// Turn structure variables
	new_actor.energy	= 0;
	new_actor.has_acted = false;
	
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
	
	// Push to actor registry
	array_push(actor_registry.actor_list, new_actor);
}

function spawn_actor_to_zone_list(actor_type, cell_x, cell_y){
	var new_actor = new actor_type();
	
	// Replacement variables
	new_actor.is_visible	= false;
	new_actor.x_pos			= cell_x;
	new_actor.y_pos			= cell_y;
	
	new_actor.colour_fg		= noone;
	new_actor.colour_bg		= noone;
	new_actor.colour_timer  = 0;
	
	// Sprite and Animation
	new_actor.sprite_x			= cell_x * cell_width;
	new_actor.sprite_y			= cell_y * cell_height;
	new_actor.sprite_target_x	= cell_x * cell_width;
	new_actor.sprite_target_y	= cell_y * cell_height;
	
	new_actor.image_index		= irandom(new_actor.sprite);
	new_actor.image_speed		= sprite_get_speed(new_actor.sprite) / game_get_speed(gamespeed_fps);
	new_actor.xscale			= 1;
	
	// Turn structure variables
	new_actor.energy	= 0;
	new_actor.has_acted = false;
	
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
	
	return(new_actor);
}

// DESPAWNING -------------------------------------------------------------------------------------
function action_list_clear_all(include_player){
	if (include_player){
		array_resize(manager.action_list, 0);
	}
	else{
		array_resize(manager.action_list, 1);
	}
}

function actor_list_clear_all(include_player){
	if (include_player){
		array_resize(manager.actor_registry.actor_list, 0);
	}
	else{
		array_resize(manager.actor_registry.actor_list, 1);
	}
}

// EFFECTS ----------------------------------------------------------------------------------------
function set_colour_flash(actor, colour, duration){
	with (actor){
		colour_fg		= colour;
		colour_timer	= duration;
	}
}

function flash_timer_reduce(){

	if (colour_timer > 0){
		colour_timer --;
		if (colour_timer <= 0){
			colour_fg = noone;
		}
	}
}

// DATA -------------------------------------------------------------------------------------------
function actor_player()constructor{
	name			= "Player";
	sprite			= rogue_spr;
	range			= 7;
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

function actor_reed_weevil()constructor{
	name			= "Reed weevil";
	sprite			= reed_weevil_spr;
	range			= 6;
	body_plan		= [1, 1, 0, 4];
	demeanour		= DEMEANOUR.TIMID;
	state			= state_idle;
	strength		= 20;
	agility			= 20;
	armour			= 0;
	hit_points		= 6;
	action_speed	= 100;
}

function actor_orc()constructor{
	name			= "Leech";
	sprite			= leech_spr;
	range			= 8;
	body_plan		= [1, 1, 2, 2];
	demeanour		= DEMEANOUR.AMBUSH;
	state			= state_idle;
	strength		= 50;
	agility			= 20;
	armour			= 1;
	hit_points		= 12;
	action_speed	= 50;
}

function actor_assassin()constructor{
	name			= "Dragonfly";
	sprite			= dragonfly_spr;
	range			= 6;
	body_plan		= [1, 1, 2, 2];
	demeanour		= DEMEANOUR.AGGRESSIVE;
	state			= state_idle;
	strength		= 20;
	agility			= 50;
	armour			= 0;
	hit_points		= 8;
	action_speed	= 150;
}




