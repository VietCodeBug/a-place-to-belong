extends Node3D
## Debug entry for the playable Chapter 01 slice. Keeps A1 and the house as separate physics worlds.

const ROOM = preload("res://scenes/world/house_a_interior.tscn")
const PLAN = preload("res://scripts/world/village_a_layout.gd")
const USE = preload("res://scripts/story/prototype/interaction.gd")
const MEMORY = preload("res://scripts/story/prototype/session.gd")
const TALK = preload("res://scripts/story/prototype/conversation.gd")
const NPC = preload("res://scripts/story/prototype/npc_actor.gd")
const POPULATION = preload("res://scripts/story/prototype/village_population.gd")
const WORK = preload("res://scripts/story/prototype/activities.gd")
const S = preload("res://scripts/world/shapes.gd")
const DATA := "res://assets/story/chapter_01/"
var hub: Node3D
var weather: Node
var session := MEMORY.new()
var conversation := TALK.new()
var snapshot: Dictionary
var village: Node3D
var thomas: Node3D
var activities: Node3D
var house: Node3D
var room_view: SubViewport
var room_canvas: CanvasLayer
var outdoor_camera: Camera3D
var outdoor_mask: int
var outdoor_anchor := PLAN.HOUSE_APPROACH[0]
var exterior_door: Node3D
var inside := false
var intro_running := false
var wake_clock := 0.0
var social_tick := 0.0

func setup(host: Node3D) -> void:
	hub = host
	weather = hub.get_node("ForestWeather")
	outdoor_camera = hub.get_node("GameplayCamera")
	outdoor_mask = outdoor_camera.cull_mask
	snapshot = read_json("runtime_snapshot.json")
	conversation.setup(self,snapshot)
	hub.ui.story_closed.connect(conversation.close)
	weather.set_time(8.45)
	build_exterior_door()
	build_thomas()
	activities = WORK.new()
	activities.name = "SharedActivities"
	add_child(activities)
	activities.setup(self)
	village = POPULATION.new()
	village.name = "VillagePopulation"
	add_child(village)
	village.setup(self,read_json("village_layout_draft.json"))
	build_room()
	enter_house(true)

func read_json(file: String) -> Dictionary:
	var json: Variant = JSON.parse_string(FileAccess.get_file_as_string(DATA+file))
	assert(json is Dictionary,"Invalid Chapter 01 data: "+file)
	return json

func build_exterior_door() -> void:
	var cottage := hub.get_node("ForestHouseA") as Node3D
	var door_point := cottage.to_global(Vector3(-.49,.48,2.76))
	var approach := Vector2(door_point.x,door_point.z)
	exterior_door = USE.new()
	exterior_door.name = "EnterHouseA"
	exterior_door.position = hub.ground(approach.x,approach.y,.16)
	exterior_door.interaction_name = "Vào Nhà A"
	exterior_door.interaction_radius = 2.05
	exterior_door.action = enter_house.bind(false)
	add_child(exterior_door)

func build_thomas() -> void:
	var at := PLAN.THOMAS
	thomas = NPC.new()
	thomas.name = "Thomas"
	add_child(thomas)
	var profile: Dictionary = snapshot.thomas.profile.duplicate()
	profile["name_en"] = profile.display_name
	thomas.setup(profile,3,at,self)
	var block := at+Vector2(-.48,.65)
	thomas.face(block)
	thomas.set_behavior("WORK")
	var stump := CylinderMesh.new()
	stump.height = .67
	stump.top_radius = .32
	stump.bottom_radius = .38
	stump.radial_segments = 10
	var ground: Vector3 = hub.ground(block.x,block.y)
	S.mesh(self,stump,ground+Vector3.UP*.33,"65523B")
	S.box(self,ground+Vector3.UP*.71,Vector3(.30,.15,.24),"A08458")
	for i in 5:
		var bundle: Vector3 = hub.ground(at.x-1.15+(i%3)*.27,at.y+1.1+floori(i/3.0)*.33)
		S.box(self,bundle+Vector3.UP*.11,Vector3(.61,.24,.22),"826345")

func build_room() -> void:
	room_canvas = CanvasLayer.new()
	room_canvas.name = "InteriorDisplay"
	room_canvas.layer = 0
	add_child(room_canvas)
	var screen := SubViewportContainer.new()
	screen.name = "InteriorSurface"
	screen.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	screen.stretch = true
	screen.mouse_filter = Control.MOUSE_FILTER_IGNORE
	room_canvas.add_child(screen)
	room_view = SubViewport.new()
	room_view.name = "InteriorWorld"
	room_view.size = Vector2i(576,324)
	room_view.own_world_3d = true
	room_view.gui_disable_input = true
	screen.add_child(room_view)
	house = ROOM.instantiate()
	room_view.add_child(house)
	house.setup(inspect,enter_outdoors)
	for id in house.targets:
		session.object_state(id,"intact")

func enter_house(first := false) -> void:
	if inside:
		return
	inside = true
	var player: CharacterBody3D = hub.player
	outdoor_anchor = Vector2(player.position.x,player.position.z)
	hub.superworld.streamer.set_process(false)
	hub.superworld.set_process(false)
	outdoor_camera.set_process(false)
	outdoor_camera.set_process_unhandled_input(false)
	outdoor_camera.cull_mask = 0
	room_canvas.show()
	room_view.render_target_update_mode = SubViewport.UPDATE_ALWAYS
	player.superworld = null
	player.reparent(house,false)
	player.position = house.WAKE if first else house.ENTRY
	player.velocity = Vector3.ZERO
	player.model.rotation.y = .08
	player.blocked = first
	exterior_door.set_available(false)
	for target in house.targets.values():
		target.set_available(true)
	session.object_state("front_door","closed")
	house.update_climate(weather.hours,weather.wetness,current_season())
	house.follow(player.position,0.0,true)
	if first:
		intro_running = true
		wake_clock = 0.0
		player.model.hide()
		show_wake(0.0)
	else:
		session.flag("ch01_home_returned")

func enter_outdoors() -> void:
	if not inside or intro_running:
		return
	inside = false
	var player: CharacterBody3D = hub.player
	var exit: Vector2 = PLAN.HOUSE_APPROACH[0]
	for target in house.targets.values():
		target.set_available(false)
	exterior_door.set_available(true)
	player.reparent(hub,false)
	player.position = hub.ground(exit.x,exit.y,.07)
	player.velocity = Vector3.ZERO
	player.model.rotation.y = PI*.5
	player.superworld = hub.superworld
	player.blocked = false
	hub.superworld.prepare_at(exit)
	hub.superworld.streamer.set_process(true)
	hub.superworld.set_process(true)
	outdoor_camera.cull_mask = outdoor_mask
	outdoor_camera.set_process(true)
	outdoor_camera.set_process_unhandled_input(true)
	outdoor_camera.set_scenic_mode(false,true)
	room_view.render_target_update_mode = SubViewport.UPDATE_DISABLED
	room_canvas.hide()
	session.object_state("front_door","opened")
	if not session.flags.has("ch01_first_exit_complete"):
		session.flag("ch01_first_exit_complete")
		hub.ui.story_notice("Lối mòn dẫn xuống rừng.")

func current_season() -> int:
	return hub.get_node("A1RiverValley").current_season

func skip_intro() -> void:
	intro_running = false
	hub.player.model.show()
	hub.player.blocked = false
	house.follow(hub.player.position,0.0,true)
	hub.ui.story_notice(snapshot.home.localization_draft.vi.CH01001_OBJECTIVE_EXPLORE_AND_EXIT)

func show_wake(blend: float) -> void:
	var eye := Vector3(-2.41,.94,-2.31).lerp(Vector3(-2.36,2.22,.86),blend)
	var aim := Vector3(-2.34,2.75,-1.88).lerp(Vector3(-1.32,.77,-1.63),blend)
	house.camera.look_at_from_position(eye,aim)

func inspect(id: String) -> void:
	var title: String = house.targets[id].interaction_name
	var flags := {"bed_01":"ch01_bed_seen","table_01":"ch01_table_seen","window_01":"ch01_window_seen"}
	var notes := {"bed_01":"Chăn đã sờn, nhưng chiếc giường vẫn chắc.","table_01":"Mặt bàn gỗ cũ, vừa đủ chỗ cho một bữa ăn.",
		"window_01":snapshot.home.localization_draft.vi.CH01001_THOUGHT_02,"kitchen_counter_01":"Vài chiếc bát và một bếp nhỏ."}
	if flags.has(id):
		session.flag(flags[id])
	session.object_state(id,"inspected")
	hub.ui.show_story(title,notes[id],[])

func actor(id: String) -> Node3D:
	return thomas if id=="THOMAS" else village.registry.get(id)

func exterior_observer() -> Vector2:
	return outdoor_anchor if inside else Vector2(hub.player.position.x,hub.player.position.z)

func _process(delta: float) -> void:
	if inside:
		house.update_climate(weather.hours,weather.wetness,current_season())
		if intro_running:
			wake_clock += delta
			show_wake(smoothstep(.80,2.45,wake_clock))
			if wake_clock>=2.45:
				skip_intro()
		else:
			house.follow(hub.player.position,delta)
	social_tick += delta
	if social_tick<.16:
		return
	social_tick = 0.0
	var outside := exterior_observer()
	conversation.track_departure(outside)
	thomas.expose(not inside and outside.distance_to(PLAN.THOMAS)<29.0)
	if thomas.active:
		var close := outside.distance_to(PLAN.THOMAS)<3.5
		thomas.visual.name_label.visible = close
		thomas.set_behavior("TALK_TO_PLAYER" if thomas.talking else "IDLE" if close else "WORK")
		thomas.face(outside if close else PLAN.THOMAS+Vector2(-.48,.65))
	if not inside and not session.flags.has("ch01_faint_trail_discovered"):
		for point: Vector2 in PLAN.HOUSE_APPROACH.slice(2,7):
			if outside.distance_squared_to(point)<4.0*4.0:
				session.flag("ch01_faint_trail_discovered")
				session.flag("ch01_outdoor_intro_complete")
				break
	if not inside and outside.x>-19 and outside.x<29:
		if outside.y>=68 and outside.y<105:
			session.flag("ch01_first_roof_spotted")
		if outside.y>=86 and outside.y<126:
			session.flag("ch01_community_rooftops_seen")
		if outside.y>=101 and outside.y<164:
			session.flag("ch01_community_edge_reached")
