extends Node

var FSM: StateMachine

func initialize(_FSM):
	FSM=_FSM

func enter():
	get_tree().call_group(FSM.BM.current_party,"apply_status_effect")

func exit():
	pass

func process(_delta):
	FSM.change_to("Turn")

func input(_event):
	pass
