extends Node

func choose_command(_BF):
	return 
	
func callbackUnitOverlap(unit_on_top):
	var unit = get_parent() 
	unit_on_top.die()
	unit.die()
