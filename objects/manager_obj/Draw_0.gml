/// @desc

// Draw game grid
for (var x_pos = 0; x_pos < grid_width; x_pos ++){
	for (var y_pos = 0; y_pos < grid_height; y_pos ++){
		
		if (game_grid[x_pos][y_pos].explored or debugging_mode){
		
			// Draw Dungeon
			var char = game_grid[x_pos][y_pos].char;
			var fg   = game_grid[x_pos][y_pos].fg;
			var bg   = game_grid[x_pos][y_pos].bg;
		
			if (!game_grid[x_pos][y_pos].is_visible and !debugging_mode){
				var fg   = c_dkgrey;
				var bg   = c_black;
			}
		
			// Draw character background
			draw_rectangle_colour(
				x_pos * cell_width,
				y_pos * cell_height,
				x_pos * cell_width + cell_width,
				y_pos * cell_height + cell_height,
				bg, bg, bg, bg,
				false
			)
		
			// draw tile character
			draw_text_colour(x_pos * cell_width, y_pos * cell_height, char, fg, fg, fg, fg, 1);
		
		}
	}
}

// Draw items

// Draw actors
var len = array_length(actor_registry.actor_list);
if (len > 0){
	for (var actor = 0; actor < len; actor ++){
		
		with (actor_registry.actor_list[actor]){
			if (self.is_visible or debugging_mode){
				x_pos	= self.x_pos * other.cell_width;
				y_pos	= self.y_pos * other.cell_height;
				char	= self.char;
				fg		= self.fg;
				bg		= self.bg;
		
				// Draw actor background
				draw_rectangle_colour(
					x_pos,
					y_pos,
					x_pos + other.cell_width,
					y_pos + other.cell_height,
					bg, bg, bg, bg,
					false
				)
		
				// Draw actor character
				draw_text_colour(x_pos, y_pos, char, fg, fg, fg, fg, 1)
			}
		}
	}
}




