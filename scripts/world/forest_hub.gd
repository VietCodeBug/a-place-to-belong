extends Node3D
const S = preload("res://scripts/world/shapes.gd")
var player: CharacterBody3D
var mailbox: Node3D
var ui: CanvasLayer
const PALETTE = preload("res://assets/palettes/early_autumn.tres")

func _ready() -> void:
	configure_inputs()
	var environment := WorldEnvironment.new()
	var settings := Environment.new()
	settings.background_mode = Environment.BG_COLOR
	settings.background_color = PALETTE.haze
	settings.ambient_light_source = Environment.AMBIENT_SOURCE_COLOR
	settings.ambient_light_color = Color("DBDFD2")
	settings.ambient_light_energy = 0.5
	settings.fog_enabled = true
	settings.fog_light_color = Color("AFBFC0")
	settings.fog_light_energy = 0.45
	settings.fog_mode = Environment.FOG_MODE_DEPTH
	settings.fog_depth_begin = 42.0
	settings.fog_depth_end = 170.0
	settings.fog_depth_curve = 1.4
	settings.tonemap_mode = Environment.TONE_MAPPER_LINEAR
	environment.environment = settings
	add_child(environment)
	var sun := DirectionalLight3D.new()
	sun.rotation_degrees = Vector3(-44,-30,0)
	sun.light_color = Color("FFE0B9")
	sun.light_energy = 0.6
	sun.directional_shadow_max_distance = 65
	sun.shadow_blur = 2.0
	sun.shadow_normal_bias = 2.0
	sun.shadow_bias = 0.12
	sun.light_angular_distance = 2.5
	sun.shadow_enabled = true
	add_child(sun)
	# A low-energy, shadowless back light catches the roof edge without extra shadow maps.
	var rim := DirectionalLight3D.new()
	rim.rotation_degrees = Vector3(-24,145,0)
	rim.light_color = Color("FFE7C2")
	rim.light_energy = 0.16
	add_child(rim)
	S.box(self,Vector3(0,-0.3,0),Vector3(48,0.6,48),PALETTE.ground.to_html(),true)
	S.box(self,Vector3(0,-0.85,-10),Vector3(500,0.6,500),"7B896C")
	build_ground()
	var woods := Node3D.new()
	woods.name = "EarlyAutumnWoodland"
	woods.set_script(preload("res://scripts/world/woodland.gd"))
	add_child(woods)
	build_cafe()
	mailbox = preload("res://scenes/props/mailbox.tscn").instantiate()
	mailbox.name = "Mailbox"
	add_child(mailbox)
	mailbox.position = Vector3(3.6,0,3.5)
	build_bicycle(Vector3(-3.8,0,2.7))
	build_bench(Vector3(-6.6,0,-0.2))
	S.cone(self,Vector3(-6.6,0.75,1),0.85,0.14,"B88254",0.85)
	S.box(self,Vector3(-6.6,0.35,1),Vector3(0.2,0.7,0.2),"92633F",true)
	S.cone(self,Vector3(-6.6,0.93,1),0.12,0.22,"F6E8D0",0.14)
	S.box(self,Vector3(6,0.8,6),Vector3(0.15,1.6,0.15),"B88254",true)
	var direction_board := S.box(self,Vector3(6,1.5,6),Vector3(1.5,0.4,0.15),"B88254")
	direction_board.rotation.z = 0.06
	S.box(self,Vector3(6,1.5,6.09),Vector3(1.3,0.27,0.035),"496B59")
	S.box(self,Vector3(5.7,1.5,6.12),Vector3(0.32,0.19,0.02),"F6E8D0")
	S.beam(self,Vector3(5.54,1.59,6.14),Vector3(5.7,1.48,6.14),0.02,"92633F")
	S.beam(self,Vector3(5.7,1.48,6.14),Vector3(5.86,1.59,6.14),0.02,"92633F")
	S.beam(self,Vector3(6.35,1.5,6.14),Vector3(6.1,1.5,6.14),0.035,"E9D4A1")
	S.beam(self,Vector3(6.1,1.5,6.14),Vector3(6.2,1.6,6.14),0.035,"E9D4A1")
	S.beam(self,Vector3(6.1,1.5,6.14),Vector3(6.2,1.4,6.14),0.035,"E9D4A1")
	for x in [-4.5,4.5]:
		S.cone(self,Vector3(x,0.3,1.5),0.38,0.6,"C87760",0.48)
		for j in range(5):
			flower(Vector3(x+(j-2)*0.12,0.55,1.5+sin(j)*0.2))
	# Solid trunks and terrain perimeter keep the hub bounded.
	for p in [Vector3(-24,1,0),Vector3(24,1,0)]:
		S.box(self,p,Vector3(0.5,3,48),"496B59",true).visible = false
	for z in [-24,24]:
		S.box(self,Vector3(0,1,z),Vector3(48,3,0.5),"496B59",true).visible = false
	for i in range(9):
		S.cone(self,Vector3(-45+i*12,-2,-47),13,16+(i%3)*4,"9DAFA5")
	decorate_cafe()
	build_fences()
	compose_vignettes()
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

func decorate_cafe() -> void:
	var cafe: Node3D = $Cafe
	# Chimney, ridge tiles, and a sloping porch canopy preserve the original gable.
	S.box(cafe,Vector3(-2,4.8,-4),Vector3(0.65,2,0.65),"9D8268")
	S.box(cafe,Vector3(-2,5.85,-4),Vector3(0.85,0.18,0.85),"715F50")
	for i in range(12):
		S.box(cafe,Vector3(0,5.57,-6.35+i*0.6),Vector3(0.38,0.16,0.45),"BD8061")
	var awning := S.box(cafe,Vector3(0,3.08,0.7),Vector3(8.8,0.16,1.9),"637C60")
	awning.rotation.x = 0.13
	S.box(cafe,Vector3(0,2.95,1.65),Vector3(8.8,0.2,0.18),"92633F")
	for x in [-4.1,4.1]:
		S.box(cafe,Vector3(x,1.55,1.85),Vector3(0.18,2.5,0.18),"92633F",true)
		S.beam(cafe,Vector3(x,2.15,1.85),Vector3(x*0.82,2.75,1.85),0.12,"B88254")
	for x in [-2.5,2.5]:
		# Flower boxes beneath warm windows.
		S.box(cafe,Vector3(x,1.04,0.45),Vector3(1.9,0.28,0.48),"92633F")
		for j in range(7):
			var p := Vector3(x-0.72+j*0.24,1.18,0.45)
			S.cone(cafe,p,0.18,0.3,"6C865A",0.07)
			S.cone(cafe,p+Vector3.UP*0.22,0.13,0.12,"E9D4A1" if j%2 else "C78D69",0.06)
		# Warm window material, restrained emission rather than extra shadow lights.
		var glass := S.material("F4D5A0").duplicate()
		glass.emission_enabled = true
		glass.emission = Color("D29A53")
		glass.emission_energy_multiplier = 0.25
		var pane := S.box(cafe,Vector3(x,1.8,0.245),Vector3(1.45,1.15,0.02),"F4D5A0")
		pane.material_override = glass
	for x in [-1.0,1.0]:
		S.beam(cafe,Vector3(x,2.7,1),Vector3(x,2.25,1),0.035,"574C3C")
		S.box(cafe,Vector3(x,2.19,1),Vector3(0.25,0.08,0.25),"574C3C")
		var lamp := S.box(cafe,Vector3(x,2.35,1),Vector3(0.17,0.25,0.17),"F8D99F")
		var glow := S.material("F8D99F").duplicate()
		glow.emission_enabled = true
		glow.emission = Color("F8CA82")
		lamp.material_override = glow
		S.box(cafe,Vector3(x,2.52,1),Vector3(0.28,0.07,0.28),"574C3C")
	# Timber framing and a side window give the camera-facing wall a lived-in silhouette.
	for z in [-5.8,-3.0,-0.2]:
		S.box(cafe,Vector3(4.06,1.6,z),Vector3(0.14,3.2,0.14),"92633F")
	S.box(cafe,Vector3(4.1,1.85,-3),Vector3(0.18,1.5,1.75),"659A98")
	S.box(cafe,Vector3(4.21,1.85,-3),Vector3(0.035,1.23,1.47),"E7C890")
	S.box(cafe,Vector3(4.24,1.85,-3),Vector3(0.04,1.32,0.08),"659A98")
	S.box(cafe,Vector3(4.24,1.85,-3),Vector3(0.04,0.08,1.55),"659A98")
	S.box(cafe,Vector3(4.25,0.99,-3),Vector3(0.4,0.28,1.8),"92633F")
	for j in range(6):
		S.cone(cafe,Vector3(4.25,1.21,-3.65+j*0.25),0.21,0.32,"8C9563",0.05)
		S.cone(cafe,Vector3(4.25,1.42,-3.65+j*0.25),0.11,0.1,"E9D4A1",0.04)
	# Hanging botanical baskets on the outer ends of the canopy.
	for x in [-3.5,3.5]:
		S.beam(cafe,Vector3(x,2.9,1.8),Vector3(x,2.25,1.8),0.035,"574C3C")
		S.cone(cafe,Vector3(x,2.13,1.8),0.2,0.3,"B88254",0.33)
		for j in range(5):
			S.cone(cafe,Vector3(x+cos(j*1.3)*0.24,2.27,1.8+sin(j*1.3)*0.24),0.21,0.3,"8C9563",0.05)
	# Freestanding café menu, parcels and envelope-shaped postal plaque.
	var menu := Node3D.new()
	add_child(menu)
	menu.position = Vector3(-4.8,0,3.3)
	menu.rotation.y = -0.2
	S.box(menu,Vector3(0,0.9,0),Vector3(0.9,1.1,0.12),"B88254",true)
	S.box(menu,Vector3(0,0.9,0.07),Vector3(0.71,0.88,0.03),"354E44")
	for side in [-1,1]:
		S.beam(menu,Vector3(side*0.38,0,0.3),Vector3(side*0.38,1.4,0),0.08,"92633F")
	for i in range(3):
		S.box(menu,Vector3(-0.04,1.02-i*0.17,0.095),Vector3(0.45-i*0.07,0.025,0.01),"D9C9A6")
	S.box(cafe,Vector3(-1.25,0.56,0.55),Vector3(0.7,0.5,0.55),"C6A47B")
	S.box(cafe,Vector3(-1.25,0.82,0.55),Vector3(0.13,0.02,0.56),"E2CAA4")
	S.box(cafe,Vector3(-1.35,0.94,0.55),Vector3(0.45,0.24,0.4),"B49168")
	S.box(cafe,Vector3(0,3.85,0.04),Vector3(1.1,0.62,0.12),"F6E8D0")
	S.beam(cafe,Vector3(-0.5,4.1,0.12),Vector3(0,3.8,0.12),0.035,"B88254")
	S.beam(cafe,Vector3(0,3.8,0.12),Vector3(0.5,4.1,0.12),0.035,"B88254")

func build_fences() -> void:
	# Short fence arcs guide toward the clearing rather than boxing in the player.
	for side in [-1,1]:
		for i in range(4):
			var x: float = side*(5.3+i*1.45)
			var z := 9.5+sin(i*0.65)*0.9
			S.box(self,Vector3(x,0.64,z),Vector3(0.14,1.28,0.14),"9E805B",true)
			if i < 3:
				for y in [0.45,0.98]:
					S.beam(self,Vector3(x,y,z),Vector3(x+side*1.45,y,9.5+sin((i+1)*0.65)*0.9),0.09,"B49A70")

func compose_vignettes() -> void:
	# Postal loading corner: mailbox + sorting shelf + tied sacks/stacked crates.
	var postal := Node3D.new()
	postal.name = "PostalLoadingCorner"
	add_child(postal)
	postal.position = Vector3(5.2,0,1.8)
	S.box(postal,Vector3(0,0.72,0),Vector3(1.3,0.14,0.65),"92633F",true)
	for x in [-0.5,0.5]:
		S.box(postal,Vector3(x,0.35,0),Vector3(0.12,0.7,0.5),"92633F",true)
	for i in range(3):
		S.box(postal,Vector3(-0.32+i*0.28,0.84+i*0.025,0),Vector3(0.35,0.05,0.27),"F6E8D0")
	for i in range(2):
		var p := Vector3(0.8+i*0.55,0.35,0.35)
		S.cone(postal,p,0.27,0.7,"B9A181",0.16)
		S.cone(postal,p+Vector3.UP*0.39,0.12,0.13,"7B6951",0.08)
	S.cone(self,Vector3(-6.6,0.025,1),2.0,0.02,"989C83",2.0).cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	# Two chairs face a shared table, sheltered by a crescent flower bed.
	for p in [Vector3(-7.4,0,2.4),Vector3(-5.8,0,2.4)]:
		S.box(self,p+Vector3.UP*0.5,Vector3(0.55,0.12,0.55),"B88254",true)
		S.box(self,p+Vector3(0,0.9,0.22),Vector3(0.55,0.65,0.1),"92633F")
		for x in [-0.2,0.2]:
			S.box(self,p+Vector3(x,0.24,0),Vector3(0.08,0.48,0.45),"92633F")
	# Foreground root/stump vignette occupies the lower right, away from the path.
	var stump := Vector3(8,0,12)
	S.cone(self,stump+Vector3.UP*0.45,0.62,0.9,"75624D",0.48)
	S.cone(self,stump+Vector3.UP*0.91,0.44,0.025,"C1A77F",0.44)
	for i in range(4):
		var a := i*TAU/4
		S.beam(self,stump+Vector3.UP*0.35,stump+Vector3(cos(a),0.08,sin(a))*1.1,0.18,"75624D")
	# Flat inset stepping details near the entrance; decorative, no movement obstacle.
	for i in range(4):
		var z := 2.8+i*0.45
		var n := S.box(self,Vector3(ClearingLayout.path_center(z),0.057,z),Vector3(0.6,0.02,0.25),"B9B19A")
		n.rotation.y = sin(i*2.1)*0.12
