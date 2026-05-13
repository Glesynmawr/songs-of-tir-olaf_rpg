
// CAMERA
function initialise_camera(following){
	camera_pos[0] = floor((following.x_pos * cell_width)  - (room_width  / 2) - (cell_width  / 2));
	camera_pos[1] = floor((following.y_pos * cell_height) - (room_height / 2) - (cell_height / 2));
}

function move_camera(target_x, target_y, camera_spd){
	if (camera_pos[0] != target_x){
		camera_pos[0] += (target_x - camera_pos[0]) * camera_spd;
	}
	if (camera_pos[1] != target_y){
		camera_pos[1] += (target_y - camera_pos[1]) * camera_spd;
	}
	camera_set_view_pos(view_camera[0], floor(camera_pos[0]), floor(camera_pos[1]));
}


// GAME LOG	
function initialise_log(){
	globalvar game_log;
	game_log = [];
}

function log_add_entry(text, colour){
	array_insert(game_log, 0, [text, colour]);
}

function draw_game_log(x_pos, y_pos, width, height){

	draw_sprite_stretched_ext(ui_border_spr, 1, x_pos, y_pos, width, height, c_black,  1);
	draw_sprite_stretched_ext(ui_border_spr, 0, x_pos, y_pos, width, height, c_ltgrey, 1);
	
	var xx = x_pos + text_width;
	var yy = y_pos + (text_height / 2);
	
	var draw_to = min(LOG_MAX_ENTRIES, array_length(game_log));
	for (var line = 0; line < draw_to; line ++){
		
		var text =		game_log[line][0];
		var colour =	game_log[line][1];
		
		draw_text_colour(xx, yy + (line * text_height), text, colour, colour, colour, colour, 1);
	}
}


// DISTANCE MAPPING
function create_distance_map(target_x, target_y){
	var i, j, xx, yy, cell_x, cell_y, candidate_list, dijkstra_map, new_list, flag;
	
	candidate_list[0] = [target_x, target_y];
	flag = 0;
	
	// Initialise Grid
	for (i = 0; i < manager_obj.grid_width; i ++){
		for (j = 0; j < manager_obj.grid_height; j ++){
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
				xx = cell_x + manager_obj.cell_x_neighbours[j];
				yy = cell_y + manager_obj.cell_y_neighbours[j];
				
				// If cell is walkable
				if (manager_obj.game_grid[xx][yy].walkable){
					if (dijkstra_map[xx][yy] == 1000000){
						dijkstra_map[xx][yy] = flag;
						array_push(new_list, [xx, yy]);
					}
				}
			}
		}
		
		candidate_list = new_list;
		flag ++;
	}
	return(dijkstra_map);
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
				if (self != manager_obj.actor_registry.player){
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



