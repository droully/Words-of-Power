extends Spell

@onready var anim_player= $AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready():
	pass




# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func animation():
	var anim_speed = 200

	Events.emit_signal("spell_cast_anim_start",self)
	anim_player.animation_finished.connect(_on_finished_animation)
	var anim = anim_player.get_animation("traveling")
	var pos_track = anim.find_track(".:position",0)
	var l = (caster.position.distance_to(target_pos) )/anim_speed

	anim.set_length(l)
	anim.track_set_key_value(pos_track,0,caster.position)
	anim.track_set_key_value(pos_track,1,target_pos)
	anim.track_set_key_time(pos_track,1,l)

	anim_player.play("traveling")
	anim_player.queue("exploding")


func _on_finished_animation(anim_name):

	if anim_name== "exploding":
		Events.emit_signal("spell_cast_anim_end",self)
		queue_free()
	
func effect(target,callback):
	var arg_dict ={"order":"attack","target":target, "damage":damage}
	callback.call("attack",arg_dict)
	return arg_dict
