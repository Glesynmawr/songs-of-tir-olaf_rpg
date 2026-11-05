
function dialogue_init(dialogue_self, dialogue_other){
	
	with (dialogue_self){
		state_previous	= state;
		state			= state_dialogue;
	}
	
	with (manager){
		
		game_state.direction_indicator = noone;
		
		dialogue = {
			speaker:		dialogue_other,
			responder:		dialogue_self,
			main_message:	"This is a message.",
			responses:		[["This is response 1", noone], ["This is response 2", noone]],
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




