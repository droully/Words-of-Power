extends Resource



class_name UnitData

enum targeting_methods {
	AreaOfEffect,
	PerpLine,
	PerpTShape,
	Cross
}
enum affecting_methods {
	AreaOfEffect,
	ForwardSegment,
	PerpTShape,
	OPTION_FOUR
}

@export var unit_name: String = "base_unit"
@export var hp: int = 100
@export var max_hp: int = 100
@export var temporal_hp: int = 0

@export var att: int = 10
@export var def: int = 5
@export var speed: int = 1
@export var shield: int = 0
@export var max_shield: int = 1
@export var priority: int = 2

@export var behavior: Script

@export var tags: Array[String] = []
@export var sprite: Texture 
