extends Control

@onready var BM = get_node("../BattleManager")
@onready var BF : BattleField = get_node("../Battlefield")

@onready var highlight_sprite=$BattleFieldAnchor/HighlightSprite
@onready var turn_label= $TurnTracker/Turn
@onready var state_label=$TurnTracker/State
@onready var actions_container= $ActionsContainer
@onready var Highlight_Layer = BF.map.Highlight_Layer
@onready var SpellBook = $"../Spellbook"

@onready var spells_UI = SpellBook.spell_names_UI
@onready var spells_Name = SpellBook.spell_names


var last_highlighted_tiles: Array = []

signal spell_button_pressed(spell_name)

func _ready():
	for i in range(len(spells_UI)):
		var button = Button.new()
		button.text = spells_UI[i] 
		
		actions_container.add_child(button)
		button.pressed.connect(_on_spell_button_pressed.bind(spells_Name[i]))


func _input(_event):
	pass
	
func move_highlight(event):
	if event is InputEventMouseMotion :
		var tile_position = BF.map.mouse_to_tile(event.position)
		BF.map.reset_highlight(last_highlighted_tiles)
		
		if  tile_position in BM.current_unit.walkable_tiles():	
			var path = BF.map.path_between_tiles(BM.current_unit.tile_position,tile_position)
			BF.map.highlight_tiles(path,Vector2i(0,0))
			last_highlighted_tiles = path
		else:
			last_highlighted_tiles = []
			
func cast_highlight(event):
	if event is InputEventMouseMotion :
		var tile_position = BF.map.mouse_to_tile(event.position)
		BF.map.reset_highlight(last_highlighted_tiles)
		
		if BF.map.tile_inside_BF(tile_position):
			
			var affecting = Affecting.new()
			var affected_tiles= affecting.affected_tiles(tile_position,BM.player, BM.spell_to_cast, BF)
			for tile in affected_tiles:
				BF.map.set_cell(Highlight_Layer,tile,1,Vector2i(1,0))

			last_highlighted_tiles = affected_tiles
		else:
			last_highlighted_tiles = []  # Reset

func deploy_highlight(event):
	if event is InputEventMouseMotion :
		var tile_position = BF.map.mouse_to_tile(event.position)
		highlight_sprite.visible=false
		if tile_position in BF.deployment_area:
			highlight_sprite.visible=true
			highlight_sprite.texture=BM.player_data.sprite			
			highlight_sprite.position=BF.map.tile_to_position(tile_position)

func _process(_delta):
	turn_label.text=BM.current_party

	state_label.text=BM.BS.current_state.name
	
	var TurnQueue=$TurnQueue
	var tq=PackedStringArray([])
	#for unit in BM.turn_queue:
	#	tq.append(unit.unit_name)
	
	#añadir las unidades
	TurnQueue.text=" ".join(tq)


func _on_spell_button_pressed(spell_name):	
	Events.emit_signal("spell_button_pressed",Utils.get_spell_data_by_name(spell_name))

func _on_move_pressed():
	pass
