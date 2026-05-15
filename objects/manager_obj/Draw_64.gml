/// @desc

var ww = camera_get_view_width(view_camera[0]);
var hh = camera_get_view_height(view_camera[0]);
var xx = 0;
var yy = 0;
	
draw_text(text_width, text_height, $"HP: {actor_registry.player.hit_points}");

var txt1 = $"Direction = {direction_indicator}";
draw_text(text_width, text_height * 2, txt1);

var txt2 = $"Text size = x:{text_width} - y:{text_height}";
draw_text(text_width, text_height * 3, txt2);

var txt2 = $"Player inventory = {actor_registry.player.inventory.items}";
draw_text(10, text_height * 4, txt2);

var log_height = (LOG_MAX_ENTRIES + 1) * text_height
draw_game_log(0, hh - log_height, ww, log_height);


if (actor_registry.player.state == state_inventory){
	draw_inventory(actor_registry.player, xx, yy, ww, hh);
}
if (actor_registry.player.state == state_pickup){
	draw_pickup(actor_registry.player, xx, yy, ww, hh);
}

draw_set_halign(fa_right);
for (var i = 0; i < array_length(action_list); i ++){
	draw_text(room_width, text_height * i, string(action_list[i].name) + ":" + string(action_list[i].state));
}
draw_set_halign(fa_left);






