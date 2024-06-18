extends Spell


func animation():
	position=target_pos
	 
	Events.emit_signal("spell_cast_anim_start",self,anim_player)
	anim_player.animation_finished.connect(_on_finished_animation)
	
	affect_tiles()
	anim_player.play("exploding")


func callbackOnHit(target):
	if target.take_damage(damage):
		caster.increase_shield()
#	target.add_status_effect(burning_effect.new())
