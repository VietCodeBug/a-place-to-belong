extends Node3D
## Curated Map 01 planting; Quaternius crowns replace unsuitable Kenney cone silhouettes.
const A = preload("res://scripts/world/field_assets.gd")
var rng := RandomNumberGenerator.new()
var batches: Dictionary = {}
const PINES := ["PineTree_1","PineTree_2","PineTree_3","PineTree_4","PineTree_5"]
func _ready() -> void:
	rng.seed = 4816
	var heroes := [Vector3(-14,17,-7),Vector3(-12,16,-19),Vector3(12,18,-16),Vector3(20,15,-4),Vector3(-17,14,10)]
	for i in range(heroes.size()):
		var p: Vector3 = heroes[i]
		var h := ForestLandscape.height_at(p.x,p.z)
		plant(PINES[i],Vector3(p.x,h,p.z),p.y,i*1.4)
		trunk_collision(Vector3(p.x,h+p.y*0.2,p.z),p.y*0.4)
	# Unequal small groves, placed around the original clearing. Southeast remains open.
	var centers := [Vector2(-20,-12),Vector2(-21,0),Vector2(-22,17),Vector2(19,-19),Vector2(3,-24)]
	for g in range(centers.size()):
		for i in range(3+g%3):
			var a := i*2.3+g
			var p: Vector2 = centers[g]+Vector2(cos(a),sin(a))*sqrt(float(i))*2.3
			plant(PINES[(g+i)%5],Vector3(p.x,ForestLandscape.height_at(p.x,p.y),p.y),rng.randf_range(9.5,15.5),a)
	for i in range(24):
		var a := PI+i*PI/23
		var p := Vector2(cos(a)*55,sin(a)*27-29)
		plant(PINES[i%5],Vector3(p.x,ForestLandscape.height_at(p.x,p.y),p.y),rng.randf_range(13,19),a,1 if i%3 else 2)
	for i in range(3):
		var p: Vector2 = [Vector2(-12,4),Vector2(18,-9),Vector2(-5,-22)][i]
		plant("BirchTree_Autumn_1" if i%2 else "BirchTree_Autumn_3",Vector3(p.x,ForestLandscape.height_at(p.x,p.y),p.y),8.5+i,i,0,"autumn")
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
		if item.material.resource_name.begins_with("Meadow"):
			n.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
		add_child(n)
	batches.clear()

func plant(asset: String, at: Vector3, height: float, yaw: float, layer := 0, role := "natural") -> void:
	var pack := "quaternius" if asset.begins_with("PineTree") or asset.begins_with("BirchTree") or asset in ["Bush_1","Rock_Moss_1"] else "nature"
	if asset.begins_with("tuft_"):
		pack = "meadow"
	var model := A.model(pack,asset,height)
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
	# Unequal shrub/rock anchors; grass and fern habitats are composed by ground_cover.gd.
	var centers := [Vector2(-11,5),Vector2(11,5),Vector2(-8,15),Vector2(10,12),Vector2(-15,-4),Vector2(16,-9)]
	for k in range(centers.size()):
		var center: Vector2=centers[k]
		for i in range(1+k%3):
			var p:=center+Vector2(rng.randf_range(-.8,.8),rng.randf_range(-.7,.7))
			plant("Bush_1",Vector3(p.x,ForestLandscape.height_at(p.x,p.y),p.y),rng.randf_range(.45,.95),rng.randf()*TAU,0,"autumn" if k==1 else "natural")
		for i in range(3):
			var bloom:=center+Vector2(rng.randf_range(-1.5,1.5),rng.randf_range(-1.1,1.1))
			if not ForestFloorDesign.reserved(bloom,.3):
				plant("flower_yellowA" if k%2 else "flower_purpleB",Vector3(bloom.x,ForestLandscape.height_at(bloom.x,bloom.y),bloom.y),.16,rng.randf()*TAU)
		var p:=center+Vector2(.8,.6)
		plant("Rock_Moss_1",Vector3(p.x,ForestLandscape.height_at(p.x,p.y)-.05,p.y),.55+k*.05,k)
	plant("stump_roundDetailed",Vector3(8,ForestLandscape.height_at(8,12),12),0.65,0.3)
	plant("log_stack",Vector3(-10,ForestLandscape.height_at(-10,0),0),0.7,0.5)
