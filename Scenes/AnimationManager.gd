extends Node

@onready var BM = get_node("../BattleManager")



enum AnimationState {Finished,Ongoing}
var anim_state = AnimationState.Finished
var ongoing_animations : Array

# Called when the node enters the scene tree for the first time.
func _ready():

	BM.player.unit_move_anim_end.connect(_on_object_finished_animation)
	BM.enemy.unit_move_anim_end.connect(_on_object_finished_animation)
	BM.player.unit_move_anim_start.connect(_on_object_started_animation)
	BM.enemy.unit_move_anim_start.connect(_on_object_started_animation)
	
	BM.spell_cast.connect(_on_spell_cast)
	



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func check_anim_state(ongoing_animations):
	if len(ongoing_animations)>0:
		anim_state = AnimationState.Ongoing
	else:
		anim_state = AnimationState.Finished

func _on_object_started_animation(object):
	ongoing_animations.append(object)
	check_anim_state(ongoing_animations)

func _on_object_finished_animation(object):
	
	ongoing_animations.erase(object)
	check_anim_state(ongoing_animations)
	
func _on_spell_cast(spell):
	spell.spell_cast_anim_start.connect(_on_object_started_animation)
	spell.spell_cast_anim_end.connect(_on_object_finished_animation)
	

		
