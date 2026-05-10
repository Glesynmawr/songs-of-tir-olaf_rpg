function generate_dungeon(){
	
	// Sets level overall size
	grid_width = 79;
	grid_height = 29;
	
	// Initialise grids
	game_grid = initialise_game_grid(grid_width, grid_height);
	generate_rooms(game_grid, 9, 5, 9);
	generate_hallways(game_grid, 25);
    
    // Initial connections
    var areas_connected = true;
    while(areas_connected){
        areas_connected = connect_areas(game_grid);
    }
    
    // Shortcuts
    create_shortcuts(game_grid, 25, 25);
	
	// Dead end culling
	var dead_ends_culled = true;
	while(dead_ends_culled){
		dead_ends_culled = cull_dead_ends(game_grid);
	}
	
	// Doors
	add_doors(game_grid);
	
	// Add entry
	entry_pos = add_entry(game_grid);
	
	// Add exit
	add_exit(game_grid, entry_pos[0], entry_pos[1]);
}

function initialise_camera(following){
	camera_pos[0] = floor((following.x_pos * cell_width)  - (room_width  / 2) - (cell_width  / 2));
	camera_pos[1] = floor((following.y_pos * cell_height) - (room_height / 2) - (cell_height / 2));
}

function move_camera(target_x, target_y, camera_spd){
	if (camera_pos[0] != target_x){
		camera_pos[0] += (target_x - camera_pos[0]) * camera_spd;
	}
	if (camera_pos[1] != target_y){
		camera_pos[1] += (target_y - camera_pos[1]) * camera_spd;
	}
	camera_set_view_pos(view_camera[0], floor(camera_pos[0]), floor(camera_pos[1]));
}




