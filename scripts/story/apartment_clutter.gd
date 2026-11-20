extends Node3D
## Small props that accumulate on the eating table and in the room after day one.

const NOODLES := Vector3(-0.14, 0.0, -0.123)
const FOOD_TONES := [Color("a58e6b"), Color("bcae89"), Color("8a8579")]
var work_surface: Node3D
var eating_surface: Node3D
var second_day: Node3D
var later_days: Node3D
var flies: Array[Node3D] = []
var wings: Array[Array] = []
var elapsed := 0.0
var stage := 0
var finishes: Dictionary = {}

func _ready() -> void:
	second_day = Node3D.new()
	second_day.name = "AfterDayOne"
	add_child(second_day)
	later_days = Node3D.new()
	later_days.name = "AccumulatedClutter"
	add_child(later_days)

	var meals := Node3D.new()
	meals.name = "UnfinishedMeal"
	second_day.add_child(meals)
	meals.global_transform = eating_surface.global_transform
	var more_meals := Node3D.new()
	more_meals.name = "TableClutter"
	later_days.add_child(more_meals)
	more_meals.global_transform = eating_surface.global_transform
	spill(meals, NOODLES + Vector3(0.037, 0.002, -0.02), 0.17, 0.14, Color("5c482f"), 0.6)
	noodle_bowl(meals, NOODLES + Vector3.UP * 0.006)
	soda_can(meals, Vector3(-0.25, 0, 0.112), true)
	scrap(meals, Vector3(0.09, 0.004, -0.06), 0.093, -0.5, Color("987457"), 0.013)
	ring(meals, Vector3(0.22, 0.002, -0.14), 0.046, Color("7b5841"))
	scrap(second_day, to_local(work_surface.to_global(Vector3(0.42, 0.003, 0.155))),
		0.085, -0.32, Color("ada391"), 0.018)
	dropped_shirt(second_day, Vector3(-0.87, 0.013, 0.93))

	spill(more_meals, Vector3(-0.32, 0.004, 0.13), 0.129, 0.075, Color("715035"), 1.5)
	scrap(more_meals, Vector3(0.27, 0.013, -0.15), 0.088, 0.17, Color("b8ae94"), 0.026)
	soda_can(more_meals, Vector3(0.45, 0.0, -0.132), false)
	soda_can(later_days, Vector3(2.22, 0.008, 0.83), true)
	scrap(later_days, Vector3(0.85, 0.006, -0.88), 0.14, 0.7, Color("7c7567"), 0.032)
	scrap(later_days, Vector3(-0.89, 0.006, 0.73), 0.095, 0.28, FOOD_TONES[1], 0.024)
	scrap(later_days, Vector3(1.02, 0.006, 1.23), 0.13, -0.14, FOOD_TONES[2], 0.018)
	spill(later_days, Vector3(0.42, 0.039, 0.89), 0.17, 0.11, Color("72735d"), 0.85)
	scrap(later_days, Vector3(0.35, 0.038, 0.82), 0.122, -0.43, Color("aaa28c"), 0.028)
	trash_bag(later_days, Vector3(2.22, 0.0, -0.69))

	for i in range(7):
		build_fly(meals, i)
	set_stage(0)

func set_stage(value: int) -> void:
	stage = value
	second_day.visible = stage >= 1
	later_days.visible = stage >= 2
	for i in range(flies.size()):
		flies[i].visible = stage >= 1 and (i < 4 or stage == 2)
	set_process(stage >= 1)

func _process(delta: float) -> void:
	elapsed += delta
	for i in range(4 if stage == 1 else flies.size()):
		var fly := flies[i]
		var t := elapsed * (2.07 + i * 0.22) + i * 1.73
		var radius := 0.08 + i * 0.028
		fly.position = NOODLES + Vector3(cos(t) * radius + sin(t * 1.68) * 0.043,
			0.15 + i * 0.026 + 0.065 * sin(t * 1.28), sin(t) * radius + cos(t * 1.42) * 0.05)
		fly.rotation.y = -t + 1.1
		var flutter := sin(elapsed * 105.0 + i * 2.0) * 0.48
		wings[i][0].rotation.z = 0.20 + flutter
		wings[i][1].rotation.z = -0.20 - flutter

func noodle_bowl(parent: Node3D, at: Vector3) -> void:
	var bowl := Node3D.new()
	bowl.name = "HalfEatenNoodles"
	bowl.position = at
	parent.add_child(bowl)
	var clay := [Vector2(0.050, 0.001), Vector2(0.069, 0.005), Vector2(0.080, 0.022),
		Vector2(0.104, 0.061), Vector2(0.116, 0.077), Vector2(0.115, 0.087), Vector2(0.106, 0.088),
		Vector2(0.100, 0.076), Vector2(0.086, 0.051), Vector2(0.064, 0.024), Vector2(0.001, 0.022)]
	lathe(bowl, Vector3.ZERO, clay, Color("b4aa8c"), 28)
	lathe(bowl, Vector3.ZERO, [Vector2(0.097, 0.053), Vector2(0.105, 0.061), Vector2(0.107, 0.067)],
		Color("6c7561"), 28)
	lathe(bowl, Vector3.ZERO, [Vector2(0.087, 0.051), Vector2(0.077, 0.050), Vector2(0.0, 0.049)],
		Color("6e542b"), 24)
	var noodles := SurfaceTool.new()
	noodles.begin(Mesh.PRIMITIVE_TRIANGLES)
	var rng := RandomNumberGenerator.new()
	rng.seed = 11083
	for i in range(11):
		var path: Array[Vector3] = []
		var shift := rng.randf_range(-PI, PI)
		for n in range(20):
			var fraction := n / 19.0
			var t := shift + fraction * (3.9 + (i % 4) * 1.1)
			var radius := (0.039 + 0.030 * sin(fraction * PI)) * (0.8 + 0.15 * sin(i * 1.3))
			path.append(Vector3(cos(t) * radius - 0.012, 0.055 + 0.002 * i + 0.006 * sin(t * 2.1),
				sin(t) * radius + 0.006 + 0.008 * cos(i * 2.1)))
		strand(noodles, path, 0.0031, FOOD_TONES[i % 3].lerp(Color("d7b469"), 0.68))
	noodles.generate_normals()
	var noodles_mesh := MeshInstance3D.new()
	noodles_mesh.mesh = noodles.commit()
	var noodle_matte := StandardMaterial3D.new()
	noodle_matte.vertex_color_use_as_albedo = true
	noodle_matte.cull_mode = BaseMaterial3D.CULL_DISABLED
	noodle_matte.roughness = 0.78
	noodles_mesh.material_override = noodle_matte
	bowl.add_child(noodles_mesh)
	for i in range(12):
		var theta := i * 2.39
		var radius := 0.036 + (i % 4) * 0.012
		var garnish := block(bowl, Vector3(cos(theta) * radius, 0.058, sin(theta) * radius),
			Vector3(0.009 + (i % 3) * 0.003, 0.003, 0.006), Color("737d40") if i % 3 else Color("ae7343"))
		garnish.rotation.y = theta
	for i in range(2):
		var stick := block(bowl, Vector3(0.036, 0.096 - i * 0.004, -0.034 + i * 0.013),
			Vector3(0.284, 0.007, 0.007), Color("97805b"))
		stick.rotation = Vector3(0.03, -0.57 - i * 0.12, -0.075)
	for i in range(3):
		block(parent, at + Vector3(-0.13 + i * 0.024, 0.004, 0.020 + sin(i * 3.0) * 0.055),
			Vector3(0.010, 0.005, 0.006), Color("a1854c"))

func strand(tool: SurfaceTool, path: Array[Vector3], radius: float, tint: Color) -> void:
	for i in range(path.size() - 1):
		var direction := (path[i + 1] - path[i]).normalized()
		var cross_axis := direction.cross(Vector3.UP).normalized()
		var vertical := cross_axis.cross(direction)
		for side in range(5):
			var a := TAU * side / 5.0
			var b := TAU * (side + 1) / 5.0
			var u := radius * (cos(a) * cross_axis + sin(a) * vertical)
			var v := radius * (cos(b) * cross_axis + sin(b) * vertical)
			for point in [path[i] + u, path[i] + v, path[i + 1] + u, path[i] + v, path[i + 1] + v, path[i + 1] + u]:
				tool.set_color(tint)
				tool.add_vertex(point)

func soda_can(parent: Node3D, at: Vector3, fallen: bool) -> void:
	var can := Node3D.new()
	can.position = at + Vector3.UP * (0.029 if fallen else 0.0)
	can.rotation = Vector3(PI * 0.5, 0.32, 0.0) if fallen else Vector3(0.0, 0.72, 0.07)
	parent.add_child(can)
	lathe(can, Vector3.ZERO, [Vector2(0.025, 0), Vector2(0.029, 0.006), Vector2(0.030, 0.095),
		Vector2(0.024, 0.109), Vector2(0.023, 0.112), Vector2(0.0, 0.110)], Color("665951"), 14)
	lathe(can, Vector3.ZERO, [Vector2(0.0305, 0.008), Vector2(0.031, 0.024), Vector2(0.0305, 0.048)], Color("7b6f65"), 14)
	lathe(can, Vector3.ZERO, [Vector2(0.023, 0.105), Vector2(0.025, 0.110), Vector2(0.021, 0.112),
		Vector2(0.0, 0.111)], Color("a09c8d"), 14)
	block(can, Vector3(0.0, 0.113, -0.009), Vector3(0.012, 0.0022, 0.016), Color("333633"))

func dropped_shirt(parent: Node3D, at: Vector3) -> void:
	var surface := SurfaceTool.new()
	surface.begin(Mesh.PRIMITIVE_TRIANGLES)
	var outline := [
		Vector3(-0.16, 0.02, -0.08), Vector3(-0.28, 0.013, 0.01), Vector3(-0.23, 0.041, 0.13),
		Vector3(-0.13, 0.012, 0.08), Vector3(-0.18, 0.028, 0.26), Vector3(-0.02, 0.054, 0.30),
		Vector3(0.16, 0.036, 0.22), Vector3(0.14, 0.024, 0.06), Vector3(0.26, 0.033, 0.11),
		Vector3(0.32, 0.018, -0.01), Vector3(0.14, 0.027, -0.10), Vector3(0.05, 0.013, -0.04),
		Vector3(-0.04, 0.035, -0.03),
	]
	for i in range(outline.size()):
		for point in [Vector3(-0.018, 0.084, 0.10), outline[i], outline[(i + 1) % outline.size()]]:
			surface.add_vertex(point * Vector3(0.83, 1.0, 0.77))
	var shirt := finish_mesh(parent, surface, at, Color("7c8687"))
	shirt.rotation.y = -0.48

func trash_bag(parent: Node3D, at: Vector3) -> void:
	var bag := SphereMesh.new()
	bag.radius = 0.20
	bag.height = 0.31
	bag.radial_segments = 9
	bag.rings = 5
	var volume := MeshInstance3D.new()
	volume.mesh = bag
	volume.position = at + Vector3(0.0, 0.149, 0.0)
	volume.scale.z = 0.76
	volume.rotation.z = 0.10
	volume.material_override = matte(Color("3b4140"))
	parent.add_child(volume)
	block(parent, at + Vector3(0.014, 0.306, 0.011), Vector3(0.034, 0.073, 0.042), Color("3f4540")).rotation.z = -0.32

func build_fly(parent: Node3D, index: int) -> void:
	var fly := Node3D.new()
	fly.name = "Fly%d" % (index + 1)
	parent.add_child(fly)
	flies.append(fly)
	var body := SphereMesh.new()
	body.radius = 0.0068
	body.height = 0.015
	body.radial_segments = 7
	body.rings = 4
	var body_mesh := MeshInstance3D.new()
	body_mesh.mesh = body
	body_mesh.scale = Vector3(0.74, 0.46, 1.13)
	body_mesh.material_override = matte(Color("242826"))
	fly.add_child(body_mesh)
	var pair: Array[MeshInstance3D] = []
	for side in [-1, 1]:
		var wing := block(fly, Vector3(side * 0.007, 0.0028, 0.002), Vector3(0.013, 0.002, 0.007), Color("857f6b"))
		wing.rotation.y = side * 0.28
		pair.append(wing)
	wings.append(pair)

func ring(parent: Node3D, at: Vector3, radius: float, tint: Color) -> void:
	lathe(parent, at, [Vector2(radius - 0.004, 0.0), Vector2(radius, 0.0), Vector2(radius + 0.002, 0.001)], tint, 24)

func spill(parent: Node3D, at: Vector3, x: float, z: float, tint: Color, seed: float) -> void:
	var mesh := SurfaceTool.new()
	mesh.begin(Mesh.PRIMITIVE_TRIANGLES)
	for i in range(24):
		var a := float(i) * TAU / 24.0
		var b := float(i + 1) * TAU / 24.0
		mesh.add_vertex(Vector3.ZERO)
		mesh.add_vertex(Vector3(cos(a) * x, 0.0, sin(a) * z) * (0.8 + 0.15 * sin(a * 5.0 + seed)))
		mesh.add_vertex(Vector3(cos(b) * x, 0.0, sin(b) * z) * (0.8 + 0.15 * sin(b * 5.0 + seed)))
	finish_mesh(parent, mesh, at, tint)

func scrap(parent: Node3D, at: Vector3, radius: float, yaw: float, tint: Color, wrinkle: float) -> void:
	var mesh := SurfaceTool.new()
	mesh.begin(Mesh.PRIMITIVE_TRIANGLES)
	var edge := PackedVector3Array([
		Vector3(-0.81, 0.13, -0.55), Vector3(0.49, 0.02, -0.71), Vector3(0.94, 0.37, 0.04),
		Vector3(0.46, 0.06, 0.65), Vector3(-0.43, 0.62, 0.50), Vector3(-0.86, 0.08, 0.13),
	])
	for i in range(edge.size()):
		for point in [Vector3(0.02, 0.89, -0.01), edge[i], edge[(i + 1) % edge.size()]]:
			mesh.add_vertex(point * Vector3(radius, wrinkle, radius))
	var instance := finish_mesh(parent, mesh, at, tint)
	instance.rotation.y = yaw

func lathe(parent: Node3D, at: Vector3, profile: Array, tint: Color, sides: int) -> void:
	var mesh := SurfaceTool.new()
	mesh.begin(Mesh.PRIMITIVE_TRIANGLES)
	for i in range(profile.size() - 1):
		for side in range(sides):
			var a := TAU * float(side) / sides
			var b := TAU * float(side + 1) / sides
			var lo: Vector2 = profile[i]
			var hi: Vector2 = profile[i + 1]
			var v0 := Vector3(cos(a) * lo.x, lo.y, sin(a) * lo.x)
			var v1 := Vector3(cos(b) * lo.x, lo.y, sin(b) * lo.x)
			var v2 := Vector3(cos(a) * hi.x, hi.y, sin(a) * hi.x)
			var v3 := Vector3(cos(b) * hi.x, hi.y, sin(b) * hi.x)
			for point in [v0, v2, v1, v1, v2, v3]:
				mesh.add_vertex(point)
	finish_mesh(parent, mesh, at, tint)

func finish_mesh(parent: Node3D, surface: SurfaceTool, at: Vector3, tint: Color) -> MeshInstance3D:
	surface.generate_normals()
	var piece := MeshInstance3D.new()
	piece.mesh = surface.commit()
	piece.material_override = matte(tint)
	piece.position = at
	parent.add_child(piece)
	return piece

func block(parent: Node3D, at: Vector3, size: Vector3, tint: Color) -> MeshInstance3D:
	var part := MeshInstance3D.new()
	var geometry := BoxMesh.new()
	geometry.size = size
	part.mesh = geometry
	part.material_override = matte(tint)
	part.position = at
	parent.add_child(part)
	return part

func matte(tint: Color) -> StandardMaterial3D:
	if not finishes.has(tint):
		var material := StandardMaterial3D.new()
		material.albedo_color = tint
		material.roughness = 0.90
		material.cull_mode = BaseMaterial3D.CULL_DISABLED
		finishes[tint] = material
	return finishes[tint]
