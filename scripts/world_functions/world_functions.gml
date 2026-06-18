
function world_generate(){
	
	tiles_per_biome = 8;
	zone_size		= 36;
	zone_third		= floor(zone_size / 3);
	
	// Biome counts
	biome[0] = 50;	// Mountains
	biome[1] = 70;	// Hills
	biome[2] = 90;	// Canyon
	biome[3] = 180;	// Salt plains
	biome[4] = 100;	// Scrubland
	biome[5] = 70;	// Marsh
	biome[6] = 120;	// Mangrove
	biome[7] = 80;	// Water
	biome[8] = 60;	// Mangrove
	biome[9] = 50;	// Marsh
	
	tile[0] = tile_world_mountain;
	tile[1] = tile_world_hill;
	tile[2] = tile_world_canyon;
	tile[3] = tile_world_salt_plain;
	tile[4] = tile_world_scrubland;
	tile[5] = tile_world_marsh;
	tile[6] = tile_world_mangrove;
	tile[7] = tile_world_water;
	tile[8] = tile_world_mangrove;
	tile[9] = tile_world_marsh;
	
	terrain_lookup[BIOME.MOUNTAIN]	= [tile_zone_rocks, noone];
	terrain_lookup[BIOME.HILL]		= 0;
	terrain_lookup[BIOME.CANYON]	= 0;
	terrain_lookup[BIOME.DESERT]	= 0;
	terrain_lookup[BIOME.SCRUB]		= 0;
	terrain_lookup[BIOME.MARSH]		= [[tile_zone_tree, 5], [tile_zone_reeds, 10], [tile_zone_dirt, 25], [tile_zone_marsh, 100]];
	terrain_lookup[BIOME.FOREST]	= [[tile_zone_rocks, 2], [tile_zone_tree, 30], [tile_zone_water, 60], [tile_zone_dirt, 100]];
	terrain_lookup[BIOME.WATER]		= [[tile_zone_tree, 2], [tile_zone_reeds, 5], [tile_zone_lilypad, 20], [tile_zone_water, 100]];
	
	// Initialise world grid
	world_grid = world_grid_initialise(WORLD_WIDTH, WORLD_HEIGHT);
	
	// Add texture
	world_grid = noise_generate(world_grid);
	
	// Add biomes
	world_grid = biomes_add(world_grid);
	
	// Smoothing passes
	world_grid = map_smoothing(world_grid);
	
	// Autotile river and canyon
	world_grid = autotile_map(world_grid);
	
	// Generate zone maps
	zone_map = [];
	for (var xx = 0; xx < WORLD_WIDTH; xx ++){
		for (var yy = 0; yy < WORLD_HEIGHT; yy ++){
			zone_map[xx][yy] = zone_map_generate(world_grid, xx, yy);
			initialise_item_grid(zone_map[xx][yy], zone_size, zone_size);
		}
	}
	
	// Set player start position
	for (xx = 0; xx < WORLD_WIDTH; xx ++){
		for (yy = 0; yy < WORLD_HEIGHT; yy ++){
			if (world_grid[xx][yy].tile == "marsh"){
				player_start_x = xx;
				player_start_y = yy;
				break;
			}
		}
	}
	
	return(world_grid);
}

function world_grid_initialise(width, height){
	
	// Initialise grid
	var grid = [];
	for (var i = 0; i < WORLD_WIDTH; i ++){
		for (var j = 0; j < WORLD_HEIGHT; j ++){
			grid[i][j] = 0;
		}
	}
	
	// Initial anchors
	grid[0][0] = 0;
	grid[0][WORLD_HEIGHT - 1] = 30;
	grid[WORLD_WIDTH - 1][0] = 60;
	grid[WORLD_WIDTH - 1][WORLD_HEIGHT - 1] = 90;
	
	var anchor1 = grid[0][0];
	var anchor2 = grid[0][WORLD_HEIGHT - 1];
	var anchor3 = grid[WORLD_WIDTH - 1][0];
	var anchor4 = grid[WORLD_WIDTH - 1][WORLD_HEIGHT - 1];
		
	// Vertical lerp
	for (j = 0; j < WORLD_HEIGHT; j ++){
		
		var lerp_amount = j / (WORLD_HEIGHT - 1);
		var lerp_value = lerp(anchor1, anchor2, lerp_amount);
		grid[0][j] = round(lerp_value);
		
		var lerp_value = lerp(anchor3, anchor4, lerp_amount);
		grid[WORLD_WIDTH - 1][j] = round(lerp_value);
	}
	
	// Horizontal lerp
	for (i = 0; i < WORLD_WIDTH; i ++){
		for (j = 0; j < WORLD_HEIGHT; j ++){
			if (grid[i][j] != 0){
				continue;
			}
			anchor1 = grid[0][j];
			anchor2 = grid[WORLD_WIDTH - 1][j];
			
			var lerp_amount = i / (WORLD_WIDTH - 1);
			var lerp_value = lerp(anchor1, anchor2, lerp_amount);
			grid[i][j] = round(lerp_value);
		}
	}
	
	return(grid);
}

function noise_generate(grid){
	
	var temp_map = [];
	var passes = 3;
	var chunk_size = 12;
	var amplitude = 16;
	
	var i, j, p;
	for (p = 0; p < passes; p ++){
		
		// Create anchor points
		for (i = 0; i <  WORLD_WIDTH; i ++){
			for (j = 0; j < WORLD_HEIGHT; j ++){
				temp_map[p][i][j] = 0;
				
				if (i mod chunk_size == 0) and (j mod chunk_size == 0){
					temp_map[p][i][j] = irandom_range(-amplitude, amplitude);
				}
				else if (i == WORLD_WIDTH - 1) or (j == WORLD_HEIGHT - 1){
					temp_map[p][i][j] = 10;
				}
				else temp_map[p][i][j] = 0;
			}
		}
		
		// Verrtical interpolation
		for (i = 0; i < WORLD_WIDTH; i ++){
			for (j = 0; j < WORLD_HEIGHT; j ++){
				if (i mod chunk_size != 0) continue;
				
				var anchor_t = floor(j / chunk_size) * chunk_size;
				var anchor_b = ceil(j / chunk_size) * chunk_size;
				if (anchor_b >= WORLD_HEIGHT) anchor_b = WORLD_HEIGHT - 1;
				
				var lerp_amount = (j - anchor_t) / chunk_size;
				var value1 = temp_map[p][i][anchor_t];
				var value2 = temp_map[p][i][anchor_b];
				
				var lerp_value = lerp(value1, value2, lerp_amount);
				temp_map[p][i][j] = lerp_value;
			}
		}
		
		// Horizontal interpolation
		for (i = 0; i < WORLD_WIDTH; i ++){
			for (j = 0; j < WORLD_HEIGHT; j ++){
				
				var anchor_l = floor(i / chunk_size) * chunk_size;
				var anchor_r = ceil(i / chunk_size) * chunk_size;
				if (anchor_r >= WORLD_WIDTH) anchor_r = WORLD_WIDTH - 1;
				
				var lerp_amount = (i - anchor_l) / chunk_size;
				var value1 = temp_map[p][anchor_l][j];
				var value2 = temp_map[p][anchor_r][j];
				
				var lerp_value = lerp(value1, value2, lerp_amount);
				temp_map[p][i][j] = lerp_value;
			}
		}
		
		chunk_size *= 0.5;
		amplitude *= 0.5;
	}
	
	// Combine maps
	for (i = 0; i < WORLD_WIDTH; i ++){
		for (j = 0; j < WORLD_HEIGHT; j ++){
			for (p = 0; p < passes; p ++){
				grid[i][j] += temp_map[p][i][j];
				grid[i][j] = clamp(round(grid[i][j]), 0, 100);
			}
		}
	}
	
	return(grid);
}

function biomes_add(grid){
	
	var current_biome = 0;
	var width = array_length(grid);
	var height = array_length(grid[0]);
	
	var i, j, highest_cell, highest_value;
	
	// Loop through biomes
	repeat(array_length(biome)){
		
		repeat(biome[current_biome]){
			
			highest_cell = [];
			highest_value = 0;
			
			for (i = 0; i < width; i ++){
				for (j = 0; j < height; j ++){
					
					var cell_value = world_grid[i][j];
					if (!is_struct(cell_value) and cell_value > highest_value){
						
						highest_cell = [i, j];
						highest_value = cell_value;
					}
				}
			}
			if (array_length(highest_cell) > 0){
				var cell_x = highest_cell[0];
				var cell_y = highest_cell[1];
			
				grid[cell_x][cell_y] = new tile[current_biome]();
				grid[cell_x][cell_y].index += irandom(tiles_per_biome - 1);
			}
		}
		current_biome ++;
	}
	
	// Add filler
	for (i = 0; i < width; i ++){
		for (j = 0; j < height; j ++){
			if (!is_struct(grid[i][j])){
				grid[i][j] = new tile_world_scrubland();
				grid[i][j].index += irandom(tiles_per_biome - 1);
			}
		}
	}
	
	return(grid);
}

function map_smoothing(grid){
	var width = array_length(grid);
	var height = array_length(grid[0]);
	
	// Smoothing passes
	for (var i = 0; i < width-1; i ++){
		for (var j = 0; j < height-1; j ++){
			var t1 = grid[i][j].tile;
			var t2 = grid[i+1][j].tile;
			var t3 = grid[i][j+1].tile;
			var t4 = grid[i+1][j+1].tile;
			
			if (t1 == "water" and t4 == "water"){
				if (t2 != "water" and t3 != "water"){
					grid[i+1][j] = new tile_world_water();
				}
			}
			else if (t2 == "water" and t3 == "water"){
				if (t1 != "water" and t4 != "water"){
					grid[i][j] = new tile_world_water();
				}
			}
			else if (t1 == "canyon" and t4 == "canyon"){
				if (t2 != "canyon" and t3 != "canyon"){
					grid[i+1][j] = new tile_world_canyon();
				}
			}
			else if (t2 == "canyon" and t3 == "canyon"){
				if (t1 != "canyon" and t4 != "canyon"){
					grid[i][j] = new tile_world_canyon();
				}
			}
		}
	}
	
	// Remove isolated tiles
	for (i = 0; i < width; i ++){
		for (j = 0; j < height; j ++){
			
			var tile = [];
			
			tile[0] = grid[i][j].tile;
			if (i + 1 < width)	tile[1]	= grid[i+1][j].tile else tile[1] = noone;
			if (j - 1 >- 0)		tile[2]	= grid[i][j-1].tile else tile[2] = noone;
			if (i - 1 >- 0)		tile[3]	= grid[i-1][j].tile else tile[3] = noone;
			if (j + 1 < height)	tile[4]	= grid[i][j+1].tile else tile[4] = noone;
			
			if (tile[0] != tile[1] and tile[0] != tile[2] and tile[0] != tile[3] and tile[0] != tile[4]){
				
				if (tile[3] == noone) grid[i][j] = variable_clone(grid[i+1][j]) else grid[i][j] = variable_clone(grid[i-1][j]);
			}
		}	
	}
	return(grid);
}

function autotile_map(grid){
	var grid_w = array_length(grid);
	var grid_h = array_length(grid[0]);
	
	for (var i = 0; i < grid_w; i ++){
		for (var j = 0; j < grid_h; j ++){
			
			if (grid[i][j].tile == "water"){
				grid[i][j].sprite = water_00_spr;
				grid[i][j].index = autotile_47(grid, "water", i, j);
			}
			else if (grid[i][j].tile == "canyon"){
				grid[i][j].sprite = canyon_00_spr;
				grid[i][j].index = autotile_47(grid, "canyon", i, j);
			}
		}
	}
	return(grid);
}

function zone_map_generate(grid, cell_x, cell_y){
	var tile = grid[cell_x][cell_y].tile;
	var index = grid[cell_x][cell_y].index;
	
	if (tile == "mountain"){
		return(zone_mountain());
	}
	else if (tile == "hill"){
		return(zone_hill());
	}
	else if (tile == "canyon"){
		return(zone_canyon(index));
	}
	else if (tile == "salt plain"){
		return(zone_salt_plain());
	}
	else if (tile == "scrubland"){
		return(zone_scrubland());
	}
	else if (tile == "mangrove"){
		return(zone_mangrove());
	}
	else if (tile == "marsh"){
		return(zone_marsh());
	}
	else if (tile == "water"){
		return(zone_water(index));
	}
	
	return(false);
}




