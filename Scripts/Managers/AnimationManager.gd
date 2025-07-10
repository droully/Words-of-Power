extends Node

@onready var BM = get_node("../BattleManager")
@onready var AS : StateMachine = $AnimState


var ongoing_animations : Array = []

# Called when the node enters the scene tree for the first time.
func _ready():

	Events.unit_move_anim_end.connect(_on_object_finished_animation)
	Events.unit_move_anim_start.connect(_on_object_started_animation)
	
	Events.spell_cast_anim_end.connect(_on_object_finished_animation)
	Events.spell_cast_anim_start.connect(_on_object_started_animation)

	Events.unit_die.connect(_on_unit_die)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	#print(ongoing_animations)
	pass
func check_anim_state():
	if len(ongoing_animations)>0:
		AS.change_to("Ongoing")
	else:
		AS.change_to("Free")

func is_animation_ongoing() -> bool:
	return "Ongoing" == AS.current_state.name
	
	
	
func _on_object_started_animation(object,anim):
	ongoing_animations.append([object,anim])
	check_anim_state()

func _on_object_finished_animation(object,anim):
	
	ongoing_animations.erase([object,anim])
	check_anim_state()

func _on_unit_die(unit):
	for p in ongoing_animations:
		var object= p[0]
		var anim=p[1]
		if unit==object:
			ongoing_animations.erase([unit,anim])
	check_anim_state()
	
		
