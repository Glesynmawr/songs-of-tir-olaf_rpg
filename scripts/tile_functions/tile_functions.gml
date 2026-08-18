
// TILE SWAPPING
function cell_replace_tile(x_pos, y_pos, new_tile){
	var vis   = other.game_grid[x_pos][y_pos].is_visible;
	var ex    = other.game_grid[x_pos][y_pos].explored;
	var items = other.game_grid[x_pos][y_pos].items;
	
	other.game_grid[x_pos][y_pos] = new new_tile();
	
	other.game_grid[x_pos][y_pos].is_visible = vis;
	other.game_grid[x_pos][y_pos].explored   = ex;
	other.game_grid[x_pos][y_pos].items		 = items;
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
	
function generate_zone_tile(tile_type){
	var new_tile = new tile_type();
	new_tile.index += irandom(floor(sprite_get_width(new_tile.sprite) / cell_width) - 1);
	return(new_tile);
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
function tile_door_closed()constructor{
	tile			= "closed door";
	sprite			= door_closed_spr;
	index			= 0;
	colour_fg		= noone;
	colour_bg		= noone;
	walkable		= true;
	transparent		= false;
	is_visible		= false;
	explored		= false;
	tile_script		= door_set_open;
}

function tile_door_open()constructor{
	tile			= "open door";
	sprite			= door_open_spr;
	index			= 0;
	colour_fg		= noone;
	colour_bg		= noone;
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
	colour_fg		= noone;
	colour_bg		= noone;
	walkable		= true;
	transparent		= false;
	is_visible		= false;
	explored		= false;
	tile_script		= door_set_open;
}

function tile_dungeon_entrance()constructor{
	tile			= "dungeon entrance";
	sprite			= zone_tile_dungeon_entrance_spr;
	index			= 0;
	colour_fg		= noone;
	colour_bg		= noone;
	walkable		= true;
	transparent		= false;
	is_visible		= false;
	explored		= false;
	tile_script		= dungeon_enter;
	dungeon_list	= [];
}

function tile_hall()constructor{
	tile			= "hall";
	sprite			= wall_00_spr;
	index			= 0;
	colour_fg		= noone;
	colour_bg		= noone;
	walkable		= true;
	transparent		= true;
	is_visible		= false;
	explored		= false;
	tile_script		= noone;
}

function tile_room()constructor{
	tile			= "room";
	sprite			= wall_00_spr;
	index			= 0;
	colour_fg		= noone;
	colour_bg		= noone;
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
	colour_fg		= noone;
	colour_bg		= noone;
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
	colour_fg		= noone;
	colour_bg		= noone;
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
	colour_fg		= noone;
	colour_bg		= noone;
	walkable		= false;
	transparent		= false;
	is_visible		= false;
	explored		= false;
	tile_script		= noone;
}


// WORLD TILES
function tile_world_mountain()constructor{
	tile			= "mountain";
	biome			= BIOME.MOUNTAIN;
	sprite			= world_tiles_spr;
	index			= 0;
	colour_fg		= noone;
	colour_bg		= noone;
	walkable		= true;
	transparent		= false;
	is_visible		= false;
	explored		= false;
	tile_script		= noone;
}

function tile_world_hill()constructor{
	tile			= "hill";
	biome			= BIOME.HILL;
	sprite			= world_tiles_spr;
	index			= 8;
	colour_fg		= noone;
	colour_bg		= noone;
	walkable		= true;
	transparent		= true;
	is_visible		= false;
	explored		= false;
	tile_script		= noone;
}

function tile_world_canyon()constructor{
	tile			= "canyon";
	biome			= BIOME.CANYON;
	sprite			= world_tiles_spr;
	index			= 16;
	colour_fg		= noone;
	colour_bg		= noone;
	walkable		= true;
	transparent		= true;
	is_visible		= false;
	explored		= false;
	tile_script		= noone;
}

function tile_world_salt_plain()constructor{
	tile			= "salt plain";
	biome			= BIOME.DESERT;
	sprite			= world_tiles_spr;
	index			= 24;
	colour_fg		= noone;
	colour_bg		= noone;
	walkable		= true;
	transparent		= true;
	is_visible		= false;
	explored		= false;
	tile_script		= noone;
}

function tile_world_scrubland()constructor{
	tile			= "scrubland";
	biome			= BIOME.SCRUB;
	sprite			= world_tiles_spr;
	index			= 32;
	colour_fg		= noone;
	colour_bg		= noone;
	walkable		= true;
	transparent		= true;
	is_visible		= false;
	explored		= false;
	tile_script		= noone;
}

function tile_world_dense_mangrove()constructor{
	tile			= "dense mangrove";
	biome			= BIOME.DENSE_MANGROVE;
	sprite			= world_tiles_spr;
	index			= 40;
	colour_fg		= noone;
	colour_bg		= noone;
	walkable		= true;
	transparent		= false;
	is_visible		= false;
	explored		= false;
	tile_script		= noone;
}

function tile_world_swamp()constructor{
	tile			= "swamp";
	biome			= BIOME.SWAMP;
	sprite			= world_tiles_spr;
	index			= 48;
	colour_fg		= noone;
	colour_bg		= noone;
	walkable		= true;
	transparent		= true;
	is_visible		= false;
	explored		= false;
	tile_script		= noone;
}

function tile_world_water()constructor{
	tile			= "water";
	biome			= BIOME.WATER;
	sprite			= world_tiles_spr;
	index			= 56;
	colour_fg		= noone;
	colour_bg		= noone;
	walkable		= true;
	transparent		= true;
	is_visible		= false;
	explored		= false;
	tile_script		= noone;
}

function tile_world_mangrove()constructor{
	tile			= "mangrove";
	biome			= BIOME.MANGROVE;
	sprite			= world_tiles_spr;
	index			= 40;
	colour_fg		= noone;
	colour_bg		= noone;
	walkable		= true;
	transparent		= false;
	is_visible		= false;
	explored		= false;
	tile_script		= noone;
}

function tile_world_marsh()constructor{
	tile			= "marsh";
	biome			= BIOME.MARSH;
	sprite			= world_tiles_spr;
	index			= 48;
	colour_fg		= noone;
	colour_bg		= noone;
	walkable		= true;
	transparent		= true;
	is_visible		= false;
	explored		= false;
	tile_script		= noone;
}


// ZONE TILES
function tile_zone_bush()constructor{
	tile			= "bush";
	sprite			= zone_tile_bush_spr;
	index			= 0;
	colour_fg		= noone;
	colour_bg		= noone;
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
	colour_fg		= noone;
	colour_bg		= noone;
	walkable		= true;
	transparent		= true;
	is_visible		= false;
	explored		= false;
	tile_script		= noone;
}

function tile_zone_grass()constructor{
	tile			= "grass";
	sprite			= zone_tile_grass_spr;
	index			= 0;
	colour_fg		= noone;
	colour_bg		= noone;
	walkable		= true;
	transparent		= true;
	is_visible		= false;
	explored		= false;
	tile_script		= noone;
}

function tile_zone_lilypad()constructor{
	tile			= "lilypad";
	sprite			= zone_tile_lilypad_spr;
	index			= 0;
	colour_fg		= noone;
	colour_bg		= noone;
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
	colour_fg		= noone;
	colour_bg		= noone;
	walkable		= true;
	transparent		= true;
	is_visible		= false;
	explored		= false;
	tile_script		= noone;
}

function tile_zone_reeds()constructor{
	tile			= "reeds";
	sprite			= zone_tile_reeds_spr;
	index			= 0;
	colour_fg		= noone;
	colour_bg		= noone;
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
	colour_fg		= noone;
	colour_bg		= noone;
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
	colour_fg		= noone;
	colour_bg		= noone;
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
	colour_fg		= noone;
	colour_bg		= noone;
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
	colour_fg		= noone;
	colour_bg		= noone;
	walkable		= true;
	transparent		= true;
	is_visible		= false;
	explored		= false;
	tile_script		= noone;
}




