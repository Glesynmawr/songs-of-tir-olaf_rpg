function generate_village(zone_map, world_x, world_y){
	
	//var village_index	= game_state.world_map[world_x][world_y].has_village;
	var village_map		= variable_clone(zone_map);
	
	var has_raised_ground	= true;
	var hut_count			= 6;
	var hut_size			= 4;
	var hut_dist			= 14;
	
	var wall_tile  = tile_wall_redwood;
	var floor_tile = tile_floor_planks;
	
	var start_dir = irandom(360);
	var angle_inc = 360 / hut_count;
	var dir = start_dir;
	
	// Add raised ground if needed
	if (has_raised_ground){
		for (var i = 0; i < hut_count; i ++){
		
			var xx = (ZONE_SIZE / 2) + lengthdir_x(hut_dist, dir);
			var yy = (ZONE_SIZE / 2) + lengthdir_y(hut_dist, dir);
			zone_add_clump_feature(village_map, tile_zone_raised_ground, 1, hut_size + 3, 0, xx, yy);
			dir += angle_inc;
		}
	}
	
	// Autotile raised ground
	village_map = autotile_map(village_map);
	village_map = water_tile_placement(village_map);
	
	// Add hut floors
	dir = start_dir;
	for (var i = 0; i < hut_count; i ++){
		
		var xx = (ZONE_SIZE / 2) + lengthdir_x(hut_dist, dir);
		var yy = (ZONE_SIZE / 2) + lengthdir_y(hut_dist, dir);
		
		zone_add_clump_feature(village_map, floor_tile, 1, hut_size, 0, xx, yy);
		
		dir += angle_inc;
	}
	
	// Add walls
	var ww = array_length(village_map);
	var hh = array_length(village_map[0]);
	
	for (i = 0; i < ww; i ++){
		for (var j = 0; j < hh; j ++){
			var floor_check = grid_check_neighbour_count(village_map, i, j, "floor", NEIGHBOUR_CHECK.ALL);
			var tile = village_map[i][j].tile;
			if (tile != "floor" and floor_check > 0){
				village_map[i][j] = new wall_tile();
			}
		}
	}
	// Autotile walls
	for (i = 0; i < ww; i ++){
		for (var j = 0; j < hh; j ++){
			var tile = village_map[i][j].tile;
			if (tile == "wall"){
				village_map[i][j].index  = autotile_47(village_map, "wall", i, j);
			}
		}
	}
	
	// Add focal point
	
	// Add decor
	
	// Add NPCs
	
	return(village_map);
}




