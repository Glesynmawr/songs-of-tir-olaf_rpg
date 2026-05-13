/// @desc Initialise 
globalvar debugging_mode;
debugging_mode  = false;
game_pause		= false;

// Cell positioning data
cell_x_neighbours = [1,  1,  0, -1, -1, -1, 0, 1];
cell_y_neighbours = [0, -1, -1, -1,  0,  1, 1, 1];
direction_indicator = noone;

// Define controls
globalvar control_key;
control_key[0]  = vk_numpad6;
control_key[1]  = vk_numpad9;
control_key[2]  = vk_numpad8;
control_key[3]  = vk_numpad7;
control_key[4]  = vk_numpad4;
control_key[5]  = vk_numpad1;
control_key[6]  = vk_numpad2;
control_key[7]  = vk_numpad3;
control_key[8]  = vk_numpad5;
control_key[9]  = ord("I");
control_key[10] = ord("D");
control_key[11] = ord("E");

globalvar controls;
controls = {
	key_r:			vk_right,
	key_u:			vk_up,
	key_l:			vk_left,
	key_d:			vk_down,
	key_confirm:	vk_space,
	key_interact:	vk_enter,
	key_inv:		ord("I"),
	key_drop:		ord("D")
}

// Sets cell size using monospaced font
draw_set_font(mono_fnt);
cell_width  = 24;
cell_height = 32;

text_height = string_height("M");
text_width  = string_width("M");

// Set distance maps
globalvar distance_map_player;
distance_map_player = [];

// Initialise game log
initialise_log();

// Level generation
generate_dungeon();

// Spawn Player
actor_registry = {
	actor_list:	[],
	player:		noone
}
spawn_actor(actor_player, entry_pos[0],   entry_pos[1]);
distance_map_player = create_distance_map(entry_pos[0],   entry_pos[1]);


// Spawn mobs
spawn_actor(actor_goblin,	entry_pos[0]-3,   entry_pos[1]-2);
spawn_actor(actor_orc,		entry_pos[0],     entry_pos[1]-2);
spawn_actor(actor_assassin, entry_pos[0]-4,   entry_pos[1]-5);


set_player_los(game_grid, actor_registry.player);
initialise_camera(actor_registry.player);


action_list = [];
turn_order_initialise();

spawn_item(item_sword,	1, SPAWN_LOC.INVENTORY, , , actor_registry.player);
spawn_item(item_shield, 1, SPAWN_LOC.INVENTORY, , , actor_registry.player);
spawn_item(item_armour, 1, SPAWN_LOC.INVENTORY, , , actor_registry.player);
spawn_item(item_helmet, 1, SPAWN_LOC.INVENTORY, , , actor_registry.player);
spawn_item(item_bow,	1, SPAWN_LOC.INVENTORY, , , actor_registry.player);
spawn_item(item_arrow,	1, SPAWN_LOC.INVENTORY, , , actor_registry.player);




