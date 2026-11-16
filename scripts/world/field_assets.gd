class_name FieldAssets
extends RefCounted
## Imported, licensed source meshes remain unchanged. Normalize placement at runtime.
const BASE := "res://assets/vendor/kenney/"
static var scenes: Dictionary = {}

static func bounds(node: Node, inherited := Transform3D.IDENTITY) -> AABB:
	var transform := inherited
	if node is Node3D:
		transform *= node.transform
	var result := AABB()
	if node is MeshInstance3D:
		result = transform * node.get_aabb()
	for child in node.get_children():
		var next := bounds(child,transform)
		if next.size.length_squared() > 0:
			result = next if result.size.length_squared() == 0 else result.merge(next)
	return result

static func model(pack: String, asset: String, height: float) -> Node3D:
	var path := ("res://assets/vendor/quaternius/"+asset+".glb") if pack == "quaternius" else BASE+pack+"/"+asset+".glb"
	if not scenes.has(path):
		scenes[path] = load(path)
	var visual: Node3D = scenes[path].instantiate()
	var box := bounds(visual)
	var scale_factor := height / maxf(box.size.y,0.001)
	var wrapper := Node3D.new()
	wrapper.name = asset.to_pascal_case()
	wrapper.add_child(visual)
	visual.scale *= scale_factor
	visual.position -= Vector3(box.get_center().x,box.position.y,box.get_center().z)*scale_factor
	return wrapper

static func place(parent: Node3D, pack: String, asset: String, at: Vector3, height: float, yaw := 0.0) -> Node3D:
	var n := model(pack,asset,height)
	parent.add_child(n)
	n.position = at
	n.rotation.y = yaw
	style(n)
	return n

static func recolor(node: Node, color: String) -> void:
	if node is MeshInstance3D:
		node.material_override = ForestShapes.material(color)
	for child in node.get_children():
		recolor(child,color)

static var styled_materials: Dictionary = {}
static func style(node: Node, role := "natural", layer := 0) -> void:
	if node is MeshInstance3D:
		for surface in range(node.mesh.get_surface_count()):
			var source: StandardMaterial3D = node.get_active_material(surface)
			if source == null:
				continue
			var key := str(source.get_instance_id())+role+str(layer)
			if not styled_materials.has(key):
				var m: StandardMaterial3D = source.duplicate()
				m.metallic = 0
				m.roughness = 1
				var name := source.resource_name.to_lower()
				if name.contains("leaf") or name == "grass":
					m.albedo_color = Color("4F7658") if name.contains("leaf") else Color("819367")
					if role == "autumn":
						m.albedo_color = Color("BD985B")
				elif name.contains("rock") or name.contains("stone"):
					m.albedo_color = Color("858D81")
				elif name.contains("bark") or name == "wood":
					m.albedo_color = Color("896044")
				if layer > 0:
					m.albedo_color = m.albedo_color.lerp(Color("8DA5A1"),0.18 if layer == 1 else 0.4)
				styled_materials[key] = m
			node.set_surface_override_material(surface,styled_materials[key])
	for child in node.get_children():
		style(child,role,layer)

static func solid(node: Node3D) -> void:
	var saved := node.transform
	node.transform = Transform3D.IDENTITY
	var b := bounds(node)
	node.transform = saved
	var body := StaticBody3D.new()
	var collision := CollisionShape3D.new()
	var shape := BoxShape3D.new()
	shape.size = b.size.max(Vector3.ONE*0.05)
	collision.shape = shape
	body.add_child(collision)
	node.add_child(body)
	body.position = b.get_center()

static func override_material(node: Node, material: Material) -> void:
	if node is MeshInstance3D:
		node.material_override = material
	for child in node.get_children():
		override_material(child,material)
