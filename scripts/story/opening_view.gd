extends Camera3D
## Eye-level view mounted inside the player's collision capsule.
const STANDING_HEIGHT := 1.55
const SEATED_HEIGHT := 1.19
const SEAT_YAW_LIMIT := 0.98

var yaw := 0.0
var pitch := -0.13
var step_phase := 0.0
var bob := Vector2.ZERO

func _ready() -> void:
	fov = 59.0
	near = 0.045
	far = 220.0

func look_with_mouse(mouse: Vector2, seated: float) -> void:
	yaw = wrapf(yaw - mouse.x * 0.00235, -PI, PI)
	if seated > 0.0:
		yaw = clampf(yaw, -SEAT_YAW_LIMIT, SEAT_YAW_LIMIT)
	pitch = clampf(pitch - mouse.y * 0.0021, -1.34, 1.30)

func follow_eyes(delta: float, seated: float, speed: float) -> void:
	if speed > 0.09:
		step_phase += delta * (3.1 + 2.6 * speed)
	var amplitude := smoothstep(0.05, 3.05, speed)
	var sway := Vector2(sin(step_phase) * 0.022, cos(step_phase * 2.0) * 0.026)
	bob = bob.lerp(sway * amplitude, 1.0 - exp(-14.0 * delta))
	var eyes := Vector3(bob.x, lerpf(STANDING_HEIGHT, SEATED_HEIGHT, seated) + bob.y, -0.048 * seated)
	position = Vector3.UP * eyes.y + Vector3(eyes.x, 0.0, eyes.z).rotated(Vector3.UP, yaw * (1.0 - seated))
	rotation = Vector3(pitch, yaw, 0.0)
