extends StaticBody2D

var health = 10
var world
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	world = get_parent().get_parent()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if health <=0:
		world.berrys.erase(self)
		self.queue_free()
