extends Control

@onready var BM = get_node("../BattleManager")
@onready var BF = get_node("../Battlefield")
@onready var player = get_node("../Battlefield/Player")
@onready var turn_label= $Turn
@onready var state_label=$State
@onready var actions_container= $ActionsContainer
@onready var Layer = BF.Layer

var spells_UI = ["Water Arc","Fire Ball","Air Slash","Earth Bind"]
var spells_Name = ["water_arc","fire_ball","air_slash","earth_bind"]

var last_highlighted_tile = Vector2i(-1, -1)
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
		
func _input(event):
	match BM.user_action_state:
		BM.UserActionState.Move:
			move_highlight(event)
		BM.UserActionState.Cast:
			cast_highlight(event)
#		_:
#			BF.set_cell(Layer.Highlight,last_highlighted_tile)

func move_highlight(event):
	if event is InputEventMouseMotion :
		var tile_position = BF.mouse_to_tile(event.position)
		for tile in last_highlighted_tiles:
			BF.set_cell(Layer.Highlight,tile)#reset
		
		if  tile_position in player.walkable_tiles(BF):	
			var path = BF.grid.get_id_path(player.tile_position,tile_position)
			for tile in path:
				BF.set_cell(Layer.Highlight,tile,1,Vector2i(0,0)) #Vector2i(0,0): amarillo
			last_highlighted_tiles = path
		else:
			last_highlighted_tiles = []
			
func cast_highlight(event):
	if event is InputEventMouseMotion :
		var tile_position = BF.mouse_to_tile(event.position)
		for tile in last_highlighted_tiles:
			BF.set_cell(Layer.Highlight,tile)#reset
		# Clear the previously highlighted tile (set it to -1 which means no tile)
		BF.set_cell(Layer.Highlight,last_highlighted_tile)
		if BF.tile_inside_BF(tile_position):
			var affected_tiles= BM.spell_to_cast.affected_tiles(tile_position,player,BF)
			for tile in affected_tiles:
				BF.set_cell(Layer.Highlight,tile,1,Vector2i(1,0))

			last_highlighted_tiles = affected_tiles
		else:
			last_highlighted_tiles = []  # Reset

func _process(_delta):
	turn_label.text=BM.turn_queue[0].unit_name
	state_label.text=BM.BattleState.keys()[BM.battle_state]

	match BM.turn_queue[0]:
		BM.player:
			$TurnContainer/EnemyTurnUI.hide()
			$TurnContainer/PlayerTurnUI.show()

		BM.enemy:
			$TurnContainer/PlayerTurnUI.hide()
			$TurnContainer/EnemyTurnUI.show()

	match BM.user_action_state:
		BM.UserActionState.Move:
			for tile in player.walkable_tiles(BF):
				if BF.get_cell_source_id(Layer.Highlight, tile) !=-1:
					pass
				else:
					BF.set_cell(Layer.Highlight,tile,1,Vector2i(2,0))

		BM.UserActionState.Cast:
			for tile in BM.spell_to_cast.targeteable_tiles(player,BF):
				if BF.get_cell_source_id(Layer.Highlight, tile) !=-1:
					pass
				else:
					BF.set_cell(Layer.Highlight,tile,1,Vector2i(2,0))
		_:

			for tiles in BF.all_tiles():
				BF.set_cell(Layer.Highlight,tiles)

func _on_spell_button_pressed(spell_name):	
	Events.emit_signal("spell_button_pressed",Utils.get_spell_by_name(spell_name))

func _on_move_pressed():
	pass
