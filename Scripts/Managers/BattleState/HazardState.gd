extends Node

var FSM: StateMachine

func initialize(_FSM):
	FSM=_FSM

func enter():
	var current_unit=FSM.BM.current_unit

	var current_hazard=FSM.BF.map.get_hazard_in_tile(current_unit.tile_position)
	if is_instance_valid(current_hazard):
		current_hazard.affect_unit(current_unit)
	
func exit():
	pass
	
func process(_delta):
	FSM.change_to("Inter")

func input(_event):
	pass
