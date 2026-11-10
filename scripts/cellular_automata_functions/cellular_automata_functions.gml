

function cellular_automata(ww, hh){
	
	var grid = [];
	
	// Init grid
	for (var i = 0; i < ww; i ++){
		for (var j = 0; j < hh; j ++){
			if (i == 0 or i == ww - 1 or j == 0 or j == hh - 1 or random(1) < 0.45){
				grid[i][j] = 1;
			}
			else grid[i][j] = 0;
		}
	}
	
	return(grid);
}

function cellular_automata_smoothing(grid){
	
	var width  = array_length(grid);
	var height = array_length(grid[0]);
	
	var new_grid = [];
	
	for (var i = 0; i < width; i ++){
		for (var j = 0; j < height; j ++){
			
			var wall_count  = wall_neighbour_count(grid, i, j, 1);
			var wall_count2 = wall_neighbour_count(grid, i, j, 2);
			
			if (i == 0 or i == width-1 or j == 0 or j == height-1){
				new_grid[i][j] = 1;
			}
			else if (wall_count > 4 or wall_count2 == 0){
				new_grid[i][j] = 1;
			}
			else if (wall_count < 4){
				new_grid[i][j] = 0;
			}
			else{
				new_grid[i][j] = grid[i][j];
			}
		}
	}
	
	return(new_grid);
}

function wall_neighbour_count(grid, xx, yy, radius){
	var width = array_length(grid);
	var height = array_length(grid[0]);
	var wall_count = 0;
	
	for (var i = max(xx-radius, 0); i <= min(xx+radius, width-1); i ++){
		for (var j = max(yy-radius, 0); j <= min(yy+radius, height-1); j ++){

			if (i == xx and j == yy){
				continue;
			}
			else{
				wall_count += grid[i][j];
			}
		}
	}
	
	return(wall_count);
}

function cellular_automata_add_tiles(){
	var ww = array_length(dungeon_grid);
	var hh = array_length(dungeon_grid[0]);
	for (var i = 0; i < ww; i ++){
		for (var j = 0; j < hh; j ++){
			var cell_index = dungeon_grid[i][j];
			if (cell_index == 0){
				
				// CREATE FLOOR TILE -------------------------------------------------------------------
				dungeon_grid[i][j] = new tile_room();
				dungeon_grid[i][j].sprite = game_state.floor_sprite;
				dungeon_grid[i][j].flag   = -1;
				
			}
			else{
				
				// CREATE WALL TILE -------------------------------------------------------------------
				dungeon_grid[i][j] = new tile_wall();
				dungeon_grid[i][j].sprite = game_state.wall_sprite;
				dungeon_grid[i][j].flag   = -1;
			
			}
		}
	}
}


// CONNECTING CAVERNS
function connect_caverns(grid){

	var flags		= cellular_automata_set_flags(grid);
	grid			= flags[0];
	var flag_count	= flags[1];
	
	var flag_list   = cellular_automata_region_sizes(grid, flag_count);
	
	var largest_flag = 0;
	var largest_area = 0;
	for (i = 0; i < flag_count; i ++){
		if (flag_list[i] > largest_area){
			largest_area = flag_list[i];
			largest_flag = i;
		}
	}
	
	cellular_automata_fill(grid, largest_flag)
}

function cellular_automata_set_flags(grid){
	
	var i, j, current_flag;
	var width  = array_length(grid);
	var height = array_length(grid[0]);
	
	// Add Viable Cells
	for (i = 0; i < width; i ++){
		for (j = 0; j < height; j ++){
			if (grid[i][j].tile != "wall"){
				grid[i][j].flag = 0;
			}
			else grid[i][j].flag = -1;
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
	
	return([grid, current_flag]);
}

function cellular_automata_region_sizes(grid, flag_count){
	
	var i, j;
	var width  = array_length(grid);	
	var height = array_length(grid[0]);
	var flag_list = [];
	
	// Initialise flag list
	for (i = 0; i < flag_count; i ++){
		flag_list[i] = 0;
	}
	
	// Populate flag list
	for (i = 0; i < width; i ++){
		for (j = 0; j < height; j ++){
			if (grid[i][j].flag > 0){
				flag_list[grid[i][j].flag] ++;
			}
		}
	}
	
	return(flag_list);
}

function cellular_automata_fill(grid, flag){
	var i, j;
	var width  = array_length(grid);	
	var height = array_length(grid[0]);
	for (i = 0; i < width; i ++){
		for (j = 0; j < height; j ++){
			if (grid[i][j].flag != flag){
				
				// CREATE WALL TILE -------------------------------------------------------------------
				grid[i][j] = new tile_wall();
				grid[i][j].sprite = game_state.wall_sprite;
				grid[i][j].flag   = -1;
			}
		}
	}
}




