extends Node


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print("test")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

# This function is called for every input event.
func _input(event: InputEvent):
	# We are only checking for ONE specific action.
	if Input.is_action_just_pressed("test_action"):
		print("SUCCESS! The 'test_action' was detected correctly.")

	if Input.is_action_just_pressed("move_down"):
		print("SUeasea")
