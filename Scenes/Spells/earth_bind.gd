extends Spell

# Called when the node enters the scene tree for the first time.


func targetable_tiles(_caster=caster,_BF=BF):
	return _BF.tiles_in_aoe(_caster.tile_position,srange,false,true)
	
func affected_tiles(target_tile,_caster=caster,_BF=BF):
	if _BF.grid.is_point_solid(target_tile):
		return []
	return _BF.tiles_in_aoe(target_tile, radius,false,true)

func animation():
	position=target_pos
	
	Events.emit_signal("spell_cast_anim_start",self)
	anim_player.animation_finished.connect(_on_finished_animation)
	
	affect_tiles()
	anim_player.play("exploding")

func _on_finished_animation(_anim_name):
	
	Events.emit_signal("spell_cast_anim_end",self)	
	queue_free()
	
func callbackOnHit(target):
	target.take_damage(damage)
	target.add_status_effect(slow.new())
