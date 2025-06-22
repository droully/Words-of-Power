extends Node

class_name BattleManager

@onready var BF  :BattleField = $"../Battlefield"
@onready var AM = $"../AnimationManager"
@onready var BS = $BattleState
@onready var SpellBook = $"../SpellBook"
@onready var player
@onready var player_data = preload("res://Scenes/Player/player.tres")



#enum UserActionState {None,Move,Cast,Deploy}
#var user_current_action = UserActionState.None

var command #no :Command

func _ready():

	Events.player_created.connect(_on_player_created)
	Events.unit_die.connect(_on_unit_die)
	Events.command_unit_deployed.connect(_on_unit_deployed)

func _process(_delta):
	BS.current_state.process(_delta)

func set_and_execute_command(cmd):
	setCommand(cmd)
	return executeCommand()
	

func _input(event: InputEvent):
	BS.current_state.input(event)
	

func turn_input(event:InputEvent):
	for move_input in Utils.move_inputs:
		if event.is_action_pressed(move_input, true):			
			var target_tile= player.tile_position+Utils.dir2vector[move_input.split("_")[1].to_upper()]
			var moveCommand = Command.Move.new(player, target_tile, BF)
			return set_and_execute_command(moveCommand)

	for spell_input in Utils.spell_inputs:
		if event.is_action_pressed(spell_input, true):
			var spell_to_cast = SpellBook.get_spell_data_from_input(spell_input)
			if spell_to_cast == null:
				return
			var castCommand = Command.Cast.new(player,spell_to_cast, BF)
			return set_and_execute_command(castCommand)


func setCommand(_command):
	self.command = _command

func executeCommand():
	if command:
		if command.execute():
			return true
	return false


func _on_move_button_pressed():
	pass
	#user_current_action=UserActionState.Move

func _on_unit_die(_unit):
	pass
	#turn_queue.erase(unit)
	
func _on_unit_deployed(unit):
	#turn_queue.append(unit)
	if unit.unit_name=="player":
		player=unit
		
func _on_player_created(_player):
	player=_player
