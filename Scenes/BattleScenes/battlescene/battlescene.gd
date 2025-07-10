extends Node2D
class_name BattleScene

@onready var BF : BattleField = $Battlefield
@onready var BM = $BattleManager

var initialized= false

func initialize(_BF: BattleField):
	if self.initialized:
		return
	change_battlefield(_BF)

func _ready():
	Events.debug.connect(_on_debug)
	pass


func change_battlefield(to_BF:BattleField):

	BF.add_sibling(to_BF)
	BF.name = "A"
	BF.queue_free()
	BF = to_BF
	BF.name="Battlefield"
	BM.BF=BF



func _input(event: InputEvent) -> void:
	if event.is_action_pressed("restart_level", true):
		var battlescene :BattleScene =  Utils.switch_level("res://Scenes/BattleScenes/battlescene/battlescene.tscn")

		
		var level= Utils.get_level_by_number(BF.level_number)
		battlescene.initialize(level)
		


func _on_debug():
	change_battlefield(BF)
	
