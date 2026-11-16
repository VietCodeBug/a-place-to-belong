class_name ForestShapes
extends RefCounted

static func material(hex: String) -> StandardMaterial3D:
	var m := StandardMaterial3D.new()
	m.albedo_color = Color(hex)
	m.roughness = 1.0
	return m

static func mesh(parent: Node3D, shape: Mesh, at: Vector3, color: String) -> MeshInstance3D:
	var n := MeshInstance3D.new()
	n.mesh = shape
	n.material_override = material(color)
	parent.add_child(n)
	n.position = at
	return n

static func box(parent: Node3D, at: Vector3, size: Vector3, color: String, solid := false) -> MeshInstance3D:
	var b := BoxMesh.new()
	b.size = size
	var n := mesh(parent, b, at, color)
	if solid:
		var body := StaticBody3D.new()
		var c := CollisionShape3D.new()
		var s := BoxShape3D.new()
		s.size = size
		c.shape = s
		n.add_child(body)
		body.add_child(c)
	return n

static func cone(parent: Node3D, at: Vector3, radius: float, height: float, color: String, top := 0.0) -> MeshInstance3D:
	var c := CylinderMesh.new()
	c.top_radius = top
	c.bottom_radius = radius
	c.height = height
	c.radial_segments = 7
	return mesh(parent, c, at, color)

static func beam(parent: Node3D, a: Vector3, b: Vector3, width: float, color: String) -> void:
	var n := box(parent, (a+b)/2, Vector3(width, a.distance_to(b), width), color)
	n.quaternion = Quaternion(Vector3.UP, (b-a).normalized())
