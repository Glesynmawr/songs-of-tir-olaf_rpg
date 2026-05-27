
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
	GAME_NEW,
	GAME_QUIT
}

#macro SCREEN_WIDTH  640
#macro SCREEN_HEIGHT 360

#macro ENERGY_PER_TURN 100
#macro LOG_MAX_ENTRIES 9

#macro C_BLACK	make_colour_rgb(0,   0,   0)
#macro C_NAVY	make_colour_rgb(29,  43,  83)
#macro C_MAROON make_colour_rgb(126, 37,  83)
#macro C_GREEN	make_colour_rgb(0,   131, 81)
#macro C_BROWN	make_colour_rgb(171, 82,  54)
#macro C_DKGREY make_colour_rgb(95,  87,  79)
#macro C_LTGREY make_colour_rgb(195, 195, 199)
#macro C_WHITE	make_colour_rgb(255, 241, 232)
#macro C_RED	make_colour_rgb(255, 0,   77)
#macro C_ORANGE make_colour_rgb(255, 163, 0)
#macro C_YELLOW make_colour_rgb(255, 236, 39)
#macro C_LIME	make_colour_rgb(0,   228, 54)
#macro C_BLUE	make_colour_rgb(41,  173, 255)
#macro C_MAUVE	make_colour_rgb(131, 118, 156)
#macro C_PINK	make_colour_rgb(255, 119, 168)
#macro C_PEACH	make_colour_rgb(255, 204, 170)


