extends Node3D
## Shared geometry batches and collision primitives for the lake ruins.

const STONE = preload("res://shaders/a1_ruin_stone.gdshader")

var builder := SurfaceTool.new()
var body: StaticBody3D
var rng := RandomNumberGenerator.new()
var cube := BoxMesh.new()

func begin_site(label: String, origin: Vector3, seed_value: int) -> void:
	name = label
	position = origin
	rng.seed = seed_value
	cube.size = Vector3.ONE
	builder.begin(Mesh.PRIMITIVE_TRIANGLES)
	body = StaticBody3D.new()
	body.name = "SwimCollision"
	add_child(body)

func stone_visual(label: String) -> MeshInstance3D:
	var material := ShaderMaterial.new()
	material.shader = STONE
	return add_visual(label,builder.commit(),material)

func add_visual(label: String, mesh: Mesh, material: Material) -> MeshInstance3D:
	var visual := MeshInstance3D.new()
	visual.name = label
	visual.mesh = mesh
	visual.material_override = material
	visual.visibility_range_end = 94.0
	visual.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	add_child(visual)
	return visual

func tint(color: String, variation: float) -> Color:
	return Color(color).lerp(Color("8D9A91"),variation)

func drum(top: float, bottom: float, height: float, at: Vector3, color: Color, shear := 0.0) -> void:
	var mesh := CylinderMesh.new()
	mesh.top_radius = top
	mesh.bottom_radius = bottom
	mesh.height = height
	mesh.radial_segments = 10
	mesh.rings = 0
	stamp(mesh,Transform3D(Basis(Vector3.UP,shear),at),color)

func stamp(mesh: Mesh, pose: Transform3D, color: Color) -> void:
	var source := mesh.surface_get_arrays(0)
	var points: PackedVector3Array = source[Mesh.ARRAY_VERTEX]
	var normals: PackedVector3Array = source[Mesh.ARRAY_NORMAL]
	var normal_basis := pose.basis.inverse().transposed()
	for index: int in source[Mesh.ARRAY_INDEX]:
		builder.set_color(color)
		builder.set_normal((normal_basis*normals[index]).normalized())
		builder.add_vertex(pose*points[index])

func block(at: Vector3, size: Vector3, color: Color, yaw := 0.0) -> void:
	stamp(cube,Transform3D(Basis(Vector3.UP,yaw).scaled_local(size),at),color)

func collide(shape: Shape3D, at: Vector3, yaw := 0.0) -> void:
	var collider := CollisionShape3D.new()
	collider.shape = shape
	collider.position = at
	collider.rotation.y = yaw
	body.add_child(collider)
