extends Node2D
@onready var label: Label = $CanvasLayer/PanelContainer/Label
@onready var grid_helper: Sprite2D = $GridHelper
@onready var proc_gen_world: Node2D = $proc_gen_world
@export var noise_height_text = NoiseTexture2D
@onready var tile_map: TileMap = $TileMap
@onready var tree_instantce = preload("res://Scenes/resource/tree/tree.tscn")
@onready var berry_instantce = preload("res://Scenes/resource/berry/Berry.tscn")

var villages :Array = []
var trees :Array = []
var berrys :Array = []

# 地图逻辑
var world
var noise:Noise
var height := 128
var width := 128
var noise_value_array :Array

var sourse_id = 0
var water_atlas = Vector2i(0,0)
var grass_atlas = Vector2i(1,0)
var chunk_map = []
func _ready() -> void:
	noise = noise_height_text.noise
	generate_world()
	env_generator()
	generate_chunk()

	print(chunk_map)

func _process(delta: float) -> void:

	label.text = '世界总人口:' + str(Human.human_count) + '\n' + '世界村落总数:' + str(villages.size())
	#set_grid_helper()


func set_grid_helper():
	var mouse_position = get_global_mouse_position()

	var playerMapCoord = proc_gen_world.get_node('TileMap').local_to_map(mouse_position)
	grid_helper.global_position = playerMapCoord * 16

func generate_world():
	for x in range(-width/2,width/2):
		for y in range(-height/2,height/2):
			#var chunk_instance = load("res://Scenes/world/chunk/chunk.tscn")
			#var new_chunk = chunk_instance.instantiate()
			#add_child(new_chunk)
			#new_chunk.global_position = Vector2(x * 16, y* 16)

			var noise_value :float = noise.get_noise_2d(x,y)
			noise_value_array.append(noise_value)
			if noise_value > -0.2:
				tile_map.set_cell(0,Vector2(x,y),0,grass_atlas)
			if noise_value < -0.2:
				tile_map.set_cell(0,Vector2(x,y),0,water_atlas)


func generate_chunk():
	for x in range(-width/2,width/2,8):
		for y in range(-height/2,height/2,8):
			var chunk_instance = load("res://Scenes/world/chunk/chunk.tscn")
			var new_chunk = chunk_instance.instantiate()
			add_child(new_chunk)
			new_chunk.global_position = Vector2(x * 16, y* 16)
			chunk_map.append(new_chunk)

func env_generator():
	# 假设TileMap节点的名称是 "TileMap"
# 假设树的tile ID是1（你需要根据你的TileSet来调整这个值）
	# 你可以根据需要调整这个值来控制树的密度
	var tree_spawn_chance := 0.01
	var berry_spawn_chance : = 0.005
		# 获取TileMap的大小
	var map_coors = tile_map.get_used_cells(0)
	#print(map_coors)
		# 遍历TileMap的每个单元格
	for map_coor in map_coors:
			# 根据概率决定是否在这个单元格放置树
		if randf() < tree_spawn_chance and not tile_map.get_cell_atlas_coords(0,map_coor) == water_atlas:
				# 设置单元格的tile
			var new_tree = tree_instantce.instantiate()
			get_node('Resource').add_child(new_tree)
			new_tree.position = tile_map.map_to_local(map_coor)
			# 将new_tree 添加到世界树列表
			trees.append(new_tree)
			continue

		if randf() < berry_spawn_chance and not tile_map.get_cell_atlas_coords(0,map_coor) == water_atlas:
			var new_berry =berry_instantce.instantiate()
			get_node('Resource').add_child(new_berry)
			new_berry.position = tile_map.map_to_local(map_coor)
			berrys.append(new_berry)
			continue
