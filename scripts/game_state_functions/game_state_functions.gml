
// INIT STATE FUNCTIONS
function init_control_menu(){
	is_rebinding_keys	= false;
	current_key_rebind	= 0;
	
	new_controls[0] = controls.key_up;
	new_controls[1] = controls.key_down;
	new_controls[2] = controls.key_left;
	new_controls[3] = controls.key_right;
	new_controls[4] = controls.key_move_confirm;
	new_controls[5] = controls.key_interact_confirm;
	new_controls[6] = controls.key_inventory;
	
	game_state = game_state_control_menu;
}

function init_main(){
	
	// Set resolution and scale
	resolution_scale();
	
	// Initialise camera limits
	camera_min_x = 0;
	camera_max_x = 0;
	camera_min_y = 0;
	camera_max_y = 0;
	
	// Initialise game states
	game_state				= noone;
	game_state_previous		= noone;
	control_state_previous	= noone;
	map_mode				= noone;
	
	// UI animation timer
	ui_flip				= true;
	ui_flip_timer_max	= 30;
	ui_flip_timer		= ui_flip_timer_max;
	
	// Set text font and cell size
	draw_set_font(mono_fnt);
	cell_width  = 16;
	cell_height = 16;
	
	// Transition into initial room
	transition_set(TRANSITION.GAME_BOOT, C_BLACK);
}
	
function init_world(){
	// Create world and set starting map
	world_map = world_generate();
	game_grid = world_map;
	
	// Set player entry position
	entry_pos = [0, 0];
																
	// Player
	spawn_new_actor(actor_player, entry_pos[0],   entry_pos[1]);
	set_player_los(game_grid, actor_registry.player);

	// Game log
	initialise_log();

	// Distance maps
	globalvar distance_map_player;
	distance_map_player = [];

	// Move speed - multiplier
	actor_move_speed = 0.2;

	// Actoion list and turn order
	action_list = [];
	turn_order_initialise();
}


// GAME STATE FUNCTIONS
function game_state_character_select(){
	
}

function game_state_control_menu(){
	if (!is_rebinding_keys){
		if (keyboard_check_pressed(controls.key_cancel)){
			transition_set(TRANSITION.CONTROL_EXIT, colour_bg_main);
		}
		else if (keyboard_check_pressed(controls.key_up)){
			control_menu_hover --;
			if (control_menu_hover < 0){
				control_menu_hover += array_length(control_menu);
			}
		}
		else if (keyboard_check_pressed(controls.key_down)){
			control_menu_hover ++;
			if (control_menu_hover >= array_length(control_menu)){
				control_menu_hover -= array_length(control_menu);
			}
		}
		else if (keyboard_check_pressed(controls.key_interact_confirm)){
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
				new_controls[6] = controls.key_inventory;
			}
			else if (txt == "Save and exit"){
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
			new_controls[6] = controls.key_inventory;
		}
		
		if (keyboard_check_pressed(vk_anykey)){
			// Check Assigned Keys for Duplicates
			var can_assign = true;
			if (keyboard_lastkey == vk_escape) can_assign = false;
			for (var i = 0; i < array_length(new_controls); i ++){
				if (new_controls[i] == keyboard_lastkey){
					can_assign = false;
				}
			}
			
			if (can_assign){

				new_controls[current_key_rebind] = keyboard_lastkey;
				current_key_rebind ++;
			
				if (current_key_rebind == array_length(new_controls)){
					is_rebinding_keys = false;
					
					controls.key_up					= new_controls[0];
					controls.key_down				= new_controls[1];
					controls.key_left				= new_controls[2];
					controls.key_right				= new_controls[3];
					controls.key_move_confirm		= new_controls[4];
					controls.key_interact_confirm	= new_controls[5];
					controls.key_inventory			= new_controls[6];
				}
			}
		}
	}
}
	
function game_state_dungeon(){
	if (!game_paused and transition == noone){
		turn_order_update();
	}
}

function game_state_main_menu(){
	if (keyboard_check_pressed(controls.key_up)){
		main_menu_hover --;
		if (main_menu_hover < 0){
			main_menu_hover += array_length(main_menu);
		}
	}
	else if (keyboard_check_pressed(controls.key_down)){
		main_menu_hover ++;
		if (main_menu_hover >= array_length(main_menu)){
			main_menu_hover -= array_length(main_menu);
		}
	}
	else if (keyboard_check_pressed(controls.key_interact_confirm)){
		var txt = main_menu[main_menu_hover];
		if (txt == "New game"){
			transition_set(TRANSITION.GAME_WORLD, colour_bg_main);
		}
		else if (txt == "Load game"){
			
		}
		else if (txt == "Controls"){
			game_state_previous = game_state;
			transition_set(TRANSITION.CONTROL_MENU, colour_bg_main);
		}
		else if (txt == "Settings"){
			
		}
		else if (txt == "Quit to desktop"){
			transition_set(TRANSITION.GAME_QUIT, C_BLACK);
		}
	}
}

function game_state_pause_menu(){
	if (keyboard_check_pressed(controls.key_cancel)){
		game_state = game_state_previous;
	}
	else if (keyboard_check_pressed(controls.key_up)){
		pause_menu_hover --;
		if (pause_menu_hover < 0){
			pause_menu_hover += array_length(pause_menu);
		}
	}
	else if (keyboard_check_pressed(controls.key_down)){
		pause_menu_hover ++;
		if (pause_menu_hover >= array_length(pause_menu)){
			pause_menu_hover -= array_length(pause_menu);
		}
	}
	else if (keyboard_check_pressed(controls.key_interact_confirm)){
		var txt = pause_menu[pause_menu_hover];
		if (txt == "Continue"){
			game_state = game_state_previous;
		}
		else if (txt == "Controls"){
			transition_set(TRANSITION.CONTROL_MENU, colour_bg_main);
		}
		else if (txt == "Settings"){
			
		}
		else if (txt == "Save and quit"){
			
		}
		else if (txt == "Quit without saving"){
			transition_set(TRANSITION.GAME_BOOT, colour_bg_main);
		}
		else if (txt == "Quit to desktop"){
			transition_set(TRANSITION.GAME_QUIT, C_BLACK);
		}
	}
}

function game_state_world(){
	if (!game_paused and transition == noone){
		turn_order_update();
	}
}


// LOCATION GOTO FUNCTIONS
function goto_dungeon(dungeon_id, is_descending = true){
	
	if (is_descending) current_depth ++ else current_depth --
	
	// reset actor and action lists
	actor_list_clear_all(false);
	action_list_clear_all(false);
	
	// Set game grid
	dungeon_map = dungeon_generate(0); //  Replace 0 with dungeon type id
	game_grid	= dungeon_map;
	map_mode	= MAP_MODE.DUNGEON;
	
	// Set player position
	
	// Set camera bounds
	camera_min_x = -(array_length(game_grid) * cell_width);
	camera_max_x = array_length(game_grid) * cell_width;
	camera_min_y = -(array_length(game_grid[0]) * cell_height);
	camera_max_y = array_length(game_grid[0]) * cell_height;
	
	// Set game state
	game_state = game_state_dungeon;
	
	// Update player LOS
	set_player_los(game_grid, actor_registry.player);
}

function goto_world(){
	
	// reset actor and action lists
	actor_list_clear_all(false);
	action_list_clear_all(false);
	
	// Set game grid
	game_grid = world_map;
	var grid_w = array_length(game_grid);
	var grid_h = array_length(game_grid[0]);
	map_mode  = MAP_MODE.WORLD;
	
	// Set player position
	actor_registry.player.x_pos = actor_registry.player.world_x;
	actor_registry.player.y_pos = actor_registry.player.world_y;
	
	player_set_sprite_pos(actor_registry.player);
	
	// Set camera bounds
	camera_min_x = -ui_width;
	camera_max_x = max(((grid_w * cell_width) - screen_width) + ui_width, -ui_width);
	camera_min_y = 0;
	camera_max_y = max(((grid_h * cell_height) - screen_height) + log_height, 0);
	
	// Set game state
	game_state = game_state_world;
	
	// Update player LOS
	set_player_los(game_grid, actor_registry.player);
}

function goto_zone(world_x, world_y, entry_x, entry_y){
	
	with (manager){
		// reset actor and action lists
		actor_list_clear_all(false);
		action_list_clear_all(false);
	
		// Set game grid
		game_grid = zone_map[world_x][world_y];
		var grid_w = array_length(game_grid);
		var grid_h = array_length(game_grid[0]);
		map_mode  = MAP_MODE.ZONE;
	
		// Set player position
		actor_registry.player.x_pos = entry_x;
		actor_registry.player.y_pos = entry_y;
	
		player_set_sprite_pos(actor_registry.player);
	
		// Set camera bounds
		camera_min_x = -ui_width;
		camera_max_x = max(((grid_w * cell_width) - screen_width) + ui_width, 0);
		camera_min_y = 0;
		camera_max_y = max(((grid_h * cell_height) - screen_height) + log_height, 0);
	
		// Set game state
		game_state = game_state_dungeon;
	
		// Spawn mobs
		if (is_array(zone_mobs[world_x][world_y])){
			var len = array_length(zone_mobs[world_x][world_y]);
			if (len > 0){
				for (var i = 0; i < len; i ++){
				
					var new_mob = zone_mobs[world_x][world_y][i];
					new_mob.is_visible = false;
	
					// Push to actor registry
					array_push(actor_registry.actor_list, new_mob);
				}
			}
		}
	
		// Update player LOS
		set_player_los(game_grid, actor_registry.player);
	}
}




