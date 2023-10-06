extends Node

@onready var BM = get_node("../BattleManager")



enum AnimationState {Finished,Ongoing}
var anim_state = AnimationState.Finished
var ongoing_animations : Array

# Called when the node enters the scene tree for the first time.
func _ready():

	Events.unit_move_anim_end.connect(_on_object_finished_animation)
	Events.unit_move_anim_start.connect(_on_object_started_animation)
	
	Events.spell_cast_anim_start.connect(_on_object_started_animation)
	Events.spell_cast_anim_end.connect(_on_object_finished_animation)



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func check_anim_state():
	if len(ongoing_animations)>0:
		anim_state = AnimationState.Ongoing
	else:
		anim_state = AnimationState.Finished

func _on_object_started_animation(object):
	ongoing_animations.append(object)
	check_anim_state()

func _on_object_finished_animation(object):
	
	ongoing_animations.erase(object)
	check_anim_state()
	


	

		
