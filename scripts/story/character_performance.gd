extends RefCounted
## Facial channels are brow lift, eyelid openness, mouth-corner lift and jaw drop.
const FACES := {
	"Neutral": Vector4.ZERO,
	"Tired": Vector4(-0.25, -0.29, -0.10, 0.03),
	"Thinking": Vector4(0.28, -0.08, -0.13, 0.0),
	"Concerned": Vector4(0.36, -0.09, -0.38, 0.0),
	"Surprised": Vector4(0.91, 0.49, 0.04, 0.41),
	"Sad": Vector4(0.24, -0.19, -0.62, 0.02),
	"Happy": Vector4(0.24, -0.13, 1.0, 0.18),
	"Subtle Smile": Vector4(0.09, -0.04, 0.49, 0.0),
}
const HEAD_LIMIT := Vector2(0.38, 0.72)
const EYE_LIMIT := Vector2(0.16, 0.25)

var face := Vector4.ZERO
var face_start := Vector4.ZERO
var face_goal := Vector4.ZERO
var face_elapsed := 0.0
var face_duration := 0.35
var hold_left := 0.0
var notice_left := 0.0
var notice := Vector4.ZERO
var gaze := Vector2.ZERO
var head := Vector2.ZERO
var attention := Vector3.INF
var turn_delay := 0.0
var blink := 0.0
var blink_until := 1.8
var rng := RandomNumberGenerator.new()

func seed_clock(seed_value: int) -> void:
	rng.seed = seed_value
	blink_until = rng.randf_range(1.1, 4.3)

func set_face(expression: String, amount: float, duration: float) -> void:
	var channels: Vector4 = FACES.get(expression, Vector4.ZERO)
	var goal := channels * amount
	if goal.is_equal_approx(face_goal):
		return
	face_start = face
	face_goal = goal
	face_elapsed = 0.0
	face_duration = maxf(0.02, duration)

func emote(expression: String, amount: float, hold: float, duration: float) -> void:
	var channels: Vector4 = FACES.get(expression, Vector4.ZERO)
	notice = channels * amount
	notice_left = hold + duration
	hold_left = duration

func look_at_world(target: Vector3) -> void:
	if target.is_finite() != attention.is_finite() or (target.is_finite() and target.distance_squared_to(attention) > 0.25):
		turn_delay = 0.11
	attention = target

func tick(delta: float, skeleton: Skeleton3D, eye_origin: Vector3, fallback: Vector2) -> void:
	face_elapsed += delta
	var target := face_start.lerp(face_goal, smoothstep(0.0, face_duration, face_elapsed))
	notice_left = maxf(0.0, notice_left - delta)
	if notice_left > 0.0:
		target = target.lerp(notice, smoothstep(0.0, maxf(0.02, hold_left), notice_left))
	face = face.lerp(target, 1.0 - exp(-18.0 * delta))
	blink_until -= delta
	if blink_until <= -0.16:
		blink_until += rng.randf_range(2.6, 6.4)
	blink = smoothstep(0.0, 0.064, -blink_until) * (1.0 - smoothstep(0.070, 0.154, -blink_until))

	var angle := fallback
	if attention.is_finite():
		var direction := skeleton.to_local(attention) - eye_origin
		if direction.length_squared() > 0.0001:
			angle = Vector2(-atan2(direction.y, Vector2(direction.x, direction.z).length()), atan2(direction.x, direction.z))
	angle = angle.clamp(-HEAD_LIMIT - EYE_LIMIT, HEAD_LIMIT + EYE_LIMIT)
	var desired_head := angle.clamp(-HEAD_LIMIT, HEAD_LIMIT)
	turn_delay = maxf(0.0, turn_delay - delta)
	gaze = gaze.lerp((angle - head).clamp(-EYE_LIMIT, EYE_LIMIT), 1.0 - exp(-16.0 * delta))
	if turn_delay == 0.0:
		head = head.lerp(desired_head, 1.0 - exp(-5.5 * delta))
