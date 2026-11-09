
// DIALOGUE FUNCTIONS -----------------------------------------------------------------------------
function dialogue_init(dialogue_self, dialogue_other){
	
	if (dialogue_other.intelligence < 5){
		log_add_entry($"{dialogue_other.name} is unable to talk.");
		return;
	}
	
	with (dialogue_self){
		state_previous	= state;
		state			= state_dialogue;
	}
	
	with (manager){
		
		game_state.direction_indicator = noone;
		
		var dialogue_index	= 0;
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
		var txt_main		= dialogue_text[dialogue_new_index][0];
		var response_list	= dialogue_text[dialogue_new_index][1];
	
		dialogue.main_message	= txt_main;
		dialogue.responses		= response_list;
		dialogue.hover			= 0;
	}
}

function dialogue_add_names(text, speaker, responder){
	
	// Check main message
	var main = text[0];
	var main_len = string_length(main);
	for (var i = 1; i <= main_len; i ++){
		var char = string_char_at(main, i);
		if (char == "|"){
			main = string_delete(main, i, 1);
			main = string_insert(speaker.name, main, i);
		}
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
	
	dialogue_text[0][0] = "Greetings, I am |. How can I help you today?";
	dialogue_text[0][1] = [
		["I am &, I have that sword you wanted.",	1],
		["Do you have something for me?",	2],
		["Goodbye",							DIALOGUE.EXIT]
	]
	
	dialogue_text[1][0] = "That's great, thank you so much!";
	dialogue_text[1][1] = [
		["- give sword -",	DIALOGUE.ITEM_GIVE, "sword"]
	]
	
	dialogue_text[2][0] = "It's dangerous to go alone! Take this!";
	dialogue_text[2][1] = [
		["Thank you.",		DIALOGUE.ITEM_TAKE, item_sword1],
		["No thank you.",	DIALOGUE.EXIT]
	]
	
	
}




