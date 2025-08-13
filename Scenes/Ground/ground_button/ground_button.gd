extends Ground

func on_ground_entered():
	pressed = true
	Events.emit_signal("button_pressed",self,tile_position)
	
func on_ground_exited():
	pressed = false
	Events.emit_signal("button_unpressed",self,tile_position)
