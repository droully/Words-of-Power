extends Node

func choose_command(_BF):
	var unit= get_parent() 
	var skipCommand = Command.Skip.new(unit)
	return skipCommand

func callbackUnitOverlap(_unit_on_top):
	pass
