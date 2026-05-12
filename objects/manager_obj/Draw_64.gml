/// @desc

var txt1 = $"Player has acted = {actor_registry.player.has_acted}";
draw_text(10, cell_height * 3, txt1);

var txt2 = $"Action list length = {array_length(action_list)}";
draw_text(10, cell_height * 4, txt2);

var txt2 = $"Player inventory = {actor_registry.player.inventory.items}";
draw_text(10, cell_height * 5, txt2);

draw_game_log(0, grid_height, grid_width, 6);

draw_text(cell_width, cell_height, $"HP: {actor_registry.player.hit_points}");

if (actor_registry.player.state == state_inventory){
	var xx = 0;
	var yy = 0;
	var ww = camera_get_view_width(view_camera[0]);
	var hh = camera_get_view_height(view_camera[0]);
	
	inventory_draw(actor_registry.player, xx, yy, ww, hh);
}

draw_set_halign(fa_right);
for (var i = 0; i < array_length(action_list); i ++){
	draw_text(room_width, cell_height * i, string(action_list[i].name) + ":" + string(action_list[i].state));
}
draw_set_halign(fa_left);






