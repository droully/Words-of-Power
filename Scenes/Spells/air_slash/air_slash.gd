extends Spell

func animation():
	Events.emit_signal("spell_cast_anim_start",self,anim_player)
	anim_player.animation_finished.connect(_on_finished_animation)

	
	rotation = atan2(dir.y, dir.x)+PI/2
	
	var anim = anim_player.get_animation("traveling")
	var pos_track = anim.find_track(".:position",0)
	var l = .4
	anim.set_length(l)
	anim.track_set_key_value(pos_track,0,target_pos)
	anim.track_set_key_value(pos_track,1,target_pos+128.0*dir)
	anim.track_set_key_time(pos_track,1,l)

	affect_tiles()	
	anim_player.play("traveling")



func callbackOnHit(target):
	if  target not in affected_targets:
		target.push(dir)
		target.push(dir)
		affected_targets.append(target)
