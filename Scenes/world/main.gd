extends Node2D
@onready var label: Label = $CanvasLayer/PanelContainer/Label
@onready var grid_helper: Sprite2D = $GridHelper
@onready var tile_map: TileMap = $TileMap
@onready var tree_instantce = preload("res://Scenes/resource/tree/tree.tscn")
@onready var berry_instantce = preload("res://Scenes/resource/berry/Berry.tscn")

var villages :Array = []
var trees :Array = []
var berrys :Array = []
func _ready() -> void:
	env_generator()
func _process(delta: float) -> void:

	label.text = '世界总人口:' + str(Human.human_count) + '\n' + '世界村落总数:' + str(villages.size())
	set_grid_helper()



func set_grid_helper():
	var mouse_position = get_global_mouse_position()

	var playerMapCoord = tile_map.local_to_map(mouse_position)
	grid_helper.global_position = playerMapCoord * 16

func env_generator():
	# 假设TileMap节点的名称是 "TileMap"
# 假设树的tile ID是1（你需要根据你的TileSet来调整这个值）
	# 你可以根据需要调整这个值来控制树的密度
	var tree_spawn_chance := 0.01
	var berry_spawn_chance : = 0.01
		# 获取TileMap的大小
	var map_coors = tile_map.get_used_cells(0)
	#print(map_coors)
		# 遍历TileMap的每个单元格
	for map_coor in map_coors:
			# 根据概率决定是否在这个单元格放置树
		if randf() < tree_spawn_chance:
				# 设置单元格的tile
			var new_tree = tree_instantce.instantiate()
			get_node('Resource').add_child(new_tree)
			new_tree.position = tile_map.map_to_local(map_coor)
			# 将new_tree 添加到世界树列表
			trees.append(new_tree)
			continue

		if randf() < berry_spawn_chance:
			var new_berry =berry_instantce.instantiate()
			get_node('Resource').add_child(new_berry)
			new_berry.position = tile_map.map_to_local(map_coor)
			berrys.append(new_berry)
			continue
