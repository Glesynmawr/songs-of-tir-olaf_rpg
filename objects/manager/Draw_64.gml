/// @desc

var ww = camera_get_view_width(view_camera[0]);
var hh = camera_get_view_height(view_camera[0]);
var xx = 0;
var yy = 0;
	
draw_text(text_width, text_height, $"HP: {actor_registry.player.hit_points}");



var txt2 = $"Text size = x:{text_width} - y:{text_height}";
draw_text(text_width, text_height * 3, txt2);

var txt2 = $"Player inventory = {actor_registry.player.inventory.items}";
draw_text(10, text_height * 4, txt2);

draw_game_log(0, hh - log_height, ww, log_height);


if (actor_registry.player.state == state_inventory or actor_registry.player.state == state_context_menu or actor_registry.player.state == state_slot_selection){
	draw_inventory(actor_registry.player, xx, yy, ww, hh);
}
if (actor_registry.player.state == state_pickup){
	draw_pickup(actor_registry.player);
}

draw_minimap();


var txt1 = $"Slot selection = {actor_registry.player.inventory.slot_selection}";
draw_text(text_width, text_height * 2, txt1);








