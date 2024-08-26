extends StaticBody2D
@onready var label: Label = $Label
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var spawn_villager_timer: Timer = $SpawnVillager
@onready var woodlabel: Label = $PanelContainer/woodlabel
@onready var food_label: Label = $PanelContainer/foodLabel
@onready var popu_label: Label = $PanelContainer/PopuLabel

var village_name : String = ''
var residents = []
var village_level :int = 1
var building_list = []
var building_building_list = []
var resource = {
	'wood': 0,
	'food' : 0
}
var population :int
var population_limit : int = 5
var development :float
var inherit_village : String = 'eva'
var hostile_with : StaticBody2D =null
var represent_color = Color(randf(), randf(), randf())

# 村庄建筑数量
var house_list = []
var windmill_list = []
#signal bulid_a_new_village_signal
# Called when the node enters the scene tree for the first time.
func _ready() -> void:

	village_name = generate_village_name()
	if get_parent().get_parent().villages.size()>0:
		hostile_with_other_village()
	label.visible = false

	get_parent().get_parent().villages.append(self)

	# 初始化村庄资源
	resource = {
		'wood':0,
		'food':0
	}
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if sprite_2d.modulate != represent_color:
		sprite_2d.modulate = represent_color
	label.text = village_name + '\n' + '等级:'+str(village_level) + '\n' + '人口:' + str(population) + '/'+str(population_limit)+ '\n'+'发展:'+ str(int(development)) + '\n'+str(building_list) + '\n' +"继承自"+inherit_village+'\n'+str(hostile_with)
	woodlabel.text = str(resource.wood)
	food_label.text = str(resource.food)
	popu_label.text =str(population)

	development += population * 0.01 *delta
	if development >=5 and resource.wood >=10:
		building_list.append(select_next_building())
		development -=5
		resource.wood -=10

	population = residents.size()

	if population < population_limit and spawn_villager_timer.is_stopped():
		spawn_villager_timer.start()


	if population <= 0:
		queue_free()

	if hostile_with != null:
		if hostile_with.population <=0:
			hostile_with = null

func check_and_build_windmills():
	# 计算应该有的风车数量（每10个人口一个风车）
	var required_windmills = int(population / 10)
	# 如果实际的风车数量少于应有的数量，建造新的风车
	if windmill_list.size() < required_windmills:
		return true
	else :
		return false

func add_resident(resident):
	residents.append(resident)

func generate_village_name() -> String:
	var prefixes = ["吴家", "乐", "妙妙", "咪咪", "严家",'张','王','刘','李','陈','黎','金']
	var suffixes = ["村", "屯", "坊", "庄", "岭"]
	# 随机选择一个前缀和一个后缀
	var random_prefix = prefixes[randi() % prefixes.size()]
	var random_suffix = suffixes[randi() % suffixes.size()]
	# 组合前缀和后缀来生成村庄名称
	return random_prefix + random_suffix

func select_next_building():
	var building_index = randi_range(0,1)

	if building_index ==0:
		return load("res://Scenes/Buildings/village_house/village_house.tscn").instantiate()
	if building_index == 1 and check_and_build_windmills():
		return load("res://Scenes/Buildings/village_windmill/village_windmill.tscn").instantiate()

func _on_spawn_villager_timeout() -> void:
	if population >= population_limit or resource.food <=10:
		spawn_villager_timer.stop()
	else :
		resource.food -= 5
		var new_villager = load("res://Scenes/basic_human/basic_human.tscn").instantiate()
		get_parent().get_parent().get_node("Human").add_child(new_villager)
		new_villager.current_village = self
		new_villager.current_village.add_resident(new_villager)
		new_villager.position = position + Vector2(randf_range(-50,50),randf_range(-50,50))
		new_villager.represent_color = represent_color
		new_villager.sprite_2d.modulate = represent_color

func hostile_with_other_village():
	#hostile_with = get_parent().get_parent().villages[0]
	#get_parent().get_parent().villages[0].hostile_with = self
	pass


func _on_mouse_entered_mouse_entered() -> void:
	sprite_2d.modulate = represent_color * Color(1, 1, 1, 0.5)
	label.visible = true


func _on_mouse_entered_mouse_exited() -> void:
	sprite_2d.modulate = represent_color
	label.visible = false
