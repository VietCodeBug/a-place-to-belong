extends Node3D

const S = preload("res://scripts/world/shapes.gd")
const CLEARING = preload("res://scripts/environment/a1_clearing.gd")
const HOUSE = preload("res://assets/a1_house_gate/hewn_eaves_cottage.glb")
var walker: CharacterBody3D
var eye: Camera3D
var look := Vector2.ZERO


func _ready() -> void:
	var env := WorldEnvironment.new()
	var settings := Environment.new()
	settings.background_mode = Environment.BG_SKY
	var sky := Sky.new()
	var daylight := ProceduralSkyMaterial.new()
	daylight.sky_top_color = Color("5A83B3")
	daylight.sky_horizon_color = Color("C7D5DB")
	daylight.ground_horizon_color = Color("CACAB8")
	daylight.ground_bottom_color = Color("849884")
	sky.sky_material = daylight
	settings.sky = sky
	settings.ambient_light_source = Environment.AMBIENT_SOURCE_COLOR
	settings.ambient_light_color = Color("D8E5FF")
	settings.ambient_light_energy = 0.59
	settings.fog_enabled = true
	settings.fog_mode = Environment.FOG_MODE_DEPTH
	settings.fog_light_color = Color("A5B4AC")
	settings.fog_sky_affect = 0.12
	settings.fog_depth_begin = 20.0
	settings.fog_depth_end = 67.0
	env.environment = settings
	add_child(env)
	var sun := DirectionalLight3D.new()
	sun.rotation_degrees = Vector3(-43,-35,0)
	sun.light_color = Color("FFDFB6")
	sun.light_energy = 0.67
	sun.shadow_opacity = 0.86
	sun.shadow_enabled = true
	sun.shadow_bias = 0.045
	sun.directional_shadow_max_distance = 52
	add_child(sun)
	var house := HOUSE.instantiate() as Node3D
	house.name = "HewnEavesCottage"
	add_child(house)
	S.box(self, Vector3(-0.48,1.57,0.04), Vector3(5.12,3.17,4.23),"FFFFFF",true).hide()
	S.box(self, Vector3(1.78,1.74,1.17), Vector3(2.45,3.45,2.72),"FFFFFF",true).hide()
	S.box(self, Vector3(-3.05,0.98,-0.28), Vector3(1.36,1.95,3.25),"FFFFFF",true).hide()
	var porch_collision := S.box(self, Vector3(-0.49,0.185,2.98),
		Vector3(1.66,0.125,1.58),"FFFFFF",true)
	porch_collision.rotation.x = 0.31
	porch_collision.hide()
	var clearing := CLEARING.new()
	clearing.name = "ForestClearing"
	add_child(clearing)
	var guide := Label.new()
	guide.text = "A1  ·  House Art Gate     WASD / chuột     Esc thả chuột"
	guide.position = Vector2(20,18)
	var overlay := CanvasLayer.new()
	overlay.name = "Help"
	add_child(overlay)
	overlay.add_child(guide)
	walker = CharacterBody3D.new()
	add_child(walker)
	walker.position = Vector3(0.9,CLEARING.height(0.9,8.2)+0.06,8.2)
	walker.floor_snap_length = 0.35
	var capsule := CapsuleShape3D.new()
	capsule.height = 1.78
	capsule.radius = 0.31
	var collider := CollisionShape3D.new()
	collider.shape = capsule
	collider.position.y = 0.89
	walker.add_child(collider)
	eye = Camera3D.new()
	eye.position.y = 1.65
	eye.fov = 64
	walker.add_child(eye)
	eye.make_current()

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	elif event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	elif event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		look -= event.relative * 0.0023
		look.y = clampf(look.y,-1.38,1.38)
		walker.rotation.y = look.x
		eye.rotation.x = look.y

func _physics_process(delta: float) -> void:
	var move := Vector2(
		float(Input.is_physical_key_pressed(KEY_D))-float(Input.is_physical_key_pressed(KEY_A)),
		float(Input.is_physical_key_pressed(KEY_S))-float(Input.is_physical_key_pressed(KEY_W)))
	move_walker(move,delta)

func move_walker(move: Vector2, delta: float) -> void:
	var speed := walker.basis*Vector3(move.x,0,move.y).limit_length()*3.1
	walker.velocity.x = speed.x
	walker.velocity.z = speed.z
	walker.velocity.y -= delta*18.0
	walker.move_and_slide()
