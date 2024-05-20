extends Node

var FSM: StateMachine
var tq

func initialize(_FSM):
	FSM=_FSM
	


func process(_delta):
	var enemies=0
	for unit in tq:
		if unit.party=="enemy":
			enemies+=1
	if enemies==0:
		FSM.change_to("End")
	else:
		tq.append(tq.pop_front())
		FSM.change_to("Status")

func enter():
	tq= FSM.BM.turn_queue	

func exit():
	pass

func input(_event):
	pass
