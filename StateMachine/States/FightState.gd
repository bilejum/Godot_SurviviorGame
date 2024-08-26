extends Node

var player = null
var enenmy
var move_direction
func _ready():
	player = get_parent().get_parent()

func enter_condition() -> bool:
	if player.current_village and enenmy == null:
		if player.current_village.hostile_with !=null:
			return true
	return false

func update(delta: float) -> void:
	if enenmy != null:
		move_toward_enenmy()
		player.velocity = move_direction * player.MAX_SPEED
		move_animate()
		player.interact()





func exit_condition() -> bool:
	#player.current_village.hostile_with.residents.size()<= 0
	if enenmy == null or player.current_village.hostile_with == null:
		return true
	return false
func on_enter() -> void:
	print("Entered FightState")
	enenmy = player.current_village.hostile_with.residents[randi_range(0,player.current_village.hostile_with.residents.size()-1)]


func on_exit() -> void:
	print("Exited FightState")

func move_toward_enenmy():
	if enenmy:
		move_direction =player.position.direction_to(enenmy.position)

func move_animate():
	if player.velocity.x >0:
		player.get_node('Sprite2D').flip_h = false
	if player.velocity.x < 0:
		player.get_node('Sprite2D').flip_h = true

	if not player.velocity.is_zero_approx():
		player.animation_player.play('walk')
		player.move_and_slide()


func _on_basic_human_is_death_signal() -> void:
	enenmy = null
