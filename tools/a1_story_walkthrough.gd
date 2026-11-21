extends SceneTree
## Exercises the ordinary controller, E prompts and dialogue buttons along the authored route.
## Optional capture keeps the opening and interaction sequences and cuts long trail transits.

const HUB = preload("res://scenes/world/forest_hub.tscn")
const LAND = preload("res://scripts/world/landscape.gd")
const PLAN = preload("res://scripts/world/village_a_layout.gd")
const CASES = preload("res://scripts/story/prototype/situations.gd")
const WORK = preload("res://scripts/story/prototype/activities.gd")
const MOVEMENT := ["move_left","move_right","move_up","move_down"]
var hub: Node3D
var stage: Node3D
var player: CharacterBody3D
var ui: CanvasLayer
var failed := false
var frames_path := ""
var stills_path := ""
var frame_index := 0
var capturing := false

func _initialize() -> void:
	call_deferred("run")

func check(value: bool, message: String) -> bool:
	if not value:
		failed = true
		push_error(message)
	return value

func pause(seconds: float) -> void:
	for index in ceili(seconds*60.0):
		await physics_frame

func controls_up() -> void:
	for action in MOVEMENT:
		Input.action_release(action)

func path_to(to: Vector2, tolerance := .32) -> bool:
	var initial := to.distance_to(Vector2(player.position.x,player.position.z))
	for tick in ceili((initial+7.0)*28.0):
		var heading := to-Vector2(player.position.x,player.position.z)
		controls_up()
		if heading.length()<tolerance:
			return true
		var desired := atan2(-heading.x,-heading.y)
		player.eyes.yaw = lerp_angle(player.eyes.yaw,desired,.15)
		player.eyes.pitch = lerpf(player.eyes.pitch,-.07,.10)
		var movement := heading.normalized().rotated(player.eyes.yaw)
		Input.action_press("move_left" if movement.x<0 else "move_right",absf(movement.x))
		Input.action_press("move_up" if movement.y<0 else "move_down",absf(movement.y))
		await physics_frame
	controls_up()
	return check(false,"Walk to %s blocked at %s" % [to,player.position])

func follow(points: Array) -> bool:
	for p: Vector2 in points:
		if not await path_to(p,.45):
			return false
	return true

func aim_to(position: Vector3) -> void:
	var camera := player.get_viewport().get_camera_3d()
	player.eyes.aim(position-camera.global_position)
	player.eyes.place(camera,player,0.0,true)

func use(target: Node3D, at: Vector2, tolerance := .24) -> bool:
	if not await path_to(at,tolerance):
		return false
	return await press_target(target)

func press_target(target: Node3D) -> bool:
	await pause(.12)
	for attempt in 3:
		var focus: Vector3 = target.get_meta("focus_at",Vector3.UP*.95)
		aim_to(target.to_global(focus))
		await pause(.13)
		if ui.active==target:
			var event := InputEventAction.new()
			event.action = "interact"
			event.pressed = true
			ui._unhandled_input(event)
			await pause(.40)
			return true
	return check(false,"Expected ray target %s, observed %s at %s / %s" % [target.name,ui.active,player.position,target.global_position])

func talk_to(person: Node3D) -> bool:
	var at: Vector2 = person.point
	var self_point := Vector2(player.position.x,player.position.z)
	if self_point.distance_to(at)>2.2:
		var offset := (self_point-at).normalized()*1.36
		if not await path_to(at+offset,.33):
			return false
	return await press_target(person.target)

func here(target: Node3D) -> Vector2:
	return Vector2(target.global_position.x,target.global_position.z)

func choose(label: String) -> bool:
	for child: Button in ui.story_choices.get_children():
		if child.text==label and child.is_visible_in_tree():
			child.pressed.emit()
			return true
	return check(false,"Missing dialogue choice %s in %s" % [label,ui.story_text.text])

func boundary(record: bool, label := "") -> void:
	if not label.is_empty():
		print("STORY_ROUTE ",frame_index," ",label," ",player.position)
	capturing = record and not frames_path.is_empty()
	if not frames_path.is_empty() or not stills_path.is_empty():
		RenderingServer.render_loop_enabled = capturing

func store_frame() -> void:
	if capturing:
		var path := frames_path+"/%06d.png" % frame_index
		var image := root.get_texture().get_image()
		if image.save_png(path)==OK:
			frame_index += 1

func still(id: String) -> void:
	if stills_path.is_empty():
		return
	var before := RenderingServer.render_loop_enabled
	RenderingServer.render_loop_enabled = true
	await RenderingServer.frame_post_draw
	await RenderingServer.frame_post_draw
	root.get_texture().get_image().save_png(stills_path+"/"+id+".png")
	RenderingServer.render_loop_enabled = before

func setup() -> void:
	TranslationServer.set_locale("vi")
	for argument in OS.get_cmdline_user_args():
		if argument.begins_with("--capture-dir="):
			frames_path = argument.get_slice("=",1)
		elif argument.begins_with("--stills-dir="):
			stills_path = argument.get_slice("=",1)
	if not frames_path.is_empty():
		DirAccess.make_dir_recursive_absolute(frames_path)
		root.size = Vector2i(640,360)
		root.content_scale_size = Vector2i(1024,576)
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_DISABLED)
		RenderingServer.frame_post_draw.connect(store_frame)
	if not stills_path.is_empty():
		DirAccess.make_dir_recursive_absolute(stills_path)
		if frames_path.is_empty():
			root.size = Vector2i(1280,720)
	hub = HUB.instantiate()
	hub.set_meta("story_prototype",true)
	root.add_child(hub)
	stage = hub.story_prototype
	player = hub.player
	ui = hub.ui
	if not frames_path.is_empty():
		# Recording quality setting. Movement, weather, NPCs and interactions run normally.
		hub.get_node("Sun").shadow_enabled = false
		hub.get_node("WorldEnvironment").environment.ssao_enabled = false

func run() -> void:
	setup()
	var completed := await walkthrough()
	controls_up()
	Input.action_release("jog")
	if completed and not failed:
		await extra_checks()
	boundary(false)
	if RenderingServer.frame_post_draw.is_connected(store_frame):
		RenderingServer.frame_post_draw.disconnect(store_frame)
	print("STORY_ROUTE ","PASS" if completed and not failed else "FAIL"," frames=",frame_index)
	hub.queue_free()
	await process_frame
	quit(0 if completed and not failed else 1)

func extra_checks() -> void:
	pass

func walkthrough() -> bool:
	boundary(true,"Nhà A · góc nhìn thứ nhất")
	await pause(.40)
	await still("00-tran-go")
	for i in 240:
		if not stage.intro_running:
			break
		await physics_frame
	if not check(not player.blocked and player.get_world_3d()==stage.room_view.find_world_3d(),"Wake did not enter the interior"):
		return false
	await still("01-phong-ngu")
	if not await press_target(stage.house.targets.bed_01):
		return false
	if not await follow([Vector2(-2.36,-1.48),Vector2(-.71,-1.49),Vector2(.37,-2.61)]):
		return false
	if not await press_target(stage.house.targets.window_01):
		return false
	if not check(stage.house.window_open,"Window did not open"):
		return false
	await pause(.62)
	await still("02-cua-so")
	if not await use(stage.house.targets.kitchen_counter_01,Vector2(2.55,-2.45)):
		return false
	await still("03-goc-bep")
	if not await follow([Vector2(.72,-1.24),Vector2(.78,1.36)]):
		return false
	if not await press_target(stage.house.targets.table_01):
		return false
	await still("04-phong-chung")
	if not await use(stage.house.targets.front_door,Vector2(-.42,2.83)):
		return false
	if not check(not stage.inside and stage.session.flags.get("ch01_first_exit_complete",false),"Door did not exit"):
		return false
	aim_to(stage.exterior_door.global_position+Vector3.UP)
	await pause(.56)
	await still("05-hien-nha")
	Input.action_press("jog")
	if not await follow(PLAN.HOUSE_APPROACH.slice(1,4)):
		return false
	boundary(false)
	if not await follow(PLAN.HOUSE_APPROACH.slice(4,-2)):
		return false
	boundary(true,"Thomas · củi lăn và xếp lại")
	if not await follow(PLAN.HOUSE_APPROACH.slice(-2)):
		return false
	Input.action_release("jog")
	if not await follow(PLAN.THOMAS_APPROACH.slice(1)):
		return false
	aim_to(stage.thomas.global_position+Vector3.UP)
	await pause(1.2)
	await still("06-thomas-bo-cui")
	if not await press_target(stage.thomas.target):
		return false
	await still("07-thomas-lua-chon")
	await pause(1.0)
	if not choose("Xếp lại khúc củi"):
		return false
	if not await use(stage.situations.targets.loose_log,CASES.LOG_AT+Vector2(.92,-.16)):
		return false
	if not await use(stage.situations.targets.woodpile,CASES.LOG_STACK+Vector2(1.0,.37)):
		return false
	await still("08-cui-da-xep")
	if not check(stage.situations.status(CASES.WOOD)=="player","Thomas did not remember the placed log"):
		return false
	if not await use(stage.thomas.target,PLAN.THOMAS+Vector2(.94,.11)):
		return false
	await pause(.7)
	ui.close()
	boundary(false)
	Input.action_press("jog")
	var trail: Array[Vector2] = []
	for p in PLAN.THOMAS_APPROACH.slice(0,-1):
		trail.push_front(p)
	for z in range(19,25):
		trail.append(Vector2(ClearingLayout.path_center(z),z))
	for z in range(25,127,4):
		trail.append(Vector2(LAND.valley_path(z),z))
	if not await follow(trail.slice(0,-7)):
		return false
	boundary(true,"Làng A · quan sát người đi làm")
	if not await follow(trail.slice(-7)):
		return false
	await still("09-lang-a")
	Input.action_release("jog")
	var hazel: Node3D = stage.actor(WORK.HAZEL)
	boundary(true,"Hazel · lấy bình, tưới và trả bình")
	if not await follow([Vector2(2.3,124.1),Vector2(-3.36,122.4)]):
		return false
	if not await talk_to(hazel):
		return false
	await pause(.72)
	if not choose("Giúp tưới hai luống"):
		return false
	var can: Node3D = stage.activities.targets.watering_can
	if not await use(can,WORK.CAN+Vector2(.85,.23)):
		return false
	for index in WORK.PATCHES.size():
		var patch: Node3D = stage.activities.targets["garden_%d" % index]
		if not await use(patch,WORK.PATCHES[index]+Vector2(1.0,0)):
			return false
	await still("10-luong-da-tuoi")
	if not await use(can,WORK.CAN+Vector2(.79,.19)):
		return false
	if not check(stage.session.memory(WORK.HAZEL).activity_done,"Hazel's activity did not finish"):
		return false
	boundary(false)
	Input.action_press("jog")
	if not await follow([Vector2(-3.5,124.5),Vector2(5.68,124.1),Vector2(11.8,123.8),Vector2(14.3,125.6)]):
		return false
	Input.action_release("jog")
	boundary(true,"Owen · lấy và lắp miếng nêm")
	var owen: Node3D = stage.actor(WORK.OWEN)
	if not await talk_to(owen):
		return false
	await still("11-owen-lua-chon")
	if not choose("Thử nêm chốt"):
		return false
	if not await use(stage.activities.targets.spare_wedge,WORK.WEDGE+Vector2(-1.04,.02)):
		return false
	if not await use(stage.activities.targets.repair_piece,WORK.REPAIR+Vector2(-.71,.04)):
		return false
	await still("12-chot-da-nem")
	if not check(stage.session.objects.wooden_latch=="wedged","Alternate repair did not install the wedge"):
		return false
	boundary(false)
	Input.action_press("jog")
	if not await follow([Vector2(14.1,125.2),Vector2(11.9,123.7),trail[-1]]):
		return false
	trail.reverse()
	if not await follow(trail.slice(1,-1)):
		return false
	var home := PLAN.HOUSE_APPROACH.duplicate()
	home.reverse()
	if not await follow(home.slice(0,-4)):
		return false
	boundary(true,"Trở về Nhà A")
	if not await follow(home.slice(-4)):
		return false
	Input.action_release("jog")
	if not await press_target(stage.exterior_door):
		return false
	await pause(.9)
	await still("13-ve-nha")
	return check(stage.inside and stage.session.flags.get("ch01_home_returned",false) and stage.session.objects.bed_01=="made","Return lost house state")
