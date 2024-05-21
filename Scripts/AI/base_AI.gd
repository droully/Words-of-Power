extends Node
@onready var unit= get_parent()

func execute_turn(_BM, _BF):

	var skipCommand = Command.Skip.new(unit)
	return skipCommand
