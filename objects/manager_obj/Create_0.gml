/// @desc Initialise 
globalvar debugging_mode;
debugging_mode  = false;
game_pause		= false;

// Cell positioning data
cell_x_neighbours = [1,  1,  0, -1, -1, -1, 0, 1];
cell_y_neighbours = [0, -1, -1, -1,  0,  1, 1, 1];

// Define controls
globalvar control_key;
control_key[0] = vk_numpad6;
control_key[1] = vk_numpad9;
control_key[2] = vk_numpad8;
control_key[3] = vk_numpad7;
control_key[4] = vk_numpad4;
control_key[5] = vk_numpad1;
control_key[6] = vk_numpad2;
control_key[7] = vk_numpad3;
control_key[8] = vk_numpad5;

// Sets cell size using monospaced font
draw_set_font(mono_fnt);
cell_width  = string_width("M");
cell_height = string_height("M");

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




