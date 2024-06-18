extends Hazard

func affect(target:Unit):
	
	target.add_status_effect(burning.new())
	target.take_damage(1)
