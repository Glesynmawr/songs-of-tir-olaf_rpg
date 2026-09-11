
function spawn_new_item(item, stack, location, x_pos = 0, y_pos = 0, actor = noone){
	var new_item	= new item();
	new_item.stack	= stack;
	
	if (location == SPAWN_LOC.FLOOR){
		array_push(game_grid[x_pos][y_pos].items, new_item);
	}
	if (location == SPAWN_LOC.INVENTORY){
		inventory_add_item(actor, new_item);
	}
}

function spawn_existing_item(item, stack = -1, x_pos, y_pos){
	
	var new_item = variable_clone(item);
	
	if (stack != -1){
		new_item.stack = stack;
	}
	
	with (manager.game_grid[x_pos][y_pos]){
		array_insert(items, 0, new_item);
	}
}

function item_hat1()constructor{
	name			= "Hat 1";
	sprite_index	= head_spr;
	image_index		= 0;
	slot			= [BODY_PART_CATEGORY.HEAD, HEAD_INDEX.HEAD];
	weight			= 1;
	value			= 1;
}

function item_hat2()constructor{
	name			= "Hat 2";
	sprite_index	= head_spr;
	image_index		= 1;
	slot			= [BODY_PART_CATEGORY.HEAD, HEAD_INDEX.HEAD];
	weight			= 1;
	value			= 1;
}

function item_mask1()constructor{
	name			= "Mask 1";
	sprite_index	= face_spr;
	image_index		= 0;
	slot			= [BODY_PART_CATEGORY.HEAD, HEAD_INDEX.FACE];
	weight			= 1;
	value			= 1;
}

function item_mask2()constructor{
	name			= "Mask 2";
	sprite_index	= face_spr;
	image_index		= 1;
	slot			= [BODY_PART_CATEGORY.HEAD, HEAD_INDEX.FACE];
	weight			= 1;
	value			= 1;
}

function item_armour1()constructor{
	name			= "Armour 1";
	sprite_index	= body_spr;
	image_index		= 0;
	slot			= [BODY_PART_CATEGORY.BODY, BODY_INDEX.BODY];
	weight			= 1;
	value			= 1;
	armour			= 1;
}

function item_armour2()constructor{
	name			= "Armour 2";
	sprite_index	= body_spr;
	image_index		= 1;
	slot			= [BODY_PART_CATEGORY.BODY, BODY_INDEX.BODY];
	weight			= 1;
	value			= 1;
	armour			= 1;
}

function item_cloak1()constructor{
	name			= "Cloak 1";
	sprite_index	= back_spr;
	image_index		= 0;
	slot			= [BODY_PART_CATEGORY.BODY, BODY_INDEX.BACK];
	weight			= 1;
	value			= 1;
}

function item_cloak2()constructor{
	name			= "Cloak 2";
	sprite_index	= back_spr;
	image_index		= 1;
	slot			= [BODY_PART_CATEGORY.BODY, BODY_INDEX.BACK];
	weight			= 1;
	value			= 1;
}

function item_vambrace1()constructor{
	name			= "Vambrace 1";
	sprite_index	= bracer_spr;
	image_index		= 0;
	slot			= [BODY_PART_CATEGORY.ARMS, ARMS_INDEX.BRACER];
	weight			= 1;
	value			= 1;
	armour			= 1;
}

function item_vambrace2()constructor{
	name			= "Vambrace 2";
	sprite_index	= bracer_spr;
	image_index		= 1;
	slot			= [BODY_PART_CATEGORY.ARMS, ARMS_INDEX.BRACER];
	weight			= 1;
	value			= 1;
	armour			= 1;
}

function item_glove1()constructor{
	name			= "Glove 1";
	sprite_index	= glove_spr;
	image_index		= 0;
	slot			= [BODY_PART_CATEGORY.ARMS, ARMS_INDEX.GLOVE];
	weight			= 1;
	value			= 1;
}

function item_glove2()constructor{
	name			= "Glove 2";
	sprite_index	= glove_spr;
	image_index		= 1;
	slot			= [BODY_PART_CATEGORY.ARMS, ARMS_INDEX.GLOVE];
	weight			= 1;
	value			= 1;
}

function item_greave1()constructor{
	name			= "Greave 1";
	sprite_index	= greave_spr;
	image_index		= 0;
	slot			= [BODY_PART_CATEGORY.LEGS, LEGS_INDEX.GREAVE];
	weight			= 1;
	value			= 1;
	armour			= 1;
}

function item_greave2()constructor{
	name			= "Greave 2";
	sprite_index	= greave_spr;
	image_index		= 1;
	slot			= [BODY_PART_CATEGORY.LEGS, LEGS_INDEX.GREAVE];
	weight			= 1;
	value			= 1;
	armour			= 1;
}

function item_boot1()constructor{
	name			= "Boot 1";
	sprite_index	= boot_spr;
	image_index		= 0;
	slot			= [BODY_PART_CATEGORY.LEGS, LEGS_INDEX.BOOT];
	weight			= 1;
	value			= 1;
}

function item_boot2()constructor{
	name			= "Boot 2";
	sprite_index	= boot_spr;
	image_index		= 1;
	slot			= [BODY_PART_CATEGORY.LEGS, LEGS_INDEX.BOOT];
	weight			= 1;
	value			= 1;
}

function item_sword1()constructor{
	name			= "Sword 1";
	sprite_index	= weapon_spr;
	image_index		= 0;
	slot			= [];
	weight			= 1;
	value			= 1;
	damage			= [1, 3, 0];
}

function item_sword2()constructor{
	name			= "Sword 2";
	sprite_index	= weapon_spr;
	image_index		= 1;
	slot			= [];
	weight			= 1;
	value			= 1;
}


