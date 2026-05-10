/// @desc
var target_x = floor((actor_registry.player.x_pos * cell_width)  - (room_width  / 2) - (cell_width  / 2));
var target_y = floor((actor_registry.player.y_pos * cell_height) - (room_height / 2) - (cell_height / 2));

move_camera(target_x, target_y, 0.1);

with (actor_registry.player){
	state();
}




