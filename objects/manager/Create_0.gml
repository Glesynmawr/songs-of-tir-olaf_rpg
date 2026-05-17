/// @desc Initialise 
globalvar debugging_mode;
debugging_mode  = false;
game_pause		= false;

resolution_scale();

// Cell positioning data
cell_x_neighbours = [1,  1,  0, -1, -1, -1, 0, 1];
cell_y_neighbours = [0, -1, -1, -1,  0,  1, 1, 1];
direction_indicator = noone;

// Drawing colours
text_colour = c_white;
bg_colour   = c_black;

// Define controls
globalvar controls, show_controls;
show_controls = true;
controls = {
	key_right:				vk_right,
	key_up:					vk_up,
	key_left:				vk_left,
	key_down:				vk_down,
	key_move_confirm:		vk_space,
	key_interact_confirm:	vk_enter,
	key_inventory:			ord("I"),
	key_drop:				ord("D"),
	key_cancel:				vk_escape
}

move_timer_max = 10;
move_timer = 0;

// Sets cell size using monospaced font
draw_set_font(mono_fnt);
cell_width  = 16;
cell_height = 16;

text_height = string_height("M") + 2;
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

spawn_new_item(item_sword,	1, SPAWN_LOC.INVENTORY, , , actor_registry.player);
spawn_new_item(item_shield, 1, SPAWN_LOC.INVENTORY, , , actor_registry.player);
spawn_new_item(item_armour, 1, SPAWN_LOC.INVENTORY, , , actor_registry.player);
spawn_new_item(item_helmet, 1, SPAWN_LOC.INVENTORY, , , actor_registry.player);
spawn_new_item(item_bow,	1, SPAWN_LOC.INVENTORY, , , actor_registry.player);
spawn_new_item(item_arrow,	1, SPAWN_LOC.INVENTORY, , , actor_registry.player);




