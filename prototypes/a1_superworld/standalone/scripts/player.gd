class_name A1Explorer
extends CharacterBody3D
## Fly-free exploration: first-person by default, V toggles scenic over-shoulder.
const G = preload("res://scripts/world_gen.gd")
var gen: A1WorldGen
var neck: Node3D
var camera: Camera3D
var body_mesh:MeshInstance3D
var third_person:=false
var mouse_sensitivity:=.0024
var walk_speed:=8.5
var run_speed:=17.0
var swim_speed:=7.0
var underwater:=false
var fishing_available:=false
var pitch:=0.0

func setup(g:A1WorldGen) -> void:
	gen=g

func _ready() -> void:
	var collision:=CollisionShape3D.new()
	var capsule:=CapsuleShape3D.new()
	capsule.radius=.42
	capsule.height=1.8
	collision.shape=capsule
	collision.position=Vector3(0,.92,0)
	add_child(collision)
	var shape:=CapsuleMesh.new()
	shape.radius=.40
	shape.height=1.75
	body_mesh=MeshInstance3D.new()
	body_mesh.mesh=shape
	body_mesh.position=Vector3(0,.96,0)
	var mat:=StandardMaterial3D.new()
	mat.albedo_color=Color("e7cf9a")
	body_mesh.material_override=mat
	body_mesh.visible=false
	add_child(body_mesh)
	neck=Node3D.new()
	neck.position=Vector3(0,1.62,0)
	add_child(neck)
	camera=Camera3D.new()
	camera.current=true
	camera.fov=72.0
	camera.far=2500.0
	neck.add_child(camera)
	Input.mouse_mode=Input.MOUSE_MODE_CAPTURED

func _unhandled_input(event:InputEvent) -> void:
	if event is InputEventMouseMotion and Input.mouse_mode==Input.MOUSE_MODE_CAPTURED:
		rotate_y(-event.relative.x*mouse_sensitivity)
		pitch=clampf(pitch-event.relative.y*mouse_sensitivity,-1.45,1.40)
		neck.rotation.x=pitch
	if event.is_action_pressed("toggle_camera"):
		third_person=not third_person
		body_mesh.visible=third_person
		camera.position=Vector3(0,2.0,6.0) if third_person else Vector3.ZERO

func is_in_lake() -> bool:
	if gen==null:return false
	return gen.lake_ratio(global_position.x,global_position.z)<1.06

func _physics_process(delta:float) -> void:
	if gen==null:return
	var body_water := is_in_lake() and global_position.y<G.WATER_LEVEL+1.1
	underwater=is_in_lake() and neck.global_position.y<G.WATER_LEVEL-.4
	if Input.mouse_mode!=Input.MOUSE_MODE_CAPTURED:
		velocity=Vector3.ZERO
		move_and_slide()
		return
	var dir:=Input.get_vector("left","right","forward","back")
	var move:=global_transform.basis*Vector3(dir.x,0,dir.y)
	move.y=0.0
	move=move.normalized()
	var speed:=swim_speed if body_water else run_speed if Input.is_action_pressed("sprint") else walk_speed
	velocity.x=move.x*speed
	velocity.z=move.z*speed
	if body_water:
		if Input.is_action_pressed("jump"):
			velocity.y=6.4
		elif Input.is_action_pressed("dive"):
			velocity.y=-5.5
		else:
			velocity.y=lerpf(velocity.y,0.0,minf(delta*4.0,1.0))
	elif is_on_floor():
		if Input.is_action_just_pressed("jump"):
			velocity.y=8.3
		else:
			velocity.y=0.0
	else:
		velocity.y-=18.0*delta
	move_and_slide()
	global_position.x=clampf(global_position.x,-G.HALF+8.0,G.HALF-8.0)
	global_position.z=clampf(global_position.z,-G.HALF+8.0,G.HALF-8.0)
	if global_position.y<gen.terrain_height(global_position.x,global_position.z)-3.0:
		global_position.y=gen.terrain_height(global_position.x,global_position.z)+1.5

func teleport_to(p:Vector2,below_water:=false) -> void:
	var terrain:=gen.terrain_height(p.x,p.y)
	global_position=Vector3(p.x,terrain+2.5,p.y)
	if below_water:global_position.y=minf(G.WATER_LEVEL-5.0,terrain+3.0)
	velocity=Vector3.ZERO
