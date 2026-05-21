
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

function item_sword()constructor{
	name		= "Sword";
	slot		= [EQUIP.HAND];
	tags		= [TAG.TWO_SLOTS];
	interact	= ["Equip", "Drop"];
}

function item_shield()constructor{
	name		= "Shield";
	slot		= [EQUIP.HAND];
	tags		= [];
	interact	= ["Equip", "Drop"];
}

function item_helmet()constructor{
	name		= "Helmet";
	slot		= [EQUIP.HEAD];
	tags		= [];
	interact	= ["Equip", "Drop"];
}

function item_armour()constructor{
	name		= "Armour";
	slot		= [EQUIP.BODY];
	tags		= [];
	interact	= ["Equip", "Drop"];
}

function item_bow()constructor{
	name		= "Bow";
	slot		= [EQUIP.GUNS];
	tags		= [TAG.TWO_SLOTS];
	interact	= ["Equip", "Drop"];
}

function item_arrow()constructor{
	name		= "Arrow";
	slot		= [];
	tags		= [];
	interact	= ["Drop"];
}




