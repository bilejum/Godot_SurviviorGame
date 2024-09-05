extends StaticBody2D
var health = 20
signal take_damage
var world
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	world = get_parent().get_parent()


func _on_take_damage() -> void:
	print('被砍了')
	if health <=1:
		world.trees.erase(self)
		queue_free()
	else :
		health -=1
