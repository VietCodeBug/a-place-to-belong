extends CharacterBody3D

var blocked := false
var state := "idle"
var walk_time := 0.0
@onready var model: Node3D = $Model
var left_leg: MeshInstance3D
var right_leg: MeshInstance3D

func _ready() -> void:
	ForestShapes.box(model, Vector3(0,1.0,0), Vector3(0.55,0.6,0.32), "496B59")
	ForestShapes.box(model, Vector3(0,1.53,0), Vector3(0.48,0.45,0.43), "E5BA93")
	ForestShapes.cone(model, Vector3(0,1.79,0), 0.32, 0.13, "C87760", 0.27)
	for x in [-0.12,0.12]:
		ForestShapes.box(model, Vector3(x,1.56,-0.222), Vector3(0.045,0.045,0.02), "343C38")
	for x in [-0.36,0.36]:
		ForestShapes.box(model, Vector3(x,0.99,0), Vector3(0.15,0.56,0.2), "B88254")
	left_leg = ForestShapes.box(model, Vector3(-0.16,0.36,0), Vector3(0.22,0.65,0.25), "384E52")
	right_leg = ForestShapes.box(model, Vector3(0.16,0.36,0), Vector3(0.22,0.65,0.25), "384E52")
	ForestShapes.box(model, Vector3(0.34,0.8,0.12), Vector3(0.24,0.35,0.3), "C87760")

func _physics_process(delta: float) -> void:
	var input := Vector2.ZERO if blocked else Input.get_vector("move_left", "move_right", "move_up", "move_down")
	var direction := Vector3(input.x,0,input.y).rotated(Vector3.UP, PI/4)
	var speed := 4.5 if Input.is_action_pressed("jog") else 2.8
	velocity.x = move_toward(velocity.x, direction.x*speed, 12*delta)
	velocity.z = move_toward(velocity.z, direction.z*speed, 12*delta)
	velocity.y -= 20*delta
	if is_on_floor():
		velocity.y = 0
	move_and_slide()
	state = "walking" if direction.length() > 0.1 else "idle"
	if state == "walking":
		model.rotation.y = lerp_angle(model.rotation.y, atan2(-direction.x,-direction.z), 1-exp(-12*delta))
		walk_time += delta*9
	var stride := sin(walk_time)*0.22 if state == "walking" else 0.0
	left_leg.rotation.x = stride
	right_leg.rotation.x = -stride
