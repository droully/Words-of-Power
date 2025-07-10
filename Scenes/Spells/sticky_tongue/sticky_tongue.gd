extends Spell

# Called when the node enters the scene tree for the first time.
func build_track():
	var anim_speed = 200
	var target_pos = BF.map.tile_to_position(affected_tiles[0])
	
	var dist= caster.position.distance_to(target_pos)
	var t = dist/anim_speed
	var anim_fw = anim_player.get_animation("forward")
	anim_fw.set_length(t)
	
	var pos_end_track = anim_fw.find_track("End:position",Animation.TrackType.TYPE_VALUE)
	var scale_body_track = anim_fw.find_track("Body:scale",Animation.TrackType.TYPE_VALUE)
	var pos_body_track = anim_fw.find_track("Body:position",Animation.TrackType.TYPE_VALUE)
	var effect_track = anim_fw.find_track(".",Animation.TrackType.TYPE_METHOD)
	
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
	
	pos_end_track = anim_bw.find_track("End:position",Animation.TrackType.TYPE_VALUE)
	scale_body_track = anim_bw.find_track("Body:scale",Animation.TrackType.TYPE_VALUE)
	pos_body_track = anim_bw.find_track("Body:position",Animation.TrackType.TYPE_VALUE)
	
	anim_bw.track_set_key_value(pos_end_track,1,caster.position)
	anim_bw.track_set_key_value(pos_end_track,0,target_pos)
	anim_bw.track_set_key_time(pos_end_track,1,t)

	anim_bw.track_set_key_value(scale_body_track,0,Vector2(2*dist/64,1))	
	anim_bw.track_set_key_time(scale_body_track,1,t)
	
	anim_bw.track_set_key_value(pos_body_track,1,caster.position)
	anim_bw.track_set_key_value(pos_body_track,0,(target_pos+caster.position)/2)
	anim_bw.track_set_key_time(pos_body_track,1,t)
	
	
	

func animation():

	$Body.rotation = atan2(dir.y, dir.x)
	$End.rotation =atan2(dir.y, dir.x)
	Events.emit_signal("spell_cast_anim_start",self,anim_player)
	anim_player.animation_finished.connect(_on_finished_animation)

	build_track()
	anim_player.play("forward")
	anim_player.queue("backward")


func callbackOnHit(target: Unit):

	if  target not in affected_targets:
		var _dir=BF.map.get_direction_from_tile_to_tile(caster.tile_position,target.tile_position)
		BF.pull(target.tile_position,_dir)
		
		affected_targets.append(target)
