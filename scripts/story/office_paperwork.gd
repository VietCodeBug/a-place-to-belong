extends RefCounted
## Shared, scale-accurate prop meshes for the workstations and copy alcove.

const INK = preload("res://scripts/story/office_paper.gdshader")
const A4 := Vector2(0.207, 0.293)

var form_mesh: ArrayMesh
var folder_mesh := BoxMesh.new()
var stack_mesh := BoxMesh.new()
var tray_mesh: ArrayMesh
var wastebasket_mesh := CylinderMesh.new()
var rim_mesh := TorusMesh.new()
var crumple_mesh: ArrayMesh
var forms: Array[ShaderMaterial] = []

func _init() -> void:
	folder_mesh.size = Vector3(0.236, 0.010, 0.316)
	stack_mesh.size = Vector3(A4.x, 0.023, A4.y)
	for layout in range(3):
		var ink := ShaderMaterial.new()
		ink.shader = INK
		ink.set_shader_parameter("form", layout)
		if layout == 2:
			ink.set_shader_parameter("stock", Color("d5c7ae"))
		forms.append(ink)
	form_mesh = make_form()
	tray_mesh = make_trays()
	wastebasket_mesh.top_radius = 0.146
	wastebasket_mesh.bottom_radius = 0.109
	wastebasket_mesh.height = 0.323
	wastebasket_mesh.radial_segments = 14
	wastebasket_mesh.rings = 0
	wastebasket_mesh.cap_top = false
	rim_mesh.inner_radius = 0.137
	rim_mesh.outer_radius = 0.154
	rim_mesh.rings = 14
	rim_mesh.ring_segments = 6
	crumple_mesh = make_crumple()

func workstation(parent: Node3D, own: bool, seed: int) -> void:
	if own:
		player_paperwork(parent)
		return
	var color := ["8e7955", "687776", "74685f"][posmod(seed, 3)] as String
	var yaw := sin(float(seed) * 1.65) * 0.31
	packet(parent, Vector3(0.77, 0.820, 0.222), yaw, color, posmod(seed, 3) == 0)
	if posmod(seed, 4) == 0:
		tray(parent, Vector3(0.83, 0.820, -0.209), -yaw * 0.3)
	elif posmod(seed, 3) == 0:
		page(parent, Vector3(-0.62, 0.823, 0.262), -yaw, 0)

func player_paperwork(parent: Node3D) -> void:
	packet(parent, Vector3(-0.68, 0.820, 0.245), -0.19, "a3804d", true)
	packet(parent, Vector3(0.79, 0.820, 0.252), 0.25, "976454", true)
	tray(parent, Vector3(0.69, 0.821, -0.196), 0.08)
	page(parent, Vector3(-0.79, 0.822, -0.086), 0.48, 2)
	var loose_form := page(parent, Vector3(-0.50, 0.842, 0.205), 0.62, 0)
	loose_form.rotation.z = -0.15
	page(parent, Vector3(0.73, 0.862, 0.255), -0.43, 1)
	var slip := page(parent, Vector3(0.62, 0.864, 0.306), 0.93, 0)
	slip.scale = Vector3(0.53, 0.65, 0.69)
	var note := ForestShapes.box(parent, Vector3(0.51, 0.825, 0.174), Vector3(0.076, 0.002, 0.071), "c39b54")
	note.rotation.y = -0.32
	var pen := ForestShapes.box(parent, Vector3(-0.43, 0.828, 0.348), Vector3(0.010, 0.011, 0.143), "424f58")
	pen.rotation.y = 0.64
	var pen_cap := ForestShapes.box(pen, Vector3(0, 0.001, -0.052), Vector3(0.013, 0.014, 0.036), "655b52")
	pen_cap.rotation.y = -0.025
	wastebasket(parent, Vector3(-0.94, 0.002, 0.453))
	pinned_clippings(parent)

func pinned_clippings(parent: Node3D) -> void:
	var board := ForestShapes.box(parent, Vector3(-0.62, 1.043, -0.459), Vector3(0.66, 0.36, 0.017), "756a56")
	board.name = "PinnedClippings"
	var cards := [Vector3(-0.174, 0.024, 0.013), Vector3(0.013, -0.031, 0.017), Vector3(0.207, 0.027, 0.019)]
	var tilts := [-0.10, 0.14, -0.18]
	for i in range(cards.size()):
		var at: Vector3 = cards[i]
		var clipping := page(board, at, 0.0, 1 if i == 2 else 2)
		clipping.basis = Basis(Vector3.BACK, tilts[i]) * Basis(Vector3.RIGHT, PI * 0.5)
		clipping.scale = Vector3(0.88, 0.48, 0.83 if i == 0 else 0.76)
		ForestShapes.box(board, at + Vector3(-0.011, 0.092, 0.008), Vector3(0.012, 0.013, 0.012), "a9634b")
	var corner := ForestShapes.box(board, Vector3(0.272, -0.087, 0.025), Vector3(0.079, 0.071, 0.003), "d0a75a")
	corner.rotation.z = 0.24

func packet(parent: Node3D, at: Vector3, yaw: float, color: String, flagged := false) -> void:
	var group := Node3D.new()
	group.name = "OpenFile"
	parent.add_child(group)
	group.position = at
	group.rotation.y = yaw
	ForestShapes.mesh(group, folder_mesh, Vector3(0, 0.005, 0), color)
	var pages := ForestShapes.mesh(group, stack_mesh, Vector3(-0.009, 0.020, 0.005), "cfc4ad")
	pages.scale.y = 0.47 if flagged else 0.66
	page(group, Vector3(-0.009, 0.0277, 0.010), -0.054, 0)
	page(group, Vector3(0.013, 0.031, 0.026), 0.103, int(flagged))
	if flagged:
		var tab := ForestShapes.box(group, Vector3(0.080, 0.035, -0.065), Vector3(0.048, 0.003, 0.072), "c6a05c")
		tab.rotation.y = -0.12
		ForestShapes.box(group, Vector3(-0.056, 0.037, -0.108), Vector3(0.028, 0.016, 0.015), "474f4b")

func page(parent: Node3D, at: Vector3, yaw: float, layout: int) -> MeshInstance3D:
	var sheet := MeshInstance3D.new()
	sheet.name = "PrintedSheet"
	sheet.mesh = form_mesh
	sheet.material_override = forms[layout]
	sheet.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	parent.add_child(sheet)
	sheet.position = at
	sheet.rotation.y = yaw
	return sheet

func tray(parent: Node3D, at: Vector3, yaw: float) -> void:
	var group := ForestShapes.mesh(parent, tray_mesh, at, "404d4c")
	group.name = "PendingFiles"
	group.rotation.y = yaw
	for level in range(2):
		var y := 0.026 + level * 0.086
		ForestShapes.mesh(group, stack_mesh, Vector3(-0.009, y, 0.002), "d8cbb3")
		var sheet := page(group, Vector3(0.009, y + 0.014, 0.013), -0.11 + level * 0.18, level)
		sheet.scale.y = 0.4
		ForestShapes.box(group, Vector3(0.051, y + 0.020, 0.099), Vector3(0.052, 0.003, 0.037), "a9834d")

func wastebasket(parent: Node3D, at: Vector3) -> void:
	var bin := ForestShapes.mesh(parent, wastebasket_mesh, at + Vector3.UP * 0.163, "414d4f")
	bin.name = "Wastebasket"
	var steel := bin.material_override.duplicate() as StandardMaterial3D
	steel.cull_mode = BaseMaterial3D.CULL_DISABLED
	steel.roughness = 0.49
	bin.material_override = steel
	ForestShapes.mesh(bin, rim_mesh, Vector3(0.0, 0.162, 0.0), "536365")
	for index in range(5):
		var angle := float(index) * 2.4
		var at_paper := Vector3(cos(angle) * 0.062, 0.076 + float(index % 3) * 0.034, sin(angle) * 0.062)
		var scrap := ForestShapes.mesh(bin, crumple_mesh, at_paper, "dad1bf" if index % 2 == 0 else "bcb8a6")
		scrap.rotation = Vector3(angle * 0.4, angle, -0.24 * index)

func make_form() -> ArrayMesh:
	var surface := SurfaceTool.new()
	surface.begin(Mesh.PRIMITIVE_TRIANGLES)
	for row in range(5):
		for column in range(3):
			var min_uv := Vector2(float(column) / 3.0, float(row) / 5.0)
			var max_uv := min_uv + Vector2(1.0 / 3.0, 1.0 / 5.0)
			var corners := [min_uv, Vector2(max_uv.x, min_uv.y), max_uv, Vector2(min_uv.x, max_uv.y)]
			for index in [0, 1, 2, 0, 2, 3]:
				var uv: Vector2 = corners[index]
				var curl := smoothstep(0.62, 1.0, uv.y) * pow(uv.x, 2.0) * 0.012
				var point := (uv - Vector2(0.5, 0.5)) * A4
				surface.set_uv(uv)
				surface.add_vertex(Vector3(point.x, curl, point.y))
	surface.generate_normals()
	return surface.commit()

func make_trays() -> ArrayMesh:
	var mesh := SurfaceTool.new()
	mesh.begin(Mesh.PRIMITIVE_TRIANGLES)
	for level in range(2):
		var y := float(level) * 0.086
		append_box(mesh, Vector3(0, y + 0.007, 0), Vector3(0.286, 0.014, 0.333))
		append_box(mesh, Vector3(0, y + 0.033, -0.162), Vector3(0.286, 0.039, 0.012))
		for x in [-0.136, 0.136]:
			append_box(mesh, Vector3(x, y + 0.029, -0.013), Vector3(0.014, 0.037, 0.307))
	for x in [-0.136, 0.136]:
		append_box(mesh, Vector3(x, 0.061, -0.150), Vector3(0.015, 0.092, 0.026))
	return mesh.commit()

func append_box(surface: SurfaceTool, at: Vector3, size: Vector3) -> void:
	var part := BoxMesh.new()
	part.size = size
	surface.append_from(part, 0, Transform3D(Basis.IDENTITY, at))

func make_crumple() -> ArrayMesh:
	var base := SphereMesh.new()
	base.radius = 0.052
	base.height = 0.073
	base.radial_segments = 7
	base.rings = 3
	var arrays := base.surface_get_arrays(0)
	var points: PackedVector3Array = arrays[Mesh.ARRAY_VERTEX]
	var triangles: PackedInt32Array = arrays[Mesh.ARRAY_INDEX]
	var surface := SurfaceTool.new()
	surface.begin(Mesh.PRIMITIVE_TRIANGLES)
	surface.set_smooth_group(-1)
	for index in triangles:
		var point := points[index]
		var wrinkle := sin(point.x * 211.0 + point.y * 275.0) * cos(point.z * 187.0)
		surface.add_vertex(point * (1.0 + 0.32 * wrinkle))
	surface.generate_normals()
	return surface.commit()
