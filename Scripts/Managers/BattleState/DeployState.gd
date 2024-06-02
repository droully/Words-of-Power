extends Node

var FSM: StateMachine
var BF: BattleField
var BM
var UI
var timer = 0

func initialize(_FSM):
	FSM=_FSM
	BF= FSM.BF
	BM= FSM.BM
	UI= FSM.UI

func enter():
	pass
	
	

func process(_delta):
	BF.map.highlight_tiles(BF.deployment_area,Vector2i(2,0))
	
	
	
func exit():
	#BM.turn_queue = BF.units.get_children()
	#BM.turn_queue.sort_custom(Utils.priority_compare)
	pass

func input(event):
	UI.deploy_highlight(event)
	if BM.deploy_input(event):
		UI.highlight_sprite.visible=false
		FSM.change_to("Turn")
