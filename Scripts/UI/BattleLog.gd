extends RichTextLabel


func _ready():
	Events.battle_start.connect(_on_battle_start)
	Events.turn_start.connect(_on_turn_start)
	Events.command_unit_moved.connect(_on_command_unit_moved)
	Events.command_spell_casted.connect(_on_command_spell_casted)
	Events.unit_die.connect(_on_unit_die)
	Events.button_pressed.connect(_on_button_pressed)
	Events.button_unpressed.connect(_on_button_unpressed)

func log_text(text_input):
	text += text_input+"\n"

func _on_battle_start():
	log_text("Battle Start")
	
func _on_turn_start():
	log_text("Turn Start:")

func _on_command_unit_moved(unit,from_tile,to_tile):
	log_text(unit.unit_name +" moved from " + str(from_tile) + " to " + str(to_tile))

func _on_command_spell_casted(caster,spell,target_tile):
	log_text(caster.unit_name +" casted " +spell.name + " on " + str(target_tile))

func _on_unit_die(unit):
	log_text(unit.unit_name+" died")

func _on_button_pressed(_button,tile_position):
	log_text("Button pressed at " + str(tile_position))
	
func _on_button_unpressed(_button,tile_position):
	log_text("Button unpressed at " + str(tile_position))
