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
var spell: Spell


signal spell_cast(spell)

func _ready():
	pass
	
func _process(_delta):
	if battle_state==BattleState.Anim:
		if AM.anim_state == AM.AnimationState.Finished:
			if is_instance_valid(spell):
				spell.queue_free()

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
					move(order["unit"], order["move_tile"])
					battle_state=BattleState.Anim
					
				if order["action"]=="cast":
					cast_spell(enemy,order["spell"], order["target"])
					battle_state=BattleState.Anim


func _input(event):
	match user_action_state:
		UserActionState.Move:
			if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
				var cursor_position = BF.mouse_to_tile(event.position)
				if  BF.get_unit_in_tile(cursor_position) or not BF.tile_inside_BF(cursor_position):
					pass
				elif move(player,cursor_position): 
					user_action_state=UserActionState.None
					player_chose_action = true
			if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_RIGHT and event.pressed:
					user_action_state=UserActionState.None
		UserActionState.Cast:
			if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
				var cursor_position = BF.mouse_to_tile(event.position)

				if cast_spell(player,spellname_to_cast, cursor_position):
					user_action_state=UserActionState.None
					player_chose_action = true
			if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_RIGHT and event.pressed:
					user_action_state=UserActionState.None

func cast_spell(caster:Unit,spell_name:String,target_tile):
	spell= get_spell_by_name(spell_name)
	spell.initialize(BF,caster,BF.map_to_local(target_tile))
	BF.add_child(spell)
	spell.hide()
	
	emit_signal("spell_cast",spell)
	spell.spell_effect.connect(_on_unit_affected)

	if BF.distance(target_tile,caster.tile_position)>spell.srange:
		return false
	spell.show()
	var targets = spell.targeting(target_tile)


	for target in targets:
		if target:
			spell.effect(target)

	
	
	spell.animation()
	
	return true

func get_spell_by_name(spell_name: String):
	var basespell_rsc = load("res://Scenes/Spells/"+spell_name+".tscn").instantiate()
	var spell = basespell_rsc.duplicate()
	return spell

func move(unit,target_tile):
	if BF.distance(target_tile,unit.tile_position)>unit.speed:
		return false
	else:
		return BF.place_unit_on_tile(unit,target_tile.x,target_tile.y)

func push(unit, direction: Vector2i):	
	var target_tile = unit.tile_position + direction  # chequear colisiones
	move(unit,target_tile)

func _on_unit_affected(effect,arg_dict):
	match effect:
		"attack":			
			arg_dict["target"].take_damage(arg_dict["damage"])
		"push":
			push(arg_dict["target"],arg_dict["dir"])





func _on_move_pressed():
	user_action_state=UserActionState.Move
	
func _on_spell_button_pressed(spell_name):
	user_action_state=UserActionState.Cast
	spellname_to_cast=spell_name
	
