extends Spell

# Called when the node enters the scene tree for the first time.


func animation():
	var anim_speed = 200
	var dist= caster.position.distance_to(target_pos)
	var t = dist/anim_speed
	$Body.rotation = atan2(dir.y, dir.x)
	$End.rotation =atan2(dir.y, dir.x)
	Events.emit_signal("spell_cast_anim_start",self,anim_player)
	anim_player.animation_finished.connect(_on_finished_animation)

	var anim_fw = anim_player.get_animation("forward")
	anim_fw.set_length(t)
	
	var pos_end_track = anim_fw.find_track("End:position",0)
	var scale_body_track = anim_fw.find_track("Body:scale",0)
	var pos_body_track = anim_fw.find_track("Body:position",0)
	var effect_track = anim_fw.find_track(".",5)
	
	anim_fw.track_set_key_value(pos_end_track,0,caster.position)
	anim_fw.track_set_key_value(pos_end_track,1,target_pos)
	anim_fw.track_set_key_time(pos_end_track,1,t)

	anim_fw.track_set_key_value(scale_body_track,1,Vector2(2*dist/64,1))	
	anim_fw.track_set_key_time(scale_body_track,1,t)
	
	anim_fw.track_set_key_value(pos_body_track,0,caster.position)
	anim_fw.track_set_key_value(pos_body_track,1,(target_pos+caster.position)/2)
	anim_fw.track_set_key_time(pos_body_track,1,t)
	
	
	anim_fw.track_insert_key(effect_track, t, {"method" : "affect_tiles" , "args" : []})
	################################

	var anim_bw = anim_player.get_animation("backward")
	anim_bw.set_length(t)
	
	pos_end_track = anim_bw.find_track("End:position",0)
	scale_body_track = anim_bw.find_track("Body:scale",0)
	pos_body_track = anim_bw.find_track("Body:position",0)
	
	anim_bw.track_set_key_value(pos_end_track,1,caster.position)
	anim_bw.track_set_key_value(pos_end_track,0,target_pos)
	anim_bw.track_set_key_time(pos_end_track,1,t)

	anim_bw.track_set_key_value(scale_body_track,0,Vector2(2*dist/64,1))	
	anim_bw.track_set_key_time(scale_body_track,1,t)
	
	anim_bw.track_set_key_value(pos_body_track,1,caster.position)
	anim_bw.track_set_key_value(pos_body_track,0,(target_pos+caster.position)/2)
	anim_bw.track_set_key_time(pos_body_track,1,t)
	

	anim_player.play("forward")
	anim_player.queue("backward")


func callbackOnHit(target: Unit):
		for i in range(100):
			var p = target.pull(dir)
			if p is Unit: #coliciona
				if target.has_tag("insect"):
					target.die()
					break
			if p is bool: #no coliciona
				pass
