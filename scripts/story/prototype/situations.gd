extends Node3D
## Optional world events use stable IDs and independent world actions.
const S = preload("res://scripts/world/shapes.gd")
const USE = preload("res://scripts/story/prototype/interaction.gd")
const PLAN = preload("res://scripts/world/village_a_layout.gd")
const WOOD := "thomas_wood"
const MEAL := "clara_table"
const LOG_AT := Vector2(-6.15,18.83)
const LOG_STACK := Vector2(-7.62,18.97)
const BOWL_AT := Vector2(3.18,130.31)
const MEAL_TABLE := Vector2(4.85,130.02)
var stage: Node3D
var targets: Dictionary = {}
var log_piece: MeshInstance3D
var bowl: MeshInstance3D
var table_bowl: MeshInstance3D
var local_time: Dictionary = {}
var movement: Tween
var thomas_beat := 0.0
var thomas_applied := false
var round_timer := 0.0

func setup(owner_stage: Node3D) -> void:
	stage = owner_stage
	var log_mesh := CylinderMesh.new()
	log_mesh.top_radius = .14
	log_mesh.bottom_radius = .16
	log_mesh.height = .59
	log_mesh.radial_segments = 10
	log_piece = S.mesh(self,log_mesh,ground(LOG_STACK)+Vector3.UP*.40,"94684B")
	log_piece.rotation = Vector3(PI*.5,0.0,-.13)
	var at := ground(MEAL_TABLE)
	S.box(self,at+Vector3.UP*.74,Vector3(1.06,.11,.73),"826049")
	for side in [-.43,.43]:
		S.box(self,at+Vector3(side,.36,0),Vector3(.12,.73,.52),"674A37")
	var shape := CylinderMesh.new()
	shape.top_radius = .145
	shape.bottom_radius = .08
	shape.height = .09
	shape.radial_segments = 12
	bowl = S.mesh(self,shape,ground(BOWL_AT)+Vector3.UP*.76,"C7B085")
	S.box(self,ground(BOWL_AT)+Vector3.UP*.36,Vector3(.45,.70,.45),"77543E")
	table_bowl = S.mesh(self,shape,at+Vector3.UP*.84,"ACC0A4")
	table_bowl.hide()
	point("loose_log","Nhặt khúc củi",LOG_AT,.18,pickup.bind(WOOD))
	point("woodpile","Xếp củi vào đống",LOG_STACK,.44,finish.bind(WOOD,"player"))
	point("meal_bowl","Lấy bát",BOWL_AT,.77,pickup.bind(MEAL))
	point("meal_table","Đặt bát lên bàn",MEAL_TABLE,.84,finish.bind(MEAL,"player"))
	refresh()

func ground(p: Vector2) -> Vector3:
	return stage.hub.ground(p.x,p.y)

func point(id: String,label: String,p: Vector2,height: float, action: Callable) -> void:
	var prop := USE.new()
	prop.name = id
	prop.position = ground(p)
	prop.set_meta("focus_at",Vector3.UP*height)
	prop.set_meta("focus_radius",.42)
	prop.interaction_name = label
	prop.interaction_radius = 1.55
	prop.action = action
	add_child(prop)
	targets[id] = prop

func status(id: String) -> String:
	return stage.session.objects.get(id,"pending")

func available(id: String) -> bool:
	return status(id)=="available"

func begin(id: String) -> void:
	if not available(id):
		return
	stage.session.object_state(id,"accepted")
	stage.hub.ui.story_notice("Nhặt khúc gỗ vừa lăn ra." if id==WOOD else "Lấy bát ở ghế thấp rồi đặt lên bàn.")
	refresh()

func pickup(id: String) -> void:
	if status(id)!="accepted":
		return
	stage.session.object_state(id,"carried")
	stage.sound("tap",stage.hub.player.global_position)
	refresh()

func finish(id: String, result: String) -> void:
	if result=="player" and status(id)!="carried":
		return
	stage.session.object_state(id,result)
	var actor_id := "THOMAS" if id==WOOD else "VLA-06"
	stage.session.memory(actor_id)[id] = result
	if result=="player":
		stage.session.flag(id+"_helped")
		stage.hub.ui.story_notice("Thomas: Được rồi. Cảm ơn cậu." if id==WOOD else "Clara: Vừa đủ chỗ. Cảm ơn nhé.")
	else:
		stage.session.flag(id+"_resolved_without_player")
	stage.sound("tap",ground(LOG_STACK if id==WOOD else MEAL_TABLE))
	refresh()

func decline(id: String) -> void:
	if status(id) in ["available","accepted","carried"]:
		stage.session.object_state(id,"available")
		local_time[id] = maxf(float(local_time.get(id,0.0)),38.0)
		refresh()

func refresh() -> void:
	var wood := status(WOOD)
	var meal := status(MEAL)
	log_piece.visible = wood!="carried"
	if wood in ["pending","player","self"]:
		log_piece.position = ground(LOG_STACK)+Vector3.UP*.40
	bowl.visible = meal not in ["carried","player","self"]
	table_bowl.visible = meal in ["player","self"]
	targets.loose_log.set_available(wood=="accepted")
	targets.woodpile.set_available(wood=="carried")
	targets.meal_bowl.set_available(meal=="accepted")
	targets.meal_table.set_available(meal=="carried")

func _process(delta: float) -> void:
	if stage==null:
		return
	var thomas: Node3D = stage.thomas
	if thomas.active and not thomas.talking:
		thomas_beat = fposmod(thomas.visual.clock,3.2)
		if thomas_beat>1.58 and thomas_beat<2.3 and not thomas_applied:
			thomas_applied = true
			stage.sound("chop",ground(LOG_STACK))
			if status(WOOD)=="pending":
				stage.session.object_state(WOOD,"available")
				movement = create_tween().set_parallel(true)
				movement.tween_property(log_piece,"position",ground(LOG_AT)+Vector3.UP*.15,.68)
				movement.tween_property(log_piece,"rotation:z",2.4,.68)
		elif thomas_beat<.5:
			thomas_applied = false
	round_timer += delta
	if round_timer<.4:
		return
	var elapsed := round_timer
	round_timer = 0.0
	if stage.village.ready_to_visit and status(MEAL)=="pending":
		var clara: Node3D = stage.actor("VLA-06")
		var grace: Node3D = stage.actor("VLA-23")
		if clara.active and clara.task=="WORK" and grace.task=="WORK" and clara.point.distance_to(grace.point)<8.0:
			stage.session.object_state(MEAL,"available")
	for id in [WOOD,MEAL]:
		var place := LOG_STACK if id==WOOD else MEAL_TABLE
		if status(id) in ["accepted","carried"] and (stage.inside or stage.exterior_observer().distance_to(place)>18.0):
			decline(id)
		if status(id) in ["available","accepted","carried"] and not stage.conversation.is_open():
			local_time[id] = float(local_time.get(id,0.0))+elapsed
			if local_time[id]>62.0 and status(id)=="available":
				finish(id,"self")
