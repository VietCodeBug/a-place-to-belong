extends Camera3D
## Gameplay three-quarter follow camera tuned so the first impression reveals
## the café, winding path, character, woodland crowns, stylized sky, and distant ridges.
## Also supports seamless live 3D scenic framing for the Title Menu.

@export var target: Node3D
var distance := 21.0
var aim := Vector3.ZERO
var scenic_mode := false
var scenic_clock := 0.0
const MIN_ZOOM := 10.0
const MAX_ZOOM := 40.0

func near_lodge() -> bool:
	return absf(target.position.x) < 18.0 and target.position.z < 17.5 and target.position.z > -16.0

func focus_position() -> Vector3:
	if near_lodge():
		return target.position + Vector3(-1.15, 2.65, -5.8)
	return target.position + Vector3(0.0, 1.55, -0.8)

func desired_position() -> Vector3:
	var length := distance + (1.2 if near_lodge() else 0.0)
	var offset_dir := Vector3(0.55, 0.32, 0.77).normalized() if near_lodge() else Vector3(0.58, 0.44, 0.68).normalized()
	var p := target.position + Vector3.UP * 1.45 + offset_dir * length
	p.y = maxf(p.y, ForestLandscape.height_at(p.x, p.z) + 2.0)
	return p

func scenic_pose() -> Dictionary:
	var sway_x := sin(scenic_clock * 0.22) * 0.85
	var sway_y := cos(scenic_clock * 0.17) * 0.22
	var eye := Vector3(13.6 + sway_x, 5.45 + sway_y, 21.2)
	eye.y = maxf(eye.y, ForestLandscape.height_at(eye.x, eye.z) + 2.2)
	# Frame cafe slightly to the right so the left-side Title Menu never hides the building
	var focus := Vector3(-2.6, 3.45, 1.2)
	return {"eye": eye, "focus": focus, "fov": 42.0}

func set_scenic_mode(enabled: bool, instant := false) -> void:
	scenic_mode = enabled
	if instant:
		if scenic_mode:
			var sp := scenic_pose()
			position = sp.eye
			aim = sp.focus
			fov = sp.fov
			look_at(aim)
		elif target != null:
			aim = focus_position()
			position = desired_position()
			fov = 43.0 if near_lodge() else 46.0
			look_at(aim)

func _ready() -> void:
	fov = 43.0
	if scenic_mode:
		var sp := scenic_pose()
		position = sp.eye
		aim = sp.focus
	else:
		aim = focus_position()
		position = desired_position()
	look_at(aim)

func _process(delta: float) -> void:
	if scenic_mode:
		scenic_clock += delta
		var sp := scenic_pose()
		position = position.lerp(sp.eye, 1.0 - exp(-2.8 * delta))
		aim = aim.lerp(sp.focus, 1.0 - exp(-3.2 * delta))
		fov = lerpf(fov, sp.fov, 1.0 - exp(-2.5 * delta))
		look_at(aim)
		return
	position = position.lerp(desired_position(), 1.0 - exp(-4.5 * delta))
	aim = aim.lerp(focus_position(), 1.0 - exp(-5.0 * delta))
	fov = lerpf(fov, 43.0 if near_lodge() else 46.0, 1.0 - exp(-3.0 * delta))
	look_at(aim)

func _unhandled_input(event: InputEvent) -> void:
	if scenic_mode:
		return
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == MOUSE_BUTTON_WHEEL_UP:
			distance = clampf(distance - 1.5, MIN_ZOOM, MAX_ZOOM)
		elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			distance = clampf(distance + 1.5, MIN_ZOOM, MAX_ZOOM)
