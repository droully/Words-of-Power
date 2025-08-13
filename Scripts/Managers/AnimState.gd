
# Base State (optional)
# --------------------
class_name AnimState
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
class Free extends AnimState:
	var timer = 0
	var name = "Free"


class Ongoing extends AnimState:
	var timer = 0
	var name = "Ongoing"

static var states = {
	"Free": Free.new(),
	"Ongoing": Ongoing.new(),
}
static var starting_state= "Free"
