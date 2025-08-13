extends Ground

func on_ground_exited():
	Events.emit_signal("ground_destroyed",self)
	queue_free()
