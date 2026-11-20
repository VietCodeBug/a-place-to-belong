extends Node3D

const S = preload("res://scripts/world/shapes.gd")
const A = preload("res://scripts/world/field_assets.gd")
const MEADOW = preload("res://environment/vegetation/scripts/dense_meadow.gd")
const MEADOW_AREA := Rect2(-16.0,-8.0,32.0,26.0)
const HOUSE = preload("res://assets/a1_house_gate/hewn_eaves_cottage.glb")
var walker: CharacterBody3D
var eye: Camera3D
var look := Vector2.ZERO
var rock_exclusions := PackedVector3Array()

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
	settings.ambient_light_energy = 0.50
	settings.fog_enabled = true
	settings.fog_mode = Environment.FOG_MODE_DEPTH
	settings.fog_light_color = Color("A5B4AC")
	settings.fog_sky_affect = 0.12
	settings.fog_depth_begin = 23.0
	settings.fog_depth_end = 92.0
	env.environment = settings
	add_child(env)
	var sun := DirectionalLight3D.new()
	sun.rotation_degrees = Vector3(-43,-35,0)
	sun.light_color = Color("FFDFB6")
	sun.light_energy = 0.71
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
	var ground := S.box(self, Vector3(0,-0.19,0),Vector3(92,0.38,88),"919D6F",true)
	var chalk := ShaderMaterial.new()
	chalk.shader = preload("res://shaders/a1_house_yard.gdshader")
	ground.material_override = chalk
	var plants := [Vector3(-2.7,0,3.8),Vector3(2.4,0,4.0),Vector3(3.8,0,3.5),
		Vector3(-3.7,0,2.9),Vector3(2.27,0,5.1),Vector3(-1.55,0,4.11)]
	for i in plants.size():
		var at: Vector3 = plants[i]
		A.place(self,"quaternius","Rock_Moss_1",at,0.27+i%3*0.10,i)
		for j in range(7):
			var p := at+Vector3(cos(j*2.4)*0.57,0,sin(j*2.4)*0.50)
			A.place(self,"nature","grass_leafs" if j%3 else "flower_purpleB",p,
				0.27+0.06*sin(j*3.11+i),j)
	for p in [Vector3(-9,0,-3),Vector3(-13,0,5),Vector3(9,0,-5),Vector3(15,0,-2),
			Vector3(3,0,-12),Vector3(-3,0,-9),Vector3(13,0,-12),Vector3(-13,0,-11)]:
		A.place(self,"quaternius","PineTree_3" if p.x>0 else "PineTree_2",p,7.0+absf(sin(p.x))*2.4,p.z,"sage")
	build_boulders()
	build_meadow()
	var guide := Label.new()
	guide.text = "A1  ·  House Art Gate     WASD / chuột     Esc thả chuột"
	guide.position = Vector2(20,18)
	var overlay := CanvasLayer.new()
	overlay.name = "Help"
	add_child(overlay)
	overlay.add_child(guide)
	walker = CharacterBody3D.new()
	add_child(walker)
	walker.position = Vector3(0.9,0.06,8.2)
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

func build_meadow() -> void:
	var meadow := MEADOW.new()
	meadow.name = "YardDenseMeadow"
	meadow.isolated_test = true # A1 supplies its own masks and ground plane.
	meadow.height_sampler = func(_point: Vector2) -> float: return 0.0
	meadow.normal_sampler = func(_point: Vector2) -> Vector3: return Vector3.UP
	meadow.area = MEADOW_AREA
	meadow.valid_area = MEADOW_AREA
	meadow.mask_rect = MEADOW_AREA
	meadow.settings = preload("res://environment/vegetation/presets/high.tres").duplicate()
	meadow.settings.carpet_density = 17.5
	meadow.settings.tuft_density = 6.5
	meadow.settings.accent_density = 0.9
	meadow.settings.flower_density = 0.43
	meadow.settings.render_distance = 36.0
	meadow.settings.chunk_size = 6.0
	meadow.settings.lod_begin = 6.0
	meadow.settings.lod_end = 11.5
	var mask := Image.create_empty(160,130,false,Image.FORMAT_RGBA8)
	for y in range(mask.get_height()):
		for x in range(mask.get_width()):
			var point := MEADOW_AREA.position + (Vector2(x,y)+Vector2(0.5,0.5))*0.20
			mask.set_pixel(x,y,grass_mask(point))
	meadow.exclusion_circles = rock_exclusions
	meadow.density_mask = ImageTexture.create_from_image(mask)
	add_child(meadow)

func grass_mask(point: Vector2) -> Color:
	if Rect2(-4.20,-2.95,7.77,5.96).has_point(point):
		return Color(0,0,0,0)
	if Rect2(-1.84,2.22,2.72,1.97).has_point(point):
		return Color(0,0,0,0)
	var trail := absf(point.x + 0.49 - (point.y-3.6)*0.145)
	var verge := smoothstep(0.69,1.47,trail) if point.y > 3.13 else 1.0
	var fringe := smoothstep(0.96,1.90,trail) if point.y > 3.13 else 1.0
	var distance_to_house := (point * Vector2(0.78,1.0)).length()
	var tall := smoothstep(3.55,7.7,distance_to_house)*fringe
	var patch := 0.51 + sin(point.x*0.91+point.y*0.48)*0.49
	var boundary := smoothstep(0.05,1.6,minf(16.0-absf(point.x),minf(point.y+8.0,18.0-point.y)))
	return Color(verge,tall*(0.57+patch*0.43),tall*patch,tall*pow(patch,3.0)*0.45)*boundary*lerpf(1.0,0.44,smoothstep(8.0,16.5,distance_to_house))

func build_boulders() -> void:
	var groups := [
		["LeftForestEdge", [
			["rock_largeA",Vector3(-6.4,-0.28,3.2),2.42,-0.65,Vector2(2.66,2.12)],
			["rock_largeB",Vector3(-5.25,-0.19,3.78),1.13,1.12,Vector2(1.67,1.27)],
			["rock_largeB",Vector3(-7.4,-0.10,2.32),0.73,0.38,Vector2(1.21,1.22)],
		]],
		["RightForestEdge", [
			["rock_largeB",Vector3(7.55,-0.29,3.33),2.02,0.86,Vector2(2.68,2.21)],
			["rock_largeA",Vector3(6.64,-0.16,3.92),1.12,-0.48,Vector2(1.59,1.16)],
			["rock_largeB",Vector3(8.70,-0.20,2.60),0.80,2.58,Vector2(1.22,1.01)],
		]],
		["RearForestEdge", [
			["rock_largeA",Vector3(4.9,-0.31,-5.68),3.01,1.77,Vector2(3.12,2.51)],
			["rock_largeB",Vector3(6.24,-0.14,-5.87),1.19,0.11,Vector2(1.63,1.23)],
		]],
	]
	var boulders := Node3D.new()
	boulders.name = "ForestEdgeBoulders"
	add_child(boulders)
	for definition in groups:
		var cluster := Node3D.new()
		cluster.name = definition[0]
		boulders.add_child(cluster)
		for i in definition[1].size():
			var spec: Array = definition[1][i]
			var at: Vector3 = spec[1]
			var stone := A.place(cluster,"nature",spec[0],at,spec[2],spec[3],"warm_stone")
			var width: Vector2 = spec[4]
			var bounds := A.bounds(stone.get_child(0))
			stone.scale = Vector3(width.x/bounds.size.x,1.0,width.y/bounds.size.z)
			for visual in stone.find_children("*","MeshInstance3D",true,false):
				for surface in range(visual.mesh.get_surface_count()):
					var imported: Material = visual.get_active_material(surface)
					var moss := imported != null and imported.resource_name.to_lower() == "grass"
					visual.set_surface_override_material(surface,S.material(
						"797C66" if moss else ["77766F","858178","726F66"][i % 3]))
			rock_exclusions.append(Vector3(at.x,at.z,minf(width.x,width.y)*0.34))
			var collider := S.box(cluster,at+Vector3.UP*float(spec[2])*0.46,
				Vector3(width.x*0.75,spec[2]*0.84,width.y*0.75),"FFFFFF",true)
			collider.rotation.y = spec[3]
			collider.hide()
