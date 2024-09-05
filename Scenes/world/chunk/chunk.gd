extends Node2D
@onready var area_2d: Area2D = $Area2D
@onready var detect_timer: Timer = $DetectTimer
@onready var sprite_2d: Sprite2D = $Sprite2D

var outline_color = Color(1, 0, 0, 0)  # 描边颜色，红色
var outline_thickness = 2  # 描边厚度


var current_village = null
var current_kingdom = null

signal occupied

func _ready() -> void:
	print('create suceess')

func _on_detect_timer_timeout() -> void:
	var body_array = area_2d.get_overlapping_bodies()
	if body_array.is_empty():
		return
	else :
		for body in body_array:
			if body.name == 'basic_human':
				body.current_chunk = self


func _on_occupied() -> void:
	print('change')
	sprite_2d.set_visible(true)
