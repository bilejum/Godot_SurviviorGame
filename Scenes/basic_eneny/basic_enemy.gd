extends CharacterBody2D

const  MAX_SPEED = 20
@export var target := PackedScene
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	walk()

func walk():
	var human := get_tree().get_nodes_in_group('human')
	velocity = global_position.direction_to(human[0].global_position) * MAX_SPEED
	move_and_slide()


func _on_area_2d_area_entered(area: Area2D) -> void:
	print('zhuangshangle')
	queue_free()
