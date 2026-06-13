
function zone_mountain(){
	var temp_list = [];
	for (var xx = 0; xx < zone_size; xx ++){
		for (var yy = 0; yy < zone_size; yy ++){
			temp_list[xx][yy] = new tile_world_mountain();
		}
	}
	return(temp_list);
}

function zone_hill(){
	var temp_list = [];
	for (var xx = 0; xx < zone_size; xx ++){
		for (var yy = 0; yy < zone_size; yy ++){
			temp_list[xx][yy] = new tile_world_hill();
		}
	}
	return(temp_list);
}

function zone_canyon(world_index){
	var temp_list = [];
	for (var xx = 0; xx < zone_size; xx ++){
		for (var yy = 0; yy < zone_size; yy ++){
			temp_list[xx][yy] = new tile_world_canyon();
			
			// Get tile image index for canyon wall position
		}
	}
	return(temp_list);
}

function zone_salt_plain(){
	var temp_list = [];
	for (var xx = 0; xx < zone_size; xx ++){
		for (var yy = 0; yy < zone_size; yy ++){
			temp_list[xx][yy] = new tile_world_salt_plain();
		}
	}
	return(temp_list);
}

function zone_scrubland(){
	var temp_list = [];
	for (var xx = 0; xx < zone_size; xx ++){
		for (var yy = 0; yy < zone_size; yy ++){
			temp_list[xx][yy] = new tile_world_scrubland();
		}
	}
	return(temp_list);
}

function zone_marsh(){
	var temp_list = [];
	for (var xx = 0; xx < zone_size; xx ++){
		for (var yy = 0; yy < zone_size; yy ++){
			temp_list[xx][yy] = new tile_world_marsh();
		}
	}
	return(temp_list);
}

function zone_mangrove(){
	var temp_list = [];
	for (var xx = 0; xx < zone_size; xx ++){
		for (var yy = 0; yy < zone_size; yy ++){
			temp_list[xx][yy] = new tile_world_mangrove();
		}
	}
	return(temp_list);
}

function zone_water(world_index){
	var temp_list = [];
	for (var xx = 0; xx < zone_size; xx ++){
		for (var yy = 0; yy < zone_size; yy ++){
			temp_list[xx][yy] = new tile_world_water();
			
			// Get tile image index for water bank position
		}
	}
	return(temp_list);
}


