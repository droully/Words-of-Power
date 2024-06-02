extends Node


var FSM: StateMachine
var BF: BattleField
var BM
var UI
var player_chose_action: bool
var current_unit

func initialize(_FSM):
	FSM=_FSM
	BF= FSM.BF
	BM= FSM.BM
	UI= FSM.UI

func enter():

	Events.emit_signal("turn_start",BM.current_party)
	current_unit= get_tree().get_first_node_in_group(BM.current_party)
	
func exit():
	BF.map.reset_highlight()


func process(_delta):

	var targeting = Targeting.new()

	if BM.is_player_turn():
		match BM.user_current_action:
			BM.UserActionState.Move:
				BF.map.highlight_tiles(current_unit.walkable_tiles(),Vector2i(2,0))
			BM.UserActionState.Cast:
				var l =targeting.targetable_tiles(current_unit, BM.spell_to_cast, BF)
				BF.map.highlight_tiles(l,Vector2i(2,0))
			_:
				BF.map.reset_highlight()

	if BM.is_enemy_turn():
		var commands = []
		
		
		get_tree().call_group(FSM.BM.current_party,"get_action",commands)
		for command in commands:
			BM.set_and_execute_command(command) 
		FSM.change_to("Anim") #delay?

func input(event):
	
	if BM.is_player_turn():
		if BM.move_input(event):
			FSM.change_to("Anim")

		match BM.user_current_action:
			#BM.UserActionState.Move:
				#UI.move_highlight(event)
					
			BM.UserActionState.Cast:
				UI.cast_highlight(event)
				if BM.cast_input(event):
					FSM.change_to("Anim")
					
#		_:
#			BF.set_cell(Highlight_Layer,last_highlighted_tile)

#func player_turn():
	#if player_chose_action:
		#player_chose_action = false
		#return true
	#else: 
		#return false
