extends Control

@onready var BM = get_node("../BattleManager")
@onready var BF : BattleField = get_node("../Battlefield")

@onready var turn_label= $TurnTracker/Turn
@onready var state_label=$TurnTracker/State
@onready var actions_container= $ActionsContainer
@onready var Highlight_Layer = BF.Layer.Highlight

var spells_UI = ["Water Arc","Fire Ball","Air Slash","Earth Bind"]
var spells_Name = ["water_arc","fire_ball","air_slash","earth_bind"]


var last_highlighted_tiles: Array = []

signal spell_button_pressed(spell_name)

func _ready():
 # Replace with the actual path to your VBoxContainer.
	# Create new buttons.
	
	for i in range(len(spells_UI)):
		var button = Button.new()
		button.text = spells_UI[i] 
		
		actions_container.add_child(button)
	# Add your logic here to cast the spell or whatever you'd like to do.
		button.pressed.connect(_on_spell_button_pressed.bind(spells_Name[i]))


func _input(_event):
	pass
	
func move_highlight(event):
	if event is InputEventMouseMotion :
		var tile_position = BF.mouse_to_tile(event.position)
		BF.reset_highlight(last_highlighted_tiles)
		
		if  tile_position in BM.current_unit.walkable_tiles(BF):	
			var path = BF.grid.get_id_path(BM.current_unit.tile_position,tile_position)
			BF.highlight_tiles(path,Vector2i(0,0))
			last_highlighted_tiles = path
		else:
			last_highlighted_tiles = []
			
func cast_highlight(event):
	if event is InputEventMouseMotion :
		var tile_position = BF.mouse_to_tile(event.position)
		BF.reset_highlight(last_highlighted_tiles)
		
		if BF.tile_inside_BF(tile_position):
			var affected_tiles= BM.spell_to_cast.affected_tiles(tile_position,BM.current_unit,BF)
			for tile in affected_tiles:
				BF.set_cell(Highlight_Layer,tile,1,Vector2i(1,0))

			last_highlighted_tiles = affected_tiles
		else:
			last_highlighted_tiles = []  # Reset

func deploy_highlight(event):
	if event is InputEventMouseMotion :
		var tile_position = BF.mouse_to_tile(event.position)
		
		if tile_position in BF.deployment_area:
			BM.player.position=BF.tile_to_position(tile_position)

func _process(_delta):
	
	
	if len(BM.turn_queue)>0:
		turn_label.text=BM.turn_queue[0].unit_name
	state_label.text=BM.BS.current_state.name
	
	var TurnQueue=$TurnQueue
	var tq=PackedStringArray([])
	for unit in BM.turn_queue:
		tq.append(unit.unit_name)
	TurnQueue.text=" ".join(tq)


func _on_spell_button_pressed(spell_name):	
	Events.emit_signal("spell_button_pressed",Utils.get_spell_by_name(spell_name))

func _on_move_pressed():
	pass
