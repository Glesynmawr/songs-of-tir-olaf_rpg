
// GAME DRAWING -----------------------------------------------------------------------------------
function game_draw_grid(){
	
	// Get grid size
	var ww = array_length(game_grid);
	var hh = array_length(game_grid[0]);
	
	// Get drawing position variables
	var player_x			= actor_registry.player.x_pos;
	var player_y			= actor_registry.player.y_pos;
	var draw_width_half		= ceil(MAP_WIDTH  / 2);
	var draw_height_half	= ceil(MAP_HEIGHT / 2);
	var player_spr_x		= actor_registry.player.sprite_x;
	var player_spr_y		= actor_registry.player.sprite_y;
	
	// Get grid drawing position
	if (!map_borders_are_clamped){
		var x_from = player_x - draw_width_half;
		var y_from = player_y - draw_height_half;
	}
	else {
		var x_from = max(min(player_x - draw_width_half, ww - (MAP_WIDTH)), 0);
		var y_from = max(min(player_y - draw_height_half, hh - (MAP_HEIGHT)), 0);
	}
	
	var x_to = x_from + MAP_WIDTH;
	var y_to = y_from + MAP_HEIGHT;
	
	// Set map offset using player sprite position, checking for edges
	var map_offset_x = actor_registry.player.sprite_target_x - actor_registry.player.sprite_x;
	var map_offset_y = actor_registry.player.sprite_target_y - actor_registry.player.sprite_y;
	
	if ((player_spr_x <= draw_width_half * cell_width)   or (player_spr_x >= (ww - draw_width_half) * cell_width)) and (map_borders_are_clamped){
		map_offset_x = 0;
	}
	if ((player_spr_y <= draw_height_half * cell_height) or (player_spr_y >= (hh - draw_height_half) * cell_height)) and (map_borders_are_clamped){
		map_offset_y = 0;
	}
	
	for (var xx = x_from; xx < x_to; xx ++){
		for (var yy = y_from; yy < y_to; yy ++){
			
			if (grid_check_position_in_bounds(game_grid, xx, yy)){
				if (game_grid[xx][yy].explored or debugging_mode){
				
					// Set screen pixel position
					var screen_x = (((xx - x_from) * cell_width)  + map_offset_x + ui_x_pos[ui_position][1]);
					var screen_y = (((yy - y_from) * cell_height) + map_offset_y);
				
					// Draw tile
					game_draw_tile(xx, yy, screen_x, screen_y);
				
					// Draw items
					game_draw_items(xx, yy, screen_x, screen_y);
				}
			}
		}
	}
	for (xx = x_from; xx < x_to; xx ++){
		for (yy = y_from; yy < y_to; yy ++){

			// Set screen pixel position
			var screen_x = (((xx - x_from) * cell_width)  + map_offset_x + ui_x_pos[ui_position][1]);
			var screen_y = (((yy - y_from) * cell_height) + map_offset_y);
				
			game_draw_actor(xx, yy, screen_x, screen_y);
		}
	}
	screen_x = (x_from * cell_width)  + map_offset_x;
	screen_y = (y_from * cell_height) + map_offset_y;
	draw_dust_particles(screen_x, screen_y);
	
	// Draw move direction indicator
	if (direction_indicator != noone){
		draw_sprite_ext(direction_arrow_spr, direction_indicator, direction_indicator_x, direction_indicator_y, 1, 1, 0, c_white, 1);
	}
}

function game_draw_actor(xx, yy, screen_x, screen_y){
	
	// Check for actor on tile
	for (var i = 0; i < array_length(actor_registry.actor_list); i ++){
					
		// Actor cell position
		var actor_x = actor_registry.actor_list[i].x_pos;
		var actor_y = actor_registry.actor_list[i].y_pos;
					
		// If actor is in current cell
		if (actor_x == xx and actor_y == yy){
			if (actor_registry.actor_list[i].is_visible or debugging_mode){
							
				// Get actor variables
				with (actor_registry.actor_list[i]){
					var spr = sprite;
								
					flash_timer_reduce();
								
					// ACTOR UPDATE SPRITE POSITION -----------------------------------------------------------
					melee_offset_x *= 0.6;
					melee_offset_y *= 0.6;
					
					var spr_offset_x = sprite_x - sprite_target_x;
					var spr_offset_y = sprite_y - sprite_target_y;
					var melee_x      = melee_offset_x;
					var melee_y      = melee_offset_y;
					var x_scale		 = xscale;
								
					// ACTOR ANIMATION ------------------------------------------------------------------------
					var ind = actor_animate();
								
					var col = colour_fg;
				}
							
				// Set sprite overlay shader
				if (col != noone){
								
					var r = colour_get_red(col)   / 255;
					var g = colour_get_green(col) / 255;
					var b = colour_get_blue(col)  / 255;
								
					col = [r, g, b, 1.0];
								
					shader_set(colour_overlay_shd);
					shader_set_uniform_f_array(uni_overlay, col);
				}
				else{
					var tex		= sprite_get_texture(spr, ind);
					var texel_w = texture_get_texel_width(tex);
					var texel_h = texture_get_texel_height(tex);
								
					shader_set(outline_shd);
					shader_set_uniform_f(uni_texel_size, texel_w, texel_h);
					shader_set_uniform_f(uni_outline_col, outline_colour[0], outline_colour[1], outline_colour[2], outline_colour[3]);
				}
							
				// Draw actor sprite and reset shader
				draw_sprite_ext(spr, ind, screen_x + spr_offset_x + melee_x + (cell_width / 2), screen_y + spr_offset_y + melee_y, x_scale, 1, 0, c_white, 1);
				shader_reset();
				
				// If actor is player, set direction indicator position and direction
				if (actor_registry.actor_list[i] == actor_registry.player and direction_indicator != noone){
					var dir_ind_x = screen_x + cell_width  / 2;
					var dir_ind_y = screen_y + cell_height / 2;
								
					direction_indicator_x = dir_ind_x + lengthdir_x(cell_width / 2,  direction_indicator * 45);
					direction_indicator_y = dir_ind_y + lengthdir_y(cell_height / 2, direction_indicator * 45);
				}
			}
		}
	}	
}

function game_draw_items(xx, yy, screen_x, screen_y){
	if (struct_exists(game_grid[xx][yy], "items")){
		if (array_length(game_grid[xx][yy].items) > 0){

			
			var item_sprite = game_grid[xx][yy].items[0].sprite_index;
			var item_index  = game_grid[xx][yy].items[0].image_index;
			var sheet_x = (item_index mod 8) * ITEM_SPRITE_SIZE;
			var sheet_y = (item_index div 8) * ITEM_SPRITE_SIZE;
			
			var draw_x = screen_x + ((cell_width  - ITEM_SPRITE_SIZE) / 2);
			var draw_y = screen_y + ((cell_height - ITEM_SPRITE_SIZE) / 2);
			
			draw_sprite_part(item_sprite, item_index, sheet_x, sheet_y, ITEM_SPRITE_SIZE, ITEM_SPRITE_SIZE, draw_x, draw_y);
		}
	}
}

function game_draw_tile(xx, yy, screen_x, screen_y){
	
	var spr = game_grid[xx][yy].sprite;
	var ind = game_grid[xx][yy].index;
				
	var col = noone;
	var bg = game_grid[xx][yy].colour_bg;
	
	var dng = noone;
	if (struct_exists(game_grid[xx][yy], "dungeon")){
		var dng = game_grid[xx][yy].dungeon;
	}
	
	// Set sprite overlay shader
	if (!game_grid[xx][yy].is_visible and game_grid[xx][yy].explored) and (!debugging_mode){
		col = C_BLUE;
	}
	if (col != noone){
								
		var r = colour_get_red(col)   / 255;
		var g = colour_get_green(col) / 255;
		var b = colour_get_blue(col)  / 255;
								
		col = [r, g, b, 1.0];
								
		shader_set(colour_overlay_shd);
		shader_set_uniform_f_array(uni_overlay, col);
	}
	else{
		var tex		= sprite_get_texture(spr, ind);
		var texel_w = texture_get_texel_width(tex);
		var texel_h = texture_get_texel_height(tex);
								
		shader_set(outline_shd);
		shader_set_uniform_f(uni_texel_size, texel_w, texel_h);
		shader_set_uniform_f(uni_outline_col, outline_colour[0], outline_colour[1], outline_colour[2], outline_colour[3]);
	}
					
	// Draw background rectangle
	if (bg != noone){
		draw_rectangle_colour(screen_x, screen_y, screen_x + cell_width, screen_y + cell_height, bg, bg, bg, bg, false);
	}
					
	// Get tile spritesheet position
	var tile_x = ind mod 8;
	var tile_y = ind div 8;
			
	draw_sprite_part_ext(spr, ind, tile_x*cell_width, tile_y*cell_height, cell_width, cell_height, screen_x, screen_y, 1, 1, C_WHITE, 1);
	
	if (dng != noone){
		draw_sprite(tile_world_dungeon_entrance_spr, 0, screen_x, screen_y);
	}
	
	shader_reset();
}


// UI DRAWING -------------------------------------------------------------------------------------
function draw_game_ui(){
	var ww = screen_width;
	var hh = screen_height;
	var xx = 0;
	var yy = 0;
	
	// Game log
	draw_game_log(0, hh - log_height, ww, log_height);

	// Info box
	draw_info_box();

	// Minimap
	draw_minimap();
	
	// Inventory and pick-up menus
	if (actor_registry.player.state == state_inventory or actor_registry.player.state == state_context_menu or actor_registry.player.state == state_slot_selection){
		draw_inventory(actor_registry.player, xx, yy, ww, hh);
	}
	if (actor_registry.player.state == state_pickup){
		draw_pickup(actor_registry.player);
	}
}

function draw_control_menu(){
	
	var control_text;
	control_text[0] = "Up";
	control_text[1] = "Down";
	control_text[2] = "Left";
	control_text[3] = "Right";
	control_text[4] = "Move";
	control_text[5] = "Select/Interact";
	control_text[6] = "Inventory";
	control_text[7] = "Map";
	control_text[8] = "Swap items";
	
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
		draw_text_outlined(control_text[i], box_center_x - text_width, control_y, colour_text_main, fa_right);
		
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
		draw_text_outlined(control_key, box_center_x + text_width, control_y, colour_text_main, fa_left);
	}
	
	// Draw menu
	for (i = 0; i < array_length(control_menu); i ++){
		var yy = menu_y + ((i + 2) * text_height);
		var txt = "";
		var x_mod = 0;
		if (control_menu_hover == i){
			txt += "> ";
			if (ui_flip){
				txt += " ";
				x_mod = (text_width / 2);
			}
		}
		txt += control_menu[i];
		draw_text_outlined(txt, box_center_x - x_mod, yy, colour_text_main, fa_center);
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
	title_y = floor(screen_height / 3);
	//draw_sprite(title_spr, 0, box_center_x, title_y);
	
	particle_create_title_fire(part_title_fire, floor(screen_width * 0.5) - 120, title_y)
	particle_create_title_fire(part_title_fire, floor(screen_width * 0.5) + 120, title_y)
	
	draw_sprite(gamemaker_logo_small_spr, 0, 4, screen_height - 4);
	draw_sprite(glesynmawr_logo_small_spr, 0, screen_width - 4, screen_height - 4);
	
	part_system_drawit(particle_system);
	
	draw_sprite(brazier_spr, 1, floor(screen_width * 0.5) - 120, title_y);
	draw_sprite(brazier_spr, 1, floor(screen_width * 0.5) + 120, title_y);
	
	// UI border
	var box_left_x = box_center_x - floor(box_width / 2);
	var box_top_y  = box_center_y - floor(box_height / 2);
	var control_string = ui_menu_control_string();
	ui_draw_box(box_left_x, box_top_y, box_width, box_height, , control_string);
	
	// Draw menu
	for (var i = 0; i < array_length(main_menu); i ++){
		var yy = box_top_y + ((i + 2) * text_height);
		var txt = "";
		var x_mod = 0;
		if (main_menu_hover == i){
			txt += "> ";
			if (ui_flip){
				txt += " ";
				x_mod = (text_width / 2);
			}
		}
		txt += main_menu[i];
		draw_text_outlined(txt, xx - x_mod, yy, colour_text_main, fa_center);
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
		var x_mod = 0;
		if (pause_menu_hover == i){
			txt += "> ";
			if (ui_flip){
				txt += " ";
				x_mod = (text_width / 2);
			}
		}
		txt += pause_menu[i];
		draw_text_outlined(txt, xx - x_mod, yy, colour_text_main, fa_center);
	}
}


// Generic UI elements ------------------------------------------------------------------
function draw_text_outlined(text, x_pos, y_pos, text_col, h_align = fa_left){
	
	// Set colours
	var bg = colour_bg_main;
	var tc = text_col;
	
	// Set h align
	draw_set_halign(h_align);
	
	// Outline
	draw_text_colour(x_pos+1, y_pos, text, bg, bg, bg, bg, 1);
	draw_text_colour(x_pos, y_pos-1, text, bg, bg, bg, bg, 1);
	draw_text_colour(x_pos-1, y_pos, text, bg, bg, bg, bg, 1);
	draw_text_colour(x_pos, y_pos+1, text, bg, bg, bg, bg, 1);
	
	// Fill text
	draw_text_colour(x_pos, y_pos, text, tc, tc, tc, tc, 1);
	
	// Reset h align
	draw_set_halign(fa_left);
}

function ui_draw_box(x_pos, y_pos, width, height, title = "", control_keys = ""){
	
	// Set colours
	var bg = colour_bg_main;
	var uc = colour_ui_main;
	
	draw_sprite_stretched_ext(ui_border_spr, 2, x_pos, y_pos, width, height, bg, 1);
	draw_sprite_stretched_ext(ui_border_spr, 1, x_pos, y_pos, width, height, bg, 1);
	draw_sprite_stretched_ext(ui_border_spr, 0, x_pos, y_pos, width, height, uc, 1);
	
	if (title != ""){
		ui_draw_box_title(x_pos + (text_width * 2), y_pos, title);
	}
	if (control_keys != ""){
		ui_draw_box_controls(x_pos + (text_width * 2), y_pos + height - text_height + 2, control_keys);
	}
}
	
function ui_draw_box_title(x_pos, y_pos, text){
	
	var ww = string_width(text) + (text_width * 2);
	
	var bg = colour_bg_main;
	var fg = colour_text_main;
	
	draw_rectangle_colour(x_pos, y_pos - 1, x_pos + ww, y_pos + text_height - 1, bg, bg, bg, bg, false);
	draw_text_colour(x_pos + text_width, y_pos, text, fg, fg, fg, fg, 1);
}

function ui_draw_box_controls(x_pos, y_pos, text){
	
	var bg = colour_bg_main;
	var tc = colour_text_main;
	
	var ww = string_width(text) + (text_width * 2);
	
	draw_rectangle_colour(x_pos, y_pos - 1, x_pos + ww, y_pos + text_height - 1, bg, bg, bg, bg, false);
	draw_text_colour(x_pos + text_width, y_pos, text, tc, tc, tc, tc, 1);
}


// Specific UI elements -----------------------------------------------------------------
function ui_anim_flip(){
	ui_flip_timer --;
	if (ui_flip_timer <= 0){
		ui_flip_timer = ui_flip_timer_max;
		ui_flip = !ui_flip;
	}
}

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
		
		draw_text_colour(xx, yy, text, colour_text_main, colour_text_main, colour_text_main, colour_text_main, 1);
	}
	
	// Draw box controls
	if (show_controls){
		xx = x_pos + (text_width * 2);
		yy = y_pos + height - text_height;
		ui_draw_box_controls(xx, yy, control_list);
	}
}

function draw_context_slot_select_menu(actor, x_pos, y_pos, width, height){
	
	var xx, yy;
	var menu_list = actor.inventory.slot_select_menu;
	
	// Create controls string
	var key_1 = keybinding_get_text(controls.key_cancel);
	var key_3 = keybinding_get_text(controls.key_interact_confirm);
	var control_list = $"{key_1} to exit / {key_3} to select item";
	
	var box_width = max(width, string_width(control_list));
	box_width += (text_width * 6);
	
	// Draw box border
	ui_draw_box(x_pos, y_pos, box_width, height);
	
	// Draw box title 
	ui_draw_box_title(x_pos + text_width, y_pos, "Select Slot");
	
	// Draw context menu choices
	for (var i = 0; i < array_length(menu_list[0]); i ++){
		xx = x_pos + (text_width * 2);
		yy = y_pos + (text_height * 2) + (text_height * i);
		var text = "";
		if (menu_list[5] == i){
			text += "> ";
		}
		text += menu_list[0][i][0];
		
		draw_text_colour(xx, yy, text, colour_text_main, colour_text_main, colour_text_main, colour_text_main, 1);
	}
	
	// Draw box controls
	if (show_controls){
		xx = x_pos + (text_width * 2);
		yy = y_pos + height - text_height;
		ui_draw_box_controls(xx, yy, control_list);
	}
}

function draw_game_log(x_pos, y_pos, width, height){
	
	ui_draw_box(x_pos, y_pos, width, height);
	
	var xx = x_pos + (text_width * 2);
	var yy = y_pos + text_height;
	
	var draw_to = min(LOG_MAX_ENTRIES, array_length(game_log));
	for (var line = 0; line < draw_to; line ++){
		
		var text =		game_log[line][0];
		var colour =	game_log[line][1];
		
		draw_text_colour(xx, yy + (line * text_height), text, colour, colour, colour, colour, 1);
	}
}

function draw_info_box(){
	
	// Background and border
	var xx = ui_x_pos[ui_position][0];
	var yy = infobox_y;
	ui_draw_box(xx, yy, infobox_width, infobox_height);
	
	// Player hit points
	xx += text_width * 2;
	yy += text_height;
	draw_text(xx, yy, $"HP: {actor_registry.player.hit_points}");
	
	yy += text_height;
	draw_text(xx, yy, $"Turn: {current_turn}"); 
	
	yy += text_height;
	draw_text(xx, yy, $"Hour: {game_current_time[TIME.HOUR]}"); 
	
	yy += text_height;
	draw_text(xx, yy, $"Day:  {game_current_time[TIME.DAY]}"); 
}

function draw_inventory(actor, x_pos, y_pos, width, height){
	
	var tc = colour_text_main;
	
	var inv_x = x_pos + floor(width / 2);
	var equ_x = x_pos + floor(width / 4);
	var xx, yy;
	
	// Create controls string
	var key_1 = keybinding_get_text(controls.key_cancel);
	var key_2 = keybinding_get_text(controls.key_inventory);
	var key_3 = keybinding_get_text(controls.key_interact_confirm);
	var control_list = $"{key_1} to exit / {key_2} to toggle / {key_3} to select";
	
	// Background
	ui_draw_box(x_pos, y_pos, width, height, , control_list);
	
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
			
			draw_text_colour(xx + text_width, yy, text, tc, tc, tc, tc, 1);
		}
	}
	
	// EQUIPMENT ----------------------------------------------------------------------------------
	// Title
	ui_draw_box_title(equ_x + text_width, y_pos, "Equipment");
	
	var box_size = equipment_box_sprite_size;
	
	// Worn Equipment
	xx = equ_x + (text_width * 2);
	yy = y_pos + (text_height * 2);
	for (var cat = 0; cat < array_length(actor.body_plan); cat ++){
		for (var ind = 0; ind < array_length(actor.body_plan[cat]); ind ++){
			if (body_part_is_present(actor, cat, ind)){
				
				var from = array_length(actor.body_plan[cat][ind]) - 1;
				var to   = BODY_PART_STATS.PART_AUX_SLOT;
				
				for (var slot = from; slot >= to; slot --){
					
					if (slot < BODY_PART_STATS.PART_SLOT_1){
						if (!body_part_has_hand(actor, cat, ind)){
							continue;
						}
					}
					
					var col = C_LTGREY;
					if (slot == BODY_PART_STATS.PART_HAND_SLOT) col = C_RED;
					if (slot == BODY_PART_STATS.PART_AUX_SLOT)  col = C_PURPLE;
					
					if (actor.inventory.equ_hover[0] == cat and actor.inventory.equ_hover[1] == ind and actor.inventory.equ_hover[2] == slot){
						col = C_WHITE;
						
						equipment_hovered_x_pos = xx;
						equipment_hovered_y_pos = yy;
					}
					
					// Draw equipment box
					draw_sprite_ext(equipment_box_spr, 0, xx, yy, 1, 1, 0, col, 1);
					
					// Draw equipment sprite
					if (is_struct(actor.body_plan[cat][ind][slot])){
						
						var slot_item = actor.body_plan[cat][ind][slot];

						var item_sprite = slot_item.sprite_index;
						var item_index  = slot_item.image_index;
						var sheet_x = (item_index mod 8) * ITEM_SPRITE_SIZE;
						var sheet_y = (item_index div 8) * ITEM_SPRITE_SIZE;
						
						draw_sprite_part(item_sprite, 0, sheet_x, sheet_y, ITEM_SPRITE_SIZE, ITEM_SPRITE_SIZE, xx + 3, yy + 3);
					}
					
					// Increment box X position
					xx += box_size;
				}
				
				var col = colour_text_main;
				draw_text_colour(xx, yy, actor.body_plan[cat][ind][BODY_PART_STATS.PART_NAME], col, col, col, col, 1);
				
				xx = equ_x + (text_width * 2);
				yy += box_size;
			}
		}
	}
	
	// Interaction context menu
	var menu_cont = actor.inventory.context_menu;
	var menu_equi = actor.inventory.slot_select_menu;
	if (menu_cont != noone and menu_equi == noone){
		draw_context_menu(actor, menu_cont[1], menu_cont[2], menu_cont[3], menu_cont[4]);
	}
	
	// Equipment slot context menu
	if (menu_equi != noone){
		draw_context_slot_select_menu(actor, menu_equi[1], menu_equi[2], menu_equi[3], menu_equi[4]);
	}
}

function draw_minimap(){
	var px, py, mx, my, s, col;
	
	var bg = colour_bg_main;
	
	var grid_w = array_length(game_grid);
	var grid_h = array_length(game_grid[0]);
	
	s = minimap_scale;
	if (!surface_exists(minimap_surface)){
		minimap_surface = surface_create(minimap_width, minimap_height - 2);
	}
	
	surface_set_target(minimap_surface);
	draw_clear(bg);
	
	// Mini Map Background
	draw_sprite_stretched_ext(ui_border_spr, 2, 0, 0, minimap_width, minimap_height, bg, 1);

	px = actor_registry.player.x_pos;
	py = actor_registry.player.y_pos;
	
	for (var i = 0; i < grid_w; i ++){
		for (var j = 0; j < grid_h; j ++){
				
			col = colour_bg_main;
			mx  = (i * s) - (px * s) + (minimap_width  / 2);
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
				
			if (col != bg){
				draw_sprite_ext(pixel_spr, 0, mx, my, s, s, 0, col, 1);
			}
		}
	}
		
	// Draw Player Position
	draw_sprite_ext(pixel_spr, 0, minimap_width / 2, minimap_height / 2, s, s, 0, c_white, 1);
	
	surface_reset_target();
		
	draw_surface(minimap_surface, ui_x_pos[ui_position][0], minimap_y);
		
	// Draw Map Border
	draw_sprite_stretched_ext(ui_border_spr, 1, ui_x_pos[ui_position][0], minimap_y, minimap_width, minimap_height, bg, 1);
	draw_sprite_stretched_ext(ui_border_spr, 0, ui_x_pos[ui_position][0], minimap_y, minimap_width, minimap_height, C_ORANGE,  1);
	
	// Draw box text
	if (minimap_title_text != ""){
		ui_draw_box_title(ui_x_pos[ui_position][0] + (text_width * 2), minimap_y, minimap_title_text);
	}
	if (minimap_sub_text != ""){
		ui_draw_box_controls(ui_x_pos[ui_position][0] + (text_width * 2), minimap_height - 5, minimap_sub_text);
	}
}

function draw_pickup(actor){
	var xx, yy, ww;
	
	var tc = colour_text_main;
	
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
		
		draw_text_colour(xx, yy, text, tc, tc, tc, tc, 1);
	}
	
	// Draw box controls
	if (show_controls){
		xx = x_pos + (text_width * 2);
		yy = y_pos + height - text_height;
		ui_draw_box_controls(xx, yy, control_list);
	}
}




