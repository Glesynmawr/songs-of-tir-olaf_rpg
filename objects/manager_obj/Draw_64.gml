/// @desc

var txt1 = $"Cell width = {cell_width}";
draw_text(10, cell_height * 3, txt1);

var txt2 = $"Cell height = {cell_height}";
draw_text(10, cell_height * 4, txt2);

var txt2 = $"Player character = {actor_registry.player.char}";
draw_text(10, cell_height * 5, txt2);

draw_game_log(0, grid_height, grid_width, 6);

draw_text(cell_width, cell_height, $"HP: {actor_registry.player.hit_points}");


