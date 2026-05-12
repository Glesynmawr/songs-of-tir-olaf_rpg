
function spawn_item(item, stack, location, x_pos = 0, y_pos = 0, actor = noone){
	var new_item = new item();
	new_item.stack = stack;
	
	if (location == SPAWN_LOC.FLOOR){
		array_push(grid[x_pos][y_pos].items, new_item);
	}
	if (location == SPAWN_LOC.INVENTORY){
		inventory_add_item(actor, new_item);
	}
}

function item_sword()constructor{
	name	= "Sword";
	slots	= [];
	tags	= [];
}

function item_shield()constructor{
	name	= "Shield";
	slots	= [];
	tags	= [];
}

function item_helmet()constructor{
	name	= "Helmet";
	slots	= [];
	tags	= [];
}

function item_armour()constructor{
	name	= "Armour";
	slots	= [];
	tags	= [];
}

function item_bow()constructor{
	name	= "Bow";
	slots	= [];
	tags	= [];
}

function item_arrow()constructor{
	name	= "Arrow";
	slots	= [];
	tags	= [];
}




