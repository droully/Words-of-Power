extends Node

@onready var player = get_node("../Battlefield/Player")

@onready var BF = get_node("../Battlefield")
@onready var AM = get_node("../AnimationManager")
@onready var BS = $BattleState

@onready var turn_queue = [] 

#enum BattleState {Status,Turn,Anim}

enum UserActionState {None,Move,Cast}
var user_action_state = UserActionState.None

var player_chose_action : bool
var spell_to_cast :Spell
var current_unit :Unit

var command 

func _ready():
	Events.spell_button_pressed.connect(_on_spell_button_pressed)
	turn_queue = BF.get_children()
	turn_queue.sort_custom( Utils.priority_compare)
func _process(_delta):
	current_unit= turn_queue[0]
	BS.current_state.process(_delta)


func player_turn():
	if player_chose_action:
		player_chose_action = false
		return true
	else: 
		return false

func enemy_turn(unit):
	var ai=unit.get_node("AI")
	var enemy_command=ai.execute_turn(self,BF) 
	setCommand(enemy_command)
	executeCommand()


func _input(event):	
	BS.current_state.input(event)


func move_input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		var cursor_position = BF.mouse_to_tile(event.position)
		var moveCommand = Command.Move.new(player, cursor_position, BF)
		setCommand(moveCommand)
		if  BF.get_unit_in_tile(cursor_position) or not BF.tile_inside_BF(cursor_position):
			pass
		elif len(BF.grid.get_point_path(cursor_position, player.tile_position))-1 > player.speed:
			pass
		elif executeCommand(): 
			user_action_state=UserActionState.None
			return true
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_RIGHT and event.pressed:
			user_action_state=UserActionState.None

func cast_input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		var cursor_position = BF.mouse_to_tile(event.position)
		var castCommand = Command.Cast.new(player,spell_to_cast,cursor_position, BF)
		setCommand(castCommand)
		if executeCommand():
			user_action_state=UserActionState.None
			return true
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_RIGHT and event.pressed:
			user_action_state=UserActionState.None

func setCommand(_command):
	self.command = _command

func executeCommand():
	if command:
		if command.execute():
			return true
	return false


func _on_move_button_pressed():
	user_action_state=UserActionState.Move
	
func _on_spell_button_pressed(spell):
	user_action_state=UserActionState.Cast
	spell_to_cast=spell
	
