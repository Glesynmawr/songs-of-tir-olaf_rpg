
#region// GAME SETTINGS ENUMS ---------------------------------------------------------------------
enum SETTING{
	AUDIO,
	GRAPHICS,
	GAMEPLAY
}

enum AUDIO_SETTINGS{
	MASTER_GAIN,
	SFX_GAIN,
	MUSIC_GAIN
}

#endregion

#region// BODY PLAN ENUMS -------------------------------------------------------------------------
enum BODY_PRESET{
	BASE,
	HUMANOID,
	QUADRUPED,
	WINGED_BIPED
}

enum BODY_PART_CATEGORY{
	HEAD,
	BODY,
	ARMS,
	LEGS
}

enum HEAD_INDEX{
	FACE,
	HEAD,
	COUNT
}

enum BODY_INDEX{
	AMMO,
	BODY,
	BACK,
	COUNT
}

enum ARMS_INDEX{
	GLOVE,
	BRACER,
	COUNT
}

enum LEGS_INDEX{
	BOOT,
	GREAVE,
	COUNT
}

enum BODY_PART_STATS{
	PART_EXISTS,
	PART_HAS_HAND,
	PART_NAME,
	PART_AUX_SLOT,
	PART_HAND_SLOT,
	PART_SLOT_1,
	PART_SLOT_2,
	PART_SLOT_3
}

#endregion


enum BIOME{
	MOUNTAIN,
	HILL,
	CANYON,
	DESERT,
	SCRUB,
	SWAMP,
	DENSE_MANGROVE,
	WATER,
	MANGROVE,
	MARSH
}

enum DEMEANOUR{
	AGGRESSIVE,
	PASSIVE,
	TIMID
}

enum EQUIP{
	HEAD,
	NECK,
	BODY_PRESET,
	BACK,
	ARMS,
	HAND,
	MITT,
	GUNS,
	FEET
}

enum FACTION{
	AMPHIBIAN_PREY,
	BIRD_PREY,
	MAMMAL_PREY,
	PLAYER,
	REPTILE_PREDATOR
}

enum INVENTORY_DISPLAY{
	EQUIPMENT,
	CONTAINER,
	SHOP
}

enum ITEM_SORT{
	WEAPON_MELEE,
	WEAPON_RANGED,
	AMMO,
	HEAD,
	FACE,
	BODY,
	BACK,
	ARMS,
	HANDS,
	LEGS,
	FEET
}

enum MAP_MODE{
	DUNGEON,
	WORLD,
	ZONE
}

enum MENU{
	MAIN,
	PAUSE,
	DEATH,
	NEXT_LEVEL,
	PREVIOUS_LEVEL
}

enum MOB_LOOKUP{
	DUNGEON,
	ZONE
}

enum NEIGHBOUR_CHECK{
	ORTH,
	DIAG,
	ALL
}

enum SPAWN_LOC{
	FLOOR,
	INVENTORY,
	EQUIPPED
}
	
enum STAT_TYPE{
	CURRENT,
	BASE
}

enum TAG{
	ARROW,
	IS_AMMO,
	MELEE,
	NATURAL,
	RANGED,
	STACKABLE,
	TWO_HANDED,
	UNREMOVABLE,
	UNWEARABLE
}

enum TIME{
	TURN,
	HOUR,
	DAY
}

enum TRANSITION{
	CONTROL_MENU,
	CONTROL_EXIT,
	GAME_BOOT,
	GAME_DUNGEON_ENTER,
	GAME_DUNGEON_EXIT,
	GAME_DUNGEON_NEXT,
	GAME_DUNGEON_PREV,
	GAME_LOAD,
	GAME_QUIT,
	GAME_RESET,
	GAME_START_NEW,
	GAME_WORLD,
	GAME_ZONE
}


#macro SCREEN_WIDTH		640
#macro SCREEN_HEIGHT	360

#macro MAP_WIDTH		30
#macro MAP_HEIGHT		22

#macro WORLD_WIDTH		40
#macro WORLD_HEIGHT		22

#macro ENERGY_PER_TURN	100
#macro LOG_MAX_ENTRIES	10

#macro ZONE_SIZE		48
#macro ITEM_SPRITE_SIZE sprite_get_width(item_size_spr)

#macro C_BLACK	 make_colour_rgb(0,   0,   0)
#macro C_WHITE	 make_colour_rgb(255, 255, 255)
#macro C_RED	 make_colour_rgb(189, 60,  43)
#macro C_CYAN	 make_colour_rgb(122, 191, 199)
#macro C_PURPLE	 make_colour_rgb(138, 70,  174)
#macro C_GREEN	 make_colour_rgb(104, 169, 65)
#macro C_BLUE	 make_colour_rgb(50,  39,  140)
#macro C_YELLOW  $F4DC71
#macro C_ORANGE  make_colour_rgb(192, 120, 33)
#macro C_BROWN	 make_colour_rgb(92,  71,  0)
#macro C_PINK	 make_colour_rgb(187, 119, 109)
#macro C_DKGREY  make_colour_rgb(85,  85,  85)
#macro C_MIDGREY make_colour_rgb(128, 128, 128)
#macro C_LIME	 make_colour_rgb(172, 234, 136)
#macro C_LTBLUE	 make_colour_rgb(124, 112, 218)
#macro C_LTGREY  make_colour_rgb(171, 171, 171)




