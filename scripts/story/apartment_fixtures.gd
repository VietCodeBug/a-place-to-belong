extends Node3D
## The kitchenette faces the living area. The wet room opens off the entry.

const TILE = preload("res://scripts/story/apartment_tile.gdshader")
const CERAMIC = preload("res://scripts/story/apartment_ceramic.gdshader")
const GLASS = preload("res://scripts/story/apartment_shower_glass.gdshader")
const TEXTILE = preload("res://scripts/story/office_textile.gdshader")
var room: Node3D
var dishes: Node3D
var later_dishes: Node3D
var bathroom_mess: Node3D
var bathroom_late: Node3D
var towel_on_rack: MeshInstance3D
var sink_water: MeshInstance3D
var changing_finishes: Array[ShaderMaterial] = []
var bin_hinge: Node3D
var under_shelf_light: SpotLight3D
var surfaces: Dictionary = {}

func _ready() -> void:
	room = get_parent() as Node3D
	build_kitchenette()
	build_wet_room()
	set_stage(0)

func set_stage(stage: int) -> void:
	dishes.visible = stage > 0
	later_dishes.visible = stage == 2
	bathroom_mess.visible = stage > 0
	bathroom_late.visible = stage == 2
	towel_on_rack.visible = stage < 2
	sink_water.scale = Vector3(1.19, 1.0, 1.16) if stage == 2 else Vector3.ONE
	under_shelf_light.light_energy = [0.18, 0.67, 0.86][stage]
	for material in changing_finishes:
		material.set_shader_parameter("wear", [0.0, 0.49, 1.0][stage])
	bin_hinge.rotation.x = -0.68 if stage == 2 else 0.0

func build_kitchenette() -> void:
	var cabinet := slab(Vector3(1.81, 0.357, -1.61), Vector3(1.09, 0.70, 0.56), "677569", true)
	cabinet.name = "WashingUpCounter"
	slab(Vector3(1.81, 0.104, -1.322), Vector3(1.03, 0.09, 0.035), "484e47")
	slab(Vector3(1.81, 0.750, -1.322), Vector3(1.08, 0.073, 0.036), "677569")
	for x in [1.55, 2.071]:
		slab(Vector3(x, 0.422, -1.322), Vector3(0.494, 0.612, 0.032), "758479")
		slab(Vector3(x + 0.10, 0.648, -1.298), Vector3(0.12, 0.018, 0.023), "4c5352")
	slab(Vector3(1.81, 0.985, -1.897), Vector3(1.09, 0.43, 0.016), "a6a898").material_override = tiles("a6a898", 0.146, true)

	# Four counter sections leave a real opening for the recessed basin.
	slab(Vector3(1.344, 0.817, -1.61), Vector3(0.166, 0.065, 0.60), "8e9084")
	slab(Vector3(2.109, 0.817, -1.61), Vector3(0.524, 0.065, 0.60), "8e9084")
	for z in [-1.849, -1.37]:
		slab(Vector3(1.636, 0.817, z), Vector3(0.438, 0.065, 0.120), "8e9084")
	var sink := basin(Vector3(1.636, 0.717, -1.61), 0.146, 0.205, 0.191, "a0a6a0")
	sink.material_override = glazed("a6aca7", 1.0, 0.0, true)
	faucet(Vector3(1.65, 0.850, -1.832), 0.21)
	var rack := slab(Vector3(2.127, 0.854, -1.62), Vector3(0.380, 0.010, 0.326), "818c88")
	rack.name = "DrainingBoard"
	for i in range(7):
		slab(Vector3(1.986 + i * 0.045, 0.861, -1.62), Vector3(0.008, 0.005, 0.28), "a1aaa2")
	slab(Vector3(2.292, 0.876, -1.682), Vector3(0.074, 0.030, 0.10), "a49b69")

	build_washing_light()
	build_bin()
	build_dishes()

func build_washing_light() -> void:
	slab(Vector3(1.94, 1.41, -1.80), Vector3(0.73, 0.042, 0.239), "887a63")
	slab(Vector3(2.22, 1.323, -1.863), Vector3(0.039, 0.154, 0.070), "777d70")
	slab(Vector3(1.94, 1.381, -1.767), Vector3(0.411, 0.014, 0.041), "b7b198")
	under_shelf_light = SpotLight3D.new()
	under_shelf_light.position = Vector3(1.91, 1.363, -1.77)
	under_shelf_light.light_color = Color("ebdfbf")
	under_shelf_light.spot_range = 1.42
	under_shelf_light.spot_angle = 47.0
	under_shelf_light.spot_attenuation = 1.08
	add_child(under_shelf_light)
	under_shelf_light.look_at(Vector3(1.82, 0.76, -1.55), Vector3.FORWARD)

func build_dishes() -> void:
	dishes = Node3D.new()
	dishes.name = "UsedDishes"
	add_child(dishes)
	later_dishes = Node3D.new()
	later_dishes.name = "LaterDishes"
	dishes.add_child(later_dishes)

	sink_water = stain_disc(dishes, Vector3(1.633, 0.768, -1.606), Vector2(0.115, 0.110),
		Color(0.39, 0.29, 0.15, 0.78))
	var large_plate := dirty_plate(dishes, Vector3(1.621, 0.854, -1.680), 0.135, "d7cfb3")
	large_plate.rotation = Vector3(0.79, 0.05, -0.13)
	var smaller_plate := dirty_plate(dishes, Vector3(1.543, 0.816, -1.603), 0.104, "c1bfa7")
	smaller_plate.rotation = Vector3(0.51, -0.29, 0.20)
	var bowl := vessel(dishes, Vector3(1.711, 0.773, -1.534),
		[Vector2(0.042, 0.0), Vector2(0.051, 0.012), Vector2(0.081, 0.051), Vector2(0.087, 0.060),
		Vector2(0.079, 0.061), Vector2(0.061, 0.027), Vector2(0.0, 0.018)], Color("899992"))
	bowl.material_override = glazed("9baaa0", 0.087, 0.24, false, 0.94)
	bowl.rotation.z = -0.10
	stain_disc(bowl, Vector3(0.002, 0.028, -0.006), Vector2(0.050, 0.041), Color("857045"))
	for i in range(7):
		var angle := i * 2.39
		var chip := slab(Vector3(0.030 * cos(angle), 0.031, 0.027 * sin(angle)),
			Vector3(0.008 + i * 0.0005, 0.004, 0.006), "836c43" if i % 2 else "87904f", false, bowl)
		chip.rotation.y = angle
	var spoon := Node3D.new()
	spoon.position = Vector3(1.747, 0.875, -1.511)
	spoon.rotation.y = 0.45
	dishes.add_child(spoon)
	slab(Vector3(0, 0.004, 0.035), Vector3(0.013, 0.008, 0.136), "a1a19a", false, spoon)
	var scoop := vessel(spoon, Vector3(0, 0.001, -0.038),
		[Vector2(0, 0), Vector2(0.017, 0.004), Vector2(0.022, 0.012), Vector2(0.001, 0.006)], Color("a8a9a1"), 20)
	scoop.scale.z = 1.24
	for i in range(2):
		var stick := slab(Vector3(1.677 + i * 0.026, 0.869 - i * 0.004, -1.527 - i * 0.030),
			Vector3(0.007, 0.006, 0.218), "a38459", false, dishes)
		stick.rotation = Vector3(0.11 - i * 0.04, -0.64 + i * 0.38, 0.0)

	var cup := vessel(dishes, Vector3(2.217, 0.858, -1.525),
		[Vector2(0.034, 0.001), Vector2(0.039, 0.006), Vector2(0.044, 0.085), Vector2(0.039, 0.088),
		Vector2(0.035, 0.021), Vector2(0.0, 0.018)], Color("a4a08a"))
	cup.material_override = glazed("b8ae9a", 0.044, 0.2, false, 0.91)
	var handle := MeshInstance3D.new()
	var loop := TorusMesh.new()
	loop.inner_radius = 0.022
	loop.outer_radius = 0.031
	loop.rings = 12
	loop.ring_segments = 7
	handle.mesh = loop
	handle.material_override = matte(Color("aaa28e"))
	handle.position = Vector3(0.053, 0.049, 0.0)
	handle.rotation.x = PI * 0.5
	cup.add_child(handle)
	stain_disc(cup, Vector3(0, 0.027, 0), Vector2(0.032, 0.032), Color("61472e"))

	var pot := vessel(later_dishes, Vector3(2.054, 0.861, -1.730), [
		Vector2(0.082, 0.001), Vector2(0.104, 0.010), Vector2(0.112, 0.103), Vector2(0.109, 0.106),
		Vector2(0.104, 0.104), Vector2(0.096, 0.014), Vector2(0.0, 0.014)], Color("69726b"))
	pot.material_override = glazed("727970", 0.112, 0.0, false, 0.83)
	for side in [-1, 1]:
		slab(Vector3(side * 0.119, 0.080, 0), Vector3(0.040, 0.020, 0.042), "51554f", false, pot)
	stain_disc(pot, Vector3(0, 0.022, 0), Vector2(0.09, 0.089), Color("917047"))
	stain_disc(later_dishes, Vector3(1.757, 0.852, -1.403), Vector2(0.100, 0.026),
		Color(0.54, 0.35, 0.17, 0.76))

func dirty_plate(parent: Node3D, at: Vector3, radius: float, tint: String) -> MeshInstance3D:
	var plate := vessel(parent, at, [Vector2(0, 0), Vector2(radius * 0.63, 0.0),
		Vector2(radius * 0.87, 0.010), Vector2(radius, 0.024), Vector2(radius * 0.99, 0.027),
		Vector2(radius * 0.86, 0.014), Vector2(radius * 0.62, 0.007), Vector2(0, 0.007)], Color(tint))
	plate.material_override = glazed(tint, radius, 0.85, false, 0.83)
	return plate

func build_bin() -> void:
	var bin := Node3D.new()
	bin.name = "KitchenBin"
	bin.position = Vector3(2.253, 0.0, -1.073)
	add_child(bin)
	slab(Vector3(0, 0.188, 0), Vector3(0.24, 0.376, 0.24), "53645b", true, bin).hide()
	for side in [-1, 1]:
		slab(Vector3(0, 0.19, side * 0.111), Vector3(0.24, 0.38, 0.018), "53645b", false, bin)
		slab(Vector3(side * 0.111, 0.19, 0), Vector3(0.018, 0.38, 0.222), "53645b", false, bin)
		slab(Vector3(side * 0.113, 0.371, 0), Vector3(0.026, 0.024, 0.249), "3d4a43", false, bin)
	slab(Vector3(0, 0.18, 0), Vector3(0.20, 0.014, 0.20), "3a4940", false, bin)
	slab(Vector3(0.034, 0.231, 0.016), Vector3(0.112, 0.066, 0.12), "999280", false, bin).rotation.y = 0.38
	slab(Vector3(-0.052, 0.25, -0.04), Vector3(0.09, 0.086, 0.088), "806b53", false, bin).rotation.z = 0.28
	slab(Vector3(0, 0.018, 0.128), Vector3(0.095, 0.015, 0.039), "939985", false, bin)
	bin_hinge = Node3D.new()
	bin_hinge.position = Vector3(0, 0.386, -0.120)
	bin.add_child(bin_hinge)
	slab(Vector3(0, 0.012, 0.120), Vector3(0.262, 0.024, 0.256), "61726a", false, bin_hinge)

func build_wet_room() -> void:
	var floor := slab(Vector3(3.535, -0.10, 1.052), Vector3(1.92, 0.20, 1.82), "879b94", true)
	floor.name = "BathroomFloor"
	slab(Vector3(3.493, 0.002, 1.052), Vector3(2.0, 0.008, 1.80), "899a93").material_override = tiles("879c94", 0.214, true)
	var wall_tile := tiles("a9b8ad", 0.217, true)
	slab(Vector3(3.544, 1.365, 0.106), Vector3(2.13, 2.73, 0.12), "a9b8ad", true).material_override = wall_tile
	slab(Vector3(3.544, 1.365, 2.0), Vector3(2.13, 2.73, 0.16), "a9b8ad", true).material_override = wall_tile
	slab(Vector3(4.544, 1.365, 1.052), Vector3(0.12, 2.73, 1.90), "a9b8ad", true).material_override = wall_tile
	slab(Vector3(3.546, 2.78, 1.052), Vector3(2.14, 0.13, 1.90), "b1b9ad", true)
	slab(Vector3(3.42, 2.699, 1.15), Vector3(0.34, 0.043, 0.233), "d7d6bf")
	var light := OmniLight3D.new()
	light.position = Vector3(3.43, 2.55, 1.16)
	light.light_color = Color("e9e1c9")
	light.light_energy = 0.65
	light.shadow_enabled = true
	light.omni_range = 3.0
	add_child(light)

	var toilet := Node3D.new()
	toilet.name = "Toilet"
	toilet.position = Vector3(4.027, 0.0, 1.618)
	add_child(toilet)
	slab(Vector3(0, 0.472, 0.18), Vector3(0.37, 0.430, 0.15), "c6cbba", true, toilet)
	slab(Vector3(0, 0.694, 0.173), Vector3(0.393, 0.028, 0.172), "dce0cf", false, toilet)
	slab(Vector3(0.105, 0.712, 0.160), Vector3(0.067, 0.012, 0.043), "82908a", false, toilet)
	var ceramic := vessel(toilet, Vector3(0, 0, -0.061),
		[Vector2(0.125, 0.003), Vector2(0.136, 0.091), Vector2(0.105, 0.225), Vector2(0.162, 0.304),
		Vector2(0.195, 0.391), Vector2(0.195, 0.427), Vector2(0.159, 0.424), Vector2(0.138, 0.360),
		Vector2(0.081, 0.279), Vector2(0.0, 0.277)], Color("d7d9c5"))
	ceramic.scale.z = 1.24
	ceramic.material_override = glazed("d7d9c5", 0.195, 0.0, true)
	var seat := vessel(toilet, Vector3(0, 0.429, -0.061),
		[Vector2(0.194, 0.001), Vector2(0.185, 0.015), Vector2(0.153, 0.016), Vector2(0.148, 0.0)],
		Color("b7bdae"))
	seat.scale.z = 1.25
	slab(Vector3(0, 0.215, -0.060), Vector3(0.33, 0.43, 0.40), "c6cbba", true, toilet).hide()

	slab(Vector3(3.010, 0.34, 0.42), Vector3(0.439, 0.68, 0.35), "758884", true)
	var washbasin := basin(Vector3(3.010, 0.642, 0.43), 0.147, 0.220, 0.173, "cdd3c4")
	washbasin.material_override = glazed("cdd3c4", 1.0, 0.0, true)
	faucet(Vector3(3.015, 0.791, 0.279), 0.144)
	slab(Vector3(3.01, 1.338, 0.184), Vector3(0.36, 0.52, 0.028), "73867f")
	slab(Vector3(3.01, 1.338, 0.201), Vector3(0.322, 0.48, 0.009), "b2c5c0")

	build_shower()
	build_bathroom_use()

func build_bathroom_use() -> void:
	bathroom_mess = Node3D.new()
	bathroom_mess.name = "WetRoomDirt"
	add_child(bathroom_mess)
	bathroom_late = Node3D.new()
	bathroom_late.name = "WetRoomLate"
	bathroom_mess.add_child(bathroom_late)
	var bar := tube(Vector3(3.36, 1.105, 0.226), 0.010, 0.31, "7d8981")
	bar.rotation.z = PI * 0.5
	towel_on_rack = towel(self, Vector3(3.35, 0.965, 0.24), Vector2(0.235, 0.28), "9b9d84", 0.009)
	towel_on_rack.rotation.x = PI * 0.5
	var soap_tray := slab(Vector3(3.24, 0.736, 0.433), Vector3(0.123, 0.018, 0.10), "8c9e91")
	soap_tray.rotation.y = -0.18
	slab(Vector3(3.24, 0.753, 0.433), Vector3(0.067, 0.025, 0.05), "aba58c")
	slab(Vector3(4.35, 1.194, 0.317), Vector3(0.18, 0.022, 0.16), "899890")
	tube(Vector3(4.35, 1.257, 0.324), 0.029, 0.102, "a9aa92")
	tube(Vector3(4.35, 1.314, 0.324), 0.022, 0.018, "758072")

	stain_disc(bathroom_mess, Vector3(4.045, 0.042, 0.486), Vector2(0.207, 0.149),
		Color(0.32, 0.38, 0.27, 0.43))
	stain_disc(bathroom_mess, Vector3(3.274, 0.010, 0.739), Vector2(0.137, 0.109),
		Color(0.35, 0.39, 0.29, 0.38))
	stain_disc(bathroom_late, Vector3(3.81, 0.014, 1.333), Vector2(0.24, 0.16),
		Color(0.33, 0.32, 0.20, 0.52))
	stain_disc(bathroom_late, Vector3(3.254, 0.744, 0.427), Vector2(0.058, 0.045),
		Color(0.57, 0.52, 0.32, 0.58))
	var dropped_towel := towel(bathroom_late, Vector3(3.045, 0.014, 0.775),
		Vector2(0.34, 0.42), "858570", 0.039)
	dropped_towel.rotation.y = -0.49
	var fallen_bottle := tube(Vector3(4.306, 0.054, 0.813), 0.025, 0.126, "777a61")
	fallen_bottle.rotation = Vector3(0.12, 0.0, PI * 0.5)
	fallen_bottle.reparent(bathroom_late, false)
	for i in range(3):
		var paper := slab(Vector3(4.182 + sin(i * 2.5) * 0.11, 0.011 + i * 0.002, 1.478 - i * 0.105),
			Vector3(0.051 + i * 0.008, 0.009, 0.036), "acaa94", false, bathroom_late)
		paper.rotation.y = 0.37 + i * 0.81

func towel(parent: Node3D, at: Vector3, size: Vector2, tint: String, crease: float) -> MeshInstance3D:
	var mesh := SurfaceTool.new()
	mesh.begin(Mesh.PRIMITIVE_TRIANGLES)
	for x in range(12):
		for z in range(9):
			var a := towel_point(size, x / 12.0, z / 9.0, crease)
			var b := towel_point(size, (x + 1) / 12.0, z / 9.0, crease)
			var c := towel_point(size, x / 12.0, (z + 1) / 9.0, crease)
			var d := towel_point(size, (x + 1) / 12.0, (z + 1) / 9.0, crease)
			for vertex in [a, b, c, b, d, c]:
				mesh.add_vertex(vertex)
	mesh.generate_normals()
	var fabric := ShaderMaterial.new()
	fabric.shader = TEXTILE
	fabric.set_shader_parameter("cloth", Color(tint))
	var node := MeshInstance3D.new()
	node.mesh = mesh.commit()
	node.material_override = fabric
	node.position = at
	parent.add_child(node)
	return node

func towel_point(size: Vector2, u: float, v: float, crease: float) -> Vector3:
	var fold := (cos(u * 21.8 + v * 4.2) * 0.40 + sin(v * 15.7 - u * 2.3) * 0.30 + 0.55) * crease
	return Vector3(size.x * (u - 0.5), fold, size.y * (v - 0.5) + sin(u * 8.3) * crease * 0.65)

func build_shower() -> void:
	var pan := slab(Vector3(4.038, 0.017, 0.573), Vector3(0.82, 0.034, 0.79), "8fa7a0")
	pan.name = "ShowerTray"
	pan.material_override = tiles("92aaa2", 0.172, true)
	slab(Vector3(4.11, 0.038, 0.435), Vector3(0.11, 0.009, 0.11), "647673")
	for i in range(4):
		slab(Vector3(4.080 + i * 0.021, 0.044, 0.435), Vector3(0.006, 0.005, 0.080), "475c58")
	var screen := slab(Vector3(3.665, 0.867, 0.41), Vector3(0.022, 1.66, 0.48), "a4b7ae", true)
	var glass := ShaderMaterial.new()
	glass.shader = GLASS
	changing_finishes.append(glass)
	screen.material_override = glass
	screen.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	for z in [0.176, 0.646]:
		slab(Vector3(3.665, 0.862, z), Vector3(0.039, 1.70, 0.036), "657772")
	slab(Vector3(3.665, 1.717, 0.41), Vector3(0.046, 0.036, 0.51), "657772")
	tube(Vector3(4.336, 1.471, 0.594), 0.017, 0.90, "8f9b94")
	tube(Vector3(4.230, 1.918, 0.594), 0.016, 0.219, "8f9b94").rotation.z = PI * 0.5
	tube(Vector3(4.126, 1.899, 0.594), 0.059, 0.029, "84958e")
	tube(Vector3(4.325, 1.066, 0.594), 0.047, 0.032, "7f9188").rotation.z = PI * 0.5

func basin(at: Vector3, height: float, width: float, depth: float, color: String) -> MeshInstance3D:
	var sink := vessel(self, at, [Vector2(0.63, 0.0), Vector2(0.79, 0.021),
		Vector2(1.0, height - 0.010), Vector2(0.98, height), Vector2(0.88, height),
		Vector2(0.64, 0.047), Vector2(0.38, 0.020), Vector2(0.0, 0.020)], Color(color))
	sink.scale = Vector3(width, 1.0, depth)
	tube(at + Vector3.UP * 0.023, 0.026, 0.005, "73827b")
	return sink

func faucet(at: Vector3, height: float) -> void:
	tube(at + Vector3.UP * 0.008, 0.036, 0.018, "767f7b")
	tube(at + Vector3.UP * height * 0.5, 0.014, height, "929e99")
	tube(at + Vector3(0, height, 0.069), 0.014, 0.146, "929e99").rotation.x = PI * 0.5
	tube(at + Vector3(0, height - 0.019, 0.133), 0.015, 0.042, "929e99")
	slab(at + Vector3(0.027, height * 0.58, -0.002), Vector3(0.051, 0.014, 0.019), "818c85")

func vessel(parent: Node3D, at: Vector3, profile: Array, tint: Color, sides := 28) -> MeshInstance3D:
	var surface := SurfaceTool.new()
	surface.begin(Mesh.PRIMITIVE_TRIANGLES)
	for i in range(profile.size() - 1):
		var lo: Vector2 = profile[i]
		var hi: Vector2 = profile[i + 1]
		for step in range(sides):
			var angle := TAU * float(step) / sides
			var next := TAU * float(step + 1) / sides
			var a := Vector3(cos(angle) * lo.x, lo.y, sin(angle) * lo.x)
			var b := Vector3(cos(next) * lo.x, lo.y, sin(next) * lo.x)
			var c := Vector3(cos(angle) * hi.x, hi.y, sin(angle) * hi.x)
			var d := Vector3(cos(next) * hi.x, hi.y, sin(next) * hi.x)
			for point in [a, c, b, b, c, d]:
				surface.add_vertex(point)
	surface.generate_normals()
	var node := MeshInstance3D.new()
	node.mesh = surface.commit()
	node.material_override = matte(tint)
	node.position = at
	parent.add_child(node)
	return node

func tube(at: Vector3, radius: float, height: float, color: String) -> MeshInstance3D:
	var mesh := CylinderMesh.new()
	mesh.top_radius = radius
	mesh.bottom_radius = radius
	mesh.height = height
	mesh.radial_segments = 16
	var node := MeshInstance3D.new()
	node.mesh = mesh
	node.material_override = matte(Color(color))
	node.position = at
	add_child(node)
	return node

func tiles(color: String, width: float, age := false) -> ShaderMaterial:
	var material := ShaderMaterial.new()
	material.shader = TILE
	material.set_shader_parameter("ceramic", Color(color))
	material.set_shader_parameter("tile_width", width)
	if age:
		changing_finishes.append(material)
	return material

func glazed(color: String, radius: float, band: float, age: bool, wear := 0.0) -> ShaderMaterial:
	var material := ShaderMaterial.new()
	material.shader = CERAMIC
	material.set_shader_parameter("glazed_color", Color(color))
	material.set_shader_parameter("radius", radius)
	material.set_shader_parameter("painted_rim", band)
	material.set_shader_parameter("fixture", float(age))
	material.set_shader_parameter("wear", wear)
	if age:
		changing_finishes.append(material)
	return material

func stain_disc(parent: Node3D, at: Vector3, radius: Vector2, color: Color) -> MeshInstance3D:
	var mesh := SurfaceTool.new()
	mesh.begin(Mesh.PRIMITIVE_TRIANGLES)
	var center := Color(color, color.a * 0.86)
	var edge := Color(color, 0.0)
	for i in range(32):
		var a := TAU * i / 32.0
		var b := TAU * (i + 1) / 32.0
		var pa := Vector3(radius.x * cos(a), 0, radius.y * sin(a)) * (0.85 + sin(a * 6.0) * 0.11)
		var pb := Vector3(radius.x * cos(b), 0, radius.y * sin(b)) * (0.85 + sin(b * 6.0) * 0.11)
		mesh.set_normal(Vector3.UP)
		mesh.set_color(center)
		mesh.add_vertex(Vector3.ZERO)
		mesh.add_vertex(pa * 0.70)
		mesh.add_vertex(pb * 0.70)
		mesh.add_vertex(pa * 0.70)
		mesh.set_color(edge)
		mesh.add_vertex(pa)
		mesh.add_vertex(pb)
		mesh.set_color(center)
		mesh.add_vertex(pa * 0.70)
		mesh.set_color(edge)
		mesh.add_vertex(pb)
		mesh.set_color(center)
		mesh.add_vertex(pb * 0.70)
	var surface := StandardMaterial3D.new()
	surface.vertex_color_use_as_albedo = true
	surface.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	surface.cull_mode = BaseMaterial3D.CULL_DISABLED
	surface.roughness = 0.34
	var disk := MeshInstance3D.new()
	disk.mesh = mesh.commit()
	disk.material_override = surface
	disk.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	disk.position = at
	parent.add_child(disk)
	return disk

func matte(tint: Color) -> StandardMaterial3D:
	if not surfaces.has(tint):
		var material := StandardMaterial3D.new()
		material.albedo_color = tint
		material.cull_mode = BaseMaterial3D.CULL_DISABLED
		material.roughness = 0.70
		surfaces[tint] = material
	return surfaces[tint]

func slab(at: Vector3, size: Vector3, color: String, blocking := false, parent: Node3D = null) -> MeshInstance3D:
	return room.slab(at, size, color, blocking, self if parent == null else parent)
