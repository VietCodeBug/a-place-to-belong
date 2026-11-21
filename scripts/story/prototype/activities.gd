extends Node3D

const S = preload("res://scripts/world/shapes.gd")
const USE = preload("res://scripts/story/prototype/interaction.gd")
const HAZEL := "VLA-01"
const OWEN := "VLA-04"
const CAN := Vector2(-4.1,121.7)
const PATCHES := [Vector2(-4.8,118.8),Vector2(-4.8,120.2)]
const BENCH := Vector2(16.3,126.4)
const REPAIR := Vector2(15.52,126.44)
var stage: Node
var targets: Dictionary = {}
var watering_can: Node3D
var carried_can: Node3D
var soil: Array[MeshInstance3D] = []
var wooden_piece: MeshInstance3D
var loose_latch: MeshInstance3D

func setup(owner_stage: Node) -> void:
	stage = owner_stage
	var p: Vector3 = ground(CAN)
	watering_can = Node3D.new()
	watering_can.position = p+Vector3.UP*.18
	add_child(watering_can)
	var tin := CylinderMesh.new()
	tin.top_radius = .127
	tin.bottom_radius = .15
	tin.height = .27
	tin.radial_segments = 12
	S.mesh(watering_can,tin,Vector3.ZERO,"5E827B")
	S.beam(watering_can,Vector3(.09,.015,0),Vector3(.34,.17,0),.043,"628A7E")
	S.box(watering_can,Vector3(.35,.17,0),Vector3(.09,.07,.10),"91A193")
	carried_can = watering_can.duplicate() as Node3D
	carried_can.scale = Vector3.ONE*.74
	carried_can.position = Vector3(.34,.61,-.07)
	stage.hub.player.model.add_child(carried_can)
	for i in PATCHES.size():
		var bed: Vector2 = PATCHES[i]+Vector2(-1.05,.20)
		soil.append(S.box(self,ground(bed)+Vector3.UP*.088,Vector3(.71,.034,.59),"987452"))
		for dx in [-.19,0.0,.19]:
			var seedling := Vector3(dx,.16,0)
			S.box(self,ground(bed)+seedling,Vector3(.061,.13,.056),"597447")
			S.box(self,ground(bed)+seedling+Vector3(.05,.06,0),Vector3(.14,.041,.093),"779155")
	var bench: Vector3 = ground(BENCH)
	S.box(self,bench+Vector3.UP*.41,Vector3(.99,.82,1.03),"FFFFFF",true).hide()
	S.box(self,bench+Vector3.UP*.74,Vector3(1.02,.13,1.08),"805D43")
	for x in [-.37,.37]:
		for z in [-.39,.39]:
			S.box(self,bench+Vector3(x,.38,z),Vector3(.13,.76,.13),"5E4C39")
	wooden_piece = S.box(self,bench+Vector3(0,.84,0),Vector3(.62,.08,.30),"A17B50")
	wooden_piece.rotation.y = -.26
	loose_latch = S.box(self,bench+Vector3(.03,.90,.02),Vector3(.24,.049,.077),"866249")
	loose_latch.rotation.y = -.68
	point("watering_can","Lấy bình tưới",CAN,take_can)
	for i in PATCHES.size():
		point("garden_%d" % i,"Tưới luống %d" % (i+1),PATCHES[i],water.bind(i))
	point("repair_piece","Giữ chi tiết gỗ",REPAIR,repair)
	refresh()

func ground(p: Vector2) -> Vector3:
	return stage.hub.ground(p.x,p.y)

func point(id: String, label: String, p: Vector2, command: Callable) -> void:
	var target := USE.new()
	target.name = id
	target.position = ground(p)
	target.interaction_name = label
	target.interaction_radius = .91
	target.action = command
	add_child(target)
	targets[id] = target

func supports(id: String) -> bool:
	return id in [HAZEL,OWEN]

func progress(id: String) -> int:
	return int(stage.session.activities.get(id,0))

func in_progress(id: String) -> bool:
	return progress(id)>0 and not stage.session.memory(id).activity_done if supports(id) else false

func begin(id: String) -> void:
	if not supports(id) or stage.session.memory(id).activity_done or progress(id)>0:
		return
	stage.session.activities[id] = 1
	refresh()
	stage.hub.ui.story_notice("Lấy bình ở mép vườn, tưới hai luống rồi trả bình." if id==HAZEL else "Tới bàn sửa và giữ chi tiết gỗ.")

func abandon(id: String) -> void:
	if not in_progress(id):
		return
	stage.session.activities.erase(id)
	if id==HAZEL:
		stage.session.object_state("watering_can","by_garden")
		for index in soil.size():
			stage.session.object_state("garden_%d" % index,"dry")
	else:
		stage.session.object_state("wooden_latch","loose")
	refresh()

func take_can() -> void:
	if progress(HAZEL)==1:
		stage.session.activities[HAZEL] = 2
		stage.session.object_state("watering_can","carried")
		stage.hub.ui.story_notice("Mang bình tới hai luống cây non.")
	elif progress(HAZEL)==4:
		stage.session.object_state("watering_can","returned")
		finish(HAZEL,"gardener_helped")
	refresh()

func water(index: int) -> void:
	var id := "garden_%d" % index
	if not in_progress(HAZEL) or progress(HAZEL)<2 or stage.session.objects.get(id)=="watered":
		return
	stage.session.object_state(id,"watered")
	stage.session.activities[HAZEL] = progress(HAZEL)+1
	splash(PATCHES[index]+Vector2(-1.04,.21))
	stage.hub.ui.story_notice("Đã tưới đủ hai luống. Trả bình ở mép vườn." if progress(HAZEL)==4 else "Một luống đã được tưới.")
	refresh()

func repair() -> void:
	if progress(OWEN)==1:
		stage.session.object_state("wooden_latch","held")
		stage.session.activities[OWEN] = 2
		stage.hub.ui.story_notice("Đã giữ miếng gỗ. Chỉnh chốt rồi thử lại.")
	elif progress(OWEN)==2:
		stage.session.object_state("wooden_latch","fixed")
		finish(OWEN,"repairer_helped")
	refresh()

func finish(id: String, flag_id: String) -> void:
	stage.session.memory(id).activity_done = true
	stage.session.flag(flag_id)
	stage.conversation.activity_feedback(id)

func splash(at: Vector2) -> void:
	var center := ground(at)
	for i in 7:
		var offset := Vector3(sin(i*2.39),0,cos(i*2.39))*.19
		var drop := S.box(self,center+offset+Vector3.UP*(.42+(i%3)*.11),Vector3(.023,.12,.028),"91BCC8")
		var falling := create_tween()
		falling.tween_property(drop,"position:y",center.y+.17,.27).set_delay(i*.035)
		falling.tween_callback(drop.queue_free)

func refresh() -> void:
	var garden_step := progress(HAZEL)
	var garden_active := in_progress(HAZEL)
	var can_target: Node3D = targets.watering_can
	can_target.interaction_name = "Trả bình tưới" if garden_step==4 else "Lấy bình tưới"
	can_target.set_available(garden_active and garden_step in [1,4])
	watering_can.visible = not garden_active or garden_step==1
	carried_can.visible = garden_active and garden_step>=2
	for index in soil.size():
		var id := "garden_%d" % index
		var watered: bool = stage.session.objects.get(id)=="watered"
		soil[index].material_override = S.material("504F37" if watered else "987452")
		targets[id].set_available(garden_active and garden_step>=2 and not watered)
	var repair_step := progress(OWEN)
	var repair_target: Node3D = targets.repair_piece
	repair_target.interaction_name = "Chỉnh và thử chốt" if repair_step==2 else "Giữ chi tiết gỗ"
	repair_target.set_available(in_progress(OWEN))
	var latch: String = stage.session.objects.get("wooden_latch","loose")
	wooden_piece.rotation.y = -.26 if latch=="loose" else 0.0
	loose_latch.rotation.y = 0.0 if latch=="fixed" else -.68
	loose_latch.material_override = S.material("527352" if latch=="fixed" else "866249")
