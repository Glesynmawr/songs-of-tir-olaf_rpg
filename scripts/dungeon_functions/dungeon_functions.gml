
function dungeon_generate(index){
	
	dungeon_grid = [];
	
	// Sets level overall size
	grid_width		  = dungeons[index].max_width;
	grid_height		  = dungeons[index].max_height;
	max_depth		  = dungeons[index].max_depth;
	level_size_change = dungeons[index].size_change;
	
	// Increase level size based on depth
	grid_width  += floor(current_depth * level_size_change);
	grid_height += floor(current_depth * level_size_change);
	
	// Ensures grid is odd number of cells
	grid_width	= (floor(grid_width  / 2) * 2) + 1;
	grid_height	= (floor(grid_height / 2) * 2) + 1;
	
	// Dungeon appearance
	wall_sprite		= dungeons[index].wall_sprite;
	floor_sprite	= dungeons[index].floor_sprite;
	door_index		= dungeons[index].door_index;
	cull_ends		= true;
	
	// Initialise grids
	dungeon_grid = initialise_game_grid(grid_width, grid_height);
	generate_rooms(dungeon_grid, 9, 3, 5);
	generate_hallways(dungeon_grid, 25);
    
    // Initial connections
    var areas_connected = true;
    while(areas_connected){
        areas_connected = connect_areas(dungeon_grid);
    }
    
    // Shortcuts
    create_shortcuts(dungeon_grid, 25, 25);
	
	// Dead end culling
	if (cull_ends){
		var dead_ends_culled = true;
		while(dead_ends_culled){
			dead_ends_culled = cull_dead_ends(dungeon_grid);
		}
	}
	
	// Doors
	if (door_index >= 0){
		add_doors(dungeon_grid);
	}
	
	// Add entry
	entry_position = add_entry(dungeon_grid);
	
	// Add exit
	if (current_depth < max_depth - 1){
		exit_position = add_exit(dungeon_grid, entry_position[0], entry_position[1]);
	}
	else exit_position = noone;
	
	// Generate tilemap
	generate_map(dungeon_grid);
	
	// Initialise item grid
	initialise_item_grid(dungeon_grid, grid_width, grid_height);
	
	return([dungeon_grid, entry_position, exit_position, door_index]);
}

// INITIALISE
function initialise_game_grid(grid_width, grid_height){
	
	var grid = [];
	
	for (var x_pos = 0; x_pos < grid_width; x_pos ++){
		for (var y_pos = 0; y_pos < grid_height; y_pos ++){
			
			// CREATE WALL TILE -------------------------------------------------------------------
			grid[x_pos][y_pos] = new tile_wall();
			grid[x_pos][y_pos].sprite = wall_sprite;
			grid[x_pos][y_pos].flag   = -1;
		}
	}
	return(grid);
}

// ROOMS
function generate_rooms(grid, number_of_rooms, min_size, max_size){
	
	// Initialise variables
	var room_count = number_of_rooms;
	var room_list = [];
	var time_out = 500;
	
	while(room_count > 0){
		
		// Sets room with and height
		var width = irandom_range(min_size, max_size);
		width = floor(width / 2) * 2 + 1;
		
		var height = irandom_range(min_size, max_size);
		height = floor(height / 2) * 2 + 1;
		
		// Finds position for room on game_grid
		var position_list = [];
		
		for (var x_pos = 2; x_pos < array_length(grid) - (2 + width); x_pos += 2){
			for (var y_pos = 2; y_pos < array_length(grid[0]) - (2 + height); y_pos += 2){
				
				//Initialise variable
				var can_place_room = true;
				
				// Check room width and height
				for(var room_x = x_pos; room_x < x_pos + width; room_x ++){
					for(var room_y = y_pos; room_y < y_pos + height; room_y ++){
						if (grid[room_x][room_y].tile == "room"){
							can_place_room = false;
						}
					}
				}
				if (can_place_room == true){
					// Push onto position array
					array_push(position_list, [x_pos, y_pos]);
				}
			}
		}
		// Choose random room from list
		var len = array_length(position_list);
		if (len > 0){
			var choice = irandom(len - 1);
			
			// Get position of random room
			var xx = position_list[choice][0];
			var yy = position_list[choice][1];
			
			// Width and height already stored
			for (x_pos = xx; x_pos < xx + width; x_pos ++){
				for (y_pos = yy; y_pos < yy + height; y_pos ++){
					
					// CREATE ROOM TILE -----------------------------------------------------------
					grid[x_pos][y_pos] = new tile_room();
				}
			}
			array_push(room_list, [xx, yy, width, height]);
			
			room_count --;
		}
		// Or decrement time-out and try again
		else{
			time_out --;
			if (time_out <= 0){
				room_count = 0;
			}
		}
	}
	return(room_list);
}

// HALLWAYS
function generate_hallways(grid, hall_max_length){
	
	var can_place = true;
	var width  = array_length(grid);
	var height = array_length(grid[0]);
	
	while (can_place == true){
		
		// Find starting points
		var position_list = [];
		
		for (var x_pos = 2; x_pos < width - 2; x_pos += 2){
			for (var y_pos = 2; y_pos < height - 2; y_pos += 2){
				if (grid[x_pos][y_pos].tile == "wall"){
					array_push(position_list, [x_pos, y_pos]);
				}
			}
		}
		
		var len = array_length(position_list);
		if (len > 0){
			
			// Set hallway starting point
			var choice = irandom(array_length(position_list) - 1);
			x_pos = position_list[choice][0];
			y_pos = position_list[choice][1];
			
			// CREATE HALLWAY TILE ----------------------------------------------------------------
			grid[x_pos][y_pos] = new tile_hall();
			
			// Dig hallway
			var hall_length = 0;
			while(hall_length < hall_max_length){
				
				// Find clear direction
				var dir = find_direction_target(grid, x_pos, y_pos, "wall", 2);
				
				// Dig hallway
				if (dir != noone){
					var hall_repeats = floor(hall_max_length / 2);
					var target_x, target_y, tile_in_bounds;
					
					repeat(hall_repeats){
				
						// Increment Hall
						repeat(2){
							x_pos += lengthdir_x(1, dir);
							y_pos += lengthdir_y(1, dir);
							
							// CREATE HALLWAY TILE ------------------------------------------------
							grid[x_pos][y_pos] = new tile_hall();
						}
				
						// Check Twistyness
						if (irandom(100) < 50){
							dir += choose(90, -90);
						}
				
						// Check Direction for Rooms or Halls
						target_x = x_pos + lengthdir_x(2, dir);
						target_y = y_pos + lengthdir_y(2, dir);
				
						tile_in_bounds = grid_check_position_in_bounds(grid, target_x, target_y, 2);
				
						if (!tile_in_bounds or grid[target_x][target_y].tile != "wall"){
							dir = find_direction_target(grid, x_pos, y_pos, "wall", 2);
							if (dir == noone) break;
						}
					}
				}
				
				hall_length += 2;
			}
		}
		else{
			// Stop placing hallways
			can_place = false;
		}
	}
}

function find_direction_target(grid, x_pos, y_pos, target_type, step_size){
	
	// Get grid dimentions
	var width  = array_length(grid);
	var height = array_length(grid[0]);
	
	var candidate_list = [];
	
	// Check Surrounding Tiles
	var dir, target_x, target_y,
	
	for (var d = 0; d < 4; d ++){
		dir = d * 90;
		target_x = x_pos + lengthdir_x(step_size, dir);
		target_y = y_pos + lengthdir_y(step_size, dir);
		
		// Check target tile is in bounds and is required string
		if (target_x > 1 and target_x < width - 2) and (target_y > 1 and target_y < height - 2){
			if (grid[target_x][target_y].tile == target_type){
				array_push(candidate_list, dir);
			}
		}
	}
	var len, choice;
	len = array_length(candidate_list);
	if (len > 0){
		choice = irandom(len - 1);
		return(candidate_list[choice]);
	}
	else return(noone);
}

// CONNECTIONS
function connect_areas(grid){
	var i, j, current_flag;
	var width  = array_length(grid);
	var height = array_length(grid[0]);
	
	// Add Viable Cells
	for (i = 0; i < width; i ++){
		for (j = 0; j < height; j ++){
			if (grid[i][j].tile != "wall"){
				grid[i][j].flag = 0;
			}
		}
	}
	
	// Grow Flags
	current_flag = 1;
	for (i = 0; i < width; i ++){
		for (j = 0; j < height; j ++){
			if (grid[i][j].flag == 0){
				grow_flags(grid, i, j, current_flag);
				current_flag ++;
			}
		}
	}
	
	// Connect Flagged Areas with Different Values
	var connect_cell = find_connection(grid);
	if (connect_cell != noone)
	{
		// CREATE HALL TILE -----------------------------------------------------------------------
		grid[connect_cell[0]][connect_cell[1]] = new tile_hall();
	
		grow_flags(grid, connect_cell[0], connect_cell[1], connect_cell[2]);
		return(true);
	}
	else return(false);
	
}

function grow_flags(grid, xpos, ypos, flag){
	var candidate_list, new_list;
	
	candidate_list[0] = [xpos, ypos];
	
	while (array_length(candidate_list) > 0){
		new_list = [];
		
		for (var i = 0; i < array_length(candidate_list); i ++){
			var cell_x = candidate_list[i][0];
			var cell_y = candidate_list[i][1];
			
			grid[cell_x][cell_y].flag = flag;
		
			for (var j = 0; j < 4; j ++){
				var dir = j*90;
				var xx = cell_x + lengthdir_x(1, dir);
				var yy = cell_y + lengthdir_y(1, dir);
				
				var in_bounds = grid_check_position_in_bounds(grid, xx, yy, 1);
				
				if (in_bounds){
					if (grid[xx][yy].flag != flag) and (grid[xx][yy].flag != -1){
						grid[xx][yy].flag = flag;
						array_push(new_list, [xx, yy]);
					}
				}
			}
		}
		candidate_list = new_list;
	}
}

function find_connection(grid){
	var i, j, candidate_list, flag_r, flag_u, flag_l, flag_d;
	var width  = array_length(grid);
	var height = array_length(grid[0]);
	
	candidate_list = [];
	for (i = 1; i < width - 1; i += 1){
		for (j = 1; j < height - 1; j += 1){
			if (j mod 2 == 1 and i mod 2 == 1) continue;
			
			// Get surrounding flags
			flag_r = grid[i+1][j].flag;
			flag_u = grid[i][j-1].flag;
			flag_l = grid[i-1][j].flag;
			flag_d = grid[i][j+1].flag;
			
			// Push valid candidates to list
			if (flag_r == -1 and flag_l == -1) and (flag_d != -1 and flag_u != -1) and (flag_u != flag_d){
				array_push(candidate_list, [i, j, flag_u]);
			}
			if (flag_u == -1 and flag_d == -1) and (flag_r != -1 and flag_l != -1) and (flag_r != flag_l){
				array_push(candidate_list, [i, j, flag_l]);
			}
		}
	}
	
	// Choose random candidate from list
	var len = array_length(candidate_list);
	if (len > 0)
	{
		var c = irandom(len - 1);
		return(candidate_list[c]);
	}
	else return(noone);
}

// SHORTCUTS
function create_shortcuts(grid, shortcut_length, secret_door_chance){
	
	var shortcut_list, xx, yy, distance_map;
	
	// Find Potential Shortcuts
	shortcut_list = find_shortcut_candidates(grid, shortcut_length);
	
	while (array_length(shortcut_list) > 0){
		
		// Pick random shortcut
		var len, choice;
		len = array_length(shortcut_list);
		choice = irandom(len-1);
		
		xx = shortcut_list[choice][0];
		yy = shortcut_list[choice][1];
		
		// Check if it is viable
		var grid_r = grid[xx + 1][yy].tile;
		var grid_u = grid[xx][yy + 1].tile;
		var grid_l = grid[xx - 1][yy].tile;
		var grid_d = grid[xx][yy - 1].tile;

		// Create shortcut if viable
		var shortcut_is_viable = false;
		
		// Vertical shortcuts
		if (grid_r == "wall" and grid_l == "wall"){
			distance_map = set_dijkstra_map(grid, xx, yy - 1, 0);
					
			if (distance_map[xx][yy = 1] >= shortcut_length){
				shortcut_is_viable = true;
			}
			
		}
		// Horizontal shortcuts
		else if (grid_u = "wall" and grid_d = "wall"){
			distance_map = set_dijkstra_map(grid, xx - 1, yy, 0);
					
			if (distance_map[xx + 1][yy] >= shortcut_length){
				shortcut_is_viable = true;
			}
		}
		// delete from list if not viable
		else {
			shortcut_is_viable = false;
		}
		
		if (shortcut_is_viable){
			
			// CREATE SECRET DOOR -----------------------------------------------------------------
			if (irandom(100) < secret_door_chance){
				grid[xx][yy] = new tile_door_secret();
				
			}
			// CREATE OPEN CONNECTION -------------------------------------------------------------
			else{
		        grid[xx][yy] = new tile_hall();
		    }
		}
		array_delete(shortcut_list, choice, 1);
	}
}

function find_shortcut_candidates(grid, shortcut_length){
	var i, j, candidate_list, distance_map;
	candidate_list = [];
    var width  = array_length(grid);
    var height = array_length(grid[0]);
	
	for (i = 1; i < width-1; i ++){
		for (j = 1; j < height-1; j ++){
			if (i mod 2 == 1 and j mod 2 == 1) continue;
			
			if (grid[i][j].tile == "wall"){
			
				var grid_r = grid[i+1][j].tile;
				var grid_u = grid[i][j+1].tile;
				var grid_l = grid[i-1][j].tile;
				var grid_d = grid[i][j-1].tile;
				
				// Vertical shortcuts
				if (grid_r == "wall" and grid_l == "wall"){
					if (grid_d != "wall" and grid_u != "wall"){
						distance_map = set_dijkstra_map(grid, i, j-1, 0);
					
						if (abs(distance_map[i][j-1] - distance_map[i][j+1]) >= shortcut_length){
							array_push(candidate_list, [i, j]);
						}
					}
				}
				// Horizontal shortcuts
				if (grid_r != "wall" and grid_l != "wall"){
					if (grid_d == "wall" and grid_u == "wall"){
						distance_map = set_dijkstra_map(grid, i-1, j, 0);
					
						if (abs(distance_map[i-1][j] - distance_map[i+1][j]) >= shortcut_length){
							array_push(candidate_list, [i, j]);
						}
					}
				}
			}
		}
	}
	return(candidate_list);
}

// END CULLING
function cull_dead_ends(grid){
	var i, j, count;
	var width  = array_length(grid);
	var height = array_length(grid[0]);
	
	for (i = 1; i < width-1; i ++){
		for (j = 0; j < height-1; j ++){
			
			var xx = i;
			var yy = j;
			
			if (grid[xx][yy].tile != "wall"){
				
				// Repeat loop
				var can_cull_tile = true;
				
				while (can_cull_tile){
					count = grid_check_neighbour_count(grid, i, j, "wall", NEIGHBOUR_CHECK.ORTH);
					if (count == 3){
					
						// CREATE WALL TILE -----------------------------------------------------------
						grid[xx][yy] = new tile_wall();
						grid[xx][yy].sprite = wall_sprite;
					
						// Move to next tile
						for (var d = 0; d < 4; d ++){
							var target_x = xx + lengthdir_x(1, d * 90);
							var target_y = yy + lengthdir_y(1, d * 90);
						
							if (grid[target_x][target_y].tile != "wall"){
								xx = target_x;
								yy = target_y;
								break;
							}
						}
						return(true);
					}
					else can_cull_tile = false;
				}
			}
		}
	}
	return(false);
}

// DOORS
function add_doors(grid){
	var can_place = true;
	var width  = array_length(grid);
	var height = array_length(grid[0]);
	
	while (can_place){
		
		for (var x_pos = 1; x_pos < width - 1; x_pos ++){
			for (var y_pos = 1; y_pos < height - 1; y_pos ++){
				if (grid[x_pos][y_pos].tile == "hall"){
					var room_cell_count = grid_check_neighbour_count(grid, x_pos, y_pos, "room", NEIGHBOUR_CHECK.ORTH)
					if (room_cell_count > 0){
						grid[x_pos][y_pos] = new tile_door_closed();
						grid[x_pos][y_pos].index = door_index;
					}
				}
			}
		}
		
		can_place = false;
	}
}

// ENTRY AND EXIT
function add_entry(grid){
	var width  = array_length(grid);
	var height = array_length(grid[0]);
	var candidate_list = [];
	
	for (var x_pos = 1; x_pos < width - 1; x_pos ++){
		for (var y_pos = 1; y_pos < height - 1; y_pos ++){
			if (grid[x_pos][y_pos].tile == "room"){
				var count = grid_check_neighbour_count(grid, x_pos, y_pos, "room")
				if (count > 4){
					array_push(candidate_list, [x_pos, y_pos]);
				}
			}
		}
	}
	
	var len = array_length(candidate_list);
	if (len > 0){
		var choice = irandom(len - 1);
		
		x_pos = candidate_list[choice][0];
		y_pos = candidate_list[choice][1];
		
		grid[x_pos][y_pos] = new tile_stairs_up();
		
		return([x_pos, y_pos]);
	}
}

function add_exit(grid, entry_x, entry_y){
	var grid_w = array_length(grid);
	var grid_h = array_length(grid[0]);
	
	var candidate_list = [];
	
	for (var x_pos = 1; x_pos < grid_w - 1; x_pos ++){
		for (var y_pos = 1; y_pos < grid_h - 1; y_pos ++){
			if (grid[x_pos][y_pos].tile == "room" and point_distance(entry_x, entry_y, x_pos, y_pos) > grid_width / 3){
				var count_door = grid_check_neighbour_count(grid, x_pos, y_pos, "closed door");
				var count_hall = grid_check_neighbour_count(grid, x_pos, y_pos, "hall");
				if (count_door == 0) and (count_hall == 0){
					array_push(candidate_list, [x_pos, y_pos]);
				}
			}
		}
	}
	
	var len = array_length(candidate_list);
	if (len > 0){
		var choice = irandom(len - 1);
		
		x_pos = candidate_list[choice][0];
		y_pos = candidate_list[choice][1];
		
		grid[x_pos][y_pos] = new tile_stairs_down();
		
		return([x_pos, y_pos]);
	}
}

// AUTOTILING
function autotile_16(grid, type, xpos, ypos){
	
	var ww = array_length(grid);
	var hh = array_length(grid[0]);
	var count = 0;
	
	if (xpos + 1 >= ww)	or (grid[xpos+1][ypos].tile == type) or (grid[xpos+1][ypos].tile == "secret door") count += 1;
	if (ypos - 1 < 0)	or (grid[xpos][ypos-1].tile == type) or (grid[xpos][ypos-1].tile == "secret door") count += 2;
	if (xpos - 1 < 0)	or (grid[xpos-1][ypos].tile == type) or (grid[xpos-1][ypos].tile == "secret door") count += 4;
	if (ypos + 1 >= hh)	or (grid[xpos][ypos+1].tile == type) or (grid[xpos][ypos+1].tile == "secret door") count += 8;
	
	return(count);
}

function autotile_47(grid, type, xpos, ypos){
	var ww = array_length(grid);
	var hh = array_length(grid[0]);
	
	var index = 0;
	var orthcount = autotile_16(grid, type, xpos, ypos);
	
	var ur = false;
	var ul = false;
	var dl = false;
	var dr = false;
	
	if (xpos + 1 >= ww) or (ypos - 1 < 0)	or (grid[xpos+1][ypos-1].tile == type) or (grid[xpos+1][ypos-1].tile == "secret door") ur = true;
	if (xpos - 1 < 0) or (ypos  - 1 < 0)	or (grid[xpos-1][ypos-1].tile == type) or (grid[xpos-1][ypos-1].tile == "secret door") ul = true;
	if (xpos - 1 < 0) or (ypos + 1 >= hh)	or (grid[xpos-1][ypos+1].tile == type) or (grid[xpos-1][ypos+1].tile == "secret door") dl = true;
	if (xpos + 1 >= ww) or (ypos + 1 >= hh)	or (grid[xpos+1][ypos+1].tile == type) or (grid[xpos+1][ypos+1].tile == "secret door") dr = true;
	
	switch(orthcount){
		case(3):
			if (ur) index = 16 else index = orthcount;
			break;
	
		case(6):
			if (ul) index = 17 else index = orthcount;
			break;
			
		case(7):
			if (ur and ul) index = 20;
			else if (ur) index = 18;
			else if (ul) index = 19;
			else index = orthcount;
			break;
		
		case(9):
			if (dr) index = 21 else index = orthcount;
			break;
			
		case(11):
			if (ur and dr) index = 24;
			else if (ur) index = 22;
			else if (dr) index = 23;
			else index = orthcount;
			break;
			
		case(12):
			if (dl) index = 25 else index = orthcount;
			break;
			
		case(13):
			if (dl and dr) index = 28;
			else if (dl) index = 26;
			else if (dr) index = 27;
			else index = orthcount;
			break;
			
		case(14):
			if (ul and dl) index = 31;
			else if (ul) index = 29;
			else if (dl) index = 30;
			else index = orthcount;
			break;
			
		case(15):
			if (ur and ul and dl and dr) index = 46;
			else if (ur and ul and dl) index = 45;
			else if (ur and ul and dr) index = 44;
			else if (ur and dl and dr) index = 43;
			else if (ul and dl and dr) index = 42;
			else if (ur and ul) index = 41;
			else if (ul and dl) index = 40;
			else if (dl and dr) index = 39;
			else if (ur and dr) index = 38;
			else if (ur and dl) index = 37;
			else if (ul and dr) index = 36;
			else if (ur) index = 32;
			else if (ul) index = 33; 
			else if (dl) index = 34;
			else if (dr) index = 35;
			else index = orthcount;
			break;
			
		default: index = orthcount;
	}
	
	return(index);
}

function generate_map(grid){
	var ww = array_length(grid);
	var hh = array_length(grid[0]);
	
	for (var i = 0; i < ww; i ++){
		for (var j = 0; j < hh; j ++){
			
			var tile = grid[i][j].tile;
			
			if (tile == "wall" or tile == "secret door"){
				grid[i][j].sprite = wall_sprite;
				grid[i][j].index  = autotile_47(grid, "wall", i, j);
			}
			else if (tile == "room" or tile == "hall"){
				grid[i][j].sprite = floor_sprite;
				grid[i][j].index  = irandom(3);
			}
		}
	}
}

// ITEM CREATION
function initialise_item_grid(grid, width, height){
	for (var i = 0; i < width; i ++){
		for (var j = 0; j < height; j ++){
			grid[i][j].items = [];
		}
	}
}




