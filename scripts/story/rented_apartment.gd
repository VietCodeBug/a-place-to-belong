extends Node3D
## PRO-003, the same rented room across three moments in time.

const MAPS = preload("res://scripts/story/map_flow.gd")
const EYES = preload("res://scripts/story/opening_view.gd")
const T = preload("res://scripts/ui/storybook_theme.gd")
const WALNUT = preload("res://scripts/story/office_wood.gdshader")
const FABRIC = preload("res://scripts/story/office_textile.gdshader")
const CHAIR = preload("res://assets/story/office_models/work_chair.glb")
const MUG = preload("res://assets/story/office_models/personal_mug.glb")
const PAPERWORK = preload("res://scripts/story/office_paperwork.gd")

const BEDSIDE := Vector3(-0.80, 0.01, 0.24)
const ALARM := Vector3(-1.11, 0.68, -0.73)
const DESK := Vector3(1.13, 0.0, -1.39)
const CALENDAR := Vector3(2.41, 1.43, -1.24)

var stage := 0
var alarm_ringing := true
var resting := false
var transitioning := false
var player: CharacterBody3D
var camera: EYES
var environment: Environment
var daylight: DirectionalLight3D
var alarm_display: Label3D
var laptop: Label3D
var calendar: Label3D
var alarm_sound: AudioStreamPlayer3D
var later_papers: Node3D
var tray: Node3D
var overlay: Control
var hint: Label
var detail: Label
var chapter: Label
var fade: ColorRect
var detail_timer: Timer
var paperwork := PAPERWORK.new()
var finishes: Dictionary = {}

func _ready() -> void:
	build_room()
	build_overlay()
	build_player()
	apply_stage()
	recapture()
	if not get_tree().get_meta(MAPS.QUIET_UI, false):
		create_tween().tween_property(fade, "color:a", 0.0, 0.68)
	else:
		fade.color.a = 0.0

func recapture() -> void:
	if DisplayServer.get_name() != "headless":
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _exit_tree() -> void:
	alarm_sound.stop()
	alarm_sound.stream = null
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

func build_player() -> void:
	player = CharacterBody3D.new()
	add_child(player)
	player.position = BEDSIDE
	var hitbox := CollisionShape3D.new()
	var capsule := CapsuleShape3D.new()
	capsule.radius = 0.22
	capsule.height = 1.69
	hitbox.shape = capsule
	hitbox.position.y = 0.845
	player.add_child(hitbox)
	camera = EYES.new()
	player.add_child(camera)
	camera.yaw = 0.02
	camera.pitch = -0.22
	camera.head_bob = get_tree().get_meta(MAPS.HEAD_BOB, true)
	camera.sensitivity = get_tree().get_meta(MAPS.LOOK_SENSITIVITY, 1.0)
	camera.follow_eyes(0.0, 1.0, 0.0, true)
	camera.make_current()

func _physics_process(delta: float) -> void:
	var motion := Vector2.ZERO
	if not alarm_ringing and not resting and not transitioning:
		motion.x = float(Input.is_physical_key_pressed(KEY_D)) - float(Input.is_physical_key_pressed(KEY_A))
		motion.y = float(Input.is_physical_key_pressed(KEY_S)) - float(Input.is_physical_key_pressed(KEY_W))
	var movement := Vector3(motion.x, 0.0, motion.y).normalized().rotated(Vector3.UP, camera.yaw) * 1.38
	player.velocity.x = move_toward(player.velocity.x, movement.x, 8.0 * delta)
	player.velocity.z = move_toward(player.velocity.z, movement.z, 8.0 * delta)
	player.velocity.y = maxf(-8.0, player.velocity.y - 18.0 * delta)
	player.move_and_slide()
	var eye_seat := clampf((EYES.STANDING_HEIGHT - camera.position.y) / (EYES.STANDING_HEIGHT - EYES.SEATED_HEIGHT), 0.0, 1.0)
	eye_seat = move_toward(eye_seat, 1.0 if alarm_ringing or resting else 0.0, delta * 1.8)
	camera.follow_eyes(delta, eye_seat, movement.length())
	update_hint()

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		MAPS.enter_forest.call_deferred(get_tree(), true)
		get_viewport().set_input_as_handled()
		return
	if transitioning:
		return
	if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		camera.look_with_mouse(event.relative, 0.0)
	elif event is InputEventKey and event.pressed and not event.echo:
		match event.physical_keycode:
			KEY_E:
				examine()
			KEY_ENTER:
				if not alarm_ringing and not resting:
					advance()

func examine() -> void:
	if alarm_ringing:
		alarm_ringing = false
		alarm_sound.stop()
		apply_stage()
		return
	var target := nearby_object()
	if target == "desk":
		show_detail([MAPS.text("Old work documents", "Tài liệu công việc cũ"),
			MAPS.text("Application received", "Đã nhận hồ sơ ứng tuyển"),
			MAPS.text("The laptop is asleep", "Laptop đang ở chế độ ngủ")][stage])
	elif target == "calendar":
		show_detail(calendar.text)
	elif target == "alarm":
		show_detail([MAPS.text("Alarm silenced", "Đã tắt tiếng báo thức"),
			MAPS.text("Alarm still set", "Báo thức vẫn còn hẹn"),
			MAPS.text("Alarm schedule off", "Đã tắt lịch báo thức")][stage])

func nearby_object() -> String:
	var p := player.position
	if p.distance_to(Vector3(ALARM.x, p.y, ALARM.z)) < 1.0:
		return "alarm"
	if p.distance_to(Vector3(CALENDAR.x - 0.28, p.y, CALENDAR.z)) < 0.83:
		return "calendar"
	if p.distance_to(Vector3(DESK.x, p.y, DESK.z)) < 1.11:
		return "desk"
	return ""

func update_hint() -> void:
	if alarm_ringing:
		hint.text = MAPS.text("E   ·   Silence the alarm", "E   ·   Tắt báo thức")
	elif resting:
		hint.text = MAPS.text("Esc   ·   Main menu", "Esc   ·   Về menu chính")
	else:
		var actions := {
			"alarm": MAPS.text("E · Alarm", "E · Báo thức"),
			"desk": MAPS.text("E · Laptop", "E · Laptop"),
			"calendar": MAPS.text("E · Calendar", "E · Lịch"),
		}
		var nearby: String = actions.get(nearby_object(), "")
		var next := MAPS.text("Enter · Continue", "Enter · Tiếp tục") if stage < 2 else MAPS.text("Enter · Sit on the bed", "Enter · Ngồi xuống giường")
		hint.text = (nearby + "      " if not nearby.is_empty() else "") + next

func advance() -> void:
	if transitioning or alarm_ringing or resting:
		return
	transitioning = true
	var duration := 0.0 if get_tree().get_meta(MAPS.QUIET_UI, false) else 0.56
	var montage := create_tween()
	montage.tween_property(fade, "color:a", 1.0, duration)
	montage.tween_callback(func():
		if stage == 2:
			resting = true
			player.position = BEDSIDE
			camera.yaw = 0.02
			camera.pitch = -0.17
		else:
			stage += 1
			apply_stage()
	)
	montage.tween_property(fade, "color:a", 0.0, duration)
	montage.tween_callback(func(): transitioning = false)

func apply_stage() -> void:
	var hour: String = ["07:00", "07:00", "— : —"][stage]
	alarm_display.text = hour
	alarm_display.modulate = Color("f0bd8a") if stage < 2 else Color("8e9b92")
	laptop.text = [MAPS.text("Documents", "Tài liệu"), MAPS.text("Applications", "Ứng tuyển"), ""][stage]
	calendar.text = [MAPS.text("WORK", "ĐI LÀM"), MAPS.text("APPLICATIONS", "ỨNG TUYỂN"), ""][stage]
	later_papers.visible = stage > 0
	tray.visible = stage == 2
	environment.ambient_light_color = [Color("dce0d7"), Color("ddc2a5"), Color("b7c4d2")][stage]
	environment.ambient_light_energy = [0.60, 0.50, 0.39][stage]
	daylight.light_energy = [0.70, 0.60, 0.28][stage]
	daylight.rotation_degrees = [Vector3(-28, 162, 0), Vector3(-21, 145, 0), Vector3(-36, 172, 0)][stage]
	chapter.text = MAPS.text("Rented apartment", "Căn hộ thuê")
	if alarm_ringing and DisplayServer.get_name() != "headless":
		alarm_sound.play()

func show_detail(text: String) -> void:
	detail.text = text
	detail_timer.start(3.1)

func build_overlay() -> void:
	var layer := CanvasLayer.new()
	add_child(layer)
	overlay = Control.new()
	layer.add_child(overlay)
	overlay.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	overlay.mouse_filter = Control.MOUSE_FILTER_IGNORE
	overlay.theme = T.theme()
	chapter = T.label("", 16, T.CREAM)
	chapter.position = Vector2(29, 26)
	overlay.add_child(chapter)
	var bottom := VBoxContainer.new()
	bottom.mouse_filter = Control.MOUSE_FILTER_IGNORE
	overlay.add_child(bottom)
	bottom.set_anchors_and_offsets_preset(Control.PRESET_BOTTOM_WIDE)
	bottom.offset_top = -91
	bottom.offset_bottom = -26
	detail = T.label("", 19, T.CREAM)
	hint = T.label("", 16, T.CREAM)
	for text in [detail, hint, chapter]:
		text.add_theme_color_override("font_outline_color", Color("29302c"))
		text.add_theme_constant_override("outline_size", 5)
		text.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	bottom.add_child(detail)
	bottom.add_child(hint)
	detail_timer = Timer.new()
	detail_timer.one_shot = true
	detail_timer.timeout.connect(func(): detail.text = "")
	add_child(detail_timer)
	fade = ColorRect.new()
	fade.color = Color("09100e")
	fade.mouse_filter = Control.MOUSE_FILTER_IGNORE
	overlay.add_child(fade)
	fade.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)

func build_room() -> void:
	var world := WorldEnvironment.new()
	environment = Environment.new()
	environment.background_mode = Environment.BG_COLOR
	environment.background_color = Color("b3bdc3")
	environment.ambient_light_source = Environment.AMBIENT_SOURCE_COLOR
	environment.ssao_enabled = true
	environment.ssao_radius = 0.45
	environment.ssao_intensity = 0.62
	world.environment = environment
	add_child(world)
	daylight = DirectionalLight3D.new()
	daylight.light_color = Color("e5e2d8")
	daylight.shadow_enabled = true
	daylight.directional_shadow_max_distance = 18.0
	add_child(daylight)
	var window_bounce := OmniLight3D.new()
	window_bounce.position = Vector3(0.02, 1.55, -1.73)
	window_bounce.light_color = Color("eadbc4")
	window_bounce.light_energy = 0.23
	window_bounce.omni_range = 4.4
	add_child(window_bounce)

	var trim := "b6af9e"
	var plaster := "cdcfc1"
	var boards := slab(Vector3(0, -0.12, 0), Vector3(5.16, 0.24, 4.10), "8a7158", true)
	var wood := ShaderMaterial.new()
	wood.shader = WALNUT
	wood.set_shader_parameter("wood", Color("9f825f"))
	boards.material_override = wood
	slab(Vector3(0, 2.79, 0), Vector3(5.16, 0.15, 4.1), "d8d3c4")
	slab(Vector3(-2.55, 1.36, 0), Vector3(0.16, 2.75, 4.08), plaster, true)
	slab(Vector3(2.55, 1.36, 0), Vector3(0.16, 2.75, 4.08), plaster, true)
	slab(Vector3(0, 1.36, 2.0), Vector3(5.16, 2.75, 0.16), "b0b5a8", true)
	slab(Vector3(0, 0.43, -2.00), Vector3(5.16, 0.86, 0.14), plaster, true)
	slab(Vector3(0, 2.50, -2.00), Vector3(5.16, 0.52, 0.14), plaster, true)
	slab(Vector3(-1.76, 1.60, -2.0), Vector3(1.63, 1.58, 0.14), plaster, true)
	slab(Vector3(1.85, 1.60, -2.0), Vector3(1.44, 1.58, 0.14), plaster, true)
	slab(Vector3(0.1, 0.906, -1.96), Vector3(2.08, 0.07, 0.22), trim)
	slab(Vector3(0.10, 1.56, -2.06), Vector3(2.0, 1.25, 0.024), "829191", true).hide()
	for x in [-0.88, 0.08, 1.05]:
		slab(Vector3(x, 1.55, -1.97), Vector3(0.052, 1.28, 0.081), "777f78")
	slab(Vector3(0.10, 2.17, -1.93), Vector3(2.09, 0.067, 0.081), "777f78")
	slab(Vector3(0.10, 2.29, -1.85), Vector3(2.26, 0.027, 0.034), "6b6558")
	for side in [-1, 1]:
		for fold in range(6):
			var x: float = 0.10 + side * (0.98 - fold * 0.043)
			slab(Vector3(x, 1.61 + fold * 0.029, -1.84 + (fold % 2) * 0.024),
				Vector3(0.059, 1.36 - fold * 0.058, 0.039), "b9ab8d" if fold % 2 == 0 else "cbbd9e")
	for i in range(11):
		var x := (i - 6.0) * 2.25
		var h := 2.3 + float((i * 9) % 7) * 0.58
		var z := -11.0 - (i % 3) * 2.4
		slab(Vector3(x, h * 0.5 - 2.0, z), Vector3(1.72, h, 2.05), "8d9da3" if i % 2 == 0 else "a4adae")
		for row in range(1, 5):
			slab(Vector3(x, float(row) * 0.58 - 1.86, z + 1.033), Vector3(0.99, 0.19, 0.011), "768a93")

	slab(Vector3(-1.79, 0.18, 0.17), Vector3(1.17, 0.31, 2.00), "80684c", true)
	slab(Vector3(-1.79, 0.46, -0.83), Vector3(1.21, 0.81, 0.090), "a48460", true)
	slab(Vector3(-1.79, 0.878, -0.83), Vector3(1.24, 0.037, 0.11), "ba9a70")
	for x in [-2.35, -1.23]:
		slab(Vector3(x, 0.55, -0.777), Vector3(0.04, 0.63, 0.027), "8f7254")
	slab(Vector3(-1.79, 0.38, 0.17), Vector3(1.11, 0.16, 1.94), "e2d6bf")
	var blanket := slab(Vector3(-1.79, 0.474, 0.37), Vector3(1.12, 0.101, 1.40), "738678")
	var weave := ShaderMaterial.new()
	weave.shader = FABRIC
	weave.set_shader_parameter("cloth", Color("738678"))
	blanket.material_override = weave
	slab(Vector3(-1.24, 0.412, 0.37), Vector3(0.060, 0.19, 1.40), "687d70")
	slab(Vector3(-1.79, 0.538, 0.94), Vector3(1.13, 0.031, 0.25), "aba385")
	var pillow := MeshInstance3D.new()
	var cushion := SphereMesh.new()
	cushion.radius = 0.5
	cushion.height = 1.0
	cushion.radial_segments = 16
	cushion.rings = 8
	pillow.mesh = cushion
	pillow.scale = Vector3(0.85, 0.18, 0.42)
	pillow.position = Vector3(-1.79, 0.49, -0.53)
	pillow.material_override = finish("e9e1ce")
	add_child(pillow)

	slab(ALARM - Vector3(0, 0.44, 0), Vector3(0.43, 0.49, 0.43), "8f785f", true)
	slab(ALARM - Vector3(0, 0.166, 0), Vector3(0.47, 0.055, 0.46), "a78663")
	slab(ALARM - Vector3(0, 0.073, 0), Vector3(0.29, 0.13, 0.15), "485554")
	alarm_display = sign3d(ALARM + Vector3(0, -0.064, 0.078), 0.0021, "f0bd8a")
	alarm_sound = AudioStreamPlayer3D.new()
	alarm_sound.stream = preload("res://assets/story/apartment_alarm.wav")
	alarm_sound.position = ALARM
	alarm_sound.volume_db = -19.0
	alarm_sound.finished.connect(alarm_sound.play)
	add_child(alarm_sound)

	slab(DESK + Vector3(0, 0.72, 0), Vector3(1.39, 0.077, 0.65), "9c7a58", true)
	for leg in [-1, 1]:
		slab(DESK + Vector3(leg * 0.59, 0.35, 0.02), Vector3(0.070, 0.70, 0.55), "6d715f")
	slab(DESK + Vector3(0.10, 0.769, 0.031), Vector3(0.45, 0.028, 0.28), "5b625d")
	slab(DESK + Vector3(0.10, 0.899, -0.11), Vector3(0.45, 0.254, 0.035), "454e4d")
	laptop = sign3d(DESK + Vector3(0.10, 0.903, -0.089), 0.0019, "c3d0b7")
	var chair := CHAIR.instantiate() as Node3D
	add_child(chair)
	chair.position = DESK + Vector3(0, 0, 0.64)
	chair.rotation.y = 2.78
	slab(chair.position + Vector3(-0.12, 0.74, 0.23), Vector3(0.36, 0.37, 0.037), "9eacb2").rotation.z = -0.15
	slab(chair.position + Vector3(-0.32, 0.70, 0.21), Vector3(0.10, 0.39, 0.044), "8b9ba3").rotation.z = -0.31
	slab(chair.position + Vector3(0.0, 0.39, 0.0), Vector3(0.45, 0.78, 0.52), "8a907e", true).hide()
	var mug := MUG.instantiate() as Node3D
	add_child(mug)
	mug.position = DESK + Vector3(0.51, 0.76, 0.10)
	paperwork.page(self, DESK + Vector3(-0.43, 0.763, 0.06), -0.29, 0)
	later_papers = Node3D.new()
	add_child(later_papers)
	paperwork.packet(later_papers, DESK + Vector3(-0.43, 0.768, 0.13), 0.16, "a39277", true)
	tray = Node3D.new()
	add_child(tray)
	slab(Vector3(1.61, 0.74, 0.63), Vector3(1.51, 0.071, 0.62), "91886e", true)
	slab(Vector3(2.25, 0.35, 0.63), Vector3(0.14, 0.71, 0.61), "7c8e82")
	slab(Vector3(0.98, 0.35, 0.63), Vector3(0.14, 0.71, 0.61), "7c8e82")
	var cup := MUG.instantiate() as Node3D
	add_child(cup)
	cup.position = Vector3(1.76, 0.78, 0.70)
	var plate := slab(Vector3(2.08, 0.795, 0.48), Vector3(0.27, 0.026, 0.20), "bfaf8f")
	plate.reparent(tray)
	slab(CALENDAR, Vector3(0.032, 0.29, 0.22), "b5a37e")
	calendar = sign3d(CALENDAR + Vector3(-0.02, 0, 0), 0.0015, "38453d")
	calendar.rotation.y = -PI * 0.5
	slab(Vector3(1.93, 0.98, 1.90), Vector3(0.85, 1.96, 0.08), "8e7e65")
	slab(Vector3(1.62, 0.93, 1.85), Vector3(0.10, 0.043, 0.07), "5c625b")
	slab(Vector3(0.10, 0.014, 0.26), Vector3(1.56, 0.024, 2.38), "8d9685")
	for side in [-1, 1]:
		slab(Vector3(0.10 + side * 0.68, 0.032, 0.26), Vector3(0.024, 0.01, 2.26), "b1aa8b")

func sign3d(point: Vector3, pixel: float, ink: String) -> Label3D:
	var label := Label3D.new()
	label.font = T.SANS
	label.font_size = 24
	label.pixel_size = pixel
	label.outline_size = 0
	label.modulate = Color(ink)
	label.position = point
	add_child(label)
	return label

func finish(color: String) -> StandardMaterial3D:
	if not finishes.has(color):
		var matte := StandardMaterial3D.new()
		matte.albedo_color = Color(color)
		matte.roughness = 0.88
		finishes[color] = matte
	return finishes[color]

func slab(at: Vector3, size: Vector3, color: String, blocking := false) -> MeshInstance3D:
	var mesh := BoxMesh.new()
	mesh.size = size
	mesh.material = finish(color)
	var instance := MeshInstance3D.new()
	instance.mesh = mesh
	instance.position = at
	add_child(instance)
	if blocking:
		var body := StaticBody3D.new()
		var shape := CollisionShape3D.new()
		var box := BoxShape3D.new()
		box.size = size
		shape.shape = box
		instance.add_child(body)
		body.add_child(shape)
	return instance
