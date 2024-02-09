extends Node

var FSM: StateMachine

func enter():
	pass

func exit():
	var last=FSM.BM.turn_queue.pop_front()
	FSM.BM.turn_queue.append(last)
	
func process(_delta):
	if not FSM.BM.AM.is_animation_ongoing():
		FSM.change_to("Status")

func input(_event):
	pass
