extends Node


var player :CharacterBody2D = null
var move_direction :Vector2
func _ready():
	player = get_parent().get_parent()

func enter_condition() -> bool:
	if player.energy < 50:
		return true
	else:
		return false

func update(delta: float) -> void:
	reduce_energy(delta)
	player.velocity = move_direction * player.MAX_SPEED
	move_animate()

	if player.position.distance_squared_to(player.current_village.position) < 1200:
		#print('enter building')
		player.visible = player.energy >= 99
		move_direction = Vector2.ZERO
		increase_energy(delta)

func exit_condition() -> bool:
	if player.energy >= 100:
		return true
	else:
		return false

func on_enter() -> void:
	move_direction = (player.current_village.position - player.position).normalized()
	print("Entered SleepState")

func on_exit() -> void:
	print("Exited SleepState")

func increase_energy(delta):
	player.energy += 10*delta

func reduce_energy(delta):
	player.energy -= 1*delta

func move_animate():
	if player.velocity.x >0:
		player.get_node('Sprite2D').flip_h = false
	if player.velocity.x < 0:
		player.get_node('Sprite2D').flip_h = true

	if not player.velocity.is_zero_approx():
		player.animation_player.play('walk')
		player.move_and_slide()
