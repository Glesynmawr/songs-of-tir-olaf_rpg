/// @desc Initialise 

global.version = [2, 4, 7];

//randomise();
debugging_mode		= false;
game_paused			= false;
transition			= noone;

#region// COLOURS ---------------------------------------------------------------------------------
colour_text_main	= C_LTGREY;
colour_bg_main		= make_colour_rgb(0, 15, 0);

colour_ui_main		= C_ORANGE;
colour_ui_off		= C_BROWN;

#endregion

#region// GAME STATE AND DATA----------------------------------------------------------------------
init_game_state()

world_data();
dungeon_data();
init_main();
init_particle_system();

#endregion

#region// ACTORS ----------------------------------------------------------------------------------

// Combat modifiers
offhand_agility_penalty = -4;

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

#region// INVENTORY SETUP -------------------------------------------------------------------------
inv_spr_size		= ITEM_SPRITE_SIZE;
inv_spacing			= inv_spr_size;
inv_display_max		= 20;

// Inventory position
inventory_x		= (screen_width / 2);
inventory_y		= 0;
inventory_w		= (screen_width / 2);
inventory_h		= screen_height;

// Equipment position
equipment_x		= 0;
equipment_y		= 0;
equipment_w		= (screen_width / 2);
equipment_h		= screen_height;

// Scroll bar
scroll_x			= inventory_x + 2;
scroll_y			= (text_height * 4);
scroll_h			= (inv_display_max * inv_spacing) + (2 * 3);
scroll_w			= 8;
scroll_fill_max		= inv_display_max * inv_spacing;

#endregion

#region// LIGHTING --------------------------------------------------------------------------------

#endregion

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
	key_right:				vk_right,
	key_up:					vk_up,
	key_left:				vk_left,
	key_down:				vk_down,
	key_move_confirm:		vk_space,
	key_interact_confirm:	vk_enter,
	key_inventory:			ord("I"),
	key_map_mode:			ord("M"),
	key_item_swap:			ord("E"),
	key_cancel:				vk_escape
}

controls_read_settings();

move_timer_max = 10;
move_timer = 0;

#endregion

#region// MOVEMENT --------------------------------------------------------------------------------
cell_x_neighbours = [1,  1,  0, -1, -1, -1, 0, 1];
cell_y_neighbours = [0, -1, -1, -1,  0,  1, 1, 1];

// Move speed - multiplier
actor_move_speed = 0.2;
		
#endregion

#region// UI --------------------------------------------------------------------------------------

// UI variables -----------------------------------------------------------------------------------
ui_settings = {
	ui_x_position			: 0,
	minimap_title_text		: "",
	minimap_sub_text		: "",
	move_bounce_amplitude	: 3,
	game_grid_cells_width:	MAP_WIDTH,
	game_grid_cells_height: MAP_HEIGHT
}

// UI constants -----------------------------------------------------------------------------------
ui_width		= 160;

// UI flipping values
ui_x_pos[0][0]	= screen_width - ui_width;
ui_x_pos[0][1]	= 0;
ui_x_pos[1][0]	= 0;
ui_x_pos[1][1]	= ui_width;

// Game log
log_surface = noone;
log_height	= (LOG_MAX_ENTRIES + 2) * text_height;

log_surface_width  = ui_width - (text_width * 4);
log_surface_height = log_height - (text_height * 2);

// Minimap
minimap_scale	= 2;
minimap_surface = noone;
minimap_width	= 80;
minimap_height	= 80;
minimap_y		= 0;

// Info box
infobox_width   = ui_width;
infobox_height  = screen_height - minimap_height - log_height + 10;
infobox_y       = minimap_height - 5;

infobox_hp_height = sprite_get_height(hit_point_bar_spr);
infobox_hp_width  = infobox_width - (text_width * 4);

// Inventory and equipment
tile_container				= noone;
inventory_display_state		= INVENTORY_DISPLAY.EQUIPMENT;
equipment_box_sprite_size	= sprite_get_width(equipment_box_spr);
equipment_hovered_x_pos		= noone;
equipment_hovered_y_pos		= noone;

// Pop-up message
notification_reset();

#endregion

#region// SHADER SET-UP ---------------------------------------------------------------------------
// Colour overlay
uni_overlay		= shader_get_uniform(colour_overlay_shd, "uColour");

// Outline
set_outline_shader_colour();

#endregion

#region// EFFECTS ---------------------------------------------------------------------------------
dust_particles = [];

#endregion

#region// TIME SYSTEM -----------------------------------------------------------------------------

// Timescale constants ----------------------------------------------------------------------------
turns_per_hour	= 30;
hours_per_day	= 24;
timescale_zone  = 1;
timescale_world	= 60;

// Timescale variables ----------------------------------------------------------------------------
time_system = {
	current_turn		: 0,
	game_current_time   : [0, 0, 0],
	timescale			: 0
}

#endregion

// Transition into initial room
transition_set(TRANSITION.GAME_BOOT, C_BLACK);




