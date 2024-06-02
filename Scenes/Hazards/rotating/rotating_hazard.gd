extends Hazard

func affect_unit(target:Unit):
	target.rotate_orientation(90)
