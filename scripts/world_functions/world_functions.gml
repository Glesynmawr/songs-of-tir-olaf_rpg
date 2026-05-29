
function world_generate(){
	
	// Biome counts
	biome[0] = 50;	// Mountains
	biome[1] = 100;	// Hills
	biome[2] = 120;	// Deep forest
	biome[3] = 140;	// Light forest
	biome[4] = 100;	// Grassland
	biome[5] = 90;	// Mangroves
	biome[6] = 50;	// Marsh
	biome[7] = 80;	// Water
	biome[8] = 50;	// Marsh
	biome[9] = 60;	// Mangroves
	
	tile[0] = tile_world_mountain;
	tile[1] = tile_world_hill;
	tile[2] = tile_world_deep_forest;
	tile[3] = tile_world_light_forest;
	tile[4] = tile_world_grass;
	tile[5] = tile_world_mangrove;
	tile[6] = tile_world_marsh;
	tile[7] = tile_world_water;
	tile[8] = tile_world_marsh;
	tile[9] = tile_world_mangrove;
	
	// Initialise world grid
	world_grid = world_grid_initialise(WORLD_WIDTH, WORLD_HEIGHT);
	
	// Add texture
	world_grid = noise_generate(world_grid);
	
	// Add biomes
	world_grid = biomes_add(world_grid);
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
			}
		}
		current_biome ++;
	}
	
	// Add filler
	for (i = 0; i < width; i ++){
		for (j = 0; j < height; j ++){
			if (!is_struct(grid[i][j])){
				grid[i][j] = new tile_world_grass();
			}
		}
	}
	
	return(grid);
}




