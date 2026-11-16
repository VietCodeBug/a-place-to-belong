extends Node3D
## Licensed Kenney models, normalized to metres and batched without editing source GLBs.
const A = preload("res://scripts/world/field_assets.gd")
const S = preload("res://scripts/world/shapes.gd")
@export var palette: ForestPalette = preload("res://assets/palettes/early_autumn.tres")
var rng := RandomNumberGenerator.new()
var batches: Dictionary = {}
const PINES := ["tree_pineTallA_detailed","tree_pineTallB_detailed","tree_pineTallC_detailed","tree_pineTallD_detailed","tree_pineRoundC"]

func _ready() -> void:
	rng.seed = 4816
	var groves := [Vector2(-13,-8),Vector2(-18,2),Vector2(-20,14),Vector2(15,-11),Vector2(5,-19)]
	for g in range(groves.size()):
		for i in range(7):
			var a := i*2.4+g
			var p: Vector2 = groves[g]+Vector2(cos(a),sin(a))*sqrt(float(i))*1.9
			var height: float = [7.0,10.5,14.0][(g+i)%3]*rng.randf_range(0.9,1.08)
			plant(PINES[(g+i)%5],Vector3(p.x,0,p.y),height,i*1.7,0)
			trunk_collision(Vector3(p.x,height*0.22,p.y),height*0.44)
	for layer in [1,2]:
		for g in range(5):
			var center := Vector2(-36+g*17,-29-layer*15+sin(g*2.1)*5)
			for i in range(6):
				var a := i*2.4
				var p := center+Vector2(cos(a),sin(a))*sqrt(float(i))*2.3
				plant(PINES[(i+g)%4],Vector3(p.x,-0.55,p.y),rng.randf_range(10,16),a,layer)
	# One autumn broadleaf accent instead of recoloring every pine yellow.
	for p in [Vector3(-10,0,2),Vector3(10,0,-9),Vector3(-16,0,-17)]:
		plant("tree_oak_fall",p,rng.randf_range(6.5,8.5),rng.randf()*TAU,0,"autumn")
	gardens()
	for item in batches.values():
		var mm := MultiMesh.new()
		mm.transform_format = MultiMesh.TRANSFORM_3D
		mm.mesh = item.mesh
		mm.instance_count = item.transforms.size()
		for i in range(mm.instance_count):
			mm.set_instance_transform(i,item.transforms[i])
		var n := MultiMeshInstance3D.new()
		n.multimesh = mm
		n.material_override = item.material
		add_child(n)
	batches.clear()

func plant(asset: String, at: Vector3, height: float, yaw: float, layer := 0, role := "natural") -> void:
	var model := A.model("nature",asset,height)
	A.style(model,role,layer)
	model.position = at
	model.rotation.y = yaw
	collect(model,Transform3D.IDENTITY)
	model.free()

func collect(node: Node, inherited: Transform3D) -> void:
	var transform := inherited
	if node is Node3D:
		transform *= node.transform
	if node is MeshInstance3D:
		# Split material surfaces into shared meshes once; don't flatten source colors.
		for surface in range(node.mesh.get_surface_count()):
			var material: Material = node.get_active_material(surface)
			var key := str(node.mesh.get_instance_id())+":"+str(surface)+":"+str(material.get_instance_id())
			if not batches.has(key):
				var mesh := ArrayMesh.new()
				mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES,node.mesh.surface_get_arrays(surface))
				batches[key] = {"mesh":mesh,"material":material,"transforms":[]}
			batches[key].transforms.append(transform)
	for child in node.get_children():
		collect(child,transform)

func trunk_collision(at: Vector3, height: float) -> void:
	var body := StaticBody3D.new()
	var c := CollisionShape3D.new()
	var shape := CylinderShape3D.new()
	shape.radius = 0.28
	shape.height = height
	c.shape = shape
	body.add_child(c)
	add_child(body)
	body.position = at

func gardens() -> void:
	var centers := [Vector3(-7,0,4),Vector3(-8,0,8),Vector3(7,0,1),Vector3(7,0,5),Vector3(-9,0,16),Vector3(6,0,14),Vector3(11,0,18)]
	for k in range(centers.size()):
		var center: Vector3 = centers[k]
		for i in range(35):
			var a := rng.randf()*TAU
			var p := center+Vector3(cos(a),0,sin(a))*sqrt(rng.randf())*2.7
			if ClearingLayout.on_path(p,0.3):
				continue
			plant("grass_large" if i%2 else "grass_leafs",p,rng.randf_range(0.25,0.65),a)
			if i%7 == 0:
				plant("flower_yellowA" if i%2 else "flower_redC",p+Vector3(0.2,0,0),0.5,a)
		for i in range(3):
			var p := center+Vector3(i*0.8-0.7,0,-0.7)
			plant("plant_bushDetailed" if i%2 else "plant_bushLarge",p,0.8+i*0.15,i)
			plant("rock_largeA" if i%2 else "rock_largeB",p+Vector3(0.3,0,0.8),0.6,i)
	for i in range(180):
		var z := rng.randf_range(4.0,23.0)
		var x := ClearingLayout.path_center(z)+(1.0 if i%2 else -1.0)*(ClearingLayout.path_half_width(z)+rng.randf_range(0.1,0.7))
		plant("grass_leafs",Vector3(x,0,z),rng.randf_range(0.12,0.32),i)
	plant("stump_roundDetailed",Vector3(8,0,12),0.8,0.3)
	plant("log_stack",Vector3(-7.7,0,-1),0.8,0.4)
