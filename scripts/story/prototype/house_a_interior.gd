extends Node3D

const S = preload("res://scripts/world/shapes.gd")
const USE = preload("res://scripts/story/prototype/interaction.gd")
const WAKE := Vector3(-1.32,.04,-1.63)
const ENTRY := Vector3(-.45,.04,2.25)
const WALL := "9B846D"
const OAK := "74513C"
const TRIM := "503B2E"
var camera: Camera3D
var window_light: OmniLight3D
var sky_light: DirectionalLight3D
var environment: Environment
var rain: GPUParticles3D
var snow: MeshInstance3D
var targets: Dictionary = {}

func setup(on_inspect: Callable, on_exit: Callable) -> void:
	build_room()
	build_furniture()
	build_window_view()
	lighting()
	point("bed_01","Nhìn chiếc giường",Vector3(-1.61,0,-1.60),1.08,on_inspect.bind("bed_01"))
	point("table_01","Quan sát chiếc bàn",Vector3(.62,0,.66),1.16,on_inspect.bind("table_01"))
	point("window_01","Nhìn ra cửa sổ",Vector3(-.27,0,-2.42),1.06,on_inspect.bind("window_01"))
	point("kitchen_counter_01","Quan sát góc bếp",Vector3(1.90,0,-1.94),1.05,on_inspect.bind("kitchen_counter_01"))
	point("front_door","Bước ra ngoài",Vector3(-.44,0,2.67),1.15,on_exit)
	camera = Camera3D.new()
	camera.name = "RoomCamera"
	camera.fov = 65.0
	camera.near = .08
	camera.far = 34.0
	camera.environment = environment
	add_child(camera)
	camera.make_current()

func point(id: String, label: String, at: Vector3, reach: float, command: Callable) -> void:
	var target := USE.new()
	target.name = id
	target.position = at
	target.interaction_name = label
	target.interaction_radius = reach
	target.action = command
	add_child(target)
	targets[id] = target

func build_room() -> void:
	S.box(self,Vector3(0,-.14,0),Vector3(6.84,.28,6.0),"6D513A",true)
	for i in 15:
		var x := (i-7)*.448
		S.box(self,Vector3(x,-.014,0),Vector3(.444,.028,5.96),["806247","927457","86684D","76573F"][i%4])
	S.box(self,Vector3(0,2.94,0),Vector3(6.9,.16,6.12),"624A38",true)
	for z in [-2.62,-1.51,-.38,.75,1.88,2.82]:
		S.box(self,Vector3(0,2.80,z),Vector3(6.88,.20,.155),TRIM)
	for side in [-1,1]:
		var x: float = side*3.40
		S.box(self,Vector3(x,1.40,0),Vector3(.18,2.8,6.12),WALL,true)
		S.box(self,Vector3(x*.975,.12,0),Vector3(.08,.20,5.98),TRIM)
	S.box(self,Vector3(0,1.40,3.0),Vector3(6.74,2.8,.18),WALL,true)
	S.box(self,Vector3(-.44,1.13,2.888),Vector3(1.17,2.27,.10),TRIM)
	for i in 6:
		S.box(self,Vector3(-.897+i*.185,1.05,2.827),Vector3(.177,2.08,.075),["7B5439","805937","75503A"][i%3])
	for y in [.48,1.58]:
		S.box(self,Vector3(-.44,y,2.765),Vector3(1.05,.075,.05),"3F392D")
	S.box(self,Vector3(-.05,1.06,2.735),Vector3(.105,.085,.095),"C3A266")
	# The window consists of an actual opening in the geometry with a separate collision plane.
	for section in [[Vector3(-2.23,1.4,-3.),Vector3(2.34,2.8,.18)],[Vector3(1.97,1.4,-3.),Vector3(2.86,2.8,.18)],
		[Vector3(-.26,.49,-3.),Vector3(1.63,.98,.18)],[Vector3(-.26,2.49,-3.),Vector3(1.63,.62,.18)]]:
		S.box(self,section[0],section[1],WALL,true)
	S.box(self,Vector3(-.26,1.58,-3.05),Vector3(1.64,1.22,.10),"FFFFFF",true).hide()
	for y in [.99,1.58,2.17]:
		S.box(self,Vector3(-.26,y,-2.91),Vector3(1.73,.077,.17),TRIM)
	for x in [-1.10,-.26,.56]:
		S.box(self,Vector3(x,1.58,-2.91),Vector3(.08,1.25,.17),TRIM)
	S.box(self,Vector3(-.26,.95,-2.79),Vector3(1.89,.10,.37),OAK)
	for side in [-1,1]:
		for i in 5:
			var x: float = -.26+side*(.66+i*.066)
			S.box(self,Vector3(x,1.64,-2.74+i%2*.047),Vector3(.067,1.26,.078),["B9A174","A48A63"][i%2])
	S.box(self,Vector3(-.42,.017,2.54),Vector3(1.27,.033,.56),"8D6D45")

func build_furniture() -> void:
	S.box(self,Vector3(-2.44,.25,-1.79),Vector3(1.27,.50,2.15),OAK,true)
	S.box(self,Vector3(-2.44,.54,-2.80),Vector3(1.32,.93,.15),TRIM)
	S.box(self,Vector3(-2.45,.555,-1.77),Vector3(1.15,.18,1.97),"C5B796")
	S.box(self,Vector3(-2.45,.666,-1.49),Vector3(1.20,.10,1.32),"6B8067")
	S.box(self,Vector3(-2.45,.723,-2.45),Vector3(.82,.15,.36),"DDD0AC")
	for i in 4:
		S.box(self,Vector3(-2.45,.720,-1.43+i*.11),Vector3(1.21,.015,.041),"9B9D71")
	S.box(self,Vector3(-2.83,.27,-.42),Vector3(.52,.54,.54),OAK,true)
	S.box(self,Vector3(-2.82,.562,-.41),Vector3(.61,.06,.61),TRIM)
	S.box(self,Vector3(-2.78,.61,-.48),Vector3(.22,.04,.17),"9C7952")
	var table := Vector3(1.46,0,.77)
	S.box(self,table+Vector3.UP*.37,Vector3(1.27,.74,.86),"FFFFFF",true).hide()
	S.box(self,table+Vector3.UP*.77,Vector3(1.45,.10,1.01),OAK)
	for x in [-.55,.55]:
		for z in [-.36,.36]:
			S.box(self,table+Vector3(x,.36,z),Vector3(.12,.72,.12),TRIM)
	S.box(self,table+Vector3(-.11,.84,-.13),Vector3(.43,.045,.31),"C5AE77")
	for index in 2:
		var at := Vector3(2.53,0,.72+index*.61)
		S.box(self,at+Vector3.UP*.21,Vector3(.43,.42,.42),OAK,true)
		S.box(self,at+Vector3(.16,.55,0),Vector3(.11,.70,.42),TRIM)
	S.box(self,Vector3(2.86,.43,-1.97),Vector3(.82,.86,1.66),OAK,true)
	S.box(self,Vector3(2.86,.89,-1.97),Vector3(.90,.09,1.75),"807063")
	S.box(self,Vector3(2.88,.963,-2.40),Vector3(.62,.065,.58),"4F4F42")
	for index in 3:
		S.box(self,Vector3(2.89,1.34+index*.34,-2.82),Vector3(.80,.065,.30),TRIM)
		for side in [-1,1]:
			var crock := CylinderMesh.new()
			crock.top_radius = .087
			crock.bottom_radius = .049
			crock.height = .115
			crock.radial_segments = 10
			S.mesh(self,crock,Vector3(2.88+side*.18,1.44+index*.34,-2.76),["B3A187","89937A","C9B996"][index])
	S.box(self,Vector3(-3.14,.56,.88),Vector3(.40,1.12,.91),OAK,true)
	for y in [.24,.59,.94]:
		S.box(self,Vector3(-2.91,y,.87),Vector3(.10,.065,.84),TRIM)
		S.box(self,Vector3(-2.86,y+.11,.92),Vector3(.12,.18,.19),"9A845C")
	S.box(self,Vector3(-.32,.013,.39),Vector3(1.66,.026,1.78),"827651")
	for index in 7:
		S.box(self,Vector3(-.32,.029,-.44+index*.274),Vector3(1.62,.01,.035),"B39462")

func build_window_view() -> void:
	S.box(self,Vector3(0,-.41,-8.2),Vector3(22,.56,10.5),"596F43")
	snow = S.box(self,Vector3(0,-.118,-8.2),Vector3(22,.014,10.5),"CDDCE0")
	for at in [Vector3(-3,0,-5.7),Vector3(2.4,0,-6.7),Vector3(-1.2,0,-9.7),Vector3(5.4,0,-11.0),Vector3(-4.4,0,-12.4),Vector3(1.5,0,-14.)]:
		S.box(self,at+Vector3.UP*1.33,Vector3(.31,2.64,.29),"655540")
		for level in 3:
			var crown := CylinderMesh.new()
			crown.top_radius = .09
			crown.bottom_radius = 1.15-level*.23
			crown.height = 1.51
			crown.radial_segments = 8
			S.mesh(self,crown,at+Vector3.UP*(2.16+level*.66),["435D45","53724E","73895B"][level])
	rain = GPUParticles3D.new()
	rain.position = Vector3(0,4,-7.3)
	rain.amount = 72
	rain.lifetime = .65
	var drops := ParticleProcessMaterial.new()
	drops.emission_shape = ParticleProcessMaterial.EMISSION_SHAPE_BOX
	drops.emission_box_extents = Vector3(6,.2,3)
	drops.direction = Vector3(.10,-1,0)
	drops.spread = 6.0
	drops.initial_velocity_min = 6.2
	drops.initial_velocity_max = 8.4
	rain.process_material = drops
	var streak := BoxMesh.new()
	streak.size = Vector3(.017,.22,.017)
	streak.material = S.material("A1BCC4")
	rain.draw_pass_1 = streak
	rain.emitting = false
	add_child(rain)

func lighting() -> void:
	environment = Environment.new()
	environment.background_mode = Environment.BG_COLOR
	environment.ambient_light_source = Environment.AMBIENT_SOURCE_COLOR
	environment.ambient_light_color = Color("B7B4AD")
	environment.tonemap_mode = Environment.TONE_MAPPER_FILMIC
	sky_light = DirectionalLight3D.new()
	sky_light.rotation_degrees = Vector3(-42,-152,0)
	sky_light.light_color = Color("F8DDB5")
	sky_light.shadow_enabled = true
	sky_light.directional_shadow_max_distance = 17.0
	add_child(sky_light)
	window_light = OmniLight3D.new()
	window_light.position = Vector3(-.31,1.67,-2.59)
	window_light.omni_range = 5.5
	window_light.light_color = Color("F5DAAE")
	add_child(window_light)
	var lamp := OmniLight3D.new()
	lamp.position = Vector3(1.43,1.82,.48)
	lamp.omni_range = 5.15
	lamp.light_color = Color("FFD49A")
	lamp.light_energy = 1.38
	add_child(lamp)
	S.box(self,Vector3(1.43,1.58,.48),Vector3(.14,.13,.14),"BD8B58")
	S.box(self,Vector3(1.43,1.82,.48),Vector3(.28,.12,.28),"D4B979")

func update_climate(hour: float, wet: float, season: int) -> void:
	var daylight := smoothstep(0.0,.42,sin((hour-6.0)*TAU/24.0))
	environment.background_color = Color("243345").lerp(Color("A6B8BA"),daylight*(1.0-wet*.34))
	environment.ambient_light_energy = .42+daylight*.29
	sky_light.light_energy = .18+daylight*.48*(1.0-wet*.72)
	window_light.light_energy = .18+daylight*.66*(1.0-wet*.47)
	rain.emitting = wet>.14
	snow.visible = season==3

func follow(actor: Vector3, delta: float, instant := false) -> void:
	var eye := actor+Vector3(-1.05,2.20,2.48)
	eye.x = clampf(eye.x,-3.05,3.05)
	eye.z = clampf(eye.z,-2.77,2.71)
	var aim := actor+Vector3(0,.72,0)
	camera.position = eye if instant else camera.position.lerp(eye,1.0-exp(-11.0*delta))
	camera.look_at(aim)
