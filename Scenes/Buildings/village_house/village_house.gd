extends StaticBody2D

var current_village = null
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	current_village.population_limit +=5
	current_village.unit_jobs_limit.gatherer +=2
	current_village.unit_jobs_limit.forester +=2
	current_village.unit_jobs_limit.builder +=1
	current_village.house_list.append(self)
