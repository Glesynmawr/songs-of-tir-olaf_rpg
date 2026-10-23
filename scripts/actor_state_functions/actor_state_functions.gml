
// ACTOR STATES -----------------------------------------------------------------------------------
function state_ready_for_inputs(){
	var player_moved = false;
	
	// Open in-game menu
	if (keyboard_check_pressed(controls.key_cancel)){
		with (manager){
			pause_menu_hover = 0;
			game_state.state_previous = game_state.state_main;
			game_state.state_main = game_state_pause_menu;
			exit;
		}
	}
	
	// Open inventory
	if (keyboard_check_pressed(controls.key_inventory) and manager.game_state.state_main != game_state_world){
		state = state_inventory;
		exit;
	}
	
	// MOVEMENT -----------------------------------------------------------------------------------
	// Direction inputs
	var x_move = keyboard_check(controls.key_right) - keyboard_check(controls.key_left)
	var y_move = keyboard_check(controls.key_down) - keyboard_check(controls.key_up)
	
	var move_dir = input_direction(x_move, y_move);
	if (move_dir != noone){
		
		// Set manager direction indicator
		with (manager) game_state.direction_indicator = move_dir;
		
		// Movement
		if (keyboard_check(controls.key_move_confirm)){
			if (manager.move_timer <= 0){
				var xx = manager.cell_x_neighbours[move_dir];
				var yy = manager.cell_y_neighbours[move_dir];
				player_moved = action_move(manager.game_state.game_grid, xx, yy);
				manager.move_timer = manager.move_timer_max;
			}
			else {
				manager.move_timer --;
			}
		}
		else{
			with (manager){
				if (move_timer != 0){
					move_timer = 0;
				}
			}
		}
		
		// DIRECTIONAL CELL INTERACTION -----------------------------------------------------------
		if (keyboard_check_pressed(controls.key_interact_confirm)){
			if (manager.game_state.game_grid[x_pos + x_move][y_pos + y_move].tile == "secret door"){
				found_a_secret(self);
			}
			player_moved = tile_interaction(self, x_pos + x_move, y_pos + y_move);
		}
	}
	else{
		
		// Reset direction indicator
		with (manager){
			if (game_state.direction_indicator != noone) game_state.direction_indicator = noone;
		}
		
		// NON-DIRECTIONAL CELL INTERACTION -------------------------------------------------------
		if (keyboard_check_pressed(controls.key_interact_confirm)){
			
			// Pickup items
			var items_exist = false;
			if (struct_exists(manager.game_state.game_grid[x_pos][y_pos], "items")){
				if (array_length(manager.game_state.game_grid[x_pos][y_pos].items) > 0){
					items_exist = true;
					pickup_menu_initialise(self);
				}
			}
			if (!items_exist){
				
				// Interact with tile
				player_moved = tile_interaction(self, x_pos, y_pos);
			}
		}
		
		// MOVE BETWEEN ZONE AND WORLD MAPS -------------------------------------------------------
		else if (keyboard_check_pressed(controls.key_map_mode)){
			
			// Move from WORLD to ZONE
			if (manager.game_state.game_grid == manager.game_state.world_map){
				with(manager){
					transition_set(TRANSITION.GAME_ZONE, colour_bg_main);
				}
			}
			
			// Move from ZONE to WORLD
			else if (manager.game_state.game_grid == manager.game_state.zone_map[world_x][world_y]){
				
				// Check for mobs hostile to this actor
				var hostile_mobs = passive_check_for_hostile_mobs();
				if (hostile_mobs){
					var txt = $"{self.name} can't leave with hostiles present!";
					log_add_entry(txt, manager.colour_text_main);
				}
				else{
					with(manager){
						transition_set(TRANSITION.GAME_WORLD, colour_bg_main);
					}
				}
			}
		}
		
		if (manager.game_state.game_grid != manager.game_state.world_map){
		
			// SWAP HELD ITEMS
			if (keyboard_check_pressed(controls.key_item_swap)){
				player_swap_items(self);
			}
		
			// ENTER LOOK/TARGET STATE
			else if (keyboard_check_pressed(controls.key_look_state)){
				state_init_look();
			}
		}
	}
	
	// IF PLAYER HAS MOVED ------------------------------------------------------------------------
	if (player_moved){
		
		manager.actor_registry.player.player_steps ++;
		
		with (manager){
			warning_decrement_duration();
		}
		
		// Set has-acted flag
		has_acted = true;
		
		// Update world position
		if (manager.game_state.map_mode == MAP_MODE.WORLD){
			world_x = x_pos;
			world_y = y_pos;
		}
		
		// Check for map edge in zone mode
		if (manager.game_state.map_mode ==	MAP_MODE.ZONE){
			if (x_pos == 0){
				if (world_x > 0){
					
					// Reset visibility on current map
					grid_set_visible(manager.game_state.game_grid, false)
					
					// Move world grid position
					world_x --;
					
					// Set game_state.game_grid to new zone
					goto_zone(world_x, world_y, ZONE_SIZE - 2, y_pos);
				}
			}
			else if (x_pos == ZONE_SIZE - 1){
				if (world_x < array_length(manager.game_state.world_map) - 1){
					
					// Reset visibility on current map
					grid_set_visible(manager.game_state.game_grid, false)
					
					// Move world grid position
					world_x ++;
					
					// Set game_state.game_grid to new zone
					goto_zone(world_x, world_y, 1, y_pos);
				}
			}
			if (y_pos == 0){
				if (world_y > 0){

					// Reset visibility on current map
					grid_set_visible(manager.game_state.game_grid, false)
					
					// Move world grid position
					world_y --;
					
					// Set game_state.game_grid to new zone
					goto_zone(world_x, world_y, x_pos, ZONE_SIZE - 2);
				}
			}
			else if (y_pos == ZONE_SIZE - 1){
				if (world_y < array_length(manager.game_state.world_map[0]) - 1){
					
					// Reset visibility on current map
					grid_set_visible(manager.game_state.game_grid, false)
					
					// Move world grid position
					world_y ++;
					
					// Set game_state.game_grid to new zone
					goto_zone(world_x, world_y, x_pos, 1);
				}
			}
		}
		
		// Update player LOS
		set_player_los(other.game_state.game_grid, self);
		
		// Update player distance map
		distance_map_player = create_distance_map(manager.game_state.game_grid, x_pos, y_pos);
	}
}

function state_idle(){
	if (!passive_state_update()){
		passive_check_actor_in_los();
	}
	
	has_acted = true;
}

function state_chase(){
	
	if (x_pos == target_x and y_pos == target_y){
		log_add_entry($"{name} has lost track of {target_actor.name}.", C_YELLOW); 
		state = state_base;
		passive_actor_reset_target();
		has_acted = true;
		return;
	}
	
	// Check if LoS to target
	if (target_actor == noone){
		state = state_base;
		has_acted = true;
		return;
	}
	
	var has_los = draw_los_line(manager.game_state.game_grid, x_pos, y_pos, target_actor.x_pos, target_actor.y_pos);
	
	// Check target in range
	var dist_x = abs(x_pos - target_actor.x_pos);
	var dist_y = abs(y_pos - target_actor.y_pos);
	
	if (has_los and dist_x <= range and dist_y <= range){
		
		// Set distance map and target position
		if (target_actor.x_pos != target_x or target_actor.y_pos != target_y){
			target_x	= target_actor.x_pos;
			target_y	= target_actor.y_pos;
			target_map	= create_distance_map(manager.game_state.game_grid, target_x, target_y);
		}
	}
	
	// Find lowest distance value of neighbours
	var lowest_dist = 10000;
	for (var i = 0; i < 8; i ++){
		var target_pos_x = x_pos + manager.cell_x_neighbours[i];
		var target_pos_y = y_pos + manager.cell_y_neighbours[i];
		
		if (grid_check_position_in_bounds(manager.game_state.game_grid, target_pos_x, target_pos_y)){
			if (target_map[target_pos_x][target_pos_y] < lowest_dist){
				lowest_dist = target_map[target_pos_x][target_pos_y];
			}
		}
	}
	
	// Make list of unoccupied neighbours with lowest value
	var candidate_list = [];
	for (i = 0; i < 8; i ++){
		var target_pos_x = x_pos + manager.cell_x_neighbours[i];
		var target_pos_y = y_pos + manager.cell_y_neighbours[i];
		
		if (grid_check_position_in_bounds(manager.game_state.game_grid, target_pos_x, target_pos_y)){
			if (target_map[target_pos_x][target_pos_y] <= lowest_dist){
				array_push(candidate_list, [manager.cell_x_neighbours[i], manager.cell_y_neighbours[i]]);
			}
		}
	}
	
	// Choose movement direction from candidate list
	var len = array_length(candidate_list);
	if (len > 0){
		var choice = irandom(len - 1);
		
		// execute move
		action_move(manager.game_state.game_grid, candidate_list[choice][0], candidate_list[choice][1]);
	}
	
	has_acted = true;
}

function state_flee(){
	
	// Set distance map and target position
	if (target_actor.x_pos != target_x or target_actor.y_pos != target_y){
		target_x = target_actor.x_pos;
		target_y = target_actor.y_pos;
		target_map = create_distance_map(manager.game_state.game_grid, target_x, target_y);
	}	
	
	// Find highest distance value of neighbours
	var highest_dist = 0;
	for (var i = 0; i < 8; i ++){
		var target_pos_x = x_pos + manager.cell_x_neighbours[i];
		var target_pos_y = y_pos + manager.cell_y_neighbours[i];
		
		var is_in_bounds	= grid_check_position_in_bounds(manager.game_state.game_grid, target_pos_x, target_pos_y);
		var is_walkable		= grid_check_tile_is_walkable(manager.game_state.game_grid, target_pos_x, target_pos_y);
		var cell_has_actor	= grid_check_position_contains_actor(target_pos_x, target_pos_y)
		
		if (is_in_bounds and is_walkable and cell_has_actor == noone){
			if (target_map[target_pos_x][target_pos_y] > highest_dist){
				highest_dist = target_map[target_pos_x][target_pos_y];
			}
		}
		else if (!is_in_bounds){
			has_acted = true;
			action_remove_actor(self, false);
			exit;
		}
	}
	
	// Make list of unoccupied neighbours with lowest value
	var candidate_list = [];
	for (i = 0; i < 8; i ++){
		var target_pos_x = x_pos + manager.cell_x_neighbours[i];
		var target_pos_y = y_pos + manager.cell_y_neighbours[i];
		
		var is_in_bounds	= grid_check_position_in_bounds(manager.game_state.game_grid, target_pos_x, target_pos_y);
		var is_walkable		= grid_check_tile_is_walkable(manager.game_state.game_grid, target_pos_x, target_pos_y);
		var cell_has_actor	= grid_check_position_contains_actor(target_pos_x, target_pos_y)
		
		if (is_in_bounds and is_walkable and cell_has_actor == noone){
			if (target_map[target_pos_x][target_pos_y] >= highest_dist){
				array_push(candidate_list, [manager.cell_x_neighbours[i], manager.cell_y_neighbours[i]]);
			}
		}
	}
	
	// Choose movement direction from candidate list
	var len = array_length(candidate_list);
	if (len > 0){
		var choice = irandom(len - 1);
		
		// Execute move
		action_move(manager.game_state.game_grid, candidate_list[choice][0], candidate_list[choice][1]);
	}
	
	// Player position
	var player_x = manager.actor_registry.player.x_pos;
	var player_y = manager.actor_registry.player.y_pos;
	
	// Visibility of player
	var dist     = target_map[x_pos][y_pos];
	var in_sight = draw_los_line(manager.game_state.game_grid, x_pos, y_pos, player_x, player_y);
	if (!in_sight and dist > range){
		player_spotted = false;
		passive_actor_reset_target();
		state = state_base;
	}
	has_acted = true;
}

function state_wander(){
	
	if (!passive_state_update()){
		var chance_to_move = random(1);
		if (chance_to_move < manager.wander_chance){
			
			var dir = irandom(7);
			var move_x = manager.cell_x_neighbours[dir];
			var move_y = manager.cell_y_neighbours[dir];
			
			var move_target_x = x_pos + move_x;
			var move_target_y = y_pos + move_y;
			
			var is_in_bounds	= grid_check_position_in_bounds(manager.game_state.game_grid, move_target_x, move_target_y, 2);
			var is_walkable		= grid_check_tile_is_walkable(manager.game_state.game_grid, move_target_x, move_target_y);
			var cell_has_actor	= grid_check_position_contains_actor(move_target_x, move_target_y)
		
			if (is_in_bounds and is_walkable and cell_has_actor == noone){
				action_move(manager.game_state.game_grid, move_x, move_y);
			}
		}
		
		passive_check_actor_in_los();
	}
	
	has_acted = true;
}


// ACTOR STATE LOOK -------------------------------------------------------------------------------
function state_look(){
	
	// Exit look state
	if (keyboard_check_pressed(controls.key_cancel)){
		look_mode	= noone;
		state		= state_ready_for_inputs;
	}
	
	with (look_mode){
		image_index += anim_speed;
		if (image_index >= sprite_get_number(sprite_index)){
			image_index -= sprite_get_number(sprite_index);
		}
		
		var target_x = cell_x * manager.cell_width;
		var target_y = cell_y * manager.cell_height;
		
		if (sprite_x != target_x) sprite_x += (target_x - sprite_x) * 0.2;
		if (sprite_y != target_y) sprite_y += (target_y - sprite_y) * 0.2;
		
		var move_x = keyboard_check(controls.key_right) - keyboard_check(controls.key_left);
		var move_y = keyboard_check(controls.key_down)  - keyboard_check(controls.key_up);
			
		var move_dir = input_direction(move_x, move_y);
		if (move_dir != noone){
			
			manager.move_timer --;
			if (manager.move_timer <= 0){
				cell_x += manager.cell_x_neighbours[move_dir];
				cell_y += manager.cell_y_neighbours[move_dir];
				manager.move_timer = manager.move_timer_max;
			}
			
			cell_x = clamp(cell_x, x_from, x_to);
			cell_y = clamp(cell_y, y_from, y_to);
			
			// Get data
			look_pages = cell_get_data(cell_x, cell_y);
			if (look_hover >= array_length(look_pages)){
				look_hover = array_length(look_pages) - 1;
			}
		}
		else{
			manager.move_timer = 0;
		}
		if (keyboard_check_pressed(controls.key_item_swap)){
			look_hover ++;
			if (look_hover >= array_length(look_pages)){
				look_hover = 0;
			}
		}
		if (keyboard_check_pressed(controls.key_interact_confirm)){
			
			if (is_array(look_pages)){
				if (look_pages[0][0] == "actor"){
					action_attack_ranged(other, look_pages[0][1]);
				}
			}
		}
	}
}

function state_init_look(){
	
	var ww = array_length(manager.game_state.game_grid);
	var hh = array_length(manager.game_state.game_grid[0]);
			
	var x_clamp_from	= max(x_pos - range, 0);
	var y_clamp_from	= max(y_pos - range, 0);
	var x_clamp_to		= min(x_pos + range, ww - 1);
	var y_clamp_to		= min(y_pos + range, hh - 1);
	
	look_mode = {
		cell_x:			x_pos,
		cell_y:			y_pos,
		
		x_from:			x_clamp_from,
		y_from:			y_clamp_from,
		x_to:			x_clamp_to,
		y_to:			y_clamp_to,
		
		sprite_x:		x_pos * manager.cell_width,
		sprite_y:		y_pos * manager.cell_height,
		sprite_index:	equipment_box_spr,
		image_index:	0,
		anim_speed:		sprite_get_speed(equipment_box_spr) / game_get_speed(gamespeed_fps),
		
		look_pages:		cell_get_data(x_pos, y_pos),
		look_hover:		0,
	}
	
	state = state_look;
}

function cell_get_data(cell_x, cell_y){

	if (!grid_check_position_in_bounds(manager.game_state.game_grid, cell_x, cell_y)){
		return(noone);
	}

	with (manager){
		
		var look_data = [];
		
		// Background and border
		var xx = ui_x_pos[ui_settings.ui_x_position][0];
		var yy = infobox_y;
	
		var key_exit	= keybinding_get_text(controls.key_cancel);
	
		var control_text = $"{key_exit} to exit";
	
		ui_draw_box(xx, yy, infobox_width, infobox_height, "Looking at -", control_text);
				
		// Get cell position
		var actor	= noone;
		var tile	= noone;
		var items	= noone;
		
		// Get actor data
		for (var i = 0; i < array_length(actor_registry.actor_list); i ++){
					
			var actor_x = actor_registry.actor_list[i].x_pos;
			var actor_y = actor_registry.actor_list[i].y_pos;
					
			if (actor_x == cell_x and actor_y == cell_y){
				actor = actor_registry.actor_list[i];
			}
		}
				
		// Get tile data
		tile = game_state.game_grid[cell_x][cell_y];
				
		// Get item data
		if (array_length(tile.items) > 0){
			items = tile.items;
		}
		
		if (actor != noone){
			array_push(look_data, ["actor", actor]);
		}
		if (items != noone){
			array_push(look_data, ["items", items]);
		}
		if (tile != noone){
			array_push(look_data, ["tile", tile]);
		}
		
		return(look_data);
	}
}


// ACTOR STATE INVENTORY
function state_inventory(){
	
	// Toggle between inventory/equipment
	if (keyboard_check_pressed(controls.key_item_swap)) inventory.selected ++;
	if (inventory.selected > 1) inventory.selected = 0;
	
	// Exit inventory state
	if (keyboard_check_pressed(controls.key_cancel) or keyboard_check_pressed(controls.key_inventory)){
		state = state_ready_for_inputs;
		manager.inventory_display_state	= INVENTORY_DISPLAY.EQUIPMENT
	}
	
	
	// INVENTORY CONTROL --------------------------------------------------------------------------
	if (inventory.selected == 1){
		inventory_control();
	}
	
	// EQUIPMENT CONTROL --------------------------------------------------------------------------
	else {
		if (manager.inventory_display_state	== INVENTORY_DISPLAY.EQUIPMENT){
			equipment_control();
		}
		else if (manager.inventory_display_state	== INVENTORY_DISPLAY.CONTAINER){
			container_control();
		}
	}
}

// Inventory menu control
function inventory_control(){
	var len = array_length(inventory.items);
		
	if (keyboard_check(controls.key_up)){
		manager.move_timer --;
		if (manager.move_timer <= 0){
			// Move up inventory
			inventory.inv_hover --;
			if (inventory.inv_hover < 0){
				inventory.inv_hover += len;
			}
			manager.move_timer = manager.move_timer_max;
		}
	}    
	else if (keyboard_check(controls.key_down)){
		manager.move_timer --;
		if (manager.move_timer <= 0){
			// Move down inventory
			inventory.inv_hover ++;
			if (inventory.inv_hover >= len){
				inventory.inv_hover -= len;
			}
			manager.move_timer = manager.move_timer_max;
		}
	}
	else if (keyboard_check_pressed(controls.key_interact_confirm)){
		if (len > 0 and inventory.context_menu == noone){
			context_menu_initialise();
		}
	}
	else{
		if (manager.move_timer != 0){
			manager.move_timer = 0;
		}
	}
}

function equipment_control(){
	
	if (keyboard_check_pressed(controls.key_up)){
			
		// Move up inventory
		var slot_relative_position = BODY_PART_STATS.PART_AUX_SLOT + (array_length(body_plan[inventory.equ_hover[0]][inventory.equ_hover[1]]) - inventory.equ_hover[2]);
		var prev_slot = body_part_find_prev_exists(self, inventory.equ_hover[0], inventory.equ_hover[1])
		if (prev_slot != noone){
			inventory.equ_hover[0] = prev_slot[0];
			inventory.equ_hover[1] = prev_slot[1];
				
			var new_slot_relative_position = BODY_PART_STATS.PART_AUX_SLOT + (array_length(body_plan[inventory.equ_hover[0]][inventory.equ_hover[1]]) - inventory.equ_hover[2]);
			if (new_slot_relative_position != slot_relative_position){
				inventory.equ_hover[2] += new_slot_relative_position - slot_relative_position;
			}
				
			var min_slot = body_part_find_min_slot(self, inventory.equ_hover[0], inventory.equ_hover[1])
			if (inventory.equ_hover[2] < min_slot) inventory.equ_hover[2] = min_slot;
				
			var max_slot = array_length(body_plan[inventory.equ_hover[0]][inventory.equ_hover[1]]) - 1;
			if (inventory.equ_hover[2] > max_slot){
				inventory.equ_hover[2] = max_slot
			}
		}
	}
	else if (keyboard_check_pressed(controls.key_down)){
			
		// Move down inventory
		var slot_relative_position = BODY_PART_STATS.PART_AUX_SLOT + (array_length(body_plan[inventory.equ_hover[0]][inventory.equ_hover[1]]) - inventory.equ_hover[2]);
		var next_slot = body_part_find_next_exists(self, inventory.equ_hover[0], inventory.equ_hover[1])
		if (next_slot != noone){
			inventory.equ_hover[0] = next_slot[0];
			inventory.equ_hover[1] = next_slot[1];

			var new_slot_relative_position = BODY_PART_STATS.PART_AUX_SLOT + (array_length(body_plan[inventory.equ_hover[0]][inventory.equ_hover[1]]) - inventory.equ_hover[2]);
			if (new_slot_relative_position != slot_relative_position){
				inventory.equ_hover[2] += new_slot_relative_position - slot_relative_position;
			}
				
			var min_slot = body_part_find_min_slot(self, inventory.equ_hover[0], inventory.equ_hover[1])
			if (inventory.equ_hover[2] < min_slot) inventory.equ_hover[2] = min_slot;
				
			var max_slot = array_length(body_plan[inventory.equ_hover[0]][inventory.equ_hover[1]]) - 1;
			if (inventory.equ_hover[2] > max_slot){
				inventory.equ_hover[2] = max_slot
			}
		}
	}
	else if (keyboard_check_pressed(controls.key_right)){
		var max_slot = array_length(body_plan[inventory.equ_hover[0]][inventory.equ_hover[1]]);
		var min_slot = body_part_find_min_slot(self, inventory.equ_hover[0], inventory.equ_hover[1])
			
		inventory.equ_hover[2] --;
		if (inventory.equ_hover[2] < min_slot){
			inventory.equ_hover[2] = max_slot - 1;
		}
	}
	else if (keyboard_check_pressed(controls.key_left)){
		var max_slot = array_length(body_plan[inventory.equ_hover[0]][inventory.equ_hover[1]]);
		var min_slot = body_part_find_min_slot(self, inventory.equ_hover[0], inventory.equ_hover[1])
			
		inventory.equ_hover[2] ++;
		if (inventory.equ_hover[2] >= max_slot){
			inventory.equ_hover[2] = min_slot;
		}
	}
	else if (keyboard_check_pressed(controls.key_interact_confirm)){
		if (inventory.context_menu == noone){
			equipment_context_menu_initialise();
		}
	}
}

function container_control(){
	var len = array_length(manager.tile_container.inventory);
		
	if (keyboard_check(controls.key_up)){
		manager.move_timer --;
		if (manager.move_timer <= 0){
			// Move up inventory
			manager.tile_container.inv_hover --;
			if (manager.tile_container.inv_hover < 0){
				manager.tile_container.inv_hover += len;
			}
			manager.move_timer = manager.move_timer_max;
		}
	}    
	else if (keyboard_check(controls.key_down)){
		manager.move_timer --;
		if (manager.move_timer <= 0){
			// Move down inventory
			manager.tile_container.inv_hover ++;
			if (manager.tile_container.inv_hover >= len){
				manager.tile_container.inv_hover -= len;
			}
			manager.move_timer = manager.move_timer_max;
		}
	}
	else if (keyboard_check_pressed(controls.key_interact_confirm)){
		if (len > 0 and inventory.context_menu == noone){
			context_menu_initialise();
		}
	}
	else{
		if (manager.move_timer != 0){
			manager.move_timer = 0;
		}
	}
}

// Inventory sub-menu control states
function state_context_menu(){
	var len = array_length(inventory.context_menu[0]);
	
	if (keyboard_check_pressed(controls.key_cancel) or keyboard_check_pressed(controls.key_inventory)){
		
		// Exit context menu
		inventory.context_menu = noone;
		state = state_inventory;
	}
	else if (keyboard_check_pressed(controls.key_up)){
		inventory.context_menu[5] --;
		if (inventory.context_menu[5] < 0){
			inventory.context_menu[5] += len;
		}
	}
	else if (keyboard_check_pressed(controls.key_down)){
		inventory.context_menu[5] ++;
		if (inventory.context_menu[5] >= len){
			inventory.context_menu[5] -= len;
		}
	}
	else if (keyboard_check_pressed(controls.key_interact_confirm)){
		
		// Inventory or equipment
		if (inventory.context_menu[0][inventory.context_menu[5]] == "Drop" or inventory.context_menu[0][inventory.context_menu[5]] == "Drop One"){
			
			var number_to_drop = 1;
			if (inventory.selected == 1){
				
				// Spawn item on ground
				spawn_existing_item(inventory.items[inventory.inv_hover], number_to_drop, x_pos, y_pos);
		
				// DROP item
				inventory_drop_slot(self, inventory.inv_hover, 1);
			}
			else{
				var target_cat     = inventory.equ_hover[0];
				var target_ind     = inventory.equ_hover[1];
				var target_slot    = inventory.equ_hover[2];
				
				var item_to_move = variable_clone(body_plan[target_cat][target_ind][target_slot]);
				
				spawn_existing_item(item_to_move, , x_pos, y_pos);
				equipment_drop_slot(self, number_to_drop, target_cat, target_ind, target_slot)
			}
			// Exit context menu
			inventory.context_menu = noone;
			state = state_inventory;
		}
		else if (inventory.context_menu[0][inventory.context_menu[5]] == "Drop All"){
			
			var number_to_drop = inventory.items[inventory.inv_hover].stack;
			if (inventory.selected == 1){
				
				// Spawn item on ground
				spawn_existing_item(inventory.items[inventory.inv_hover], number_to_drop, x_pos, y_pos);
		
				// DROP item
				inventory_drop_slot(self, inventory.inv_hover, number_to_drop);
			}
			else{
				var target_cat     = inventory.equ_hover[0];
				var target_ind     = inventory.equ_hover[1];
				var target_slot    = inventory.equ_hover[2];
				
				var item_to_move = variable_clone(body_plan[target_cat][target_ind][target_slot]);
				
				spawn_existing_item(item_to_move, number_to_drop, x_pos, y_pos);
				equipment_drop_slot(self, number_to_drop, target_cat, target_ind, target_slot)
			}
			// Exit context menu
			inventory.context_menu = noone;
			state = state_inventory;
		}
		else if (inventory.context_menu[0][inventory.context_menu[5]] == "Equip"){
			
			// Initialise slot select menu
			equipment_slot_select_initialise();
		}
		else if (inventory.context_menu[0][inventory.context_menu[5]] == "Remove"){
			// Equipment only
			var target_cat     = inventory.equ_hover[0];
			var target_ind     = inventory.equ_hover[1];
			var target_slot    = inventory.equ_hover[2];
				
			var item_to_move = variable_clone(body_plan[target_cat][target_ind][target_slot]);
			
			inventory_add_item(self, item_to_move, item_to_move.stack);
			body_plan[target_cat][target_ind][target_slot] = noone;
			
			// Exit context menu
			inventory.context_menu = noone;
			state = state_inventory;
		}
		else if (inventory.context_menu[0][inventory.context_menu[5]] == "Hold"){
			// Initialise slot select menu
			hold_slot_select_initialise();
		}
		else if (inventory.context_menu[0][inventory.context_menu[5]] == "Store"){
			// Store item in container
			if (container_add_item(self, manager.tile_container)){
				inventory_drop_slot(self, inventory.inv_hover, inventory.items[inventory.inv_hover].stack);
				
				// Exit context menu
				inventory.context_menu = noone;
				state = state_inventory;
			}
		}
		else if (inventory.context_menu[0][inventory.context_menu[5]] == "Take"){
			container_take_item(self, manager.tile_container);
			
			// Exit context menu
			inventory.context_menu = noone;
			state = state_inventory;
		}
	}
}

function state_slot_selection(){
	var len = array_length(inventory.slot_select_menu[0]);
	
	if (keyboard_check_pressed(controls.key_cancel) or keyboard_check_pressed(controls.key_inventory)){
		
		// Exit context menu
		inventory.slot_select_menu = noone;
		state = state_context_menu;
	}
	else if (keyboard_check_pressed(controls.key_up)){
		inventory.slot_select_menu[5] --;
		if (inventory.slot_select_menu[5] < 0){
			inventory.slot_select_menu[5] += len;
		}
	}
	else if (keyboard_check_pressed(controls.key_down)){
		inventory.slot_select_menu[5] ++;
		if (inventory.slot_select_menu[5] >= len){
			inventory.slot_select_menu[5] -= len;
		}
	}
	else if (keyboard_check_pressed(controls.key_interact_confirm)){
		var menu_hover   = inventory.slot_select_menu[5];
		var number_to_move = 1;
		
		// Check ammo
		if (struct_exists(inventory.items[inventory.inv_hover], "tags")){
			if (item_check_tag(inventory.items[inventory.inv_hover], TAG.IS_AMMO)){
				
				number_to_move = inventory.ammo_cap;
				
				if (body_plan[BODY_PART_CATEGORY.BODY][0][BODY_PART_STATS.PART_SLOT_1] != noone){
					
					// Check currently equipped ammo
					var current_ammo = body_plan[BODY_PART_CATEGORY.BODY][0][BODY_PART_STATS.PART_SLOT_1];
					if (inventory.items[inventory.inv_hover].name == current_ammo.name){
						
						number_to_move = inventory.ammo_cap - current_ammo.stack
						number_to_move = min(number_to_move, inventory.items[inventory.inv_hover].stack);
						if (number_to_move == 0){
							inventory.context_menu		= noone;
							inventory.slot_select_menu	= noone;
							state = state_inventory;
							return;
						}
						current_ammo.stack += number_to_move;
						inventory_drop_slot(self, inventory.inv_hover, number_to_move);
						inventory.context_menu		= noone;
						inventory.slot_select_menu	= noone;
						state = state_inventory;
						return;
					}
				}
				
				number_to_move = min(number_to_move, inventory.items[inventory.inv_hover].stack);
			}
		}
		
		var item_to_move = variable_clone(inventory.items[inventory.inv_hover]);
		var dest_cat     = inventory.slot_select_menu[0][menu_hover][1];
		var dest_ind     = inventory.slot_select_menu[0][menu_hover][2];
		var dest_slot    = inventory.slot_select_menu[0][menu_hover][3];
		
		inventory_drop_slot(self, inventory.inv_hover, number_to_move);
		equipment_add_item(self, number_to_move, item_to_move, dest_cat, dest_ind, dest_slot);
		
		inventory.context_menu		= noone;
		inventory.slot_select_menu	= noone;
		state = state_inventory;
	}
}

function state_pickup(){
	var len = array_length(pickup_menu);
	if (keyboard_check_pressed(controls.key_cancel) or keyboard_check_pressed(controls.key_inventory)){
		state = state_ready_for_inputs;
	}
	else if (keyboard_check_pressed(controls.key_up)){
		pickup_hover --;
		if (pickup_hover < 0) pickup_hover += len;
	}
	else if (keyboard_check_pressed(controls.key_down)){
		pickup_hover ++;
		if (pickup_hover >= len) pickup_hover -= len;
	}
	else if (keyboard_check_pressed(controls.key_interact_confirm)){
		// Add item to inventory and remove from menu
		inventory_add_item(self, pickup_menu[pickup_hover], pickup_menu[pickup_hover].stack);
		
		// Find item on ground and delete it
		var ind = array_get_index(manager.game_state.game_grid[x_pos][y_pos].items, pickup_menu[pickup_hover]);
		array_delete(manager.game_state.game_grid[x_pos][y_pos].items, ind, 1);
		
		// Delete item from pickup menu
		array_delete(pickup_menu, pickup_hover, 1);
		
		// Reset menu length
		len = array_length(pickup_menu);
		if (len <= 0){
			state = state_ready_for_inputs;
		}
		if (pickup_hover >= len) pickup_hover --;
	}
}




