extends Spell
func play_track(sprite,target):

	sprite.rotation = atan2(dir.y, dir.x)
	var anim = anim_player.get_animation("traveling")

	var track = anim.find_track(sprite.name+":position",Animation.TrackType.TYPE_VALUE)
	var l = .2
	anim.set_length(l)
	anim.track_set_key_value(track,0,BF.map.tile_to_position(caster.tile_position))
	anim.track_set_key_value(track,1,target)
	anim.track_set_key_time(track,1,l)

func animation():
	var dirs =BF.map.get_sides(caster.tile_position,caster.orientation_dir)

	Events.emit_signal("spell_cast_anim_start",self,anim_player)
	anim_player.animation_finished.connect(_on_finished_animation)
	play_track($Sprite1,BF.map.tile_to_position(dirs[0]))
	play_track($Sprite2,BF.map.tile_to_position(dirs[1]))
	affect_tiles()
	anim_player.play("traveling")

func callbackOnHit(target):
	if  target not in affected_targets:
		var _dir=BF.map.get_direction_from_tile_to_tile(caster.tile_position,target.tile_position)
		target.push(_dir)
		affected_targets.append(target)
