
function spawn_new_item(item, stack, location, x_pos = 0, y_pos = 0, actor = noone){
	var new_item = new item();
	new_item.stack = stack;
	
	if (location == SPAWN_LOC.FLOOR){
		array_push(grid[x_pos][y_pos].items, new_item);
	}
	if (location == SPAWN_LOC.INVENTORY){
		inventory_add_item(actor, new_item);
	}
}

function spawn_existing_item(item, stack, x_pos, y_pos){
	
	var new_item = variable_clone(item);
	new_item.stack = stack;
	
	with (manager.game_grid[x_pos][y_pos]){
		array_push(items, new_item);
	}
}

function item_hat()constructor{
	name		= "Hat";
	slot		= [BODY_PART_CATEGORY.HEAD, BODY_PART_STATS.PART_SLOT_1];
	spawn_count = 1;
	tags		= [];
	interact	= ["Equip", "Drop"];
}






