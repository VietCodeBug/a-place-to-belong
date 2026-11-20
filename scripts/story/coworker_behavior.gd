extends RefCounted
## Work states own hands/posture. Attention may briefly override the current look target.
const STATES := {
	"Typing": Vector2(3.4, 8.8), "Reading": Vector2(1.5, 3.1),
	"Thinking": Vector2(1.7, 3.2), "Mouse": Vector2(1.1, 2.5),
	"Short Break": Vector2(1.6, 3.5), "Looking Around": Vector2(0.9, 2.1),
	"Listening": Vector2(2.4, 7.0), "Drinking": Vector2(3.0, 4.2),
}
const CHOICES := [
	["Reading", "Mouse", "Reading", "Thinking", "Mouse"],
	["Reading", "Looking Around", "Mouse", "Thinking", "Looking Around"],
	["Short Break", "Reading", "Thinking", "Mouse", "Short Break"],
]
var rng := RandomNumberGenerator.new()
var profile := 0
var state := "Typing"
var age := 0.0
var duration := 1.0
var cooldown := 0.0
var glance := 0.0
var changes := 0
var meeting := false
var has_mug := false

func setup(seed_value: int, selected: int, at_meeting: bool, can_drink: bool) -> void:
	rng.seed = seed_value
	profile = selected
	meeting = at_meeting
	has_mug = can_drink
	enter("Listening" if meeting else "Typing")
	age = rng.randf_range(0.03, duration * 0.56)
	cooldown = rng.randf_range(2.5, 9.0)

func enter(next: String) -> void:
	state = next
	age = 0.0
	var range_seconds: Vector2 = STATES[next]
	duration = rng.randf_range(range_seconds.x, range_seconds.y)
	changes += 1

func update(delta: float, can_notice: bool) -> void:
	age += delta
	cooldown = maxf(0.0, cooldown - delta)
	glance = maxf(0.0, glance - delta)
	if can_notice and cooldown == 0.0 and state in ["Typing", "Looking Around", "Listening", "Short Break"]:
		cooldown = rng.randf_range(8.0, 18.0)
		if rng.randf() < [0.28, 0.69, 0.40][profile]:
			glance = rng.randf_range(0.68, 1.14)
	if age < duration:
		return
	if meeting:
		if state == "Listening":
			enter("Drinking" if has_mug and rng.randf() < 0.60 else "Reading")
		else:
			enter("Listening")
	elif state == "Typing":
		enter(CHOICES[profile][rng.randi_range(0, CHOICES[profile].size() - 1)])
	else:
		enter("Typing")

func drink_progress() -> float:
	if state != "Drinking":
		return 0.0
	var t := age / duration
	return smoothstep(0.0, 0.42, t) * (1.0 - smoothstep(0.59, 0.98, t))
