extends BaseStatus

class_name burning

var effect_name="burning"
var damage=5

func per_turn_effect():
	unit.take_damage(damage,"fire")
