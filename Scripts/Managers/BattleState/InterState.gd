extends Node

var FSM: StateMachine
var BM: BattleManager

func initialize(_FSM):
	FSM=_FSM
	BM= FSM.BM

func process(_delta):
	if BM.BF.win:
		FSM.change_to("End")
	else:
		FSM.change_to("Status")


func enter():
	pass

func exit():
	pass

func input(_event):
	pass
