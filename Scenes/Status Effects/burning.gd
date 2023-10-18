extends BaseStatus

class_name burning

var effect_name="burning"
@export var damage=5

func per_turn_effect():
	unit.take_damage(damage,"fire")

