extends Node
class_name StateMachine

var states_dict = {"Battle":BattleState,"Anim":AnimState}

@onready var BM: BattleManager = $"../../BattleManager"
@onready var AM = $"../../AnimationManager"
@onready var UI = $"../../UIManager"
@export_enum("Battle","Anim") var states_type: String


var current_state
var history = []
var states = {}

func _ready():
	# Instantiate state objects
	var states_source = states_dict[states_type]
	states = states_source.states
	current_state = states[states_source.starting_state]
	

	# Initialize each state
	for state in states.values():
		state.initialize(self)

	# Pick initial state
	current_state.enter()

func change_to(state_name):
	history.append(current_state)
	set_state(state_name)

func back():
	if history.size() > 0:
		set_state(history.pop_back())

func set_state(state_name):
	current_state.exit()
	current_state = states[state_name]
	current_state.enter()

func _process(delta):
	if current_state and current_state.has_method("process"):
		current_state.process(delta)

func _input(event):
	if current_state and current_state.has_method("input"):
		current_state.input(event)
