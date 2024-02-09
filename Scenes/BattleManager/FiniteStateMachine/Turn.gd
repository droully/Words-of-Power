extends Node


var FSM: StateMachine

func enter():
	Events.emit_signal("turn_start",FSM.BM.current_unit)

func exit():
	pass


func process(_delta):
	var current_unit=FSM.BM.current_unit
	var player_turn=FSM.BM.player_turn
	var enemy_turn=FSM.BM.enemy_turn
	
	match current_unit.party:
		"player":
			if player_turn.call():
				FSM.change_to("Anim")
		"enemy":
			enemy_turn.call(current_unit)
			FSM.change_to("Anim")


func input(event):
	if ("player" == FSM.BM.current_unit.party):
		match FSM.BM.user_action_state:
			FSM.BM.UserActionState.Move:
				if FSM.BM.move_input(event):
					FSM.BM.player_chose_action = true
					
			FSM.BM.UserActionState.Cast:				
				if FSM.BM.cast_input(event):
					FSM.BM.player_chose_action = true
