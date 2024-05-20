extends Spell

# Called when the node enters the scene tree for the first time.


func animation():
	position=target_pos
	
	Events.emit_signal("spell_cast_anim_start",self)
	anim_player.animation_finished.connect(_on_finished_animation)
	
	affect_tiles()
	anim_player.play("exploding")

func callbackOnHit(target):
	target.take_damage(damage)
	target.add_status_effect(slow.new())
