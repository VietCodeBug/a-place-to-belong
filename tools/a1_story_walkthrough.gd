extends SceneTree
## Exercises the ordinary controller, E prompts and dialogue buttons along the authored route.
## Optional capture keeps the opening and interaction sequences and cuts long trail transits.

const HUB = preload("res://scenes/world/forest_hub.tscn")
const LAND = preload("res://scripts/world/landscape.gd")
const PLAN = preload("res://scripts/world/village_a_layout.gd")
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
		var movement := heading.normalized().rotated(PI*.25)
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

func use(target: Node3D, at: Vector2, tolerance := .26) -> bool:
	if not await path_to(at,tolerance):
		return false
	await pause(.24)
	if not check(ui.active==target,"Expected E target %s, observed %s at %s" % [target.name,ui.active,player.position]):
		return false
	var event := InputEventAction.new()
	event.action = "interact"
	event.pressed = true
	ui._unhandled_input(event)
	await pause(.12)
	return true

func here(target: Node3D) -> Vector2:
	return Vector2(target.global_position.x,target.global_position.z)

func choose(label: String) -> bool:
	for child: Button in ui.story_choices.get_children():
		if child.text==label and child.is_visible_in_tree():
			child.pressed.emit()
			return true
	return check(false,"Missing dialogue choice %s in %s" % [label,ui.body.text])

func continue_lines(hold := .23) -> void:
	if capturing:
		hold = maxf(hold,.72)
	for index in 30:
		if not ui.story_open or not ui.story_choices.visible or ui.story_choices.get_child_count()!=1:
			return
		var button := ui.story_choices.get_child(0) as Button
		if button.text!="Tiếp":
			return
		await pause(hold)
		button.pressed.emit()

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

func zoom(near: bool) -> void:
	var camera := hub.get_node("GameplayCamera")
	var event := InputEventMouseButton.new()
	event.button_index = MOUSE_BUTTON_WHEEL_UP if near else MOUSE_BUTTON_WHEEL_DOWN
	event.pressed = true
	for step in 7:
		camera._unhandled_input(event)

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

func before_accept(_id: String) -> void:
	pass

func walkthrough() -> bool:
	boundary(true,"Thức dậy ở Nhà A")
	check(stage.inside and stage.intro_running and player.blocked,"Wake state did not lock controls")
	for i in 240:
		if not stage.intro_running:
			break
		await physics_frame
	if not check(not player.blocked and player.get_world_3d()==stage.room_view.find_world_3d(),"Wake did not hand control to the interior"):
		return false
	await still("01-nha-a")
	for id in ["bed_01","window_01","table_01"]:
		var item: Node3D = stage.house.targets[id]
		if not await use(item,here(item)):
			return false
		if not check(ui.panel.visible and stage.session.objects[id]=="inspected","House inspection produced no state"):
			return false
		await pause(.65)
		ui.close()
	await still("02-tu-cua-so")
	if not await use(stage.house.targets.front_door,here(stage.house.targets.front_door)):
		return false
	if not check(not stage.inside and stage.session.flags.get("ch01_first_exit_complete",false),"First door did not exit"):
		return false
	await pause(.7)
	await still("03-ra-rung")
	Input.action_press("jog")
	if not await follow(PLAN.HOUSE_APPROACH.slice(1,4)):
		return false
	boundary(false)
	if not await follow(PLAN.HOUSE_APPROACH.slice(4,-2)):
		return false
	boundary(true,"Gặp Thomas trên đường mòn")
	zoom(true)
	if not await follow(PLAN.HOUSE_APPROACH.slice(-2)):
		return false
	if not check(stage.thomas.behavior=="WORK","Thomas should work before A approaches"):
		return false
	await still("04-thomas-lam-viec")
	Input.action_release("jog")
	if not await follow(PLAN.THOMAS_APPROACH.slice(1)) or not await use(stage.thomas.target,PLAN.THOMAS+Vector2(.72,0)):
		return false
	await still("05-thomas-hoi-thoai")
	await continue_lines()
	if not check(stage.session.flags.get("thomas_intro_heard",false),"Thomas intro did not complete"):
		return false
	if not choose("Hỏi đường"):
		return false
	await continue_lines(.38)
	if not choose("Tạm biệt"):
		return false
	zoom(false)
	boundary(false)
	Input.action_press("jog")
	var trail: Array[Vector2] = []
	for p in PLAN.THOMAS_APPROACH.slice(0,-1):
		trail.push_front(p)
	for z in range(19,25):
		trail.append(Vector2(ClearingLayout.path_center(z),z))
	for z in range(25,127,4):
		trail.append(Vector2(LAND.valley_path(z),z))
	if not await follow(trail.slice(0,-8)):
		return false
	boundary(true,"Làng A và đường vào làng")
	if not await follow(trail.slice(-8)):
		return false
	await still("06-lang-a")
	Input.action_release("jog")
	if not check(stage.session.flags.get("ch01_community_edge_reached",false),"Village reveal did not record arrival"):
		return false
	boundary(true,"Hazel và hai luống cây")
	var hazel: Node3D = stage.actor(WORK.HAZEL)
	if not await follow([Vector2(2.0,123.9),Vector2(-4.15,123.2)]) or not await use(hazel.target,hazel.point+Vector2(.68,0)):
		return false
	await still("07-hazel")
	await continue_lines()
	if not choose("Đề nghị giúp"):
		return false
	await continue_lines()
	await before_accept(WORK.HAZEL)
	if not choose("Bắt đầu"):
		return false
	if not check(not stage.session.memory(WORK.HAZEL).activity_done,"Accepting Hazel's offer credited unfinished work"):
		return false
	var can: Node3D = stage.activities.targets.watering_can
	if not await use(can,WORK.CAN):
		return false
	for index in WORK.PATCHES.size():
		var patch: Node3D = stage.activities.targets["garden_%d" % index]
		if not await use(patch,WORK.PATCHES[index]):
			return false
		await pause(.35)
	await still("08-hai-luong-da-tuoi")
	if not await use(can,WORK.CAN):
		return false
	await continue_lines(.65)
	if not check(stage.session.memory(WORK.HAZEL).activity_done and stage.session.objects.watering_can=="returned","Hazel work did not persist"):
		return false
	boundary(false)
	Input.action_press("jog")
	if not await follow([Vector2(-4.2,124.1),Vector2(5.88,124.3),Vector2(11.9,123.7),Vector2(14.1,125.2)]):
		return false
	Input.action_release("jog")
	boundary(true,"Owen và bàn sửa đồ")
	zoom(true)
	var owen: Node3D = stage.actor(WORK.OWEN)
	if not await use(owen.target,owen.point+Vector2(-.64,0)):
		return false
	await still("09-owen")
	await continue_lines()
	if not choose("Đề nghị giúp"):
		return false
	await continue_lines()
	if not choose("Bắt đầu"):
		return false
	var repair: Node3D = stage.activities.targets.repair_piece
	if not await use(repair,WORK.REPAIR) or not check(stage.session.objects.wooden_latch=="held","Wooden piece never moved into held state"):
		return false
	await pause(.55)
	await still("10-giu-chi-tiet-go")
	if not await use(repair,WORK.REPAIR):
		return false
	await continue_lines(.70)
	if not check(stage.session.memory(WORK.OWEN).activity_done and stage.session.objects.wooden_latch=="fixed","Owen work did not persist"):
		return false
	zoom(false)
	boundary(false)
	Input.action_press("jog")
	if not await follow([Vector2(14.1,125.2),Vector2(11.9,123.7),trail[-1]]):
		return false
	trail.reverse()
	if not await follow(trail.slice(1,-1)):
		return false
	var return_trail := PLAN.HOUSE_APPROACH.duplicate()
	return_trail.reverse()
	if not await follow(return_trail.slice(0,-4)):
		return false
	boundary(true,"Về Nhà A")
	if not await follow(return_trail.slice(-4)):
		return false
	Input.action_release("jog")
	if not await use(stage.exterior_door,PLAN.HOUSE_APPROACH[0]):
		return false
	await pause(1.0)
	await still("11-tro-ve-nha")
	return check(stage.inside and stage.session.flags.get("ch01_home_returned",false) and stage.session.objects.bed_01=="inspected",
		"Return transition lost progress")
