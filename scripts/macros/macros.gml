
enum BIOME{
	MOUNTAIN,
	HILL,
	CANYON,
	DESERT,
	SCRUB,
	MARSH,
	FOREST,
	WATER
}

enum BODY_PART{
	HEAD,
	BODY,
	ARMS,
	LEGS
}

enum EQUIP{
	HEAD,
	NECK,
	BODY,
	BACK,
	ARMS,
	HAND,
	MITT,
	GUNS,
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

enum TAG{
	STACKABLE,
	TWO_SLOTS
}

enum TRANSITION{
	CONTROL_MENU,
	CONTROL_EXIT,
	GAME_BOOT,
	GAME_DUNGEON,
	GAME_QUIT,
	GAME_WORLD,
	GAME_ZONE
}


#macro SCREEN_WIDTH  640
#macro SCREEN_HEIGHT 360

#macro ENERGY_PER_TURN 100
#macro LOG_MAX_ENTRIES 8

#macro WORLD_WIDTH	27
#macro WORLD_HEIGHT	16

#macro ZONE_SIZE	39

#macro C_BLACK	 make_colour_rgb(0,   0,   0)
#macro C_WHITE	 make_colour_rgb(255, 255, 255)
#macro C_RED	 make_colour_rgb(189, 60,  43)
#macro C_CYAN	 make_colour_rgb(122, 191, 199)
#macro C_PURPLE	 make_colour_rgb(138, 70,  174)
#macro C_GREEN	 make_colour_rgb(104, 169, 65)
#macro C_BLUE	 make_colour_rgb(50,  39,  140)
#macro C_YELLOW  make_colour_rgb(208, 220, 113)
#macro C_ORANGE  make_colour_rgb(192, 120, 33)
#macro C_BROWN	 make_colour_rgb(92,  71,  0)
#macro C_PINK	 make_colour_rgb(187, 119, 109)
#macro C_DKGREY  make_colour_rgb(85,  85,  85)
#macro C_MIDGREY make_colour_rgb(128, 128, 128)
#macro C_LIME	 make_colour_rgb(172, 234, 136)
#macro C_LTBLUE	 make_colour_rgb(124, 112, 218)
#macro C_LTGREY  make_colour_rgb(171, 171, 171)



