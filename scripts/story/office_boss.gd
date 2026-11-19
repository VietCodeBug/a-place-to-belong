extends CharacterBody3D
## The boss walks the cross aisle and stops by desks without blocking the exit route.

const STOPS := [
	{"position": Vector3(-3.74, 0, -2.40), "look_at": Vector3(-4.97, 0, -3.41), "pause": 2.1},
	{"position": Vector3(0.14, 0, -2.40), "look_at": Vector3(-0.35, 0, -4.11), "pause": 1.8},
	{"position": Vector3(2.58, 0, -2.40), "look_at": Vector3(4.70, 0, -3.42), "pause": 2.4},
]
const WALK_SPEED := 1.15
const ACCELERATION := 2.4
const TURN_SPEED := 2.25

@onready var actor = $BossActor

var player: CharacterBody3D
var next_stop := 0
var pause_left := 0.56
var focus := Vector3(-0.33, 0, -4.1)
var elapsed := 0.0

func _ready() -> void:
	actor.rotation.y = -PI * 0.5
	actor.resync(0.0, Vector3.ZERO)

func _physics_process(delta: float) -> void:
	elapsed += delta
	pause_left = maxf(0.0, pause_left - delta)
	var stop: Dictionary = STOPS[next_stop]
	var target: Vector3 = stop.position
	var approach := planar(target - global_position)
	var current_speed := planar(velocity).length()
	if pause_left == 0.0 and approach.length() < 0.095 and current_speed < 0.15:
		focus = stop.look_at
		pause_left = stop.pause
		next_stop = (next_stop + 1) % STOPS.size()
	var direction := approach.normalized()
	var yielding := player_in_the_way(direction)
	var inspecting := pause_left > 0.0
	var attention := direction
	if current_speed > 0.16:
		attention = planar(velocity).normalized()
	elif yielding:
		attention = planar(player.global_position - global_position).normalized()
	elif inspecting:
		attention = planar(focus - global_position).normalized()
	if attention.length_squared() > 0.0:
		var wanted_yaw := atan2(attention.x, attention.z)
		actor.rotation.y = rotate_toward(actor.rotation.y, wanted_yaw, TURN_SPEED * delta)
	var speed := 0.0
	if not inspecting and not yielding and direction.length_squared() > 0.0:
		var travel_yaw := atan2(direction.x, direction.z)
		var alignment := 1.0 - smoothstep(0.16, 0.53, absf(angle_difference(actor.rotation.y, travel_yaw)))
		var braking_speed := sqrt(2.0 * ACCELERATION * maxf(0.0, approach.length() - 0.045))
		speed = minf(WALK_SPEED, braking_speed) * alignment
	velocity = planar(velocity).move_toward(direction * speed, ACCELERATION * delta)
	move_and_slide()
	var scan := sin(elapsed * 1.46) * (0.38 if inspecting else 0.23)
	actor.looking_out = move_toward(actor.looking_out, scan, delta * 1.4)
	actor.resync(delta, planar(get_real_velocity()))

func planar(value: Vector3) -> Vector3:
	return Vector3(value.x, 0.0, value.z)

func player_in_the_way(direction: Vector3) -> bool:
	if not is_instance_valid(player):
		return false
	var separation := planar(player.global_position - global_position)
	var forward := separation.dot(direction)
	var lateral := (separation - direction * forward).length()
	return separation.length() < 0.69 or (forward > 0.0 and forward < 1.08 and lateral < 0.46)
