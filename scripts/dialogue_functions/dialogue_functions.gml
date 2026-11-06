
// DIALOGUE FUNCTIONS -----------------------------------------------------------------------------
function dialogue_init(dialogue_self, dialogue_other){
	
	with (dialogue_self){
		state_previous	= state;
		state			= state_dialogue;
	}
	
	with (manager){
		
		game_state.direction_indicator = noone;
		
		var dialogue_index	= 0;
		var txt_main		= dialogue_text[dialogue_index][0];
		var response_list	= dialogue_text[dialogue_index][1];
		
		dialogue = {
			speaker:		dialogue_other,
			responder:		dialogue_self,
			main_message:	txt_main,
			responses:		response_list,
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


// DIALOGUE TEXT ----------------------------------------------------------------------------------
function dialogue_text_init(){
	
	dialogue_text[0][0] = "Greetings, I am a bot. How can I help you today?";
	dialogue_text[0][1] = [
		["Tell me about dialogue option 1", 1],
		["What is dialogue option 2?",		2]
	]
	
	dialogue_text[1][0] = "This is dialogue option 1. What else would you like to know?";
	dialogue_text[1][1] = [
		["Lets go back to option 0 for a moment.",	0],
		["That's all I need to know thanks.",		DIALOGUE.EXIT]
	]
	
	dialogue_text[2][0] = "Dialogue option 2 is so exciting! Would you like to know more about it?";
	dialogue_text[2][1] = [
		["Actually, I'd like to know about option 1.",	1],
		["What was dialogue option 0 again?",			0],
		["No thank you.",								DIALOGUE.EXIT]
	]
	
	
}




