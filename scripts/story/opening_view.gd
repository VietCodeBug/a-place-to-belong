extends Camera3D
## Eye-level view mounted inside the player's collision capsule.
const STANDING_HEIGHT := 1.55
const SEATED_HEIGHT := 1.19
const SEAT_YAW_LIMIT := 0.98
const DOWN_LIMIT := -1.22
const SEATED_DOWN_LIMIT := -1.07

var yaw := 0.0
var pitch := -0.13
var sensitivity := 1.0
var head_bob := true
var step_phase := 0.0
var bob := Vector2.ZERO
var focus: Node3D
var focus_weight := 0.0
var focus_target := 0.0
var probe := SphereShape3D.new()
var pose_offset := Vector3.ZERO
var pose_aim := 0.0
var pose_look := Vector3.INF

func _ready() -> void:
	fov = 59.0
	near = 0.035
	far = 220.0
	probe.radius = 0.082

func look_with_mouse(mouse: Vector2, seated: float) -> void:
	yaw = wrapf(yaw - mouse.x * 0.00235 * sensitivity, -PI, PI)
	if seated > 0.0:
		yaw = clampf(yaw, -SEAT_YAW_LIMIT, SEAT_YAW_LIMIT)
	pitch = clampf(pitch - mouse.y * 0.0021 * sensitivity, lerpf(DOWN_LIMIT, SEATED_DOWN_LIMIT, seated), 1.30)

func sync_input() -> void:
	rotation = Vector3(maxf(pitch, DOWN_LIMIT), yaw, 0.0)

func follow_eyes(delta: float, seated: float, speed: float, scripted := false) -> void:
	if head_bob and speed > 0.09:
		step_phase += delta * (3.1 + 2.6 * speed)
	var amplitude := smoothstep(0.05, 3.05, speed) if head_bob else 0.0
	var sway := Vector2(sin(step_phase) * 0.009, cos(step_phase * 2.0) * 0.012)
	bob = bob.lerp(sway * amplitude, 1.0 - exp(-16.0 * delta))
	focus_weight = move_toward(focus_weight, focus_target, delta * 3.7)
	var emphasis := smoothstep(0.0, 1.0, focus_weight)
	var anchor := Vector3.UP * lerpf(STANDING_HEIGHT, SEATED_HEIGHT, seated)
	var view_pitch := maxf(pitch, lerpf(DOWN_LIMIT, SEATED_DOWN_LIMIT, seated))
	var down_lean := smoothstep(0.43, 1.20, -view_pitch) * 0.18 * (1.0 - seated)
	var drift := Vector3(bob.x, bob.y, -0.048 * seated - down_lean).rotated(Vector3.UP, yaw * (1.0 - seated))
	var room := drift_clearance(anchor, drift)
	position = anchor + pose_offset + drift * room
	# A wall can take away the room needed to look ahead of the collar.
	view_pitch = maxf(view_pitch, lerpf(-0.91, DOWN_LIMIT, room))
	fov = lerpf(59.0, 54.0, emphasis)
	var heading := Vector3(view_pitch, yaw, 0.0)
	if focus != null and emphasis > 0.0:
		var direction := global_position.direction_to(focus.global_position)
		heading.x = lerp_angle(heading.x, asin(direction.y), emphasis)
		heading.y = lerp_angle(heading.y, atan2(-direction.x, -direction.z), emphasis)
	if pose_look.is_finite() and pose_aim > 0.0:
		var direction := global_position.direction_to(pose_look)
		heading.x = lerp_angle(heading.x, asin(direction.y), pose_aim)
		heading.y = lerp_angle(heading.y, atan2(-direction.x, -direction.z), pose_aim)
	var ease := 1.0 if scripted or delta == 0.0 else 1.0 - exp(-28.0 * delta)
	rotation.x = lerp_angle(rotation.x, heading.x, ease)
	rotation.y = lerp_angle(rotation.y, heading.y, ease)

func drift_clearance(anchor: Vector3, drift: Vector3) -> float:
	if drift.length_squared() < 0.000001 or not Engine.is_in_physics_frame():
		return 1.0
	var query := PhysicsShapeQueryParameters3D.new()
	query.shape = probe
	query.transform.origin = get_parent().to_global(anchor)
	query.motion = get_parent().global_basis * drift
	query.collision_mask = 1
	query.exclude = [get_parent().get_rid()]
	var travel := get_world_3d().direct_space_state.cast_motion(query)
	return travel[0] if not travel.is_empty() else 0.0
