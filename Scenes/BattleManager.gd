extends Node

@onready var player = get_node("../Battlefield/Player")
@onready var enemy = get_node("../Battlefield/Enemy") 
@onready var UI = get_node("../UIManager")
@onready var BF = get_node("../Battlefield")
@onready var AM = get_node("../AnimationManager")

@onready var turn_queue = [player, enemy] 

enum BattleState {Status,Turn,Anim}
var battle_state = BattleState.Turn

enum UserActionState {None,Move,Cast}
var user_action_state = UserActionState.None

var player_chose_action
var spell_to_cast :Spell

var command : Command
var commandStack = []

func _ready():
	Events.spell_button_pressed.connect(_on_spell_button_pressed)
	
func _process(_delta):
	var current_unit= turn_queue[0]
	if battle_state == BattleState.Status:
		process_status(current_unit)

	if battle_state==BattleState.Turn:
		match current_unit:
			player:
				player_turn()
			enemy:
				enemy_turn()
	if battle_state==BattleState.Anim:
		if AM.anim_state == AM.AnimationState.Finished:
			next_turn()
			
func process_status(unit):
	var status_list=unit.get_node("StatusEffects").get_children()
	
	for status in status_list:
		status.per_turn_effect()
	for status in status_list:
		status.pass_turn()
	battle_state=BattleState.Turn
	
func next_turn():
			var last=turn_queue.pop_front()
			turn_queue.append(last)
			battle_state=BattleState.Status

func player_turn():
	if player_chose_action:
		player_chose_action = false
		battle_state=BattleState.Anim

func enemy_turn():
	var ai=enemy.get_node("AI")
	var enemy_command=ai.execute_turn(self,BF) 
	setCommand(enemy_command)
	executeCommand()
	battle_state=BattleState.Anim

func _input(event):
	if Input.is_action_pressed("ui_undo"):
		undoLastCommand()
	if (player == turn_queue[0]) and (battle_state == BattleState.Turn ):
		match user_action_state:
			UserActionState.Move:
				if move_input(event):
					player_chose_action = true
			UserActionState.Cast:
				
				if cast_input(event):
					player_chose_action = true

func move_input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		var cursor_position = BF.mouse_to_tile(event.position)
		var moveCommand = MoveCommand.new(player, cursor_position, BF)	
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
		var castCommand = CastCommand.new(player,spell_to_cast,cursor_position, BF)
		setCommand(castCommand)
		if executeCommand():
			user_action_state=UserActionState.None
			return true
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_RIGHT and event.pressed:
			user_action_state=UserActionState.None

func setCommand(_command: Command):
	self.command = _command

func executeCommand():
	if command:
		if command.execute():
			commandStack.append(command)  
			return true
	return false

func undoLastCommand():
	if commandStack.size() > 0:
		var lastCommand = commandStack.pop_back()
		lastCommand.undo()

func _on_move_button_pressed():
	user_action_state=UserActionState.Move
	
func _on_spell_button_pressed(spell):
	user_action_state=UserActionState.Cast
	spell_to_cast=spell
	
