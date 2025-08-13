extends Ground


func on_ground_entered():
	
	Events.emit_signal("win_level")
