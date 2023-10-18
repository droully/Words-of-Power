extends Node

class_name BaseStatus

@export var duration = 2
@onready var unit = get_parent().get_parent()

func apply_effect():
	pass

func per_turn_effect():
	pass
func remove_effect():
	pass
	
func pass_turn():
	duration -=1
	if duration<=0:
		remove_effect()
		queue_free()
