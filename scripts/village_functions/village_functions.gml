
// VILLAGE GENERATOR ------------------------------------------------------------------------------
function generate_village(zone_map, world_x, world_y){
	
	// Create new faction
	init_new_faction(10, 20);
	var new_village_faction = array_length(game_state.faction_list)-1;
	
	var village_map				= variable_clone(zone_map);
	
	// Placement variables
	var centre_x = choose(0, 1);
	var centre_y = choose(0, 1);
	
	var farm_x, farm_y;
	
	if (centre_x == 0){
		centre_x	= floor(ZONE_SIZE * 0.4);
		farm_x		= floor(ZONE_SIZE * 0.66);
	}
	else{
		centre_x	= floor(ZONE_SIZE * 0.6);
		farm_x		= floor(ZONE_SIZE * 0.33);
	}
	if (centre_y == 0){
		centre_y	= floor(ZONE_SIZE * 0.4);
		farm_y		= floor(ZONE_SIZE * 0.66);
	}
	else{
		centre_y	= floor(ZONE_SIZE * 0.6);
		farm_y		= floor(ZONE_SIZE * 0.33);
	}
	
	var building_count		= game_state.world_map[world_x][world_y].village.building_count;
	var building_size		= game_state.world_map[world_x][world_y].village.building_size;		// RADIUS for round buildings, HEIGHT AND WIDTH for rectangular
	var building_distance	= game_state.world_map[world_x][world_y].village.building_distance; // Distance to CENTRE of building
	var stagger_amount		= game_state.world_map[world_x][world_y].village.building_stagger;	// MULTIPLIER applied to building_distance
	
	// Appearance variables
	var has_raised_ground	= game_state.world_map[world_x][world_y].village.raised_ground;
	var floor_tile			= game_state.world_map[world_x][world_y].village.floor_tile;
	var wall_tile			= game_state.world_map[world_x][world_y].village.wall_tile;
	var decor_index			= game_state.world_map[world_x][world_y].village.decor_index;
	var furnish_list		= game_state.world_map[world_x][world_y].village.furnish_list;
	
	// Crops
	var farm_function		= game_state.world_map[world_x][world_x].village.farm_spawn_function;
	var crop_tile			= game_state.world_map[world_x][world_y].village.crop;
	var ripe_tile			= game_state.world_map[world_x][world_y].village.crop_ripe;
	
	// Set building starting positions
	var building_list = [];
	building_list = buildings_set_positions(centre_x, centre_y, building_count, building_distance, building_size, stagger_amount, furnish_list, building_size[0], furnish_focal_cauldron)
	
	// Add farming region
	village_map = farm_function(village_map, farm_x, farm_y, crop_tile, ripe_tile);
	
	// Add raised ground
	if (has_raised_ground){
		village_map = buildings_create_raised_ground(village_map, building_list, building_distance);
	}
	
	village_map = buildings_create_rectangle(village_map, building_list, floor_tile);
	
	// Add focal point
	village_map = zone_add_clump_feature(village_map, floor_tile, 1, building_size[0] - 1, 0, centre_x, centre_y);
	
	// Add walls
	village_map = buildings_add_walls(village_map, wall_tile);
	
	// Add doors
	village_map = buildings_add_doors(village_map, building_list, decor_index);
	
	// Autotile walls
	village_map = buildings_autotile_walls(village_map);

	// Add building decor
	village_occupant_count	= 0;
	
	for (var i = 0; i < array_length(building_list); i ++){
		var xx			= building_list[i][0];
		var yy			= building_list[i][1];
		var ww			= building_list[i][2];
		var hh			= building_list[i][3];
		var door_dir	= building_list[i][4];
		var decor		= building_list[i][5];
		
		if (decor != noone){
			var decor_return = decor(village_map, xx, yy, ww, hh, door_dir, decor_index);
			village_map				 = decor_return[0];
			village_occupant_count	+= decor_return[1];
		}
	}
	
	
	// Add cauldron seating
	
	// Add crops
	village_map = water_crop_tile_placement(village_map, crop_tile, ripe_tile);
	
	// Return map
	return([village_map, village_occupant_count, new_village_faction]);
}

// GENERATE VILLAGERS -----------------------------------------------------------------------------

// BUILDING POSITIONS AND TILES -------------------------------------------------------------------
function buildings_set_positions(centre_x, centre_y, number_of_buildings, building_distance, building_size, stagger_amount, furnish_list, focal_point_radius, focal_furnish){
	
	var building_list = [];
	
	// Initialise direction variables
	var start_dir = 0 //irandom(360);
	var angle_inc = 360 / number_of_buildings;
	var dir = start_dir;
	
	for (var i = 0; i < number_of_buildings; i ++){
		
		var ww = building_size[0];
		var hh = building_size[1];
		
		// Change orientation
		if (random(1) > 0.5){
			ww = building_size[1];
			hh = building_size[0];
		}
		
		// Random size
		ww += irandom(1);
		hh += irandom(1);
		
		var dist = building_distance;
		if (stagger_amount != 0){
			if (i mod 2 == 1){
				dist = floor(building_distance * stagger_amount);
			}
		}
		
		var xx = centre_x + lengthdir_x(dist, dir);
		var yy = centre_y + lengthdir_y(dist, dir);
		
		var door_direction = point_direction(xx, yy, centre_x, centre_y);
		door_direction = round(door_direction / 90);
		if (door_direction == 4) door_direction = 0;
		
		var choice = irandom(array_length(furnish_list)-1);
		var decor = furnish_list[choice];
		
		xx -= floor(ww / 2)
		yy -= floor(hh / 2)
		
		array_push(building_list, [xx, yy, ww, hh, door_direction, decor]);
		dir += angle_inc;
	}
	array_push(building_list, [centre_x - focal_point_radius, centre_y - focal_point_radius, focal_point_radius * 2, focal_point_radius * 2, noone, focal_furnish]);
	
	return(building_list);
}

function buildings_create_raised_ground(grid, building_list, building_distance){
	
	zone_add_clump_feature(grid, tile_zone_raised_ground, 1, building_distance, 0, ZONE_SIZE / 2, ZONE_SIZE / 2);
	
	for (var i = 0; i < array_length(building_list); i ++){
		
		var xx = building_list[i][0];
		var yy = building_list[i][1];
		var ww = building_list[i][2];
		var hh = building_list[i][3];
		
		// Add raised ground
		ground_size = max(ww, hh) + 4;
		zone_add_clump_feature(grid, tile_zone_raised_ground, 1, ground_size, 0.4, xx + floor(ww / 2), yy + floor(hh / 2));
			
		ground_size -= 3;
		zone_add_clump_feature(grid, tile_zone_raised_ground, 1, ground_size, 0, xx + floor(ww / 2), yy + floor(hh / 2));

	}
	
	return(grid);
}

// Autotiling happens here!
function buildings_create_rectangle(grid, building_list, floor_tile){
	
	for (var i = 0; i < array_length(building_list); i ++){
		
		if (i == array_length(building_list) - 1){
			
		}
		else {
			var xx = building_list[i][0];
			var yy = building_list[i][1];
			var ww = building_list[i][2];
			var hh = building_list[i][3];
		
			// Autotile raised ground
			grid = autotile_map(grid); 
		
			// Add building floor
			for (var x_pos = xx; x_pos < xx + ww; x_pos ++){
				for (var y_pos = yy; y_pos < yy + hh; y_pos ++){
					grid[x_pos][y_pos] = generate_zone_tile(floor_tile);
				}
			}
		}
	}
	return(grid);
}

function buildings_add_walls(grid, wall_tile){
	var ww = array_length(grid);
	var hh = array_length(grid[0]);
	
	for (var i = 0; i < ww; i ++){
		for (var j = 0; j < hh; j ++){
			var floor_check = grid_check_neighbour_count(grid, i, j, "floor", NEIGHBOUR_CHECK.ALL);
			var tile = grid[i][j].tile;
			if (tile != "floor" and floor_check > 0){
				grid[i][j] = new wall_tile();
			}
		}
	}
	return(grid);
}

function buildings_autotile_walls(grid){
	var ww = array_length(grid);
	var hh = array_length(grid[0]);
	
	// Autotile walls
	for (var i = 0; i < ww; i ++){
		for (var j = 0; j < hh; j ++){
			var tile = grid[i][j].tile;
			if (tile == "wall"){
				grid[i][j].index  = autotile_47(grid, "wall", i, j);
			}
		}
	}
	return(grid);
}

function buildings_add_doors(grid, building_list, door_index){
	
	var x_pos, y_pos;
	var len = array_length(building_list);
	
	for (var i = 0; i < len; i ++){
		
		var xx = building_list[i][0] - 1;
		var yy = building_list[i][1] - 1;
		var ww = building_list[i][2] + 1;
		var hh = building_list[i][3] + 1;
		
		if (i == len - 1){
			
			// Doors
			x_pos = xx + ceil(ww / 2);
			y_pos = yy + 2;
			grid[x_pos][y_pos] = new tile_door_closed();
			grid[x_pos][y_pos].index = door_index;
	
			x_pos = xx + ceil(ww / 2);
			y_pos = yy + hh - 1;
			grid[x_pos][y_pos] = new tile_door_closed();
			grid[x_pos][y_pos].index = door_index;
	
			x_pos = xx + 2;
			y_pos = yy + ceil(hh / 2);
			grid[x_pos][y_pos] = new tile_door_closed();
			grid[x_pos][y_pos].index = door_index;
	
			x_pos = xx + ww - 1;
			y_pos = yy + ceil(hh / 2);
			grid[x_pos][y_pos] = new tile_door_closed();
			grid[x_pos][y_pos].index = door_index;
		}
		else{
		
			var door_direction = building_list[i][4];
		
			var building_centre_x = xx + (ww / 2);
			var building_centre_y = yy + (hh / 2);
			var zone_centre       = ZONE_SIZE / 2;
		
			// Find wall tile index target
			var dir_to_centre = point_direction(zone_centre, zone_centre, building_centre_x, building_centre_y);
			var target_index = 5;
			if ((dir_to_centre < 45) or (dir_to_centre > 315) or (dir_to_centre > 135 and dir_to_centre < 225)){
				target_index = 10;
			}
		
			if (door_direction == 0){
				// EAST wall door
				y_pos = yy + irandom_range(1, hh - 1);
				x_pos = xx + ww;
			}
			else if (door_direction == 1){
				// NORTH wall door
				y_pos = yy;
				x_pos = xx + irandom_range(1, ww - 1);
			}
			else if (door_direction == 2){
				// WEST wall door
				y_pos = yy + irandom_range(1, hh - 1);
				x_pos = xx;
			}
			else if (door_direction == 3){
				// SOUTH wall door
				y_pos = yy + hh;
				x_pos = xx + irandom_range(1, ww - 1);
			}
			
			grid[x_pos][y_pos] = new tile_door_closed();
			grid[x_pos][y_pos].index = door_index;
		
		}
	}
	
	return(grid);
}


// FARMING AREAS
function farms_add_water_crop(grid, farm_x, farm_y){
	
	var crop_grid = variable_clone(grid);
	
	// Place water feature
	crop_grid = zone_add_clump_feature(crop_grid, tile_zone_water, 1, floor(ZONE_SIZE * 0.33), 0, farm_x, farm_y);
	
	return(crop_grid);
}


// FURNISHING FUNCTIONS ---------------------------------------------------------------------------
function furnish_home(grid, x_pos, y_pos, width, height, door_dir, decor_index){
	
	// Cook pot
	var xx = x_pos + floor(width / 2);
	var yy = y_pos + floor(height / 2);
	grid[xx][yy] = new tile_cook_pot();
	grid[xx][yy].index = decor_index;
	
	// Cabinet
	if (door_dir == 0){
		var yy = y_pos + irandom_range(1, height - 1);
		var xx = x_pos;
	}
	else if (door_dir == 1){
		var yy = y_pos + (height - 1);
		var xx = x_pos + irandom_range(1, width - 1);
	}
	else if (door_dir == 2){
		var yy = y_pos + irandom_range(1, height - 1);
		var xx = x_pos + (width - 1);
	}
	else if (door_dir == 3){
		var yy = y_pos;
		var xx = x_pos + irandom_range(1, width - 1);
	}
	
	if (door_dir != noone){
		grid[xx][yy] = new tile_cabinet();
		grid[xx][yy].index = decor_index;
	}
	
	// Beds
	var occupants		= floor((width * height) / 6);
	var total_occupants = 0;
	
	repeat(occupants){
		var candidate_list = [];
		
		for (var i = x_pos; i < x_pos + width; i ++){
			for (var j = y_pos; j < y_pos + height; j ++){
				if (grid[i][j].tile == "floor"){
					var door_check		= grid_check_neighbour_count(grid, i, j, "closed door", NEIGHBOUR_CHECK.ALL);
					var cookpot_check	= grid_check_neighbour_count(grid, i, j, "cook pot", NEIGHBOUR_CHECK.ALL);
					var wall_check		= grid_check_neighbour_count(grid, i, j, "wall", NEIGHBOUR_CHECK.ORTH);
					var bed_check		= grid_check_neighbour_count(grid, i, j, "bed", NEIGHBOUR_CHECK.ALL);
					var cabinet_check	= grid_check_neighbour_count(grid, i, j, "cabinet", NEIGHBOUR_CHECK.DIAG);
					
					if (wall_check > 0 and door_check == 0 and cookpot_check == 0 and bed_check == 0 and cabinet_check == 0){
						array_push(candidate_list, [i, j]);
					}
				}
			}
		}
		
		var len = array_length(candidate_list);
		if (len > 0){
			var choice = irandom(len - 1);
			xx = candidate_list[choice][0];
			yy = candidate_list[choice][1];
			grid[xx][yy] = new tile_bed();
			grid[xx][yy].index = decor_index;
			total_occupants ++;
		}
	}
	
	return([grid, total_occupants]);
}

function furnish_focal_cauldron(grid, x_pos, y_pos, width, height, door_dir, decor_index){
	
	// Cook pot
	var xx = x_pos + floor(width / 2);
	var yy = y_pos + floor(height / 2);
	grid[xx][yy] = new tile_cook_pot();
	grid[xx][yy].index = decor_index;
	
	// Cushions
	repeat(village_occupant_count){
		var candidate_list = [];
		for (var i = x_pos; i < x_pos + width; i ++){
			for (var j = y_pos; j < y_pos + height; j ++){
				if (i != x_pos + floor(width / 2)) and (j != y_pos + floor(height / 2)){
					if (grid[i][j].tile == "floor"){
						array_push(candidate_list, [i, j]);
					}
				}
			}
		}
		var len = array_length(candidate_list);
		if (len > 0){
			var choice = irandom(len - 1);
			xx = candidate_list[choice][0];
			yy = candidate_list[choice][1];
			grid[xx][yy] = generate_zone_tile(tile_floor_cushion);
		}
	}
	
	return([grid, 0]);
}




