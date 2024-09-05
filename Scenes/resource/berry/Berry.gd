extends StaticBody2D

var health = 10
signal pick_up_berry
var world
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	world = get_parent().get_parent()


func _on_pick_up_berry() -> void:
	print('被采了')
	if health <=1:
		world.berrys.erase(self)
		queue_free()
	else :
		health -=1
