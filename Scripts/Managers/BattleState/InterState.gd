extends Node

var FSM: StateMachine
var BM: BattleManager

func initialize(_FSM):
	FSM=_FSM
	BM= FSM.BM
	


func process(_delta):
	#FSM.BM.change_current_party()
	if BM.BF.check_won_game():
		FSM.change_to("End")
	else:
		FSM.change_to("Status")

	#FSM.change_to("End")

func enter():
	pass

func exit():
	pass

func input(_event):
	pass
