extends RichTextLabel


func _ready():
	Events.battle_start.connect(_on_battle_start)
	Events.turn_start.connect(_on_turn_start)
	Events.command_unit_moved.connect(_on_command_unit_moved)
	Events.command_spell_casted.connect(_on_command_spell_casted)

func _on_battle_start():
	text += "Battle Start \n"
	
func _on_turn_start(unit):
	text += unit.unit_name +" turn: \n"

func _on_command_unit_moved(unit,from_tile,to_tile):
	text += unit.unit_name +" moved from " + str(from_tile) + " to " + str(to_tile)+"\n"

func _on_command_spell_casted(caster,spell,target_tile):
	text += caster.unit_name +" casted " +spell.name + " on " + str(target_tile) +"\n"
