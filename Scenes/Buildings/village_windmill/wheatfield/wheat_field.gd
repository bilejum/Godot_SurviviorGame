extends StaticBody2D
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var growth_timer: Timer = $GrowthTimer

var current_windmill = null
var growth_step = 0
var has_been_appended = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	current_windmill = get_parent()
	animated_sprite_2d.play('step1')


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if growth_step ==1 :
		animated_sprite_2d.play('step2')
	elif growth_step == 2:
		animated_sprite_2d.play('step3')
	elif growth_step == 3:
		animated_sprite_2d.play('step4')
		if not has_been_appended:
			has_been_appended = true
			current_windmill.ripe_wheatfields.append(self)

func _on_growth_timer_timeout() -> void:
	var growth_rate = randf()
	if growth_rate <0.5:
		growth_step+=1
	else :
		growth_timer.start()

func harvest():
	animated_sprite_2d.play('step1')
	growth_step =0
	has_been_appended = false
