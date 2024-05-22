extends Node

class_name StateMachine

@onready var BM = $".."
@onready var BF = $"../../Battlefield"
@onready var AM = $"../../AnimationManager"
@onready var UI = $"../../UIManager"

var current_state
var history = []
var states = {}


func _ready():
	
	match name:
		"AnimState":
			current_state=$Free
		"BattleState":
			current_state=$Start

	for state in get_children():
		state.initialize(self)
		states[state.name] = state
		if current_state.name !=state.name:
			remove_child(state)
	current_state.enter()

func change_to(state_name):
	history.append(current_state.name)
	set_state(state_name)

func back():
	if history.size() > 0:
		set_state(history.pop_back())

func set_state(state_name):
	current_state.exit()
	remove_child(current_state)
	
	current_state = states[state_name]
	add_child(current_state)
	current_state.enter()



