
function inventory_initialise(){
	var inv;
	
	inv = {
		items: [],
		hover: 0
	}
	
	return(inv);
}

function pickup_menu_initialise(actor){
	var items = manager_obj.game_grid[actor.x_pos][actor.y_pos].items;
	if (array_length(items) <= 0){
		return(false);
	}
	else{
		pickup_menu		= [];
		pickup_hover	= 0;
		
		for (var i = 0; i < array_length(items); i ++){
			array_push(pickup_menu, items[i]);
		}
		
		state = state_pickup;
	}
}

function inventory_add_item(actor, item){
	with (actor){
		array_push(inventory.items, item);
		return(true);
	}
}

function inventory_drop_slot(actor, slot, stack){
	with (actor){
		inventory.items[slot].stack -= stack;
		if (inventory.items[slot].stack <= 0){
			array_delete(inventory.items, slot, 1);
		}
		if (inventory.hover >= array_length(inventory.items)) inventory.hover = array_length(inventory.items) - 1;
		
		return(true);
	}
}




