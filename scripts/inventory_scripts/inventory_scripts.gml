
function inventory_draw(actor, x_pos, y_pos, width, height){
	
	// Get inventory array
	var inv = actor.inventory.items;
	
	// Background
	var bg_col = c_black;
	draw_rectangle_colour(x_pos, y_pos, x_pos + width, y_pos + height, bg_col, bg_col, bg_col, bg_col, false);
	
	// Title
	draw_text(x_pos + 10, y_pos + 10, "Inventory");
	
	// Items
	var len = array_length(inv);
	if (len > 0){
		for(var i = 0; i < len; i ++){
			
			// Position
			var xx = x_pos + 20;
			var yy = y_pos + 40 + (30 * i);
			
			// Text
			var text = "";
			if (actor.inventory.hover == i){
				text += "> ";
			}
			
			text += inv[i].name;
			
			draw_text(xx, yy, text);
		}
	}
}

function inventory_initialise(){
	var inv;
	
	inv = {
		items: [],
		hover: 0
	}
	
	return(inv);
}

function inventory_add_item(actor, item){
	with (actor){
		array_push(inventory.items, item);
		return(true);
	}
}

function inventory_drop_slot(actor, slot){
	with (actor){
		array_delete(inventory.items, slot, 1);
		return(true);
	}
}




