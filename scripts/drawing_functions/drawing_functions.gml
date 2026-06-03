
// GAME DRAWING -----------------------------------------------------------------------------------
function draw_actors(list){
	var len = array_length(list);
	if (len > 0){
		for (var actor = 0; actor < len; actor ++){
		
			with (list[actor]){
				if (self.is_visible or manager.debugging_mode){
				
					// Position and colour
					var xx	= self.x_pos * other.cell_width;
					var yy	= self.y_pos * other.cell_height;
					var col	= self.fg;
		
					// Draw actor sprite
					draw_sprite_ext(sprite[0], sprite[1], xx, yy, 1, 1, 0, col, 1);
				}
			}
		}
	}
}
	
function draw_direction_indicator(){
	if (direction_indicator != noone){
		
		with (actor_registry.player){
			var xx = (x_pos * other.cell_width) + (other.cell_width / 2);
			var yy = (y_pos * other.cell_height) + (other.cell_height / 2);
		
			draw_sprite_ext(direction_arrow_spr, manager.direction_indicator, xx, yy, 1, 1, 0, c_white, 1);
		}
	}
}

function draw_dungeon(){
	// Game layers
	draw_game_grid(game_grid);
	draw_actors(actor_registry.actor_list);
	
	if (game_paused){
		draw_pause_menu();
	}
	else{
		draw_direction_indicator();
	}
}
	
function draw_game_grid(grid){
	var ww = array_length(grid);
	var hh = array_length(grid[0]);
	
	for (var i = 0; i < ww; i ++){
		for (var j = 0; j < hh; j ++){
			if (grid[i][j].explored or debugging_mode){
				var spr = grid[i][j].sprite;
				var ind = grid[i][j].index;
				var fg   = c_white;
			
				var x_pos = i * cell_width;
				var y_pos = j * cell_height;
			
				if (!grid[i][j].is_visible and !debugging_mode){
					fg   = c_dkgrey;
				}
			
				var tile_x = ind % 8;
				var tile_y = ind div 8;
			
				draw_sprite_part_ext(spr, ind, tile_x*cell_width, tile_y*cell_height, cell_width, cell_height, x_pos, y_pos, 1, 1, fg, 1);
				
				if (array_length(grid[i][j].items) > 0){
					draw_sprite(item_spr, 0, x_pos, y_pos);
				}
			}
		}
	}
}

function draw_game_ui(){
	var ww = camera_get_view_width(view_camera[0]);
	var hh = camera_get_view_height(view_camera[0]);
	var xx = 0;
	var yy = 0;
	
	draw_text(text_width, text_height, $"HP: {actor_registry.player.hit_points}");

	draw_game_log(0, hh - log_height, ww, log_height);


	if (actor_registry.player.state == state_inventory or actor_registry.player.state == state_context_menu or actor_registry.player.state == state_slot_selection){
		draw_inventory(actor_registry.player, xx, yy, ww, hh);
	}
	if (actor_registry.player.state == state_pickup){
		draw_pickup(actor_registry.player);
	}

	draw_minimap();
}

function draw_world_grid(grid){
	var ww = array_length(grid);
	var hh = array_length(grid[0]);
	
	var i, j;
	for (i = 0; i < ww; i ++){
		for (j = 0; j < hh; j ++){
			
			var xx = i * cell_width;
			var yy = j * cell_height;
			var ind = grid[i][j].index;
			var spr = grid[i][j].sprite;
			
			var tile_x = ind % 8;
			var tile_y = ind div 8;
			
			draw_sprite_part_ext(spr, ind, tile_x*cell_width, tile_y*cell_height, cell_width, cell_height, xx, yy, 1, 1, c_white, 1);
			
			if (actor_registry.player.world_x == i and actor_registry.player.world_y == j){
				draw_rectangle_colour(xx, yy, xx + cell_width, yy + cell_height, bg_colour, bg_colour, bg_colour, bg_colour, false);
				draw_sprite_ext(actor_spr, 0, xx, yy, 1, 1, 0, c_yellow, 1);
			}
		}
	}
}


// UI DRAWING -------------------------------------------------------------------------------------
function draw_control_menu(){
	
	var control_text;
	control_text[0] = "Up";
	control_text[1] = "Down";
	control_text[2] = "Left";
	control_text[3] = "Right";
	control_text[4] = "Move";
	control_text[5] = "Select/Interact";
	control_text[6] = "Inventory";
	
	var box_height		= text_height * (array_length(control_menu) + array_length(control_text) + 6);
	var box_width		= text_width * 60;
	var box_center_x	= floor(screen_width * 0.5);
	var box_center_y	= floor(screen_height * 0.5);
	
	// Draw background
	draw_sprite(title_background_spr, 0, box_center_x, box_center_y);
	
	// UI border
	var box_left_x = box_center_x - floor(box_width * 0.5);
	var box_top_y  = box_center_y - floor(box_height * 0.5);
	var control_string = ui_menu_control_string();
	ui_draw_box(box_left_x, box_top_y, box_width, box_height, "Controls", control_string);
	
	var binding_y = box_top_y + (text_height * 2);
	var menu_y    = box_top_y + (text_height * 11);
	
	// Draw keybindings
	for (var i = 0; i < array_length(new_controls); i ++){
		
		var control_y = binding_y + (i * text_height);
		
		// Key use text
		draw_text_outlined(control_text[i], box_center_x - text_width, control_y, text_colour, fa_right);
		
		// Keybinding
		var control_key = "";
		if (!is_rebinding_keys){
			control_key += keybinding_get_text(new_controls[i]);
		}
		else{
			if (current_key_rebind == i){
				control_key += "<";
			}
			if (new_controls[i] != noone){
				control_key += keybinding_get_text(new_controls[i]);
			}
		}
		draw_text_outlined(control_key, box_center_x + text_width, control_y, text_colour, fa_left);
	}
	
	// Draw menu
	for (i = 0; i < array_length(control_menu); i ++){
		var yy = menu_y + (i * text_height);
		var txt = "";
		if (control_menu_hover == i){
			txt += "> ";
		}
		txt += control_menu[i];
		draw_text_outlined(txt, box_center_x, yy, text_colour, fa_center);
	}
}

function draw_main_menu(){
	var xx				= floor(screen_width * 0.5);
	var box_height		= text_height * (array_length(main_menu) + 4);
	var box_width		= text_width * 60;
	var box_center_x	= floor(screen_width * 0.5);
	var box_center_y	= floor(screen_height * 0.66);
	var title_y			= floor(screen_height * 0.5);
	
	// Background
	draw_sprite(title_background_spr, 0, box_center_x, title_y);
	
	// Title
	draw_sprite(title_spr, 0, box_center_x, floor(screen_height * 0.33));
	
	// UI border
	var box_left_x = box_center_x - floor(box_width / 2);
	var box_top_y  = box_center_y - floor(box_height / 2);
	var control_string = ui_menu_control_string();
	ui_draw_box(box_left_x, box_top_y, box_width, box_height, , control_string);
	
	// Draw menu
	for (var i = 0; i < array_length(main_menu); i ++){
		var yy = box_top_y + ((i + 2) * text_height);
		var txt = "";
		if (main_menu_hover == i){
			txt += "> ";
		}
		txt += main_menu[i];
		draw_text_outlined(txt, xx, yy, text_colour, fa_center);
	}
}

function draw_pause_menu(){
	var xx				= floor(screen_width * 0.5);
	var box_height		= text_height * (array_length(pause_menu) + 4);
	var box_width		= text_width * 60;
	var box_center_x	= floor(screen_width * 0.5);
	var box_center_y	= floor(screen_height * 0.5);
	
	// UI border
	var box_left_x = box_center_x - floor(box_width * 0.5);
	var box_top_y  = box_center_y - floor(box_height * 0.5);
	var control_string = ui_menu_control_string();
	ui_draw_box(box_left_x, box_top_y, box_width, box_height, "Options", control_string);
	
	
	// Draw menu
	for (var i = 0; i < array_length(pause_menu); i ++){
		var yy = box_top_y + ((i + 2) * text_height);
		var txt = "";
		if (pause_menu_hover == i){
			txt += "> ";
		}
		txt += pause_menu[i];
		draw_text_outlined(txt, xx, yy, text_colour, fa_center);
	}
}


// Generic UI elements ------------------------------------------------------------------
function draw_text_outlined(text, x_pos, y_pos, text_col, h_align = fa_left){
	
	// Set h align
	draw_set_halign(h_align);
	
	// Outline
	draw_text_colour(x_pos+1, y_pos, text, bg_colour, bg_colour, bg_colour, bg_colour, 1);
	draw_text_colour(x_pos, y_pos-1, text, bg_colour, bg_colour, bg_colour, bg_colour, 1);
	draw_text_colour(x_pos-1, y_pos, text, bg_colour, bg_colour, bg_colour, bg_colour, 1);
	draw_text_colour(x_pos, y_pos+1, text, bg_colour, bg_colour, bg_colour, bg_colour, 1);
	
	// Fill text
	draw_text_colour(x_pos, y_pos, text, text_col, text_col, text_col, text_col, 1);
	
	// Reset h align
	draw_set_halign(fa_left);
}

function ui_draw_box(x_pos, y_pos, width, height, title = "", control_keys = ""){
	draw_sprite_stretched_ext(ui_border_spr, 2, x_pos, y_pos, width, height, bg_colour, 1);
	draw_sprite_stretched_ext(ui_border_spr, 1, x_pos, y_pos, width, height, bg_colour, 1);
	draw_sprite_stretched_ext(ui_border_spr, 0, x_pos, y_pos, width, height, c_white, 1);
	
	if (title != ""){
		ui_draw_box_title(x_pos + (text_width * 2), y_pos, title);
	}
	if (control_keys != ""){
		ui_draw_box_controls(x_pos + (text_width * 2), y_pos + height - text_height, control_keys);
	}
}
	
function ui_draw_box_title(x_pos, y_pos, text){
	
	var ww = string_width(text) + (text_width * 2);
	
	draw_rectangle_colour(x_pos, y_pos - 1, x_pos + ww, y_pos + text_height - 1, bg_colour, bg_colour, bg_colour, bg_colour, false);
	draw_text_colour(x_pos + text_width, y_pos, text, text_colour, text_colour, text_colour, text_colour, 1);
}

function ui_draw_box_controls(x_pos, y_pos, text){
	
	var ww = string_width(text) + (text_width * 2);
	
	draw_rectangle_colour(x_pos, y_pos - 1, x_pos + ww, y_pos + text_height - 1, bg_colour, bg_colour, bg_colour, bg_colour, false);
	draw_text_colour(x_pos + text_width, y_pos, text, text_colour, text_colour, text_colour, text_colour, 1);
}


// Specific UI elements -----------------------------------------------------------------
function draw_context_menu(actor, x_pos, y_pos, width, height){
	
	var xx, yy;
	var choices = actor.inventory.context_menu;
	
	// Create controls string
	var key_1 = keybinding_get_text(controls.key_cancel);
	var key_3 = keybinding_get_text(controls.key_interact_confirm);
	var control_list = $"{key_1} to exit / {key_3} to select item";
	
	var box_width = max(width, string_width(control_list));
	box_width += (text_width * 6);
	// Draw box border
	ui_draw_box(x_pos, y_pos, box_width, height);
	
	// Draw box title 
	ui_draw_box_title(x_pos + text_width, y_pos, "Interact");
	
	// Draw context menu choices
	for (var i = 0; i < array_length(choices[0]); i ++){
		xx = x_pos + (text_width * 2);
		yy = y_pos + (text_height * 2) + (text_height * i);
		var text = "";
		if (choices[5] == i){
			text += "> ";
		}
		text += choices[0][i];
		
		draw_text_colour(xx, yy, text, text_colour, text_colour, text_colour, text_colour, 1);
	}
	
	// Draw box controls
	if (show_controls){
		xx = x_pos + (text_width * 2);
		yy = y_pos + height - text_height;
		ui_draw_box_controls(xx, yy, control_list);
	}
}

function draw_inventory(actor, x_pos, y_pos, width, height){
	
	var inv_x = x_pos + floor(width / 2);
	var equ_x = x_pos + floor(width / 4);
	var xx, yy;
	
	// Create controls string
	var key_1 = keybinding_get_text(controls.key_cancel);
	var key_2 = keybinding_get_text(controls.key_inventory);
	var key_3 = keybinding_get_text(controls.key_interact_confirm);
	var control_list = $"{key_1} or {key_2} to exit / {key_3} to select";
	
	// Background
	ui_draw_box(x_pos, y_pos, width, height);
	
	// INVENTORY ----------------------------------------------------------------------------------
	// Title
	ui_draw_box_title(inv_x + text_width, y_pos, "Inventory");
	
	// Items
	var len = array_length(actor.inventory.items);
	if (len > 0){
		for(var i = 0; i < len; i ++){
			
			// Position
			xx = inv_x + (text_width * 2);
			yy = y_pos + (text_height * 2) + (text_height * i);
			
			// Text
			var text = "";
			if (actor.inventory.inv_hover == i and actor.inventory.selected == 1){
				text += "> ";
			}
			text += actor.inventory.items[i].name;
			
			draw_text_colour(xx + text_width, yy, text, text_colour, text_colour, text_colour, text_colour, 1);
		}
	}
	
	// EQUIPMENT ----------------------------------------------------------------------------------
	// Title
	ui_draw_box_title(equ_x + text_width, y_pos, "Equipment");
	var j;
	
	var type = actor.inventory.equ_hover[0];
	var slot = actor.inventory.equ_hover[1];
	yy = y_pos + (text_height * 2);
	xx = equ_x + (text_width * 2);
	
	// Equipment slots
	for (i = 0; i < array_length(actor.inventory.equipment); i ++){
		draw_text_colour(xx, yy, equip_data[i][0], text_colour, text_colour, text_colour, text_colour, 1);
		yy += text_height;
		
		for (j = 0; j < array_length(actor.inventory.equipment[i]); j ++){
			var col = text_colour;
			
			// Text
			var text = "";
			if (type == i and slot == j and actor.inventory.selected == 0){
				text += "> ";
			}
			if (actor.inventory.slot_selection != noone){
				if (actor.inventory.slot_selection[0] == i and actor.inventory.slot_selection[1] == j){
					text += "> ";
				}
			}
			if (!is_struct(actor.inventory.equipment[i][j])){
				if (actor.inventory.equipment[i][j] == -3){
					var prev_slot = j - 1;
					if (prev_slot < 0) prev_slot = array_length(actor.inventory.equipment[i]) - 1;
					text += actor.inventory.equipment[i][prev_slot].name;
					col = c_dkgrey;
				}
				else text += $" - No {equip_data[i][1]} equipped - "
			}
			else text += actor.inventory.equipment[i][j].name;
		
			draw_text_colour(xx + text_width, yy, text, col, col, col, col, 1);
			
			yy += text_height;
		}
		yy += text_height;
	}
	
	// Interaction context menu
	var menu = actor.inventory.context_menu;
	if (menu != noone){
		draw_context_menu(actor, menu[1], menu[2], menu[3], menu[4]);
	}
	
	
	// Draw box controls
	if (show_controls){
		xx = x_pos + (text_width * 2);
		yy = y_pos + height - text_height;
		ui_draw_box_controls(xx, yy, control_list);
	}
}

function draw_minimap(){
	var px, py, mx, my, s, col;
	
	s = minimap_scale;
	if (!surface_exists(minimap_surface)){
		minimap_surface = surface_create(minimap_width, minimap_height);
	}
	
	surface_set_target(minimap_surface);
	draw_clear(bg_colour);
	
	// Mini Map Background
	draw_sprite_stretched_ext(ui_border_spr, 2, 0, 0, minimap_width, minimap_height, bg_colour, 1);

	px = actor_registry.player.x_pos;
	py = actor_registry.player.y_pos;
	
	for (var i = 0; i < grid_width; i ++){
		for (var j = 0; j < grid_height; j ++){
				
			col = bg_colour;
			mx  = (i * s) - (px * s) + (minimap_width / 2);
			my  = (j * s) - (py * s) + (minimap_height / 2);
				
			if(game_grid[i][j].is_visible){
				if (game_grid[i][j].tile != "wall") and (game_grid[i][j].tile != "secret door"){
					col = c_grey;
				}
			}
			else if (game_grid[i][j].explored){
				if (game_grid[i][j].tile != "wall") and (game_grid[i][j].tile != "secret door"){
					col = c_dkgrey;
				}
			}
				
			if (col != bg_colour){
				draw_sprite_ext(pixel_spr, 0, mx, my, s, s, 0, col, 1);
			}
		}
	}
		
	// Draw Player Position
	draw_sprite_ext(pixel_spr, 0, minimap_width / 2, minimap_height / 2, s, s, 0, c_white, 1);
	
	surface_reset_target();
		
	draw_surface(minimap_surface, minimap_x, minimap_y);
		
	// Draw Map Border
	draw_sprite_stretched(ui_border_spr, 0, minimap_x, minimap_y, minimap_width, minimap_height);
	
}

function draw_pickup(actor){
	var xx, yy, ww;
	
	// Get array length
	var len = array_length(actor.pickup_menu);
	
	// Create controls string
	var key_1 = keybinding_get_text(controls.key_cancel);
	var key_2 = keybinding_get_text(controls.key_interact_confirm);
	var control_list = $"{key_1} to exit / {key_2} to pick up item";
	
	// Get menu width
	var width = 0;
	for (var i = 0; i < len; i ++){
		ww = string_width(actor.pickup_menu[i].name);
		if (ww > width){
			width = ww;
		}
	}
	width = max(string_width(control_list), width);
	width += (text_width * 6);
	var x_pos = round(camera_get_view_width(view_camera[0]) / 2) - round(width / 2);
	
	// Get menu height
	var height = (len * text_height) + (text_height * 4);
	var y_pos = round(camera_get_view_height(view_camera[0]) / 2) - round(height / 2);
	
	// Draw box and background
	ui_draw_box(x_pos, y_pos, width, height);
	
	// Title
	ui_draw_box_title(x_pos + text_width, y_pos, "Pick up");
	
	// Draw menu options
	for (var i = 0; i < len; i ++){
		xx = x_pos + (text_width * 2);
		yy = y_pos + (text_height * 2) + (i * text_height);
		
		// Text
		var text = "";
		if (actor.pickup_hover == i){
			text += "> ";
		}
		text += actor.pickup_menu[i].name;
		
		draw_text_colour(xx, yy, text, text_colour, text_colour, text_colour, text_colour, 1);
	}
	
	// Draw box controls
	if (show_controls){
		xx = x_pos + (text_width * 2);
		yy = y_pos + height - text_height;
		ui_draw_box_controls(xx, yy, control_list);
	}
}




