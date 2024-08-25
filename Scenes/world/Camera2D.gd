extends Camera2D
var pull = false
var mousePos
var currentPos
func _physics_process(delta):
	if Input.is_action_just_released("ScrollDown"):
		if zoom.x >= 0.8 and zoom.y >= 0.8:
			zoom.x -= 0.2
			zoom.y -= 0.2
	if Input.is_action_just_released("ScrollUp"):
		if zoom.x <= 4 and zoom.y <= 4:
			zoom.x += 0.2
			zoom.y += 0.2
	if Input.is_action_just_pressed("LMB"):
		mousePos = get_global_mouse_position()
	if Input.is_action_pressed("LMB"):
		currentPos = get_global_mouse_position()
		offset.x -= currentPos.x-mousePos.x
		offset.y -= currentPos.y - mousePos.y
