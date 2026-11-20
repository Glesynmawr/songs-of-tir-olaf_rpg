
// TILE SWAPPING
function cell_replace_tile(cell_x, cell_y, new_tile_func){
	
	// Get tile state stats
	var tile_is_visible			= manager.game_state.game_grid[cell_x][cell_y].is_visible;
	var tile_is_explored		= manager.game_state.game_grid[cell_x][cell_y].explored;
	var tile_has_items			= manager.game_state.game_grid[cell_x][cell_y].items;
	var tile_has_inventory		= noone;
	if (struct_exists(manager.game_state.game_grid[cell_x][cell_y], "inventory")){
		tile_has_inventory		= manager.game_state.game_grid[cell_x][cell_y].inventory;
	}
	var tile_previously_opened	= noone;
	if (struct_exists(manager.game_state.game_grid[cell_x][cell_y], "has_been_opened")){
		tile_previously_opened	= manager.game_state.game_grid[cell_x][cell_y].has_been_opened;
	}
	var tile_is_lit				= manager.game_state.game_grid[cell_x][cell_y].is_lit;
	
	// Create new tile
	manager.game_state.game_grid[cell_x][cell_y] = new new_tile_func();
	
	// Reset tile state stats
	manager.game_state.game_grid[cell_x][cell_y].is_visible				= tile_is_visible;
	manager.game_state.game_grid[cell_x][cell_y].explored				= tile_is_explored;
	manager.game_state.game_grid[cell_x][cell_y].items					= tile_has_items;
	if (tile_has_inventory != noone){										
		manager.game_state.game_grid[cell_x][cell_y].inventory			= tile_has_inventory;
	}
	if (tile_previously_opened != noone){
		manager.game_state.game_grid[cell_x][cell_y].has_been_opened	= tile_previously_opened;
	}
	manager.game_state.game_grid[cell_x][cell_y].is_lit					= tile_is_lit;
}

function tile_lookup(tile_array){
	var len, weights_total, random_roll, weight_accumulator, i;
	
	
	len = array_length(tile_array);
	weights_total = 0;
	for (i = 0; i < len; i ++){
		weights_total += tile_array[i][1];
	}
	
	random_roll = irandom(weights_total);
	weight_accumulator = 0;

	for (i = 0; i < len; i ++){
		
		weight_accumulator += tile_array[i][1];
		
		if (random_roll <= weight_accumulator){
			return(tile_array[i][0]);
		}
	}
	return(tile_array[len-1][0]);
}

function water_tile_placement(target_array){
	var cell_x, cell_y;
	for (cell_x = 0; cell_x < ZONE_SIZE; cell_x ++){
		for (cell_y = 0; cell_y < ZONE_SIZE; cell_y ++){
			if (target_array[cell_x][cell_y].tile == "water"){
				
				// If tile is open water (no banks)
				if (target_array[cell_x][cell_y].index >= 46){
					
					// Create random tile from list
					var new_tile = tile_lookup(zone_tile_lookup[BIOME.WATER]);
					target_array[cell_x][cell_y] = generate_zone_tile(new_tile);
				}
			}
		}
	}
	return(target_array);
}

function water_crop_tile_placement(target_array, crop_tile, ripe_crop_tile){
	var cell_x, cell_y;
	for (cell_x = 0; cell_x < ZONE_SIZE; cell_x ++){
		for (cell_y = 0; cell_y < ZONE_SIZE; cell_y ++){
			
			// If tile is water tile
			if (target_array[cell_x][cell_y].tile == "water"){
				
				// If tile has no edges
				if (target_array[cell_x][cell_y].index >= 46){
					
					// 60% chance of crop placement
					if (random(1) < 0.6){
						
						// 10% chance of ripe crop placement
						if (random(1) < 0.1){
							target_array[cell_x][cell_y] = generate_zone_tile(ripe_crop_tile);
						}
						else{
							target_array[cell_x][cell_y] = generate_zone_tile(crop_tile);
						}
					}
				}
			}
		}
	}
	return(target_array);
}


// DUNGEON TILES
function tile_dungeon_entrance()constructor{
	tile			= "dungeon entrance";
	sprite			= zone_tile_dungeon_entrance_spr;
	index			= 0;
	walkable		= true;
	transparent		= false;
	is_visible		= false;
	explored		= false;
	tile_script		= dungeon_enter;
}

function tile_hall()constructor{
	tile			= "hall";
	sprite			= floor_00_spr;
	index			= 0;
	walkable		= true;
	transparent		= true;
	is_visible		= false;
	explored		= false;
	tile_script		= noone;
}

function tile_room()constructor{
	tile			= "room";
	sprite			= floor_00_spr;
	index			= 0;
	walkable		= true;
	transparent		= true;
	is_visible		= false;
	explored		= false;
	tile_script		= noone;
}

function tile_stairs_up()constructor{
	tile			= "entry";
	sprite			= stairs_00_spr;
	index			= 0;
	walkable		= true;
	transparent		= true;
	is_visible		= false;
	explored		= false;
	tile_script		= level_ascend;
}

function tile_stairs_down()constructor{
	tile			= "exit";
	sprite			= stairs_00_spr;
	index			= 1;
	walkable		= true;
	transparent		= true;
	is_visible		= false;
	explored		= false;
	tile_script		= level_descend;
}

function tile_wall()constructor{
	tile			= "wall";
	sprite			= wall_00_spr;
	index			= 1;
	walkable		= false;
	transparent		= false;
	is_visible		= false;
	explored		= false;
	tile_script		= noone;
}

function tile_wall_redwood()constructor{
	tile			= "wall";
	sprite			= wall_03_spr;
	index			= 0;
	walkable		= false;
	transparent		= false;
	is_visible		= false;
	explored		= false;
	tile_script		= noone;
}

function tile_floor_planks()constructor{
	tile			= "floor";
	sprite			= floor_02_spr;
	index			= 0;
	walkable		= true;
	transparent		= true;
	is_visible		= false;
	explored		= false;
	tile_script		= noone;
}


// FURNITURE TILES
// Containers
function tile_chest_large()constructor{
	tile			= "Large chest";
	sprite			= chest_large_closed_spr;
	index			= 0;
	walkable		= false;
	transparent		= true;
	is_visible		= false;
	explored		= false;
	tile_script		= tile_access_inventory;
	inventory		= [];
	inventory_max	= 10;
	inv_hover		= 0;
	has_been_opened = false;
}

// Lighting
function tile_torch()constructor{
	tile			= "torch";
	sprite			= torch_spr;
	index			= 0;
	walkable		= true;
	transparent		= true;
	is_visible		= false;
	explored		= false;
	tile_script		= light_toggle;
	light_source	= true;
	lit_sprite		= fire_spr;
	light_index		= 0;
	light_radius	= 2;
}

// Decorative
function tile_bed() constructor{
	tile			= "bed";
	sprite			= bed_spr;
	index			= 0;
	walkable		= true;
	transparent		= true;
	is_visible		= false;
	explored		= false;
	tile_script		= noone;
}

function tile_cabinet() constructor{
	tile			= "cabinet";
	sprite			= cabinet_spr;
	index			= 0;
	walkable		= false;
	transparent		= true;
	is_visible		= false;
	explored		= false;
	tile_script		= tile_access_inventory;
	inventory		= [];
	inventory_max	= 10;
	inv_hover		= 0;
	has_been_opened = false;
}

function tile_carpet()constructor{
	tile			= "carpet";
	sprite			= carpet_spr;
	index			= 0;
	walkable		= true;
	transparent		= true;
	is_visible		= false;
	explored		= false;
	tile_script		= noone;
}

function tile_cook_pot() constructor{
	tile			= "cook pot";
	sprite			= cook_pot_spr;
	index			= 0;
	walkable		= false;
	transparent		= true;
	is_visible		= false;
	explored		= false;
	tile_script		= noone;
}

function tile_floor_cushion() constructor{
	tile			= "floor_cushion";
	sprite			= floor_cushion_spr;
	index			= 0;
	walkable		= true;
	transparent		= true;
	is_visible		= false;
	explored		= false;
	tile_script		= noone;
}

function tile_table_empty() constructor{
	tile			= "table";
	sprite			= table_empty_spr;
	index			= 0;
	walkable		= false;
	transparent		= true;
	is_visible		= false;
	explored		= false;
	tile_script		= noone;
}

function tile_table_kitchen() constructor{
	tile			= "table";
	sprite			= table_kitchen_spr;
	index			= 0;
	walkable		= false;
	transparent		= true;
	is_visible		= false;
	explored		= false;
	tile_script		= noone;
}

// INTERACTIVE TILES
function tile_door_closed()constructor{
	tile			= "closed door";
	sprite			= door_closed_spr;
	index			= 0;
	walkable		= true;
	transparent		= false;
	is_visible		= false;
	explored		= false;
	tile_script		= door_set_open;
	has_been_opened = false;
}

function tile_door_open()constructor{
	tile			= "open door";
	sprite			= door_open_spr;
	index			= 0;
	walkable		= true;
	transparent		= true;
	is_visible		= false;
	explored		= false;
	tile_script		= door_set_close;
}

function tile_door_secret()constructor{
	tile			= "secret door";
	sprite			= wall_00_spr;
	index			= 0;
	walkable		= true;
	transparent		= false;
	is_visible		= false;
	explored		= false;
	tile_script		= door_set_open;
	has_been_opened = false;
}


// PLANTS
function tile_zone_grass()constructor{
	tile			= "grass";
	sprite			= zone_tile_grass_spr;
	index			= 0;
	walkable		= true;
	transparent		= true;
	is_visible		= false;
	explored		= false;
	tile_script		= noone;
}

function tile_zone_lilypad()constructor{
	tile			= "water";
	sprite			= zone_tile_lilypad_spr;
	index			= 0;
	walkable		= true;
	transparent		= true;
	is_visible		= false;
	explored		= false;
	tile_script		= noone;
}

function tile_reedmace()constructor{
	tile			= "reedmace";
	sprite			= reedmace_spr;
	index			= 0;
	walkable		= true;
	transparent		= true;
	is_visible		= false;
	explored		= false;
	tile_script		= noone;
}

function tile_reedmace_ripe()constructor{
	tile			= "reedmace";
	sprite			= reedmace_ripe_spr;
	index			= 0;
	walkable		= true;
	transparent		= false;
	is_visible		= false;
	explored		= false;
	tile_script		= crop_harvest;
	harvested_tile  = tile_reedmace;
}


// ZONE TILES -------------------------------------------------------------------------------------
function tile_zone_bush()constructor{
	tile			= "bush";
	sprite			= zone_tile_bush_spr;
	index			= 0;
	walkable		= true;
	transparent		= true;
	is_visible		= false;
	explored		= false;
	tile_script		= noone;
}

function tile_zone_dirt()constructor{
	tile			= "dirt";
	sprite			= zone_tile_dirt_spr;
	index			= 0;
	walkable		= true;
	transparent		= true;
	is_visible		= false;
	explored		= false;
	tile_script		= noone;
}



function tile_zone_marsh()constructor{
	tile			= "swamp";
	sprite			= zone_tile_marsh_spr;
	index			= 0;
	walkable		= true;
	transparent		= true;
	is_visible		= false;
	explored		= false;
	tile_script		= noone;
}

function tile_zone_raised_ground()constructor{
	tile			= "raised ground";
	sprite			= zone_tile_raised_ground_00_spr;
	index			= 0;
	walkable		= true;
	transparent		= true;
	is_visible		= false;
	explored		= false;
	tile_script		= noone;
}

function tile_zone_reeds()constructor{
	tile			= "water";
	sprite			= zone_tile_reeds_spr;
	index			= 0;
	walkable		= true;
	transparent		= false;
	is_visible		= false;
	explored		= false;
	tile_script		= noone;
}

function tile_zone_rocks()constructor{
	tile			= "rocks";
	sprite			= zone_tile_rocks_spr;
	index			= 0;
	walkable		= true;
	transparent		= false;
	is_visible		= false;
	explored		= false;
	tile_script		= noone;
}

function tile_zone_salt()constructor{
	tile			= "salt";
	sprite			= zone_tile_salt_spr;
	index			= 0;
	walkable		= true;
	transparent		= true;
	is_visible		= false;
	explored		= false;
	tile_script		= noone;
}

function tile_zone_tree()constructor{
	tile			= "tree";
	sprite			= zone_tile_tree_spr;
	index			= 0;
	walkable		= true;
	transparent		= false;
	is_visible		= false;
	explored		= false;
	tile_script		= noone;
}

function tile_zone_water()constructor{
	tile			= "water";
	sprite			= zone_tile_water_spr;
	index			= 0;
	walkable		= true;
	transparent		= true;
	is_visible		= false;
	explored		= false;
	tile_script		= noone;
}




