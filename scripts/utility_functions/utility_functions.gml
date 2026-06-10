
// CAMERA
function initialise_camera(following){
	camera_pos[0] = floor((following.x_pos * cell_width)  - (screen_width  / 2) + (cell_width  / 2));
	camera_pos[1] = floor((following.y_pos * cell_height) - (screen_height / 2) - (cell_height / 2)) + floor(log_height / 2);
}

function move_camera(target_x, target_y, camera_spd){
	if (camera_pos[0] != target_x){
		camera_pos[0] += (target_x - camera_pos[0]) * camera_spd;
	}
	if (camera_pos[1] != target_y){
		camera_pos[1] += (target_y - camera_pos[1]) * camera_spd;
	}
	
	if (abs(camera_pos[0] - target_x) < 0.1) camera_pos[0] = target_x;
	if (abs(camera_pos[1] - target_y) < 0.1) camera_pos[1] = target_y;
	
	camera_set_view_pos(view_camera[0], camera_pos[0], camera_pos[1]);
}

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


	// SET CAMERA AND APPLICATION SURFACE SIZE
	camera_set_view_size(cam, view_wport[0]/scale, view_hport[0]/scale);
	surface_resize(application_surface, width, height);
	display_set_gui_size(width / scale, height / scale)
	
	
	// SET SCREEN SIZE VARIABLES
	screen_width	= width  / scale;
	screen_height	= height / scale;
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
function draw_game_log(x_pos, y_pos, width, height){
	
	ui_draw_box(x_pos, y_pos, width, height);
	
	var xx = x_pos + (text_width * 2);
	var yy = y_pos + text_height;
	
	var draw_to = min(LOG_MAX_ENTRIES, array_length(game_log));
	for (var line = 0; line < draw_to; line ++){
		
		var text =		game_log[line][0];
		var colour =	game_log[line][1];
		
		draw_text_colour(xx, yy + (line * text_height), text, colour, colour, colour, colour, 1);
	}
}

function initialise_log(){
	globalvar game_log;
	game_log = [];
}

function log_add_entry(text, colour){
	array_insert(game_log, 0, [text, colour]);
}


// GAME STATE TRANSITIONS
function transition_set(transition_type, transition_colour){
	transition = {
		anim_speed:	0.5,
		index:		0,
		colour:		transition_colour,
		type:		transition_type
	}
}

function transition_update(){
	transition.index += transition.anim_speed;
	if (transition.index >= sprite_get_number(transition_spr) - 1){
		transition.anim_speed *= -1;
		
		switch(transition.type){
			
			case TRANSITION.CONTROL_MENU:	game_state = init_control_menu;		break;
			case TRANSITION.CONTROL_EXIT:	
				game_state = game_state_previous;	
				if (game_state == game_state_dungeon) game_state = game_state_pause_menu; break;
			case TRANSITION.GAME_BOOT:		game_state = game_state_main_menu;	break;
			case TRANSITION.GAME_DUNGEON:	game_state = game_state_dungeon;	break;
			case TRANSITION.GAME_QUIT:		game_end();							break;
			case TRANSITION.GAME_WORLD:		game_state = game_state_world;		break;
			
			default: show_message("Transition type not set!");					break;
		}
	}
	else if (transition.index <= 0){
		transition			= noone;
	}
}


// LOADING AND SAVING
function controls_read_settings(){
	
	var struct_json = json_stringify(controls_default);

	var file = file_text_open_read("player_settings_controls");
	if (file != -1){
		struct_json = file_text_read_string(file);
	}
	
	var loaded = json_parse(struct_json);
	controls = variable_clone(loaded);
}

function controls_save_settings(){
	
	var struct_json = json_stringify(controls);
	
	var file = file_text_open_write("player_settings_controls");
	file_text_write_string(file, struct_json);
	file_text_close(file);
}


// TURN STRUCTURE
function turn_order_initialise(){
	action_list = [];
	action_index = 0;
	
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
				array_push(other.action_list, [self, dist]);
			}
		}
	}
	// IF ACTION LIST LENGTH IS GREATER THAN ZERO
	var len = array_length(action_list);
	if (len > 0){
	
		// SORT ACTION LIST BY ASCENDING DISTANCE TO PLAYER
		array_sort(action_list, function(elm1, elm2){
			return(elm1[1] - elm2[1])
		});
	
		// CONVERT ARRAY TO 1D
		for (i = 0; i < len; i ++){
			action_list[i] = action_list[i][0];
		}
	}
	else {
		if (array_length(actor_registry.actor_list) > 0){
			
			for (var i = 0; i < array_length(actor_registry.actor_list); i ++){
				actor_registry.actor_list[i].energy += ENERGY_PER_TURN;
			}
			actor_registry.player.has_acted = false;
			turn_order_initialise();
		}
	}
}

function turn_order_update(){
	var len = array_length(action_list);

	if (action_index < len){
	
			with (action_list[action_index]){
				state();
				if (has_acted){
					other.action_index ++;
				}
			}
		
		if (action_index >= array_length(action_list)){
						
			// Create New Action List
			for (var i = 0; i < array_length(actor_registry.actor_list); i ++){
				actor_registry.actor_list[i].has_acted = false;
			}
			turn_order_initialise();
			
		}
	}
}




