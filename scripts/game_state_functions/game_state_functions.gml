
// GAME_STATE
function init_control_menu(){
	is_rebinding_keys	= false;
	current_key_rebind	= 0;
	
	new_controls[0] = controls.key_up;
	new_controls[1] = controls.key_down;
	new_controls[2] = controls.key_left;
	new_controls[3] = controls.key_right;
	new_controls[4] = controls.key_move_confirm;
	new_controls[5] = controls.key_interact_confirm;
	new_controls[6] = controls.key_inventory;
	
	game_state = game_state_control_menu;
}

function init_dungeon(){
	dungeon_map = dungeon_generate();
}

function init_main(){
	resolution_scale();
	
	game_state			= noone;
	game_state_previous = noone;
	
	transition_set(TRANSITION.GAME_BOOT, C_BLACK);
	main_menu_hover = 0;
}
	
function init_world(){
	world_map = world_generate();
}

function game_state_character_select(){
	
}

function game_state_control_menu(){
	if (!is_rebinding_keys){
		if (keyboard_check_pressed(controls.key_cancel)){
			transition_set(TRANSITION.CONTROL_EXIT, bg_colour);
		}
		else if (keyboard_check_pressed(controls.key_up)){
			control_menu_hover --;
			if (control_menu_hover < 0){
				control_menu_hover += array_length(control_menu);
			}
		}
		else if (keyboard_check_pressed(controls.key_down)){
			control_menu_hover ++;
			if (control_menu_hover >= array_length(control_menu)){
				control_menu_hover -= array_length(control_menu);
			}
		}
		else if (keyboard_check_pressed(controls.key_interact_confirm)){
			var txt = control_menu[control_menu_hover];
			if (txt == "Rebind keys"){
				for (var i = 0; i < array_length(new_controls); i ++){
					new_controls[i] = noone;
				}
				is_rebinding_keys = true;
			}
			else if (txt == "Set default keys"){
				controls = variable_clone(controls_default);
				
				new_controls[0] = controls.key_up;
				new_controls[1] = controls.key_down;
				new_controls[2] = controls.key_left;
				new_controls[3] = controls.key_right;
				new_controls[4] = controls.key_move_confirm;
				new_controls[5] = controls.key_interact_confirm;
				new_controls[6] = controls.key_inventory;
			}
			else if (txt == "Save and exit"){
				controls_save_settings();
				transition_set(TRANSITION.CONTROL_EXIT, bg_colour);
			}
		}
	}
	else{
		if (keyboard_check_pressed(controls.key_cancel)){
			is_rebinding_keys	= false;
			new_controls[0] = controls.key_up;
			new_controls[1] = controls.key_down;
			new_controls[2] = controls.key_left;
			new_controls[3] = controls.key_right;
			new_controls[4] = controls.key_move_confirm;
			new_controls[5] = controls.key_interact_confirm;
			new_controls[6] = controls.key_inventory;
		}
		
		if (keyboard_check_pressed(vk_anykey)){
			// Check Assigned Keys for Duplicates
			var can_assign = true;
			if (keyboard_lastkey == vk_escape) can_assign = false;
			for (var i = 0; i < array_length(new_controls); i ++){
				if (new_controls[i] == keyboard_lastkey){
					can_assign = false;
				}
			}
			
			if (can_assign){

				new_controls[current_key_rebind] = keyboard_lastkey;
				current_key_rebind ++;
			
				if (current_key_rebind == array_length(new_controls)){
					is_rebinding_keys = false;
					
					controls.key_up					= new_controls[0];
					controls.key_down				= new_controls[1];
					controls.key_left				= new_controls[2];
					controls.key_right				= new_controls[3];
					controls.key_move_confirm		= new_controls[4];
					controls.key_interact_confirm	= new_controls[5];
					controls.key_inventory			= new_controls[6];
				}
			}
		}
	}
}

function game_state_dungeon(){
	var target_x = floor((actor_registry.player.x_pos * cell_width)  - (screen_width  / 2) + (cell_width  / 2));
	var target_y = floor((actor_registry.player.y_pos * cell_height) - (screen_height / 2) - (cell_height / 2));

	move_camera(target_x, target_y + floor(log_height / 2), 0.1);

	if (!game_paused and transition == noone){
		turn_order_update();
	}
}

function game_state_main_menu(){
	if (keyboard_check_pressed(controls.key_up)){
		main_menu_hover --;
		if (main_menu_hover < 0){
			main_menu_hover += array_length(main_menu);
		}
	}
	else if (keyboard_check_pressed(controls.key_down)){
		main_menu_hover ++;
		if (main_menu_hover >= array_length(main_menu)){
			main_menu_hover -= array_length(main_menu);
		}
	}
	else if (keyboard_check_pressed(controls.key_interact_confirm)){
		var txt = main_menu[main_menu_hover];
		if (txt == "New game"){
			transition_set(TRANSITION.GAME_WORLD, bg_colour);
		}
		else if (txt == "Load game"){
			
		}
		else if (txt == "Controls"){
			game_state_previous = game_state;
			transition_set(TRANSITION.CONTROL_MENU, bg_colour);
		}
		else if (txt == "Settings"){
			
		}
		else if (txt == "Quit to desktop"){
			transition_set(TRANSITION.GAME_QUIT, C_BLACK);
		}
	}
}

function game_state_pause_menu(){
	if (keyboard_check_pressed(controls.key_up)){
		pause_menu_hover --;
		if (pause_menu_hover < 0){
			pause_menu_hover += array_length(pause_menu);
		}
	}
	else if (keyboard_check_pressed(controls.key_down)){
		pause_menu_hover ++;
		if (pause_menu_hover >= array_length(pause_menu)){
			pause_menu_hover -= array_length(pause_menu);
		}
	}
	else if (keyboard_check_pressed(controls.key_interact_confirm)){
		var txt = pause_menu[pause_menu_hover];
		if (txt == "Continue"){
			game_state = game_state_previous;
		}
		else if (txt == "Controls"){
			transition_set(TRANSITION.CONTROL_MENU, bg_colour);
		}
		else if (txt == "Settings"){
			
		}
		else if (txt == "Save and quit"){
			
		}
		else if (txt == "Quit without saving"){
			transition_set(TRANSITION.GAME_BOOT, bg_colour);
		}
		else if (txt == "Quit to desktop"){
			transition_set(TRANSITION.GAME_QUIT, C_BLACK);
		}
	}
}

function game_state_world(){
	if (!game_paused and transition == noone){
		turn_order_update();
	}
}




