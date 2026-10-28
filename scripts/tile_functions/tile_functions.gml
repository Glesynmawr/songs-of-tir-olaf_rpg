
// TILE SWAPPING
function cell_replace_tile(x_pos, y_pos, new_tile){
	var vis   = manager.game_state.game_grid[x_pos][y_pos].is_visible;
	var ex    = manager.game_state.game_grid[x_pos][y_pos].explored;
	var items = manager.game_state.game_grid[x_pos][y_pos].items;
	var inv   = noone;
	if (struct_exists(manager.game_state.game_grid[x_pos][y_pos], "inventory")){
		inv = manager.game_state.game_grid[x_pos][y_pos].inventory;
	}
	var prev_open = noone;
	if (struct_exists(manager.game_state.game_grid[x_pos][y_pos], "has_been_opened")){
		prev_open = manager.game_state.game_grid[x_pos][y_pos].has_been_opened;
	}
	var lit   = manager.game_state.game_grid[x_pos][y_pos].is_lit;
	
	manager.game_state.game_grid[x_pos][y_pos] = new new_tile();
	
	manager.game_state.game_grid[x_pos][y_pos].is_visible = vis;
	manager.game_state.game_grid[x_pos][y_pos].explored   = ex;
	manager.game_state.game_grid[x_pos][y_pos].items	  = items;
	if (inv != noone){
		manager.game_state.game_grid[x_pos][y_pos].inventory = inv;
	}
	if (prev_open != noone){
		manager.game_state.game_grid[x_pos][y_pos].has_been_opened = prev_open;
	}
	manager.game_state.game_grid[x_pos][y_pos].is_lit = lit;
}

function tile_lookup(list){
	var len = array_length(list);
	var roll = irandom(100);
	for (var i = 0; i < len; i ++){
		if (roll < list[i][1]){
			return(list[i][0]);
		}
	}
	return(list[len-1][0]);
}

function water_tile_placement(grid){
	var xx, yy;
	for (xx = 0; xx < ZONE_SIZE; xx ++){
		for (yy = 0; yy < ZONE_SIZE; yy ++){
			if (grid[xx][yy].tile == "water"){
				if (grid[xx][yy].index >= 46){
					var new_tile = tile_lookup(terrain_lookup[BIOME.WATER]);
					grid[xx][yy] = generate_zone_tile(new_tile);
				}
			}
		}
	}
	return(grid);
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
	light_radius	= 4;
}

// Decorative
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


// WORLD TILES
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




