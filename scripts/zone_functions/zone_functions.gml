// ZONE GENERATOR FUNCTIONS

// GENERATORS -------------------------------------------------------------------------------------
function zone_map_generate(target_array, world_cell_x, world_cell_y){
	var grid_biome_index	= target_array[world_cell_x][world_cell_y].biome;
	var grid_autotile_index	= target_array[world_cell_x][world_cell_y].index;
	var grid_has_dungeon	= target_array[world_cell_x][world_cell_y].dungeon;
	
	// Generate base zone map
	var new_zone_map = zone_function[grid_biome_index](grid_autotile_index, grid_has_dungeon, grid_biome_index);
	
	// Add village
	if (struct_exists(target_array[world_cell_x][world_cell_y], "village")){
		
		var new_village = generate_village(new_zone_map, world_cell_x, world_cell_y);
		
		new_zone_map			= new_village[0];
		var new_zone_occupants	= new_village[1];
		var new_faction			= new_village[2];
		
		// Add occupants
		map_spawn_villagers(new_zone_map, new_zone_occupants, 1, actor_elder, 0, noone, actor_farmer, 2, new_faction);
	}
	else{
		// Spawn mobs
		if (mob_lookup[grid_biome_index][MOB_LOOKUP.ZONE] != noone){
			map_spawn_mobs(mob_lookup[grid_biome_index][MOB_LOOKUP.ZONE], 5);
		}
	}
	
	return(new_zone_map);
}

function generate_zone_tile(tile_type){
	var new_tile = new tile_type();
	new_tile.index += irandom(floor(sprite_get_width(new_tile.sprite) / ZONE_TILE_SIZE) - 1);
	return(new_tile);
}

function zone_canyon(tile_image_index, tile_has_dungeon, tile_biome_index){
	var new_zone_map = initialise_temp_list();
	
	if (tile_has_dungeon){
		new_zone_map = dungeons_add_to_zone(new_zone_map, tile_biome_index);
	}
	
	for (var xx = 0; xx < ZONE_SIZE; xx ++){
		for (var yy = 0; yy < ZONE_SIZE; yy ++){
			if (new_zone_map[xx][yy] == noone){

				// Get tile image index for canyon wall position
				var new_tile = tile_lookup(zone_tile_lookup[tile_biome_index]);
				new_zone_map[xx][yy] = generate_zone_tile(new_tile);
			}
		}
	}
	
	// MAP NEIGHBOURS -----------------------------------------------------------------------------
	var tile_fill = [];
	tile_fill = map_edge_biome_fill(tile_image_index);
	
	return(new_zone_map);
}

function zone_river(tile_image_index, tile_has_dungeon, tile_biome_index){
	var new_zone_map = initialise_temp_list();
	
	if (tile_has_dungeon){
		new_zone_map = dungeons_add_to_zone(new_zone_map, tile_biome_index);
	}
	
	for (var xx = 0; xx < ZONE_SIZE; xx ++){
		for (var yy = 0; yy < ZONE_SIZE; yy ++){
			if (new_zone_map[xx][yy] == noone){
				new_zone_map[xx][yy] = generate_zone_tile(tile_zone_water);
			}
		}
	}
	
	// MAP NEIGHBOURS -----------------------------------------------------------------------------
	var tile_fill = [];
	tile_fill = map_edge_biome_fill(tile_image_index);
	
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
					var new_tile = tile_lookup(zone_tile_lookup[BIOME.DENSE_MANGROVE]);
					new_zone_map[x2][y2] = generate_zone_tile(new_tile);
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
					var new_tile = tile_lookup(zone_tile_lookup[BIOME.DENSE_MANGROVE]);
					new_zone_map[x2][y2] = generate_zone_tile(new_tile);
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
					var new_tile = tile_lookup(zone_tile_lookup[BIOME.DENSE_MANGROVE]);
					new_zone_map[x2][y2] = generate_zone_tile(new_tile);
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
					var new_tile = tile_lookup(zone_tile_lookup[BIOME.DENSE_MANGROVE]);
					new_zone_map[x2][y2] = generate_zone_tile(new_tile);
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
						var new_tile = tile_lookup(zone_tile_lookup[BIOME.DENSE_MANGROVE]);
						new_zone_map[x2][y2] = generate_zone_tile(new_tile);
					}
				}
			}
		}
	}
	
	new_zone_map = autotile_map(new_zone_map);
	
	// Water Feature Placement
	new_zone_map = water_tile_placement(new_zone_map);
	
	return(new_zone_map);
}

function map_edge_biome_fill(tile_image_index){
	var map_edge_fill = [];
	
	map_edge_fill[0] = false;	// Right edge
	map_edge_fill[1] = false;	// Top edge
	map_edge_fill[2] = false;	// Left edge
	map_edge_fill[3] = false;	// Bottom edge
	map_edge_fill[4] = false;	// Top right corner
	map_edge_fill[5] = false;	// Top left corner
	map_edge_fill[6] = false;	// bottom left corner
	map_edge_fill[7] = false;	// bottom right corner
			
	// Get tile image index for water bank position
	switch(tile_image_index){
		case 0:  map_edge_fill[0] = true	 map_edge_fill[1] = true	 map_edge_fill[2] = true	 map_edge_fill[3] = true;	break;
		case 1:  map_edge_fill[1] = true	 map_edge_fill[2] = true	 map_edge_fill[3] = true;							break;
		case 2:  map_edge_fill[0] = true	 map_edge_fill[2] = true	 map_edge_fill[3] = true;							break;
		case 3:  map_edge_fill[2] = true	 map_edge_fill[3] = true;													break;
		case 4:  map_edge_fill[0] = true	 map_edge_fill[1] = true	 map_edge_fill[3] = true;							break;
		case 5:  map_edge_fill[1] = true	 map_edge_fill[3] = true;													break;
		case 6:  map_edge_fill[0] = true	 map_edge_fill[3] = true	 map_edge_fill[5] = true;							break;
		case 7:  map_edge_fill[3] = true	 map_edge_fill[5] = true;													break;
		case 8:  map_edge_fill[0] = true	 map_edge_fill[1] = true	 map_edge_fill[2] = true;							break;
		case 9:  map_edge_fill[1] = true	 map_edge_fill[2] = true	 map_edge_fill[7] = true;							break;
		case 10: map_edge_fill[0] = true	 map_edge_fill[2] = true;													break;
		case 11: map_edge_fill[2] = true	 map_edge_fill[4] = true	 map_edge_fill[7] = true;							break;
		case 12: map_edge_fill[0] = true	 map_edge_fill[1] = true	 map_edge_fill[6] = true;							break;
		case 13: map_edge_fill[1] = true	 map_edge_fill[6] = true	 map_edge_fill[7] = true;							break;
		case 14: map_edge_fill[0] = true	 map_edge_fill[5] = true	 map_edge_fill[6] = true;							break;
		case 15: map_edge_fill[4] = true	 map_edge_fill[5] = true	 map_edge_fill[6] = true	 map_edge_fill[7] = true;	break;
		case 16: map_edge_fill[2] = true	 map_edge_fill[3] = true;													break;
		case 17: map_edge_fill[0] = true	 map_edge_fill[3] = true;													break;
		case 18: map_edge_fill[3] = true	 map_edge_fill[5] = true;													break;
		case 19: map_edge_fill[3] = true	 map_edge_fill[4] = true;													break;
		case 20: map_edge_fill[3] = true;																			break;
		case 21: map_edge_fill[1] = true	 map_edge_fill[2] = true;													break;
		case 22: map_edge_fill[2] = true	 map_edge_fill[7] = true;													break;
		case 23: map_edge_fill[2] = true	 map_edge_fill[4] = true;													break;
		case 24: map_edge_fill[2] = true;																			break;
		case 25: map_edge_fill[0] = true	 map_edge_fill[1] = true;													break;
		case 26: map_edge_fill[1] = true	 map_edge_fill[7] = true;													break;
		case 27: map_edge_fill[1] = true	 map_edge_fill[6] = true;													break;
		case 28: map_edge_fill[1] = true;																			break;
		case 29: map_edge_fill[0] = true	 map_edge_fill[6] = true;													break;
		case 30: map_edge_fill[0] = true	 map_edge_fill[5] = true;													break;
		case 31: map_edge_fill[0] = true;																			break;
		case 32: map_edge_fill[5] = true	 map_edge_fill[6] = true	 map_edge_fill[7] = true;							break;
		case 33: map_edge_fill[4] = true	 map_edge_fill[6] = true	 map_edge_fill[7] = true;							break;
		case 34: map_edge_fill[4] = true	 map_edge_fill[5] = true	 map_edge_fill[7] = true;							break;
		case 35: map_edge_fill[4] = true	 map_edge_fill[5] = true	 map_edge_fill[6] = true;							break;
		case 36: map_edge_fill[4] = true	 map_edge_fill[6] = true;													break;
		case 37: map_edge_fill[5] = true	 map_edge_fill[7] = true;													break;
		case 38: map_edge_fill[5] = true	 map_edge_fill[6] = true;													break;
		case 39: map_edge_fill[4] = true	 map_edge_fill[5] = true;													break;
		case 40: map_edge_fill[4] = true	 map_edge_fill[7] = true;													break;
		case 41: map_edge_fill[6] = true	 map_edge_fill[7] = true;													break;
		case 42: map_edge_fill[4] = true;																			break;
		case 43: map_edge_fill[5] = true;																			break;
		case 44: map_edge_fill[6] = true;																			break;
		case 45: map_edge_fill[7] = true;																			break;
		case 46: ;																								break;
				
	}
	
	return(map_edge_fill);
}

function zone_standard(tile_image_index, tile_has_dungeon, tile_biome_index){
	var new_zone_map = initialise_temp_list();
	
	for (var xx = 0; xx < ZONE_SIZE; xx ++){
		for (var yy = 0; yy < ZONE_SIZE; yy ++){
			if (new_zone_map[xx][yy] == noone){
				var new_tile = tile_lookup(zone_tile_lookup[tile_biome_index]);
				new_zone_map[xx][yy] = generate_zone_tile(new_tile);
			}
		}
	}
	
	// Add zone features
	if (zone_feature[tile_biome_index] != noone){
		
		var tile_type, choice, feature_count, max_radius, density;
		
		for (var i = 0; i < array_length(zone_feature[tile_biome_index]); i ++){
		
			tile_type		= zone_feature[tile_biome_index][i][1];
			choice			= irandom(array_length(zone_feature[tile_biome_index][i][0]) - 1);
			feature_count	= zone_feature[tile_biome_index][i][0][choice];
			max_radius		= zone_feature[tile_biome_index][i][2];
			density			= zone_feature[tile_biome_index][i][3];
			
			var centre_x, centre_y;
			
			repeat(feature_count){
				centre_x = irandom(ZONE_SIZE);
				centre_y = irandom(ZONE_SIZE);
				new_zone_map = zone_add_clump_feature(new_zone_map, tile_type, max_radius, density, centre_x, centre_y);
			}
		}
	}
	
	
	// Add tile_has_dungeon entrance
	if (tile_has_dungeon){
		new_zone_map = dungeons_add_to_zone(new_zone_map, tile_biome_index);
	}
	
	// Water Feature Placement
	new_zone_map = autotile_map(new_zone_map);
	new_zone_map = water_tile_placement(new_zone_map);
	
	return(new_zone_map);
}


// DUNGEON PLACEMENT ------------------------------------------------------------------------------
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


// ADD CLUMP FEATURES -----------------------------------------------------------------------------
function zone_add_clump_feature(target_array, tile_func, max_radius, density, centre_x, centre_y){
	
	var start_x, end_x, start_y, end_y;
	
	start_x = centre_x - max_radius;
	end_x	= centre_x + max_radius;
	start_y = centre_y - max_radius;
	end_y	= centre_y + max_radius;
	
	var cell_x, cell_y;
	
	for (cell_x = start_x; cell_x < end_x; cell_x ++){
		for (cell_y = start_y; cell_y < end_y; cell_y ++){
			
			if (grid_check_position_in_bounds(target_array, cell_x, cell_y)){
				var dist = round(point_distance(cell_x, cell_y, centre_x, centre_y));
			
				var tile_spawn_chance = ((max_radius - dist) / max_radius);
				var random_roll = random(density);
				if (random_roll < tile_spawn_chance){
					target_array[cell_x][cell_y] = generate_zone_tile(tile_func);
				}
			}
		}
	}
	
	return(target_array);
}




