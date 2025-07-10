extends Spell
func build_track(sprite,target):

	sprite.rotation = atan2(dir.y, dir.x)
	var anim = anim_player.get_animation("traveling")

	var pos_track = anim.find_track(sprite.name+":position",Animation.TrackType.TYPE_VALUE)
	var l = .2
	anim.set_length(l)
	anim.track_set_key_value(pos_track,0,BF.map.tile_to_position(caster.tile_position))
	anim.track_set_key_value(pos_track,1,target)
	anim.track_set_key_time(pos_track,1,l)

func animation():
	var dirs =BF.map.get_sides(caster.tile_position,caster.orientation_dir)

	Events.emit_signal("spell_cast_anim_start",self,anim_player)
	anim_player.animation_finished.connect(_on_finished_animation)
	build_track($Sprite1,BF.map.tile_to_position(dirs[0]))
	build_track($Sprite2,BF.map.tile_to_position(dirs[1]))
	
	affect_tiles()
	anim_player.play("traveling")


func affect_tiles():
	for tile in affected_tiles:
		var _dir=BF.map.get_direction_from_tile_to_tile(caster.tile_position,tile)
		BF.push(tile,_dir)
