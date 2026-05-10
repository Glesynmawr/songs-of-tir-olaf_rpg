
function tile_wall()constructor{
	tile			= "wall";
	char			= "#";
	fg				= c_ltgrey;
	bg				= c_dkgrey;
	walkable		= false;
	transparent		= false;
	is_visible		= false;
	explored		= false;
	tile_script		= noone;
}

function tile_room()constructor{
	tile			= "room";
	char			= ".";
	fg				= c_grey;
	bg				= c_black;
	walkable		= true;
	transparent		= true;
	is_visible		= false;
	explored		= false;
	tile_script		= noone;
}

function tile_hall()constructor{
	tile			= "hall";
	char			= ".";
	fg				= c_grey;
	bg				= c_black;
	walkable		= true;
	transparent		= true;
	is_visible		= false;
	explored		= false;
	tile_script		= noone;
}

function tile_closed_door()constructor{
	tile			= "closed door";
	char			= "+";
	fg				= c_aqua;
	bg				= c_navy;
	walkable		= true;
	transparent		= false;
	is_visible		= false;
	explored		= false;
	tile_script		= door_set_open;
}

function tile_secret_door()constructor{
	tile			= "closed door";
	char			= "?";
	fg				= c_lime;
	bg				= c_green;
	walkable		= true;
	transparent		= false;
	is_visible		= false;
	explored		= false;
	tile_script		= noone;
}

function tile_open_door()constructor{
	tile			= "open door";
	char			= "/";
	fg				= c_aqua;
	bg				= c_navy;
	walkable		= true;
	transparent		= true;
	is_visible		= false;
	explored		= false;
	tile_script		= door_set_close;
}

function tile_entry()constructor{
	tile			= "entry";
	char			= "<";
	fg				= c_orange;
	bg				= c_red;
	walkable		= true;
	transparent		= true;
	is_visible		= false;
	explored		= false;
	tile_script		= noone;
}

function tile_exit()constructor{
	tile			= "exit";
	char			= ">";
	fg				= c_white;
	bg				= c_aqua;
	walkable		= true;
	transparent		= true;
	is_visible		= false;
	explored		= false;
	tile_script		= noone;
}




