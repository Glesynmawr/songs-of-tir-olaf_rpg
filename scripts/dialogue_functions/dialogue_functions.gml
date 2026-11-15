
// DIALOGUE FUNCTIONS -----------------------------------------------------------------------------
function dialogue_init(dialogue_self, dialogue_other){
	
	if (dialogue_other.intelligence < 5){
		log_add_entry($"{dialogue_other.name} is unable to talk.");
		return;
	}
	
	var dialogue_index = dialogue_get_init_index(dialogue_self, dialogue_other)
	with (dialogue_self){
		state_previous	= state;
		state			= state_dialogue;
	}
	
	with (manager){
		
		game_state.direction_indicator = noone;
		var txt_main		= dialogue_add_names(dialogue_text[dialogue_index], dialogue_other, dialogue_self);
		
		dialogue = {
			speaker:		dialogue_other,
			responder:		dialogue_self,
			main_message:	txt_main[0],
			responses:		txt_main[1],
			hover:			0,
		}
	}
}

function dialogue_get_init_index(dialogue_self, dialogue_other){
	
	var dialogue_index	= 0;
	with (dialogue_other){
		
		// Never met player before
		if (!has_met_player){
			
			if (knows_player_name){
				
				// Name known
				dialogue_index = 1;
			}
			else{
				
				// Name unknown
				dialogue_index = 0;
			}
			has_met_player = true;
		}
		// Met player before
		else{
			if (knows_player_name){
				
				// Name known
				dialogue_index = 3;
			}
			else{
				
				// Name unknown
				dialogue_index = 2;
			}
			has_met_player = true;
		}
	}
	
	return(dialogue_index);
}

function dialogue_reset(){
	with (manager){
		
		with (dialogue.responder){
			state = state_previous;
		}
		dialogue = noone;
	}
}

function dialogue_update(dialogue_new_index){
	
	with (manager){
		
		var txt_main = dialogue_add_names(dialogue_text[dialogue_new_index], dialogue.speaker, dialogue.responder);
	
		dialogue.main_message	= txt_main[0];
		dialogue.responses		= txt_main[1];
		dialogue.hover			= 0;
	}
}

function dialogue_add_names(text_base, speaker, responder){
	
	var text = variable_clone(text_base);
	
	// Check main message
	var main = text[0];
	var main_len = string_length(main);
	for (var i = 1; i <= main_len; i ++){
		var char = string_char_at(main, i);
		if (char == "|"){
			main = string_delete(main, i, 1);
			main = string_insert(speaker.name, main, i);
		}
		else if (char == "&"){
			main = string_delete(main, i, 1);
			main = string_insert(responder.name, main, i);
		}
		var main_len = string_length(main);
	}
	
	// Check responses
	var resp = text[1];
	
	for (i = 0; i < array_length(resp); i ++){
		var resp_len = string_length(resp[i][0]);
		for (var j = 1; j <= resp_len; j ++){
			var char = string_char_at(resp[i][0], j);
			if (char == "&"){
				resp[i][0] = string_delete(resp[i][0], j, 1);
				resp[i][0] = string_insert(responder.name, resp[i][0], j);
			}
			else if (char == "|"){
				resp[i][0] = string_delete(resp[i][0], j, 1);
				resp[i][0] = string_insert(speaker.name, resp[i][0], j);
			}
			resp_len = string_length(resp[i][0])
		}
	}
	
	var new_text = [main, resp];
	
	return(new_text);
}


// ITEM SWAPPING
function actor_give_item(giver, reciever, item_name){
	for (var i = 0; i < array_length(giver.inventory.items); i ++){
		
		var item = variable_clone(giver.inventory.items[i]);
		
		if (item.name == item_name){
			inventory_drop_slot(giver, i, 1);
			inventory_add_item(reciever, item, 1);
			return(true);
		}
	}
	return(false);
}


// QUEST DIALOGUE ---------------------------------------------------------------------------------
function quest_dialogue_init(){
	
}


// DIALOGUE TEXT ----------------------------------------------------------------------------------
function dialogue_text_init(){
	
	// DIALOGUE BEGINNINGS ------------------------------------------------------------------------
	// Player unknown, first meeting
	dialogue_text[0][0] = "Welcome, I am |. How can I help you today?";
	dialogue_text[0][1] = [
		["Greetings |, I am &.",		DIALOGUE.TELL_NAME, 4],
		["Goodbye.",					DIALOGUE.EXIT]
	]
	
	// Player known, first meeting
	dialogue_text[1][0] = "Welcome &. I know who you are. What brings you here?";
	dialogue_text[1][1] = [
		["You already know who I am?",	DIALOGUE.EXIT],
		["Goodbye.",					DIALOGUE.EXIT]
	]
	
	// Player unknown, already met
	dialogue_text[2][0] = "Hello again stranger. How can I help you today?";
	dialogue_text[2][1] = [
		["Greetings |, My name is &.",	DIALOGUE.TELL_NAME, 4],
		["Goodbye.",					DIALOGUE.EXIT]
	]
	
	// Player known, already met
	dialogue_text[3][0] = "Greetings &. How can I help you today?";
	dialogue_text[3][1] = [
		["Greetings |.",				DIALOGUE.EXIT],
		["Goodbye.",					DIALOGUE.EXIT]
	]
	
	// DIALOGUE SECOND STATEMENTS -----------------------------------------------------------------
	dialogue_text[4][0] = "Good to meet you &. What can I do for you?";
	dialogue_text[4][1] = [
		["I need nothing, thank you.",	DIALOGUE.EXIT],
		["Goodbye.",					DIALOGUE.EXIT]
	]
	
	
}




