
// MAP CHECK FUNCTIONS
function grid_check_position_in_bounds(grid, x_pos, y_pos, border = 0){
	var x_min, x_max, y_min, y_max;
	
    var width  = array_length(grid);
    var height = array_length(grid[0]);
    
	x_min = border;
	y_min = border;
	x_max = width - border;
	y_max = height - border;
	
	if (x_pos >= x_min and x_pos < x_max) and (y_pos >= y_min and y_pos < y_max){
		return(true)
	}
	return(false);
}

function grid_check_position_contains_actor(x_pos, y_pos){
	for (var i = 0; i < array_length(manager.actor_registry.actor_list); i ++){
		var actor = manager.actor_registry.actor_list[i];
		if (actor.x_pos == x_pos and actor.y_pos == y_pos){
			return(actor);
			break;
		}
	}
	return(noone);
}

function initialise_distance_grid(grid_width, grid_height, initial_value){
	
	var grid = [];
	for (var x_pos = 0; x_pos < grid_width; x_pos ++){
		for (var y_pos = 0; y_pos < grid_height; y_pos ++){
			
			grid[x_pos][y_pos] = initial_value;
		}
	}
	return(grid);
}

function set_dijkstra_map(grid, target_x, target_y, initial_flag){
	var i, j, xx, yy, cell_x, cell_y, dir, candidate_list, dijkstra_map, new_list, flag;
	
	candidate_list[0] = [target_x, target_y];
	flag = initial_flag;
    var width  = array_length(grid);
    var height = array_length(grid[0]);
	
	// Initialise Grid
	dijkstra_map = initialise_distance_grid(width, height, -99);
	
	while (array_length(candidate_list) > 0){
		new_list = [];
		
		for (i = 0; i < array_length(candidate_list); i ++){
			cell_x = candidate_list[i][0];
			cell_y = candidate_list[i][1];
			
			dijkstra_map[cell_x][cell_y] = flag;
		
			for (j = 0; j < 4; j ++){
				dir = j*90;
				xx = cell_x + lengthdir_x(1, dir);
				yy = cell_y + lengthdir_y(1, dir);
				
				if (grid[xx][yy].walkable){
					if (dijkstra_map[xx][yy] == -99){
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

function grid_check_neighbour_count(grid, x_pos, y_pos, tile_type, directions = NEIGHBOUR_CHECK.ALL){
	
	// Check position is in bounds
	var position_in_bounds = grid_check_position_in_bounds(grid, x_pos, y_pos, 1);
	
	if (!position_in_bounds){
		return(false);
	}
	
	var i, target_x, target_y;
	
	// Directional checks
	var orth_check = 0;
	var diag_check = 0;
	
	for (i = 0; i < array_length(cell_x_neighbours); i ++){
		
		target_x = x_pos + cell_x_neighbours[i];
		target_y = y_pos + cell_y_neighbours[i];
		
		if (grid[target_x][target_y].tile == tile_type){
			if (i mod 2 == 0){
				orth_check ++;
			}
			else{
				diag_check ++;
			}
		}
	}
	// Orthogonal check
	if (directions == NEIGHBOUR_CHECK.ORTH){
		return(orth_check);
	}
	
	// Diagonal check
	else if (directions == NEIGHBOUR_CHECK.DIAG){
		return(diag_check);
	}
	
	// All check
	else return(orth_check + diag_check);
}

function grid_check_tile_is_walkable(grid, x_pos, y_pos){
	
	var is_in_bounds = grid_check_position_in_bounds(grid, x_pos, y_pos);
	if (is_in_bounds){
		var is_walkable = grid[x_pos][y_pos].walkable;
		if (is_walkable){
			return(true);
		}
		else return(false);
	}
	else return(true);
}

// LOS FUNCTIONS
function set_player_los(grid, actor){
	with (actor){
		
		var width = array_length(grid);
		var height = array_length(grid[0]);
		var range = actor.range + 2;
		
		var x_min = max(actor.x_pos - range, 0);
		var x_max = min(actor.x_pos + range + 1, width);
		
		var y_min = max(actor.y_pos - range, 0);
		var y_max = min(actor.y_pos + range + 1, height);
		
		for (var x_pos = x_min; x_pos < x_max; x_pos ++){
			for (var y_pos = y_min; y_pos < y_max; y_pos ++){
				
				var tile_is_visible = draw_los_line(grid, x_pos, y_pos, actor.x_pos, actor.y_pos);
				var tile_distance   = round(point_distance(x_pos, y_pos, actor.x_pos, actor.y_pos))
				
				if (tile_is_visible and tile_distance <= actor.range){
					grid[x_pos][y_pos].is_visible = true;
					grid[x_pos][y_pos].explored = true;
				}
				else{
					grid[x_pos][y_pos].is_visible = false;
				
				}
			}
		}
	}
	for (var i = 0; i < array_length(manager.actor_registry.actor_list); i ++){
		with (manager.actor_registry.actor_list[i]){
			if (grid[self.x_pos][self.y_pos].is_visible){
				self.is_visible = true;
			}
			else self.is_visible = false;
		}
	}
}

function draw_los_line(grid, x_from, y_from, x_to, y_to){

	var len_x = abs(x_from - x_to);
	var len_y = abs(y_from - y_to);
	
	if (len_x >= len_y){
		
		var increment = sign(x_to - x_from);
		var count = 0;
		var cell_x = x_from;
		
		while(count < len_x){
			cell_x += increment;
			var interpolation = abs(cell_x - x_from) / len_x;
			var cell_y = round(lerp(y_from, y_to, interpolation));
			
			if (cell_x != x_from or cell_y != y_from) and (cell_x != x_to or cell_y != y_to){
				if (grid[cell_x][cell_y].transparent == false){
					return(false);
				}
			}
			count ++;
		}
	}
	else{
		var increment = sign(y_to - y_from);
		var count = 0;
		var cell_y = y_from;
		
		while(count < len_y){
			cell_y += increment;
			var interpolation = abs(cell_y - y_from) / len_y;
			var cell_x = round(lerp(x_from, x_to, interpolation));

			if (cell_x != x_from or cell_y != y_from) and (cell_x != x_to or cell_y != y_to){
				if (grid[cell_x][cell_y].transparent == false){
					return(false);
				}
			}
			count ++;
		}
	}
	
	return(true);
}


// MAP VISIBILITY RESETTING
function grid_set_visible(grid, visibility){
	for (var i = 0; i < array_length(grid); i ++){
		for (var j = 0; j < array_length(grid[0]); j ++){
			grid[i][j].is_visible = visibility;
		}
	}
}

function grid_set_explored(grid, is_explored){
	for (var i = 0; i < array_length(grid); i ++){
		for (var j = 0; j < array_length(grid[0]); j ++){
			grid[i][j].explored = is_explored;
		}
	}
}




