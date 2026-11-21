extends Node3D

const S = preload("res://scripts/world/shapes.gd")
const USE = preload("res://scripts/story/prototype/interaction.gd")
const HAZEL := "VLA-01"
const OWEN := "VLA-04"
const CAN := Vector2(-4.1,121.7)
const PATCHES := [Vector2(-4.8,118.8),Vector2(-4.8,120.2)]
const BENCH := Vector2(16.3,126.4)
const REPAIR := Vector2(15.52,126.44)
const WEDGE := Vector2(15.86,125.27)
var stage: Node
var targets: Dictionary = {}
var watering_can: Node3D
var carried_can: Node3D
var soil: Array[MeshInstance3D] = []
var wooden_piece: MeshInstance3D
var loose_latch: MeshInstance3D
var fitted_wedge: MeshInstance3D
var spare_wedge: MeshInstance3D
var wait_for_npc: Dictionary = {}
var ambient_clock := 0.0

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
	fitted_wedge = S.box(self,bench+Vector3(.17,.91,.09),Vector3(.15,.041,.10),"B69256")
	spare_wedge = S.box(self,ground(WEDGE)+Vector3.UP*.65,Vector3(.15,.05,.10),"C5965C")
	S.box(self,ground(WEDGE)+Vector3.UP*.30,Vector3(.39,.60,.39),"8D6748")
	point("spare_wedge","Lấy miếng nêm",WEDGE,take_wedge)
	point("repair_piece","Giữ chi tiết gỗ",REPAIR,repair)
	refresh()

func ground(p: Vector2) -> Vector3:
	return stage.hub.ground(p.x,p.y)

func point(id: String, label: String, p: Vector2, command: Callable) -> void:
	var target := USE.new()
	target.name = id
	target.position = ground(p)
	target.interaction_name = label
	target.interaction_radius = 1.65
	target.set_meta("focus_at",Vector3.UP*(.86 if id=="repair_piece" else .64 if id=="spare_wedge" else .20))
	target.set_meta("focus_radius",.50 if id.begins_with("garden") else .34)
	target.action = command
	add_child(target)
	targets[id] = target

func supports(id: String) -> bool:
	return id in [HAZEL,OWEN]

func progress(id: String) -> int:
	return int(stage.session.activities.get(id,0))

func in_progress(id: String) -> bool:
	return progress(id)>0 and not stage.session.memory(id).activity_done if supports(id) else false

func begin(id: String, approach: String = "hold") -> void:
	if not supports(id) or stage.session.memory(id).activity_done or progress(id)>0 or stage.session.objects.get(id+"_result")=="self":
		return
	stage.session.activities[id] = 1
	if id==OWEN:
		stage.session.object_state("repair_approach",approach)
	refresh()
	stage.hub.ui.story_notice("Lấy bình ở mép vườn, tưới hai luống rồi trả bình." if id==HAZEL else "Lấy miếng nêm ở ghế cạnh bàn." if approach=="wedge" else "Tới bàn sửa và giữ chi tiết gỗ.")

func abandon(id: String) -> void:
	if not in_progress(id):
		return
	stage.session.activities.erase(id)
	wait_for_npc[id] = 9.0
	if id==HAZEL:
		stage.session.object_state("watering_can","by_garden")
	else:
		stage.session.object_state("wooden_latch","loose")
		stage.session.objects.erase("repair_approach")
	refresh()

func take_can() -> void:
	if progress(HAZEL)==1:
		var watered := 0
		for index in soil.size():
			watered += int(stage.session.objects.get("garden_%d" % index)=="watered")
		stage.session.activities[HAZEL] = 2+watered
		stage.session.object_state("watering_can","carried")
		stage.hub.ui.story_notice("Hai luống đã được tưới. Đặt bình lại." if watered==soil.size() else "Mang bình tới luống còn khô.")
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
	stage.sound("water",ground(PATCHES[index]))
	stage.hub.ui.story_notice("Đã tưới đủ hai luống. Trả bình ở mép vườn." if progress(HAZEL)==4 else "Một luống đã được tưới.")
	refresh()

func take_wedge() -> void:
	if progress(OWEN)==1 and stage.session.objects.get("repair_approach")=="wedge":
		stage.session.activities[OWEN] = 2
		stage.session.object_state("wooden_latch","wedging")
		stage.hub.ui.story_notice("Đặt miếng nêm vào chốt trên bàn sửa.")
		refresh()

func repair() -> void:
	if progress(OWEN)==1:
		stage.session.object_state("wooden_latch","held")
		stage.session.activities[OWEN] = 2
		stage.hub.ui.story_notice("Đã giữ miếng gỗ. Chỉnh chốt rồi thử lại.")
	elif progress(OWEN)==2:
		var wedge: bool = stage.session.objects.get("repair_approach")=="wedge"
		stage.session.object_state("wooden_latch","wedged" if wedge else "fixed")
		create_tween().tween_property(loose_latch,"rotation:y",.15 if wedge else 0.0,.24)
		stage.sound("tap",loose_latch.global_position)
		finish(OWEN,"repairer_helped")
	refresh()

func finish(id: String, flag_id: String) -> void:
	stage.session.memory(id).activity_done = true
	stage.session.object_state(id+"_result","player")
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
	fitted_wedge.visible = stage.session.objects.get("wooden_latch")=="wedged"
	var wedge: bool = stage.session.objects.get("repair_approach")=="wedge"
	targets.spare_wedge.set_available(in_progress(OWEN) and wedge and progress(OWEN)==1)
	spare_wedge.visible = not wedge or progress(OWEN)<2
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
	repair_target.interaction_name = ("Đặt nêm và thử chốt" if wedge else "Chỉnh và thử chốt") if repair_step==2 else "Giữ chi tiết gỗ"
	repair_target.set_available(in_progress(OWEN) and (not wedge or repair_step>=2))
	var latch: String = stage.session.objects.get("wooden_latch","loose")
	wooden_piece.rotation.y = -.26 if latch=="loose" else 0.0
	loose_latch.rotation.y = .15 if latch=="wedged" else 0.0 if latch=="fixed" else -.68
	loose_latch.material_override = S.material("527352" if latch in ["fixed","wedged"] else "866249")

func can_offer(id: String) -> bool:
	if not supports(id) or stage.session.objects.has(id+"_result"):
		return false
	var person: Node3D = stage.actor(id)
	return person!=null and person.task=="WORK"

func defer_for_npc(id: String) -> void:
	abandon(id)
	wait_for_npc[id] = 9.0

func _process(delta: float) -> void:
	if stage==null or stage.village==null or not stage.village.ready_to_visit:
		return
	ambient_clock += delta
	if ambient_clock<.5:
		return
	var elapsed := ambient_clock
	ambient_clock = 0.0
	for id in [HAZEL,OWEN]:
		var actor: Node3D = stage.actor(id)
		var workplace := CAN if id==HAZEL else BENCH
		var nearby: bool = not stage.inside and stage.exterior_observer().distance_to(workplace)<18.0
		if in_progress(id) and not nearby:
			abandon(id)
		if actor==null or actor.talking or not can_offer(id) or in_progress(id):
			continue
		if not nearby and not wait_for_npc.has(id):
			continue
		wait_for_npc[id] = float(wait_for_npc.get(id,0.0))+elapsed
		if wait_for_npc[id]>45.0:
			stage.session.object_state(id+"_result","self")
			if id==HAZEL:
				for index in soil.size():
					if nearby and stage.session.objects.get("garden_%d" % index)!="watered":
						splash(PATCHES[index]+Vector2(-1.04,.21))
					stage.session.object_state("garden_%d" % index,"watered")
				if nearby:
					stage.sound("water",ground(PATCHES[0]))
			else:
				stage.session.object_state("wooden_latch","fixed")
				if nearby:
					stage.sound("tap",loose_latch.global_position)
			refresh()
