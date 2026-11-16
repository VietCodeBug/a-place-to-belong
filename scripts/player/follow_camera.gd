extends Camera3D
## Gameplay preset adapts near architecture; cinematic presets live separately.
@export var target: Node3D
var distance := 24.0
var aim := Vector3.ZERO
const MIN_ZOOM := 10.0
const MAX_ZOOM := 40.0

func near_lodge() -> bool:
	return absf(target.position.x)<18 and target.position.z<17 and target.position.z> -16

func focus_position() -> Vector3:
	return target.position+(Vector3(-2,2.3,-5.0) if near_lodge() else Vector3(0,1.4,-0.6))

func _ready() -> void:
	fov = 42
	aim = focus_position()
	position = desired_position()
	look_at(aim)

func desired_position() -> Vector3:
	var length := distance+(2.0 if near_lodge() else 0.0)
	var p := target.position+Vector3.UP*1.5+Vector3(0.62,0.54,0.57).normalized()*length
	p.y = maxf(p.y,ForestLandscape.height_at(p.x,p.z)+2.0)
	return p

func _process(delta: float) -> void:
	position = position.lerp(desired_position(),1-exp(-4.5*delta))
	aim = aim.lerp(focus_position(),1-exp(-5*delta))
	fov = lerpf(fov,42.0 if near_lodge() else 46.0,1-exp(-3*delta))
	look_at(aim)

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == MOUSE_BUTTON_WHEEL_UP:
			distance = clampf(distance-1.5,MIN_ZOOM,MAX_ZOOM)
		elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			distance = clampf(distance+1.5,MIN_ZOOM,MAX_ZOOM)
