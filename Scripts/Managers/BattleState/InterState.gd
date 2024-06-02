extends Node

var FSM: StateMachine
var current_party

func initialize(_FSM):
	FSM=_FSM
	


func process(_delta):
	FSM.BM.change_current_party()
	
	FSM.change_to("Status")

	#FSM.change_to("End")

func enter():
	current_party= FSM.BM.current_party	

func exit():
	pass

func input(_event):
	pass
