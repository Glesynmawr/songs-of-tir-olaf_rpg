/// @desc Initialise 

//randomise();

debugging_mode		= false;
game_paused			= false;

// Colours
colour_text_main	= C_LTGREY;
colour_bg_main		= C_BLACK;
colour_ui_main		= C_ORANGE;

// STATE TRANSITION
transition = noone;

// DUNGEON PROGRESS
current_depth   = noone;;
dungeon_entry_x = noone;
dungeon_entry_y = noone;


#region// MENUS -----------------------------------------------------------------------------------
control_menu_hover = 0;
control_menu[0] = "Rebind keys";
control_menu[1] = "Set default keys";
control_menu[2] = "Save and exit";

game_over_menu_hover = 0;
game_over_menu[0] = "Try again";
game_over_menu[1] = "Quit to title";
game_over_menu[2] = "Quit to desktop";

main_menu_hover = 0;
main_menu[0] = "New game";
main_menu[1] = "Load game";
main_menu[2] = "Controls";
main_menu[3] = "Settings";
main_menu[4] = "Quit to desktop";

pause_menu_hover = 0;
pause_menu[0] = "Continue";
pause_menu[1] = "Controls";
pause_menu[2] = "Settings";
pause_menu[3] = "Save and quit";
pause_menu[4] = "Quit without saving";
pause_menu[5] = "Quit to desktop";

#endregion

#region// SET CONTRLS------------------------------------------------------------------------------
globalvar controls;
show_controls = true;

controls_default = {
	key_right: vk_right,
	key_up: vk_up,
	key_left: vk_left,
	key_down: vk_down,
	key_move_confirm: vk_space,
	key_interact_confirm: vk_enter,
	key_inventory: ord("I"),
	key_cancel: vk_escape
}

controls_read_settings();

move_timer_max = 10;
move_timer = 0;

#endregion

dungeon_data();
init_main();
init_particle_system();

#region // MOVEMENT -------------------------------------------------------------------------------
cell_x_neighbours = [1,  1,  0, -1, -1, -1, 0, 1];
cell_y_neighbours = [0, -1, -1, -1,  0,  1, 1, 1];
direction_indicator = noone;
direction_indicator_x = 0;
direction_indicator_y = 0;

#endregion

#region // EQUIPMENT SLOTS ------------------------------------------------------------------------
equip_data[EQUIP.HEAD] = ["head",			"headwear",			3];
equip_data[EQUIP.NECK] = ["neck",			"necklace",			3];
equip_data[EQUIP.BODY_PRESET] = ["body",			"armour",			1];
equip_data[EQUIP.BACK] = ["back",			"cloak",			1];
equip_data[EQUIP.ARMS] = ["arm",			"Vambrace",			6];
equip_data[EQUIP.HAND] = ["hand",			"Item",				6];
equip_data[EQUIP.MITT] = ["gloves",			"Gloves",		 	3];
equip_data[EQUIP.GUNS] = ["ranged item",	"Ranged item",		2];
equip_data[EQUIP.FEET] = ["feet",			"Footwear",	 		3];

#endregion

#region// UI --------------------------------------------------------------------------------------
ui_width	   = 96;
ui_position	   = 0;
ui_x_pos[0][0] = screen_width - ui_width;
ui_x_pos[0][1] = 0;
ui_x_pos[1][0] = 0;
ui_x_pos[1][1] = ui_width;

text_height = string_height("M") + 2;
text_width  = string_width("M");

// Game log
log_height = (LOG_MAX_ENTRIES + 2) * text_height;

// Minimap
minimap_scale	= 2;
minimap_surface = noone;
minimap_width	= ui_width;
minimap_height	= ui_width;
minimap_y		= 0;

// Minimap text
minimap_title_text = "";
minimap_sub_text  = "";

// Info box
infobox_width   = ui_width;
infobox_height  = screen_height - minimap_height - log_height + 10;
infobox_y       = minimap_height - 5;

// Inventory and equipment
equipment_box_sprite_size = sprite_get_width(equipment_box_spr);
equipment_hovered_x_pos = noone;
equipment_hovered_y_pos = noone;

#endregion

#region// SHADER SET-UP ---------------------------------------------------------------------------
// Colour overlay
uni_overlay		= shader_get_uniform(colour_overlay_shd, "uColour");

// Outline
outline_colour = C_BLACK;
var r = colour_get_red(outline_colour)   / 255;
var g = colour_get_green(outline_colour) / 255;
var b = colour_get_blue(outline_colour)  / 255;

outline_colour  = [r, g, b, 1.0];
uni_texel_size	= shader_get_uniform(outline_shd, "utexel_size");
uni_outline_col = shader_get_uniform(outline_shd, "uRGBA");

#endregion

#region// ACTORS ----------------------------------------------------------------------------------


// Base body plan (all FALSE)
body_plan_presets[BODY_PRESET.BASE][BODY_PART_CATEGORY.HEAD] = [[false, false, "Head"], [false, false, "Left head"], [false, false, "Right head"]];
body_plan_presets[BODY_PRESET.BASE][BODY_PART_CATEGORY.BODY] = [[false, false, "Body"]];
body_plan_presets[BODY_PRESET.BASE][BODY_PART_CATEGORY.ARMS] = [[false, false, "Right arm"], [false, false, "Left arm"], [false, false, "Right front arm"], [false, false, "Left front arm"], [false, false, "Right rear arm"], [false, false, "Left rear arm"]];
body_plan_presets[BODY_PRESET.BASE][BODY_PART_CATEGORY.LEGS] = [[false, false, "Right leg"], [false, false, "Left leg"], [false, false, "Right front leg"], [false, false, "Left front leg"], [false, false, "Right rear leg"], [false, false, "Left rear leg"]];

// Presets
// HUMANOID
body_plan_presets[BODY_PRESET.HUMANOID][BODY_PART_CATEGORY.HEAD] = [[true, false, "Head"], [false, false, "Left head"], [false, false, "Right head"]];
body_plan_presets[BODY_PRESET.HUMANOID][BODY_PART_CATEGORY.BODY] = [[true, false, "Body"]];
body_plan_presets[BODY_PRESET.HUMANOID][BODY_PART_CATEGORY.ARMS] = [[true, true,  "Right arm"], [true, true,  "Left arm"], [false, true,  "Right front arm"], [false, true,  "Left front arm"], [false, true,  "Right rear arm"], [false, true,  "Left rear arm"]];
body_plan_presets[BODY_PRESET.HUMANOID][BODY_PART_CATEGORY.LEGS] = [[true, false, "Right leg"], [true, false, "Left leg"], [false, false, "Right front leg"], [false, false, "Left front leg"], [false, false, "Right rear leg"], [false, false, "Left rear leg"]];

// QUADRUPED
body_plan_presets[BODY_PRESET.QUADRUPED][BODY_PART_CATEGORY.HEAD] = [[true, false, "Head"], [false, false, "Left head"], [false, false, "Right head"]];
body_plan_presets[BODY_PRESET.QUADRUPED][BODY_PART_CATEGORY.BODY] = [[true, false, "Body"]];
body_plan_presets[BODY_PRESET.QUADRUPED][BODY_PART_CATEGORY.ARMS] = [[false, false, "Right arm"], [false, false, "Left arm"], [false, false, "Right front arm"], [false, false, "Left front arm"], [false, false, "Right rear arm"], [false, false, "Left rear arm"]];
body_plan_presets[BODY_PRESET.QUADRUPED][BODY_PART_CATEGORY.LEGS] = [[false, false, "Right leg"], [false, false, "Left leg"], [true, false,  "Right front leg"], [true, false,  "Left front leg"], [true,  false, "Right rear leg"], [true,  false, "Left rear leg"]];

// WINGED BIPED
body_plan_presets[BODY_PRESET.WINGED_BIPED][BODY_PART_CATEGORY.HEAD] = [[true, false, "Head"], [false, false, "Left head"], [false, false, "Right head"]];
body_plan_presets[BODY_PRESET.WINGED_BIPED][BODY_PART_CATEGORY.BODY] = [[true, false, "Body"]];
body_plan_presets[BODY_PRESET.WINGED_BIPED][BODY_PART_CATEGORY.ARMS] = [[false, false, "Right arm"], [false, false, "Left arm"], [false, false, "Right front arm"], [false, false, "Left front arm"], [false, false, "Right rear arm"], [false, false, "Left rear arm"]];
body_plan_presets[BODY_PRESET.WINGED_BIPED][BODY_PART_CATEGORY.LEGS] = [[true,  false, "Right leg"], [true,  false, "Left leg"], [false, false, "Right front leg"], [false, false, "Left front leg"], [false, false, "Right rear leg"], [false, false, "Left rear leg"]];

#endregion

#region// TIME SYSTEM -----------------------------------------------------------------------------
current_turn		= 0;
game_current_time   = [0, 0, 0];
timescale_zone      = 1;
timescale_world		= 60;
timescale			= 0;

turns_per_hour	= 30;
hours_per_day	= 24;

#endregion




