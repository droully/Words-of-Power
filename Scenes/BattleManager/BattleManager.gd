extends Node

@onready var player = $"../Battlefield/Player"

@onready var BF :BattleField = get_node("../Battlefield")  
@onready var AM = get_node("../AnimationManager")
@onready var BS = $"../BattleState"
@onready var turn_queue = [] 

#enum BattleState {Status,Turn,Anim}

enum UserActionState {None,Move,Cast,Deploy}
var user_current_action = UserActionState.None

var spell_to_cast : Spell
var current_unit : Unit

var command #no :Command

func _ready():
	Events.spell_button_pressed.connect(_on_spell_button_pressed)
	

func _process(_delta):
	BS.current_state.process(_delta)


func enemy_turn(unit):
	var ai=unit.get_node("AI")
	var enemy_command=ai.execute_turn(self,BF) 
	setCommand(enemy_command)
	executeCommand()


func _input(event):	
	BS.current_state.input(event)

func deploy_input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		var cursor_position = BF.mouse_to_tile(event.position)
		
		if not cursor_position in BF.deployment_area:
			pass 
		elif BF.spawn_unit(player,cursor_position,turn_queue):
			user_current_action=UserActionState.None
			return true
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_RIGHT and event.pressed:
			user_current_action=UserActionState.None

func move_input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		var cursor_position = BF.mouse_to_tile(event.position)
		var moveCommand = Command.Move.new(current_unit, cursor_position, BF)
		setCommand(moveCommand)
		if  BF.get_unit_in_tile(cursor_position) or not BF.tile_inside_BF(cursor_position): #no mover a unidad ni afuera
			pass
		elif len(BF.grid.get_point_path(cursor_position, current_unit.tile_position))-1 > current_unit.speed:
			pass
		elif executeCommand(): 
			user_current_action=UserActionState.None
			return true
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_RIGHT and event.pressed:
			user_current_action=UserActionState.None

func cast_input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		var cursor_position = BF.mouse_to_tile(event.position)
		var castCommand = Command.Cast.new(current_unit,spell_to_cast,cursor_position, BF)
		setCommand(castCommand)
		if executeCommand():
			user_current_action=UserActionState.None
			spell_to_cast=null
			return true
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_RIGHT and event.pressed:
			user_current_action=UserActionState.None
			spell_to_cast=null

func setCommand(_command):
	self.command = _command

func executeCommand():
	if command:
		if command.execute():
			return true
	return false


func _on_move_button_pressed():
	user_current_action=UserActionState.Move

func _on_spell_button_pressed(spell):
	user_current_action=UserActionState.Cast
	spell_to_cast=spell

