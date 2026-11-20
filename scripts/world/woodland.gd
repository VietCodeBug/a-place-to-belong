extends Node3D
## Curated Map 01 woodland with foreground/midground/background separation,
## harmonious pine/sage/autumn color distribution, and preserved clearing sightlines.
const A = preload("res://scripts/world/field_assets.gd")
var rng := RandomNumberGenerator.new()
var batches: Dictionary = {}
const PINES := ["PineTree_1","PineTree_2","PineTree_3","PineTree_4","PineTree_5"]
const PINE_ROLES := ["natural","sage","spruce","cedar","natural"]
const TINTS := [
	Color(1.00, 1.00, 1.00, 0.13),
	Color(1.08, 1.05, 0.92, 0.37),
	Color(0.91, 0.99, 0.97, 0.61),
	Color(1.05, 0.98, 0.89, 0.83),
	Color(0.95, 1.04, 0.93, 0.29),
]

func _ready() -> void:
	rng.seed = 4816
	# 1. Preserved hero trees & trunk collisions framing the cafe clearing
	var heroes := [Vector3(-14,17,-7),Vector3(-12,16,-19),Vector3(12,18,-16),Vector3(20,15,-4),Vector3(-17,14,10)]
	var hero_roles := ["spruce","natural","sage","cedar","natural"]
	for i in range(heroes.size()):
		var p: Vector3 = heroes[i]
		var h := ForestLandscape.height_at(p.x,p.z)
		plant(PINES[i],Vector3(p.x,h,p.z),p.y,i*1.4,0,hero_roles[i],TINTS[i])
		trunk_collision(Vector3(p.x,h+p.y*0.2,p.z),p.y*0.4)

	# 2. Inner perimeter groves with varied heights & green-gold harmony (South/SE camera corridor kept open)
	var centers := [Vector2(-20,-12),Vector2(-21,0),Vector2(-22,17),Vector2(19,-19),Vector2(3,-24),Vector2(22,4)]
	for g in range(centers.size()):
		var count := 3 + g % 3
		for i in range(count):
			var a := i*2.3+g
			var p: Vector2 = centers[g]+Vector2(cos(a),sin(a))*sqrt(float(i))*2.45
			if in_camera_corridor(p):
				continue
			var role: String = PINE_ROLES[(g+i)%PINE_ROLES.size()]
			var tint: Color = TINTS[(g*2+i)%TINTS.size()]
			plant(PINES[(g+i)%5],Vector3(p.x,ForestLandscape.height_at(p.x,p.y),p.y),rng.randf_range(9.5,15.5),a,0,role,tint)

	# 3. Warm Early-Autumn focal accents (birches & fall oaks) breaking dark conifer masses
	var autumn_accents := [
		[Vector2(-12,4), "BirchTree_Autumn_1", 9.0, "autumn"],
		[Vector2(18,-9), "BirchTree_Autumn_3", 9.8, "autumn"],
		[Vector2(-5,-22), "BirchTree_Autumn_1", 10.4, "russet"],
		[Vector2(15.5,2.5), "BirchTree_Autumn_3", 8.4, "autumn"],
		[Vector2(-19,-5), "BirchTree_Autumn_1", 9.2, "russet"],
		[Vector2(8,-21), "tree_oak_fall", 9.6, "autumn"],
		[Vector2(-18.5,13.5), "BirchTree_Autumn_3", 8.6, "autumn"],
	]
	for idx in range(autumn_accents.size()):
		var item: Array = autumn_accents[idx]
		var pos2: Vector2 = item[0]
		plant(item[1],Vector3(pos2.x,ForestLandscape.height_at(pos2.x,pos2.y),pos2.y),float(item[2]),idx*1.15,0,item[3],TINTS[idx%TINTS.size()])

	# 4. Midground forest ring (r ~ 34..62m) wrapping W, NW, N, NE, and E flanks
	# Leaves South & SE gameplay/review camera corridor completely open.
	for i in range(42):
		var t := float(i) / 41.0
		var a := lerpf(2.38, TAU + 0.30, t)
		var radius := 36.0 + 11.0 * sin(i * 1.9) + 6.0 * cos(i * 0.7)
		var p := Vector2(cos(a) * radius * 1.08, sin(a) * radius * 0.92 - 5.0)
		if in_camera_corridor(p):
			continue
		var layer := 1 if radius < 45.0 else 2
		var role: String = PINE_ROLES[i % PINE_ROLES.size()]
		if i % 7 == 3:
			plant("BirchTree_Autumn_1" if i%2==0 else "BirchTree_Autumn_3",Vector3(p.x,ForestLandscape.height_at(p.x,p.y),p.y),rng.randf_range(9.5,13.5),a,1,"autumn",TINTS[i%TINTS.size()])
		else:
			plant(PINES[i%5],Vector3(p.x,ForestLandscape.height_at(p.x,p.y),p.y),rng.randf_range(12.5,18.5),a,layer,role,TINTS[i%TINTS.size()])

	# 5. Far foothill treeline (r ~ 64..98m) anchoring hills into distant mountain ridges
	for i in range(48):
		var a := float(i) / 48.0 * TAU
		# Keep trees shorter in SE saddle so aerial review shots view over their tops cleanly
		var in_se := exp(-pow(wrapf(a - 0.80, -PI, PI), 2.0) / 0.18)
		var radius := lerpf(74.0, 94.0, 0.5 + 0.5 * sin(i * 2.7 + 0.4)) + in_se * 18.0
		var p := Vector2(cos(a) * radius, sin(a) * radius - 6.0)
		var h_tree := lerpf(rng.randf_range(13.5, 19.2), rng.randf_range(9.0, 12.0), in_se)
		plant(PINES[(i*2)%5],Vector3(p.x,ForestLandscape.height_at(p.x,p.y),p.y),h_tree,a*1.3,2,PINE_ROLES[i%5],TINTS[i%TINTS.size()])

	gardens()
	for item in batches.values():
		var mm := MultiMesh.new()
		mm.transform_format = MultiMesh.TRANSFORM_3D
		mm.use_custom_data = true
		mm.mesh = item.mesh
		mm.instance_count = item.transforms.size()
		for i in range(mm.instance_count):
			mm.set_instance_transform(i,item.transforms[i])
			mm.set_instance_custom_data(i,item.tints[i])
		var n := MultiMeshInstance3D.new()
		n.multimesh = mm
		n.material_override = item.material
		if item.material.resource_name.begins_with("Meadow"):
			n.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
		add_child(n)
	batches.clear()

func in_camera_corridor(p: Vector2) -> bool:
	return p.y > 12.0 and p.y < 54.0 and p.x > -15.5 and p.x < 34.0

func plant(asset: String, at: Vector3, height: float, yaw: float, layer := 0, role := "natural", tint := Color(1,1,1,0.5)) -> void:
	if height > 4.0 and ForestLandscape.in_overlook_view(at.x, at.z):
		return
	var pack := "quaternius" if asset.begins_with("PineTree") or asset.begins_with("BirchTree") or asset in ["Bush_1","Rock_Moss_1"] else "nature"
	if asset.begins_with("tuft_"):
		pack = "meadow"
	var model := A.model(pack,asset,height)
	A.style(model,role,layer)
	model.position = at
	model.rotation.y = yaw
	collect(model,Transform3D.IDENTITY,tint)
	model.free()

func collect(node: Node, inherited: Transform3D, tint: Color) -> void:
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
				batches[key] = {"mesh":mesh,"material":material,"transforms":[],"tints":[]}
			batches[key].transforms.append(transform)
			batches[key].tints.append(tint)
	for child in node.get_children():
		collect(child,transform,tint)

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
	# Authored shrub, mossy rock & wildflower edge clusters framing the path and cafe clearing
	var centers := [
		Vector2(-11,5),Vector2(11,5),Vector2(-8,15),Vector2(10,12),
		Vector2(-15,-4),Vector2(16,-9),Vector2(-4.8,18.5),Vector2(6.8,16.2),
		Vector2(-13.5,12.5),Vector2(14.5,1.5)
	]
	for k in range(centers.size()):
		var center: Vector2=centers[k]
		if ForestFloorDesign.reserved(center, 0.8):
			continue
		for i in range(2+k%3):
			var p:=center+Vector2(rng.randf_range(-1.05,1.05),rng.randf_range(-.9,.9))
			if ForestFloorDesign.reserved(p, 0.55):
				continue
			var bush_role := "autumn" if k in [1,6] else ("sage" if k%2==0 else "natural")
			plant("Bush_1",Vector3(p.x,ForestLandscape.height_at(p.x,p.y),p.y),rng.randf_range(.48,1.05),rng.randf()*TAU,0,bush_role,TINTS[(k+i)%TINTS.size()])
		for i in range(4):
			var bloom:=center+Vector2(rng.randf_range(-1.6,1.6),rng.randf_range(-1.2,1.2))
			if not ForestFloorDesign.reserved(bloom,.45):
				var flower_asset := "flower_yellowA" if (k+i)%3==0 else ("flower_purpleB" if k%2==0 else "flower_redC")
				plant(flower_asset,Vector3(bloom.x,ForestLandscape.height_at(bloom.x,bloom.y),bloom.y),rng.randf_range(.15,.22),rng.randf()*TAU)
		var p:=center+Vector2(.85,.6)
		if not ForestFloorDesign.reserved(p, 0.5):
			plant("Rock_Moss_1",Vector3(p.x,ForestLandscape.height_at(p.x,p.y)-.06,p.y),.58+(k%4)*.14,k*1.1)

	# Larger perimeter anchor boulders nestled into tree edges (visual grounding, outside walking routes)
	var boulders := [
		[Vector2(-15.8,-5.5),"rock_largeA",1.15,0.4],
		[Vector2(17.5,-6.2),"rock_largeB",1.25,1.9],
		[Vector2(-18.2,8.4),"rock_largeA",0.95,2.6],
		[Vector2(13.8,14.2),"Rock_Moss_1",0.92,0.8],
		[Vector2(-11.2,-16.5),"rock_largeB",1.35,1.2],
	]
	for b in boulders:
		var bp: Vector2 = b[0]
		plant(b[1],Vector3(bp.x,ForestLandscape.height_at(bp.x,bp.y)-0.12,bp.y),float(b[2]),float(b[3]),0,"warm_stone")

	plant("stump_roundDetailed",Vector3(8,ForestLandscape.height_at(8,12),12),0.65,0.3)
	plant("log_stack",Vector3(-10,ForestLandscape.height_at(-10,0),0),0.7,0.5)
