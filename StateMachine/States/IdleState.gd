extends Node

var player : CharacterBody2D = null
var move_direction :Vector2
var wander_time : float

func _ready():
	player = get_parent().get_parent()

func enter_condition() -> bool:
	return true

func update(delta: float) -> void:
	if wander_time > 0:
		wander_time -=delta

	else:
		randomize_wander()


	player.velocity = move_direction * player.MAX_SPEED
	move_animate()

	reduce_energy(delta)

func exit_condition() -> bool:
	return true

func on_enter() -> void:
	print("Entered IdleState")
	randomize_wander()

func on_exit() -> void:
	print("Exited IdleState")

func randomize_wander():
	wander_time = randf_range(1,3)
	move_direction = Vector2(randf_range(-1,1),randf_range(-1,1)).normalized()

func move_animate():
	if player.velocity.x >0:
		player.get_node('Sprite2D').flip_h = false
	if player.velocity.x < 0:
		player.get_node('Sprite2D').flip_h = true

	if not player.velocity.is_zero_approx():
		player.animation_player.play('walk')
		player.move_and_slide()

func reduce_energy(delta):
	player.energy -= 1 *delta
