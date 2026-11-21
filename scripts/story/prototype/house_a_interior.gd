extends Node3D

const S = preload("res://scripts/world/shapes.gd")
const USE = preload("res://scripts/story/prototype/interaction.gd")
const SURFACE = preload("res://shaders/house_a_surface.gdshader")
const BOTANY = preload("res://scripts/world/a1_botany.gd")
const WAKE := Vector3(-2.60,.04,-1.16)
const ENTRY := Vector3(-.42,.04,2.93)
const WIDTH := 9.18
const DEPTH := 7.56
const H := 3.0
const LIMESTONE := "B49B79"
const OAK := "875B3E"
const TRIM := "563722"
var camera: Camera3D
var window_light: OmniLight3D
var sky_light: DirectionalLight3D
var environment: Environment
var rain: GPUParticles3D
var snow: MeshInstance3D
var targets: Dictionary = {}
var palette: Dictionary = {}
var lamps: Array[OmniLight3D] = []
var casement: Node3D
var drawer: Node3D
var door: Node3D
var stage: Node3D
var lights_on := true
var window_open := false
var drawer_open := false
var window_trees: Array[Node3D] = []
var window_season := -1

func setup(owner_stage: Node3D, on_exit: Callable) -> void:
	stage = owner_stage
	build_room()
	build_furniture()
	build_window_view()
	lighting()
	point("bed_01","Vuốt phẳng chăn",Vector3(-3.28,.67,-1.73),.78,make_bed)
	point("table_01","Bật / tắt đèn bàn",Vector3(2.20,.92,1.0),.69,toggle_lamp)
	point("window_01","Mở cửa sổ",Vector3(.37,1.51,-3.70),.55,toggle_window)
	point("kitchen_counter_01","Mở ngăn bếp",Vector3(3.47,.68,-2.48),.53,toggle_drawer)
	point("front_door","Mở cửa ra sân",Vector3(-.42,1.22,3.65),.47,on_exit)
	camera = Camera3D.new()
	camera.name = "RoomCamera"
	camera.near = .045
	camera.far = 32.0
	camera.environment = environment
	add_child(camera)
	camera.make_current()

func point(id: String, label: String, focus: Vector3, radius: float, command: Callable) -> void:
	var target := USE.new()
	target.name = id
	target.position = Vector3(focus.x,0,focus.z)
	target.set_meta("focus_at",Vector3.UP*focus.y)
	target.set_meta("focus_radius",radius)
	target.interaction_name = label
	target.interaction_radius = 1.65
	target.action = command
	add_child(target)
	targets[id] = target

func surface(color: String, finish: int, vertical: bool) -> ShaderMaterial:
	var key := "%s/%d/%s" % [color,finish,vertical]
	if not palette.has(key):
		var material := ShaderMaterial.new()
		material.shader = SURFACE
		material.set_shader_parameter("tint",Color(color))
		material.set_shader_parameter("finish",finish)
		material.set_shader_parameter("vertical",vertical)
		palette[key] = material
	return palette[key]

func box(at: Vector3, size: Vector3, color: String, solid := false, finish := 0, vertical := false) -> MeshInstance3D:
	var mesh := S.box(self,at,size,color,solid)
	mesh.material_override = surface(color,finish,vertical)
	return mesh

func build_room() -> void:
	box(Vector3(0,-.13,0),Vector3(WIDTH,.26,DEPTH),"74523B",true)
	for i in 23:
		var x := (i-11)*.394
		for row in 3:
			box(Vector3(x,-.016,-2.5+row*2.5),Vector3(.388,.032,2.489),["7D5437","906244","885A3C","765235"][posmod(i+row*7,4)])
	box(Vector3(0,H+.19,0),Vector3(WIDTH,.16,DEPTH),"593A27",true)
	for i in 21:
		box(Vector3((i-10)*.434,H+.093,0),Vector3(.423,.11,DEPTH),["6A452B","785037","654128"][i%3])
	for z in [-3.62,-2.10,-.61,.90,2.40,3.66]:
		box(Vector3(0,H-.035,z),Vector3(WIDTH,.29,.19),TRIM)
	for side in [-1,1]:
		var x: float = side*WIDTH*.5
		box(Vector3(x,1.52,0),Vector3(.18,3.04,DEPTH),LIMESTONE,true,1)
		box(Vector3(x*.978,.10,0),Vector3(.08,.16,DEPTH),TRIM)
		for z in [-3.63,-1.15,1.35,3.60]:
			box(Vector3(x*.974,1.51,z),Vector3(.18,3.01,.16),TRIM,false,0,true)
	var front := DEPTH*.5
	for span in [[-4.59,-1.12],[.31,4.59]]:
		box(Vector3((span[0]+span[1])*.5,1.51,front),Vector3(span[1]-span[0],3.02,.19),LIMESTONE,true,1)
	box(Vector3(-.405,2.66,front),Vector3(1.43,.74,.19),LIMESTONE,true,1)
	box(Vector3(-.40,1.12,front+.03),Vector3(1.40,2.24,.14),TRIM,true).hide()
	door = Node3D.new()
	door.position = Vector3(-1.09,0,front-.055)
	add_child(door)
	for i in 7:
		var plank := S.box(door,Vector3(.10+i*.185,1.125,0),Vector3(.18,2.24,.096),OAK)
		plank.material_override = surface(["68432B","805435","755035"][i%3],0,true)
	for level in [.42,1.71]:
		S.box(door,Vector3(.66,level,-.067),Vector3(1.25,.103,.073),"45392F")
	S.box(door,Vector3(1.12,1.13,-.129),Vector3(.113,.068,.105),"B99358")
	for side in [-1,1]:
		box(Vector3(-.40+side*.735,1.153,front-.12),Vector3(.13,2.31,.23),TRIM,false,0,true)
	box(Vector3(-.4,2.28,front-.10),Vector3(1.57,.17,.24),TRIM)
	var left := -4.59
	for x in [-2.84,.37,3.03]:
		var right: float = x-.70
		box(Vector3((right+left)*.5,1.52,-front),Vector3(right-left,3.04,.18),LIMESTONE,true,1)
		make_window(float(x),-front,x==.37)
		left = x+.70
	box(Vector3((left+4.59)*.5,1.52,-front),Vector3(4.59-left,3.04,.18),LIMESTONE,true,1)
	# Recessed bedroom wall, with an open 1.30 m doorway at the end of the hall.
	box(Vector3(-1.77,1.43,-2.97),Vector3(.18,2.86,1.62),LIMESTONE,true,1)
	box(Vector3(-1.77,1.43,-.38),Vector3(.18,2.86,.94),LIMESTONE,true,1)
	box(Vector3(-3.19,1.43,.10),Vector3(2.86,2.86,.14),LIMESTONE,true,1)
	for z in [-2.11,-.89,.10]:
		box(Vector3(-1.77,1.43,z),Vector3(.22,2.88,.16),TRIM,false,0,true)
	box(Vector3(-1.77,2.48,-1.50),Vector3(.26,.18,1.30),TRIM)
	box(Vector3(1.31,1.52,-3.38),Vector3(.18,3.04,.78),TRIM,true,0,true)

func make_window(x: float, z: float, opens: bool) -> void:
	box(Vector3(x,.52,z),Vector3(1.40,1.04,.18),LIMESTONE,true,1)
	box(Vector3(x,2.66,z),Vector3(1.40,.76,.18),LIMESTONE,true,1)
	box(Vector3(x,1.02,z+.10),Vector3(1.57,.12,.39),OAK)
	box(Vector3(x,2.28,z+.07),Vector3(1.57,.13,.22),TRIM)
	var sash := Node3D.new()
	sash.position = Vector3(x-.65,1.03,z+.07)
	add_child(sash)
	for dx in [0.0,.65,1.30]:
		S.box(sash,Vector3(dx,.63,0),Vector3(.052,1.22,.090),TRIM)
	for y in [.035,.61,1.22]:
		S.box(sash,Vector3(.65,y,0),Vector3(1.35,.048,.080),TRIM)
	if opens:
		casement = sash
	else:
		box(Vector3(x,1.63,z-.06),Vector3(1.40,1.16,.06),"FFFFFF",true).hide()
	for side in [-1,1]:
		for i in 4:
			var offset: float = side*(.62+i*.07)
			box(Vector3(x+offset,1.80,z+.16+i%2*.043),Vector3(.066,.93,.09),["BBA784","AE9674"][i%2],false,2)

func table(at: Vector3, width: float, depth: float) -> void:
	box(at+Vector3.UP*.37,Vector3(width-.06,.74,depth-.08),"FFFFFF",true).hide()
	box(at+Vector3.UP*.77,Vector3(width,.11,depth),OAK)
	for x in [-1.0,1.0]:
		for z in [-1.0,1.0]:
			box(at+Vector3(x*(width*.5-.14),.36,z*(depth*.5-.11)),Vector3(.115,.72,.115),TRIM,false,0,true)

func crock(at: Vector3, size: float, color: String) -> void:
	var jar := CylinderMesh.new()
	jar.top_radius = size*.38
	jar.bottom_radius = size*.49
	jar.height = size
	jar.radial_segments = 12
	S.mesh(self,jar,at,color)
	box(at+Vector3.UP*(size*.49),Vector3(size*.56,.038,size*.56),"685145",false,2)

func build_furniture() -> void:
	box(Vector3(-3.53,.26,-1.86),Vector3(1.50,.52,2.25),OAK,true)
	box(Vector3(-3.53,.65,-2.94),Vector3(1.53,1.02,.15),TRIM)
	box(Vector3(-3.53,.57,-1.86),Vector3(1.42,.19,2.13),"CBB897",false,2)
	var duvet := box(Vector3(-3.53,.68,-1.61),Vector3(1.42,.12,1.49),"60775F",false,2)
	duvet.name = "Duvet"
	duvet.rotation.y = .04
	box(Vector3(-3.53,.73,-2.55),Vector3(.88,.15,.43),"E0CCAB",false,2)
	for i in 5:
		box(Vector3(-3.53,.744,-1.30+i*.10),Vector3(1.40,.016,.036),"A79C69",false,2)
	box(Vector3(-2.37,.33,-3.22),Vector3(.67,.66,.62),TRIM,true)
	crock(Vector3(-2.45,.76,-3.25),.16,"B7A587")
	box(Vector3(-4.25,.81,-.69),Vector3(.55,1.62,1.18),"765338",true,0,true)
	for z in [-.99,-.43]:
		box(Vector3(-3.96,.89,z),Vector3(.09,1.42,.47),OAK,false,0,true)
		S.box(self,Vector3(-3.895,.83,z),Vector3(.063,.105,.041),"B99058")
	var dining := Vector3(2.22,0,1.13)
	table(dining,1.68,.91)
	box(dining+Vector3(.02,.834,.03),Vector3(.77,.022,.99),"D3BE9A",false,2)
	for at in [dining+Vector3(0,0,.85),dining+Vector3(0,0,-.83)]:
		box(at+Vector3.UP*.21,Vector3(.45,.42,.43),OAK,true)
		box(at+Vector3(0,.67,.15 if at.z>dining.z else -.15),Vector3(.45,.59,.10),TRIM,false,0,true)
	crock(dining+Vector3(-.45,.93,.19),.20,"876A4B")
	crock(dining+Vector3(.35,.90,-.08),.13,"687D6C")
	box(dining+Vector3(.08,.90,.07),Vector3(.19,.105,.18),"D0A55E",false,2)
	box(Vector3(4.03,.46,-2.55),Vector3(.88,.92,1.93),OAK,true)
	box(Vector3(4.04,.944,-2.55),Vector3(.98,.095,2.01),"93826D",false,2)
	drawer = Node3D.new()
	drawer.position = Vector3(3.56,.69,-2.48)
	add_child(drawer)
	S.box(drawer,Vector3(.02,0,0),Vector3(.23,.25,.68),"794C30")
	S.box(drawer,Vector3(-.10,0,0),Vector3(.07,.12,.10),"AF8B54")
	box(Vector3(4.02,.997,-3.04),Vector3(.67,.04,.57),"444F4E",false,2)
	for i in 3:
		box(Vector3(4.27,1.47+i*.43,-2.58),Vector3(.42,.083,1.68),TRIM)
		for j in 3:
			crock(Vector3(4.23,1.60+i*.43,-3.04+j*.43),.12+float((i+j)%3)*.052,["BEAA83","8E9279","987259"][(i+j)%3])
	# Hearth and bench occupy the west side of the common room, away from the entry line.
	box(Vector3(-4.05,.15,1.73),Vector3(1.04,.30,1.48),"7C7666",true,2)
	for n in 5:
		for z in [1.21,2.24]:
			box(Vector3(-4.18,.36+n*.195,z),Vector3(.57,.185,.32),["786D5D","8F7F68","746A5F"][n%3],false,2)
	box(Vector3(-4.34,1.23,1.73),Vector3(.60,.22,1.62),"86735C",false,2)
	box(Vector3(-4.34,2.01,1.73),Vector3(.50,1.35,1.12),"786955",false,2)
	for i in 4:
		box(Vector3(-4.28,.38,1.39+i*.22),Vector3(.38,.115,.18),"764628")
	box(Vector3(-4.10,.52,1.72),Vector3(.22,.05,.27),"AB5C38",false,2)
	box(Vector3(-3.89,.52,3.01),Vector3(1.13,1.04,.40),"725235",true)
	for i in 4:
		box(Vector3(-3.89,.24+i*.25,2.78),Vector3(1.13,.069,.18),TRIM)
		crock(Vector3(-3.98,.335+i*.25,2.76),.15,"A28B65")
	box(Vector3(-2.89,.31,3.13),Vector3(.49,.62,.59),"856349",true)
	box(Vector3(-2.90,.63,3.13),Vector3(.50,.074,.60),"795239")
	box(Vector3(-1.41,.014,1.59),Vector3(2.56,.028,1.77),"717554",false,2)
	for offset in [-.76,-.67,.67,.76]:
		box(Vector3(-1.41,.031,1.59+offset),Vector3(2.49,.009,.039),"AF9062",false,2)

func build_window_view() -> void:
	box(Vector3(0,-.41,-10),Vector3(26,.56,14),"596F43",false,1)
	snow = box(Vector3(0,-.118,-9.5),Vector3(26,.014,14),"CDDCE0",false,1)
	var grove := [["BirchTree_2",-3.8,-7.6,7.2],["NormalTree_3",2.9,-8.9,7.2],["PineTree_2",-1.6,-11.9,8.9],
		["NormalTree_4",5.5,-12.8,7.1],["PineTree_3",-5.2,-14.7,10.0],["BirchTree_3",.85,-16.3,8.1]]
	for spec in grove:
		var tree := BOTANY.place_tree(self,spec[0],Vector3(spec[1],-.13,spec[2]),spec[3],float(spec[1]))
		window_trees.append(tree)
	for spot in [Vector3(-2,-.13,-6.0),Vector3(2.9,-.13,-6.7),Vector3(4.3,-.13,-9.3),Vector3(-4.4,-.13,-8.9)]:
		BOTANY.place(self,"Bush_Large",spot,.82,spot.x)
		BOTANY.place_stone(self,spot+Vector3(.73,-.05,.24),.52,spot.x)
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

func lamp(at: Vector3, reach: float, energy: float) -> void:
	var fixture := OmniLight3D.new()
	fixture.position = at
	fixture.omni_range = reach
	fixture.light_color = Color("FFD495")
	fixture.light_energy = energy
	add_child(fixture)
	lamps.append(fixture)

func lighting() -> void:
	environment = Environment.new()
	environment.background_mode = Environment.BG_COLOR
	environment.ambient_light_source = Environment.AMBIENT_SOURCE_COLOR
	environment.ambient_light_color = Color("CBBEAA")
	environment.tonemap_mode = Environment.TONE_MAPPER_FILMIC
	sky_light = DirectionalLight3D.new()
	sky_light.rotation_degrees = Vector3(-25,161,0)
	sky_light.light_color = Color("FAE5BD")
	sky_light.shadow_enabled = true
	sky_light.directional_shadow_max_distance = 21.0
	add_child(sky_light)
	window_light = OmniLight3D.new()
	window_light.position = Vector3(.50,1.87,-3.28)
	window_light.omni_range = 6.2
	window_light.light_color = Color("F6DFB9")
	add_child(window_light)
	lamp(Vector3(2.12,1.11,.95),4.6,1.22)
	lamp(Vector3(-3.83,.84,1.76),4.3,.78)
	lamp(Vector3(-2.45,.98,-3.20),3.6,.50)

func update_climate(hour: float, wet: float, season: int) -> void:
	var daylight := smoothstep(0.0,.44,sin((hour-6.0)*TAU/24.0))
	environment.background_color = Color("243345").lerp(Color("9DAEB3"),daylight*(1.0-wet*.34))
	environment.ambient_light_energy = .29+daylight*.37
	sky_light.light_energy = .13+daylight*.8*(1.0-wet*.61)
	window_light.light_energy = .16+daylight*.58*(1.0-wet*.47)
	rain.emitting = wet>.14
	snow.visible = season==3
	if window_season!=season:
		window_season = season
		for tree in window_trees:
			BOTANY.season_tree(tree,season)

func toggle_window() -> void:
	window_open = not window_open
	targets.window_01.interaction_name = "Khép cửa sổ" if window_open else "Mở cửa sổ"
	stage.session.object_state("window_01","open" if window_open else "closed")
	create_tween().tween_property(casement,"rotation:y",1.23 if window_open else 0.0,.32)
	stage.sound("door",targets.window_01.position+Vector3.UP*1.4,self)

func toggle_drawer() -> void:
	drawer_open = not drawer_open
	targets.kitchen_counter_01.interaction_name = "Đóng ngăn bếp" if drawer_open else "Mở ngăn bếp"
	stage.session.object_state("kitchen_counter_01","open" if drawer_open else "closed")
	create_tween().tween_property(drawer,"position:x",3.14 if drawer_open else 3.56,.24)
	stage.sound("door",drawer.position,self)

func toggle_lamp() -> void:
	lights_on = not lights_on
	lamps[0].visible = lights_on
	stage.session.object_state("table_01","lamp_on" if lights_on else "lamp_off")
	targets.table_01.interaction_name = "Tắt đèn bàn" if lights_on else "Bật đèn bàn"
	stage.sound("tap",targets.table_01.position+Vector3.UP,self)

func make_bed() -> void:
	if stage.session.objects.get("bed_01")=="made":
		return
	create_tween().tween_property(get_node("Duvet"),"rotation:y",0.0,.25)
	stage.session.object_state("bed_01","made")
	stage.session.flag("ch01_bed_seen")
	targets.bed_01.set_available(false)
