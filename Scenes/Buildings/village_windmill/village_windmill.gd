extends StaticBody2D

var current_village = null
var ripe_wheatfields = []

var workers = []
 # 其实是food来着
var food : int = 0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	current_village.windmill_list.append(self)
	var worker = current_village.residents.pick_random()
	worker.unit_job = 'farmer'
	workers.append(worker)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func get_food():

	var field = ripe_wheatfields.pick_random()
	if field != null:
		field.harvest()
		food +=1
		ripe_wheatfields.erase(field)
		return true
	else :
		return false
