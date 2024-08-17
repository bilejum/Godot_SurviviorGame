extends CharacterBody2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer

const MAX_SPEED = 20
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	walk()
	if Input.is_action_pressed('interact'):
		interact()
	
func walk():
	var x_direction = Input.get_axis('ui_left','ui_right') as int
	var y_direction = Input.get_axis('ui_up','ui_down') as int
	velocity = Vector2(x_direction,y_direction) * MAX_SPEED
	
	if velocity.x >0:
		$Sprite2D.flip_h = false
	if velocity.x < 0:
		$Sprite2D.flip_h = true
		
	if not velocity.is_zero_approx():
		animation_player.play('walk')
		move_and_slide()

func interact():
	var tool := get_tree().get_nodes_in_group('tool')
	print(tool)
	tool[0].swing()
		
	
