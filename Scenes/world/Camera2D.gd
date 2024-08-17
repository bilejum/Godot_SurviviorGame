extends Camera2D

const CAMERA_SPEED = 5
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var camera_direction = Input.get_vector('camera_right','camera_left','camera_down','camera_up')
	position -=camera_direction * CAMERA_SPEED
	
