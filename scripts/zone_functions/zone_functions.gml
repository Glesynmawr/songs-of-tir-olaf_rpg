
function zone_mountain(){
	var temp_list = [];
	for (var xx = 0; xx < zone_size; xx ++){
		for (var yy = 0; yy < zone_size; yy ++){
			temp_list[xx][yy] = new tile_zone_rocks();
		}
	}
	return(temp_list);
}

function zone_hill(){
	var temp_list = [];
	for (var xx = 0; xx < zone_size; xx ++){
		for (var yy = 0; yy < zone_size; yy ++){
			temp_list[xx][yy] = new tile_zone_grass();
		}
	}
	return(temp_list);
}

function zone_canyon(world_index){
	var temp_list = [];
	for (var xx = 0; xx < zone_size; xx ++){
		for (var yy = 0; yy < zone_size; yy ++){
			temp_list[xx][yy] = new tile_world_canyon();
			temp_list[xx][yy].sprite = zone_tiles_spr;
			temp_list[xx][yy].index += irandom(tiles_per_biome - 1);
			
			// Get tile image index for canyon wall position
		}
	}
	return(temp_list);
}

function zone_salt_plain(){
	var temp_list = [];
	for (var xx = 0; xx < zone_size; xx ++){
		for (var yy = 0; yy < zone_size; yy ++){
			temp_list[xx][yy] = new tile_zone_salt();
		}
	}
	return(temp_list);
}

function zone_scrubland(){
	var temp_list = [];
	for (var xx = 0; xx < zone_size; xx ++){
		for (var yy = 0; yy < zone_size; yy ++){
			temp_list[xx][yy] = new tile_zone_dirt();
		}
	}
	return(temp_list);
}

function zone_marsh(){
	var temp_list = [];
	for (var xx = 0; xx < zone_size; xx ++){
		for (var yy = 0; yy < zone_size; yy ++){
			temp_list[xx][yy] = new tile_zone_grass();
		}
	}
	return(temp_list);
}

function zone_mangrove(){
	var temp_list = [];
	for (var xx = 0; xx < zone_size; xx ++){
		for (var yy = 0; yy < zone_size; yy ++){
			temp_list[xx][yy] = generate_zone_tile(tile_zone_tree);
		}
	}
	return(temp_list);
}

function zone_water(world_index){
	var temp_list = [];
	for (var xx = 0; xx < zone_size; xx ++){
		for (var yy = 0; yy < zone_size; yy ++){
			temp_list[xx][yy] = generate_zone_tile(tile_zone_water);
		}
	}
	
	var tile_fill;
	tile_fill[0] = false;	// Right edge
	tile_fill[1] = false;	// Top edge
	tile_fill[2] = false;	// Left edge
	tile_fill[3] = false;	// Bottom edge
	tile_fill[4] = false;	// Top right corner
	tile_fill[5] = false;	// Top left corner
	tile_fill[6] = false;	// bottom left corner
	tile_fill[7] = false;	// bottom right corner
			
	// Get tile image index for water bank position
	switch(world_index){
		case 0:  tile_fill[0] = true tile_fill[1] = true tile_fill[2] = true tile_fill[3] = true;	break;
		case 1:  tile_fill[1] = true tile_fill[2] = true tile_fill[3] = true;						break;
		case 2:  tile_fill[0] = true tile_fill[2] = true tile_fill[3] = true;						break;
		case 3:  tile_fill[2] = true tile_fill[3] = true;											break;
		case 4:  tile_fill[0] = true tile_fill[1] = true tile_fill[3] = true;						break;
		case 5:  tile_fill[1] = true tile_fill[3] = true;											break;
		case 6:  tile_fill[0] = true tile_fill[3] = true tile_fill[5] = true;						break;
		case 7:  tile_fill[3] = true tile_fill[5] = true;											break;
		case 8:  tile_fill[0] = true tile_fill[1] = true tile_fill[2] = true;						break;
		case 9:  tile_fill[1] = true tile_fill[2] = true tile_fill[7] = true;						break;
		case 10: tile_fill[0] = true tile_fill[2] = true;											break;
		case 11: tile_fill[2] = true tile_fill[4] = true tile_fill[7] = true;						break;
		case 12: tile_fill[0] = true tile_fill[1] = true tile_fill[6] = true;						break;
		case 13: tile_fill[1] = true tile_fill[6] = true tile_fill[7] = true;						break;
		case 14: tile_fill[0] = true tile_fill[5] = true tile_fill[6] = true;						break;
		case 15: tile_fill[4] = true tile_fill[5] = true tile_fill[6] = true tile_fill[7] = true;	break;
		case 16: tile_fill[2] = true tile_fill[3] = true;											break;
		case 17: tile_fill[0] = true tile_fill[3] = true;											break;
		case 18: tile_fill[3] = true tile_fill[5] = true;											break;
		case 19: tile_fill[3] = true tile_fill[4] = true;											break;
		case 20: tile_fill[3] = true;																break;
		case 21: tile_fill[1] = true tile_fill[2] = true;											break;
		case 22: tile_fill[2] = true tile_fill[7] = true;											break;
		case 23: tile_fill[2] = true tile_fill[4] = true;											break;
		case 24: tile_fill[2] = true;																break;
		case 25: tile_fill[0] = true tile_fill[1] = true;											break;
		case 26: tile_fill[1] = true tile_fill[7] = true;											break;
		case 27: tile_fill[1] = true tile_fill[6] = true;											break;
		case 28: tile_fill[1] = true;																break;
		case 29: tile_fill[0] = true tile_fill[6] = true;											break;
		case 30: tile_fill[0] = true tile_fill[5] = true;											break;
		case 31: tile_fill[0] = true;																break;
		case 32: tile_fill[5] = true tile_fill[6] = true tile_fill[7] = true;						break;
		case 33: tile_fill[4] = true tile_fill[6] = true tile_fill[7] = true;						break;
		case 34: tile_fill[4] = true tile_fill[5] = true tile_fill[7] = true;						break;
		case 35: tile_fill[4] = true tile_fill[5] = true tile_fill[6] = true;						break;
		case 36: tile_fill[4] = true tile_fill[6] = true;											break;
		case 37: tile_fill[5] = true tile_fill[7] = true;											break;
		case 38: tile_fill[5] = true tile_fill[6] = true;											break;
		case 39: tile_fill[4] = true tile_fill[5] = true;											break;
		case 40: tile_fill[4] = true tile_fill[7] = true;											break;
		case 41: tile_fill[6] = true tile_fill[7] = true;											break;
		case 42: tile_fill[4] = true;																break;
		case 43: tile_fill[5] = true;																break;
		case 44: tile_fill[6] = true;																break;
		case 45: tile_fill[7] = true;																break;
		case 46: ;																					break;
				
	}
	var x2, y2, dist, anchor_x, anchor_y, tile_chance;
	
	// Right edge fill
	if (tile_fill[0] == true){
		anchor_x = zone_size - 1;
		for (x2 = 0; x2 < zone_size; x2 ++){
			for (y2 = 0; y2 < zone_size; y2 ++){
				anchor_y = y2;
				dist = point_distance(x2, y2, anchor_x, anchor_y);
				tile_chance = dist / zone_third;
				if (random(1) >= tile_chance){
					temp_list[x2][y2] = generate_zone_tile(tile_zone_tree);
				}
			}
		}
	}
			
	// Top edge tiling
	if (tile_fill[1] == true){
		anchor_y = 0;
		for (x2 = 0; x2 < zone_size; x2 ++){
			anchor_x = x2;
			for (y2 = 0; y2 < zone_size; y2 ++){
				dist = point_distance(x2, y2, anchor_x, anchor_y);
				tile_chance = dist / zone_third;
				if (random(1) >= tile_chance){
					temp_list[x2][y2] = generate_zone_tile(tile_zone_tree);
				}
			}
		}
	}
	
	// Left edge fill
	if (tile_fill[2] == true){
		anchor_x = 0;
		for (x2 = 0; x2 < zone_size; x2 ++){
			for (y2 = 0; y2 < zone_size; y2 ++){
				anchor_y = y2;
				dist = point_distance(x2, y2, anchor_x, anchor_y);
				tile_chance = dist / zone_third;
				if (random(1) >= tile_chance){
					temp_list[x2][y2] = generate_zone_tile(tile_zone_tree);
				}
			}
		}
	}
	
	// Bottom edge fill
	if (tile_fill[3] == true){
		anchor_y = zone_size - 1;
		for (x2 = 0; x2 < zone_size; x2 ++){
			anchor_x = x2;
			for (y2 = 0; y2 < zone_size; y2 ++){
				dist = point_distance(x2, y2, anchor_x, anchor_y);
				tile_chance = dist / zone_third;
				if (random(1) >= tile_chance){
					temp_list[x2][y2] = generate_zone_tile(tile_zone_tree);
				}
			}
		}
	}
	
	// Top right corner fill
	if (tile_fill[4] == true){
		anchor_x = zone_size - 1;
		anchor_y = 0;
		
		for (x2 = 0; x2 < zone_size; x2 ++){
			for (y2 = 0; y2 < zone_size; y2 ++){
				dist = point_distance(x2, y2, anchor_x, anchor_y);
				tile_chance = dist / zone_third;
				if (random(1) >= tile_chance){
					temp_list[x2][y2] = generate_zone_tile(tile_zone_tree);
				}
			}
		}
	}
	
	// Top left corner fill
	if (tile_fill[5] == true){
		anchor_x = 0;
		anchor_y = 0;
		
		for (x2 = 0; x2 < zone_size; x2 ++){
			for (y2 = 0; y2 < zone_size; y2 ++){
				dist = point_distance(x2, y2, anchor_x, anchor_y);
				tile_chance = dist / zone_third;
				if (random(1) >= tile_chance){
					temp_list[x2][y2] = generate_zone_tile(tile_zone_tree);
				}
			}
		}
	}
	
	// bottom left corner fill
	if (tile_fill[6] == true){
		anchor_x = 0;
		anchor_y = zone_size - 1;
		
		for (x2 = 0; x2 < zone_size; x2 ++){
			for (y2 = 0; y2 < zone_size; y2 ++){
				dist = point_distance(x2, y2, anchor_x, anchor_y);
				tile_chance = dist / zone_third;
				if (random(1) >= tile_chance){
					temp_list[x2][y2] = generate_zone_tile(tile_zone_tree);
				}
			}
		}
	}
	
	// bottom right corner fill
	if (tile_fill[7] == true){
		anchor_x = zone_size - 1;
		anchor_y = zone_size - 1;
		
		for (x2 = 0; x2 < zone_size; x2 ++){
			for (y2 = 0; y2 < zone_size; y2 ++){
				dist = point_distance(x2, y2, anchor_x, anchor_y);
				tile_chance = dist / zone_third;
				if (random(1) >= tile_chance){
					temp_list[x2][y2] = generate_zone_tile(tile_zone_tree);
				}
			}
		}
	}
	
	temp_list = autotile_map(temp_list);
	
	return(temp_list);
}




