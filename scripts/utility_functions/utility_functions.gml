
// CAMERA
function resolution_scale(){
	
	// INITIALISE VARIABLES
	var width, height, scale_x, scale_y, scale;
	
	// GET WINDOW SIZE
	width = window_get_width();
	height = window_get_height();
	
	// SET SCALE FACTOR
	scale_x = max(1, floor(width / SCREEN_WIDTH));
	scale_y = max(1, floor(height / SCREEN_HEIGHT));
	scale = min(scale_x, scale_y);
	scale = floor(scale);
	
	// GET MAIN VIEW CAMERA
	var cam = view_get_camera(0);
	
	// SET VIEWPORT SIZE
	view_set_wport(0, width);
	view_set_hport(0, height);

	// SET CAMERA AND SURFACE SIZES
	camera_set_view_size(cam, width / scale, height / scale);
	surface_resize(application_surface, max(width, SCREEN_WIDTH), max(height, SCREEN_HEIGHT));
	display_set_gui_size(width / scale, height / scale)
	
	// SET SCREEN SIZE VARIABLES
	screen_width	= floor(width  / scale);
	screen_height	= floor(height / scale) - 2;
	
}

function actor_set_sprite_pos(actor){
	with (actor){
		sprite_x = x_pos * manager.cell_width;
		sprite_y = y_pos * manager.cell_height;
		sprite_target_x = x_pos * manager.cell_width;
		sprite_target_y = y_pos * manager.cell_height;
	}
}

function menu_pos_reset(){
	with (manager){
		control_menu_hover		= 0;
		game_over_menu_hover	= 0;
		main_menu_hover			= 0;
		pause_menu_hover		= 0;
	}
}


// CONTROLS
function input_direction(x_move, y_move){

	if (x_move == -1){
		if (y_move == -1) return(3);
		if (y_move == 0)  return(4);
		if (y_move == 1)  return(5);
	}
	else if (x_move == 0){
		if (y_move == -1) return(2);
		if (y_move == 0)  return(noone);
		if (y_move == 1)  return(6);
	}
	else if (x_move == 1){
		if (y_move == -1) return(1);
		if (y_move == 0)  return(0);
		if (y_move == 1)  return(7);
	}
}

function keybinding_get_text(key_char){
	switch(key_char){
		
		case vk_tab:		 return("[tab]");	break;
		case vk_control:	 return("[ctrl]");	break;
		case vk_printscreen: return("[PtSc]");	break;
		case vk_pause:		 return("[pau]");	break;
		case vk_insert:		 return("[ins]");	break;
		case vk_shift:		 return("[shift]"); break;
		case vk_alt:		 return("[alt]");	break;
		case vk_home:		 return("[home]");	break;
		case vk_end:		 return("[end]");	break;
		case vk_pageup:		 return("[PgUp]");	break;
		case vk_pagedown:	 return("[PgDn]");	break;
		case vk_escape:		 return("[esc]");	break;
		case vk_enter:		 return("[enter]"); break;
		case vk_backspace:	 return("[BkSp]");	break;
		case vk_up:			 return("[up]");	break;
		case vk_down:		 return("[down]");	break;
		case vk_left:		 return("[left]");	break;
		case vk_right:		 return("[right]"); break;
		case vk_space:		 return("[space]"); break;
		case vk_delete:		 return("[del]");	break;
		
		case vk_numpad0:	return("[num0]"); break;
		case vk_numpad1:	return("[num1]"); break;
		case vk_numpad2:	return("[num2]"); break;
		case vk_numpad3:	return("[num3]"); break;
		case vk_numpad4:	return("[num4]"); break;
		case vk_numpad5:	return("[num5]"); break;
		case vk_numpad6:	return("[num6]"); break;
		case vk_numpad7:	return("[num7]"); break;
		case vk_numpad8:	return("[num8]"); break;
		case vk_numpad9:	return("[num9]"); break;
		
		case ord("1"):		return("[1]"); break;
		case ord("2"):		return("[2]"); break;
		case ord("3"):		return("[3]"); break;
		case ord("4"):		return("[4]"); break;
		case ord("5"):		return("[5]"); break;
		case ord("6"):		return("[6]"); break;
		case ord("7"):		return("[7]"); break;
		case ord("8"):		return("[8]"); break;
		case ord("9"):		return("[9]"); break;
		case ord("0"):		return("[0]"); break;
		
		case vk_f1:			return("[f1]");  break;
		case vk_f2:			return("[f2]");  break;
		case vk_f3:			return("[f3]");  break;
		case vk_f4:			return("[f4]");  break;
		case vk_f5:			return("[f5]");  break;
		case vk_f6:			return("[f6]");  break;
		case vk_f7:			return("[f7]");  break;
		case vk_f8:			return("[f8]");  break;
		case vk_f9:			return("[f9]");	 break;
		case vk_f10:		return("[f10]"); break;
		case vk_f11:		return("[f11]"); break;
		case vk_f12:		return("[f12]"); break;
		
		case vk_multiply:	return("[num*]"); break;
		case vk_divide:		return("[num/]"); break;
		case vk_add:		return("[num+]"); break;
		case vk_subtract:	return("[num-]"); break;
		case vk_decimal:	return("[num.]"); break;
		
		case 188:			return("[,]"); break;
		case 190:			return("[.]"); break;
		case 191:			return("[/]"); break;
								  
		case 186:			return("[;]"); break;
		case 192:			return("[']"); break;
		case 222:			return("[#]"); break;
								  
		case 219:			return("[[]"); break;
		case 221:			return("[]]"); break;
								
		case 189:			return("[-]"); break;
		case 187:			return("[=]"); break;
								
		case 223:			return("[`]"); break;
		case 220:			return("[\]"); break;
		
		case ord("A"):		return("[a]"); break;
		case ord("B"):		return("[b]"); break;
		case ord("C"):		return("[c]"); break;
		case ord("D"):		return("[d]"); break;
		case ord("E"):		return("[e]"); break;
		case ord("F"):		return("[f]"); break;
		case ord("G"):		return("[g]"); break;
		case ord("H"):		return("[h]"); break;
		case ord("I"):		return("[i]"); break;
		case ord("J"):		return("[j]"); break;
		case ord("K"):		return("[k]"); break;
		case ord("L"):		return("[l]"); break;
		case ord("M"):		return("[m]"); break;
		case ord("N"):		return("[n]"); break;
		case ord("O"):		return("[o]"); break;
		case ord("P"):		return("[p]"); break;
		case ord("Q"):		return("[q]"); break;
		case ord("R"):		return("[r]"); break;
		case ord("S"):		return("[s]"); break;
		case ord("T"):		return("[t]"); break;
		case ord("U"):		return("[u]"); break;
		case ord("V"):		return("[v]"); break;
		case ord("W"):		return("[w]"); break;
		case ord("X"):		return("[x]"); break;
		case ord("Y"):		return("[y]"); break;
		case ord("Z"):		return("[z]"); break;
		
		default:			return("[undefined]");
	}
}

function ui_menu_control_string(){
	
	var key_up		= keybinding_get_text(controls.key_up);
	var key_down	= keybinding_get_text(controls.key_down);
	var key_select	= keybinding_get_text(controls.key_interact_confirm);
	
	var control_text = $"{key_up} or {key_down} to move cursor - {key_select} to select";
	
	return(control_text);
}


// DISTANCE MAPPING
function create_distance_map(grid, target_x, target_y){
	var i, j, xx, yy, cell_x, cell_y, candidate_list, dijkstra_map, new_list, flag;
	
	var grid_w = array_length(grid);
	var grid_h = array_length(grid[0]);
	
	candidate_list[0] = [target_x, target_y];
	flag = 0;
	
	// Initialise Grid
	for (i = 0; i < grid_w; i ++){
		for (j = 0; j < grid_h; j ++){
			dijkstra_map[i][j] = 1000000;
		}
	}

	// Populate grid
	while (array_length(candidate_list) > 0){
		
		// New cell list
		new_list = [];
		
		// Loop through current cell list
		for (i = 0; i < array_length(candidate_list); i ++){
			cell_x = candidate_list[i][0];
			cell_y = candidate_list[i][1];
			
			// Set the cell flag
			dijkstra_map[cell_x][cell_y] = flag;
			
			// Loop through cell neighbours
			for (j = 0; j < 8; j ++){
				
				// Get all 8 cell neighbour positions
				xx = cell_x + manager.cell_x_neighbours[j];
				yy = cell_y + manager.cell_y_neighbours[j];
				
				// Check cell is in bounds
				if (grid_check_position_in_bounds(grid, xx, yy)){
				
					// If cell is walkable
					if (grid[xx][yy].walkable){
						if (dijkstra_map[xx][yy] == 1000000){
							dijkstra_map[xx][yy] = flag;
							array_push(new_list, [xx, yy]);
						}
					}
				}
			}
		}
		
		candidate_list = new_list;
		flag ++;
	}
	return(dijkstra_map);
}


// GAME LOG	
function log_add_entry(text, colour = colour_text_main){
	with (manager){
		array_insert(game_state.game_log, 0, [text, colour]);
	}
}


// GAME STATE TRANSITIONS
function transition_set(transition_type, transition_colour){
	with (manager){
	transition = {
			anim_speed:	0.5,
			index:		0,
			colour:		transition_colour,
			type:		transition_type
		}
	}
}

function transition_update(){
	with (manager){
		transition.index += transition.anim_speed;
		if (transition.index >= sprite_get_number(transition_spr) - 1){
			transition.anim_speed *= -1;
		
			switch(transition.type){
			
				case TRANSITION.CONTROL_EXIT:	
					menu_pos_reset();
					game_state.state_main = control_state_previous;	break;	
							
			
				case TRANSITION.CONTROL_MENU:	
					menu_pos_reset();
					control_state_previous = game_state.state_main;
					game_state.state_main = init_control_menu;	break;
																										
				case TRANSITION.GAME_BOOT:		
					menu_pos_reset();
					game_state.state_main = game_state_main_menu;	break;
				
				case TRANSITION.GAME_DUNGEON_ENTER:	
					menu_pos_reset();
					goto_dungeon(game_state.dungeon_index, true);	break;
			
				case TRANSITION.GAME_DUNGEON_EXIT:	
					menu_pos_reset();
					var wx = actor_registry.player.world_x;
					var wy = actor_registry.player.world_y;
					goto_zone(wx, wy, game_state.dungeon_entry_x, game_state.dungeon_entry_y);	break;
				
				case TRANSITION.GAME_DUNGEON_NEXT:	
					menu_pos_reset();
					goto_dungeon(game_state.dungeon_index, true);	break;
																									
				case TRANSITION.GAME_DUNGEON_PREV:	
					menu_pos_reset();
					goto_dungeon(game_state.dungeon_index, false);	break;
																									
				case TRANSITION.GAME_LOAD:		    menu_pos_reset() game_load_all();	break;
																									
				case TRANSITION.GAME_QUIT:		    menu_pos_reset() game_end();		break;
			
				case TRANSITION.GAME_RESET:			
					menu_pos_reset();
					game_state.state_main = game_state_main_menu;	break;
			
				case TRANSITION.GAME_START_NEW:		menu_pos_reset() init_world();	break;
			
				case TRANSITION.GAME_WORLD:		
					menu_pos_reset();
					grid_set_visible(manager.game_state.game_grid, false) 
					goto_world();	break;
			
				case TRANSITION.GAME_ZONE:	
					menu_pos_reset();
					grid_set_visible(manager.game_state.game_grid, false) 
					goto_zone(actor_registry.player.world_x, actor_registry.player.world_y, floor(ZONE_SIZE / 2), floor(ZONE_SIZE / 2)); break;
			
				default: show_message("Transition type not set!");									break;
			}
		}
		else if (transition.index <= 0){
			transition			= noone;
		}
	}
}

function transition_zoom_in(){
	
}

function transition_zoom_out(){
	
}


// LOADING AND SAVING
function controls_read_settings(){
	
	var control_data, loaded_data;

	var file = file_text_open_read("player_settings_controls");
	if (file != -1){
		loaded_data = file_text_read_string(file);
		loaded_data = json_parse(loaded_data);
	}
	else{
		loaded_data = controls_default;
	}
	
	// Check version number exists
	if (struct_exists(loaded_data, "save_version")){
		
		// Check version number
		if (loaded_data.save_version[0] == global.version[0]){
			
			// Valid version number
			control_data = loaded_data.save_controls;
		}
		else{
			
			// Invalid version number
			control_data = manager.controls_default;
		}
	}
	else{
		
		// No version detected
		control_data = manager.controls_default;
	}
	
	controls = variable_clone(control_data);
	file_text_close(file);
}

function controls_save_settings(){
	
	var control_save_data;
	
	control_save_data = {
		save_version:	global.version,
		save_controls:	controls
	}
	
	var struct_json = json_stringify(control_save_data);
	
	var file = file_text_open_write("player_settings_controls");
	file_text_write_string(file, struct_json);
	file_text_close(file);
}
	
function game_save_all(){
	
	var save_data;
	
	// Create save struct
	save_data = {
		save_version:	global.version,
		save_actors:	actor_registry,
		save_game:		game_state,
		save_ui:		ui_settings,
		save_time:		time_system
	}
	
	// Save struct to file
	var struct_json = json_stringify(save_data);
	var file = file_text_open_write("game_save");
	file_text_write_string(file, struct_json);
	file_text_close(file);
	
	return(true);
}

function game_load_all(){
	
	var loaded_data;
	
	// Reaad from save file
	var file = file_text_open_read("game_save");
	
	// If save file exists
	if (file != -1){
		
		// Parse saved data
		loaded_data = file_text_read_string(file);
		loaded_data = json_parse(loaded_data);
		
		// Check version number
		if (loaded_data.save_version[0] == global.version[0]){
			
			// Push data to game structs
			manager.actor_registry	= loaded_data.save_actors;
			manager.game_state		= loaded_data.save_game;
			manager.ui_settings		= loaded_data.save_ui;
			manager.time_system		= loaded_data.save_time;
			
			manager.game_state.state_main = manager.game_state.state_previous;
			
			// Find player instance
			for (var i = 0; i < array_length(manager.actor_registry.actor_list); i ++){
				if (manager.actor_registry.actor_list[i].is_player){
					manager.actor_registry.player = manager.actor_registry.actor_list[i];
					break;
				}
			}
			if (loaded_data.save_version[1] != global.version[1]){
				
				// Save data may produce unexpected results
				
				var txt = "Save file is from an older version and\nmay cause errors or unexpected crashes.";
				var xx = screen_width / 2;
				var yy = screen_height / 2;
				create_notification(txt, xx, yy, true, false);
			}
			
			distance_map_player = create_distance_map(manager.game_state.game_grid, manager.actor_registry.player.x_pos, manager.actor_registry.player.y_pos);
			turn_order_initialise();
			
			file_text_close(file);
			return(true);
		}
		else{
			// Save file is not valid
			var txt = "Save file is from an older version\nand is incompatible.";
			var xx = screen_width / 2;
			var yy = screen_height / 2;
			create_notification(txt, xx, yy, true, false);
		}
	}
			
	file_text_close(file);
	
	return(false);
}


// NOTIFICATIONS
function create_notification(text, x_pos, y_pos, needs_cancel, needs_confirm = true){
	with (manager){
		var ww = string_width(text) + (text_width * 4);
		var hh = string_height(text) + (text_height * 4);
		
		notification.text		= text;
								
		notification.width		= ww;
		notification.height		= hh;
								
		notification.x_pos		= floor(x_pos - (ww / 2));
		notification.y_pos		= floor(y_pos - (hh / 2));
		
		notification.cancel		= needs_cancel;
		notification.confirm	= needs_confirm;
	}
}

function notification_reset(){
	with (manager){
		notification = {
			text	: "",
			x_pos	: 0,
			y_pos	: 0,
			width	: 0,
			height	: 0,
			cancel	: true,
			confirm	: false,
			action	: noone
		}
	}
}


// TURN STRUCTURE
function turn_order_initialise(){
	with (manager){
		actor_registry.action_list = [];
		actor_registry.action_index = 0;
	
		for (var i = 0; i < array_length(actor_registry.actor_list); i ++){
		
			with (actor_registry.actor_list[i]){
	
				// CHECK ACTOR ENERGY
				if (energy > 0){
		
					// GET ACTION ENERGY COST
					var action_cost = 100;
					if (action_speed > 0){
						action_cost = 10000 / action_speed;
					}
		
					// GET ACTOR DISTANCE FROM PLAYER
					dist = 0;
					if (self != manager.actor_registry.player){
						var dist = distance_map_player[x_pos][y_pos];
					}
		
					// PUSH INSTANCE ID AND DISTANCE TO ACTION LIST
					energy -= action_cost;
					array_push(other.actor_registry.action_list, [self, dist]);
				}
			}
		}
		// IF ACTION LIST LENGTH IS GREATER THAN ZERO
		var len = array_length(actor_registry.action_list);
		if (len > 0){
	
			// SORT ACTION LIST BY ASCENDING DISTANCE TO PLAYER
			array_sort(actor_registry.action_list, function(elm1, elm2){
				return(elm1[1] - elm2[1])
			});
	
			// CONVERT ARRAY TO 1D
			for (i = 0; i < len; i ++){
				actor_registry.action_list[i] = actor_registry.action_list[i][0];
			}
		}
		else {
			if (array_length(actor_registry.actor_list) > 0){
			
				for (var i = 0; i < array_length(actor_registry.actor_list); i ++){
					actor_registry.actor_list[i].energy += ENERGY_PER_TURN;
				}
				actor_registry.player.has_acted = false;
			
				increment_time_and_date();
			
				turn_order_initialise();
			}
		}
	}
}

function turn_order_update(){
	with (manager){
		var len = array_length(actor_registry.action_list);

		for (var i = 0; i < len; i ++){
		
			if (i >= array_length(actor_registry.action_list)) break;
		
			actor_registry.action_list[i].state();
		
			if (i >= array_length(actor_registry.action_list)) break;
		
			if (!actor_registry.action_list[i].has_acted) break;
			actor_registry.action_index ++;
		}
	
		if (actor_registry.action_index >= array_length(actor_registry.action_list)){
						
			// Create New Action List
			for (var i = 0; i < array_length(actor_registry.actor_list); i ++){
				actor_registry.actor_list[i].has_acted = false;
			}
			turn_order_initialise();
		}
	}
}

function increment_time_and_date(){
	with (manager){
		// Increase current TURN
		time_system.game_current_time[TIME.TURN] += time_system.timescale;
	
		if (time_system.game_current_time[TIME.TURN] >= turns_per_hour){
		
			time_system.game_current_time[TIME.TURN] -= turns_per_hour
		
			// Increase current HOUR
			time_system.game_current_time[TIME.HOUR] ++;
			if (time_system.game_current_time[TIME.HOUR] >= hours_per_day){
				time_system.game_current_time[TIME.HOUR] -= hours_per_day
			
				// Increase current DAY
				time_system.game_current_time[TIME.DAY] ++;
			}
		}
	}
}




