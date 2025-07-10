extends Ground

func step():
	pressed = true
	Events.emit_signal("button_pressed",self,tile_position)
	
func unstep():
	pressed = false
	Events.emit_signal("button_unpressed",self,tile_position)
