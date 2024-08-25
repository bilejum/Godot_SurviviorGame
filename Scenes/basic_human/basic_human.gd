extends CharacterBody2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var label: Label = $Label
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var nav: NavigationAgent2D = $Navigation/NavigationAgent2D
@onready var nav_timer: Timer = $Navigation/NavTimer
@onready var build_detect: Area2D = $BuildDetect
@onready var resourcelabel: Label = $PanelContainer/Label
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var timer: Timer = $Timer

# 基本信息
# ------------------------
# 移动速度
const MAX_SPEED = 50
# 当前村庄
var current_village = null
# 名字
var human_name : String
# 生命值
var health = 1
# 是否死亡
var is_death  :bool = false
# 代表色
var represent_color = Color(randf(), randf(), randf())
# 精力
@export var energy = 100
# 目标
var target
var world

var inventory = {
	'wood':0 ,
	'food':0
}
# 背包容量
var inventory_limit :int = 5

var can_build = false

var current_state = null

var unit_job = null
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# 赋予角色名称
	human_name = generate_human_name()
	world = get_parent().get_parent()
# Called every frame. 'delta' is the elapsed time since the previous frame.
	label.visible = false
func _process(delta: float) -> void:
	# 走路
	var direction = to_local(nav.get_next_path_position())
	nav.velocity = direction * MAX_SPEED * delta
	move_and_slide()
	if target != null:
		var target_position =target.global_position
		if target_position.distance_to(self.global_position) < 48 or nav.is_target_reached():
			$StateChart.send_event('nav_finished')

	if target == null and current_state == 'find':
		$StateChart.send_event('to idle state')

	if build_detect.get_overlapping_bodies().is_empty():
		can_build = true
	else :
		can_build = false


	if not velocity.is_zero_approx():
		animation_player.play('walk')

	resourcelabel.text = str(inventory.wood + inventory.food)
	label.text = str(human_name) + '\n' + str(unit_job)

func _on_nav_timer_timeout() -> void:
	if target != null:
		nav.target_position = target.position

func _on_navigation_agent_2d_velocity_computed(safe_velocity: Vector2) -> void:
	velocity = safe_velocity
	move_and_slide()

# 生成角色名称
func generate_human_name() -> String:
	var surnames = ["赵","钱","孙","李","周","吴","郑","王","冯","陈","褚","卫","蒋","沈","韩","杨","朱","秦","尤","许","何","吕","施","张","孔","曹","严","华","金","魏","陶","姜","戚","谢","邹","喻","柏","水","窦","章","云","苏","潘","葛","奚","范","彭","郎","鲁","韦","昌","马","苗","凤","花","方","俞","任","袁","柳","酆","鲍","史","唐","费","廉","岑","薛","雷","贺","倪","汤","滕","殷","罗","毕","郝","邬","安","常","乐","于","时","傅","皮","卞","齐","康","伍","余","元","卜","顾","孟","平","黄","和","穆","萧","尹","姚","邵","湛","汪","祁","毛","禹","狄","米","贝","明","臧","计","伏","成","戴","谈","宋","茅","庞","熊","纪","舒","屈","项","祝","董","梁","杜","阮","蓝","闵","席","季","麻","强","贾","路","娄","危","江","童","颜","郭","梅","盛","林","刁","锺","徐","邱","骆","高","夏","蔡","田","樊","胡","凌","霍","虞","万","支","柯","昝","管","卢","莫","经","房","裘","缪","干","解","应","宗","丁","宣","贲","邓","郁","单","杭","洪","包","诸","左","石","崔","吉","钮","龚","程","嵇","邢","滑","裴","陆","荣","翁","荀","羊","於","惠","甄","麴","家","封","芮","羿","储","靳","汲","邴","糜","松","井","段","富","巫","乌","焦","巴","弓","牧","隗","山","谷","车","侯","宓","蓬","全","郗","班","仰","秋","仲","伊","宫","宁","仇","栾","暴","甘","钭","历","戎","祖","武","符","刘","景","詹","束","龙","叶","幸","司","韶","郜","黎","蓟","溥","印","宿","白","怀","蒲","邰","从","鄂","索","咸","籍","赖","卓","蔺","屠","蒙","池","乔","阳","郁","胥","能","苍","双","闻","莘","党","翟","谭","贡","劳","逄","姬","申","扶","堵","冉","宰","郦","雍","却","璩","桑","桂","濮","牛","寿","通","边","扈","燕","冀","僪","浦","尚","农","温","别","庄","晏","柴","瞿","阎","充","慕","连","茹","习","宦","艾","鱼","容","向","古","易","慎","戈","廖","庾","终","暨","居","衡","步","都","耿","满","弘","匡","国","文","寇","广","禄","阙","东","欧","殳","沃","利","蔚","越","夔","隆","师","巩","厍","聂","晁","勾","敖","融","冷","訾","辛","阚","那","简","饶","空","曾","毋","沙","乜","养","鞠","须","丰","巢","关","蒯","相","查","后","荆","红","游","竺","权","逮","盍","益","桓","公","万俟","司马","上官","欧阳","夏侯","诸葛","闻人","东方","赫连","皇甫","尉迟","公羊","澹台","公冶","宗政","濮阳","淳于","单于","太叔","申屠","公孙","仲孙","轩辕","令狐","钟离","宇文","长孙","慕容","司徒","司空","召","有","舜","拉","丛","岳","寸","贰","皇","侨","彤","竭","端","赫","实","甫","集","象","翠","狂","辟","典","良","函","芒","苦","其","京","中","夕","之","章佳","那拉","冠","宾","香","果","觉罗","罗","特","察","兰","罗","纳喇","乌雅","范姜","碧鲁","张廖","张简","图门","太史","公叔","乌孙","完颜","马佳","佟佳","富察","费莫","蹇","称","诺","来","多","繁","戊","朴","回","毓","税","荤","靖","绪","愈","硕","牢","买","但","巧","枚","撒","泰","秘","亥","绍","以","壬","森","斋","释","奕","姒","朋","求","羽","用","占","真","穰","翦","闾","漆","贵","代","贯","旁","崇","栋","告","休","褒","谏","锐","皋","闳","在","歧","禾","示","是","委","钊","频","嬴","呼","大","威","昂","律","冒","保","系","抄","定","化","莱","校","么","抗","祢","綦","悟","宏","功","庚","务","敏","捷","拱","兆","丑","丙","畅","苟","随","类","卯","俟","友","答","乙","允","甲","留","尾","佼","玄","乘","裔","延","植","环","矫","赛","昔","侍","度","旷","遇","偶","前","由","咎","塞","敛","受","泷","袭","衅","叔","圣","御","夫","仆","镇","藩","邸","府","掌","首","员","焉","戏","可","智","尔","凭","悉","进","笃","厚","仁","业","肇","资","合","仍","九","衷","哀","刑","俎","仵","圭","夷","徭","蛮","汗","孛","乾","帖","罕","洛","淦","洋","邶","郸","郯","邗","邛","剑","虢","隋","蒿","茆","菅","苌","树","桐","锁","钟","机","盘","铎","斛","玉","线","针","箕","庹","绳","磨","蒉","瓮","弭","刀","疏","牵","浑","恽","势","世","仝","同","蚁","止","戢","睢","冼","种","涂","肖","己","泣","潜","卷","脱","谬","蹉","赧","浮","顿","说","次","错","念","夙","斯","完","丹","表","聊","源","姓","吾","寻","展","出","不","户","闭","才","无","书","学","愚","本","性","雪","霜","烟","寒","少","字","桥","板","斐","独","千","诗","嘉","扬","善","揭","祈","析","赤","紫","青","柔","刚","奇","拜","佛","陀","弥","阿","素","长","僧","隐","仙","隽","宇","祭","酒","淡","塔","琦","闪","始","星","南","天","接","波","碧","速","禚","腾","潮","镜","似","澄","潭","謇","纵","渠","奈","风","春","濯","沐","茂","英","兰","檀","藤","枝","检","生","折","登","驹","骑","貊","虎","肥","鹿","雀","野","禽","飞","节","宜","鲜","粟","栗","豆","帛","官","布","衣","藏","宝","钞","银","门","盈","庆","喜","及","普","建","营","巨","望","希","道","载","声","漫","犁","力","贸","勤","革","改","兴","亓","睦","修","信","闽","北","守","坚","勇","汉","练","尉","士","旅","五","令","将","旗","军","行","奉","敬","恭","仪","母","堂","丘","义","礼","慈","孝","理","伦","卿","问","永","辉","位","让","尧","依","犹","介","承","市","所","苑","杞","剧","第","零","谌","招","续","达","忻","六","鄞","战","迟","候","宛","励","粘","萨","邝","覃","辜","初","楼","城","区","局","台","原","考","妫","纳","泉","老","清","德","卑","过","麦","曲","竹","百","福","言","第五","佟","爱","年","笪","谯","哈","墨","南宫","赏","伯","佴","佘","牟","商","西门","东门","左丘","梁丘","琴","后","况","亢","缑","帅","微生","羊舌","海","归","呼延","南门","东郭","百里","钦","鄢","汝","法","闫","楚","晋","谷梁","宰父","夹谷","拓跋","壤驷","乐正","漆雕","公西","巫马","端木","颛孙","子车","督","仉","司寇","亓官","鲜于","锺离","盖","逯","库","郏","逢","阴","薄","厉","稽","闾丘","公良","段干","开","光","操","瑞","眭","泥","运","摩","伟","铁","迮"]
	var names = ["赵","钱","孙","李","周","吴","郑","王","冯","陈","褚","卫","蒋","沈","韩","杨","朱","秦","尤","许","何","吕","施","张","孔","曹","严","华","金","魏","陶","姜","戚","谢","邹","喻","柏","水","窦","章","云","苏","潘","葛","奚","范","彭","郎","鲁","韦","昌","马","苗","凤","花","方","俞","任","袁","柳","酆","鲍","史","唐","费","廉","岑","薛","雷","贺","倪","汤","滕","殷","罗","毕","郝","邬","安","常","乐","于","时","傅","皮","卞","齐","康","伍","余","元","卜","顾","孟","平","黄","和","穆","萧","尹","姚","邵","湛","汪","祁","毛","禹","狄","米","贝","明","臧","计","伏","成","戴","谈","宋","茅","庞","熊","纪","舒","屈","项","祝","董","梁","杜","阮","蓝","闵","席","季","麻","强","贾","路","娄","危","江","童","颜","郭","梅","盛","林","刁","锺","徐","邱","骆","高","夏","蔡","田","樊","胡","凌","霍","虞","万","支","柯","昝","管","卢","莫","经","房","裘","缪","干","解","应","宗","丁","宣","贲","邓","郁","单","杭","洪","包","诸","左","石","崔","吉","钮","龚","程","嵇","邢","滑","裴","陆","荣","翁","荀","羊","於","惠","甄","麴","家","封","芮","羿","储","靳","汲","邴","糜","松","井","段","富","巫","乌","焦","巴","弓","牧","隗","山","谷","车","侯","宓","蓬","全","郗","班","仰","秋","仲","伊","宫","宁","仇","栾","暴","甘","钭","历","戎","祖","武","符","刘","景","詹","束","龙","叶","幸","司","韶","郜","黎","蓟","溥","印","宿","白","怀","蒲","邰","从","鄂","索","咸","籍","赖","卓","蔺","屠","蒙","池","乔","阳","郁","胥","能","苍","双","闻","莘","党","翟","谭","贡","劳","逄","姬","申","扶","堵","冉","宰","郦","雍","却","璩","桑","桂","濮","牛","寿","通","边","扈","燕","冀","僪","浦","尚","农","温","别","庄","晏","柴","瞿","阎","充","慕","连","茹","习","宦","艾","鱼","容","向","古","易","慎","戈","廖","庾","终","暨","居","衡","步","都","耿","满","弘","匡","国","文","寇","广","禄","阙","东","欧","殳","沃","利","蔚","越","夔","隆","师","巩","厍","聂","晁","勾","敖","融","冷","訾","辛","阚","那","简","饶","空","曾","毋","沙","乜","养","鞠","须","丰","巢","关","蒯","相","查","后","荆","红","游","竺","权","逮","盍","益","桓","公","万俟","司马","上官","欧阳","夏侯","诸葛","闻人","东方","赫连","皇甫","尉迟","公羊","澹台","公冶","宗政","濮阳","淳于","单于","太叔","申屠","公孙","仲孙","轩辕","令狐","钟离","宇文","长孙","慕容","司徒","司空","召","有","舜","拉","丛","岳","寸","贰","皇","侨","彤","竭","端","赫","实","甫","集","象","翠","狂","辟","典","良","函","芒","苦","其","京","中","夕","之","章佳","那拉","冠","宾","香","果","觉罗","罗","特","察","兰","罗","纳喇","乌雅","范姜","碧鲁","张廖","张简","图门","太史","公叔","乌孙","完颜","马佳","佟佳","富察","费莫","蹇","称","诺","来","多","繁","戊","朴","回","毓","税","荤","靖","绪","愈","硕","牢","买","但","巧","枚","撒","泰","秘","亥","绍","以","壬","森","斋","释","奕","姒","朋","求","羽","用","占","真","穰","翦","闾","漆","贵","代","贯","旁","崇","栋","告","休","褒","谏","锐","皋","闳","在","歧","禾","示","是","委","钊","频","嬴","呼","大","威","昂","律","冒","保","系","抄","定","化","莱","校","么","抗","祢","綦","悟","宏","功","庚","务","敏","捷","拱","兆","丑","丙","畅","苟","随","类","卯","俟","友","答","乙","允","甲","留","尾","佼","玄","乘","裔","延","植","环","矫","赛","昔","侍","度","旷","遇","偶","前","由","咎","塞","敛","受","泷","袭","衅","叔","圣","御","夫","仆","镇","藩","邸","府","掌","首","员","焉","戏","可","智","尔","凭","悉","进","笃","厚","仁","业","肇","资","合","仍","九","衷","哀","刑","俎","仵","圭","夷","徭","蛮","汗","孛","乾","帖","罕","洛","淦","洋","邶","郸","郯","邗","邛","剑","虢","隋","蒿","茆","菅","苌","树","桐","锁","钟","机","盘","铎","斛","玉","线","针","箕","庹","绳","磨","蒉","瓮","弭","刀","疏","牵","浑","恽","势","世","仝","同","蚁","止","戢","睢","冼","种","涂","肖","己","泣","潜","卷","脱","谬","蹉","赧","浮","顿","说","次","错","念","夙","斯","完","丹","表","聊","源","姓","吾","寻","展","出","不","户","闭","才","无","书","学","愚","本","性","雪","霜","烟","寒","少","字","桥","板","斐","独","千","诗","嘉","扬","善","揭","祈","析","赤","紫","青","柔","刚","奇","拜","佛","陀","弥","阿","素","长","僧","隐","仙","隽","宇","祭","酒","淡","塔","琦","闪","始","星","南","天","接","波","碧","速","禚","腾","潮","镜","似","澄","潭","謇","纵","渠","奈","风","春","濯","沐","茂","英","兰","檀","藤","枝","检","生","折","登","驹","骑","貊","虎","肥","鹿","雀","野","禽","飞","节","宜","鲜","粟","栗","豆","帛","官","布","衣","藏","宝","钞","银","门","盈","庆","喜","及","普","建","营","巨","望","希","道","载","声","漫","犁","力","贸","勤","革","改","兴","亓","睦","修","信","闽","北","守","坚","勇","汉","练","尉","士","旅","五","令","将","旗","军","行","奉","敬","恭","仪","母","堂","丘","义","礼","慈","孝","理","伦","卿","问","永","辉","位","让","尧","依","犹","介","承","市","所","苑","杞","剧","第","零","谌","招","续","达","忻","六","鄞","战","迟","候","宛","励","粘","萨","邝","覃","辜","初","楼","城","区","局","台","原","考","妫","纳","泉","老","清","德","卑","过","麦","曲","竹","百","福","言","第五","佟","爱","年","笪","谯","哈","墨","南宫","赏","伯","佴","佘","牟","商","西门","东门","左丘","梁丘","琴","后","况","亢","缑","帅","微生","羊舌","海","归","呼延","南门","东郭","百里","钦","鄢","汝","法","闫","楚","晋","谷梁","宰父","夹谷","拓跋","壤驷","乐正","漆雕","公西","巫马","端木","颛孙","子车","督","仉","司寇","亓官","鲜于","锺离","盖","逯","库","郏","逢","阴","薄","厉","稽","闾丘","公良","段干","开","光","操","瑞","眭","泥","运","摩","伟","铁","迮"]
	# 随机选择一个姓氏和一个名字
	var random_surname = surnames[randi() % surnames.size()]
	var random_name = names[randi() % names.size()]
	# 组合姓氏和名字来生成成人姓名
	return random_surname + random_name

#背包逻辑
# 先判断一下是什么东西，然后添加进背包
func inventory_append(object = null):
	var inventory_num = 0
	for num in inventory.values():
		inventory_num += num
	if inventory_num < inventory_limit:
		inventory[object] +=1
		return false
	else :
		print('背包已满')
		return true
#生成玩家周围随机位置
func find_random_place(radius: float):
	# 生成一个介于0和1之间的随机浮点数
	var random_angle = randf() * TAU # Mathf.TAU是圆的周长，等于2 * PI
	var random_distance = randf_range(0.5,1) * radius  # 生成一个在0到radius之间的随机距离

	# 根据随机角度和距离计算随机点
	var random_point = Vector2(
		random_distance * cos(random_angle),
		random_distance * sin(random_angle)
	)
	# 将随机点添加到角色位置上
	return	position + random_point

# 进入Idle模式
func _on_idle_state_state_entered() -> void:
	await get_tree().create_timer(1)
	# 重置目标和速度
	print('enter idle')
	target = null
	velocity = Vector2.ZERO


	#if current_village !=null and energy <= 40:
		#$StateChart.send_event('to sleep state')
	# 如果没有村庄，就优先建一个村庄
	if current_village == null:
		$StateChart.send_event('to build state')

	#如果有村庄，就随机一个工作
	elif unit_job == null:
		var state_index = randi_range(0,2)
		if state_index == 0:
			$StateChart.send_event('to cope tree state')

		if  state_index == 1:
			$StateChart.send_event('to build state')

		if state_index == 2:
			$StateChart.send_event('to pickup food state')
	elif unit_job == 'farmer':
		$StateChart.send_event('to pickup food state')


# 进入FindTree状态
func _on_find_tree_state_entered() -> void:
	current_state = 'find'
	var trees = world.trees
	var closest_tree = null  # 初始化最近树的变量
	var min_distance = 1000  # 初始化最小距离为无穷大

	for tree in trees:
		if tree != null:
			var distance_to_player = tree.global_position.distance_to(self.global_position)
			if distance_to_player < min_distance:  # 如果当前树距离角色更近
				min_distance = distance_to_player  # 更新最小距离
				closest_tree = tree  # 更新最近树
		else :
			$StateChart.send_event('to idle state')

	if closest_tree != null and is_instance_valid(closest_tree):
		target = closest_tree
		#print(closest_tree.global_position)
	else:
		print("No trees found.")
		$StateChart.send_event('to idle state')


# 进入copeTree
func _on_cope_tree_state_entered() -> void:
	current_state = 'cope tree'
	# 优先判断背包
	if inventory_append('wood'): # 背包是否满检测
		$StateChart.send_event('go to village')
	else :
		$StateChart.send_event('cope_finished')
	# 树被人先砍了
	if not is_instance_valid(target):
		$StateChart.send_event('cope_finished')
	if target !=null:
		if target.global_position.distance_to(self.global_position) < 50:
			var tree = target
			tree.health -=1
			target = null



func _on_go_to_village_state_entered() -> void:
	target = current_village

func _on_clear_inventory_state_entered() -> void:
	current_village.resource.wood += inventory.wood
	current_village.resource.food += inventory.food
	inventory.clear()
	if inventory.is_empty():
		inventory = {
		'wood':0,
		'food':0
	}
		$StateChart.send_event('to idle state')


func _on_detect_place_state_entered() -> void:
	if can_build == true and build_detect.get_overlapping_bodies().is_empty():
		$StateChart.send_event('to build')
	else :
		$StateChart.send_event('to find place')


func _on_find_place_state_entered() -> void:
	if can_build == true and build_detect.get_overlapping_bodies().is_empty():
		$StateChart.send_event('to build')

	else :
		nav.target_position = find_random_place(16*10)
		$StateChart.send_event('to detect place')


func _on_build_state_entered() -> void:
	print('enter build')
	var building = null
	if current_village != null and not current_village.building_list.is_empty():
		# 防止被其它人建了
		building = current_village.building_list[0]
		current_village.building_list.erase(building)
	else :
		$StateChart.send_event('to idle state')

	if current_village == null:
		var new_village = load("res://Scenes/Buildings/village_base/village_base.tscn").instantiate()
		new_village.residents.append(self)
		world.get_node('Building').add_child(new_village)
		current_village = new_village
		new_village.position = self.position + Vector2(16,16)

	else :
		if is_instance_valid(building):
			var new_building = building
			new_building.position = self.position + Vector2(16,16)
			new_building.current_village = current_village
			world.get_node('Building').add_child(new_building)
			current_village.building_list.remove_at(0)

			$StateChart.send_event('to idle state')
		else :
			$StateChart.send_event('to idle state')



func _on_find_food_state_entered() -> void:
	print('zhao guo zi')
	current_state = 'find'
	var berrys = world.berrys
	var have_food_windmill_list = []
	# 有食物才添加进采集可寻找数组
	if unit_job == 'farmer':
		for windmill in current_village.windmill_list:
			if not windmill.ripe_wheatfields.is_empty():
				have_food_windmill_list.append(windmill)
		if current_village != null and not have_food_windmill_list.is_empty():
			berrys = have_food_windmill_list + berrys
	var closest_berry = null  # 初始化最近树的变量
	var min_distance = 1000  # 初始化最小距离为无穷大

	for berry in berrys:
		if berry != null:
			var distance_to_player = berry.global_position.distance_to(self.global_position)
			if distance_to_player < min_distance:  # 如果当前树距离角色更近
				min_distance = distance_to_player  # 更新最小距离
				closest_berry = berry  # 更新最近树
		else :
			$StateChart.send_event('to idle state')

	if closest_berry != null and is_instance_valid(closest_berry):
		target = closest_berry
		#print(closest_tree.global_position)
	else:
		print("No berrys found.")
		$StateChart.send_event('to idle state')


func _on_pickup_food_state_entered() -> void:
	current_state = 'cope berry'
	# 树被人先砍了
	if not is_instance_valid(target):
		$StateChart.send_event('pickup_finished')
	if target !=null:
		if target.global_position.distance_to(self.global_position) < 50:
			var berry = target
			if berry.has_method('get_food'):
				# 这是windmill
					if	berry.get_food():
						berry.food -=1
						if berry.ripe_wheatfields.is_empty():
							target = null
							$StateChart.send_event('to idle state')
						if inventory_append('food'): # 背包是否满检测
							$StateChart.send_event('go to village')
						else :
							$StateChart.send_event('pickup_finished')
					else :
						$StateChart.send_event('to idle state')
			else :
				berry.health -=1
				target = null
				if inventory_append('food'): # 背包是否满检测
					$StateChart.send_event('go to village')
				else :
					$StateChart.send_event('pickup_finished')
	else:
		$StateChart.send_event('to idle state')


func _on_go_village_state_entered() -> void:
	target = current_village


func _on_sleep_state_entered() -> void:
	if target !=null:
		sprite_2d.visible == false
		self.collision_shape_2d.disabled = true
		target =null
		velocity = Vector2.ZERO
		energy +=50
	else :
		$StateChart.send_event('to go village')


func _on_sleep_state_exited() -> void:
		self.visible == true
		self.collision_shape_2d.disabled = false


func _on_go_work_state_entered() -> void:
	$StateChart.send_event('to idle state')


#func _on_timer_timeout() -> void:
	#energy -=1

func _on_mouse_entered_mouse_entered() -> void:
	sprite_2d.modulate = Color(1, 1, 1, 0.5)
	label.visible = true


func _on_mouse_entered_mouse_exited() -> void:
	sprite_2d.modulate = Color(1, 1, 1, 1)
	label.visible = false
