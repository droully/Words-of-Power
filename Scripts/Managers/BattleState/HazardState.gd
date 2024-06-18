extends Node

var FSM: StateMachine

func initialize(_FSM):
	FSM=_FSM

func enter():
	get_tree().call_group("hazard","affect_unit_on_top")
	get_tree().call_group("hazard","pass_turn")

func exit():
	pass

func process(_delta):
	FSM.change_to("Inter")

func input(_event):
	pass
