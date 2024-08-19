extends CharacterBody2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var label: Label = $Label

const MAX_SPEED = 20
var current_village = null
@export var energy = 100
var human_name : String
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	human_name = generate_human_name()
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	walk()
	if Input.is_action_pressed('interact'):
		interact()
	label.text = human_name +'\n'+'所属:' + current_village.village_name + '\n' + str(int(energy))
		
	
	
func walk():
	var x_direction = Input.get_axis('ui_left','ui_right') as int
	var y_direction = Input.get_axis('ui_up','ui_down') as int
	velocity = Vector2(x_direction,y_direction) * MAX_SPEED
	
	if velocity.x >0:
		$Sprite2D.flip_h = false
	if velocity.x < 0:
		$Sprite2D.flip_h = true
		
	if not velocity.is_zero_approx():
		animation_player.play('walk')
		move_and_slide()

func interact():
	var tool := get_tree().get_nodes_in_group('tool')
	print(tool)
	tool[0].swing()
		
func generate_human_name() -> String:
	var surnames = ["赵", "钱", "孙", "李", "周", "吴", "郑", "王"]
	var names = ["伟", "芳", "强", "燕", "秀英", "敏", "静", "丽",'乐','妙','莹','咪']

	# 随机选择一个姓氏和一个名字
	var random_surname = surnames[randi() % surnames.size()]
	var random_name = names[randi() % names.size()]

	# 组合姓氏和名字来生成成人姓名
	return random_surname + random_name
	
