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
var spellname_to_cast :String

var command : Command
var commandStack = []




func _ready():
	pass
	
func _process(_delta):
	if battle_state==BattleState.Anim:
		if AM.anim_state == AM.AnimationState.Finished:

			var last=turn_queue.pop_front()
			turn_queue.append(last)
			battle_state=BattleState.Turn

	else:
		var current= turn_queue[0]
		match current:
			player:
				if player_chose_action:
					player_chose_action = false
					battle_state=BattleState.Anim

			enemy:
				var ai=enemy.get_node("AI")
				var order=ai.execute_turn(self,BF) 

				if order["action"]=="move":
					var moveCommand = MoveCommand.new(order["unit"], order["move_tile"], BF)	
					setCommand(moveCommand)
					executeCommand()
					battle_state=BattleState.Anim
					
				if order["action"]=="cast":			
					
					var spell=get_spell_by_name(order["spell"])
					var castCommand = CastCommand.new(enemy,spell,order["target"], BF,_on_unit_affected)
					setCommand(castCommand)
					Events.spell_effect.connect(_on_unit_affected)
					executeCommand()
					battle_state=BattleState.Anim


func _input(event):
	if Input.is_action_pressed("ui_undo"):
		undoLastCommand()
	
	match user_action_state:
		UserActionState.Move:
			if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
				var cursor_position = BF.mouse_to_tile(event.position)
				var moveCommand = MoveCommand.new(player, cursor_position, BF)	
				setCommand(moveCommand)
					
				if  BF.get_unit_in_tile(cursor_position) or not BF.tile_inside_BF(cursor_position):
					pass
				elif BF.distance(cursor_position, player.tile_position) > player.speed:
					pass
				elif executeCommand(): 
					user_action_state=UserActionState.None
					player_chose_action = true
			if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_RIGHT and event.pressed:
					user_action_state=UserActionState.None
		UserActionState.Cast:
			if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
				var cursor_position = BF.mouse_to_tile(event.position)
				
				var spell=get_spell_by_name(spellname_to_cast)
				var castCommand = CastCommand.new(player,spell,cursor_position, BF,_on_unit_affected)

				
				setCommand(castCommand)
				if executeCommand():
					user_action_state=UserActionState.None
					player_chose_action = true
			if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_RIGHT and event.pressed:
					user_action_state=UserActionState.None


func get_spell_by_name(spell_name: String):
	var basespell_rsc = load("res://Scenes/Spells/"+spell_name+".tscn").instantiate()
	var spell = basespell_rsc.duplicate()
	return spell

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

func _on_move_pressed():
	user_action_state=UserActionState.Move
	
func _on_spell_button_pressed(spell_name):
	user_action_state=UserActionState.Cast
	spellname_to_cast=spell_name
	
