extends Node3D
## Debug entry for the playable Chapter 01 slice. Keeps A1 and the house as separate physics worlds.

const ROOM = preload("res://scenes/world/house_a_interior.tscn")
const PLAN = preload("res://scripts/world/village_a_layout.gd")
const USE = preload("res://scripts/story/prototype/interaction.gd")
const MEMORY = preload("res://scripts/story/prototype/session.gd")
const TALK = preload("res://scripts/story/prototype/conversation.gd")
const NPC = preload("res://scripts/story/prototype/npc_actor.gd")
const POPULATION = preload("res://scripts/story/prototype/village_population.gd")
const SITUATIONS = preload("res://scripts/story/prototype/situations.gd")
const WORK = preload("res://scripts/story/prototype/activities.gd")
const SOUND = preload("res://scripts/story/prototype/foley.gd")
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
var situations: Node3D
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
var foley := SOUND.new()
var step_distance := 0.0
var wind_clock := 0.0
var transition_usec: Array[int] = []
var schedule_debug: Label

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
	situations = SITUATIONS.new()
	situations.name = "WorldSituations"
	add_child(situations)
	situations.setup(self)
	if "--npc-debug" in OS.get_cmdline_user_args():
		schedule_debug = Label.new()
		schedule_debug.position = Vector2(18,125)
		schedule_debug.add_theme_font_size_override("font_size",14)
		schedule_debug.add_theme_constant_override("outline_size",7)
		schedule_debug.modulate = Color("EBDFB6")
		hub.ui.root_ui.add_child(schedule_debug)
	build_room()
	enter_house(true)

func read_json(file: String) -> Dictionary:
	var json: Variant = JSON.parse_string(FileAccess.get_file_as_string(DATA+file))
	assert(json is Dictionary,"Invalid Chapter 01 data: "+file)
	return json

func build_exterior_door() -> void:
	var cottage := hub.get_node("ForestHouseA/CottageShell") as Node3D
	var door_point := cottage.to_global(Vector3(-.49,.48,2.76))
	var approach := Vector2(door_point.x,door_point.z)
	exterior_door = USE.new()
	exterior_door.name = "EnterHouseA"
	exterior_door.position = Vector3(approach.x,door_point.y,approach.y)
	exterior_door.set_meta("focus_at",Vector3.UP*.92)
	exterior_door.set_meta("focus_radius",.58)
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
	thomas.task = "WORK"
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
	house.setup(self,open_door)
	for id in house.targets:
		session.object_state(id,"intact")

func enter_house(first := false) -> void:
	if inside:
		return
	var started := Time.get_ticks_usec()
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
	hub.eyes.yaw = -.12 if first else .0
	hub.eyes.pitch = 1.08 if first else .02
	hub.eyes.place(house.camera,player,0.0,true)
	house.door.rotation.y = 0.0
	transition_usec.append(Time.get_ticks_usec()-started)
	if first:
		intro_running = true
		wake_clock = 0.0

	else:
		session.flag("ch01_home_returned")

func open_door() -> void:
	if not inside or intro_running or hub.player.blocked:
		return
	hub.player.blocked = true
	sound("door",house.targets.front_door.position+Vector3.UP,self.house)
	var opening := create_tween()
	opening.tween_property(house.door,"rotation:y",1.23,.32)
	opening.tween_callback(enter_outdoors)

func enter_outdoors() -> void:
	if not inside or intro_running:
		return
	var started := Time.get_ticks_usec()
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
	hub.eyes.yaw = PI*.52
	hub.eyes.pitch = -.05
	outdoor_camera.set_scenic_mode(false,true)
	transition_usec.append(Time.get_ticks_usec()-started)
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
	hub.player.blocked = false
	hub.eyes.pitch = -.04
	hub.eyes.place(house.camera,hub.player,0.0,true)

func sound(kind: String, at: Vector3, parent: Node3D = null) -> void:
	if DisplayServer.get_name()!="headless":
		foley.play(kind,at,parent if parent!=null else self)

func actor(id: String) -> Node3D:
	return thomas if id=="THOMAS" else village.registry.get(id)

func exterior_observer() -> Vector2:
	return outdoor_anchor if inside else Vector2(hub.player.position.x,hub.player.position.z)

func _process(delta: float) -> void:
	var player: CharacterBody3D = hub.player
	if inside:
		house.update_climate(weather.hours,weather.wetness,current_season())
		if intro_running:
			wake_clock += delta
			hub.eyes.pitch = lerpf(1.08,-.04,smoothstep(.65,2.20,wake_clock))
			if wake_clock>=2.20:
				skip_intro()
		hub.eyes.place(house.camera,player,delta)
		wind_clock += delta
		if wind_clock>5.4 and house.window_open:
			wind_clock = 0.0
			sound("wind",Vector3(.37,1.55,-3.60),house)
	if player.is_on_floor() and not player.blocked:
		step_distance += Vector2(player.velocity.x,player.velocity.z).length()*delta
		if step_distance>.96:
			step_distance = 0.0
			sound("wood" if inside else "earth",player.global_position,self.house if inside else self)
	if thomas.active:
		thomas.advance(delta,exterior_observer())
	social_tick += delta
	if social_tick<.16:
		return
	social_tick = 0.0
	if schedule_debug!=null:
		var rows := PackedStringArray(["F8 +1 giờ   ·   F9 −1 giờ   ·   %s" % hub.ui.format_clock(weather.hours)])
		for resident in village.registry.values():
			if resident.active and rows.size()<12:
				rows.append("%s  %s  %s" % [resident.nick,resident.behavior,resident.work_phase if resident.task=="WORK" else ""])
		schedule_debug.text = "\n".join(rows)
	var outside := exterior_observer()
	conversation.track_departure(outside)
	thomas.expose(not inside and outside.distance_to(PLAN.THOMAS)<29.0)
	if thomas.active:
		var close := outside.distance_to(PLAN.THOMAS)<3.5
		thomas.visual.name_label.visible = close
		thomas.set_behavior("TALK_TO_PLAYER" if thomas.talking else "WORK")
		thomas.face(outside if thomas.talking else PLAN.THOMAS+Vector2(-.48,.65))
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

func _unhandled_input(event: InputEvent) -> void:
	if schedule_debug==null or not (event is InputEventKey) or not event.pressed or event.echo:
		return
	if event.physical_keycode in [KEY_F8,KEY_F9]:
		weather.set_time(weather.hours+(1.0 if event.physical_keycode==KEY_F8 else -1.0))
		get_viewport().set_input_as_handled()
