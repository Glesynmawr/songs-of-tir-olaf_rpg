function generate_village(zone_map, world_x, world_y){
	
	//var village_index	= game_state.world_map[world_x][world_y].has_village;
	var village_map		= variable_clone(zone_map);
	
	// Placement variables
	var building_count		= 4;
	var building_size		= [5, 5]; // RADIUS for round buildings, HEIGHT AND WIDTH for rectangular
	var building_distance	= 8; // Distance to CENTRE of building
	var stagger_amount		= 0; // MULTIPLIER applied to building_distance
	
	// Appearance variables
	var has_raised_ground	= true;
	var building_shape		= BUILDING_SHAPE.RECTANGLE;
	var wall_tile  = tile_wall_redwood;
	var floor_tile = tile_floor_planks;
	
	// Set building starting positions
	var building_list = [];
	building_list = buildings_set_positions(building_count, building_distance, stagger_amount)
	
	if (building_shape == BUILDING_SHAPE.ROUND){
		village_map = buildings_create_round(village_map, building_list, floor_tile, building_size, has_raised_ground);
	}
	else if (building_shape == BUILDING_SHAPE.RECTANGLE){
		village_map = buildings_create_rectangle(village_map, building_list, floor_tile, building_size, has_raised_ground);
	}
	
	// Add walls
	village_map = buildings_add_walls(village_map, wall_tile);
	
	// Add focal point
	
	// Add decor
	
	// Add NPCs
	
	return(village_map);
}

function buildings_set_positions(number_of_buildings, building_distance, stagger_amount){
	
	var building_list = [];
	
	// Initialise direction variables
	var start_dir = irandom(360);
	var angle_inc = 360 / number_of_buildings;
	var dir = start_dir;
	
	for (var i = 0; i < number_of_buildings; i ++){
		
		var dist = building_distance;
		if (stagger_amount != 0){
			if (i mod 2 == 1){
				dist = floor(building_distance * stagger_amount);
			}
		}
		
		var xx = (ZONE_SIZE / 2) + lengthdir_x(dist, dir);
		var yy = (ZONE_SIZE / 2) + lengthdir_y(dist, dir);
		array_push(building_list, [xx, yy]);
		dir += angle_inc;
	}
	
	return(building_list);
}

function buildings_create_round(grid, building_list, floor_tile, building_size, has_raised_ground){
	
	for (var i = 0; i < array_length(building_list); i ++){
		
		var xx = building_list[i][0];
		var yy = building_list[i][1];
		
		// Add raised ground
		if (has_raised_ground){
			zone_add_clump_feature(grid, tile_zone_raised_ground, 1, building_size + 3, 0.3, xx, yy);
		}
		
		// Autotile raised ground
		grid = autotile_map(grid);
		grid = water_tile_placement(grid);
		
		// Add building floor
		zone_add_clump_feature(grid, floor_tile, 1, building_size - 1, 0, xx, yy);
	}
	
	return(grid);
}

function buildings_create_rectangle(grid, building_list, floor_tile, building_size, has_raised_ground){
	
	for (var i = 0; i < array_length(building_list); i ++){
		
		var xx = building_list[i][0];
		var yy = building_list[i][1];
		var ww = building_size[0] - 2;
		var hh = building_size[1] - 2;
		
		// Add raised ground
		if (has_raised_ground){
			var ground_size = max(ww, hh) + 3;
			zone_add_clump_feature(grid, tile_zone_raised_ground, 1, ground_size, 0.3, xx, yy);
		}
		
		// Autotile raised ground
		grid = autotile_map(grid);
		grid = water_tile_placement(grid);
		
		// Add building floor
		xx -= floor(ww / 2);
		yy -= floor(hh / 2);
		
		for (var x_pos = xx; x_pos < xx + ww; x_pos ++){
			for (var y_pos = yy; y_pos < yy + hh; y_pos ++){
				grid[x_pos][y_pos] = new floor_tile();
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
	// Autotile walls
	for (i = 0; i < ww; i ++){
		for (var j = 0; j < hh; j ++){
			var tile = grid[i][j].tile;
			if (tile == "wall"){
				grid[i][j].index  = autotile_47(grid, "wall", i, j);
			}
		}
	}
	return(grid);
}



