extends Spell


# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func _process(_delta):
	pass

func animation():
	var anim_speed = 200
	Events.emit_signal("spell_cast_anim_start",self)
	anim_player.animation_finished.connect(_on_finished_animation)
	anim_player.animation_changed.connect(_on_changed_animation)
	
	var anim = anim_player.get_animation("traveling")
	var pos_track = anim.find_track(".:position",0)
	var l = (caster.position.distance_to(target_pos) )/anim_speed
	anim.set_length(l)
	anim.track_set_key_value(pos_track,0,caster.position)
	anim.track_set_key_value(pos_track,1,target_pos)
	anim.track_set_key_time(pos_track,1,l)

	anim_player.play("traveling")
#	AM.start_animation(self)
	anim_player.queue("exploding")


func _on_changed_animation(old_anim_name, _new_anim_name):
	if old_anim_name== "traveling":
		affect_tiles()


	
func callbackOnHit(target:Unit):
	target.take_damage(damage)
	target.add_status_effect(burning.new())
