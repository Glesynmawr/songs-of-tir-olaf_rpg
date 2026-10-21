
// GAME DRAWING -----------------------------------------------------------------------------------
function game_draw_grid(){
	
	// Get grid size
	var ww = array_length(game_state.game_grid);
	var hh = array_length(game_state.game_grid[0]);
	
	// Get drawing position variables
	var player_x			= actor_registry.player.x_pos;
	var player_y			= actor_registry.player.y_pos;
	var draw_width_half		= ceil(ui_settings.game_grid_cells_width  / 2);
	var draw_height_half	= ceil(ui_settings.game_grid_cells_height / 2);
	var player_spr_x		= actor_registry.player.sprite_x;
	var player_spr_y		= actor_registry.player.sprite_y;
	
	// Get grid drawing position
	if (!game_state.map_borders_are_clamped){
		var x_from = player_x - draw_width_half;
		var y_from = player_y - draw_height_half;
	}
	else {
		var x_from = max(min(player_x - draw_width_half, ww - (ui_settings.game_grid_cells_width)), 0);
		var y_from = max(min(player_y - draw_height_half, hh - (ui_settings.game_grid_cells_height)), 0);
	}
	
	var x_to = x_from + ui_settings.game_grid_cells_width;
	var y_to = y_from + ui_settings.game_grid_cells_height;
	
	// Set map offset using player sprite position, checking for edges
	var map_offset_x = actor_registry.player.sprite_target_x - actor_registry.player.sprite_x;
	var map_offset_y = actor_registry.player.sprite_target_y - actor_registry.player.sprite_y;
	
	if ((player_spr_x <= draw_width_half * cell_width)   or (player_spr_x >= (ww - draw_width_half) * cell_width)) and (game_state.map_borders_are_clamped){
		map_offset_x = 0;
	}
	if ((player_spr_y <= draw_height_half * cell_height) or (player_spr_y >= (hh - draw_height_half) * cell_height)) and (game_state.map_borders_are_clamped){
		map_offset_y = 0;
	}
	
	for (var xx = x_from; xx < x_to; xx ++){
		for (var yy = y_from; yy < y_to; yy ++){
			
			if (grid_check_position_in_bounds(game_state.game_grid, xx, yy)){
				if (game_state.game_grid[xx][yy].explored or debugging_mode){
				
					// Set screen pixel position
					var screen_x = floor((((xx - x_from) * cell_width)  + map_offset_x + ui_x_pos[ui_settings.ui_x_position][1]));
					var screen_y = floor((((yy - y_from) * cell_height) + map_offset_y));
					
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
			var screen_x = (((xx - x_from) * cell_width)  + map_offset_x + ui_x_pos[ui_settings.ui_x_position][1]);
			var screen_y = (((yy - y_from) * cell_height) + map_offset_y);
				
			game_draw_actor(xx, yy, screen_x, screen_y);
			
		}
	}
	
	screen_x = (x_from * cell_width)  - map_offset_x;
	screen_y = (y_from * cell_height) - map_offset_y;
	draw_particles(screen_x, screen_y);
	
	draw_look_cursor(screen_x + 3, screen_y + 3);
	
	// Draw move direction indicator
	if (game_state.direction_indicator != noone){
		draw_sprite_ext(direction_arrow_spr, game_state.direction_indicator, game_state.direction_indicator_x, game_state.direction_indicator_y, 1, 1, 0, c_white, 1);
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
					var z_modifier	 = passive_move_bounce(self) * manager.ui_settings.move_bounce_amplitude;
							
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
				draw_sprite_ext(spr, ind, screen_x + spr_offset_x + melee_x + (cell_width / 2), screen_y + spr_offset_y + melee_y - z_modifier, x_scale, 1, 0, c_white, 1);
				shader_reset();
				
				// If actor is player, set direction indicator position and direction
				if (actor_registry.actor_list[i] == actor_registry.player and game_state.direction_indicator != noone){
					var dir_ind_x = screen_x + cell_width  / 2;
					var dir_ind_y = screen_y + cell_height / 2;
								
					game_state.direction_indicator_x = dir_ind_x + lengthdir_x(cell_width / 2,  game_state.direction_indicator * 45);
					game_state.direction_indicator_y = dir_ind_y + lengthdir_y(cell_height / 2, game_state.direction_indicator * 45);
				}
			}
		}
	}	
}

function game_draw_items(xx, yy, screen_x, screen_y){
	if (struct_exists(game_state.game_grid[xx][yy], "items")){
		if (array_length(game_state.game_grid[xx][yy].items) > 0){
			
			var item_sprite = game_state.game_grid[xx][yy].items[0].sprite_index;
			var item_index  = game_state.game_grid[xx][yy].items[0].image_index;
			var sheet_x = (item_index mod 8) * ITEM_SPRITE_SIZE;
			var sheet_y = (item_index div 8) * ITEM_SPRITE_SIZE;
			
			var x_offset = floor((cell_width  - ITEM_SPRITE_SIZE) / 2);
			var y_offset = floor((cell_height - ITEM_SPRITE_SIZE) / 2);
			
			var draw_x = screen_x + ((cell_width  - ITEM_SPRITE_SIZE) / 2) + x_offset;
			var draw_y = screen_y + ((cell_height - ITEM_SPRITE_SIZE) / 2) + y_offset;
			
			draw_sprite_part(item_sprite, 0, sheet_x, sheet_y, ITEM_SPRITE_SIZE, ITEM_SPRITE_SIZE, draw_x, draw_y);
		}
	}
}

function game_draw_tile(xx, yy, screen_x, screen_y){
	
	var spr = game_state.game_grid[xx][yy].sprite;
	var ind = game_state.game_grid[xx][yy].index;
				
	var col = noone;
	
	var dng = noone;
	if (struct_exists(game_state.game_grid[xx][yy], "dungeon")){
		var dng = game_state.game_grid[xx][yy].dungeon;
	}
	
	// Set sprite overlay shader
	if (!game_state.game_grid[xx][yy].is_visible and game_state.game_grid[xx][yy].explored) and (!debugging_mode){
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
					
	// Get tile spritesheet position
	var tile_x = ind mod 8;
	var tile_y = ind div 8;
			
	draw_sprite_part_ext(spr, ind, tile_x*cell_width, tile_y*cell_height, cell_width, cell_height, floor(screen_x), floor(screen_y), 1, 1, C_WHITE, 1);
	
	if (struct_exists(game_state.game_grid[xx][yy], "is_animated")){
		
	}
	
	// If tile is light source
	if (struct_exists(game_state.game_grid[xx][yy], "light_source")){
		
		// If tile is lit and visible
		if (game_state.game_grid[xx][yy].light_source and game_state.game_grid[xx][yy].is_visible){
			
			// Increment lit index
			game_state.game_grid[xx][yy].light_index += sprite_get_speed(game_state.game_grid[xx][yy].lit_sprite) / game_get_speed(gamespeed_fps);
		
			// Loop lit animation
			if (game_state.game_grid[xx][yy].light_index >= sprite_get_number(game_state.game_grid[xx][yy].lit_sprite)){
				game_state.game_grid[xx][yy].light_index = 0;
			}
		
			// Draw light sprite
			draw_sprite(game_state.game_grid[xx][yy].lit_sprite, game_state.game_grid[xx][yy].light_index, screen_x, screen_y);
		}
	}
	
	if (dng != noone){
		draw_sprite(tile_world_dungeon_entrance_spr, 0, screen_x, screen_y);
	}
	if (shader_current() != -1){
		shader_reset();
	}
}


// INVENTORY --------------------------------------------------------------------------------------
function draw_inventory(actor, x_pos, y_pos, width, height){
	
	// Text colour
	var tc = colour_text_main;
	
	// Position variables
	var xx, yy;
	var text_y_offset = ceil((ITEM_SPRITE_SIZE - text_height) / 2);
	
	// Create controls string
	var key_1 = keybinding_get_text(controls.key_cancel);
	var key_2 = keybinding_get_text(controls.key_cancel);
	var key_3 = keybinding_get_text(controls.key_item_swap);
	var key_4 = keybinding_get_text(controls.key_interact_confirm);
	var control_list = $"{key_1} or {key_2} to exit / {key_3} to toggle / {key_4} to select";
	
	// Background
	ui_draw_box(x_pos, y_pos, width, height, "Inventory", control_list);
	
	// INVENTORY ----------------------------------------------------------------------------------
	var display_inv = inventory_create_display_list(actor);
	
	// Scrolling
	var len = array_length(display_inv[0]);
	var scroll_data = inventory_draw_scrollbar(display_inv[0], display_inv[1]);
	var draw_from = scroll_data[0];
	var draw_to = scroll_data[1];
	
	xx = x_pos + (text_width * 4);
	yy = y_pos + (text_height * 2);
	
	// Inventory information
	var inv_weight = actor.inv_weight;
	var equ_weight = actor.equ_weight;
	var max_weight = actor.carry_weight;
	
	var total_weight = $"{inv_weight + equ_weight} lb / {max_weight} lb total"
	
	var weight_colour = colour_text_main;
	if (inv_weight > max_weight * 2){
		weight_colour = C_RED;
		total_weight += " (overburdened)";
	}
	else if (inv_weight >= max_weight){
		weight_colour = C_ORANGE;
		total_weight += " (encumbered)";
	}
	
	draw_text_outlined($"{inv_weight} lb lb carried", xx, yy, colour_text_main);
	yy += text_height
	draw_text_outlined($"{equ_weight} lb equipped", xx, yy, colour_text_main);
	yy += text_height
	draw_text_outlined(total_weight, xx, yy, weight_colour);
	
	yy += text_height * 2;
	
	// Items
	if (len > 0){
		for(var i = draw_from; i < draw_to; i ++){
			
			// Reset X position
			xx = x_pos + (text_width * 4);
			
			var txt = display_inv[0][i][0];
			
			// Item text 
			if (array_length(display_inv[0][i]) > 1){
				
				var spr = display_inv[0][i][1];
				var ind = display_inv[0][i][2];
				var wei = display_inv[0][i][3];
				var val = display_inv[0][i][4];
				
				xx += inv_spacing;
				
				var sheet_x = (ind mod 8) * ITEM_SPRITE_SIZE;
				var sheet_y = (ind div 8) * ITEM_SPRITE_SIZE;
				draw_sprite_part(spr, 0, sheet_x, sheet_y, ITEM_SPRITE_SIZE, ITEM_SPRITE_SIZE, xx, yy);
				
				var x_mod = 0;
				if (ui_flip and display_inv[1] == i and actor.inventory.selected == 1){
					x_mod = text_width;
				}
				xx += inv_spacing * 1.5;
				
				// Item name and stack
				draw_text_outlined($"{wei} lb / $ {val}", x_pos + width, yy + text_y_offset, tc, fa_right);
				
				// Weight (and value?)
				draw_text_outlined(txt, xx + text_width - x_mod, yy + text_y_offset, tc);
			}
			else{
				draw_text_outlined(txt, xx, yy + text_y_offset, tc);
			}
			
			// Increment y position
			yy += inv_spacing;
		}
	}
	else{
		
		// Inventory is empty
		draw_text_outlined(" - No items held _ ", xx, yy, tc);
	}
	
	// EQUIPMENT ----------------------------------------------------------------------------------
	if (inventory_display_state == INVENTORY_DISPLAY.EQUIPMENT){
		draw_equipment(actor);
	}
	// CONTAINER ----------------------------------------------------------------------------------
	else if (inventory_display_state == INVENTORY_DISPLAY.CONTAINER){
		draw_container(tile_container);
	}
	// TRADE --------------------------------------------------------------------------------------
	
	
	// Interaction context menu
	var menu_cont = actor.inventory.context_menu;
	var menu_equi = actor.inventory.slot_select_menu;
	if (menu_cont != noone and menu_equi == noone){
		draw_context_menu(actor, screen_width / 2, screen_height / 2, menu_cont[3], menu_cont[4]);
	}
	
	// Equipment slot context menu
	if (menu_equi != noone){
		draw_context_slot_select_menu(actor, screen_width / 2, screen_height / 2, menu_equi[3], menu_equi[4]);
	}
}

function draw_equipment(actor){
	// Text colour
	var tc = colour_text_main;
	
	// Position variables
	var xx, yy;
	
	// Create controls string
	var key_1 = keybinding_get_text(controls.key_cancel);
	var key_2 = keybinding_get_text(controls.key_item_swap);
	var key_3 = keybinding_get_text(controls.key_interact_confirm);
	var control_list = $"{key_1} to exit / {key_2} to toggle / {key_3} to select";
	
	// Background
	ui_draw_box(equipment_x, equipment_y, equipment_w, equipment_h, "Equipment", control_list);
	
	// Worn Equipment
	xx = equipment_x + (text_width * 2);
	yy = equipment_y + (text_height * 2);
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
					
					var col			= C_LTGREY;
					var is_animated = false;
					if (slot == BODY_PART_STATS.PART_HAND_SLOT) col = C_RED;
					if (slot == BODY_PART_STATS.PART_AUX_SLOT)  col = C_PURPLE;
					
					if (actor.inventory.equ_hover[0] == cat and actor.inventory.equ_hover[1] == ind and actor.inventory.equ_hover[2] == slot and actor.inventory.selected == 0){
						col = C_WHITE;
						is_animated = true;
						equipment_hovered_x_pos = xx;
						equipment_hovered_y_pos = yy;
					}
					
					// Draw equipment box
					ui_draw_equipment_box(xx, yy, col, is_animated);
					
					// Draw equipment
					if (is_struct(actor.body_plan[cat][ind][slot])){
						
						var slot_item = actor.body_plan[cat][ind][slot];

						var item_sprite = slot_item.sprite_index;
						var item_index  = slot_item.image_index;
						var sheet_x = (item_index mod 8) * ITEM_SPRITE_SIZE;
						var sheet_y = (item_index div 8) * ITEM_SPRITE_SIZE;
						
						// Sprite
						var offset = floor((equipment_box_size - ITEM_SPRITE_SIZE) / 2);
						draw_sprite_part(item_sprite, 0, sheet_x, sheet_y, ITEM_SPRITE_SIZE, ITEM_SPRITE_SIZE, xx + offset, yy + offset);
						
						// Stack
						var stack = slot_item.stack;
						if (stack > 1){
							draw_text_outlined(string(stack), xx, yy, tc);
						}
					}
					
					// Increment box X position
					xx += equipment_box_size;
				}
				
				var col = colour_text_main;
				draw_text_colour(xx, yy, actor.body_plan[cat][ind][BODY_PART_STATS.PART_NAME], col, col, col, col, 1);
				
				xx = equipment_x + (text_width * 2);
				yy += equipment_box_size;
			}
		}
	}
}

function draw_container(container){
	
	// Text colour
	var tc = colour_text_main;
	
	// Position variables
	var xx, yy;

	var text_y_offset = ceil((ITEM_SPRITE_SIZE - text_height) / 2);
	
	// Create controls string
	var key_1 = keybinding_get_text(controls.key_cancel);
	var key_2 = keybinding_get_text(controls.key_inventory);
	var key_3 = keybinding_get_text(controls.key_interact_confirm);
	var control_list = $"{key_1} to exit / {key_2} to toggle / {key_3} to select";
	var title = container.tile;
	
	// Background
	ui_draw_box(equipment_x, equipment_y, equipment_w, equipment_h, title, control_list);
	
	xx = equipment_x + (text_width  * 5);
	yy = equipment_y + (text_height * 2);
	
	// Inventory information
	var len_items = array_length(container.inventory);
	var max_items = container.inventory_max;
	draw_text_outlined($"{len_items} / {max_items} items", xx, yy, colour_text_main);
	
	yy += text_height * 2;
	
	for (var i = 0; i < len_items; i ++){
		
		var spr = container.inventory[i].sprite_index;
		var ind = container.inventory[i].image_index;
		
		var sheet_x = (ind mod 8) * ITEM_SPRITE_SIZE;
		var sheet_y = (ind div 8) * ITEM_SPRITE_SIZE;
		
		var txt = "";
		var x_mod = 0;
		if (manager.actor_registry.player.inventory.selected == 0){
			if (container.inv_hover == i){
				txt += "> ";
			}
			if (ui_flip){
				txt += " ";
				x_mod = text_width;
			}
		}
		txt += container.inventory[i].name;
		
		draw_sprite_part(spr, 0, sheet_x, sheet_y, ITEM_SPRITE_SIZE, ITEM_SPRITE_SIZE, xx, yy);
		
		draw_text_outlined(txt, xx + (inv_spacing * 2) - x_mod, yy + text_y_offset, tc);
		
		yy += inv_spacing;
	}
}

function draw_trade(trader){
	
}

function draw_context_menu(actor, x_pos, y_pos, width, height){
	
	var xx, yy;
	var choices = actor.inventory.context_menu;
	
	// Create controls string
	var key_1 = keybinding_get_text(controls.key_cancel);
	var key_2 = keybinding_get_text(controls.key_inventory);
	var key_3 = keybinding_get_text(controls.key_interact_confirm);
	
	var box_title    = "What do you want to do with this?";
	var control_list = $"{key_1} or {key_2} to exit / {key_3} to select item";
	
	var box_width = max(width, string_width(control_list), string_width(box_title));
	box_width += (text_width * 6);
	
	// Draw box border
	ui_draw_box(x_pos - (box_width / 2), y_pos - (height / 2), box_width, height, box_title, control_list);
	
	// Draw context menu choices
	for (var i = 0; i < array_length(choices[0]); i ++){
		xx = (x_pos - (box_width / 2))  + (text_width * 3);
		yy = (y_pos - (height / 2)) + (text_height * 2) + (text_height * i);
		var txt = "";
		var x_mod = 0;
		if (choices[5] == i){
			txt += "> ";
			if (ui_flip){
				txt += " ";
				x_mod = text_width;
			}
		}
		txt += choices[0][i];
		
		draw_text_colour(xx - x_mod, yy, txt, colour_text_main, colour_text_main, colour_text_main, colour_text_main, 1);
	}
}

function draw_context_slot_select_menu(actor, x_pos, y_pos, width, height){
	
	var xx, yy;
	var menu_list = actor.inventory.slot_select_menu;
	
	// Create controls string
	var key_1 = keybinding_get_text(controls.key_cancel);
	var key_2 = keybinding_get_text(controls.key_inventory);
	var key_3 = keybinding_get_text(controls.key_interact_confirm);
	var control_list = $"{key_1} or {key_2} to exit / {key_3} to select item";
	
	var box_title = "Choose a slot";
	
	var box_width = max(width, string_width(control_list), string_width(box_title));
	box_width += (text_width * 6);
	
	// Draw box border
	ui_draw_box(x_pos - (box_width / 2), y_pos - (height / 2), box_width, height, box_title, control_list);
	
	// Draw context menu choices
	for (var i = 0; i < array_length(menu_list[0]); i ++){
		xx = (x_pos - (box_width / 2))  + (text_width * 3);
		yy = (y_pos - (height / 2)) + (text_height * 2) + (text_height * i);
		
		var txt = "";
		var x_mod = 0;
		if (menu_list[5] == i){
			txt += "> ";
			if (ui_flip){
				txt += " ";
				x_mod = text_width;
			}
		}
		
		txt += menu_list[0][i][0];
		
		draw_text_colour(xx - x_mod, yy, txt, colour_text_main, colour_text_main, colour_text_main, colour_text_main, 1);
	}
}

function inventory_create_display_list(actor){
	with (actor){
		var new_list = [];
		var hovered_index = noone;
		
		var len	= array_length(inventory.items);
		
		// If inventory contains items
		if (len > 0){
			var current_sort_index = noone;
			
			// Cycle through inventory
			for (var i = 0; i < len; i ++){
				var item_sort_index = inventory.items[i].sort_index;
				if (current_sort_index != item_sort_index){
					current_sort_index = item_sort_index;
					
					// Push header to list
					array_push(new_list, [inventory_get_category_text(inventory.items[i])]);
				}
				var item_text = "";
				if (inventory.inv_hover == i) {
					if (inventory.selected == 1){
						item_text += "> ";
						if (manager.ui_flip){
							item_text += " ";
						}
					}
					hovered_index = array_length(new_list);
				}
				if (inventory.items[i].stack > 1){
					item_text += $"{inventory.items[i].stack} x ";
				}
				item_text += inventory.items[i].name
				
				var item_sprite = inventory.items[i].sprite_index;
				var item_index  = inventory.items[i].image_index;
				var item_weight = inventory.items[i].weight;
				var item_value  = inventory.items[i].value;
				
				// Push item to list
				array_push(new_list, [item_text, item_sprite, item_index, item_weight, item_value]);
			}
		}
		return([new_list, hovered_index]);
	}
}

function inventory_draw_scrollbar(array, hover){
	var inv_length			= array_length(array);
	var scroll_start_index	= 0;
	var scroll_end_index	= inv_length;

	if (inv_length > inv_display_max){
	
		// Set scrolling limits
		
		scroll_start_index	= max(hover - (floor(inv_display_max / 2) - 1), 0);
		scroll_start_index	= min(scroll_start_index, inv_length - inv_display_max);
		
		scroll_end_index	= scroll_start_index + inv_display_max;
	
		// Set scroll bar fill 
		var fill_percent	= inv_display_max / inv_length
		var fill_amount		= scroll_fill_max * fill_percent;
	
		var fill_pos_y		= scroll_start_index * (scroll_fill_max - fill_amount) / (inv_length - inv_display_max);
		
		// Background
		draw_sprite_stretched_ext(scrollbar_spr, 1, scroll_x, scroll_y, scroll_w, scroll_h, colour_bg_main, 1);
		
		// Fill bar
		draw_sprite_stretched_ext(pixel_spr, 0, scroll_x + 3, scroll_y + 3 + fill_pos_y, 2, fill_amount, C_ORANGE, 1);
		
		// Border
		draw_sprite_stretched_ext(scrollbar_spr, 0, scroll_x, scroll_y, scroll_w, scroll_h, colour_ui_main, 1);
		
		return([scroll_start_index, scroll_end_index]);
	}
	else{
		return([0, inv_length]);
	}
}

function inventory_get_category_text(item){
	var sort_index = item.sort_index;
	switch(sort_index){
		case ITEM_SORT.WEAPON_MELEE:	return("Melee Weapons");	break;
		case ITEM_SORT.WEAPON_RANGED:	return("Ranged Weapons");	break;
		case ITEM_SORT.AMMO:			return("Ammo");				break;
		case ITEM_SORT.HEAD:			return("Head");				break;
		case ITEM_SORT.FACE:			return("Face");				break;
		case ITEM_SORT.BODY:			return("Body");				break;
		case ITEM_SORT.BACK:			return("Back");				break;
		case ITEM_SORT.ARMS:			return("Arms");				break;
		case ITEM_SORT.HANDS:			return("Hands");			break;
		case ITEM_SORT.LEGS:			return("Legs");				break;
		case ITEM_SORT.FEET:			return("Feet");				break;
	}
}


// UI DRAWING -------------------------------------------------------------------------------------
function draw_game_ui(){
	
	 ui_draw_box(ui_x_pos[ui_settings.ui_x_position][0], 0, ui_width, screen_height);
	
	// Game log
	draw_game_log(ui_x_pos[ui_settings.ui_x_position][0], screen_height - log_height, ui_width, log_height);

	// Info box
	draw_info_box();

	// Minimap
	draw_minimap();
	
	// Day/night cycle
	draw_day_night();
	
	// Inventory and pick-up menus
	if (actor_registry.player.state == state_inventory or actor_registry.player.state == state_context_menu or actor_registry.player.state == state_slot_selection){
		draw_inventory(actor_registry.player, inventory_x, inventory_y, inventory_w, inventory_h);
	}
	if (actor_registry.player.state == state_pickup){
		draw_pickup(actor_registry.player);
	}
	if (actor_registry.player.state == state_look){
		draw_look_data();
	}
	
	draw_warning();
}

function draw_control_menu(){
	
	var control_text;
	control_text[0] = "Up";
	control_text[1] = "Down";
	control_text[2] = "Left";
	control_text[3] = "Right";
	control_text[4] = "Move";
	control_text[5] = "Select/Interact";
	control_text[6] = "Look/Target";
	control_text[7] = "Inventory";
	control_text[8] = "View Map";
	control_text[9] = "Swap items";
	
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
	
function draw_game_over_menu(){
	var xx				= floor(screen_width * 0.5);
	var box_height		= text_height * (array_length(game_over_menu) + 4);
	var box_width		= text_width * 60;
	var box_center_x	= floor(screen_width * 0.5);
	var box_center_y	= floor(screen_height * 0.5);
	
	// UI border
	var box_left_x = box_center_x - floor(box_width / 2);
	var box_top_y  = box_center_y - floor(box_height / 2);
	var control_string = ui_menu_control_string();
	ui_draw_box(box_left_x, box_top_y, box_width, box_height,"Songs of Tir Olaf" , control_string);
	
	// Draw menu
	for (var i = 0; i < array_length(game_over_menu); i ++){
		var yy = box_top_y + ((i + 2) * text_height);
		var txt = "";
		var x_mod = 0;
		if (game_over_menu_hover == i){
			txt += "> ";
			if (ui_flip){
				txt += " ";
				x_mod = (text_width / 2);
			}
		}
		txt += game_over_menu[i];
		draw_text_outlined(txt, xx - x_mod, yy, colour_text_main, fa_center);
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
	
	// Fire particle effects
	particle_create_title_fire(part_title_fire, floor(screen_width * 0.5) - 120, title_y)
	particle_create_title_fire(part_title_fire, floor(screen_width * 0.5) + 120, title_y)
	
	// Mini logos and version number
	draw_sprite(gamemaker_logo_small_spr, 0, 4, screen_height - 4);
	draw_text_outlined($"Version: {global.version[0]}.{global.version[1]}.{global.version[2]}", 24, screen_height - 12, colour_text_main);
	draw_sprite(glesynmawr_logo_small_spr, 0, screen_width - 4, screen_height - 4);
	
	part_system_drawit(particle_system);
	
	// Braziers
	draw_sprite(brazier_spr, 1, floor(screen_width * 0.5) - 120, title_y);
	draw_sprite(brazier_spr, 1, floor(screen_width * 0.5) + 120, title_y);
	
	// UI border
	var box_left_x = box_center_x - floor(box_width / 2);
	var box_top_y  = box_center_y - floor(box_height / 2);
	var control_string = ui_menu_control_string();
	ui_draw_box(box_left_x, box_top_y, box_width, box_height,"Songs of Tir Olaf" , control_string);
	
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


// UI GENERIC -------------------------------------------------------------------------------------
function draw_text_outlined(text, x_pos, y_pos, text_col, h_align = fa_left){
	
	// Set colours
	var bg = colour_bg_main;
	var tc = text_col;
	
	// Set h align
	draw_set_halign(h_align);
	
	// Outline
	draw_text_ext_colour(x_pos+1, y_pos, text, text_height, screen_width, bg, bg, bg, bg, 1);
	draw_text_ext_colour(x_pos, y_pos-1, text, text_height, screen_width, bg, bg, bg, bg, 1);
	draw_text_ext_colour(x_pos-1, y_pos, text, text_height, screen_width, bg, bg, bg, bg, 1);
	draw_text_ext_colour(x_pos, y_pos+1, text, text_height, screen_width, bg, bg, bg, bg, 1);
	
	// Fill text
	draw_text_ext_colour(x_pos, y_pos, text, text_height, screen_width, tc, tc, tc, tc, 1);
	
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

function ui_draw_equipment_box(x_pos, y_pos, colour, animated, width = manager.equipment_box_size, height = manager.equipment_box_size){
	
	with (manager){
		var xx = x_pos;
		var yy = y_pos;
		var ww = width;
		var hh = height;
	
		if (animated){
			xx -= ui_flip;
			yy -= ui_flip;
			ww += 2 * ui_flip;
			hh += 2 * ui_flip;
		}
	
		draw_sprite_stretched_ext(equipment_box_spr, 0, xx, yy, ww, hh, colour, 1);
	}
}


// UI SPECIFIC ------------------------------------------------------------------------------------
function ui_anim_flip(){
	ui_flip_timer --;
	if (ui_flip_timer <= 0){
		ui_flip_timer = ui_flip_timer_max;
		ui_flip = !ui_flip;
	}
}
	
function draw_day_night(){
	
	if (!surface_exists(day_night_surface)){
		day_night_surface = surface_create(day_night_width, day_night_height);
	}
	
	surface_set_target(day_night_surface);
	
	draw_clear(colour_bg_main);
	
	var current_day_turn	= time_system.game_current_time[TIME.TURN] mod turns_per_day;
	var angle_increment		= 360 / turns_per_day;
	var time_angle_start	= 270 - (angle_increment * current_day_turn);
	
	var bg_index;
	if (current_day_turn < (5 * turns_per_hour)){
		bg_index = 4;
	}
	else if (current_day_turn < (6 * turns_per_hour)){
		bg_index = 3;
	}
	else if (current_day_turn < (7 * turns_per_hour)){
		bg_index = 2;
	}
	else if (current_day_turn < (8 * turns_per_hour)){
		bg_index = 1;
	}
	else if (current_day_turn < (16 * turns_per_hour)){
		bg_index = 0;
	}
	else if (current_day_turn < (17 * turns_per_hour)){
		bg_index = 1;
	}
	else if (current_day_turn < (18 * turns_per_hour)){
		bg_index = 2;
	}
	else if (current_day_turn < (19 * turns_per_hour)){
		bg_index = 3;
	}
	else {
		bg_index = 4;
	}
	
	draw_sprite(day_night_background_spr, bg_index, 0, 0);
	
	var spr_x = floor(lengthdir_x(sun_moon_distance_x, time_angle_start) + (day_night_width / 2));
	var spr_y = floor(lengthdir_y(sun_moon_distance_y, time_angle_start) + day_night_height);
	
	draw_sprite(day_night_sun_moon_spr, 0, spr_x, spr_y);
	
	spr_x = floor(lengthdir_x(sun_moon_distance_x, time_angle_start - 180) + (day_night_width / 2));
	spr_y = floor(lengthdir_y(sun_moon_distance_y, time_angle_start - 180) + day_night_height);
	
	draw_sprite(day_night_sun_moon_spr, 1, spr_x, spr_y);
	
	draw_sprite(day_night_foreground_spr, bg_index, 0, 0);
	
	surface_reset_target();
	
	var xx = floor(ui_x_pos[ui_settings.ui_x_position][0] + minimap_width + 3);
	var yy = floor(text_width + 3);
	draw_surface(day_night_surface, xx, yy);
}

function draw_game_log(x_pos, y_pos, width, height){
	
	ui_draw_box(x_pos, y_pos, width, height);
	
	var xx = x_pos + (text_width * 2);
	var yy = y_pos + text_height;
	
	if (!surface_exists(log_surface)){
		log_surface = surface_create(log_surface_width, log_surface_height);
	}
	
	surface_set_target(log_surface);
	
	draw_clear(colour_bg_main);
	
	var draw_to = min(LOG_MAX_ENTRIES, array_length(game_state.game_log));
	var line_y_pos = 0;
	for (var line = 0; line < draw_to; line ++){
		
		var text =		game_state.game_log[line][0];
		var colour =	game_state.game_log[line][1];
		
		draw_text_ext_colour(0, line_y_pos, text, text_height, log_surface_width, colour ,colour ,colour ,colour, 1);
		
		line_y_pos += string_height_ext(text, text_height, log_surface_width) + 3;
	}
	
	surface_reset_target();
	
	draw_surface(log_surface, xx, yy);
}

function draw_info_box(){
	
	// Background and border
	var xx = ui_x_pos[ui_settings.ui_x_position][0];
	var yy = infobox_y;
	ui_draw_box(xx, yy, infobox_width, infobox_height);
	
	// Player hit points
	xx += text_width * 2;
	yy += text_width * 2;
	
	var hp_max = actor_registry.player.hit_points[STAT_TYPE.BASE];
	var hp_cur = actor_registry.player.hit_points[STAT_TYPE.CURRENT];
	var fill_percent = hp_cur / hp_max;
	var fill_pixels  = infobox_hp_width * fill_percent;
	
	draw_sprite_stretched(hit_point_bar_spr, 0, xx, yy, infobox_hp_width, infobox_hp_height); 
	draw_sprite_stretched(hit_point_bar_spr, 1, xx, yy, fill_pixels, infobox_hp_height);
	
	draw_text_outlined($"HP: {actor_registry.player.hit_points[STAT_TYPE.CURRENT]} / {actor_registry.player.hit_points[STAT_TYPE.BASE]}", xx + 3, yy + 3, colour_text_main);
	
	// Current turn
	yy += 32;
	draw_text_outlined($"Turn: {time_system.game_current_time[TIME.TURN]}", xx, yy, colour_text_main);
	
	// Current hour
	yy += text_height;
	draw_text_outlined($"Hour: {time_system.game_current_time[TIME.HOUR]}", xx, yy, colour_text_main);
	
	// Current day
	yy += text_height;
	draw_text_outlined($"Day:  {time_system.game_current_time[TIME.DAY]}", xx, yy, colour_text_main);
	
	// Hand-held items
	yy += text_height;
	var x_pos = xx;
	for (var category = 0; category < array_length(actor_registry.player.body_plan); category ++){
		for (var index = 0; index < array_length(actor_registry.player.body_plan[category]); index ++){
			if (body_part_is_present(actor_registry.player, category, index)){
				if (body_part_has_hand(actor_registry.player, category, index)){
					
					ui_draw_equipment_box(x_pos, yy, colour_ui_main, false);
					
					// Held item
					var item_in_hand = actor_registry.player.body_plan[category][index][BODY_PART_STATS.PART_HAND_SLOT];
					if (item_in_hand != noone){
						var spr = item_in_hand.sprite_index;
						var ind = item_in_hand.image_index;
					
						var sheet_x = (ind mod 8) * ITEM_SPRITE_SIZE;
						var sheet_y = (ind div 8) * ITEM_SPRITE_SIZE;
						var offset  = floor((equipment_box_size - ITEM_SPRITE_SIZE) / 2);
						draw_sprite_part(spr, 0, sheet_x, sheet_y, ITEM_SPRITE_SIZE, ITEM_SPRITE_SIZE, x_pos + offset, yy + offset);
					}
					x_pos += equipment_box_size
				}
			}
		}
	}
}

function draw_minimap(){
	var px, py, mx, my, s, col;
	
	var bg = colour_bg_main;
	
	var grid_w = array_length(game_state.game_grid);
	var grid_h = array_length(game_state.game_grid[0]);
	
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
				
			if(game_state.game_grid[i][j].is_visible){
				if (game_state.game_grid[i][j].walkable == true) and (game_state.game_grid[i][j].tile != "secret door"){
					
					col = C_LTGREY;
					
					if (game_state.game_grid[i][j].transparent == false){
						col = C_MIDGREY;
					}
					else if (game_state.game_grid[i][j].tile == "entry"){
						col = C_YELLOW;
					}
					else if (game_state.game_grid[i][j].tile == "exit"){
						col = C_YELLOW;
					}
				}
			}
			else if (game_state.game_grid[i][j].explored){
				if (game_state.game_grid[i][j].walkable == true) and (game_state.game_grid[i][j].tile != "secret door"){
					
					col = C_BLUE;
					
					if (game_state.game_grid[i][j].transparent == false){
						col = C_DKGREY;
					}
					else if (game_state.game_grid[i][j].tile == "entry"){
						col = C_ORANGE;
					}
					else if (game_state.game_grid[i][j].tile == "exit"){
						col = C_YELLOW;
					}
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
		
	draw_surface(minimap_surface, ui_x_pos[ui_settings.ui_x_position][0], minimap_y);
		
	// Draw Map Border
	draw_sprite_stretched_ext(ui_border_spr, 1, ui_x_pos[ui_settings.ui_x_position][0], minimap_y, minimap_width, minimap_height, bg, 1);
	draw_sprite_stretched_ext(ui_border_spr, 0, ui_x_pos[ui_settings.ui_x_position][0], minimap_y, minimap_width, minimap_height, C_ORANGE,  1);
	
	// Draw box text
	if (ui_settings.minimap_title_text != ""){
		ui_draw_box_title(ui_x_pos[ui_settings.ui_x_position][0] + (text_width * 2), minimap_y, ui_settings.minimap_title_text);
	}
	if (ui_settings.minimap_sub_text != ""){
		ui_draw_box_controls(ui_x_pos[ui_settings.ui_x_position][0] + (text_width * 2), minimap_height - 5, ui_settings.minimap_sub_text);
	}
}

function draw_notification(){
	with (manager){
		var xx = notification.x_pos;
		var yy = notification.y_pos;
		var ww = notification.width;
		var hh = notification.height;
		var txt = notification.text;
		
		// Create controls string
		var control_list = "";
		if (notification.cancel){
			var key_1 = keybinding_get_text(controls.key_cancel);
			control_list += $"{key_1} to exit";
		}
		if (notification.confirm){
			var key_2 = keybinding_get_text(controls.key_interact_confirm);
			control_list += $" / {key_2} to confirm";
		}
	
		// Background
		ui_draw_box(xx, yy, ww, hh, , control_list);
		
		// Notification text
		draw_text_outlined(txt, xx + (text_width * 2), yy + (text_height * 2), colour_text_main);
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
		xx = x_pos + (text_width * 3);
		yy = y_pos + (text_height * 2) + (i * text_height);
		
		// Text
		var txt = "";
		var x_mod = 0;
		if (actor.pickup_hover == i){
			txt += "> ";
			if (ui_flip){
				txt += " ";
				x_mod = (text_width);
			}
		}
		txt += actor.pickup_menu[i].name;
		
		draw_text_colour(xx - x_mod, yy, txt, tc, tc, tc, tc, 1);
	}
	
	// Draw box controls
	if (show_controls){
		xx = x_pos + (text_width * 2);
		yy = y_pos + height - text_height;
		ui_draw_box_controls(xx, yy, control_list);
	}
}


// UI LOOK STATE ----------------------------------------------------------------------------------
function draw_look_cursor(x_offset, y_offset){
	
	if (struct_exists(actor_registry.player, "look_mode")){
		if (actor_registry.player.look_mode != noone){
			
			with (actor_registry.player.look_mode){
				
				var col = C_BLACK;
				var r = colour_get_red(col)   / 255;
				var g = colour_get_green(col) / 255;
				var b = colour_get_blue(col)  / 255;
								
				col = [r, g, b, 1.0];
								
				var tex		= sprite_get_texture(sprite_index, image_index);
				var texel_w = texture_get_texel_width(tex);
				var texel_h = texture_get_texel_height(tex);
								
				shader_set(outline_shd);
				shader_set_uniform_f(manager.uni_texel_size, texel_w, texel_h);
				shader_set_uniform_f(manager.uni_outline_col, col[0], col[1], col[2], col[3]);
				
				ui_draw_equipment_box(sprite_x - x_offset, sprite_y - y_offset, manager.colour_ui_main, true)
				
				shader_reset();
			}
		}
	}
}

function draw_look_data(){
	
	if (struct_exists(actor_registry.player, "look_mode")){
		if (actor_registry.player.look_mode != noone){
			
			if (actor_registry.player.look_mode.look_pages == noone){
				return;
			}
			
			// Background and border
			var xx = ui_x_pos[ui_settings.ui_x_position][0];
			var yy = infobox_y;
	
			var key_exit	= keybinding_get_text(controls.key_cancel);
	
			var control_text = $"{key_exit} to exit";
	
			ui_draw_box(xx, yy, infobox_width, infobox_height, "Looking at -", control_text);
				
			xx += text_width * 2;
			yy += text_width * 2;
			
			var look_hover = actor_registry.player.look_mode.look_hover;
			var look_list  = actor_registry.player.look_mode.look_pages;
			
			if (look_list[look_hover][0] == "actor"){
				draw_look_actor_data(look_list[look_hover][1])
			}
			if (look_list[look_hover][0] == "items"){
				draw_look_items_data(look_list[look_hover][1])
			}
			if (look_list[look_hover][0] == "tile"){
				draw_look_tile_data(look_list[look_hover][1])
			}
		}
	}
}

function draw_look_actor_data(actor){
	var xx = ui_x_pos[ui_settings.ui_x_position][0] + (text_width * 2);
	var yy = infobox_y + (text_width * 2);
	
	draw_text_outlined(actor.name, xx, yy, colour_text_main);
}

function draw_look_items_data(items){
	var xx = ui_x_pos[ui_settings.ui_x_position][0] + (text_width * 2);
	var yy = infobox_y + (text_width * 2);
	var text_y_offset = ceil((ITEM_SPRITE_SIZE - text_height) / 2);
	
	draw_text_outlined("Items", xx, yy, colour_text_main);
	
	yy += text_width * 2;
	
	var list_len  = array_length(items);
	var max_lines = floor((infobox_height - (text_width * 6)) / inv_spacing);
	var lines_to_draw = min(list_len, max_lines);
	var excess_lines = list_len - (lines_to_draw);
	
	for (var i = 0; i < lines_to_draw; i ++){
		
		if (i == lines_to_draw - 1){
			if (excess_lines - 1 > 0){
				var item_append = "";
				if (excess_lines > 1) item_append = "s"
				draw_text_outlined($"  Plus {excess_lines} more item{item_append} ... ", xx, yy + text_y_offset, colour_text_main); 
				break;
			}
		}
		
		var spr = items[i].sprite_index;
		var ind = items[i].image_index;
		var txt = items[i].name;
		
		var sheet_x = (ind mod 8) * ITEM_SPRITE_SIZE;
		var sheet_y = (ind div 8) * ITEM_SPRITE_SIZE;
		
		draw_sprite_part(spr, ind, sheet_x, sheet_y, ITEM_SPRITE_SIZE, ITEM_SPRITE_SIZE, xx, yy);
		
		xx += inv_spacing * 2;
		draw_text_outlined(txt, xx, yy + text_y_offset, colour_text_main);
		
		xx -= inv_spacing * 2;
		yy += inv_spacing;
	}
	
	
}

function draw_look_tile_data(tile){
	var xx = ui_x_pos[ui_settings.ui_x_position][0] + (text_width * 2);
	var yy = infobox_y + (text_width * 2);
	
	draw_text_outlined(tile.tile, xx, yy, colour_text_main);
}


// WARNINGS ---------------------------------------------------------------------------------------
function draw_warning(){
	
	if (is_struct(current_warning)){
		var xx = 0;
		var yy = 0;
		var ww = screen_width;
		var hh = screen_height;
	
		var warning_text	= current_warning.text;
		var colour			= current_warning.colour;
		var animated		= current_warning.is_animated;
	
		var tex		= sprite_get_texture(equipment_box_spr, 0);
		var texel_w = texture_get_texel_width(tex);
		var texel_h = texture_get_texel_height(tex);
								
		shader_set(outline_shd);
		shader_set_uniform_f(uni_texel_size, texel_w, texel_h);
		shader_set_uniform_f(uni_outline_col, outline_colour[0], outline_colour[1], outline_colour[2], outline_colour[3]);
					
		ui_draw_equipment_box(xx, yy, colour, animated, ww, hh);
	
		shader_reset();
	
		var text_w = string_width(warning_text) + (text_width * 2);
		var text_h = text_height;
	
		var text_x = floor((ww / 2) - (text_w / 2));
		var text_y = screen_height - text_h;
	
		draw_rectangle_colour(text_x, text_y, text_x+text_w, text_y+text_h, colour_bg_main, colour_bg_main, colour_bg_main, colour_bg_main, false);
		draw_text_outlined(warning_text, text_x + text_width, text_y + 1, colour);
	}
}




