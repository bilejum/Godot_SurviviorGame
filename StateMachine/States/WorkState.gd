extends Node


var player :CharacterBody2D = null
var detection_radius = 16 * 20

func _ready():
	player = get_parent().get_parent()

func enter_condition() -> bool:
	var current_village = player.current_village
	if current_village == null or jugement():
		return true
	else:
		return false

func update(delta: float) -> void:
	pass

func exit_condition() -> bool:
	if player.current_village:
		return true
	else:
		return false

func on_enter() -> void:
	print("Entered BuildBaseState")
	#player.current_village = find_village()
	if player.current_village == null or player.current_village.building_list[0] == 'VillageBase':
					# 如果没有找到村庄，则创建一个
		var current_village = player.current_village
		player.current_village = create_village()
			# 将玩家添加到村庄中
		if current_village != player.current_village:
			player.current_village.add_resident(player)

func on_exit() -> void:
	print("Exited BuildBaseState")

#func find_village():
	## 在这里实现逻辑来查找附近的村庄
	## 这是一个简化的示例，假设场景中有一个名为"Villages"的节点，它包含所有的村庄
	#var villages = get_tree().get_nodes_in_group("building")
	#for village in villages:
		#if village.position.distance_to(player.position) <= detection_radius:
			#return village
	#return null

func create_village():
	var can_build_village:bool = true
	if player.get_parent().get_parent().villages.size() >0 and player.current_village:
		if not player.get_parent().get_parent().villages.is_empty():
			for other_village in player.get_parent().get_parent().villages:
				if is_instance_valid(other_village):
					if player.position.distance_to(other_village.position) < detection_radius:
						can_build_village = false
						return player.current_village
		if can_build_village:
			var new_village = load("res://Scenes/Buildings/village_base/village_base.tscn").instantiate()
			player.get_parent().get_node("../Building").add_child(new_village)
			player.get_parent().get_parent().villages.append(new_village)
			new_village.position = player.position + Vector2(randf_range(-50,50),randf_range(-50,50))

			new_village.inherit_village = player.current_village.village_name
			player.current_village.building_list.erase('VillageBase')
			player.current_village.residents.erase(player)
			player.current_village = new_village
			print('normal fuction create a village')
			#new_village.represent_color = player.represent_color
			return new_village

	if player.get_parent().get_parent().villages.size() == 0:
		#第一个村庄
		var new_village = load("res://Scenes/Buildings/village_base/village_base.tscn").instantiate()
		player.get_parent().get_node("../Building").add_child(new_village)
		new_village.position = player.position + Vector2(randf_range(-50,50),randf_range(-50,50))
		player.get_parent().get_parent().villages.append(new_village)

		new_village.represent_color = player.represent_color
		return new_village

	return player.current_village

	# 将新村庄添加到"Villages"组中
func jugement() ->bool:
	if player.current_village.position.distance_to(player.position) > detection_radius:
		if not player.current_village.building_list.is_empty():
			if player.current_village.building_list[0]=='VillageBase':
				return true
	return false

