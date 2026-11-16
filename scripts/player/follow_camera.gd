extends Camera3D
@export var target: Node3D
var distance := 18.0

func _ready() -> void:
	position = desired_position()
	look_at(target.position + Vector3.UP)

func desired_position() -> Vector3:
	return target.position + Vector3(0.54,0.65,0.54).normalized()*distance + Vector3.UP

func _process(delta: float) -> void:
	position = position.lerp(desired_position(), 1-exp(-6*delta))
	look_at(target.position + Vector3.UP)

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == MOUSE_BUTTON_WHEEL_UP:
			distance = clampf(distance-1, 10, 22)
		elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			distance = clampf(distance+1, 10, 22)
