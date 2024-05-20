extends Node

var FSM: StateMachine

func initialize(_FSM):
	FSM=_FSM


func enter():
	pass

func exit():
	pass
	
func process(_delta):
	if not FSM.BM.AM.is_animation_ongoing():
		FSM.change_to("Inter")

func input(_event):
	pass
