extends Node

var FSM: StateMachine
var timer = 0

func initialize(_FSM):
	FSM=_FSM

func enter():	
	FSM.UI.find_child("BattleStart").visible=true

func process(delta):
	timer += delta
	if timer >1:
		FSM.change_to("Deploy")
		


func exit():
	FSM.UI.find_child("BattleStart").visible=false
	Events.emit_signal("battle_start")

func input(_event):
	pass
