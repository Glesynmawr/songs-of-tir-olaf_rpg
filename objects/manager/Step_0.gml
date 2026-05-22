/// @desc
var target_x = floor((actor_registry.player.x_pos * cell_width)  - (screen_width  / 2) + (cell_width  / 2));
var target_y = floor((actor_registry.player.y_pos * cell_height) - (screen_height / 2) - (cell_height / 2));

move_camera(target_x, target_y + floor(log_height / 2), 0.1);


if (!game_pause){
	turn_order_update();
}




