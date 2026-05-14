/// @desc

// Draw game grid
draw_game_grid(game_grid);

for (var x_pos = 0; x_pos < grid_width; x_pos ++){
	for (var y_pos = 0; y_pos < grid_height; y_pos ++){
		
		var xx = x_pos * cell_width;
		var yy = y_pos * cell_height;
		

		// Draw items
		var len = array_length(game_grid[x_pos][y_pos].items);
		if (len > 0){
			
			var char = "t";
			var bg = c_black;
			fg = c_grey;
			
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
			draw_text_colour(xx, yy, char, fg, fg, fg, fg, 1);
		}
	}
}

// Draw actors
var len = array_length(actor_registry.actor_list);
if (len > 0){
	for (var actor = 0; actor < len; actor ++){
		
		with (actor_registry.actor_list[actor]){
			if (self.is_visible or debugging_mode){
				x_pos	= self.x_pos * other.cell_width;
				y_pos	= self.y_pos * other.cell_height;
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
		
				// Draw actor sprite
				draw_sprite_ext(sprite[0], sprite[1], x_pos, y_pos, 1, 1, 0, fg, 1);
				
				if (self == other.actor_registry.player){
					if (other.direction_indicator != noone){
						draw_sprite(direction_arrow_spr, other.direction_indicator, x_pos, y_pos);
					}
				}
			}
		}
	}
}




