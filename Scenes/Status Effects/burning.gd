extends Node

class_name burning_effect

var duration = 2
var damage=5
@onready var unit = get_parent().get_parent()

func apply_effect():
	unit.take_damage(damage,"fire")
	duration -= 1 

func check_duration():
	if duration<=0:
		queue_free()
