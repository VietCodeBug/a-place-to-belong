extends Node3D
const S = preload("res://scripts/world/shapes.gd")
const A = preload("res://scripts/world/field_assets.gd")
const PALETTE = preload("res://assets/palettes/early_autumn.tres")
var player: CharacterBody3D
var mailbox: Node3D
var ui: CanvasLayer

func _ready() -> void:
	configure_inputs()
	lighting()
	S.box(self,Vector3(0,-0.3,0),Vector3(48,0.6,48),PALETTE.ground.to_html(),true)
	S.box(self,Vector3(0,-0.85,-10),Vector3(500,0.6,500),"7B896C")
	build_ground()
	var forest := Node3D.new()
	forest.name = "LicensedWoodland"
	forest.set_script(preload("res://scripts/world/woodland.gd"))
	add_child(forest)
	var cafe := Node3D.new()
	cafe.name = "Cafe"
	cafe.set_script(preload("res://scripts/world/cafe_kit.gd"))
	add_child(cafe)
	mailbox = preload("res://scenes/props/mailbox.tscn").instantiate()
	mailbox.name = "Mailbox"
	add_child(mailbox)
	mailbox.position = Vector3(3.6,0,3.5)
	build_bicycle(Vector3(-3.8,0.28,2.0))
	props()
	for p in [Vector3(-24,1,0),Vector3(24,1,0)]:
		S.box(self,p,Vector3(0.5,3,48),"496B59",true).visible = false
	for z in [-24,24]:
		S.box(self,Vector3(0,1,z),Vector3(48,3,0.5),"496B59",true).visible = false
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

func lighting() -> void:
	var world := WorldEnvironment.new()
	var env := Environment.new()
	env.background_mode = Environment.BG_COLOR
	env.background_color = Color("ADBDB8")
	env.ambient_light_source = Environment.AMBIENT_SOURCE_COLOR
	env.ambient_light_color = Color("DBDFD2")
	env.ambient_light_energy = 0.55
	env.fog_enabled = true
	env.fog_light_color = Color("AFBFC0")
	env.fog_light_energy = 0.5
	env.fog_mode = Environment.FOG_MODE_DEPTH
	env.fog_depth_begin = 38
	env.fog_depth_end = 145
	world.environment = env
	add_child(world)
	var sun := DirectionalLight3D.new()
	sun.rotation_degrees = Vector3(-42,-32,0)
	sun.light_color = Color("FFE0BB")
	sun.light_energy = 0.7
	sun.shadow_enabled = true
	sun.shadow_normal_bias = 2
	sun.shadow_blur = 2
	sun.directional_shadow_max_distance = 65
	add_child(sun)

func props() -> void:
	# Imported seating models have a common, human-usable scale.
	var table := A.place(self,"furniture","tableRound",Vector3(-6.5,0,1.6),0.78)
	A.style(table)
	A.solid(table)
	for p in [Vector3(-7.5,0,2.4),Vector3(-5.4,0,2.4)]:
		var chair := A.place(self,"furniture","chair",p,1.0,PI)
		A.style(chair)
		A.solid(chair)
	var bench := A.place(self,"furniture","bench",Vector3(-6.5,0,-0.2),1.05)
	A.style(bench)
	A.solid(bench)
	for i in range(3):
		var parcel := A.place(self,"furniture","cardboardBoxClosed",Vector3(5.2+i*0.5,0,1.7),0.45+i*0.12,i*0.2)
		A.style(parcel)
	var shelf := A.place(self,"furniture","bookcaseOpenLow",Vector3(5.5,0,0.6),1.2,PI/2)
	A.style(shelf)
	var sign := A.place(self,"nature","sign",Vector3(5.7,0,6.5),1.6,-0.3)
	A.style(sign)
	A.solid(sign)
	for side in [-1,1]:
		for i in range(3):
			var fence := A.place(self,"nature","fence_planksDouble",Vector3(side*(5.2+i*1.9),0,10),1.0)
			A.style(fence)
			A.solid(fence)

func configure_inputs() -> void:
	var bindings := {"move_left":KEY_A,"move_right":KEY_D,"move_up":KEY_W,"move_down":KEY_S,"jog":KEY_SHIFT,"interact":KEY_E}
	for action in bindings:
		if not InputMap.has_action(action):
			InputMap.add_action(action)
			var key := InputEventKey.new()
			key.physical_keycode = bindings[action]
			InputMap.action_add_event(action,key)

func build_ground() -> void:
	# Broad foreground narrows into a quiet S curve ending at the porch ramp.
	var st := SurfaceTool.new()
	st.begin(Mesh.PRIMITIVE_TRIANGLES)
	var edges: Array[Vector3] = []
	for i in range(73):
		var z := 2.4+i*0.3
		var center := ClearingLayout.path_center(z)
		var width := ClearingLayout.path_half_width(z)+sin(i*1.7)*0.035
		edges.append(Vector3(center-width,0.045,z))
		edges.append(Vector3(center+width,0.045,z))
	for i in range(72):
		var a := i*2
		for index in [a,a+1,a+2,a+1,a+3,a+2]:
			st.add_vertex(edges[index])
	st.generate_normals()
	S.mesh(self,st.commit(),Vector3.ZERO,PALETTE.path.to_html()).cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	# Low faceted rises frame the clearing without changing the playable center.
	for item in [Vector3(-17,0,-12),Vector3(14,0,-14),Vector3(-19,0,11),Vector3(19,0,4)]:
		var shape := SphereMesh.new()
		shape.radial_segments = 12
		shape.rings = 5
		var hill := S.mesh(self,shape,item-Vector3.UP*0.6,"869165")
		hill.scale = Vector3(8,2.0,6)
		hill.create_trimesh_collision()
	# Single-surface organic meadow patches avoid thin, overlapping cylinder caps.
	var patch_centers := [Vector3(-7,0,3),Vector3(-8,0,7),Vector3(7,0,0),Vector3(8,0,4),Vector3(-9,0,16),Vector3(5,0,14),Vector3(10,0,18),Vector3(13,0,10)]
	for i in range(patch_centers.size()):
		var center: Vector3 = patch_centers[i]+Vector3.UP*(0.01+i*0.0015)
		var patch := SurfaceTool.new()
		patch.begin(Mesh.PRIMITIVE_TRIANGLES)
		for j in range(11):
			var angle := j*TAU/11
			var next := (j+1)*TAU/11
			var r := 2.4+sin(j*2.2+i)*0.35
			var r_next := 2.4+sin((j+1)*2.2+i)*0.35
			patch.set_normal(Vector3.UP)
			patch.add_vertex(Vector3.ZERO)
			patch.add_vertex(Vector3(cos(angle)*r,0,sin(angle)*r*1.3))
			patch.add_vertex(Vector3(cos(next)*r_next,0,sin(next)*r_next*1.3))
		var n := S.mesh(self,patch.commit(),center,"879267" if i%2 else "75845B")
		n.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF

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
