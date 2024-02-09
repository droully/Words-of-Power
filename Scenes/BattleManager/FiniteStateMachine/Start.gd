extends Node

var FSM: StateMachine

func enter():	
	pass

func process(_delta):
	FSM.change_to("Turn")
func exit():
	Events.emit_signal("battle_start")

func input(_event):
	pass
