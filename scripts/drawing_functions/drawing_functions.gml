
// GAME DRAWING -----------------------------------------------------------------------------------
function game_draw_character_select(){
	
}

function game_draw_grid(){
	var ww = array_length(game_grid);
	var hh = array_length(game_grid[0]);
	
	var player_x			= actor_registry.player.x_pos;
	var player_y			= actor_registry.player.y_pos;
	var draw_width_half		= ceil(cells_draw_width  / 2);
	var draw_height_half	= ceil(cells_draw_height / 2);
	var player_spr_x		= actor_registry.player.sprite_x;
	var player_spr_y		= actor_registry.player.sprite_y;
	
	// Get grid drawing position
	var x_from = max(min(player_x - draw_width_half,  ww - (cells_draw_width)),  0);
	var y_from = max(min(player_y - draw_height_half, hh - (cells_draw_height)), 0);
	var x_to   = min(x_from + cells_draw_width,  ww)
	var y_to   = min(y_from + cells_draw_height, hh);
	
	// Set map offset
	var map_offset_x = actor_registry.player.sprite_target_x - actor_registry.player.sprite_x;
	var map_offset_y = actor_registry.player.sprite_target_y - actor_registry.player.sprite_y;
	if (player_spr_x <= draw_width_half * cell_width)   or (player_spr_x >= (ww - draw_width_half) * cell_width){
		map_offset_x = 0;
	}
	if (player_spr_y < draw_height_half * cell_height) or (player_spr_y > (hh - draw_height_half) * cell_height){
		map_offset_y = 0;
	}
	
	for (var xx = x_from; xx < x_to; xx ++){
		for (var yy = y_from; yy < y_to; yy ++){
			if (game_grid[xx][yy].explored or debugging_mode){
				
				var screen_x = (xx - x_from) * cell_width  + map_offset_x;
				var screen_y = (yy - y_from) * cell_height + map_offset_y;
				
				var draw_actor = false;
				var draw_item  = false;
				
				// Check for actor on tile
				for (var i = 0; i < array_length(actor_registry.actor_list); i ++){
					
					// Actor cell position
					var actor_x = actor_registry.actor_list[i].x_pos;
					var actor_y = actor_registry.actor_list[i].y_pos;
					
					if (actor_x == xx and actor_y == yy){
						if (actor_registry.actor_list[i].is_visible){
							// Draw actor sprite
							with (actor_registry.actor_list[i]){
								var spr = sprite;
								
								// ACTOR UPDATE SPRITE POSITION -----------------------------------------------------------
								var spr_offset_x = sprite_x - sprite_target_x;
								var spr_offset_y = sprite_y - sprite_target_y;
								
								// ACTOR ANIMATION ------------------------------------------------------------------------
								ind = actor_animate();
								
								var col = colour_fg;
							}
							if (col != noone){
								
								var r = colour_get_red(col)   / 255;
								var g = colour_get_green(col) / 255;
								var b = colour_get_blue(col)  / 255;
								
								col = [r, g, b, 1.0];
								
								shader_set(colour_overlay_shd);
								shader_set_uniform_f_array(uni_overlay, col);
							}
							
							draw_sprite(spr, ind, screen_x + spr_offset_x, screen_y + spr_offset_y)
							
							shader_reset();
							
							draw_actor = true;
							
							if (actor_registry.actor_list[i] == actor_registry.player and direction_indicator != noone){
								var dir_ind_x = screen_x + cell_width  / 2;
								var dir_ind_y = screen_y + cell_height / 2;
								
								direction_indicator_x = dir_ind_x + lengthdir_x(cell_width / 2,  direction_indicator * 45);
								direction_indicator_y = dir_ind_y + lengthdir_y(cell_height / 2, direction_indicator * 45);
							}
						}
					}
				}
				
				// Check for items on tile
				if (!draw_actor){
					if (struct_exists(game_grid[xx][yy], "items")){
						if (array_length(game_grid[xx][yy].items) > 0){
							draw_sprite(item_spr, 0, screen_x, screen_y);
							draw_item = true;
						}
					}
				}
				
				// Draw tile
				if (!draw_actor and !draw_item){
					var spr = game_grid[xx][yy].sprite;
					var ind = game_grid[xx][yy].index;
				
					var fg = game_grid[xx][yy].colour_fg;
					var bg = game_grid[xx][yy].colour_bg;
			
					if (!game_grid[xx][yy].is_visible and !debugging_mode){
						fg = C_BLUE;
					}
					
					// Set foreground draw colour
					var draw_col_fg = c_white;
					if (fg != noone) draw_col_fg = fg;
					
					// Draw background rectangle
					if (bg != noone){
						draw_rectangle_colour(screen_x, screen_y, screen_x + cell_width, screen_y + cell_height, bg, bg, bg, bg, false);
					}
					
					// Get tile spritesheet position
					var tile_x = ind mod 8;
					var tile_y = ind div 8;
			
					draw_sprite_part_ext(spr, ind, tile_x*cell_width, tile_y*cell_height, cell_width, cell_height, screen_x, screen_y, 1, 1, draw_col_fg, 1);
				}
			}
		}
	}
	
	// Draw move direction indicator
	if (direction_indicator != noone){
		draw_sprite_ext(direction_arrow_spr, direction_indicator, direction_indicator_x, direction_indicator_y, 1, 1, 0, c_white, 1);
	}
	
	// Game window border
	//draw_sprite_stretched_ext(game_window_border_spr, 1, ui_width, 0, gamemap_width, gamemap_height, colour_bg_main, 1);
	//draw_sprite_stretched_ext(game_window_border_spr, 0, ui_width, 0, gamemap_width, gamemap_height, C_ORANGE,  1);
}


// UI DRAWING -------------------------------------------------------------------------------------
function draw_game_ui(){
	var ww = screen_width;
	var hh = screen_height;
	var xx = 0;
	var yy = 0;
	
	// Player hit points
	draw_text(text_width, text_height, $"HP: {actor_registry.player.hit_points}");
	
	// Game log
	draw_game_log(0, hh - log_height, ww, log_height);

	// Inventory and pick-up menus
	if (actor_registry.player.state == state_inventory or actor_registry.player.state == state_context_menu or actor_registry.player.state == state_slot_selection){
		draw_inventory(actor_registry.player, xx, yy, ww, hh);
	}
	if (actor_registry.player.state == state_pickup){
		draw_pickup(actor_registry.player);
	}
	
	// Minimap
	draw_minimap();
	
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
		var yy = menu_y + (i * text_height);
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
	draw_sprite(title_spr, 0, box_center_x, title_y);
	
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

function draw_inventory(actor, x_pos, y_pos, width, height){
	
	var tc = colour_text_main;
	
	var inv_x = x_pos + floor(width / 2);
	var equ_x = x_pos + floor(width / 4);
	var xx, yy;
	
	// Create controls string
	var key_1 = keybinding_get_text(controls.key_cancel);
	var key_2 = keybinding_get_text(controls.key_inventory);
	var key_3 = keybinding_get_text(controls.key_interact_confirm);
	var control_list = $"{key_1} or {key_2} to exit / {key_3} to select";
	
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
	var j;
	
	var type = actor.inventory.equ_hover[0];
	var slot = actor.inventory.equ_hover[1];
	yy = y_pos + (text_height * 2);
	xx = equ_x + (text_width * 2);
	
	// Equipment slots
	for (i = 0; i < array_length(actor.inventory.equipment); i ++){
		draw_text_colour(xx, yy, equip_data[i][0], tc, tc, tc, tc, 1);
		yy += text_height;
		
		for (j = 0; j < array_length(actor.inventory.equipment[i]); j ++){
			var col = tc;
			
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
		
	draw_surface(minimap_surface, minimap_x, minimap_y);
		
	// Draw Map Border
	draw_sprite_stretched_ext(ui_border_spr, 1, minimap_x, minimap_y, minimap_width, minimap_height, bg, 1);
	draw_sprite_stretched_ext(ui_border_spr, 0, minimap_x, minimap_y, minimap_width, minimap_height, C_ORANGE,  1);
	
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




