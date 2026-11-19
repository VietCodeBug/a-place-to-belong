extends Node3D
## ENV-REAL-01. The same desk is used during the opening, playback and email interaction.
const MAPS = preload("res://scripts/story/map_flow.gd")
const THEME = preload("res://scripts/ui/storybook_theme.gd")
const STORYBOOK = preload("res://scripts/ui/storybook_screens.gd")
const COWORKER_MODELS := [
	preload("res://assets/story/office_models/colleague_npc_01.glb"),
	preload("res://assets/story/office_models/colleague_npc_02.glb"),
]
const COWORKER_HIP_DROPS := [0.42, 0.43]
const MONITOR = preload("res://assets/story/office_models/desk_monitor.glb")
const MOUSE = preload("res://assets/story/office_models/desk_mouse.glb")
const WALNUT_DESK = preload("res://assets/story/office_models/walnut_workstation.glb")
const TASK_CHAIR = preload("res://assets/story/office_models/work_chair.glb")
const DESK_LAMP = preload("res://assets/story/office_models/desk_lamp.glb")
const MUG = preload("res://assets/story/office_models/personal_mug.glb")
const PLANT = preload("res://assets/story/office_models/rubber_plant.glb")
const WOOD_MATERIAL = preload("res://scripts/story/office_wood.gdshader")
const TEXTILE = preload("res://scripts/story/office_textile.gdshader")
const TERRACOTTA = preload("res://scripts/story/office_terracotta.gdshader")
const DISPLAY = preload("res://scripts/story/office_display.gdshader")
const COPY_ALCOVE = preload("res://assets/story/office_models/copy_alcove.glb")
const PENDANT = preload("res://assets/story/office_models/office_pendant.glb")
const MEETING_TABLE = preload("res://assets/story/office_models/meeting_table.glb")
const COPY = preload("res://assets/story/office.json")
const ACTOR = preload("res://scenes/story/opening_actor.tscn")
const BOSS = preload("res://scenes/story/office_boss.tscn")
const EYE_CAMERA = preload("res://scripts/story/opening_view.gd")
const OFFICE_STORM = preload("res://scripts/story/office_storm.gd")
const OFFICE_PAPERWORK = preload("res://scripts/story/office_paperwork.gd")
const OFFICE_WORKDAY = preload("res://scripts/story/office_workday.gd")
const MAIL = preload("res://scripts/ui/office_mail.gd")
const WORK_DESK := Vector3(-5.34, 0.0, 0.96)
const EAST_BANK := Vector3(1.64, 0.0, 0.48)
const DESK_SEAT := WORK_DESK + Vector3(0.0, 0.02, 0.83)
const DESK_STAND := WORK_DESK + Vector3(0.0, 0.02, 1.17)
const DESK_SPACING := 1.99
const BENCH_SCALE := 0.84
const STAFF_CHAIR_INSET := 0.18
const INTRO_LENGTH := 8.2
const MAIL_DURING_INTRO := 6.64
var player: CharacterBody3D
var actor: Node3D
var camera: EYE_CAMERA
var storm: OFFICE_STORM
var paperwork := OFFICE_PAPERWORK.new()
var workday: OFFICE_WORKDAY
var status: Label
var root_ui: Control
var pause_overlay: Control
var storybook: STORYBOOK
var in_title_menu := false
var in_pause_menu := false
var mail: MAIL
var terminal: MeshInstance3D
var email_display: Tween
var mail_indicator: MeshInstance3D
var notification_time := 0.0
var locale: Dictionary
var arrived := false
var read_mail := false
var complete := false
var seated_coworkers: Array[Node3D] = []
var standing_coworkers: Array[Node3D] = []
var textile_materials := {}
var block_meshes: Dictionary = {}
var desk_finish: ShaderMaterial
var lens_finish: StandardMaterial3D
var typing_colleague: Node3D
var male_colleague: Node3D
var boss: CharacterBody3D
var office_time := 0.0
var intro_time := 0.0
var intro_active := true
var seat_requested := false
var seat_from := DESK_STAND
var desk_chair: Node3D
var player_keyboard: Node3D
var player_mouse: Node3D
var meeting_listener: Node3D
var phone_requested := false
var interaction_gesture := 0.0
var mouse_clicked := false
var coworker_at_archives: Node3D
var archive_home := Vector3.ZERO

func _ready() -> void:
	locale = COPY.data["vi" if MAPS.is_vietnamese() else "en"]
	register_controls()
	build_office()
	player = CharacterBody3D.new()
	add_child(player)
	player.position = DESK_SEAT
	player.set_collision_mask_value(2, true)
	var shape := CollisionShape3D.new()
	var capsule := CapsuleShape3D.new()
	capsule.radius = 0.25
	capsule.height = 1.72
	shape.shape = capsule
	shape.position.y = 0.86
	player.add_child(shape)
	actor = ACTOR.instantiate()
	player.add_child(actor)
	actor.rotation.y = PI
	actor.seated = 1.0
	actor.bind_keyboard(player_keyboard)
	actor.mouse_prop = player_mouse
	actor.set_expression("Tired", 0.60)
	camera = EYE_CAMERA.new()
	player.add_child(camera)
	actor.use_first_person()
	camera.make_current()
	camera.focus = terminal
	camera.sensitivity = get_tree().get_meta(MAPS.LOOK_SENSITIVITY, 1.0)
	camera.head_bob = get_tree().get_meta(MAPS.HEAD_BOB, true)
	boss = BOSS.instantiate()
	boss.player = player
	boss.position = Vector3(2.58, 0.001, -2.40)
	add_child(boss)
	build_overlay()
	recapture()
	update_intro(0.0)
	actor.resync(0.0, Vector3.ZERO)

func register_controls() -> void:
	var bindings := {
		"office_left": KEY_A, "office_right": KEY_D, "office_forward": KEY_W,
		"office_back": KEY_S, "office_jog": KEY_SHIFT,
	}
	for action in bindings:
		if not InputMap.has_action(action):
			InputMap.add_action(action)
			var key := InputEventKey.new()
			key.physical_keycode = bindings[action]
			InputMap.action_add_event(action, key)

func build_overlay() -> void:
	var hud := CanvasLayer.new()
	add_child(hud)
	var layout := MarginContainer.new()
	hud.add_child(layout)
	layout.set_anchors_and_offsets_preset(Control.PRESET_BOTTOM_WIDE)
	layout.offset_left = 24
	layout.offset_right = -24
	layout.offset_top = -68
	layout.offset_bottom = -24
	status = Label.new()
	status.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	status.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	status.add_theme_font_size_override("font_size", 16)
	status.add_theme_color_override("font_color", Color("f3e8d3"))
	status.add_theme_color_override("font_outline_color", Color("26342f"))
	status.add_theme_constant_override("outline_size", 6)
	layout.add_child(status)
	root_ui = Control.new()
	root_ui.theme = THEME.theme()
	root_ui.mouse_filter = Control.MOUSE_FILTER_IGNORE
	hud.add_child(root_ui)
	root_ui.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	mail = MAIL.new()
	root_ui.add_child(mail)
	mail.build(locale)
	mail.attach_screen(terminal)
	mail.dismissed.connect(close_email)
	storybook = STORYBOOK.new(self, MAPS.OFFICE)
	storybook.build_pause()

func set_pause_menu(open: bool) -> void:
	if complete or mail.visible:
		return
	in_pause_menu = open
	storybook.close_page()
	pause_overlay.visible = open
	status.visible = not open
	if open:
		player.velocity = Vector3.ZERO
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		pause_overlay.find_children("*", "Button", true, false)[0].grab_focus()
	else:
		recapture()

func enter_title_menu(_instant := false) -> void:
	MAPS.enter_forest.call_deferred(get_tree(), true)

func deliver_email() -> void:
	if arrived:
		return
	arrived = true
	mail.update_inbox(true, false)
	mail_indicator.show()
	notification_time = office_time
	workday.play_mail_cue()
	actor.set_expression("Surprised", 0.4)

func recapture() -> void:
	if DisplayServer.get_name() != "headless":
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _exit_tree() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

func _process(delta: float) -> void:
	office_time += delta
	workday.local_typing = actor.keyboard_weight
	workday.reading_mail = mail.visible
	storm.reading_mail = mail.visible
	storm.flashes_enabled = not storybook.reduce_motion
	if mail_indicator.visible:
		mail_indicator.scale = Vector3.ONE * lerpf(1.0, 1.25, maxf(0.0, 1.0 - (office_time - notification_time) * 1.8))
	for index in range(seated_coworkers.size()):
		update_seated_colleague(seated_coworkers[index], index, delta)
	var phase := fposmod(office_time + 0.42, 6.8)
	var printer_first := speaking_turn(phase, 0.0, 2.86)
	var printer_second := speaking_turn(phase, 3.13, 6.18)
	standing_coworkers[0].pose_standing_coworker(delta, printer_first, printer_second)
	standing_coworkers[1].pose_standing_coworker(delta, printer_second, printer_first)
	var meeting_turn := speaking_turn(fposmod(office_time + 1.42, 6.8), 0.0, 3.34)
	standing_coworkers[2].pose_standing_coworker(delta, meeting_turn, 1.0 - meeting_turn)
	meeting_listener.looking_out = move_toward(meeting_listener.looking_out, meeting_turn * 0.85, delta * 1.6)

func update_seated_colleague(coworker: Node3D, index: int, delta: float) -> void:
	var duration := 17.0 + float(index % 4) * 1.8
	var beat := fposmod(office_time + index * 3.91, duration)
	var travel := Vector3.ZERO
	if coworker == coworker_at_archives:
		var cycle := fposmod(office_time + 2.9, 36.0)
		var rise := smoothstep(17.3, 18.0, cycle) * (1.0 - smoothstep(26.0, 26.8, cycle))
		var depart := smoothstep(18.0, 19.5, cycle) * (1.0 - smoothstep(24.3, 26.0, cycle))
		var old: Vector3 = coworker.position
		coworker.position = archive_home + Vector3(0.16, 0.0, 0.84) * depart
		coworker.seated = 1.0 - rise
		coworker.rotation.y = lerp_angle(PI + 0.12, 0.44, smoothstep(17.75, 18.30, cycle) * (1.0 - smoothstep(24.0, 24.65, cycle)))
		travel = (coworker.position - old) / maxf(delta, 0.0001)
	if coworker.drink_prop != null:
		coworker.drink_amount = smoothstep(5.4, 6.22, beat) * (1.0 - smoothstep(7.10, 7.92, beat))
	if coworker.mouse_prop != null:
		var use_mouse := smoothstep(7.0, 7.65, beat) * (1.0 - smoothstep(9.05, 9.80, beat))
		var read := smoothstep(12.1, 12.85, beat) * (1.0 - smoothstep(14.4, 15.15, beat))
		coworker.mouse_use = use_mouse
		coworker.desk_rest = read * 0.82
		coworker.typing = 0.84 * (1.0 - read)
		coworker.looking_out = sin(beat * 0.33) * 0.32 * read
		coworker.set_expression("Thinking" if read > 0.5 else "Neutral", read * 0.38)
	coworker.resync(delta, travel)

func speaking_turn(phase: float, begins: float, ends: float) -> float:
	return smoothstep(begins, begins + 0.39, phase) * (1.0 - smoothstep(ends - 0.42, ends, phase))

func _physics_process(delta: float) -> void:
	if in_pause_menu or complete:
		return
	if intro_active:
		update_intro(delta)
		actor.resync(delta, Vector3.ZERO)
		return
	var wants_move := Vector2.ZERO
	if not mail.visible and (Input.mouse_mode == Input.MOUSE_MODE_CAPTURED or DisplayServer.get_name() == "headless"):
		wants_move = Input.get_vector("office_left", "office_right", "office_forward", "office_back")
	if wants_move.length_squared() > 0.0:
		seat_requested = false
		phone_requested = false
	var previous_seated: float = actor.seated
	actor.seated = move_toward(actor.seated, 1.0 if seat_requested else 0.0, delta * 1.8)
	if actor.seated > 0.0 or previous_seated > 0.0:
		player.position = seat_from.lerp(DESK_SEAT, actor.seated)
		player.velocity = Vector3.ZERO
		actor.rotation.y = PI
		camera.yaw = lerp_angle(camera.yaw, clampf(camera.yaw, -EYE_CAMERA.SEAT_YAW_LIMIT, EYE_CAMERA.SEAT_YAW_LIMIT), 1.0 - exp(-10.0 * delta))
		position_chair(actor.seated)
		wants_move = Vector2.ZERO
	var move := Vector3(wants_move.x, 0, wants_move.y).normalized().rotated(Vector3.UP, camera.yaw)
	var pace := 3.05 if Input.is_action_pressed("office_jog") else 1.63
	player.velocity.x = move_toward(player.velocity.x, move.x * pace, delta * 8.0)
	player.velocity.z = move_toward(player.velocity.z, move.z * pace, delta * 8.0)
	player.velocity.y = maxf(-8.0, player.velocity.y - delta * 18.0)
	player.move_and_slide()
	var actual := player.get_real_velocity()
	actual.y = 0.0
	if actor.seated == 0.0:
		actor.rotation.y = lerp_angle(actor.rotation.y, PI + camera.yaw, 1.0 - exp(-16.0 * delta))
	interaction_gesture = move_toward(interaction_gesture, 0.0, delta * 1.8)
	actor.reach = interaction_gesture * 0.65
	var editing: bool = actor.seated > 0.98 and not mail.visible and not phone_requested
	var mouse_pass := fposmod(office_time, 12.0)
	var mouse_use := smoothstep(6.7, 7.2, mouse_pass) * (1.0 - smoothstep(8.45, 9.1, mouse_pass))
	var clicked := editing and mouse_pass >= 7.63 and mouse_pass < 8.35
	if clicked and not mouse_clicked:
		workday.play_mouse()
	mouse_clicked = clicked
	actor.mouse_use = move_toward(actor.mouse_use, mouse_use if editing else 0.0, delta * 4.0)
	actor.typing = move_toward(actor.typing, actor.seated if editing else 0.0, delta * 3.0)
	actor.looking_out = move_toward(actor.looking_out, 0.0, delta * 1.6)
	actor.sigh = move_toward(actor.sigh, 0.0, delta * 2.0)
	actor.phone_amount = move_toward(actor.phone_amount, 1.0 if phone_requested else 0.0, delta * 2.8)
	actor.thinking = move_toward(actor.thinking, 0.65 if mail.visible else 0.0, delta * 2.4)
	if mail.visible:
		actor.set_expression("Thinking", 0.6)
	elif read_mail:
		actor.set_expression("Sad", 0.42)
	elif office_time - notification_time > 1.15:
		actor.set_expression("Neutral", 0.0)
	actor.resync(delta, actual)
	camera.follow_eyes(delta, actor.seated, actual.length())
	update_status()

func position_chair(sitting: float) -> void:
	desk_chair.position = Vector3(-0.57 * (1.0 - sitting), 0.0, 0.90 + 0.32 * (1.0 - sitting))
	desk_chair.rotation.y = PI + 0.29 * (1.0 - sitting)

func update_intro(delta: float) -> void:
	if intro_time < 7.13 and intro_time + delta >= 7.13:
		workday.play_chair()
	intro_time += delta
	var quiet := storybook.reduce_motion
	var glance := smoothstep(2.1, 3.24, intro_time) * (1.0 - smoothstep(3.44, 4.35, intro_time))
	var phone_peek := smoothstep(4.14, 4.82, intro_time) * (1.0 - smoothstep(5.19, 5.92, intro_time))
	var rising := smoothstep(6.98, 8.05, intro_time)
	actor.typing = 1.0 - smoothstep(2.36, 3.06, intro_time)
	actor.desk_rest = smoothstep(2.5, 3.37, intro_time)
	actor.phone_amount = phone_peek if not quiet else 0.0
	actor.sigh = sin(smoothstep(5.61, 6.68, intro_time) * PI) * 0.67
	actor.seated = 1.0 - rising
	actor.looking_out = -glance
	player.position = DESK_SEAT.lerp(DESK_STAND, rising)
	position_chair(actor.seated)

	camera.yaw = (-1.00 * glance - 0.30 * phone_peek) if not quiet else 0.0
	camera.pitch = lerpf(-0.381, -0.052, glance) - 0.37 * phone_peek + 0.236 * rising
	camera.follow_eyes(delta, actor.seated, 0.0, true)
	if intro_time >= MAIL_DURING_INTRO:
		deliver_email()
	status.text = locale.skip
	if intro_time >= INTRO_LENGTH:
		finish_intro()

func finish_intro() -> void:
	if not intro_active:
		return
	intro_active = false
	status.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	player.position = DESK_STAND
	actor.seated = 0.0
	actor.typing = 0.0
	actor.desk_rest = 0.0
	actor.looking_out = 0.0
	actor.sigh = 0.0
	actor.phone_amount = 0.0
	actor.reset_steps()
	position_chair(0.0)
	camera.yaw = 0.0
	camera.pitch = -0.13
	camera.follow_eyes(0.0, 0.0, 0.0)
	update_status()
	if arrived:
		return
	var delivery := Timer.new()
	delivery.one_shot = true
	add_child(delivery)
	delivery.timeout.connect(deliver_email)
	delivery.timeout.connect(delivery.queue_free)
	delivery.start(3.0)

func update_status() -> void:
	if mail.visible:
		status.text = ""
	elif read_mail and near_exit():
		status.text = locale.leave
	elif near_desk():
		if arrived:
			status.text = locale.reread if read_mail else locale.open
		else:
			status.text = locale.seat if can_sit() else ""
	elif intro_time < INTRO_LENGTH + 3.0 and office_time < INTRO_LENGTH + 7.0:
		status.text = locale.controls
	else:
		status.text = ""

func near_desk() -> bool:
	var to_screen := terminal.global_position - (player.global_position + Vector3.UP)
	var in_front := player.position.z > WORK_DESK.z + 0.31
	return in_front and to_screen.length() < 2.05 and absf(player.position.x - WORK_DESK.x) < 1.20

func can_sit() -> bool:
	return actor.seated > 0.0 or player.position.distance_to(DESK_STAND) < 0.56

func near_exit() -> bool:
	return absf(player.position.x) < 1.45 and player.position.z > 4.5

func _unhandled_input(event: InputEvent) -> void:
	if complete:
		return
	if mail.visible:
		if event.is_action_pressed("ui_cancel") or (event is InputEventKey and event.pressed and not event.echo and event.physical_keycode == KEY_E):
			mail.close_message()
			get_viewport().set_input_as_handled()
		return
	if intro_active:
		if event.is_action_pressed("ui_cancel") or event.is_action_pressed("ui_accept"):
			finish_intro()
			get_viewport().set_input_as_handled()
		return
	if event.is_action_pressed("ui_cancel"):
		if storybook.shade.visible:
			storybook.back()
		else:
			set_pause_menu(not in_pause_menu)
		get_viewport().set_input_as_handled()
		return
	if in_pause_menu:
		return
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		recapture()
	elif event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		camera.look_with_mouse(event.relative, actor.seated)
	elif event is InputEventKey and event.pressed and not event.echo and not mail.visible:
		match event.physical_keycode:
			KEY_E:
				interact()
			KEY_F:
				if can_sit():
					if actor.seated == 0.0:
						seat_from = player.position
					seat_requested = not seat_requested
					workday.play_chair()
			KEY_Q:
				phone_requested = not phone_requested

func interact() -> void:
	if intro_active or in_pause_menu or mail.visible or complete:
		return
	if arrived and near_desk():
		open_email()
	elif read_mail and near_exit():
		leave_office()

func open_email() -> void:
	read_mail = true
	interaction_gesture = 1.0
	phone_requested = false
	mail.update_inbox(true, true)
	mail_indicator.hide()
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	player.velocity = Vector3.ZERO
	camera.focus_target = 1.0 if not storybook.reduce_motion else 0.0
	mail.open_message()
	if not storybook.reduce_motion:
		if email_display != null:
			email_display.kill()
		mail.modulate.a = 0.0
		email_display = create_tween()
		email_display.tween_property(mail, "modulate:a", 1.0, 0.24)
	else:
		mail.modulate.a = 1.0

func close_email() -> void:
	camera.focus_target = 0.0
	recapture()
	update_status()

func leave_office() -> void:
	complete = true
	status.hide()
	if storybook.reduce_motion:
		get_tree().change_scene_to_file.call_deferred(MAPS.APARTMENT_SCENE)
		return
	var fade := ColorRect.new()
	fade.color = Color(0.034, 0.052, 0.050, 0.0)
	root_ui.add_child(fade)
	fade.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	var transition := create_tween()
	transition.tween_property(fade, "color:a", 1.0, 0.53)
	transition.tween_callback(get_tree().change_scene_to_file.bind(MAPS.APARTMENT_SCENE))

func box(position: Vector3, size: Vector3, color: Color, solid := false, glow := false) -> MeshInstance3D:
	var key := [size, color, glow]
	var mesh: BoxMesh = block_meshes.get(key)
	if mesh == null:
		mesh = BoxMesh.new()
		mesh.size = size
		var material := StandardMaterial3D.new()
		material.albedo_color = color
		material.roughness = 0.83
		material.emission_enabled = glow
		material.emission = color
		material.emission_energy_multiplier = 0.65
		mesh.material = material
		block_meshes[key] = mesh
	var instance := MeshInstance3D.new()
	instance.mesh = mesh
	instance.position = position
	add_child(instance)
	if solid:
		instance.create_trimesh_collision()
	return instance

func place_model(model: PackedScene, at: Vector3, yaw := 0.0, size := 1.0) -> Node3D:
	var item := model.instantiate() as Node3D
	item.position = at
	item.rotation.y = yaw
	item.scale = Vector3.ONE * size
	add_child(item)
	return item

func fabric_panel(at: Vector3, size: Vector3, tone: Color, solid := false) -> MeshInstance3D:
	if not textile_materials.has(tone):
		var cloth := ShaderMaterial.new()
		cloth.shader = TEXTILE
		cloth.set_shader_parameter("cloth", tone)
		textile_materials[tone] = cloth
	var panel := box(at, size, tone, solid)
	panel.material_override = textile_materials[tone]
	return panel

func finish_meshes(root: Node3D, material_name: String, finish: Material) -> void:
	for child in root.find_children("*", "MeshInstance3D", true, false):
		var visual := child as MeshInstance3D
		for surface in range(visual.mesh.get_surface_count()):
			var material := visual.mesh.surface_get_material(surface)
			if material and material.resource_name == material_name:
				visual.set_surface_override_material(surface, finish)

func workstation_monitor(x: float, own: bool, layout: int) -> void:
	const SIZE := 0.81
	var screen_origin := Vector3(x, 0.816 * (1.0 - SIZE), 0)
	place_model(MONITOR, screen_origin, 0.0, SIZE)
	box(screen_origin + Vector3(0, 1.177, -0.282) * SIZE,
		Vector3(0.87, 0.48, 0.062) * SIZE, Color.WHITE, true).hide()
	var display := MeshInstance3D.new()
	var glass := QuadMesh.new()
	glass.size = Vector2(0.826, 0.421) * SIZE
	var image := ShaderMaterial.new()
	image.shader = DISPLAY
	image.set_shader_parameter("layout", layout)
	display.mesh = glass
	display.material_override = image
	display.position = screen_origin + Vector3(0, 1.187, -0.248) * SIZE
	display.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	add_child(display)
	if not own:
		return
	terminal = display
	mail_indicator = box(screen_origin + Vector3(0.33, 1.258, -0.236) * SIZE,
		Vector3(0.026, 0.025, 0.006) * SIZE, Color("c37555"), false, true)
	mail_indicator.hide()

func key_cap(column: int, row: int) -> Vector3:
	return Vector3(-0.204 + column * 0.037, 0.845, 0.138 + row * 0.043)

func desk(at: Vector3, own := false, yaw := 0.0, occupied := false, bench := false, chair_inset := 0.0) -> Node3D:
	var mark := get_child_count()
	var tabletop := place_model(WALNUT_DESK, Vector3.ZERO)
	finish_meshes(tabletop, "Quarter-sawn walnut", desk_finish)
	box(Vector3(0, 0.779, 0), Vector3(2.24, 0.072, 0.93), Color.WHITE, true).hide()
	var screen_x := 0.10 if own else (-0.40 if occupied else 0.11)
	var layout := 0 if own else (1 + posmod(roundi(at.x * 2 + at.z), 2))
	workstation_monitor(screen_x, own, layout)
	var keyboard_inset := 0.181 if own else 0.074
	box(Vector3(0, 0.829, 0.19 + keyboard_inset), Vector3(0.47, 0.024, 0.16), Color("444b47"))
	if own:
		fabric_panel(Vector3(0.01, 0.819, 0.196), Vector3(1.03, 0.006, 0.52), Color("495e60"))
	if own or chair_inset > 0.0:
		var keyboard := Node3D.new()
		keyboard.name = "KeyboardCaps"
		add_child(keyboard)
		for column in range(12):
			for row in range(3):
				var key := box(key_cap(column, row) + Vector3.BACK * keyboard_inset,
					Vector3(0.03, 0.008, 0.028), Color("b7b1a3") if (column + row * 5) % 8 != 0 else Color("958d7a"))
				key.reparent(keyboard, false)
		if own:
			player_keyboard = keyboard
	if own:
		var plant := place_model(PLANT, Vector3(-0.87, 0.818, -0.32), 0.4, 0.45)
		plant.scale.x = 1.12
	var mouse := place_model(MOUSE, Vector3(0.365, 0.822, 0.217 + keyboard_inset * 0.74), -0.12)
	mouse.name = "WorkMouse"
	if own:
		player_mouse = mouse
	if own:
		place_model(MUG, Vector3(0.41, 0.818, -0.095), 0.35)
	elif occupied or layout == 1:
		place_model(MUG, Vector3(0.61, 0.818, -0.08), -0.65)
	else:
		box(Vector3(-0.54, 0.826, 0.20), Vector3(0.26, 0.015, 0.20), Color("9a856a")).rotation.y = 0.15
		box(Vector3(-0.54, 0.836, 0.20), Vector3(0.23, 0.009, 0.18), Color("c9bd9e")).rotation.y = 0.15
	if own or (layout == 2 and not occupied):
		place_model(DESK_LAMP, Vector3(0.97, 0.818, -0.35), -0.08, 0.73)
		var practical := OmniLight3D.new()
		practical.position = Vector3(0.86, 1.05, -0.17)
		practical.light_color = Color("ffe0b8")
		practical.light_energy = 0.26
		practical.omni_range = 1.35
		add_child(practical)
	if own:
		desk_chair = place_model(TASK_CHAIR, Vector3(0, 0, 0.90), PI)
	else:
		var chair := place_model(TASK_CHAIR, Vector3(0, 0, 0.91 - chair_inset), PI + (0.16 if not occupied else 0.0))
		var obstacle := StaticBody3D.new()
		var shape := CollisionShape3D.new()
		var extents := BoxShape3D.new()
		extents.size = Vector3(0.49, 0.92, 0.46)
		shape.shape = extents
		shape.position.y = 0.46
		chair.add_child(obstacle)
		obstacle.add_child(shape)
	var decor := posmod(roundi(at.x * 13.0 + at.z * 7.0), 6)
	if decor == 1 or decor == 3:
		var notebook := box(Vector3(0.73, 0.833, 0.235), Vector3(0.188, 0.023, 0.246), Color("836f68") if decor == 1 else Color("6a7d6b"))
		notebook.rotation.y = -0.16 if decor == 1 else 0.23
		box(notebook.position + Vector3(0, 0.003, 0.005), Vector3(0.177, 0.013, 0.242), Color("c5b99e")).rotation.y = notebook.rotation.y
	var cable := box(Vector3(screen_x + 0.084, 0.820, -0.344), Vector3(0.011, 0.009, 0.222), Color("4a4841"))
	cable.rotation.y = 0.25
	var components := get_children().slice(mark)
	var station := Node3D.new()
	station.name = "PlayerWorkstation" if own else "Workstation"
	add_child(station)
	for component in components:
		component.reparent(station, false)
	station.position = at
	station.rotation.y = yaw
	if bench:
		station.scale.x = BENCH_SCALE
	paperwork.workstation(station, own, roundi(at.x * 3.0 + at.z * 5.0))
	return station

func build_staff_bench(origin: Vector3, includes_player: bool) -> void:
	const BANK_DEPTH := 1.06
	var spine_z := origin.z - BANK_DEPTH * 0.5
	for slot in range(3):
		var front := origin + Vector3(slot * DESK_SPACING, 0.0, 0.0)
		var back := front - Vector3(0.0, 0.0, BANK_DEPTH)
		var own := includes_player and slot == 0
		var station := desk(front, own, 0.0, not own, true, 0.0 if own else STAFF_CHAIR_INSET)
		var rear_station := desk(back, false, PI, true, true, STAFF_CHAIR_INSET)
		var acoustic := Color("586d6e") if includes_player else Color("537777")
		fabric_panel(Vector3(front.x, 0.949, spine_z), Vector3(1.91, 0.263, 0.066), acoustic, true)
		box(Vector3(front.x, 1.085, spine_z), Vector3(1.92, 0.019, 0.069), Color("87735d"))
		if slot != 1:
			var note_x := front.x + (-0.42 if slot == 0 else 0.39)
			box(Vector3(note_x, 0.997, spine_z + 0.039), Vector3(0.115, 0.085, 0.002), Color("d9c48f")).rotation.z = -0.09
			box(Vector3(note_x, 1.031, spine_z + 0.041), Vector3(0.009, 0.009, 0.006), Color("88745d"))
		for support in [-0.81, 0.81]:
			box(Vector3(front.x + support, 0.829, spine_z), Vector3(0.027, 0.14, 0.082), Color("5a6558"))
		if slot < 2:
			var seam := front.x + DESK_SPACING * 0.50
			fabric_panel(Vector3(seam, 0.913, origin.z - 0.10), Vector3(0.05, 0.218, 0.63), acoustic, true)
			box(Vector3(seam, 1.024, origin.z - 0.10), Vector3(0.058, 0.019, 0.64), Color("a6977f"))
		if includes_player and slot == 1:
			typing_colleague = add_typing_colleague(station, 0, "ColleagueNPC01")
		elif includes_player and slot == 2:
			male_colleague = add_typing_colleague(station, 1, "ColleagueNPC02")
		elif not own:
			add_typing_colleague(station, slot % 2)
		add_typing_colleague(rear_station, (slot + int(includes_player)) % 2)
	box(Vector3(origin.x + DESK_SPACING, 0.726, spine_z), Vector3(5.86, 0.087, 0.15), Color("62685c"))

func add_coworker(model_index: int, at: Vector3, yaw: float, is_seated: bool, actor_name := "OfficeColleague") -> Node3D:
	var coworker = ACTOR.instantiate()
	coworker.name = actor_name
	coworker.model = COWORKER_MODELS[model_index]
	coworker.seated_hip_drop = COWORKER_HIP_DROPS[model_index]
	coworker.position = at
	coworker.rotation.y = yaw
	coworker.seated = 1.0 if is_seated else 0.0
	coworker.clock = float(seated_coworkers.size() + standing_coworkers.size()) * 0.39
	coworker.add_to_group("office_colleagues")
	add_child(coworker)
	return coworker

func add_typing_colleague(station: Node3D, model_index: int, actor_name := "OfficeColleague") -> Node3D:
	var at := to_local(station.to_global(Vector3(0.0, 0.02, 0.83 - STAFF_CHAIR_INSET)))
	var coworker := add_coworker(model_index, at, station.rotation.y + PI, true, actor_name)
	coworker.typing = 0.83
	coworker.keystroke_seconds = 0.35 + 0.028 * (seated_coworkers.size() % 5)
	coworker.bind_keyboard(station.get_node("KeyboardCaps"))
	coworker.mouse_prop = station.get_node("WorkMouse")
	seated_coworkers.append(coworker)
	coworker.resync(0.0, Vector3.ZERO)
	return coworker

func build_staff() -> void:
	build_staff_bench(WORK_DESK, true)
	build_staff_bench(EAST_BANK, false)
	for index in range(2):
		var at := Vector3(-5.18 + index * 2.08, 0, -4.35 + index * 0.08)
		var station := desk(at, false, 0.12, true, true, STAFF_CHAIR_INSET)
		var coworker := add_typing_colleague(station, index)
		if index == 0:
			coworker_at_archives = coworker
			archive_home = coworker.position
	build_meeting_area()
	# A small group by the printer. The cross aisle stays open in front of them.
	add_standing_colleague(Vector3(-1.37, 0, -3.98), 1.38, 0)
	add_standing_colleague(Vector3(-0.50, 0, -3.90), -1.63, 1)
	add_standing_colleague(Vector3(3.33, 0, -3.63), 1.27, 1)

func build_meeting_area() -> void:
	var at := Vector3(5.03, 0, -3.76)
	fabric_panel(at + Vector3(0, 0.014, 0), Vector3(3.80, 0.026, 2.91), Color("536364"))
	var table := place_model(MEETING_TABLE, at)
	finish_meshes(table, "Quarter-sawn walnut", desk_finish)
	box(at + Vector3(0, 0.783, 0), Vector3(2.36, 0.083, 1.15), Color.WHITE, true).hide()
	place_model(PLANT, at + Vector3(0.79, 0.83, 0.08), -0.31, 0.29)
	var meeting_mug := place_model(MUG, at + Vector3(-0.73, 0.83, 0.37), 0.81, 0.84)
	place_model(MUG, at + Vector3(0.38, 0.83, -0.22), -0.50)
	paperwork.packet(self, at + Vector3(-0.24, 0.826, 0.03), -0.36, "8e7772", true)
	paperwork.page(self, at + Vector3(0.37, 0.827, -0.14), 2.79, 0)
	meeting_listener = add_meeting_colleague(at + Vector3(-0.48, 0, 0.86), PI - 0.21, 1)
	meeting_listener.drink_prop = meeting_mug
	meeting_listener.drink_rest = meeting_mug.global_transform
	add_meeting_colleague(at + Vector3(0.37, 0, -0.86), -0.24, 0)

func add_meeting_colleague(at: Vector3, yaw: float, model_index: int) -> Node3D:
	place_model(TASK_CHAIR, at, yaw)
	var coworker := add_coworker(model_index, at + Vector3.UP * 0.02, yaw, true)
	coworker.keyboard_targets.assign([
		coworker.to_global(Vector3(0.14, 0.822, 0.45)),
		coworker.to_global(Vector3(-0.14, 0.822, 0.42)),
	])
	seated_coworkers.append(coworker)
	coworker.resync(0.0, Vector3.ZERO)
	add_colleague_obstacle(coworker, 1.30)
	return coworker

func add_standing_colleague(at: Vector3, yaw: float, model_index: int) -> void:
	var coworker := add_coworker(model_index, at, yaw, false)
	coworker.gesture_side = "R" if model_index == 0 or yaw > 0.0 else "L"
	coworker.pose_standing_coworker(0.0)
	standing_coworkers.append(coworker)
	add_colleague_obstacle(coworker, 1.72)

func add_colleague_obstacle(coworker: Node3D, height: float) -> void:
	var obstacle := StaticBody3D.new()
	var collision := CollisionShape3D.new()
	var capsule := CapsuleShape3D.new()
	capsule.radius = 0.20
	capsule.height = height
	collision.shape = capsule
	collision.position.y = height * 0.5
	coworker.add_child(obstacle)
	obstacle.add_child(collision)

func archive_bay(x: float, z: float, width: float) -> void:
	# Warm timber edges wrap a dark backing, with shelving and varied folders.
	var wood := Color("9d7255")
	var support := Color("705648")
	box(Vector3(x, 1.39, z + 0.23), Vector3(width, 2.49, 0.09), Color("3b5050"), true)
	for side in [-1, 1]:
		box(Vector3(x + side * width * 0.51, 1.37, z), Vector3(0.08, 2.6, 0.51), support, true)
	var papers := [Color("b58663"), Color("b7a786"), Color("668581"), Color("aaa28c"), Color("8f604e")]
	for row in range(5):
		var rack_y := 0.20 + row * 0.49
		box(Vector3(x, rack_y, z), Vector3(width, 0.067, 0.53), wood)
		box(Vector3(x, rack_y, z - 0.267), Vector3(width, 0.039, 0.017), wood.lightened(0.21))
		var cursor := x - width * 0.43
		for book in range(11):
			var span := 0.095 + float((row * 17 + book * 19) % 5) * 0.021
			var length := 0.22 + float((row * 7 + book * 3) % 5) * 0.032
			if cursor + span > x + width * 0.43:
				break
			if (row * 7 + book) % 6 == 0:
				cursor += span + 0.071
				continue
			var file := box(Vector3(cursor + span * 0.5, rack_y + length * 0.5 + 0.034, z + 0.01), Vector3(span - 0.009, length, 0.37), papers[(row * 3 + book) % papers.size()])
			file.rotation.z = -0.09 if book % 6 == 5 else 0.0
			box(Vector3(file.position.x, rack_y + length * 0.68, z - 0.176), Vector3(span * 0.64, 0.031, 0.008), Color("e5d1ae"))
			cursor += span
	box(Vector3(x, 2.64, z), Vector3(width + 0.12, 0.087, 0.53), support)
	box(Vector3(x, 2.589, z - 0.22), Vector3(width * 0.92, 0.018, 0.017), Color("d7bb91"), false, true)

func window_wall(center: Vector3, width: float, yaw: float, bays: int) -> void:
	var plaster := Color("85958d")
	var timber := Color("655446")
	var metal := Color("2d4245")
	var mark := get_child_count()
	box(Vector3(0, 0.37, 0), Vector3(width, 0.74, 0.28), plaster, true)
	box(Vector3(0, 3.10, 0), Vector3(width, 0.28, 0.28), plaster, true)
	# Solid glass collision, with unobstructed daylight and a visible glazing frame.
	box(Vector3(0, 1.85, 0), Vector3(width, 2.22, 0.045), Color.WHITE, true).hide()
	box(Vector3(0, 0.755, 0.061), Vector3(width, 0.10, 0.40), timber)
	box(Vector3(0, 2.963, 0.075), Vector3(width, 0.09, 0.26), timber)
	box(Vector3(0, 2.56, 0.016), Vector3(width, 0.037, 0.12), metal)
	var spacing := width / float(bays)
	for segment in range(bays + 1):
		var x := -width * 0.5 + segment * spacing
		box(Vector3(x, 1.85, 0.003), Vector3(0.14, 2.20, 0.19), timber)
		box(Vector3(x, 1.85, 0.103), Vector3(0.043, 2.16, 0.055), metal)
	for segment in range(bays):
		var x := -width * 0.5 + (segment + 0.5) * spacing
		box(Vector3(x, 1.85, 0.014), Vector3(0.035, 2.19, 0.10), metal)
		if segment % 3 == 2:
			var shade := 0.27 + 0.07 * float(segment % 3)
			box(Vector3(x, 2.91, 0.145), Vector3(spacing - 0.18, 0.093, 0.14), timber)
			fabric_panel(Vector3(x, 2.88 - shade * 0.5, 0.155), Vector3(spacing - 0.20, shade, 0.027), Color("b5ae91"))
			box(Vector3(x, 2.88 - shade, 0.163), Vector3(spacing - 0.21, 0.024, 0.034), Color("a28158"))
	var parts := get_children().slice(mark)
	var wall := Node3D.new()
	wall.name = "WindowWall"
	add_child(wall)
	for part in parts:
		part.reparent(wall, false)
	wall.position = center
	wall.rotation.y = yaw
	storm.add_window_panes(wall, width, bays)

func city_block(at: Vector3, width: float, height: float, tone: Color, foreground: bool, yaw: float, style: int) -> void:
	var mark := get_child_count()
	var base := -5.8
	var top := base + height
	var front := width * 0.38
	var main := box(Vector3(0, base + height * 0.5, 0), Vector3(width, height, front * 2), tone)
	var stone := main.mesh.material.duplicate() as StandardMaterial3D
	main.material_override = stone
	stone.emission_enabled = true
	stone.emission = Color("7995a7").lerp(tone, 0.28)
	stone.emission_energy_multiplier = 0.12 if foreground else 0.30
	# Stone crowns, a setback penthouse and a slim curtain wall give the skyline
	# distinct profiles from both windows.
	match style:
		0:
			box(Vector3(0, top + 0.035, 0), Vector3(width + 0.20, 0.13, front * 2 + 0.17), tone.lightened(0.10))
			box(Vector3(-width * 0.18, top + 0.29, -front * 0.13), Vector3(width * 0.43, 0.49, front * 1.07), tone.lightened(0.07))
		1:
			box(Vector3(-width * 0.06, top + 0.58, -front * 0.14), Vector3(width * 0.70, 1.16, front * 1.49), tone.lightened(0.07))
			box(Vector3(-width * 0.16, top + 1.24, -front * 0.18), Vector3(width * 0.29, 0.19, front * 0.86), tone)
		2:
			box(Vector3(0, top - 0.21, 0), Vector3(width * 1.06, 0.46, front * 2 + 0.13), tone.lightened(0.11))
			box(Vector3(width * 0.19, top + 0.35, -front * 0.31), Vector3(width * 0.33, 0.57, front * 0.69), tone.darkened(0.08))
	if foreground:
		var dark_windows: Array = []
		var lit_windows: Array = []
		var glass_tint := tone.darkened(0.29)
		var columns := 4 if style == 1 else 3
		var pitch := 0.77 if style == 1 else 0.99
		var skin := tone.lightened(0.11)
		for row in range(1, int((height - 0.52) / pitch)):
			var y := base + float(row) * pitch
			if style == 1:
				box(Vector3(0, y, front + 0.014), Vector3(width * 0.85, 0.48, 0.020), glass_tint)
			elif style == 0 and row % 2 == 0:
				box(Vector3(0, y - 0.33, front + 0.075), Vector3(width * 1.03, 0.074, 0.17), skin)
			for column in range(columns):
				var x := (float(column) - float(columns - 1) * 0.5) * width * (0.71 / columns)
				var variation := posmod(row * 11 + column * 7 + roundi(at.x), 17)
				var occupied := variation < (3 if style == 2 else 2)
				var window_color := glass_tint.lerp(tone.lightened(0.07), float(variation % 6) * 0.105)
				if occupied:
					window_color = Color("c8a77c") if variation == 0 else Color("9d9382")
				var ratio := 0.58 if style != 2 else 0.67
				var size := Vector3(width / columns * ratio, 0.40 if style == 1 else 0.50, 0.014)
				var pane := [Transform3D(Basis.from_scale(size), Vector3(x, y, front + 0.026)), window_color]
				if occupied:
					lit_windows.append(pane)
				else:
					dark_windows.append(pane)
		city_windows(dark_windows, false)
		city_windows(lit_windows, true)
		if style == 1:
			for column in range(5):
				var x := (column - 2) * width * 0.20
				box(Vector3(x, base + height * 0.49, front + 0.035), Vector3(0.037, height * 0.92, 0.053), skin)
	var parts := get_children().slice(mark)
	var building := Node3D.new()
	building.name = "CityBlock"
	add_child(building)
	for part in parts:
		part.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
		part.reparent(building, false)
	building.position = at
	building.rotation.y = yaw

func city_windows(panes: Array, lit: bool) -> void:
	if panes.is_empty():
		return
	var facade := StandardMaterial3D.new()
	facade.vertex_color_use_as_albedo = true
	facade.roughness = 0.92
	facade.emission_enabled = lit
	facade.emission = Color("b7ae96")
	facade.emission_energy_multiplier = 0.24
	var mesh := BoxMesh.new()
	mesh.size = Vector3.ONE
	mesh.material = facade
	var batch := MultiMesh.new()
	batch.transform_format = MultiMesh.TRANSFORM_3D
	batch.use_colors = true
	batch.mesh = mesh
	batch.instance_count = panes.size()
	for index in range(panes.size()):
		batch.set_instance_transform(index, panes[index][0])
		batch.set_instance_color(index, panes[index][1])
	var windows := MultiMeshInstance3D.new()
	windows.multimesh = batch
	windows.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	add_child(windows)

func build_city() -> void:
	const BLOCKS := [
		Vector3(-27, 13.4, -41), Vector3(-17, 10.2, -39), Vector3(-8, 14.7, -45), Vector3(1, 11.9, -46),
		Vector3(9, 15.1, -43), Vector3(19, 10.9, -39), Vector3(28, 12.6, -47),
		Vector3(-17, 7.2, -25), Vector3(-10, 10.9, -23), Vector3(-5, 8.8, -22), Vector3(1, 7.7, -26),
		Vector3(8, 9.9, -21), Vector3(17, 8.9, -26), Vector3(23, 11.2, -31),
	]
	for row in range(7):
		var far_block: Vector3 = BLOCKS[row]
		var near_block: Vector3 = BLOCKS[row + 7]
		var tone := Color("586e77").lerp(Color("899395"), float(row % 4) * 0.25)
		city_block(Vector3(far_block.x, 0, far_block.z), 4.1 + (row % 3) * 1.2, far_block.y, Color("728895"), false, 0, row % 3)
		city_block(Vector3(near_block.x, 0, near_block.z), 2.2 + (row % 3) * 0.71, near_block.y, tone, true, 0, (row + 1) % 3)
		city_block(Vector3(far_block.z - 5, 0, -far_block.x), 5.7, far_block.y + 0.3, Color("788d98"), false, PI / 2, (row + 1) % 3)
		city_block(Vector3(near_block.z + 2, 0, -near_block.x), 3.0 + (row % 2) * 1.2, near_block.y, tone, true, PI / 2, (row + 2) % 3)

func shared_storage() -> void:
	# The copy station anchors the end of the centre aisle.
	var at := Vector3(0.22, 0.0, -5.36)
	var back := box(at + Vector3(0, 1.57, -0.15), Vector3(3.20, 2.45, 0.12), Color("825743"), true)
	var tile := ShaderMaterial.new()
	tile.shader = TERRACOTTA
	back.material_override = tile
	var cabinetry := place_model(COPY_ALCOVE, at)
	finish_meshes(cabinetry, "Ivory shade lining", lens_finish)
	box(at + Vector3(0, 0.417, 0.14), Vector3(3.00, 0.82, 0.70), Color.WHITE, true).hide()
	var notice := at + Vector3(0.47, 1.91, -0.064)
	box(notice, Vector3(1.20, 0.66, 0.043), Color("554b3b"))
	fabric_panel(notice + Vector3(0, 0, 0.030), Vector3(1.12, 0.58, 0.020), Color("9e896c"))
	for sheet in range(5):
		var x := -0.438 + sheet * 0.218
		var y := 0.085 - (sheet % 2) * 0.16
		var page := paperwork.page(self, notice + Vector3(x, y, 0.048 + (sheet % 2) * 0.006), 0.0, sheet % 2)
		page.basis = Basis(Vector3.BACK, sin(sheet * 5.2) * 0.14) * Basis(Vector3.RIGHT, PI * 0.5)
		box(notice + Vector3(x, y + 0.112, 0.060), Vector3(0.010, 0.012, 0.012), Color("8b5b48"))
	place_model(PLANT, at + Vector3(1.15, 0.83, 0.25), 0.92, 0.50)
	paperwork.tray(cabinetry, Vector3(0.39, 0.826, 0.23), 0.01)
	paperwork.packet(cabinetry, Vector3(-0.08, 0.826, 0.31), -0.21, "717b71")
	paperwork.wastebasket(self, at + Vector3(1.71, 0.002, 0.21))
	var output := paperwork.page(cabinetry, OFFICE_WORKDAY.FEED_ORIGIN, 0.0, 1)
	output.scale = Vector3(1.04, 0.22, 0.54)
	workday = OFFICE_WORKDAY.new()
	workday.name = "OfficeWorkday"
	add_child(workday)
	workday.configure(WORK_DESK, EAST_BANK, at, output)
	var wash := local_light(at + Vector3(0.0, 2.55, 0.24), at + Vector3(0.0, 0.87, 0.05), Color("dddee0"), 0.82, 3.1)
	wash.spot_angle = 58.0

func local_light(at: Vector3, target: Vector3, tint: Color, energy: float, reach: float, shadows := false) -> SpotLight3D:
	var spot := SpotLight3D.new()
	spot.position = at
	spot.light_color = tint
	spot.light_energy = energy
	spot.spot_range = reach
	spot.spot_angle = 55
	spot.spot_attenuation = 1.18
	spot.shadow_enabled = shadows
	spot.shadow_bias = 0.045
	spot.shadow_normal_bias = 0.85
	spot.shadow_blur = 1.7
	add_child(spot)
	spot.look_at(target, Vector3.BACK)
	return spot

func pendant(at: Vector3, target: Vector3, tint: Color, energy: float, yaw := 0.0, shadows := false) -> void:
	var fixture := place_model(PENDANT, at, yaw)
	finish_meshes(fixture, "Ivory shade lining", lens_finish)
	local_light(at - Vector3(0, 0.126, 0), target, tint, energy, 4.15, shadows)

func office_lighting() -> void:
	var frame := Color("384746")
	var oak := Color("867359")
	# Two acoustic clouds make the lower rows read as work bays at eye level.
	for zone in [Vector3(-3.21, 3.041, 0.26), Vector3(3.89, 3.041, -0.16)]:
		box(zone + Vector3(0, 0.074, 0), Vector3(5.98, 0.075, 2.77), frame)
		for index in range(9):
			var z := (index - 4) * 0.302
			box(zone + Vector3(0, -0.008, z), Vector3(5.88, 0.082, 0.056), oak if index % 2 == 0 else oak.darkened(0.17))
		for x in [-2.93, 2.93]:
			box(zone + Vector3(x, 0.010, 0), Vector3(0.084, 0.124, 2.62), frame)

	pendant(Vector3(-4.76, 2.68, 1.10), Vector3(-4.84, 0.86, 0.91), Color("f6e5cf"), 0.76, 0.0, true)
	pendant(Vector3(-1.94, 2.72, 0.18), Vector3(-1.92, 0.78, -0.05), Color("e0e7e1"), 1.05)
	pendant(Vector3(2.92, 2.73, -0.38), Vector3(2.70, 0.82, -0.56), Color("e0e9e6"), 1.17)
	pendant(Vector3(5.25, 2.73, 0.68), Vector3(5.12, 0.84, 0.55), Color("e5e6da"), 1.02)
	pendant(Vector3(4.98, 2.73, -3.67), Vector3(5.04, 0.79, -3.68), Color("f1dfc6"), 1.15, -0.10, true)
	pendant(Vector3(-4.08, 2.73, -3.89), Vector3(-4.19, 0.80, -4.36), Color("e0e7e2"), 0.99)
	# Wall washers leave the aisle readable when the player turns away from the windows.
	local_light(Vector3(0.27, 2.93, 4.97), Vector3(0, 1.04, 5.65), Color("ffdfa8"), 1.01, 3.57)
	local_light(Vector3(6.28, 2.94, 2.98), Vector3(7.75, 1.40, 2.32), Color("d8d9d1"), 0.43, 3.66)
	var bounce := OmniLight3D.new()
	bounce.position = Vector3(-3.5, 1.8, 2.38)
	bounce.light_energy = 0.26
	bounce.light_color = Color("f0cda5")
	bounce.omni_range = 5.0
	add_child(bounce)
	local_light(Vector3(0.32, 2.32, -3.35), Vector3(-0.45, 3.13, -3.13), Color("e3c8a4"), 0.42, 3.3)
	local_light(Vector3(5.88, 2.84, 1.92), Vector3(7.77, 1.35, 0.69), Color("dcd1b9"), 0.74, 4.10)

func build_office() -> void:
	var environment := WorldEnvironment.new()
	var atmosphere := Environment.new()
	atmosphere.ambient_light_source = Environment.AMBIENT_SOURCE_COLOR
	atmosphere.reflected_light_source = Environment.REFLECTION_SOURCE_DISABLED
	atmosphere.ssao_enabled = true
	atmosphere.ssao_radius = 0.55
	atmosphere.ssao_intensity = 0.82
	atmosphere.ssao_power = 1.15
	environment.environment = atmosphere
	add_child(environment)
	storm = OFFICE_STORM.new()
	storm.name = "OfficeStorm"
	add_child(storm)
	desk_finish = ShaderMaterial.new()
	desk_finish.shader = WOOD_MATERIAL
	desk_finish.set_shader_parameter("wood", Color("a57955"))
	desk_finish.set_shader_parameter("boards", false)
	lens_finish = StandardMaterial3D.new()
	lens_finish.albedo_color = Color("f0cda0")
	lens_finish.emission_enabled = true
	lens_finish.emission = Color("ffe1b3")
	lens_finish.emission_energy_multiplier = 0.62
	var plaster := Color("9da79b")
	box(Vector3(0, -0.15, 0), Vector3(16, 0.3, 12), Color("727c81"), true)
	box(Vector3(0, 3.24, 0), Vector3(16, 0.2, 12), Color("65665a"), true)
	box(Vector3(8, 1.6, 0), Vector3(0.2, 3.2, 12), plaster, true)
	box(Vector3(0, 1.6, 6), Vector3(16, 3.2, 0.2), Color("61766c"), true)
	window_wall(Vector3(0, 0, -6), 16.0, 0.0, 7)
	window_wall(Vector3(-8, 0, 0), 12.0, PI / 2, 5)
	build_city()
	for x in [-5.3, 4.9]:
		box(Vector3(x, 0.59, 5.86), Vector3(4.9, 1.17, 0.10), Color("81918a"))
		box(Vector3(x, 1.18, 5.82), Vector3(4.92, 0.054, 0.15), Color("a89373"))
	archive_bay(-3.44, 5.55, 2.64)
	archive_bay(4.50, 5.55, 2.37)
	place_model(PLANT, Vector3(-1.84, 0, 5.15), 1.05, 1.20)
	box(Vector3(0, 1.055, 5.78), Vector3(1.51, 2.2, 0.055), Color("aa9475"))

	build_staff()
	shared_storage()
	for at in [Vector3(-6.82, 0, -5.03), Vector3(6.7, 0, -5.0), Vector3(7.23, 0, 1.20), Vector3(7.11, 0, -3.30)]:
		place_model(PLANT, at, at.x * 0.25, 1.45 if at.x < 0 else 1.07)
	place_model(PLANT, Vector3(-4.95, 0.82, -3.92), 0.7, 0.42)
	# The quieter wall by the meeting table is lined with low joinery and felt.
	box(Vector3(7.86, 0.64, -0.15), Vector3(0.10, 1.17, 11.57), Color("495c58"))
	box(Vector3(7.776, 1.23, -0.15), Vector3(0.16, 0.037, 11.62), Color("876f54"))
	for section in range(5):
		var at := Vector3(7.798, 0.71, 3.98 - section * 2.01)
		fabric_panel(at, Vector3(0.022, 0.74, 1.84), Color("5c6f65"))
		box(at + Vector3(-0.021, -0.423, 0), Vector3(0.042, 0.027, 1.9), Color("7f7861"))
	var shelf := FieldAssets.place(self, "furniture", "bookcaseOpenLow", Vector3(7.40, 0, -0.45), 1.05, -PI / 2)
	shelf.scale.z = 1.18
	box(Vector3(7.87, 0.12, 0), Vector3(0.10, 0.22, 12), Color("9a7f62"))
	var bulletin := box(Vector3(7.86, 1.84, -2.75), Vector3(0.071, 0.88, 1.72), Color("8e6e51"))
	bulletin.name = "OfficeBulletin"
	box(Vector3(7.816, 1.84, -2.75), Vector3(0.027, 0.78, 1.59), Color("b59e7a"))
	for note in range(4):
		var height := 1.89 + (0.103 if note % 2 == 0 else -0.16)
		var z := -3.30 + note * 0.34
		var sheet := box(Vector3(7.79, height, z), Vector3(0.013, 0.29, 0.25), Color("e1d4b7"))
		sheet.rotation.x = (float(note) - 1.5) * 0.045
		box(Vector3(7.777, height + 0.111, z), Vector3(0.019, 0.016, 0.017), Color("915d4b"))

	# Walnut planter and waiting bench sit against the softer side windows.
	var bench := Color("967054")
	box(Vector3(-6.93, 0.40, -0.93), Vector3(0.49, 0.13, 2.7), bench, true)
	box(Vector3(-6.93, 0.46, -0.37), Vector3(0.48, 0.06, 1.43), Color("9e8e70"))
	for z in [-2.09, 0.19]:
		box(Vector3(-6.93, 0.18, z), Vector3(0.44, 0.36, 0.13), Color("4c5b50"))
	place_model(PLANT, Vector3(-6.94, 0.47, -2.00), 1.28, 0.52)
	place_model(PLANT, Vector3(-7.18, 0, 1.41), 2.05, 1.54)
	# A darker felt runner anchors the bench and keeps the walkway beside it clear.
	box(Vector3(-6.35, 0.016, -0.91), Vector3(1.47, 0.024, 3.34), Color("6c7b6c"))
	for edge in [-1, 1]:
		box(Vector3(-6.35 + edge * 0.63, 0.031, -0.91), Vector3(0.024, 0.007, 3.20), Color("baae8a"))
	var floor := box(Vector3(0, -0.011, 0), Vector3(15.85, 0.023, 11.86), Color.WHITE)
	var oak_finish := ShaderMaterial.new()
	oak_finish.shader = WOOD_MATERIAL
	oak_finish.set_shader_parameter("wood", Color("876e57"))
	floor.material_override = oak_finish
	fabric_panel(Vector3(0.12, 0.015, 0.06), Vector3(1.10, 0.022, 5.64), Color("586766"))
	fabric_panel(Vector3(0, 0.015, 3.96), Vector3(14.8, 0.022, 1.36), Color("515e5b"))
	for edge in [-1, 1]:
		box(Vector3(0, 0.029, 3.96 + edge * 0.592), Vector3(14.65, 0.006, 0.020), Color("9b8669"))
	office_lighting()
	var sun := DirectionalLight3D.new()
	sun.rotation_degrees = Vector3(-20.0, -113, 0)
	sun.shadow_bias = 0.073
	sun.shadow_normal_bias = 1.1
	sun.shadow_blur = 1.9
	sun.directional_shadow_max_distance = 28.0
	sun.shadow_enabled = true
	add_child(sun)
	storm.configure(atmosphere, sun)
	atmosphere.fog_enabled = true
	atmosphere.fog_mode = Environment.FOG_MODE_DEPTH
	atmosphere.fog_depth_begin = 15.0
	atmosphere.fog_depth_end = 62.0
	atmosphere.fog_density = 0.56
	atmosphere.fog_light_color = Color("8f9fad")
	var cooler := Vector3(6.75, 0.0, 3.74)
	box(cooler + Vector3(0, 0.51, 0), Vector3(0.79, 1.02, 0.54), Color("6c7973"), true)
	box(cooler + Vector3(0, 1.032, 0), Vector3(0.81, 0.08, 0.56), Color("a69d86"))
	place_model(MUG, cooler + Vector3(-0.20, 1.075, 0.10), -0.4, 0.85)
	place_model(PLANT, cooler + Vector3(0.22, 1.075, -0.10), 1.1, 0.34)
	var exit_sign := Label3D.new()
	exit_sign.position = Vector3(0, 2.17, 5.82)
	exit_sign.rotation.y = PI
	exit_sign.text = locale.exit
	exit_sign.pixel_size = 0.004
	add_child(exit_sign)
	box(Vector3(0, 1.03, 5.84), Vector3(1.36, 2.06, 0.10), Color("959997"))
	box(Vector3(0.51, 1, 5.75), Vector3(0.18, 0.05, 0.08), Color("46535b"))
