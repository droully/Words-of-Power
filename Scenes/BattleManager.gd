extends Node

@onready var player = get_node("../Battlefield/Player")
@onready var enemy = get_node("../Battlefield/Enemy") 
@onready var UI = get_node("../UIManager")
@onready var BF = get_node("../Battlefield")
@onready var AM = get_node("../AnimationManager")

@onready var turn_queue = [player, enemy] 

enum BattleState {Turn,Anim}
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
	if battle_state==BattleState.Anim:
		if AM.anim_state == AM.AnimationState.Finished:
			next_turn()
	else:
		var current= turn_queue[0]
		match current:
			player:
				player_turn()
			enemy:
				enemy_turn()
				
func next_turn():
			var last=turn_queue.pop_front()
			turn_queue.append(last)
			battle_state=BattleState.Turn

func player_turn():
	if player_chose_action:
		player_chose_action = false
		battle_state=BattleState.Anim

func enemy_turn():
	var ai=enemy.get_node("AI")
	var order=ai.execute_turn(self,BF) 

	if order["action"]=="move":
		var moveCommand = MoveCommand.new(order["unit"], order["move_tile"], BF)	
		setCommand(moveCommand)
		executeCommand()
		battle_state=BattleState.Anim
		
	if order["action"]=="cast":			
		
		var spell=Utils.get_spell_by_name(order["spell"])
		var castCommand = CastCommand.new(enemy,spell,order["target"], BF,_on_unit_affected)
		setCommand(castCommand)
		Events.spell_effect.connect(_on_unit_affected)
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
		var castCommand = CastCommand.new(player,spell_to_cast,cursor_position, BF,_on_unit_affected)

		setCommand(castCommand)
		if executeCommand():
			user_action_state=UserActionState.None
			return true
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_RIGHT and event.pressed:
			user_action_state=UserActionState.None



func push(unit, direction: Vector2i):	
	var target_tile = unit.tile_position + direction  # chequear colisiones
	var moveCommand = MoveCommand.new(unit, target_tile, BF)
	setCommand(moveCommand)
	executeCommand()




func _on_unit_affected(effect,arg_dict):
	match effect:
		"attack":
			arg_dict["target"].take_damage(arg_dict["damage"])
		"push":
			push(arg_dict["target"],arg_dict["dir"])


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
	
