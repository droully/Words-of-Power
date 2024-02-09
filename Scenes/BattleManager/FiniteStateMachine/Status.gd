extends Node

var FSM: StateMachine

func enter():
	var current_unit=FSM.BM.current_unit
	
	var status_list=current_unit.get_node("StatusEffects").get_children()
	
	for status in status_list:
		status.per_turn_effect()
	for status in status_list:
		status.pass_turn()

func exit():
	pass

func process(_delta):
	FSM.change_to("Turn")

func input(_event):
	pass
