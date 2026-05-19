
function state_ready_for_inputs(){
	var player_moved = false;
	
	if (keyboard_check_pressed(controls.key_inventory)){
		state = state_inventory;
		exit;
	}
	
	// Direction inputs
	var x_move = keyboard_check(controls.key_right) - keyboard_check(controls.key_left)
	var y_move = keyboard_check(controls.key_down) - keyboard_check(controls.key_up)
	
	var move_dir = input_direction(x_move, y_move);
	if (move_dir != noone){
		
		// Set manager direction indicator
		with (manager) direction_indicator = move_dir;
		
		// Movement
		if (keyboard_check(controls.key_move_confirm)){
				if (manager.move_timer <= 0){
				var xx = manager.cell_x_neighbours[move_dir];
				var yy = manager.cell_y_neighbours[move_dir];
				player_moved = action_move(manager.game_grid, xx, yy);
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
		
		// Interaction
		if (keyboard_check_pressed(controls.key_interact_confirm)){
			{
				player_moved = tile_interaction(self, x_pos + x_move, y_pos + y_move);
			}
		}
	}
	else{
		if (manager.direction_indicator != noone){
			manager.direction_indicator = noone;
		}
		if (keyboard_check_pressed(controls.key_interact_confirm)){
			if (array_length(manager.game_grid[x_pos][y_pos].items) > 0){
				pickup_menu_initialise(self);
			}
		}
		else if (keyboard_check_pressed(controls.key_move_confirm)){
			player_moved = tile_interaction(self, x_pos + x_move, y_pos + y_move);
		}
	}

	if (player_moved){
		// Set has-acted flag
		has_acted = true;
		
		// Update player LOS
		set_player_los(other.game_grid, self);
		
		// Update player distance map
		distance_map_player = create_distance_map(x_pos, y_pos);
	}
}

function state_inventory(){
	var len, slots;
	
	if (keyboard_check_pressed(controls.key_right)) inventory.selected ++;
	if (keyboard_check_pressed(controls.key_left))  inventory.selected --;
	inventory.selected = clamp(inventory.selected, 0, 1);
	
	if (inventory.selected == 1){
		len = array_length(inventory.items);
		
		if (keyboard_check_pressed(controls.key_inventory) or keyboard_check_pressed(controls.key_cancel)){
			// Exit INVENTORY state
			state = state_ready_for_inputs;
		}
		else if (keyboard_check_pressed(controls.key_up)){
			// Move up inventory
			inventory.inv_hover --;
			if (inventory.inv_hover < 0){
				inventory.inv_hover += len;
			}
		}
		else if (keyboard_check_pressed(controls.key_down)){
			// Move down inventory
			inventory.inv_hover ++;
			if (inventory.inv_hover >= len){
				inventory.inv_hover -= len;
			}
		}
		else if (keyboard_check_pressed(controls.key_interact_confirm)){
			if (inventory.context_menu == noone){
				context_menu_initialise();
			}
		}
	}
	else {
		len = array_length(inventory.equipment);
		
		if (keyboard_check_pressed(controls.key_inventory) or keyboard_check_pressed(controls.key_cancel)){
			// Exit INVENTORY state
			state = state_ready_for_inputs;
		}
		else if (keyboard_check_pressed(controls.key_up)){
			// Move up equipment
			
			inventory.equ_hover[1] --;
			if (inventory.equ_hover[1] < 0){
				inventory.equ_hover[0] --;
				if (inventory.equ_hover[0] < 0){
					inventory.equ_hover[0] += len;
				}
				slots = array_length(inventory.equipment[inventory.equ_hover[0]]);
				inventory.equ_hover[1] += slots;
			}
			
		}
		else if (keyboard_check_pressed(controls.key_down)){
			slots = array_length(inventory.equipment[inventory.equ_hover[0]]);
			
			// Move down equipment
			inventory.equ_hover[1] ++;
			if (inventory.equ_hover[1] >= slots){
				inventory.equ_hover[0] ++;
				if (inventory.equ_hover[0] >= len){
					inventory.equ_hover[0] -= len;
				}
				inventory.equ_hover[1] = 0;
			}
		}
		else if (keyboard_check_pressed(controls.key_interact_confirm)){
			if (is_array(inventory.equipment[inventory.equ_hover[0]][inventory.equ_hover[1]])){
				if (inventory.context_menu == noone){
					context_menu_initialise();
				}
			}
		}
	}
}

function state_context_menu(){
	var len = array_length(inventory.context_menu[0]);
	
	if (keyboard_check_pressed(controls.key_cancel)){
		
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
		
		if (inventory.context_menu[0][inventory.context_menu[5]] == "Drop"){
			// Spawn item on ground
			spawn_existing_item(inventory.items[inventory.inv_hover], 1, x_pos, y_pos);
		
			// DROP item
			inventory_drop_slot(self, inventory.inv_hover, 1);
		
			// Exit context menu
			inventory.context_menu = noone;
			state = state_inventory;
		}
		else if (inventory.context_menu[0][inventory.context_menu[5]] == "Equip"){
			// Inventory only
			
			
		}
		else if (inventory.context_menu[0][inventory.context_menu[5]] == "Remove"){
			// Equipment only
			
			
		}
	}
}

function state_pickup(){
	var len = array_length(pickup_menu);
	if (keyboard_check_pressed(controls.key_cancel)){
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
		inventory_add_item(self, pickup_menu[pickup_hover]);
		
		// Find item on ground and delete it
		var ind = array_get_index(manager.game_grid[x_pos][y_pos].items, pickup_menu[pickup_hover]);
		array_delete(manager.game_grid[x_pos][y_pos].items, ind, 1);
		
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

function state_idle(){
	// Check if player is in range and visible
	if (distance_map_player[x_pos][y_pos] <= range) and (manager.game_grid[x_pos][y_pos].is_visible == true){
		log_add_entry($"{name} has spotted {manager.actor_registry.player.name}!", c_ltgrey);
		state = state_chase;
	}
	
	has_acted = true;
}

function state_chase(){
	
	// Find lowest distance value of neighbours
	var lowest_dist = 10000;
	for (var i = 0; i < 8; i ++){
		var target_x = x_pos + manager.cell_x_neighbours[i];
		var target_y = y_pos + manager.cell_y_neighbours[i];
		
		if (distance_map_player[target_x][target_y] < lowest_dist){
			lowest_dist = distance_map_player[target_x][target_y];
		}
	}
	
	// Make list of unoccupied neighbours with lowest value
	var candidate_list = [];
	for (i = 0; i < 8; i ++){
		var target_x = x_pos + manager.cell_x_neighbours[i];
		var target_y = y_pos + manager.cell_y_neighbours[i];
		
		if (distance_map_player[target_x][target_y] <= lowest_dist){
			array_push(candidate_list, [manager.cell_x_neighbours[i], manager.cell_y_neighbours[i]]);
		}
	}
	
	// Choose movement direction from candidate list
	var len = array_length(candidate_list);
	if (len > 0){
		var choice = irandom(len - 1);
		
		// execute move
		action_move(manager.game_grid, candidate_list[choice][0], candidate_list[choice][1]);
	}
	
	has_acted = true;
}
