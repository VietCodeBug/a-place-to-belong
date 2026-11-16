extends Node3D
const S = preload("res://scripts/world/shapes.gd")
var player: CharacterBody3D
var mailbox: Node3D
var ui: CanvasLayer

func _ready() -> void:
	configure_inputs()
	var environment := WorldEnvironment.new()
	var settings := Environment.new()
	settings.background_mode = Environment.BG_COLOR
	settings.background_color = Color("B6CFCE")
	settings.ambient_light_source = Environment.AMBIENT_SOURCE_COLOR
	settings.ambient_light_color = Color("F6E8D0")
	settings.ambient_light_energy = 0.4
	environment.environment = settings
	add_child(environment)
	var sun := DirectionalLight3D.new()
	sun.rotation_degrees = Vector3(-38,-35,0)
	sun.light_color = Color("FFE1AF")
	sun.light_energy = 0.7
	sun.shadow_enabled = true
	add_child(sun)
	S.box(self,Vector3(0,-0.3,0),Vector3(48,0.6,48),"78956D",true)
	# A gently winding sandy route; broad overlapping patches avoid visible gaps.
	for i in range(32):
		var z := -8.0+i*0.95
		S.cone(self,Vector3(sin(z*0.22)*2,0.012,z),1.8,0.025,"D8BF91",1.8)
	build_cafe()
	mailbox = preload("res://scenes/props/mailbox.tscn").instantiate()
	mailbox.name = "Mailbox"
	add_child(mailbox)
	mailbox.position = Vector3(3.6,0,3.5)
	build_bicycle(Vector3(-3.8,0,2.7))
	build_bench(Vector3(7,0,1))
	build_bench(Vector3(-7,0,4))
	S.cone(self,Vector3(-6,0.75,1),0.85,0.14,"B88254",0.85)
	S.box(self,Vector3(-6,0.35,1),Vector3(0.2,0.7,0.2),"92633F",true)
	S.cone(self,Vector3(-6,0.93,1),0.12,0.22,"F6E8D0",0.14)
	S.box(self,Vector3(6,0.8,6),Vector3(0.15,1.6,0.15),"B88254",true)
	S.box(self,Vector3(6,1.5,6),Vector3(1.5,0.4,0.15),"F6E8D0")
	var rng := RandomNumberGenerator.new()
	rng.seed = 4816
	for i in range(65):
		var p := Vector3(rng.randf_range(-22,22),0,rng.randf_range(-22,22))
		if absf(p.x) < 8 and p.z > -10 and p.z < 19:
			continue
		build_tree(p,rng.randf_range(0.8,1.4))
	for i in range(90):
		var p := Vector3(rng.randf_range(-19,19),0,rng.randf_range(-18,19))
		if absf(p.x) < 5 and p.z > -9:
			continue
		if i % 3 == 0:
			S.cone(self,p+Vector3(0,0.3,0),0.65,0.6,"82948E",0.3)
		elif i % 3 == 1:
			S.cone(self,p+Vector3(0,0.35,0),0.8,0.7,"496B59",0.35)
		else:
			flower(p)
	for x in [-4.5,4.5]:
		S.cone(self,Vector3(x,0.3,1.5),0.38,0.6,"C87760",0.48)
		for j in range(5):
			flower(Vector3(x+(j-2)*0.12,0.55,1.5+sin(j)*0.2))
	# Solid trunks and terrain perimeter keep the hub bounded.
	for p in [Vector3(-24,1,0),Vector3(24,1,0)]:
		S.box(self,p,Vector3(0.5,3,48),"496B59",true)
	for z in [-24,24]:
		S.box(self,Vector3(0,1,z),Vector3(48,3,0.5),"496B59",true)
	for i in range(9):
		S.cone(self,Vector3(-36+i*9,2,-34),8,14+(i%3)*3,"7E9B9A")
	player = preload("res://scenes/player/postal_worker.tscn").instantiate()
	player.name = "Player"
	add_child(player)
	player.position = Vector3(1,0.1,7)
	var camera := Camera3D.new()
	camera.set_script(preload("res://scripts/player/follow_camera.gd"))
	camera.target = player
	camera.fov = 55
	add_child(camera)
	ui = CanvasLayer.new()
	ui.set_script(preload("res://scripts/interactions/interaction_controller.gd"))
	ui.player = player
	add_child(ui)

func configure_inputs() -> void:
	var bindings := {"move_left":KEY_A,"move_right":KEY_D,"move_up":KEY_W,"move_down":KEY_S,"jog":KEY_SHIFT,"interact":KEY_E}
	for action in bindings:
		if not InputMap.has_action(action):
			InputMap.add_action(action)
			var key := InputEventKey.new()
			key.physical_keycode = bindings[action]
			InputMap.action_add_event(action,key)

func build_cafe() -> void:
	var cafe := Node3D.new()
	cafe.name = "Cafe"
	add_child(cafe)
	S.box(cafe,Vector3(0,1.6,-3),Vector3(8,3.2,6),"B88254",true)
	for y in range(8):
		S.box(cafe,Vector3(0,0.25+y*0.4,0.015),Vector3(8,0.035,0.035),"92633F")
	S.box(cafe,Vector3(0,2.9,0.05),Vector3(8,0.42,0.13),"F6E8D0")
	# Ridge along Z: two steep matte roof planes and triangular end cap.
	for side in [-1,1]:
		var roof := S.box(cafe,Vector3(side*2.2,4.12,-3),Vector3(5.35,0.22,7),"8BA58A")
		roof.rotation.z = side*-0.55
	for z in [0.0,-6.0]:
		var gable := ImmediateMesh.new()
		gable.surface_begin(Mesh.PRIMITIVE_TRIANGLES)
		gable.surface_set_normal(Vector3(0,0,1 if z == 0.0 else -1))
		var points := [Vector3(-4,3.2,z),Vector3(4,3.2,z),Vector3(0,5.48,z)]
		if z < 0:
			points.reverse()
		for point in points:
			gable.surface_add_vertex(point)
		gable.surface_end()
		S.mesh(cafe,gable,Vector3.ZERO,"B88254")
	S.box(cafe,Vector3(0,5.55,-3),Vector3(0.3,0.22,7.1),"C87760")
	S.box(cafe,Vector3(0,1.15,0.1),Vector3(1.15,2.3,0.16),"C8A14F")
	S.box(cafe,Vector3(0.36,1.12,0.22),Vector3(0.1,0.1,0.12),"F6E8D0")
	for x in [-2.5,2.5]:
		S.box(cafe,Vector3(x,1.8,0.1),Vector3(1.8,1.5,0.2),"659A98")
		S.box(cafe,Vector3(x,1.8,0.22),Vector3(1.5,1.2,0.04),"F6DDA6")
		S.box(cafe,Vector3(x,1.8,0.26),Vector3(0.07,1.3,0.05),"659A98")
		S.box(cafe,Vector3(x,1.8,0.26),Vector3(1.6,0.07,0.05),"659A98")
	S.box(cafe,Vector3(0,0.15,1),Vector3(8.8,0.3,2),"B88254",true)
	for i in range(12):
		S.box(cafe,Vector3(-4.1+i*0.74,0.31,1),Vector3(0.025,0.02,2),"92633F")
	for side in [-1,1]:
		S.box(cafe,Vector3(side*4.15,0.8,1),Vector3(0.12,0.12,2),"B88254",true)
		for z in [0.2,1.8]:
			S.box(cafe,Vector3(side*4.15,0.7,z),Vector3(0.15,1.3,0.15),"B88254",true)
	# A shallow ramp serves as a practical step for CharacterBody movement.
	var ramp := S.box(cafe,Vector3(0,0.07,2.35),Vector3(2,0.15,1.2),"B88254",true)
	ramp.rotation.x = 0.2

func build_tree(p: Vector3, scale_factor: float) -> void:
	var tree := Node3D.new()
	add_child(tree)
	tree.position = p
	tree.scale = Vector3.ONE*scale_factor
	S.box(tree,Vector3(0,1,0),Vector3(0.35,2,0.35),"92633F",true)
	for tier in range(3):
		S.cone(tree,Vector3(0,1.7+tier*0.9,0),1.5-tier*0.33,2,"496B59" if tier%2 == 0 else "66856B")

func flower(p: Vector3) -> void:
	S.cone(self,p+Vector3(0,0.16,0),0.035,0.32,"496B59",0.035)
	S.cone(self,p+Vector3(0,0.35,0),0.15,0.09,"F6E8D0",0.08)

func build_bench(p: Vector3) -> void:
	S.box(self,p+Vector3(0,0.55,0),Vector3(2,0.16,0.6),"B88254",true)
	S.box(self,p+Vector3(0,1.05,-0.28),Vector3(2,0.6,0.12),"B88254",true)
	for x in [-0.75,0.75]:
		S.box(self,p+Vector3(x,0.25,0),Vector3(0.15,0.5,0.5),"92633F",true)

func build_bicycle(p: Vector3) -> void:
	var bike := Node3D.new()
	bike.name = "DeliveryBicycle"
	add_child(bike)
	bike.position = p
	for x in [-0.7,0.7]:
		var wheel := TorusMesh.new()
		wheel.inner_radius = 0.34
		wheel.outer_radius = 0.45
		wheel.rings = 12
		wheel.ring_segments = 6
		var n := S.mesh(bike,wheel,Vector3(x,0.46,0),"343C38")
		n.rotation.x = PI/2
		for j in range(6):
			var a := j*PI/3
			S.beam(bike,Vector3(x,0.46,0),Vector3(x+cos(a)*0.36,0.46+sin(a)*0.36,0),0.025,"B6B8AA")
	var a := Vector3(-0.7,0.46,0)
	var b := Vector3(0,0.46,0)
	var c := Vector3(-0.25,1.05,0)
	var d := Vector3(0.55,1.05,0)
	for pair in [[a,b],[b,c],[c,a],[c,d],[d,b],[d,Vector3(0.7,0.46,0)]]:
		S.beam(bike,pair[0],pair[1],0.07,"C85E55")
	S.box(bike,Vector3(-0.25,1.15,0),Vector3(0.4,0.12,0.24),"92633F")
	S.beam(bike,d,Vector3(0.55,1.4,0),0.06,"B6B8AA")
	S.box(bike,Vector3(0.55,1.4,0),Vector3(0.1,0.08,0.6),"343C38")
	S.box(bike,Vector3(0.85,1.16,0),Vector3(0.45,0.35,0.46),"D3AF76")
	S.box(bike,Vector3(0,0.5,0),Vector3(2.1,1,0.5),"C85E55").visible = false
	var body := StaticBody3D.new()
	var collision := CollisionShape3D.new()
	var shape := BoxShape3D.new()
	shape.size = Vector3(2.1,1,0.5)
	collision.shape = shape
	bike.add_child(body)
	body.add_child(collision)
	collision.position.y = 0.5
