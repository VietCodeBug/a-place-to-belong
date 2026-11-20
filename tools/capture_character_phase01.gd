extends SceneTree
## In a graphical session, use --write-movie <clip>.avi --fixed-fps 24 -- <clip>.
const MAPS = preload("res://scripts/story/map_flow.gd")
const ACTOR = preload("res://scenes/story/opening_actor.tscn")
const SPEED := 1.65

var shot: Camera3D
var stage_root: Node3D
var caption: Label
var began := 0
var first_frame := 0

func _initialize() -> void:
	call_deferred("run")

func run() -> void:
	TranslationServer.set_locale("vi")
	root.content_scale_size = Vector2i(1280, 720)
	set_meta(MAPS.QUIET_UI, true)
	var args := OS.get_cmdline_user_args()
	var scenario: String = args[0] if not args.is_empty() else "locomotion"
	began = Time.get_ticks_usec()
	first_frame = Engine.get_process_frames()
	match scenario:
		"locomotion", "face":
			await character_stage(scenario)
		"npc", "interaction":
			await office_review(scenario)
		"apartment":
			assert(change_scene_to_file(MAPS.APARTMENT_SCENE) == OK)
			await scene_changed
			await apartment_review(current_scene)
		"gameplay":
			await full_gameplay()
		"profile":
			await profile_office()
		_:
			push_error("Unknown character capture scenario: " + scenario)
			quit(1)
			return
	var seconds := (Time.get_ticks_usec() - began) / 1000000.0
	var frames := Engine.get_process_frames() - first_frame
	print("CHARACTER CAPTURE %s COMPLETE | %d frames | %.2f capture FPS | %.2f ms/frame including render and movie write" %
		[scenario, frames, frames / seconds, seconds * 1000.0 / frames])
	quit.call_deferred()

func wait_for(seconds: float) -> void:
	await create_timer(seconds).timeout

func setup_shot(parent: Node) -> void:
	shot = Camera3D.new()
	parent.add_child(shot)
	shot.fov = 45.0
	shot.make_current()
	var canvas := CanvasLayer.new()
	parent.add_child(canvas)
	caption = Label.new()
	canvas.add_child(caption)
	caption.position = Vector2(28, 660)
	caption.add_theme_font_size_override("font_size", 27)
	caption.add_theme_constant_override("outline_size", 6)

func frame_subject(point: Vector3, offset: Vector3, label: String) -> void:
	shot.global_position = point + offset
	shot.look_at(point)
	caption.text = label

func character_stage(scenario: String) -> void:
	stage_root = Node3D.new()
	root.add_child(stage_root)
	current_scene = stage_root
	var world := WorldEnvironment.new()
	var sky := Environment.new()
	sky.background_mode = Environment.BG_COLOR
	sky.background_color = Color("293b3c")
	sky.ambient_light_source = Environment.AMBIENT_SOURCE_COLOR
	sky.ambient_light_color = Color("f2e2ce")
	sky.ambient_light_energy = 0.78
	world.environment = sky
	stage_root.add_child(world)
	var light := DirectionalLight3D.new()
	light.rotation_degrees = Vector3(-38.0, -142.0, 0.0)
	light.shadow_enabled = true
	stage_root.add_child(light)
	var floor_mesh := BoxMesh.new()
	floor_mesh.size = Vector3(36.0, 0.07, 36.0)
	var floor_node := MeshInstance3D.new()
	floor_node.mesh = floor_mesh
	floor_node.position.y = -0.04
	var material := StandardMaterial3D.new()
	material.albedo_color = Color("6a7873")
	floor_node.material_override = material
	stage_root.add_child(floor_node)
	var actor := ACTOR.instantiate()
	stage_root.add_child(actor)
	setup_shot(stage_root)
	await process_frame
	if scenario == "face":
		await facial_demo(actor)
	else:
		await locomotion_demo(actor)

func facial_demo(actor: Node3D) -> void:
	var head := Vector3(0.0, 1.52, 0.07)
	frame_subject(head, Vector3(0.036, 0.04, 0.55), "Khuôn mặt · Character A")
	for expression in ["Neutral", "Tired", "Thinking", "Concerned", "Surprised", "Sad", "Happy", "Subtle Smile"]:
		caption.text = expression
		actor.set_expression(expression, 0.94, 0.40)
		var eyes: Vector3 = {
			"Tired": Vector3(0.08, -0.20, 1.0), "Thinking": Vector3(-0.20, 0.14, 1.0),
			"Concerned": Vector3(0.06, -0.03, 1.0), "Surprised": Vector3(0.02, 0.13, 1.0),
			"Sad": Vector3(0.12, -0.36, 1.0), "Happy": Vector3(0.03, 0.09, 1.0),
			"Subtle Smile": Vector3(-0.05, 0.04, 1.0),
		}.get(expression, Vector3(0.05, 0.01, 1.0))
		var focus := head + eyes
		actor.set_attention(focus)
		await pose_for(actor, 1.45)
	actor.set_expression("Neutral")
	for shape in ["Closed", "Open", "Round", "Wide"]:
		var weights := Vector4.ZERO
		weights[["Closed", "Open", "Round", "Wide"].find(shape)] = 0.80
		actor.set_viseme_weights(weights)
		caption.text = "Viseme · " + shape
		await pose_for(actor, 0.75)

func pose_for(actor: Node3D, seconds: float) -> void:
	var spent := 0.0
	while spent < seconds:
		await process_frame
		var delta: float = root.get_process_delta_time()
		spent += delta
		actor.resync(delta, Vector3.ZERO)

func locomotion_demo(actor: Node3D) -> void:
	var events := [
		["Đứng nghỉ", 1.3, 0.0, 0.0, 0.0, Vector3(2.5, 0.42, 2.9)],
		["Bắt đầu bước · Đi bộ", 2.6, SPEED, 0.0, 0.0, Vector3(3.36, 0.28, 1.2)],
		["Chạy nhẹ", 2.4, 3.05, 0.0, 0.0, Vector3(3.5, 0.39, -1.5)],
		["Giảm tốc · Dừng", 1.6, 0.0, 0.0, 0.0, Vector3(2.7, 0.36, 2.0)],
		["Xoay trái", 1.4, 0.0, 1.10, 0.0, Vector3(2.65, 0.40, 2.25)],
		["Xoay phải", 1.5, 0.0, -0.48, 0.0, Vector3(2.45, 0.36, 2.22)],
		["Ngồi xuống · Nghỉ tay", 2.3, 0.0, -0.48, 1.0, Vector3(2.35, 0.43, 2.7)],
		["Đứng dậy", 1.5, 0.0, -0.48, 0.0, Vector3(2.35, 0.43, 2.7)],
	]
	var velocity := 0.0
	var seat := 0.0
	var chair := preload("res://assets/story/office_models/work_chair.glb").instantiate() as Node3D
	stage_root.add_child(chair)
	chair.hide()
	for event in events:
		var t := 0.0
		if event[4] == 1.0:
			chair.global_position = actor.global_position
			chair.rotation.y = actor.rotation.y
			chair.show()
		while t < event[1]:
			await process_frame
			var delta: float = root.get_process_delta_time()
			t += delta
			velocity = move_toward(velocity, event[2], delta * 4.8)
			seat = move_toward(seat, event[4], delta * 1.55)
			actor.seated = smoothstep(0.0, 1.0, seat)
			actor.desk_rest = 1.0
			actor.lap_rest = 1.0
			actor.rotation.y = rotate_toward(actor.rotation.y, event[3], 2.1 * delta)
			var travel := actor.basis.z * velocity
			actor.position += travel * delta
			actor.resync(delta, travel)
			frame_subject(actor.global_position + Vector3.UP * 0.87, event[5], event[0])

func office_review(scenario: String) -> void:
	assert(change_scene_to_file(MAPS.OFFICE_SCENE) == OK)
	await scene_changed
	var office := current_scene
	office.finish_intro()
	office.status.hide()
	setup_shot(office)
	var meeting: Node3D = office.meeting_listener
	if scenario == "interaction":
		var actor: Node3D = office.typing_colleague
		office.set_process(false)
		var key_center: Vector3 = actor.key_face(17)
		frame_subject(key_center, Vector3(0.21, 0.32, 0.24), "Bàn phím · NPC 01")
		actor.typing = 0.89
		await pose_for(actor, 2.8)
		for i in range(40):
			await process_frame
			actor.mouse_use = smoothstep(0.0, 1.0, i / 39.0)
			actor.resync(root.get_process_delta_time(), Vector3.ZERO)
		frame_subject(actor.mouse_prop.global_position, Vector3(0.21, 0.26, 0.34), "Từ bàn phím sang chuột")
		await pose_for(actor, 1.0)
		frame_subject(meeting.global_position + Vector3(0.0, 1.04, -0.24), Vector3(-0.69, 0.12, -0.68), "Nắm quai · Uống · Đặt lại")
		var duration := 4.8
		var timer := 0.0
		while timer < duration:
			await process_frame
			var delta: float = root.get_process_delta_time()
			timer += delta
			meeting.drink_amount = smoothstep(0.3, 1.8, timer) * (1.0 - smoothstep(2.7, 4.4, timer))
			meeting.resync(delta, Vector3.ZERO)
		shot.clear_current()
		office.camera.make_current()
		office.open_phone()
		caption.text = "Điện thoại · Giao diện bên trái"
		await wait_for(2.3)
		office.phone.close_panel()
		return
	var t := 0.0
	while t < 96.0:
		await process_frame
		t += root.get_process_delta_time()
		var card := floori(t / 6.0) % 5
		match card:
			0:
				frame_subject(Vector3(-3.65, 1.02, 1.03), Vector3(1.72, 0.80, 3.20), "Dãy bàn · Gõ phím, đọc và nghỉ tay")
			1:
				frame_subject(Vector3(-0.95, 1.05, -3.92), Vector3(1.25, 0.43, 2.24), "Khu máy in · Trao đổi")
			2:
				frame_subject(meeting.global_position + Vector3(0.0, 0.95, -0.49), Vector3(2.10, 0.64, 2.28), "Bàn họp · Lắng nghe và uống nước")
			3:
				frame_subject(office.boss.global_position + Vector3.UP * 0.83, Vector3(0.54, 0.84, 2.12), "Sếp · Đi, dừng và quan sát")
			_:
				frame_subject(Vector3(-4.52, 1.0, -4.01), Vector3(1.2, 0.73, 3.0), "Khu hồ sơ · Đổi tư thế")
	print("NPC STATES ", office.behaviors.size(), " seated, ", office.standing_coworkers.size(), " standing, plus supervisor")

func apartment_review(apartment: Node3D) -> void:
	await wait_for(1.75)
	apartment.examine()
	await wait_for(2.25)
	apartment.advance()
	await wait_for(1.18)
	apartment.camera.yaw = 0.0
	apartment.camera.pitch = -0.32
	await move_apartment(apartment, KEY_D, Vector3.RIGHT, -0.24)
	await move_apartment(apartment, KEY_W, Vector3.FORWARD, 0.87)
	await wait_for(0.32)
	apartment.examine()
	await wait_for(5.75)
	apartment.advance()
	await wait_for(1.18)
	apartment.camera.yaw = 0.0
	apartment.camera.pitch = -0.41
	await move_apartment(apartment, KEY_S, Vector3.BACK, -0.25)
	await move_apartment(apartment, KEY_A, Vector3.LEFT, 0.86)
	await wait_for(0.36)
	apartment.examine()
	await wait_for(2.65)
	apartment.advance()
	await wait_for(3.25)

func move_apartment(apartment: Node3D, key: Key, axis: Vector3, target: float) -> void:
	var event := InputEventKey.new()
	event.keycode = key
	event.physical_keycode = key
	event.pressed = true
	Input.parse_input_event(event)
	var remaining := 2.4
	while apartment.player.position.dot(axis) < target and remaining > 0.0:
		await process_frame
		remaining -= root.get_process_delta_time()
	event = event.duplicate()
	event.pressed = false
	Input.parse_input_event(event)
	assert(remaining > 0.0, "Could not reach the next apartment waypoint.")

func full_gameplay() -> void:
	assert(change_scene_to_file(MAPS.OFFICE_SCENE) == OK)
	await scene_changed
	var office := current_scene
	while office.intro_active:
		await process_frame
	await wait_for(0.42)
	office.interact()
	assert(office.mail.visible)
	await wait_for(4.6)
	office.mail.close_message()
	office.camera.yaw = 0.0
	await move_until(office, "office_back", Vector3.BACK, 3.36)
	Input.action_press("office_jog")
	await move_until(office, "office_right", Vector3.RIGHT, -0.20)
	Input.action_release("office_jog")
	await move_until(office, "office_back", Vector3.BACK, 4.68)
	office.interact()
	assert(office.complete)
	await scene_changed
	await apartment_review(current_scene)

func move_until(office: Node3D, action: String, axis: Vector3, target: float) -> void:
	Input.action_press(action)
	var expires: float = office.office_time + 8.0
	while office.player.position.dot(axis) < target and office.office_time < expires:
		await process_frame
	Input.action_release(action)
	assert(office.office_time < expires, "Could not reach the next office waypoint.")

func profile_office() -> void:
	assert(change_scene_to_file(MAPS.OFFICE_SCENE) == OK)
	await scene_changed
	var office := current_scene
	await wait_for(1.1)
	var start := Time.get_ticks_usec()
	var start_frame := Engine.get_process_frames()
	await wait_for(4.5)
	var elapsed := (Time.get_ticks_usec() - start) / 1000000.0
	var fps := (Engine.get_process_frames() - start_frame) / elapsed
	office.set_process(false)
	office.set_physics_process(false)
	office.boss.set_physics_process(false)
	var actor: Node3D = office.actor
	var samples := 360
	var step := 1.0 / 60.0
	actor.set_expression("Concerned", 0.65)
	start = Time.get_ticks_usec()
	for i in samples:
		actor.skeleton.reset_bone_poses()
		actor.advance_performance(step)
		actor.pose_face()
	var face_ms := (Time.get_ticks_usec() - start) / (1000.0 * samples)
	start = Time.get_ticks_usec()
	for i in samples:
		for side in ["L", "R"]:
			actor.solve_chain("Arm" + side, "Forearm" + side, "Hand" + side,
				Vector3(0.20 if side == "L" else -0.20, 0.87, 0.38), Vector3.DOWN, Basis.IDENTITY)
	var ik_ms := (Time.get_ticks_usec() - start) / (1000.0 * samples)
	start = Time.get_ticks_usec()
	for i in samples:
		for coworker in office.seated_coworkers:
			coworker.resync(step, Vector3.ZERO)
		for coworker in office.standing_coworkers:
			coworker.pose_standing_coworker(step)
		office.boss.actor.resync(step, Vector3.ZERO)
	var actors_ms := (Time.get_ticks_usec() - start) / (1000.0 * samples)
	print("OFFICE PROFILE | %.2f FPS | %.2f ms frame | 19 NPC pose updates %.3f ms | A face and reset %.3f ms | two arm IK %.3f ms" %
		[fps, 1000.0 / fps, actors_ms, face_ms, ik_ms])
