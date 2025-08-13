
# Base State (optional)
# --------------------


class_name BattleState
var FSM

func initialize(_FSM):
	FSM = _FSM

func enter(): pass
func process(_delta): pass
func exit(): pass
func input(_event): pass

# --------------------
# Start State
# --------------------
class Start extends BattleState:
	var timer = 0
	var name = "Start"

	func enter():
		FSM.UI.find_child("BattleStart").visible = true

	func process(delta):
		timer += delta
		if timer > 1:
			FSM.change_to("Turn")

	func exit():
		FSM.UI.find_child("BattleStart").visible = false
		Events.emit_signal("battle_start")

# --------------------
# Turn State
# --------------------
class Turn extends BattleState:
	var commands = []
	var player
	var name = "Turn"


	func enter():
		Events.emit_signal("turn_start")
		player = FSM.BM.player

	func exit():
		commands = []
		for command in commands:
			FSM.BM.set_and_execute_command(command)

	func input(event):
		if FSM.BM.turn_input(event):
			FSM.change_to("Anim")

# --------------------
# Anim State
# --------------------
class Anim extends BattleState:
	var name = "Anim"

	func process(_delta):
		if not FSM.BM.AM.is_animation_ongoing():
			FSM.change_to("Inter")

# --------------------
# Inter State
# --------------------

class Inter extends BattleState:
	var name = "Inter"
	func process(_delta):
		if FSM.BM.BF.win:
			FSM.change_to("End")
		else:
			FSM.change_to("Turn")


# --------------------
# End State
# --------------------

class End extends BattleState:
	var name = "End"
	func enter():
		FSM.UI.find_child("BattleEnd").visible=true

	func exit():
		FSM.UI.find_child("BattleEnd").visible=false

static var states = {
	"Start": Start.new(),
	"Turn": Turn.new(),
	"Anim": Anim.new(),
	"Inter": Inter.new(),
	"End": End.new()
}
static var starting_state= "Start"
