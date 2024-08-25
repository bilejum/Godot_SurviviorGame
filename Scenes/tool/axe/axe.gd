extends Node2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func swing():
	animation_player.play('swing')





func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is CharacterBody2D and body.current_village != self.get_parent().get_parent().current_village:
		body.health -=1
