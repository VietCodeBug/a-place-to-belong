extends Node3D
## Residents share one small ground graph. Only visible actors animate per frame.

const NPC = preload("res://scripts/story/prototype/npc_actor.gd")
const PLAN = preload("res://scripts/world/village_a_layout.gd")
const LAND = preload("res://scripts/world/landscape.gd")
const AREA := Rect2i(-23,100,52,73)
const NEAR_RANGE := 28.0
var stage: Node
var registry: Dictionary = {}
var stations: Dictionary = {}
var layout: Dictionary
var graph := AStarGrid2D.new()
var valid_cells: Array[Vector2i] = []
var probe := PhysicsShapeQueryParameters3D.new()
var baked_rows := 0
var ready_to_visit := false
var elapsed := 0.0
var social_elapsed := 0.0
var nearby_label: Node3D
var overheard_label: Label3D
var overheard_timeout := 0.0
var exchange: Dictionary = {}
var exchange_line := 0
var heard_this_visit: Dictionary = {}

func setup(owner_stage: Node, draft_layout: Dictionary) -> void:
	stage = owner_stage
	layout = draft_layout
	graph.region = AREA
	graph.diagonal_mode = AStarGrid2D.DIAGONAL_MODE_NEVER
	graph.default_estimate_heuristic = AStarGrid2D.HEURISTIC_MANHATTAN
	graph.update()
	var clearance := BoxShape3D.new()
	clearance.size = Vector3(.74,1.38,.74)
	probe.shape = clearance
	probe.collision_mask = 1
	probe.exclude = [stage.hub.player.get_rid()]

func bake_rows(count: int) -> void:
	var space := get_world_3d().direct_space_state
	for z in range(AREA.position.y+baked_rows,AREA.position.y+mini(baked_rows+count,AREA.size.y)):
		for x in range(AREA.position.x,AREA.end.x):
			var cell := Vector2i(x,z)
			var y := LAND.height_at(x,z)
			probe.transform = Transform3D(Basis.IDENTITY,Vector3(x,y+.90,z))
			var bed_edge := x>=-10 and x<=-6 and z>=118 and z<=122
			var blocked := bed_edge or not space.intersect_shape(probe,1).is_empty()
			if blocked:
				graph.set_point_solid(cell)
			else:
				valid_cells.append(cell)
	baked_rows += count
	if baked_rows>=AREA.size.y:
		create_residents()
		ready_to_visit = true

func create_residents() -> void:
	var reserved: Dictionary = {}
	var home_offsets: Dictionary = {}
	var village: Node = stage.hub.get_node("A1RiverValley/VillageA")
	for index in stage.snapshot.residents.size():
		var profile: Dictionary = stage.snapshot.residents[index]
		var id: String = profile.id
		var household: String = profile.household_id
		var lot: Node3D = village.get_node(layout.homes[household])
		var offset: int = home_offsets.get(household,0)
		home_offsets[household] = offset+1
		var entry := lot.to_global(Vector3((offset-1)*.80,0,3.1+offset*.26))
		var anchor := Vector2(entry.x,entry.z)
		var home := reserve(anchor,reserved)
		var job: Array = layout.work_sites[index]
		var work := reserve(Vector2(job[0],job[1]),reserved)
		var meeting_site := PLAN.COMMON+Vector2((index%6-2.5)*1.25,(floori(index/6.0)-2)*1.17)
		if index>=12:
			meeting_site = Vector2(6.5+(index%4-1.5)*1.75,140+index%5*4.0)
		meeting_site = {"VLA-01":Vector2(3,127),"VLA-04":Vector2(4,127),"VLA-06":Vector2(4,129),
			"VLA-23":Vector2(6,128),"VLA-18":Vector2(14,132),"VLA-19":Vector2(15,131)}.get(id,meeting_site)
		var social := reserve(meeting_site,reserved)
		var person := NPC.new()
		person.name = id
		add_child(person)
		var at := Vector2(work if current_slot(index,id)==2 else home)
		person.setup(profile,index,at,stage)
		person.face(at+Vector2(.6,-.8).rotated(index*2.3))
		registry[id] = person
		stations[id] = [home,work,social]
		stage.session.memory(id)
		plan(person,index)

func reserve(ideal: Vector2, used: Dictionary) -> Vector2i:
	var closest := Vector2i.ZERO
	var range_sq := INF
	for cell in valid_cells:
		var dist := Vector2(cell).distance_squared_to(ideal)
		if dist<range_sq and not used.has(cell):
			closest = cell
			range_sq = dist
	used[closest] = true
	return closest

func current_slot(index: int, id: String) -> int:
	var hour: float = stage.weather.hours
	if stage.activities.in_progress(id):
		return 2
	if hour<6.7 or hour>=19.0+float(index%4)*.24:
		return 0
	if hour<7.7+float(index%5)*.22:
		return 1
	var lunch := 12.0+float(index%4)*.43
	if hour>=lunch and hour<lunch+1.45:
		return 3
	return 2

func plan(person: Node3D, index: int) -> void:
	var id: String = person.data.id
	var slot := current_slot(index,id)
	if slot==person.schedule_slot or person.talking:
		return
	person.schedule_slot = slot
	person.task = ["REST","IDLE","WORK","SOCIALIZE"][slot]
	var at: Vector2i = stations[id][[0,0,1,2][slot]]
	if Vector2(at).distance_to(person.point)<.065:
		person.route.clear()
		return
	# If a shift changes mid-leg, finish the current grid edge before changing direction.
	var from := Vector2i(person.route[0]) if not person.route.is_empty() else Vector2i(person.point.round())
	var path := graph.get_id_path(from,at)
	person.route.clear()
	for cell in path:
		var point := Vector2(cell)
		if point.distance_to(person.point)>.065:
			person.route.append(point)

func _physics_process(delta: float) -> void:
	if not ready_to_visit:
		bake_rows(6)
		return
	var observer: Vector2 = stage.exterior_observer()
	elapsed += delta
	var tick := elapsed>=.24
	var step := elapsed
	if tick:
		elapsed = 0.0
	var nearest := NEAR_RANGE*NEAR_RANGE
	var chosen: Node3D
	for id in registry:
		var person: Node3D = registry[id]
		if tick:
			var index := int(id.get_slice("-",1))-1
			plan(person,index)
			var distance: float = person.point.distance_squared_to(observer)
			var visible: bool = not stage.inside and distance<NEAR_RANGE*NEAR_RANGE
			if visible and distance<4.2*4.2 and distance<nearest:
				nearest = distance
				chosen = person
			if visible and not person.active:
				person.position = person.grounded(person.point)
			person.expose(visible)
		if person.active:
			person.advance(delta,observer)
		elif tick:
			person.advance(step,observer)
	if tick:
		set_nearby_label(chosen)
		social_elapsed += step
		if social_elapsed>=2.0:
			overhear(social_elapsed)
			social_elapsed = 0.0

func set_nearby_label(person: Node3D) -> void:
	if nearby_label==person:
		return
	if is_instance_valid(nearby_label):
		nearby_label.visual.name_label.hide()
	nearby_label = person
	if person!=null:
		person.visual.name_label.show()

func overhear(step: float) -> void:
	var observer: Vector2 = stage.exterior_observer()
	if observer.distance_to(PLAN.COMMON)>46.0:
		heard_this_visit.clear()
	if is_instance_valid(overheard_label):
		overheard_timeout -= step
		if overheard_timeout>0.0 and eligible(exchange,observer):
			return
		overheard_label.hide()
		overheard_label = null
	if not exchange.is_empty():
		if exchange_line<exchange.lines.size() and eligible(exchange,observer):
			play_line()
			return
		exchange.clear()
	for candidate in stage.snapshot.overheard:
		if heard_this_visit.has(candidate.id) or not eligible(candidate,observer):
			continue
		exchange = candidate.duplicate()
		exchange_line = 0
		heard_this_visit[candidate.id] = true
		play_line()
		return

func eligible(candidate: Dictionary, observer: Vector2) -> bool:
	if candidate.is_empty() or stage.conversation.is_open() or stage.inside:
		return false
	var first: Node3D = registry[candidate.actors[0]]
	var second: Node3D = registry[candidate.actors[1]]
	return first.behavior=="SOCIALIZE" and second.behavior=="SOCIALIZE" and first.point.distance_to(second.point)<=4.0 \
		and first.point.distance_to(observer)<=6.0

func play_line() -> void:
	var line: Dictionary = exchange.lines[exchange_line]
	var speaker: Node3D = registry[line.speaker_id]
	overheard_label = speaker.visual.gesture_label
	overheard_label.text = line.text_vi
	overheard_label.show()
	overheard_timeout = 3.8
	exchange_line += 1

func active_count() -> int:
	var visible := 0
	for person in registry.values():
		visible += int(person.active)
	return visible
