extends Node3D
## PRO-003, the same rented room across three moments in time.

const MAPS = preload("res://scripts/story/map_flow.gd")
const EYES = preload("res://scripts/story/opening_view.gd")
const T = preload("res://scripts/ui/storybook_theme.gd")
const WALNUT = preload("res://scripts/story/office_wood.gdshader")
const FABRIC = preload("res://scripts/story/office_textile.gdshader")
const BEDDING = preload("res://scripts/story/apartment_bedding.gdshader")
const PLASTER = preload("res://scripts/story/apartment_plaster.gdshader")
const CLUTTER = preload("res://scripts/story/apartment_clutter.gd")
const PHONE = preload("res://scripts/ui/phone_panel.gd")
const FIXTURES = preload("res://scripts/story/apartment_fixtures.gd")
const LAMP = preload("res://assets/story/office_models/desk_lamp.glb")
const CHAIR = preload("res://assets/story/office_models/work_chair.glb")
const MUG = preload("res://assets/story/office_models/personal_mug.glb")
const PAPERWORK = preload("res://scripts/story/office_paperwork.gd")

const BEDSIDE := Vector3(-0.80, 0.01, 0.24)
const ALARM := Vector3(-1.11, 0.68, -0.73)
const DESK := Vector3(0.37, 0.0, -1.60)
const CALENDAR := Vector3(1.49, 1.49, -1.92)
const EATING_TABLE := Vector3(2.06, 0.0, 0.20)

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
var clutter: CLUTTER
var fixtures: FIXTURES
var phone: PHONE
var plaster_finish: ShaderMaterial
var window_bounce: OmniLight3D
var meal_lamp: SpotLight3D
var curtains: Array[MeshInstance3D] = []
var duvet: MeshInstance3D
var bedding: Array[ArrayMesh] = []
var quilt: ShaderMaterial
var bedside_light: OmniLight3D
var bedside_mess: Node3D
var folded_cover: MeshInstance3D
var pillow: MeshInstance3D
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
	if not alarm_ringing and not resting and not transitioning and not phone.visible:
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
	if phone.visible:
		if PHONE.is_shortcut(event) or event.is_action_pressed("ui_cancel"):
			phone.close_panel()
			get_viewport().set_input_as_handled()
		return
	if event.is_action_pressed("ui_cancel"):
		MAPS.enter_forest.call_deferred(get_tree(), true)
		get_viewport().set_input_as_handled()
		return
	if transitioning:
		return
	if PHONE.is_shortcut(event):
		open_phone()
		get_viewport().set_input_as_handled()
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

func open_phone() -> void:
	player.velocity = Vector3.ZERO
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	var applications: String = [
		MAPS.text("No applications yet.", "Chưa có hồ sơ ứng tuyển."),
		MAPS.text("Application received. Awaiting a reply.", "Đã nhận hồ sơ ứng tuyển. Đang chờ phản hồi."),
		MAPS.text("No new replies.", "Chưa có phản hồi mới.")
	][stage]
	phone.show_phone(day_label(), phone_schedule(), applications, alarm_ringing)

func phone_schedule() -> String:
	if stage == 2:
		return MAPS.text("Alarm schedule off.", "Đã tắt lịch báo thức.")
	if stage == 1:
		return MAPS.text("07:00 · Alarm\n\nReview job applications.", "07:00 · Báo thức\n\nXem lại hồ sơ ứng tuyển.")
	return MAPS.text("07:00 · Alarm ringing", "07:00 · Báo thức đang reo") if alarm_ringing else MAPS.text("07:00 · Alarm silenced", "07:00 · Đã tắt tiếng báo thức")

func silence_alarm() -> void:
	if not alarm_ringing:
		return
	alarm_ringing = false
	alarm_sound.stop()
	if phone.visible:
		phone.update_calendar(phone_schedule())

func examine() -> void:
	if alarm_ringing:
		silence_alarm()
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
	if p.distance_to(Vector3(ALARM.x, p.y, ALARM.z)) < 0.79:
		return "alarm"
	if p.distance_to(Vector3(CALENDAR.x, p.y, CALENDAR.z)) < 0.77:
		return "calendar"
	if p.z > DESK.z + 0.28 and p.distance_to(Vector3(DESK.x, p.y, DESK.z)) < 1.11:
		return "desk"
	return ""

func update_hint() -> void:
	if phone.visible:
		hint.text = ""
	elif alarm_ringing:
		hint.text = MAPS.text("E · Silence the alarm     Q · Phone", "E · Tắt báo thức     Q · Điện thoại")
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
		hint.text = (nearby + "      " if not nearby.is_empty() else "") + next + MAPS.text("      Q · Phone", "      Q · Điện thoại")

func advance() -> void:
	if transitioning or alarm_ringing or resting or phone.visible:
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
	clutter.set_stage(stage)
	fixtures.set_stage(stage)
	plaster_finish.set_shader_parameter("wear", [0.10, 0.71, 0.98][stage])
	duvet.mesh = bedding[stage]
	quilt.set_shader_parameter("wear", [0.0, 0.41, 0.94][stage])
	folded_cover.visible = stage == 0
	bedside_mess.visible = stage >= 1
	bedside_light.light_energy = [0.15, 0.49, 0.51][stage]
	pillow.position.x = [-1.79, -1.92, -1.98][stage]
	pillow.position.z = [-0.53, -0.50, -0.43][stage]
	pillow.rotation.y = [0.0, 0.19, 0.34][stage]
	for curtain in curtains:
		curtain.scale.x = [0.51, 0.81, 0.99][stage]
	environment.background_color = [Color("aeb9bc"), Color("717f86"), Color("525f69")][stage]
	environment.ambient_light_color = [Color("dce0d7"), Color("b5c3c0"), Color("849598")][stage]
	environment.ambient_light_energy = [0.58, 0.44, 0.33][stage]
	window_bounce.light_color = [Color("e9dac2"), Color("a8b7b6"), Color("899ba4")][stage]
	window_bounce.light_energy = [0.24, 0.27, 0.19][stage]
	meal_lamp.light_energy = [0.23, 0.86, 0.95][stage]
	daylight.light_color = [Color("e5e2d8"), Color("bcc9cf"), Color("9cabb8")][stage]
	daylight.light_energy = [0.64, 0.28, 0.14][stage]
	daylight.rotation_degrees = [Vector3(-28, 162, 0), Vector3(-21, 145, 0), Vector3(-36, 172, 0)][stage]
	chapter.text = MAPS.text("Rented apartment", "Căn hộ thuê") + "  ·  " + day_label()
	if alarm_ringing and DisplayServer.get_name() != "headless":
		alarm_sound.play()

func day_label() -> String:
	return [
		MAPS.text("Day 1", "Ngày 1"), MAPS.text("Day 2", "Ngày 2"), MAPS.text("Days later", "Những ngày sau")
	][stage]

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
	phone = PHONE.new()
	overlay.add_child(phone)
	phone.dismissed.connect(recapture)
	phone.alarm_silenced.connect(silence_alarm)

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
	window_bounce = OmniLight3D.new()
	window_bounce.position = Vector3(0.02, 1.55, -1.73)
	window_bounce.light_color = Color("eadbc4")
	window_bounce.light_energy = 0.23
	window_bounce.omni_range = 4.4
	add_child(window_bounce)

	var trim := "a19b83"
	var plaster := "cdcfc1"
	plaster_finish = ShaderMaterial.new()
	plaster_finish.shader = PLASTER
	plaster_finish.set_shader_parameter("paint", Color("bbbdac"))
	var boards := slab(Vector3(0, -0.12, 0), Vector3(5.16, 0.24, 4.10), "8a7158", true)
	var wood := ShaderMaterial.new()
	wood.shader = WALNUT
	wood.set_shader_parameter("wood", Color("9f825f"))
	boards.material_override = wood
	slab(Vector3(0, 2.79, 0), Vector3(5.16, 0.15, 4.1), "d8d3c4")
	slab(Vector3(-2.55, 1.36, 0), Vector3(0.16, 2.75, 4.08), plaster, true).material_override = plaster_finish
	build_bathroom_wall(plaster)
	slab(Vector3(0, 1.36, 2.0), Vector3(5.16, 2.75, 0.16), "b0b5a8", true).material_override = plaster_finish
	slab(Vector3(0, 0.43, -2.00), Vector3(5.16, 0.86, 0.14), plaster, true).material_override = plaster_finish
	slab(Vector3(0, 2.50, -2.00), Vector3(5.16, 0.52, 0.14), plaster, true).material_override = plaster_finish
	slab(Vector3(-1.76, 1.60, -2.0), Vector3(1.63, 1.58, 0.14), plaster, true).material_override = plaster_finish
	slab(Vector3(1.85, 1.60, -2.0), Vector3(1.44, 1.58, 0.14), plaster, true).material_override = plaster_finish
	slab(Vector3(0.1, 0.906, -1.96), Vector3(2.08, 0.07, 0.22), trim)
	slab(Vector3(0.10, 1.56, -2.06), Vector3(2.0, 1.25, 0.024), "829191", true).hide()
	for x in [-0.88, 0.08, 1.05]:
		slab(Vector3(x, 1.55, -1.97), Vector3(0.052, 1.28, 0.081), "777f78")
	slab(Vector3(0.10, 2.17, -1.93), Vector3(2.09, 0.067, 0.081), "777f78")
	slab(Vector3(0.10, 2.29, -1.85), Vector3(2.26, 0.027, 0.034), "6b6558")
	build_curtain(-0.94, 1)
	build_curtain(1.14, -1)
	slab(Vector3(0, 0.078, -1.90), Vector3(5.0, 0.15, 0.041), "867f66")
	slab(Vector3(-2.445, 0.077, 0.0), Vector3(0.044, 0.15, 3.96), "827c64")
	slab(Vector3(2.445, 0.077, -0.575), Vector3(0.044, 0.15, 2.79), "827c64")
	slab(Vector3(2.445, 0.077, 1.83), Vector3(0.044, 0.15, 0.33), "827c64")
	for i in range(11):
		var x := (i - 6.0) * 2.25
		var h := 2.3 + float((i * 9) % 7) * 0.58
		var z := -11.0 - (i % 3) * 2.4
		slab(Vector3(x, h * 0.5 - 2.0, z), Vector3(1.72, h, 2.05), "8d9da3" if i % 2 == 0 else "a4adae")
		for row in range(1, 5):
			slab(Vector3(x, float(row) * 0.58 - 1.86, z + 1.033), Vector3(0.99, 0.19, 0.011), "768a93")

	build_sleeping_corner()
	slab(ALARM - Vector3(0, 0.073, 0), Vector3(0.29, 0.13, 0.15), "485554")
	alarm_display = sign3d(ALARM + Vector3(0, -0.064, 0.078), 0.0021, "f0bd8a")
	alarm_sound = AudioStreamPlayer3D.new()
	alarm_sound.stream = preload("res://assets/story/apartment_alarm.wav")
	alarm_sound.position = ALARM
	alarm_sound.volume_db = -19.0
	alarm_sound.finished.connect(alarm_sound.play)
	add_child(alarm_sound)

	var desk_surface := build_work_corner()
	var eating_surface := build_eating_corner()
	fixtures = FIXTURES.new()
	fixtures.name = "ApartmentFixtures"
	add_child(fixtures)
	clutter = CLUTTER.new()
	clutter.work_surface = desk_surface
	clutter.eating_surface = eating_surface
	add_child(clutter)
	slab(Vector3(1.93, 0.98, 1.90), Vector3(0.85, 1.96, 0.08), "8e7e65")
	slab(Vector3(1.62, 0.93, 1.85), Vector3(0.10, 0.043, 0.07), "5c625b")
	slab(Vector3(0.10, 0.014, 0.26), Vector3(1.56, 0.024, 2.38), "8d9685")
	for side in [-1, 1]:
		slab(Vector3(0.10 + side * 0.68, 0.032, 0.26), Vector3(0.024, 0.01, 2.26), "b1aa8b")

func build_sleeping_corner() -> void:
	var wood := ShaderMaterial.new()
	wood.shader = WALNUT
	wood.set_shader_parameter("wood", Color("927859"))
	wood.set_shader_parameter("boards", false)
	var base := slab(Vector3(-1.79, 0.18, 0.17), Vector3(1.17, 0.31, 2.00), "80684c", true)
	base.material_override = wood
	slab(Vector3(-1.20, 0.268, 0.17), Vector3(0.036, 0.074, 1.97), "a18b6c")
	slab(Vector3(-1.79, 0.286, 1.178), Vector3(1.18, 0.080, 0.048), "967e60")
	slab(Vector3(-1.79, 0.46, -0.83), Vector3(1.21, 0.81, 0.090), "a48460", true).material_override = wood
	slab(Vector3(-1.79, 0.878, -0.83), Vector3(1.24, 0.037, 0.11), "ba9a70")
	for x in [-2.355, -1.224]:
		slab(Vector3(x, 0.55, -0.777), Vector3(0.042, 0.66, 0.029), "8f7254")

	cushion(Vector3(-1.79, 0.387, 0.17), Vector3(1.12, 0.162, 1.94), 0.28, "d4c7ab")
	slab(Vector3(-1.235, 0.390, 0.18), Vector3(0.018, 0.012, 1.83), "b2a488")
	duvet = MeshInstance3D.new()
	duvet.position = Vector3(-1.79, 0.469, 0.37)
	add_child(duvet)
	bedding = [duvet_mesh(0.0), duvet_mesh(0.56), duvet_mesh(1.0)]
	quilt = ShaderMaterial.new()
	quilt.shader = BEDDING
	quilt.set_shader_parameter("cloth", Color("728577"))
	duvet.material_override = quilt
	folded_cover = cushion(Vector3(-1.79, 0.514, 0.98), Vector3(1.09, 0.069, 0.248), 0.33, "b2a58b")
	for z in [0.901, 0.922, 1.036]:
		var stripe := slab(Vector3(-1.79, 0.544, z), Vector3(0.99, 0.004, 0.008), "887a63", false, folded_cover)
		stripe.position -= folded_cover.position

	pillow = cushion(Vector3(-1.79, 0.497, -0.53), Vector3(0.77, 0.15, 0.40), 0.48, "e1d7bd")
	var pillow_case := ShaderMaterial.new()
	pillow_case.shader = FABRIC
	pillow_case.set_shader_parameter("cloth", Color("e2d7c0"))
	pillow.material_override = pillow_case

	var cabinet := slab(Vector3(-1.11, 0.252, -0.73), Vector3(0.43, 0.49, 0.43), "8f785f", true)
	cabinet.material_override = wood
	slab(Vector3(-1.11, 0.514, -0.73), Vector3(0.47, 0.055, 0.46), "a78663").material_override = wood
	for y in [0.34, 0.17]:
		slab(Vector3(-1.11, y, -0.507), Vector3(0.376, 0.132, 0.022), "a68b64")
		slab(Vector3(-1.11, y + 0.016, -0.485), Vector3(0.093, 0.017, 0.025), "635846")
	var coaster := slab(Vector3(-0.933, 0.544, -0.801), Vector3(0.084, 0.009, 0.083), "978568")
	coaster.rotation.y = 0.26
	var cup := MUG.instantiate() as Node3D
	cup.position = Vector3(-0.933, 0.549, -0.802)
	cup.scale = Vector3.ONE * 0.79
	cup.rotation.y = 0.44
	add_child(cup)
	build_bedside_lamp()

	slab(Vector3(-1.69, 1.408, -1.787), Vector3(0.91, 0.042, 0.267), "93815f").material_override = wood
	for x in [-2.00, -1.39]:
		slab(Vector3(x, 1.297, -1.843), Vector3(0.046, 0.197, 0.094), "77745f")
	var covers := ["827760", "687b75", "a08869", "937662"]
	for i in range(covers.size()):
		var length := 0.173 + (i % 3) * 0.027
		var book := slab(Vector3(-1.985 + i * 0.052, 1.432 + length * 0.5, -1.783),
			Vector3(0.045, length, 0.155), covers[i])
		book.rotation.z = -0.16 if i == 3 else 0.0
		slab(Vector3(book.position.x, 1.47, -1.704), Vector3(0.030, 0.016, 0.006), "c0b096")
	slab(Vector3(-1.47, 1.447, -1.777), Vector3(0.233, 0.031, 0.153), "a09074").rotation.y = -0.17

	bedside_mess = Node3D.new()
	bedside_mess.name = "BedsideClutter"
	add_child(bedside_mess)
	var envelope := slab(Vector3(-1.125, 0.546, -0.558), Vector3(0.173, 0.007, 0.100), "c3b99d", false, bedside_mess)
	envelope.rotation.y = 0.29
	slab(Vector3(-1.093, 0.551, -0.530), Vector3(0.144, 0.005, 0.073), "d1c3a5", false, bedside_mess).rotation.y = -0.18
	var tissue := cushion(Vector3(-0.91, 0.026, -0.49), Vector3(0.131, 0.053, 0.092), 0.53, "a49d87")
	tissue.rotation = Vector3(0.14, 0.41, -0.13)
	tissue.reparent(bedside_mess, false)

func build_bedside_lamp() -> void:
	var at := Vector3(-1.247, 0.542, -0.869)
	slab(at + Vector3(0, 0.009, 0), Vector3(0.106, 0.018, 0.093), "695941")
	slab(at + Vector3(0, 0.117, 0), Vector3(0.017, 0.216, 0.017), "68604e")
	var shade := MeshInstance3D.new()
	var cone := CylinderMesh.new()
	cone.top_radius = 0.044
	cone.bottom_radius = 0.087
	cone.height = 0.107
	cone.radial_segments = 22
	shade.mesh = cone
	shade.material_override = finish("a09173")
	shade.position = at + Vector3(0, 0.257, 0)
	add_child(shade)
	bedside_light = OmniLight3D.new()
	bedside_light.position = at + Vector3(0.019, 0.189, 0.020)
	bedside_light.light_color = Color("dfbd8d")
	bedside_light.omni_range = 1.72
	bedside_light.omni_attenuation = 1.2
	add_child(bedside_light)

func cushion(at: Vector3, size: Vector3, curve: float, color: String) -> MeshInstance3D:
	var surface := SurfaceTool.new()
	surface.begin(Mesh.PRIMITIVE_TRIANGLES)
	for row in range(12):
		var lo := lerpf(-PI * 0.5, PI * 0.5, row / 12.0)
		var hi := lerpf(-PI * 0.5, PI * 0.5, (row + 1) / 12.0)
		for side in range(28):
			var a := TAU * side / 28.0
			var b := TAU * (side + 1) / 28.0
			var p := cushion_point(a, lo, curve) * size
			var q := cushion_point(b, lo, curve) * size
			var r := cushion_point(a, hi, curve) * size
			var t := cushion_point(b, hi, curve) * size
			for corner in [p, r, q, q, r, t]:
				surface.add_vertex(corner)
	surface.generate_normals()
	var piece := MeshInstance3D.new()
	piece.mesh = surface.commit()
	piece.material_override = finish(color)
	piece.position = at
	add_child(piece)
	return piece

func cushion_point(yaw: float, latitude: float, curve: float) -> Vector3:
	var span := pow(absf(cos(latitude)), curve)
	var x := signf(cos(yaw)) * pow(absf(cos(yaw)), curve) * span
	var z := signf(sin(yaw)) * pow(absf(sin(yaw)), curve) * span
	var y := signf(sin(latitude)) * pow(absf(sin(latitude)), curve)
	return Vector3(x, y, z) * 0.5

func build_bathroom_wall(plaster: String) -> void:
	# The two wall sections leave a full doorway on the dining side of the entry.
	slab(Vector3(2.55, 1.36, -0.61), Vector3(0.16, 2.75, 2.86), plaster, true).material_override = plaster_finish
	slab(Vector3(2.55, 1.36, 1.85), Vector3(0.16, 2.75, 0.38), plaster, true).material_override = plaster_finish
	slab(Vector3(2.55, 2.425, 1.245), Vector3(0.16, 0.62, 0.85), plaster, true).material_override = plaster_finish
	for z in [0.831, 1.647]:
		slab(Vector3(2.55, 1.055, z), Vector3(0.192, 2.11, 0.047), "9a8c72")
	slab(Vector3(2.55, 2.115, 1.239), Vector3(0.192, 0.063, 0.86), "9a8c72")
	# The door leaf sits open along the wet room's front wall.
	var door := slab(Vector3(2.939, 1.024, 1.745), Vector3(0.78, 2.02, 0.049), "7b8779", true)
	door.name = "BathroomDoor"
	door.rotation.y = -0.12
	slab(Vector3(0.269, 0.0, -0.037), Vector3(0.083, 0.031, 0.055), "596b64", false, door)

func build_work_corner() -> Node3D:
	var top := slab(DESK + Vector3(0, 0.738, 0), Vector3(1.20, 0.054, 0.57), "9c7a58", true)
	top.name = "WorkDesk"
	for x in [-0.515, 0.515]:
		for z in [-0.205, 0.205]:
			slab(DESK + Vector3(x, 0.356, z), Vector3(0.062, 0.712, 0.064), "6d715f")
	slab(DESK + Vector3(0, 0.649, -0.205), Vector3(1.09, 0.108, 0.042), "887451")

	var surface := Node3D.new()
	surface.position.y = 0.027
	top.add_child(surface)
	slab(Vector3(0.06, 0.014, 0.031), Vector3(0.45, 0.028, 0.28), "5b625d", false, surface)
	slab(Vector3(0.06, 0.143, -0.11), Vector3(0.45, 0.254, 0.035), "454e4d", false, surface)
	laptop = sign3d(Vector3(0.06, 0.147, -0.089), 0.0019, "c3d0b7")
	laptop.reparent(surface, false)
	paperwork.page(surface, Vector3(-0.36, 0.002, 0.06), -0.29, 0)
	later_papers = Node3D.new()
	surface.add_child(later_papers)
	paperwork.packet(later_papers, Vector3(-0.36, 0.007, 0.13), 0.16, "a39277", true)

	var chair := CHAIR.instantiate() as Node3D
	chair.name = "WorkChair"
	chair.position = DESK + Vector3(0.0, 0.0, 0.54)
	chair.rotation.y = PI
	add_child(chair)
	slab(Vector3(0.09, 0.785, -0.270), Vector3(0.26, 0.33, 0.027), "9eacb2", false, chair).rotation.x = 0.11
	slab(Vector3(0.09, 0.946, -0.251), Vector3(0.26, 0.018, 0.077), "9eacb2", false, chair)
	slab(Vector3(0.0, 0.48, -0.02), Vector3(0.49, 0.96, 0.57), "8a907e", true, chair).hide()

	slab(CALENDAR, Vector3(0.22, 0.29, 0.032), "b5a37e")
	calendar = sign3d(CALENDAR + Vector3(0.0, 0.0, 0.019), 0.0015, "38453d")
	return surface

func build_eating_corner() -> Node3D:
	var table := Node3D.new()
	table.name = "EatingTable"
	table.position = EATING_TABLE
	table.rotation.y = PI * 0.5
	add_child(table)
	var top := slab(Vector3(0, 0.744, 0), Vector3(1.06, 0.066, 0.65), "91886e", true, table)
	var table_finish := ShaderMaterial.new()
	table_finish.shader = WALNUT
	table_finish.set_shader_parameter("wood", Color("9d825c"))
	table_finish.set_shader_parameter("boards", false)
	top.material_override = table_finish
	for x in [-0.45, 0.45]:
		for z in [-0.246, 0.246]:
			slab(Vector3(x, 0.356, z), Vector3(0.061, 0.712, 0.061), "7c8e82", false, table)
	slab(Vector3(0, 0.676, 0.246), Vector3(0.97, 0.064, 0.036), "827053", false, table)
	var chair := FieldAssets.place(self, "furniture", "chair", EATING_TABLE + Vector3(-0.50, 0, 0.14), 0.82, PI * 0.5)
	chair.name = "EatingChair"
	FieldAssets.recolor(chair, "83765d")
	FieldAssets.solid(chair)

	var surface := Node3D.new()
	surface.position.y = 0.777
	table.add_child(surface)
	var cup := MUG.instantiate() as Node3D
	cup.position = Vector3(0.14, 0.006, 0.104)
	surface.add_child(cup)
	slab(Vector3(0.14, 0.0025, 0.104), Vector3(0.153, 0.005, 0.154), "9e8f71", false, surface)
	build_eating_light(surface)
	return surface

func build_eating_light(surface: Node3D) -> void:
	var practical := LAMP.instantiate() as Node3D
	practical.position = Vector3(0.367, 0.0, 0.167)
	practical.scale = Vector3.ONE * 0.78
	practical.rotation.y = -0.46
	surface.add_child(practical)
	meal_lamp = SpotLight3D.new()
	meal_lamp.position = Vector3(0.367, 0.36, 0.165)
	meal_lamp.light_color = Color("f2cd94")
	meal_lamp.spot_range = 2.5
	meal_lamp.spot_angle = 57.0
	meal_lamp.spot_attenuation = 1.18
	surface.add_child(meal_lamp)
	meal_lamp.look_at(surface.to_global(Vector3(-0.12, 0, -0.12)), Vector3.UP)

func build_curtain(edge: float, side: int) -> void:
	var surface := SurfaceTool.new()
	surface.begin(Mesh.PRIMITIVE_TRIANGLES)
	for i in range(30):
		var u := i / 30.0
		var v := (i + 1) / 30.0
		for point in [curtain_point(u, 0.0), curtain_point(v, 0.0), curtain_point(u, 1.0),
				curtain_point(v, 0.0), curtain_point(v, 1.0), curtain_point(u, 1.0)]:
			surface.add_vertex(Vector3(point.x * side, point.y, point.z))
	surface.generate_normals()
	var fabric := StandardMaterial3D.new()
	fabric.albedo_color = Color("a79e82")
	fabric.roughness = 0.99
	fabric.cull_mode = BaseMaterial3D.CULL_DISABLED
	var curtain := MeshInstance3D.new()
	curtain.mesh = surface.commit()
	curtain.material_override = fabric
	curtain.position = Vector3(edge, 2.24, -1.82)
	add_child(curtain)
	curtains.append(curtain)

func curtain_point(u: float, down: float) -> Vector3:
	var ripple := sin(u * TAU * 6.0) * 0.032 + sin(u * TAU * 2.0) * 0.016
	var hem := down * (1.27 - 0.045 * u + 0.021 * cos(u * TAU * 6.0))
	return Vector3(u, -hem, ripple * lerpf(0.79, 1.1, down))

func duvet_mesh(wrinkle: float) -> ArrayMesh:
	var surface := SurfaceTool.new()
	surface.begin(Mesh.PRIMITIVE_TRIANGLES)
	for x in range(16):
		for z in range(19):
			var a := Vector2(x / 16.0, z / 19.0)
			var b := Vector2((x + 1) / 16.0, z / 19.0)
			var c := Vector2(x / 16.0, (z + 1) / 19.0)
			var d := Vector2((x + 1) / 16.0, (z + 1) / 19.0)
			for uv in [a, b, c, b, d, c]:
				surface.set_uv(uv)
				surface.add_vertex(duvet_point(uv.x, uv.y, wrinkle))
	surface.generate_normals()
	return surface.commit()

func duvet_point(u: float, v: float, wrinkle: float) -> Vector3:
	var pleat := sin(u * 14.0 + v * 8.4) * sin(v * 13.2 + u * 3.9)
	var drop := smoothstep(0.87, 1.0, u) * lerpf(0.038, 0.103, wrinkle)
	var rumple := absf(pleat) * lerpf(0.015, 0.129, wrinkle)
	var loose_corner := Vector3(-v * 0.035, 0.0, sin(u * 7.0) * 0.13) * wrinkle
	return Vector3((u - 0.5) * 1.14, rumple - drop + 0.013, (v - 0.5) * 1.41) + loose_corner

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

func slab(at: Vector3, size: Vector3, color: String, blocking := false, parent: Node3D = null) -> MeshInstance3D:
	var mesh := BoxMesh.new()
	mesh.size = size
	mesh.material = finish(color)
	var instance := MeshInstance3D.new()
	instance.mesh = mesh
	instance.position = at
	var destination := parent if parent != null else self
	destination.add_child(instance)
	if blocking:
		var body := StaticBody3D.new()
		var shape := CollisionShape3D.new()
		var box := BoxShape3D.new()
		box.size = size
		shape.shape = box
		instance.add_child(body)
		body.add_child(shape)
	return instance
