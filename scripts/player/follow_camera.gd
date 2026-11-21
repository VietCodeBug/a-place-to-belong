extends Camera3D
## Gameplay three-quarter follow camera tuned so the first impression reveals
## the café, winding path, character, woodland crowns, stylized sky, and distant ridges.
## Also supports seamless live 3D scenic framing for the Title Menu.

const PLAN = preload("res://scripts/world/village_a_layout.gd")

@export var target: Node3D
var superworld: Node3D
var distance := 21.0
var aim := Vector3.ZERO
var scenic_mode := false
var scenic_clock := 0.0
const MIN_ZOOM := 10.0
const MAX_ZOOM := 40.0

func near_lodge() -> bool:
	return absf(target.position.x) < 18.0 and target.position.z < 17.5 and target.position.z > -16.0

func village_camera_blend() -> float:
	return smoothstep(79.0, 100.0, target.position.z)

func house_camera_blend() -> float:
	return 1.0 - smoothstep(3.0,10.0,Vector2(target.position.x,target.position.z).distance_to(PLAN.HOUSE_APPROACH[0]))

func swim_blend() -> float:
	if superworld == null or not superworld.lake.contains(target.position):
		return 0.0
	return smoothstep(.85,2.8,5.0-target.position.y)

func lakeside_blend() -> float:
	if superworld == null:
		return 0.0
	var at := Vector2(target.position.x,target.position.z)
	var ratio: float = superworld.field.lake_ratio(at)
	return (1.0-smoothstep(.99,1.21,ratio)) if at.x < 650.0 else .0

func focus_position() -> Vector3:
	var diving := swim_blend()
	if diving > .0:
		return target.position+Vector3(1.45,lerpf(1.55,.63,diving),-.30)
	if near_lodge():
		return target.position + Vector3(-1.15, 2.65, -5.8)
	var focus := Vector3(0.0,1.55,lerpf(-.8,7.5,village_camera_blend())).lerp(Vector3(3.0,2.3,-.5),house_camera_blend())
	return target.position + focus.lerp(Vector3(3.7,1.4,0),lakeside_blend())

func desired_position() -> Vector3:
	var length := distance + (1.2 if near_lodge() else 0.0)
	var offset_dir := Vector3(0.55, 0.32, 0.77).normalized() if near_lodge() else Vector3(0.58, 0.44, 0.68).normalized()
	var village := village_camera_blend()
	offset_dir = offset_dir.rotated(Vector3.UP, 2.78 * village)
	length = lerpf(length, length*.41, village)
	offset_dir = offset_dir.lerp(Vector3(-.79,.43,-.44),house_camera_blend()).normalized()
	length = lerpf(length,length*.52,house_camera_blend())
	var diving := swim_blend()
	var shore := lakeside_blend()
	length = lerpf(lerpf(length,length*.58,shore),4.1,diving)
	offset_dir = offset_dir.lerp(Vector3(-.87,.33,.43).normalized(),shore)
	offset_dir = offset_dir.lerp(Vector3(-.73,.10,.67).normalized(),diving)
	var p := target.position + Vector3.UP*lerpf(1.45,.60,diving) + offset_dir*length
	var y: float = superworld.terrain_height(p.x,p.z) if superworld != null else ForestLandscape.height_at(p.x,p.z)
	p.y = maxf(p.y,y + lerpf(2.0,1.30,diving))
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
	if superworld != null:
		far = 4300.0
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
