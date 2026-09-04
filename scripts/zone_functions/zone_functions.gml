
function zone_canyon(world_index, dungeon, terrain){
	var temp_list = initialise_temp_list();
	
	if (dungeon){
		temp_list = dungeons_add_to_zone(temp_list, terrain);
	}
	
	for (var xx = 0; xx < ZONE_SIZE; xx ++){
		for (var yy = 0; yy < ZONE_SIZE; yy ++){
			if (temp_list[xx][yy] == noone){

				// Get tile image index for canyon wall position
				var new_tile = tile_lookup(terrain_lookup[terrain]);
				temp_list[xx][yy] = generate_zone_tile(new_tile);
			}
		}
	}
	return(temp_list);
}

function zone_river(world_index, dungeon, terrain){
	var temp_list = initialise_temp_list();
	
	if (dungeon){
		temp_list = dungeons_add_to_zone(temp_list, terrain);
	}
	
	for (var xx = 0; xx < ZONE_SIZE; xx ++){
		for (var yy = 0; yy < ZONE_SIZE; yy ++){
			if (temp_list[xx][yy] == noone){
				temp_list[xx][yy] = generate_zone_tile(tile_zone_water);
			}
		}
	}
	
	#region// MAP NEIGHBOURS ----------------------------------------------------------------------
	var tile_fill;
	tile_fill[0] = false;	// Right edge
	tile_fill[1] = false;	// Top edge
	tile_fill[2] = false;	// Left edge
	tile_fill[3] = false;	// Bottom edge
	tile_fill[4] = false;	// Top right corner
	tile_fill[5] = false;	// Top left corner
	tile_fill[6] = false;	// bottom left corner
	tile_fill[7] = false;	// bottom right corner
			
	// Get tile image index for water bank position
	switch(world_index){
		case 0:  tile_fill[0] = true	 tile_fill[1] = true	 tile_fill[2] = true	 tile_fill[3] = true;	break;
		case 1:  tile_fill[1] = true	 tile_fill[2] = true	 tile_fill[3] = true;							break;
		case 2:  tile_fill[0] = true	 tile_fill[2] = true	 tile_fill[3] = true;							break;
		case 3:  tile_fill[2] = true	 tile_fill[3] = true;													break;
		case 4:  tile_fill[0] = true	 tile_fill[1] = true	 tile_fill[3] = true;							break;
		case 5:  tile_fill[1] = true	 tile_fill[3] = true;													break;
		case 6:  tile_fill[0] = true	 tile_fill[3] = true	 tile_fill[5] = true;							break;
		case 7:  tile_fill[3] = true	 tile_fill[5] = true;													break;
		case 8:  tile_fill[0] = true	 tile_fill[1] = true	 tile_fill[2] = true;							break;
		case 9:  tile_fill[1] = true	 tile_fill[2] = true	 tile_fill[7] = true;							break;
		case 10: tile_fill[0] = true	 tile_fill[2] = true;													break;
		case 11: tile_fill[2] = true	 tile_fill[4] = true	 tile_fill[7] = true;							break;
		case 12: tile_fill[0] = true	 tile_fill[1] = true	 tile_fill[6] = true;							break;
		case 13: tile_fill[1] = true	 tile_fill[6] = true	 tile_fill[7] = true;							break;
		case 14: tile_fill[0] = true	 tile_fill[5] = true	 tile_fill[6] = true;							break;
		case 15: tile_fill[4] = true	 tile_fill[5] = true	 tile_fill[6] = true	 tile_fill[7] = true;	break;
		case 16: tile_fill[2] = true	 tile_fill[3] = true;													break;
		case 17: tile_fill[0] = true	 tile_fill[3] = true;													break;
		case 18: tile_fill[3] = true	 tile_fill[5] = true;													break;
		case 19: tile_fill[3] = true	 tile_fill[4] = true;													break;
		case 20: tile_fill[3] = true;																			break;
		case 21: tile_fill[1] = true	 tile_fill[2] = true;													break;
		case 22: tile_fill[2] = true	 tile_fill[7] = true;													break;
		case 23: tile_fill[2] = true	 tile_fill[4] = true;													break;
		case 24: tile_fill[2] = true;																			break;
		case 25: tile_fill[0] = true	 tile_fill[1] = true;													break;
		case 26: tile_fill[1] = true	 tile_fill[7] = true;													break;
		case 27: tile_fill[1] = true	 tile_fill[6] = true;													break;
		case 28: tile_fill[1] = true;																			break;
		case 29: tile_fill[0] = true	 tile_fill[6] = true;													break;
		case 30: tile_fill[0] = true	 tile_fill[5] = true;													break;
		case 31: tile_fill[0] = true;																			break;
		case 32: tile_fill[5] = true	 tile_fill[6] = true	 tile_fill[7] = true;							break;
		case 33: tile_fill[4] = true	 tile_fill[6] = true	 tile_fill[7] = true;							break;
		case 34: tile_fill[4] = true	 tile_fill[5] = true	 tile_fill[7] = true;							break;
		case 35: tile_fill[4] = true	 tile_fill[5] = true	 tile_fill[6] = true;							break;
		case 36: tile_fill[4] = true	 tile_fill[6] = true;													break;
		case 37: tile_fill[5] = true	 tile_fill[7] = true;													break;
		case 38: tile_fill[5] = true	 tile_fill[6] = true;													break;
		case 39: tile_fill[4] = true	 tile_fill[5] = true;													break;
		case 40: tile_fill[4] = true	 tile_fill[7] = true;													break;
		case 41: tile_fill[6] = true	 tile_fill[7] = true;													break;
		case 42: tile_fill[4] = true;																			break;
		case 43: tile_fill[5] = true;																			break;
		case 44: tile_fill[6] = true;																			break;
		case 45: tile_fill[7] = true;																			break;
		case 46: ;																								break;
				
	}
	
	#endregion
	
	var x2, y2, dist, anchor_x, anchor_y, tile_chance;
	
	// Right edge fill
	if (tile_fill[0] == true){
		anchor_x = ZONE_SIZE - 1;
		for (x2 = 0; x2 < ZONE_SIZE; x2 ++){
			for (y2 = 0; y2 < ZONE_SIZE; y2 ++){
				anchor_y = y2;
				dist = point_distance(x2, y2, anchor_x, anchor_y);
				tile_chance = dist / zone_third;
				if (random(1) >= tile_chance){
					var new_tile = tile_lookup(terrain_lookup[BIOME.DENSE_MANGROVE]);
					temp_list[x2][y2] = generate_zone_tile(new_tile);
				}
			}
		}
	}
			
	// Top edge tiling
	if (tile_fill[1] == true){
		anchor_y = 0;
		for (x2 = 0; x2 < ZONE_SIZE; x2 ++){
			anchor_x = x2;
			for (y2 = 0; y2 < ZONE_SIZE; y2 ++){
				dist = point_distance(x2, y2, anchor_x, anchor_y);
				tile_chance = dist / zone_third;
				if (random(1) >= tile_chance){
					var new_tile = tile_lookup(terrain_lookup[BIOME.DENSE_MANGROVE]);
					temp_list[x2][y2] = generate_zone_tile(new_tile);
				}
			}
		}
	}
	
	// Left edge fill
	if (tile_fill[2] == true){
		anchor_x = 0;
		for (x2 = 0; x2 < ZONE_SIZE; x2 ++){
			for (y2 = 0; y2 < ZONE_SIZE; y2 ++){
				anchor_y = y2;
				dist = point_distance(x2, y2, anchor_x, anchor_y);
				tile_chance = dist / zone_third;
				if (random(1) >= tile_chance){
					var new_tile = tile_lookup(terrain_lookup[BIOME.DENSE_MANGROVE]);
					temp_list[x2][y2] = generate_zone_tile(new_tile);
				}
			}
		}
	}
	
	// Bottom edge fill
	if (tile_fill[3] == true){
		anchor_y = ZONE_SIZE - 1;
		for (x2 = 0; x2 < ZONE_SIZE; x2 ++){
			anchor_x = x2;
			for (y2 = 0; y2 < ZONE_SIZE; y2 ++){
				dist = point_distance(x2, y2, anchor_x, anchor_y);
				tile_chance = dist / zone_third;
				if (random(1) >= tile_chance){
					var new_tile = tile_lookup(terrain_lookup[BIOME.DENSE_MANGROVE]);
					temp_list[x2][y2] = generate_zone_tile(new_tile);
				}
			}
		}
	}
	
	// Corner fill
	for (var i = 4; i < array_length(tile_fill); i ++){
		if (tile_fill[i] == true){
			
			switch(i){
				case 4: anchor_x = ZONE_SIZE - 1 anchor_y = 0; break;
				case 5: anchor_x = 0 anchor_y = 0; break;
				case 6: anchor_x = 0 anchor_y = ZONE_SIZE - 1; break;
				case 7: anchor_x = ZONE_SIZE - 1 anchor_y = ZONE_SIZE - 1; break;
			}
		
			for (x2 = 0; x2 < ZONE_SIZE; x2 ++){
				for (y2 = 0; y2 < ZONE_SIZE; y2 ++){
					dist = point_distance(x2, y2, anchor_x, anchor_y);
					tile_chance = dist / zone_third;
					if (random(1) >= tile_chance){
						var new_tile = tile_lookup(terrain_lookup[BIOME.DENSE_MANGROVE]);
						temp_list[x2][y2] = generate_zone_tile(new_tile);
					}
				}
			}
		}
	}
	
	temp_list = autotile_map(temp_list);
	
	// Water Feature Placement
	temp_list = water_tile_placement(temp_list);
	
	return(temp_list);
}

function zone_standard(world_index, dungeon, biome_index){
	var new_map = initialise_temp_list();
	
	if (dungeon){
		new_map = dungeons_add_to_zone(new_map, biome_index);
	}
	
	for (var xx = 0; xx < ZONE_SIZE; xx ++){
		for (var yy = 0; yy < ZONE_SIZE; yy ++){
			if (new_map[xx][yy] == noone){
				var new_tile = tile_lookup(terrain_lookup[biome_index]);
				new_map[xx][yy] = generate_zone_tile(new_tile);
			}
		}
	}
	
	// Add lakes
	if (zone_lakes[biome_index] != noone){
		var lakes_min = zone_lakes[biome_index][0];
		var lakes_max = zone_lakes[biome_index][1];
		var lake_count = irandom_range(lakes_min, lakes_max);
		
		var min_radius				= zone_lakes[biome_index][2];
		var grow_diminish_amount	= zone_lakes[biome_index][3];
		
		repeat(lake_count){
			var grow_count		= 0;
			var grow_chance		= 1;
			var lake_start_x	= irandom(ZONE_SIZE);
			var lake_start_y	= irandom(ZONE_SIZE);
		
			var lake_temp_list;
			lake_temp_list[0] = [lake_start_x, lake_start_y];
		
			while(array_length(lake_temp_list) > 0){
				var candidate_list = [];
			
				grow_count ++;
				if (grow_count > min_radius){
					grow_chance -= grow_diminish_amount;
				}
			
				for (var i = 0; i < array_length(lake_temp_list); i ++){
				
					var cell_x = lake_temp_list[i][0];
					var cell_y = lake_temp_list[i][1];
				
					for (var j = 0; j < 4; j ++){
						var dir = j * 90;
						xx = cell_x + lengthdir_x(1, dir);
						yy = cell_y + lengthdir_y(1, dir);
						var in_bounds = grid_check_position_in_bounds(new_map, xx, yy);
						if (in_bounds){
							var chance_roll = random(1);
							if (chance_roll < grow_chance and new_map[xx][yy].tile != "water"){
								array_push(candidate_list, [xx, yy]);
								new_map[xx][yy] = generate_zone_tile(tile_zone_water);
							}
						}
					}
				}
				lake_temp_list = candidate_list;
			}
		}
	}
	
	// Water Feature Placement
	new_map = autotile_map(new_map);
	new_map = water_tile_placement(new_map);
	
	return(new_map);
}

// Dungeon placement
function initialise_temp_list(){
	var temp_list = [];
	for (var i = 0; i < ZONE_SIZE; i ++){
		for (var j = 0; j < ZONE_SIZE; j ++){
			temp_list[i][j] = noone;
		}
	}
	return(temp_list);
}

function dungeons_add_to_zone(grid, type){
	var dx = irandom_range(zone_third, ZONE_SIZE - zone_third);
	var dy = irandom_range(zone_third, ZONE_SIZE - zone_third);
	var ind = 9 - type;
	
	grid[dx][dy]				= new tile_dungeon_entrance();
	grid[dx][dy].index			= ind;
	grid[dx][dy].dungeon_list	= array_create(dungeons[ind].max_depth, noone);
	
	return(grid);
	
}




