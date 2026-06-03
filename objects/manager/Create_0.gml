/// @desc Initialise 

debugging_mode		= false;
game_paused			= false;

// Colours
text_colour = C_PEACH;
bg_colour   = C_BLACK;

// STATE TRANSITION
transition = noone;

#region// MENUS -----------------------------------------------------------------------------------
control_menu_hover = 0;
control_menu[0] = "Rebind keys";
control_menu[1] = "Set default keys";
control_menu[2] = "Save and exit";

game_over_menu_hover = 0;
game_over_menu[0] = "Try again";
game_over_menu[1] = "Quit to title";
game_over_menu[2] = "Quit to desktop";

main_menu_hover = 0;
main_menu[0] = "New game";
main_menu[1] = "Load game";
main_menu[2] = "Controls";
main_menu[3] = "Settings";
main_menu[4] = "Quit to desktop";

pause_menu_hover = 0;
pause_menu[0] = "Continue";
pause_menu[1] = "Controls";
pause_menu[2] = "Settings";
pause_menu[3] = "Save and quit";
pause_menu[4] = "Quit without saving";
pause_menu[5] = "Quit to desktop";

#endregion

#region// SET CONTRLS------------------------------------------------------------------------------
globalvar controls;
show_controls = true;

controls_default = {
	key_right: vk_right,
	key_up: vk_up,
	key_left: vk_left,
	key_down: vk_down,
	key_move_confirm: vk_space,
	key_interact_confirm: vk_enter,
	key_inventory: ord("I"),
	key_cancel: vk_escape
}

controls_read_settings();

move_timer_max = 10;
move_timer = 0;

#endregion

init_main();

// Cell positioning data
cell_x_neighbours = [1,  1,  0, -1, -1, -1, 0, 1];
cell_y_neighbours = [0, -1, -1, -1,  0,  1, 1, 1];
direction_indicator = noone;





// Actor equipment
equip_data[EQUIP.HEAD] = ["head", "headwear",			3];
equip_data[EQUIP.NECK] = ["neck", "necklace",			3];
equip_data[EQUIP.BODY] = ["body", "armour",				1];
equip_data[EQUIP.BACK] = ["back", "cloak",				1];
equip_data[EQUIP.ARMS] = ["arm", "Vambrace",			6];
equip_data[EQUIP.HAND] = ["hand", "Item",				6];
equip_data[EQUIP.MITT] = ["gloves", "Gloves",		 	3];
equip_data[EQUIP.GUNS] = ["ranged item", "Ranged item",	2];
equip_data[EQUIP.FEET] = ["feet", "Footwear",	 		3];


// Sets cell size using monospaced font
draw_set_font(mono_fnt);
cell_width  = 16;
cell_height = 16;

text_height = string_height("M") + 2;
text_width  = string_width("M");

// Game log
log_height = (LOG_MAX_ENTRIES + 2) * text_height;

// Minimap
minimap_scale	= 2;
minimap_surface = noone;
minimap_width	= 96;
minimap_height	= 96;
minimap_x		= screen_width - minimap_width;
minimap_y		= 0;

// Level Sprite Indices
door_index = 0;
floor_sprite = floor_00_spr;

// Set distance maps
globalvar distance_map_player;
distance_map_player = [];

// Initialise game log
initialise_log();

// World generation
world_generate();

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
//spawn_actor(actor_goblin,	entry_pos[0]-3,   entry_pos[1]-2);
//spawn_actor(actor_orc,		entry_pos[0],     entry_pos[1]-2);
//spawn_actor(actor_assassin, entry_pos[0]-4,   entry_pos[1]-5);


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




