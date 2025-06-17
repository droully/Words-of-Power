extends Resource



class_name SpellData

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
	SingleTarget
}

@export var spell_name: String = "base_spell"
@export var spell_name_UI: String = "Base Spell"
@export var spell_input: String

@export var player_usable: bool = false
@export var sprite: SpriteFrames
@export var animation: Animation

@export var cost: int = 1
@export var srange: int = 1
@export var duration: float = 1
@export var damage: int = 10
@export var radius: int = 1
@export var targeting: targeting_methods = targeting_methods.AreaOfEffect
@export var affecting: affecting_methods = affecting_methods.AreaOfEffect
