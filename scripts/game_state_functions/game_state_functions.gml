
// INIT STATE FUNCTIONS
function init_control_menu(){
	with (manager){
		menu_pos_reset();
		is_rebinding_keys	= false;
		current_key_rebind	= 0;
	
		new_controls[0] = controls.key_up;
		new_controls[1] = controls.key_down;
		new_controls[2] = controls.key_left;
		new_controls[3] = controls.key_right;
		new_controls[4] = controls.key_move_confirm;
		new_controls[5] = controls.key_interact_confirm;
		new_controls[6] = controls.key_look_state;
		new_controls[7] = controls.key_inventory;
		new_controls[8] = controls.key_map_mode;
		new_controls[9] = controls.key_item_swap;
				
		game_state.state_main = game_state_control_menu;
	}
}

function init_faction_list(){
	var list = [];
	
	list[FACTION.AMPHIBIAN_PREY][FACTION.AMPHIBIAN_PREY]		= 20;
	list[FACTION.AMPHIBIAN_PREY][FACTION.BIRD_PREY]				= 20;
	list[FACTION.AMPHIBIAN_PREY][FACTION.MAMMAL_PREY]			= 10;
	list[FACTION.AMPHIBIAN_PREY][FACTION.PLAYER]				= 10;
	list[FACTION.AMPHIBIAN_PREY][FACTION.REPTILE_PREDATOR]		= 10;
																 
	list[FACTION.BIRD_PREY][FACTION.AMPHIBIAN_PREY]				= 20;
	list[FACTION.BIRD_PREY][FACTION.BIRD_PREY]					= 20;
	list[FACTION.BIRD_PREY][FACTION.MAMMAL_PREY]				= 10;
	list[FACTION.BIRD_PREY][FACTION.PLAYER]						= 10;
	list[FACTION.BIRD_PREY][FACTION.REPTILE_PREDATOR]			= 10;
						
	list[FACTION.MAMMAL_PREY][FACTION.AMPHIBIAN_PREY]			= 20;
	list[FACTION.MAMMAL_PREY][FACTION.BIRD_PREY]				= 20;
	list[FACTION.MAMMAL_PREY][FACTION.MAMMAL_PREY]				= 20;
	list[FACTION.MAMMAL_PREY][FACTION.PLAYER]					= 10;
	list[FACTION.MAMMAL_PREY][FACTION.REPTILE_PREDATOR]			= 20;						
						
	list[FACTION.REPTILE_PREDATOR][FACTION.AMPHIBIAN_PREY]		= 10;
	list[FACTION.REPTILE_PREDATOR][FACTION.BIRD_PREY]			= 10;
	list[FACTION.REPTILE_PREDATOR][FACTION.MAMMAL_PREY]			= 10;
	list[FACTION.REPTILE_PREDATOR][FACTION.PLAYER]				= 10;
	list[FACTION.REPTILE_PREDATOR][FACTION.REPTILE_PREDATOR]	= 10;
	
	return(list);
}

function init_game_state(){
	
	// Actors
	actor_registry = {
		actor_list:		[],
		player:			noone,
		action_list:	[],
		action_index:	0
	}
	
	// Game states
	game_paused = false;
	game_state = {
		game_grid				: noone,
		game_log				: [],
		map_mode				: noone,
		map_borders_are_clamped	: noone,
		state_main				: noone,
		state_previous			: noone,
		world_map				: noone,
		zone_map				: noone,
	
		current_depth			: noone,
		dungeon_entry_x			: noone,
		dungeon_entry_y			: noone,
	
		direction_indicator		: noone,
		direction_indicator_x	: 0,
		direction_indicator_y	: 0,
	
		faction_list			: []
	}
}

function init_main(){
	with (manager){
		// Set resolution and scale
		resolution_scale();
	
		// Initialise game states
		menu_pos_reset();
		game_state.state_main		= noone;
		game_state.state_previous	= noone;
		control_state_previous		= noone;
		game_state.map_mode			= noone;
	
		// UI animation timer
		ui_flip				= true;
		ui_flip_timer_max	= 30;
		ui_flip_timer		= ui_flip_timer_max;
	
		// Set text font and cell size
		draw_set_font(mono_fnt);
		text_height = string_height("M") + 2;
		text_width  = string_width("M");
		cell_width  = 16;
		cell_height = 16;
	}
}
	
function init_world(){
	
	with (manager){
		
		// Initialise game state
		init_game_state()
		
		// Initialise game states
		game_state.state_main		= noone;
		game_state.state_previous	= noone;
		control_state_previous		= noone;
		game_state.map_mode			= noone;
		
		// Actor registry - Active actors only
		actor_registry = {
			actor_list:		[],
			player:			noone,
			action_list:	[],
			action_index:	0
		}
		
		// Create world and set starting map
		game_state.world_map = world_generate();
		game_state.game_grid = game_state.world_map;
	
		// Game state
		game_state.state_main = game_state_world;
	
		// Set player entry position
		entry_pos = [player_start_x, player_start_y];
																
		// Player
		spawn_new_actor(actor_rogue, entry_pos[0],   entry_pos[1], true);
		with (actor_registry.player){
			world_x			= other.entry_pos[0];
			world_y			= other.entry_pos[1];
			state			= state_ready_for_inputs;
			state_base		= state_ready_for_inputs;
			faction			= FACTION.PLAYER;
		}
		
		grid_calculate_lighting(manager.game_state.game_grid)
		set_player_los(game_state.game_grid, actor_registry.player);
	
		spawn_new_item(item_hat1,			1,  SPAWN_LOC.INVENTORY, , , actor_registry.player);
		spawn_new_item(item_hat2,			1,  SPAWN_LOC.INVENTORY, , , actor_registry.player);
		spawn_new_item(item_mask1,			1,  SPAWN_LOC.INVENTORY, , , actor_registry.player);
		spawn_new_item(item_mask2,			1,  SPAWN_LOC.INVENTORY, , , actor_registry.player);
		spawn_new_item(item_armour1,		1,  SPAWN_LOC.INVENTORY, , , actor_registry.player);
		spawn_new_item(item_armour2,		1,  SPAWN_LOC.INVENTORY, , , actor_registry.player);
		spawn_new_item(item_cloak1,			1,  SPAWN_LOC.INVENTORY, , , actor_registry.player);
		spawn_new_item(item_cloak2,			1,  SPAWN_LOC.INVENTORY, , , actor_registry.player);
		spawn_new_item(item_vambrace1,		2,  SPAWN_LOC.INVENTORY, , , actor_registry.player);
		spawn_new_item(item_vambrace2,		2,  SPAWN_LOC.INVENTORY, , , actor_registry.player);
		spawn_new_item(item_glove1,			2,  SPAWN_LOC.INVENTORY, , , actor_registry.player);
		spawn_new_item(item_glove2,			2,  SPAWN_LOC.INVENTORY, , , actor_registry.player);
		spawn_new_item(item_greave1,		2,  SPAWN_LOC.INVENTORY, , , actor_registry.player);
		spawn_new_item(item_greave2,		2,  SPAWN_LOC.INVENTORY, , , actor_registry.player);
		spawn_new_item(item_boot1,			2,  SPAWN_LOC.INVENTORY, , , actor_registry.player);
		spawn_new_item(item_boot2,			2,  SPAWN_LOC.INVENTORY, , , actor_registry.player);
		
		spawn_new_item(item_sword1,			1,  SPAWN_LOC.INVENTORY, , , actor_registry.player);
		spawn_new_item(item_sword2,			1,  SPAWN_LOC.INVENTORY, , , actor_registry.player);
		
		spawn_new_item(item_short_bow,		1,  SPAWN_LOC.INVENTORY, , , actor_registry.player);
		spawn_new_item(item_wooden_arrow,	30, SPAWN_LOC.INVENTORY, , , actor_registry.player);
		spawn_new_item(item_stone_arrow,	30, SPAWN_LOC.INVENTORY, , , actor_registry.player);
		
		actor_registry.player.inv_weight = inventory_get_weight(actor_registry.player);
		
		// Distance maps
		globalvar distance_map_player;
		distance_map_player = [];

		// Action list and turn order
		actor_registry.action_list = [];
		turn_order_initialise();
		
		game_state.faction_list = init_faction_list();
		
		// Go to world
		goto_world();
	}
}


// NOTIFICATION CONTROL
function notification_control(){
	if (keyboard_check_pressed(controls.key_interact_confirm) and notification.confirm == true){
		if (notification.action != noone){
			notification.action();
			play_sound(ui_confirm_00_snd, AUDIO_SETTINGS.SFX_GAIN);
		}
	}
	else if (keyboard_check_pressed(controls.key_cancel) and notification.cancel == true){
		play_sound(ui_cancel_00_snd, AUDIO_SETTINGS.SFX_GAIN);
		notification_reset();
	}
}


// GAME STATE FUNCTIONS
function game_state_control_menu(){
	with (manager){
		
		if (notification.text != ""){
			notification_control()
			exit;
		}
		
		if (!is_rebinding_keys){
			if (keyboard_check_pressed(controls.key_cancel)){
				play_sound(ui_cancel_00_snd, AUDIO_SETTINGS.SFX_GAIN);
				transition_set(TRANSITION.CONTROL_EXIT, colour_bg_main);
			}
			else if (keyboard_check_pressed(controls.key_up)){
				play_sound(ui_select_00_snd, AUDIO_SETTINGS.SFX_GAIN);
				control_menu_hover --;
				if (control_menu_hover < 0){
					control_menu_hover += array_length(control_menu);
				}
			}
			else if (keyboard_check_pressed(controls.key_down)){
				play_sound(ui_select_00_snd, AUDIO_SETTINGS.SFX_GAIN);
				control_menu_hover ++;
				if (control_menu_hover >= array_length(control_menu)){
					control_menu_hover -= array_length(control_menu);
				}
			}
			else if (keyboard_check_pressed(controls.key_interact_confirm)){
				play_sound(ui_confirm_00_snd, AUDIO_SETTINGS.SFX_GAIN);
				var txt = control_menu[control_menu_hover];
				if (txt == "Rebind keys"){
					for (var i = 0; i < array_length(new_controls); i ++){
						new_controls[i] = noone;
					}
					is_rebinding_keys = true;
				}
				else if (txt == "Set default keys"){
					controls = variable_clone(controls_default);
				
					new_controls[0] = controls.key_up;
					new_controls[1] = controls.key_down;
					new_controls[2] = controls.key_left;
					new_controls[3] = controls.key_right;
					new_controls[4] = controls.key_move_confirm;
					new_controls[5] = controls.key_interact_confirm;
					new_controls[6] = controls.key_look_state;
					new_controls[7] = controls.key_inventory;
					new_controls[8] = controls.key_map_mode;
					new_controls[9] = controls.key_item_swap;
				}
				else if (txt == "Save and exit"){
					play_sound(ui_confirm_00_snd, AUDIO_SETTINGS.SFX_GAIN);
					controls_save_settings();
					transition_set(TRANSITION.CONTROL_EXIT, colour_bg_main);
				}
			}
		}
		else{
			if (keyboard_check_pressed(controls.key_cancel)){
				is_rebinding_keys	= false;
				new_controls[0] = controls.key_up;
				new_controls[1] = controls.key_down;
				new_controls[2] = controls.key_left;
				new_controls[3] = controls.key_right;
				new_controls[4] = controls.key_move_confirm;
				new_controls[5] = controls.key_interact_confirm;
				new_controls[6] = controls.key_look_state;
				new_controls[7] = controls.key_inventory;
				new_controls[8] = controls.key_map_mode;
				new_controls[9] = controls.key_item_swap;
			}
		
			if (keyboard_check_pressed(vk_anykey)){
				// Check Assigned Keys for Duplicates
				var can_assign = true;
				if (keyboard_lastkey == vk_escape) can_assign = false;
				for (var i = 0; i < array_length(new_controls); i ++){
					if (new_controls[i] == keyboard_lastkey){
						play_sound(ui_cancel_00_snd, AUDIO_SETTINGS.SFX_GAIN);
						can_assign = false;
					}
				}
			
				if (can_assign){
					play_sound(ui_select_00_snd, AUDIO_SETTINGS.SFX_GAIN);
					new_controls[current_key_rebind] = keyboard_lastkey;
					current_key_rebind ++;
			
					if (current_key_rebind == array_length(new_controls)){
						play_sound(ui_confirm_00_snd, AUDIO_SETTINGS.SFX_GAIN);
						is_rebinding_keys = false;
					
						controls.key_up					= new_controls[0];
						controls.key_down				= new_controls[1];
						controls.key_left				= new_controls[2];
						controls.key_right				= new_controls[3];
						controls.key_move_confirm		= new_controls[4];
						controls.key_interact_confirm	= new_controls[5];
						controls.key_look_state			= new_controls[6];
						controls.key_inventory			= new_controls[7];
						controls.key_map_mode			= new_controls[8];
						controls.key_item_swap		   	= new_controls[9];
					}
				}
			}
		}
	}
}
	
function game_state_dungeon(){
	with (manager){
		
		if (notification.text != ""){
			notification_control()
			exit;
		}
		
		if (!game_paused and transition == noone){
			turn_order_update();
		}
	}
}
	
function game_state_game_over(){
	with (manager){
		if (notification.text != ""){
			notification_control()
			exit;
		}
		
		if (keyboard_check_pressed(controls.key_up)){
			play_sound(ui_select_00_snd, AUDIO_SETTINGS.SFX_GAIN);
			game_over_menu_hover --;
			if (game_over_menu_hover < 0){
				game_over_menu_hover += array_length(game_over_menu);
			}
		}
		else if (keyboard_check_pressed(controls.key_down)){
			play_sound(ui_select_00_snd, AUDIO_SETTINGS.SFX_GAIN);
			game_over_menu_hover ++;
			if (game_over_menu_hover >= array_length(game_over_menu)){
				game_over_menu_hover -= array_length(game_over_menu);
			}
		}
		else if (keyboard_check_pressed(controls.key_interact_confirm)){
			play_sound(ui_confirm_00_snd, AUDIO_SETTINGS.SFX_GAIN);
			var txt = game_over_menu[game_over_menu_hover];
			if (txt == "Try again"){
				transition_set(TRANSITION.GAME_START_NEW, colour_bg_main);
			}
			else if (txt == "Quit to title"){
				transition_set(TRANSITION.GAME_RESET, colour_bg_main);
			}
			else if (txt == "Quit to desktop"){
				transition_set(TRANSITION.GAME_QUIT, C_BLACK);
			}
		}
	}
}

function game_state_main_menu(){
	with (manager){
		if (notification.text != ""){
			notification_control()
			exit;
		}
		
		if (keyboard_check_pressed(controls.key_up)){
			play_sound(ui_select_00_snd, AUDIO_SETTINGS.SFX_GAIN);
			main_menu_hover --;
			if (main_menu_hover < 0){
				main_menu_hover += array_length(main_menu);
			}
		}
		else if (keyboard_check_pressed(controls.key_down)){
			play_sound(ui_select_00_snd, AUDIO_SETTINGS.SFX_GAIN);
			main_menu_hover ++;
			if (main_menu_hover >= array_length(main_menu)){
				main_menu_hover -= array_length(main_menu);
			}
		}
		else if (keyboard_check_pressed(controls.key_interact_confirm)){
			play_sound(ui_confirm_00_snd, AUDIO_SETTINGS.SFX_GAIN);
			var txt = main_menu[main_menu_hover];
			if (txt == "New game"){
				transition_set(TRANSITION.GAME_START_NEW, colour_bg_main);
			}
			else if (txt == "Load game"){
				if (file_exists("game_save")){
					transition_set(TRANSITION.GAME_LOAD, colour_bg_main);
				}
				else{
					// No save file found
					var txt = "No save file found.";
					var xx = screen_width / 2;
					var yy = screen_height / 2;
					create_notification(txt, xx, yy, true, false);
				}
			}
			else if (txt == "Controls"){
				game_state.state_previous = game_state.state_main;
				transition_set(TRANSITION.CONTROL_MENU, colour_bg_main);
			}
			else if (txt == "Settings"){
			
			}
			else if (txt == "Quit to desktop"){
				transition_set(TRANSITION.GAME_QUIT, C_BLACK);
			}
		}
	}
}

function game_state_pause_menu(){
	with (manager){
		
		if (notification.text != ""){
			notification_control()
			exit;
		}
		
		if (keyboard_check_pressed(controls.key_cancel)){
			play_sound(ui_cancel_00_snd, AUDIO_SETTINGS.SFX_GAIN);
			game_state.state_main = game_state.state_previous;
		}
		else if (keyboard_check_pressed(controls.key_up)){
			play_sound(ui_select_00_snd, AUDIO_SETTINGS.SFX_GAIN);
			pause_menu_hover --;
			if (pause_menu_hover < 0){
				pause_menu_hover += array_length(pause_menu);
			}
		}
		else if (keyboard_check_pressed(controls.key_down)){
			play_sound(ui_select_00_snd, AUDIO_SETTINGS.SFX_GAIN);
			pause_menu_hover ++;
			if (pause_menu_hover >= array_length(pause_menu)){
				pause_menu_hover -= array_length(pause_menu);
			}
		}
		else if (keyboard_check_pressed(controls.key_interact_confirm)){
			play_sound(ui_confirm_00_snd, AUDIO_SETTINGS.SFX_GAIN);
			var txt = pause_menu[pause_menu_hover];
			if (txt == "Continue"){
				game_state.state_main = game_state.state_previous;
			}
			else if (txt == "Controls"){
				transition_set(TRANSITION.CONTROL_MENU, colour_bg_main);
			}
			else if (txt == "Settings"){
			
			}
			else if (txt == "Save and quit"){
				game_save_all();
				transition_set(TRANSITION.GAME_BOOT, colour_bg_main);
			}
			else if (txt == "Quit without saving"){
				transition_set(TRANSITION.GAME_BOOT, colour_bg_main);
			}
			else if (txt == "Quit to desktop"){
				transition_set(TRANSITION.GAME_QUIT, C_BLACK);
			}
		}
	}
}

function game_state_world(){
	with (manager){
		
		if (notification.text != ""){
			notification_control()
			exit;
		}
		
		if (!game_paused and transition == noone){
			turn_order_update();
		}
	}
}


// LOCATION GOTO FUNCTIONS
function goto_dungeon(dungeon_id, is_descending){
	with (manager){
		var world_x = actor_registry.player.world_x;
		var world_y = actor_registry.player.world_y;

		// Exit dungeon
		if (game_state.current_depth < 0){
			transition_set(TRANSITION.GAME_DUNGEON_EXIT, C_BLACK);
			exit;
		}

		// reset actor and action lists
		actor_list_clear_all(false);
		action_list_clear_all(false);
	
		// Set game grid
		var new_dungeon = game_state.zone_map[world_x][world_y][game_state.dungeon_entry_x][game_state.dungeon_entry_y].dungeon_list[game_state.current_depth];
		if (new_dungeon == noone){
			var new_dungeon = dungeon_generate(dungeon_id);
			game_state.zone_map[world_x][world_y][game_state.dungeon_entry_x][game_state.dungeon_entry_y].dungeon_list[game_state.current_depth] = new_dungeon;
		}
	
		game_state.game_grid	= new_dungeon[0];
		game_state.map_mode	= MAP_MODE.DUNGEON;
		game_state.door_index  = new_dungeon[3];
		ui_settings.game_grid_cells_width	= MAP_WIDTH;
		ui_settings.game_grid_cells_height	= MAP_HEIGHT;
	
		// Set player position
		if (is_descending == true){
			actor_registry.player.x_pos = new_dungeon[1][0];
			actor_registry.player.y_pos = new_dungeon[1][1];
		}
		else{
			actor_registry.player.x_pos = new_dungeon[2][0];
			actor_registry.player.y_pos = new_dungeon[2][1];
		}
		actor_set_sprite_pos(actor_registry.player);
	
		// Set camera bounds
		game_state.map_borders_are_clamped = false;
	
		// Set game state
		game_state.state_main = game_state_dungeon;
		
		// Spawn mobs
		if (game_state.mobs_to_spawn != noone){
			map_spawn_mobs(game_state.mobs_to_spawn, 0);
		}
		
		// Update player LOS
		grid_calculate_lighting(manager.game_state.game_grid);
		set_player_los(game_state.game_grid, actor_registry.player);
	
		// Update Minimap text
		ui_settings.minimap_title_text = dungeons[game_state.dungeon_index].name;
		ui_settings.minimap_sub_text   = "Level: " + string(game_state.current_depth + 1);
	
		// Set time_system.timescale
		time_system.timescale	= timescale_zone;
		time_system.map_is_underground		= true;
		world_update_lighting();
	}
}

function goto_world(){
	with (manager){
		// reset actor and action lists
		actor_list_clear_all(false);
		action_list_clear_all(false);
	
		// Set game grid
		game_state.game_grid = game_state.world_map;
		game_state.map_mode  = MAP_MODE.WORLD;
		ui_settings.game_grid_cells_width	= WORLD_WIDTH;
		ui_settings.game_grid_cells_height	= WORLD_HEIGHT;
	
		// Set player position
		actor_registry.player.x_pos = actor_registry.player.world_x;
		actor_registry.player.y_pos = actor_registry.player.world_y;
	
		actor_set_sprite_pos(actor_registry.player);
	
		// Set camera bounds
		game_state.map_borders_are_clamped = true;
	
		// Set game state
		game_state.state_main = game_state_world;
	
		// Update player LOS
		grid_calculate_lighting(manager.game_state.game_grid);
		set_player_los(game_state.game_grid, actor_registry.player);
	
		// Update Minimap text
		ui_settings.minimap_title_text = "Tir Olaf";
		ui_settings.minimap_sub_text  = "";
	
		// Set time_system.timescale
		time_system.timescale = timescale_world;
		time_system.map_is_underground  = false;
		world_update_lighting();
	}
}

function goto_zone(world_x, world_y, entry_x, entry_y){
	with (manager){
		// reset actor and action lists
		actor_list_clear_all(false);
		action_list_clear_all(false);
	
		// Set game grid
		if (game_state.zone_map[world_x][world_y] == noone){
			game_state.zone_map[world_x][world_y] = zone_map_generate(game_state.world_map, world_x, world_y);
			initialise_item_grid(game_state.zone_map[world_x][world_y], ZONE_SIZE, ZONE_SIZE);
		}
		game_state.game_grid	= game_state.zone_map[world_x][world_y];
		game_state.map_mode		= MAP_MODE.ZONE;
		ui_settings.game_grid_cells_width	= MAP_WIDTH;
		ui_settings.game_grid_cells_height	= MAP_HEIGHT;
	
		// Set player position
		actor_registry.player.x_pos = entry_x;
		actor_registry.player.y_pos = entry_y;
	
		actor_set_sprite_pos(actor_registry.player);
	
		// Set camera bounds
		game_state.map_borders_are_clamped = true;
	
		// Set game state
		game_state.state_main = game_state_dungeon;
	
		// Spawn mobs
		var b = game_state.world_map[world_x][world_y].biome;
		if (mob_lookup[b][MOB_LOOKUP.ZONE] != noone){
			map_spawn_mobs(mob_lookup[b][MOB_LOOKUP.ZONE], 5);
		}
	
		// Update player LOS
		grid_calculate_lighting(manager.game_state.game_grid);
		set_player_los(game_state.game_grid, actor_registry.player);
		
		// Update Minimap text
		ui_settings.minimap_title_text = world_grid[world_x][world_y].tile;
		ui_settings.minimap_sub_text  = "";
		
		// Set time_system.timescale
		time_system.timescale = timescale_zone;
		time_system.map_is_underground  = false;
		world_update_lighting();
	}
}


// MOB SPAWNING
function map_spawn_mobs(lookup_table, spawn_border){
	
	// Set number of mobs to spawn
	var mob_count = irandom_range(ceil(lookup_table[0] / 2), lookup_table[0]);
	
	// Get width and height of game grid
	var width  = array_length(manager.game_state.game_grid);
	var height = array_length(manager.game_state.game_grid[0]);
	
	repeat(mob_count){

		var table_to_use = lookup_table;

		var random_mob = random(1);
		if (random_mob <= 0.02){
			var random_biome = irandom(array_length(mob_lookup) - 1);
			var random_type  = irandom(array_length(mob_lookup[random_biome]) - 1);
			
			table_to_use = mob_lookup[random_biome][random_type];
		}
		if (table_to_use == noone){
			continue;
		}
		
		// Choose a mob
		var mob_roll = irandom(100);
		for (var i = 1; i < array_length(table_to_use); i ++){
			if (mob_roll <= table_to_use[i][1]){
				var actor_to_spawn		= spawn_new_actor(table_to_use[i][0], noone, noone);
				
				var actor_spawn_tile = noone;
				if (table_to_use == lookup_table){
					actor_spawn_tile = actor_to_spawn.spawn_tile;
				}
				break;
			}
		}
		
		// Find valid candidate positions
		var candidate_list = [];
		for (var cell_x = spawn_border; cell_x < width - spawn_border; cell_x ++){
			for (var cell_y = spawn_border; cell_y < height - spawn_border; cell_y ++){
				var cell_type = manager.game_state.game_grid[cell_x][cell_y].tile;
				
				if (actor_spawn_tile != noone){
					if (cell_type == actor_spawn_tile){
						array_push(candidate_list, [cell_x, cell_y]);
					}
				}
				else{
					array_push(candidate_list, [cell_x, cell_y]);
				}
			}
			
			var len = array_length(candidate_list);
			if (len > 0){
				var choice = irandom(len - 1);
				var xx = candidate_list[choice][0];
				var yy = candidate_list[choice][1];
				actor_to_spawn.x_pos			= xx;
				actor_to_spawn.y_pos			= yy;
				actor_to_spawn.sprite_x			= xx * cell_width;
				actor_to_spawn.sprite_y			= yy * cell_height;
				actor_to_spawn.sprite_target_x	= xx * cell_width;
				actor_to_spawn.sprite_target_y	= yy * cell_height;
				actor_to_spawn.xscale			= choose(1, -1);
			}
		}
	}
}




