extends Node

var FSM: StateMachine

func initialize(_FSM):
	FSM=_FSM

func process(_delta):
	print("weeena")

func enter():
	FSM.UI.find_child("BattleEnd").visible=true

func exit():
	FSM.UI.find_child("BattleEnd").visible=false

func input(_event):
	pass
