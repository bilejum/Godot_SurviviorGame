extends Node

@onready var animated_sprite_2d = %AnimatedSprite2D

var player = null

func _ready():
	player = get_parent().get_parent()

func enter_condition() -> bool:
	return Input.is_action_pressed("ui_accept")

func update(delta: float) -> void:
	pass
func exit_condition() -> bool:
	return true

func on_enter() -> void:
	animated_sprite_2d.play("blue")
	print("Entered blueState")

func on_exit() -> void:
	print("Exited blueState")

