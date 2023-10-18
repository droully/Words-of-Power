extends BaseStatus

class_name slow

var effect_name="slow"

func apply_effect():
	unit.speed -=1
	
func remove_effect():
	unit.speed +=1
