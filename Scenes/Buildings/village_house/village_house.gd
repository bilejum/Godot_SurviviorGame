extends StaticBody2D

var current_village = null
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	current_village.population_limit +=5
	current_village.house_list.append(self)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
