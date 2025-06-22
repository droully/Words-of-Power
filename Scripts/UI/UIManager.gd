extends Control

@onready var BM = get_node("../BattleManager")

@onready var highlight_sprite=$BattleFieldAnchor/HighlightSprite
@onready var turn_label= $RightPane/TurnTracker/Turn
@onready var state_label=$RightPane/TurnTracker/State
@onready var turn_queue=$RightPane/TurnQueue
#@onready var actions_container= $ActionsContainer
#@onready var Highlight_Layer = BF.highlight
#@onready var SpellBook = $"../Spellbook"

#@onready var spells_UI = SpellBook.spell_names_UI
#@onready var spells_Name = SpellBook.spell_names


var last_highlighted_tiles: Array = []

#signal spell_button_pressed(spell_name)

func _ready():
	pass
func _input(_event):
	pass
	#
#func move_highlight(event):
	#if event is InputEventMouseMotion :
		#var tile_position = BF.map.mouse_to_tile(event.position)
		#BF.highlight.reset_highlight(last_highlighted_tiles)
		#
		#if  tile_position in BM.current_unit.walkable_tiles():	
			#var path = []#BF.map.path_between_tiles(BM.current_unit.tile_position,tile_position)
			#BF.highlight.highlight_tiles(path,Vector2i(0,0))
			#last_highlighted_tiles = path
		#else:
			#last_highlighted_tiles = []
			#
#func cast_highlight(event):
	#if event is InputEventMouseMotion :
		#var tile_position = BF.map.mouse_to_tile(event.position)
		#BF.highlight.reset_highlight(last_highlighted_tiles)
		#
		#if BF.map.tile_inside_BF(tile_position):
			#
			#var affecting = Affecting.new()
			#var affected_tiles= affecting.affected_tiles(tile_position,BM.player, BM.spell_to_cast, BF)
#
			#BF.highlight.highlight_tiles(affected_tiles,Vector2i(1,0))
#
			#last_highlighted_tiles = affected_tiles
		#else:
			#last_highlighted_tiles = []  # Reset
#
#func deploy_highlight(event):
	#if event is InputEventMouseMotion :
		#var tile_position = BF.map.mouse_to_tile(event.position)
		#highlight_sprite.visible=false
		#if tile_position in BF.deployment_area:
			#highlight_sprite.visible=true
			#highlight_sprite.texture=BM.player_data.sprite			
			#highlight_sprite.position=BF.map.tile_to_position(tile_position)

func _process(_delta):

	state_label.text=BM.BS.current_state.name

	var tq=PackedStringArray([])
	#for unit in BM.turn_queue:
	#	tq.append(unit.unit_name)
	
	#añadir las unidades
	turn_queue.text=" ".join(tq)
