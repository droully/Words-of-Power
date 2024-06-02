extends Hazard

func affect_unit(target:Unit):
	target.add_status_effect(burning.new())
	target.take_damage(1)

