extends Node


var FSM: StateMachine
var BF: BattleField
var BM
var UI
var player_chose_action: bool
var player

var commands=[]
func initialize(_FSM):
	FSM=_FSM
	BF= FSM.BF
	BM= FSM.BM
	UI= FSM.UI

func enter():

	Events.emit_signal("turn_start")
	player=BM.player
	
func exit():
	BF.highlight.reset_highlight()
	commands = []
	
	get_tree().call_group("enemy","get_action",commands)
	for command in commands:
		BM.set_and_execute_command(command) 


func process(_delta):

	var targeting = Targeting.new()

	match BM.user_current_action:
		BM.UserActionState.Move:
			BF.highlight.highlight_tiles(player.walkable_tiles(),Vector2i(2,0))
		BM.UserActionState.Cast:
			var l =targeting.targetable_tiles(player, BM.spell_to_cast, BF)
			BF.highlight.highlight_tiles(l,Vector2i(2,0))
		_:
			BF.highlight.reset_highlight()


func input(event:InputEvent):
	
	if BM.turn_input(event):
		FSM.change_to("Anim")

#
	#match BM.user_current_action:
		##BM.UserActionState.Move:
			##UI.move_highlight(event)
				#
		#BM.UserActionState.Cast:
			#UI.cast_highlight(event)
			#if BM.cast_input(event):
				#FSM.change_to("Anim")
				#
##		_:
##			BF.set_cell(Highlight_Layer,last_highlighted_tile)
