extends Node


var FSM: StateMachine
var BF: BattleField
var BM
var UI
var player_chose_action: bool

func initialize(_FSM):
	FSM=_FSM
	BF= FSM.BF
	BM= FSM.BM
	UI= FSM.UI

func enter():
	BM.current_unit = BM.turn_queue[0]
	
	Events.emit_signal("turn_start",BM.current_unit)

func exit():
	BF.map.reset_highlight()


func process(_delta):
	
	var current_unit= BM.current_unit
	var targeting = Targeting.new()
	BM.current_unit = current_unit
	
	match current_unit.party:
		"player":
			match BM.user_current_action:
				BM.UserActionState.Move:
					BF.map.highlight_tiles(BM.current_unit.walkable_tiles(),Vector2i(2,0))
				BM.UserActionState.Cast:
					var l =targeting.targetable_tiles(current_unit, BM.spell_to_cast, BF)
					BF.map.highlight_tiles(l,Vector2i(2,0))
				_:
					BF.map.reset_highlight()

		"enemy":
			BM.enemy_turn.call(current_unit)
			FSM.change_to("Anim") #delay?

	

func input(event):
	
	if ("player" == BM.current_unit.party):
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
