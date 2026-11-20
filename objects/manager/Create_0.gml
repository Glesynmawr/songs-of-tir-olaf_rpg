/// @desc Initialise 

global.version = [6, 10, 25];

//randomise();
debugging_mode		= false;
game_paused			= false;
transition			= noone;

audio_group_load(audiogroup_sfx);

#region// COLOURS ---------------------------------------------------------------------------------
colour_text_main	= C_LTGREY;
colour_bg_main		= make_colour_rgb(0, 30, 0);

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
melee_base_hit_modifier = 0;
range_base_hit_modifier = 0;
wander_chance			= 0.3;

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

// INSECTOID
body_plan_presets[BODY_PRESET.INSECTOID][BODY_PART_CATEGORY.HEAD] = [[true, false, "Head"], [false, false, "Left head"], [false, false, "Right head"]];
body_plan_presets[BODY_PRESET.INSECTOID][BODY_PART_CATEGORY.BODY] = [[true, false, "Body"]];
body_plan_presets[BODY_PRESET.INSECTOID][BODY_PART_CATEGORY.ARMS] = [[false, false, "Right arm"], [false, false, "Left arm"], [false, false, "Right front arm"], [false, false, "Left front arm"], [false, false, "Right rear arm"], [false, false, "Left rear arm"]];
body_plan_presets[BODY_PRESET.INSECTOID][BODY_PART_CATEGORY.LEGS] = [[true,  false, "Right leg"], [true,  false, "Left leg"], [true,  false, "Right front leg"], [true,  false, "Left front leg"], [true,  false, "Right rear leg"], [true,  false, "Left rear leg"]];

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

#region// DIALOGUE --------------------------------------------------------------------------------
dialogue_text_init();
quest_dialogue_init()

dialogue = noone;

dialogue_x = screen_width  / 2;
dialogue_y = screen_height / 2;
dialogue_w = 250;
dialogue_h = 100;

#endregion

#region// FACTIONS --------------------------------------------------------------------------------

// Faction overrides
faction_override[FACTION.AMPHIBIAN_PREY]	= [];
faction_override[FACTION.BIRD_PREY]			= [[FACTION.AMPHIBIAN_PREY, 20]];
faction_override[FACTION.MAMMAL_PREY]		= [[FACTION.AMPHIBIAN_PREY, 20], [FACTION.MAMMAL_PREY, 20]];
faction_override[FACTION.PLAYER]			= [];
faction_override[FACTION.REPTILE_PREDATOR]	= [];

#endregion

#region// INVENTORY SETUP -------------------------------------------------------------------------

inventory_display_state		= INVENTORY_DISPLAY.EQUIPMENT;
tile_container				= noone;
inv_display_max		= 20;

// Inventory position
inventory_x		= floor(screen_width / 3);
inventory_y		= 0;
inventory_w		= ceil(screen_width / 3);
inventory_h		= screen_height;

// Scroll bar
scroll_x			= inventory_x + 2;
scroll_y			= (text_height * 4);
scroll_h			= (inv_display_max * ITEM_SPRITE_SIZE) + (2 * 3);
scroll_w			= 8;
scroll_fill_max		= inv_display_max * ITEM_SPRITE_SIZE;

// Equipment position
equipment_x					= 0;
equipment_y					= 0;
equipment_w					= floor(screen_width / 3);
equipment_h					= screen_height;
equipment_box_size			= 20;
equipment_hovered_x_pos		= noone;
equipment_hovered_y_pos		= noone;

// Character position
character_x	= equipment_w + inventory_w;
character_y	= 0;
character_w = floor(screen_width / 3);
character_h = screen_height;

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
	key_look_state:			vk_backspace,
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
ui_border = 5;

globalvar game_settings;
game_settings[SETTING.AUDIO][AUDIO_SETTINGS.MASTER_GAIN]	= 1;
game_settings[SETTING.AUDIO][AUDIO_SETTINGS.SFX_GAIN]		= 1;
game_settings[SETTING.AUDIO][AUDIO_SETTINGS.MUSIC_GAIN]		= 1;

ui_settings = {
	ui_x_position			: 0,
	move_bounce_amplitude	: 3,
	
	minimap_title_text		: "",
	minimap_sub_text		: "",
	game_grid_cells_width	: MAP_WIDTH,
	game_grid_cells_height	: MAP_HEIGHT
}

// UI constants -----------------------------------------------------------------------------------
ui_width		= 160;

// UI flipping values
ui_x_pos[0][0]	= screen_width - ui_width;
ui_x_pos[0][1]	= 0;
ui_x_pos[1][0]	= 0;
ui_x_pos[1][1]	= ui_width;

// Info box
infobox_width   = ui_width;
infobox_height  = screen_height;
infobox_y       = 0;

// Minimap
minimap_scale	= 2;
minimap_surface = noone;
minimap_width	= 107;
minimap_height	= 107;
minimap_y		= 0;

// Day/night indicator
day_night_surface	= noone;
sun_moon_distance_x	= 19;
sun_moon_distance_y = 15;
day_night_x_pos		= minimap_width - ui_border;
day_night_width		= sprite_get_width(day_night_background_spr);
day_night_height	= sprite_get_height(day_night_background_spr);

// Player stats
stats_x = minimap_width - ui_border;
stats_y = day_night_height + ui_border + 1;
stats_w = infobox_width - minimap_width + (ui_border);
stats_h = minimap_height - stats_y;

// Player hit points
hp_y_pos	= minimap_height + ui_border;
hp_height	= sprite_get_height(fill_bar_spr);
hp_width	= infobox_width - (ui_border * 4);

// Player experience points
xp_y_pos	= hp_y_pos + hp_height + ui_border;
xp_height	= sprite_get_height(fill_bar_spr);
xp_width	= hp_width;

// Player carry weight and move speed
speed_y_pos		= xp_y_pos + hp_height + ui_border;
weight_y_pos	= speed_y_pos + text_height;

// Hand-held items
held_items_y_pos	= weight_y_pos + (ui_border * 2);
held_items_w_max	= floor((infobox_width - (ui_border * 2)) / equipment_box_size);
var width_px		= held_items_w_max * equipment_box_size;
held_items_x_pos	= floor((infobox_width - width_px) / 2);

// Game log
log_surface = noone;
log_height	= (LOG_MAX_ENTRIES + 2) * text_height;

log_surface_width  = ui_width - (text_width * 4);
log_surface_height = log_height - (text_height * 2);

// Pop-up message
notification_reset();

// Warnings
current_warning = noone;
warning_set("Warning! Your butt is hanging out!", C_RED, true, 3)

#endregion

#region// SHADER SET-UP ---------------------------------------------------------------------------
// Colour overlay
uni_overlay		= shader_get_uniform(colour_overlay_shd, "uColour");

// Outline
set_outline_shader_colour();

#endregion

#region// EFFECTS ---------------------------------------------------------------------------------
map_particles	= [];
ui_particles	= [];

#endregion

#region// TIME SYSTEM -----------------------------------------------------------------------------

// Timescale constants ----------------------------------------------------------------------------
turns_per_hour	= (ZONE_SIZE / 2);
hours_per_day	= 24;
turns_per_day	= turns_per_hour * hours_per_day;
timescale_zone  = 1;
timescale_world	= ZONE_SIZE;

// Timescale record -------------------------------------------------------------------------------
time_system = {
	game_current_time   : [0, 0, 0],
	timescale			: 0,
	map_is_underground  : false,
}

#endregion

#region// LIGHTING --------------------------------------------------------------------------------
light_time_offset	= -6;
light_height_offset = 8;
world_lighting		= 0;

world_light_min = 2;
world_light_max = ceil(MAP_WIDTH / 2);

#endregion

// Transition into initial room
transition_set(TRANSITION.GAME_BOOT, C_BLACK);




