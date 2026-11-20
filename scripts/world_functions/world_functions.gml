// WORLD GENERATOR FUNCTIONS

// DATA -------------------------------------------------------------------------------------------
function world_data(){
	zone_third				= floor(ZONE_SIZE / 3);
	dungeon_count_divisor	= 100;
	
	// Generation variables
	world_generate_octaves		= 3;
	world_generate_frequency	= 8;
	world_generate_amplitude	= 12;

	// BIOME SIZE
	biome_size[BIOME.MOUNTAIN]			= 200;
	biome_size[BIOME.HILL]				= 240;
	biome_size[BIOME.CANYON]			= 400;
	biome_size[BIOME.DESERT]			= 560;
	biome_size[BIOME.SCRUB]				= 400;
	biome_size[BIOME.SWAMP]				= 360;
	biome_size[BIOME.DENSE_MANGROVE]	= 360;
	biome_size[BIOME.WATER]				= 440;
	biome_size[BIOME.MANGROVE]			= 360;
	biome_size[BIOME.MARSH]				= 360;
	
	// BIOME GENERATION FUNCTIONS
	world_tile[BIOME.MOUNTAIN]			= tile_world_mountain;
	world_tile[BIOME.HILL]				= tile_world_hill;
	world_tile[BIOME.CANYON]			= tile_world_canyon;
	world_tile[BIOME.DESERT]			= tile_world_salt_plain;
	world_tile[BIOME.SCRUB]				= tile_world_scrubland;
	world_tile[BIOME.SWAMP]				= tile_world_swamp;
	world_tile[BIOME.DENSE_MANGROVE]	= tile_world_dense_mangrove;
	world_tile[BIOME.WATER]				= tile_world_water;
	world_tile[BIOME.MANGROVE]			= tile_world_mangrove;
	world_tile[BIOME.MARSH]				= tile_world_marsh;
	
	// ZONE GENERATION FUNCTION
	zone_function[BIOME.MOUNTAIN]		= zone_standard;
	zone_function[BIOME.HILL]			= zone_standard;
	zone_function[BIOME.CANYON]			= zone_canyon;
	zone_function[BIOME.DESERT]			= zone_standard;
	zone_function[BIOME.SCRUB]			= zone_standard;
	zone_function[BIOME.SWAMP]			= zone_standard;
	zone_function[BIOME.DENSE_MANGROVE]	= zone_standard;
	zone_function[BIOME.WATER]			= zone_river;
	zone_function[BIOME.MANGROVE]		= zone_standard;
	zone_function[BIOME.MARSH]			= zone_standard;
	
	// ZONE FEATURES PER BIOME
	zone_feature[BIOME.MOUNTAIN]		= noone;
	zone_feature[BIOME.HILL]			= noone;
	zone_feature[BIOME.CANYON]			= noone;
	zone_feature[BIOME.DESERT]			= noone;
	zone_feature[BIOME.SCRUB]			= noone;
	zone_feature[BIOME.SWAMP]			= noone;
	zone_feature[BIOME.DENSE_MANGROVE]	= noone;
	zone_feature[BIOME.WATER]			= noone;
	zone_feature[BIOME.MANGROVE]		= noone;
	zone_feature[BIOME.MARSH]			= [[[1, 1, 2, 2, 2, 3], tile_zone_water, 8, 0.5], [[0, 0, 1, 1, 1, 2], tile_zone_tree, 8, 1.5]];
	
	// TILE LOOKUP TABLES PER BIOME								
	zone_tile_lookup[BIOME.MOUNTAIN]		= [[tile_zone_rocks, 15], [tile_zone_dirt, 25]];
	zone_tile_lookup[BIOME.HILL]			= [[tile_zone_grass, 15], [tile_zone_dirt, 25]];
	zone_tile_lookup[BIOME.CANYON]			= [[tile_zone_rocks,  5], [tile_zone_salt, 10], [tile_zone_dirt, 25]];
	zone_tile_lookup[BIOME.DESERT]			= [[tile_zone_rocks,  5], [tile_zone_dirt, 10], [tile_zone_salt, 25]];
	zone_tile_lookup[BIOME.SCRUB]			= [[tile_zone_bush,  8], [tile_zone_grass, 20], [tile_zone_dirt, 25]];
	zone_tile_lookup[BIOME.SWAMP]			= [[tile_zone_tree,  5], [tile_zone_reeds, 10], [tile_zone_dirt, 25],		[tile_zone_marsh, 100]];
	zone_tile_lookup[BIOME.DENSE_MANGROVE]	= [[tile_zone_rocks, 2], [tile_zone_tree, 30],	[tile_zone_dirt,  60],		[tile_zone_water, 100]];
	zone_tile_lookup[BIOME.WATER]			= [[tile_zone_tree,  2], [tile_reedmace, 5],	[tile_zone_lilypad, 20],	[tile_zone_water, 100]];
	zone_tile_lookup[BIOME.MANGROVE]		= [[tile_zone_rocks, 2], [tile_zone_tree, 10],	[tile_zone_dirt,  60],		[tile_zone_water, 100]];
	zone_tile_lookup[BIOME.MARSH]			= [[tile_zone_tree,  1], [tile_zone_reeds, 1],	[tile_zone_water, 4],		[tile_zone_dirt, 10],	[tile_zone_marsh, 50]];
	
	// MOB LOOKUP TABLES
	mob_lookup[BIOME.MOUNTAIN][MOB_LOOKUP.ZONE]				= noone;
	mob_lookup[BIOME.MOUNTAIN][MOB_LOOKUP.DUNGEON]			= noone;
	mob_lookup[BIOME.HILL][MOB_LOOKUP.ZONE]					= noone;
	mob_lookup[BIOME.HILL][MOB_LOOKUP.DUNGEON]				= noone;
	mob_lookup[BIOME.CANYON][MOB_LOOKUP.ZONE]				= noone;
	mob_lookup[BIOME.CANYON][MOB_LOOKUP.DUNGEON]			= noone;
	mob_lookup[BIOME.DESERT][MOB_LOOKUP.ZONE]				= noone;
	mob_lookup[BIOME.DESERT][MOB_LOOKUP.DUNGEON]			= noone;
	mob_lookup[BIOME.SCRUB][MOB_LOOKUP.ZONE]				= noone;
	mob_lookup[BIOME.SCRUB][MOB_LOOKUP.DUNGEON]				= noone;
	mob_lookup[BIOME.SWAMP][MOB_LOOKUP.ZONE]				= noone;
	mob_lookup[BIOME.SWAMP][MOB_LOOKUP.DUNGEON]				= noone;
	mob_lookup[BIOME.DENSE_MANGROVE][MOB_LOOKUP.ZONE]		= noone;
	mob_lookup[BIOME.DENSE_MANGROVE][MOB_LOOKUP.DUNGEON]	= noone;
	mob_lookup[BIOME.WATER][MOB_LOOKUP.ZONE]				= noone;
	mob_lookup[BIOME.WATER][MOB_LOOKUP.DUNGEON]				= noone;
	mob_lookup[BIOME.MANGROVE][MOB_LOOKUP.ZONE]				= noone;
	mob_lookup[BIOME.MANGROVE][MOB_LOOKUP.DUNGEON]			= noone;
	mob_lookup[BIOME.MARSH][MOB_LOOKUP.ZONE]				= [10, [actor_marsh_turtle, 10], [actor_flamingo, 30], [actor_marsh_frog, 100]];
	mob_lookup[BIOME.MARSH][MOB_LOOKUP.DUNGEON]				= [10, [actor_marsh_rat, 10], [actor_marsh_bat, 30], [actor_reed_weevil, 100]];
}


// GENERATORS -------------------------------------------------------------------------------------
function world_generate(){
	// Initialise world grid
	world_grid = world_grid_initialise(WORLD_WIDTH, WORLD_HEIGHT);
	
	// Add texture
	world_grid = noise_generate(world_grid);
	
	// Add biomes
	world_grid = biomes_add(world_grid);
	
	// Smoothing passes
	world_grid = map_smoothing(world_grid);
	
	// Autotile river and canyon
	world_grid = autotile_map(world_grid, world_tile_water_at_spr);
	
	// Add dungeons
	world_grid = dungeons_add_to_world(world_grid);
	
	// Add villages
	world_grid = world_add_villages(world_grid);
	
	// Generate zone maps
	game_state.zone_map  = [];
	for (var xx = 0; xx < WORLD_WIDTH; xx ++){
		for (var yy = 0; yy < WORLD_HEIGHT; yy ++){
			game_state.zone_map[xx][yy]  = noone;
		}
	}
	
	// Set player start position
	player_start_x = 0;
	player_start_y = 0;
	
	return(world_grid);
}

function world_grid_initialise(width, height){
	
	// Initialise grid
	var grid = [];
	for (var i = 0; i < width; i ++){
		for (var j = 0; j < height; j ++){
			grid[i][j] = 0;
		}
	}
	
	// Initial anchors
	grid[0][0] = 0;
	grid[0][height - 1] = 30;
	grid[width - 1][0] = 60;
	grid[width - 1][height - 1] = 90;
	
	var anchor1 = grid[0][0];
	var anchor2 = grid[0][height - 1];
	var anchor3 = grid[width - 1][0];
	var anchor4 = grid[width - 1][height - 1];
		
	// Vertical lerp
	for (j = 0; j < height; j ++){
		
		var lerp_amount = j / (height - 1);
		var lerp_value = lerp(anchor1, anchor2, lerp_amount);
		grid[0][j] = round(lerp_value);
		
		var lerp_value = lerp(anchor3, anchor4, lerp_amount);
		grid[width - 1][j] = round(lerp_value);
	}
	
	// Horizontal lerp
	for (i = 0; i < width; i ++){
		for (j = 0; j < height; j ++){
			if (grid[i][j] != 0){
				continue;
			}
			anchor1 = grid[0][j];
			anchor2 = grid[width - 1][j];
			
			var lerp_amount = i / (width - 1);
			var lerp_value = lerp(anchor1, anchor2, lerp_amount);
			grid[i][j] = round(lerp_value);
		}
	}
	
	return(grid);
}

function noise_generate(grid){
	
	var ww = array_length(grid);
	var hh = array_length(grid[0]);
	
	var temp_map	= [];
	var passes		= world_generate_octaves;
	var chunk_size	= world_generate_frequency;
	var amplitude	= world_generate_amplitude;
	
	var i, j, p;
	for (p = 0; p < passes; p ++){
		
		// Create anchor points
		for (i = 0; i <  ww; i ++){
			for (j = 0; j < hh; j ++){
				temp_map[p][i][j] = 0;
				
				if (i mod chunk_size == 0) and (j mod chunk_size == 0){
					temp_map[p][i][j] = irandom_range(-amplitude, amplitude);
				}
				else if (i == ww - 1) or (j == hh - 1){
					temp_map[p][i][j] = 10;
				}
				else temp_map[p][i][j] = 0;
			}
		}
		
		// Verrtical interpolation
		for (i = 0; i < ww; i ++){
			for (j = 0; j < hh; j ++){
				if (i mod chunk_size != 0) continue;
				
				var anchor_t = floor(j / chunk_size) * chunk_size;
				var anchor_b = ceil(j / chunk_size) * chunk_size;
				if (anchor_b >= hh) anchor_b = hh - 1;
				
				var lerp_amount = (j - anchor_t) / chunk_size;
				var value1 = temp_map[p][i][anchor_t];
				var value2 = temp_map[p][i][anchor_b];
				
				var lerp_value = lerp(value1, value2, lerp_amount);
				temp_map[p][i][j] = lerp_value;
			}
		}
		
		// Horizontal interpolation
		for (i = 0; i < ww; i ++){
			for (j = 0; j < hh; j ++){
				
				var anchor_l = floor(i / chunk_size) * chunk_size;
				var anchor_r = ceil(i / chunk_size) * chunk_size;
				if (anchor_r >= ww) anchor_r = ww - 1;
				
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
	for (i = 0; i < ww; i ++){
		for (j = 0; j < hh; j ++){
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
	repeat(array_length(biome_size)){
		
		repeat(biome_size[current_biome]){
			
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
			
				grid[cell_x][cell_y] = new world_tile[current_biome]();
				var tiles_in_biome = floor(sprite_get_width(grid[cell_x][cell_y].sprite) / game_state.cell_width) - 1;
				grid[cell_x][cell_y].index += irandom(tiles_in_biome);
			}
		}
		current_biome ++;
	}
	
	// Add filler
	for (i = 0; i < width; i ++){
		for (j = 0; j < height; j ++){
			if (!is_struct(grid[i][j])){
				grid[i][j] = new tile_world_marsh();
				var tiles_in_biome = floor(sprite_get_width(grid[cell_x][cell_y].sprite) / game_state.cell_width) - 1;
				grid[i][j].index += irandom(tiles_in_biome);
			}
			grid[i][j].mobs = [];
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

function autotile_map(grid, water_spr = water_00_spr){
	var grid_w = array_length(grid);
	var grid_h = array_length(grid[0]);
	
	for (var i = 0; i < grid_w; i ++){
		for (var j = 0; j < grid_h; j ++){
			
			if (grid[i][j].tile == "water"){
				grid[i][j].sprite = water_spr;
				grid[i][j].index = autotile_47(grid, "water", i, j);
			}
			else if (grid[i][j].tile == "canyon"){
				grid[i][j].sprite = canyon_00_spr;
				grid[i][j].index = autotile_47(grid, "canyon", i, j);
			}
			else if (grid[i][j].tile == "raised ground"){
				grid[i][j].sprite = zone_tile_raised_ground_00_spr;
				grid[i][j].index = autotile_47(grid, "raised ground", i, j);
			}
		}
	}
	return(grid);
}


// ADD SPECIAL LOCATIONS --------------------------------------------------------------------------
function dungeons_add_to_world(grid){
	
	var ww = array_length(grid);
	var hh = array_length(grid[0]);
	
	// Initialise dungeon variable
	for (var i = 0; i < ww; i ++){
		for (var j = 0; j < hh; j ++){
			grid[i][j].dungeon = noone;
		}
	}
	
	// Loop through biomes
	for (var b = 0; b < array_length(biome_size); b ++){
		
		var dungeon_count = ceil(biome_size[b] / dungeon_count_divisor);
		
		repeat(dungeon_count){
			var cand_list = [];
			for (i = 0; i < ww; i ++){
				for (j = 0; j < hh; j ++){
					if (grid[i][j].biome == b and grid[i][j].dungeon == noone){
						array_push(cand_list, [i, j]);
					}
				}
			}
			var len = array_length(cand_list)
			if (len > 0){
				var c	= irandom(len - 1);
				var xx	= cand_list[c][0];
				var yy	= cand_list[c][1];
				grid[xx][yy].dungeon = true;
			}
		}
	}
	return(grid);
}

function world_add_villages(grid){
	
	grid[0][0].village = {
		building_count:			6,
		building_size:			[5, 4],
		building_distance:		12,
		building_stagger:		1.2,
		raised_ground:			true,
		floor_tile:				tile_floor_planks,
		wall_tile:				tile_wall_redwood,
		decor_index:			0,
		furnish_list:			[furnish_home, furnish_home, noone],
		farm_spawn_function:	farms_add_water_crop,
		crop:					tile_reedmace,
		crop_ripe:				tile_reedmace_ripe,
	}
	
	return(grid);
}


// WORLD TILES ------------------------------------------------------------------------------------
function tile_world_mountain()constructor{
	tile			= "mountain";
	biome			= BIOME.MOUNTAIN;
	sprite			= world_tile_mountain_spr;
	index			= 0;
	walkable		= true;
	transparent		= false;
	is_visible		= false;
	explored		= false;
	tile_script		= noone;
}

function tile_world_hill()constructor{
	tile			= "hill";
	biome			= BIOME.HILL;
	sprite			= world_tile_hill_spr;
	index			= 0;
	walkable		= true;
	transparent		= true;
	is_visible		= false;
	explored		= false;
	tile_script		= noone;
}

function tile_world_canyon()constructor{
	tile			= "canyon";
	biome			= BIOME.CANYON;
	sprite			= world_tile_canyon_spr;
	index			= 0;
	walkable		= true;
	transparent		= true;
	is_visible		= false;
	explored		= false;
	tile_script		= noone;
}

function tile_world_salt_plain()constructor{
	tile			= "salt plain";
	biome			= BIOME.DESERT;
	sprite			= world_tile_salt_desert_spr;
	index			= 0;
	walkable		= true;
	transparent		= true;
	is_visible		= false;
	explored		= false;
	tile_script		= noone;
}

function tile_world_scrubland()constructor{
	tile			= "scrubland";
	biome			= BIOME.SCRUB;
	sprite			= world_tile_scrubland_spr;
	index			= 0;
	walkable		= true;
	transparent		= true;
	is_visible		= false;
	explored		= false;
	tile_script		= noone;
}

function tile_world_dense_mangrove()constructor{
	tile			= "dense mangrove";
	biome			= BIOME.DENSE_MANGROVE;
	sprite			= world_tile_dense_mangrove_spr;
	index			= 0;
	walkable		= true;
	transparent		= false;
	is_visible		= false;
	explored		= false;
	tile_script		= noone;
}

function tile_world_swamp()constructor{
	tile			= "swamp";
	biome			= BIOME.SWAMP;
	sprite			= world_tile_swamp_spr;
	index			= 0;
	walkable		= true;
	transparent		= true;
	is_visible		= false;
	explored		= false;
	tile_script		= noone;
}

function tile_world_water()constructor{
	tile			= "water";
	biome			= BIOME.WATER;
	sprite			= world_tile_water_spr;
	index			= 0;
	walkable		= true;
	transparent		= true;
	is_visible		= false;
	explored		= false;
	tile_script		= noone;
}

function tile_world_mangrove()constructor{
	tile			= "mangrove";
	biome			= BIOME.MANGROVE;
	sprite			= world_tile_mangrove_spr;
	index			= 0;
	walkable		= true;
	transparent		= false;
	is_visible		= false;
	explored		= false;
	tile_script		= noone;
}

function tile_world_marsh()constructor{
	tile			= "marsh";
	biome			= BIOME.MARSH;
	sprite			= world_tile_marsh_spr;
	index			= 0;
	walkable		= true;
	transparent		= true;
	is_visible		= false;
	explored		= false;
	tile_script		= noone;
}


