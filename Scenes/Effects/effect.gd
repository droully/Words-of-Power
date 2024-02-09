extends Resource


class_name Effect

@export var effect_name: String

func callback(arg_array):
	if effect_name == "damage":
		target.take_damage(damage)
		target.add_status_effect(burning.new())

