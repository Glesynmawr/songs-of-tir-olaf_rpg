
// LEVEL TILES
function cell_replace_tile(x_pos, y_pos, new_tile){
	var vis   = other.game_grid[x_pos][y_pos].is_visible;
	var ex    = other.game_grid[x_pos][y_pos].explored;
	var items = other.game_grid[x_pos][y_pos].items;
	
	other.game_grid[x_pos][y_pos] = new new_tile();
	
	other.game_grid[x_pos][y_pos].is_visible = vis;
	other.game_grid[x_pos][y_pos].explored   = ex;
	other.game_grid[x_pos][y_pos].items		 = items;
}

function tile_door_closed()constructor{
	tile			= "closed door";
	sprite			= door_closed_spr;
	index			= 0;
	fg				= c_aqua;
	bg				= c_navy;
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
	fg				= c_aqua;
	bg				= c_navy;
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
	fg				= c_ltgrey;
	bg				= c_dkgrey;
	walkable		= true;
	transparent		= false;
	is_visible		= false;
	explored		= false;
	tile_script		= door_set_open;
}

function tile_hall()constructor{
	tile			= "hall";
	sprite			= wall_00_spr;
	index			= 0;
	fg				= c_grey;
	bg				= c_black;
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
	fg				= c_grey;
	bg				= c_black;
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
	fg				= c_orange;
	bg				= c_red;
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
	fg				= c_white;
	bg				= c_aqua;
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
	fg				= c_ltgrey;
	bg				= c_dkgrey;
	walkable		= false;
	transparent		= false;
	is_visible		= false;
	explored		= false;
	tile_script		= noone;
}


// WORLD TILES
function tile_world_mountain()constructor{
	tile	= "mountain";
	sprite	= world_tiles_spr;
	index	= 0;
}

function tile_world_hill()constructor{
	tile	= "hill";
	sprite	= world_tiles_spr;
	index	= 8;
}

function tile_world_canyon()constructor{
	tile	= "canyon";
	sprite	= world_tiles_spr;
	index	= 16;
}

function tile_world_salt_plain()constructor{
	tile	= "salt plain";
	sprite	= world_tiles_spr;
	index	= 24;
}

function tile_world_scrubland()constructor{
	tile	= "scrubland";
	sprite	= world_tiles_spr;
	index	= 32;
}

function tile_world_mangrove()constructor{
	tile	= "mangrove";
	sprite	= world_tiles_spr;
	index	= 40;
}

function tile_world_marsh()constructor{
	tile	= "marsh";
	sprite	= world_tiles_spr;
	index	= 48;
}

function tile_world_water()constructor{
	tile	= "water";
	sprite	= world_tiles_spr;
	index	= 56;
}


