extends Node3D
## Deterministic clustered woodland; repeated geometry is GPU-instanced by mesh/color.
const S = preload("res://scripts/world/shapes.gd")
@export var palette: ForestPalette = preload("res://assets/palettes/early_autumn.tres")
var rng := RandomNumberGenerator.new()
var batches: Dictionary = {}
var crowns: Array[Mesh] = []
var pebble: ArrayMesh
var tuft: ArrayMesh
var trunk: CylinderMesh
var tree_counts := [0,0,0]
var silhouette_counts := [0,0,0]

func _ready() -> void:
	rng.seed = 4816
	for variant in range(3):
		crowns.append(crown_mesh(variant))
	pebble = rock_mesh()
	trunk = CylinderMesh.new()
	trunk.radial_segments = 7
	trunk.top_radius = 0.65
	trunk.bottom_radius = 1
	trunk.height = 1
	tuft = grass_mesh()
	plant_forest()
	plant_gardens()
	for batch in batches.values():
		var mm := MultiMesh.new()
		mm.transform_format = MultiMesh.TRANSFORM_3D
		mm.mesh = batch.mesh
		mm.instance_count = batch.transforms.size()
		for i in range(mm.instance_count):
			mm.set_instance_transform(i,batch.transforms[i])
		var instance := MultiMeshInstance3D.new()
		instance.multimesh = mm
		instance.material_override = S.material(batch.color)
		if batch.mesh == tuft:
			instance.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
		add_child(instance)
	batches.clear()

func stamp(shape: Mesh, p: Vector3, size: Vector3, color: Color, yaw := 0.0) -> void:
	var key := str(shape.get_instance_id()) + color.to_html()
	if not batches.has(key):
		batches[key] = {"mesh":shape,"color":color.to_html(),"transforms":[]}
	batches[key].transforms.append(Transform3D(Basis(Vector3.UP,yaw).scaled(size),p))

func triangle(st: SurfaceTool, a: Vector3, b: Vector3, c: Vector3) -> void:
	st.add_vertex(a)
	st.add_vertex(c)
	st.add_vertex(b)

func crown_mesh(variant: int) -> ArrayMesh:
	var st := SurfaceTool.new()
	st.begin(Mesh.PRIMITIVE_TRIANGLES)
	st.set_smooth_group(-1)
	# Scalloped bough skirts, irregular shoulders and an off-axis tip.
	var rings: Array[PackedVector3Array] = []
	for row in range(4):
		var ring := PackedVector3Array()
		for j in range(9):
			var angle := j*TAU/9
			var radius: float = [0.35,1.0,0.65,0.035][row]
			radius *= 1.0+sin(j*2.7+variant)*0.16
			var y: float = [0.0,0.12,0.53,1.0][row]
			if row == 1:
				y += (j%2)*0.06
			var lean := y*0.18 if variant == 2 else 0.0
			ring.append(Vector3(cos(angle)*radius+lean,y,sin(angle)*radius))
		rings.append(ring)
	for row in range(3):
		for j in range(9):
			var k := (j+1)%9
			triangle(st,rings[row][j],rings[row+1][j],rings[row][k])
			triangle(st,rings[row][k],rings[row+1][j],rings[row+1][k])
	st.generate_normals()
	return st.commit()

func grass_mesh() -> ArrayMesh:
	var st := SurfaceTool.new()
	st.begin(Mesh.PRIMITIVE_TRIANGLES)
	st.set_smooth_group(-1)
	for j in range(3):
		var a := j*TAU/3
		var side := Vector3(cos(a),0,sin(a))*0.14
		var tip := Vector3(sin(a)*0.15,0.6,cos(a)*0.1)
		triangle(st,-side,tip,side)
		triangle(st,side,tip,-side)
	st.generate_normals()
	return st.commit()

func tree(p: Vector3, category: int, variant: int, depth_layer := 0, autumn := false) -> void:
	tree_counts[category] += 1
	silhouette_counts[variant] += 1
	var height: float = [6.8,9.2,12.0][category]*rng.randf_range(0.9,1.1)
	var width: float = [1.65,2.05,2.5][category]
	if variant == 1:
		width *= 1.22
	var bark := Color("79644D") if depth_layer == 0 else Color("657F78")
	stamp(trunk,p+Vector3.UP*height*0.29,Vector3(0.25,height*0.58,0.25),bark)
	if depth_layer == 0:
		var body := StaticBody3D.new()
		var c := CollisionShape3D.new()
		var shape := CylinderShape3D.new()
		shape.radius = 0.3
		shape.height = height*0.6
		c.shape = shape
		body.add_child(c)
		add_child(body)
		body.position = p+Vector3.UP*height*0.3
	var tiers := (4 if variant == 0 else 3) if depth_layer == 0 else 2
	for tier in range(tiers):
		var t := float(tier)/tiers
		var color := palette.pine if tier%2 == 0 else palette.pine_light
		if autumn:
			color = palette.gold.lerp(palette.pine_light,0.18+0.12*(tier%2))
		if depth_layer > 0:
			color = color.lerp(Color("7F9B99"),0.12 if depth_layer == 1 else 0.32)
		var at := p+Vector3(sin(tier*2.1)*0.14,height*(0.20+t*0.53),0)
		stamp(crowns[variant],at,Vector3(width*(1-t*0.68),height*0.38,width*(1-t*0.68)),color,rng.randf_range(0,TAU))

func plant_forest() -> void:
	# Near wings, then separated middle groves and a reduced-detail far ridge.
	# The central roof corridor (-9..9, z -7..-22) is deliberately left empty.
	var near := [Vector2(-15,-6),Vector2(-19,3),Vector2(-21,15),Vector2(16,-7),Vector2(23,-17),Vector2(4,-19)]
	for cluster in range(near.size()):
		for j in range(6):
			var a := j*2.4+cluster*0.6
			var r := sqrt(float(j))*1.5
			var v: Vector2 = near[cluster]+Vector2(cos(a),sin(a))*r
			tree(Vector3(v.x,0,v.y),(j+cluster)%3,(j+cluster*2)%3,0,(j+cluster*3)%9 == 0)
	var middle := [Vector2(-31,-23),Vector2(-17,-28),Vector2(1,-29),Vector2(17,-31),Vector2(32,-23)]
	for cluster in range(middle.size()):
		wooded_mound(middle[cluster],Vector2(12,10),2.0,Color("6C8577"))
		for j in range(7):
			var a := j*2.4+cluster
			var r := sqrt(float(j))*2.1
			var v: Vector2 = middle[cluster]+Vector2(cos(a),sin(a))*r
			var height := mound_height(v,middle[cluster],Vector2(12,10),2.0)
			tree(Vector3(v.x,height,v.y),j%3,(j+cluster)%3,1)
	wooded_mound(Vector2(0,-53),Vector2(70,17),3.0,Color("708C87"))
	for j in range(28):
		var x := -57+j*4.3
		var z := -51+sin(j*0.73)*5.5
		tree(Vector3(x,mound_height(Vector2(x,z),Vector2(0,-53),Vector2(70,17),3.0),z),1+j%2,j%3,2)

func plant_gardens() -> void:
	# Asymmetric vignettes frame the café and the two bottom corners of the play view.
	var gardens := [Vector3(-7,0,3),Vector3(-8,0,7),Vector3(6.8,0,0),Vector3(7.5,0,4),Vector3(-9,0,16),Vector3(5.2,0,14),Vector3(10,0,18),Vector3(13,0,10)]
	for index in range(gardens.size()):
		var center: Vector3 = gardens[index]
		var foreground := index >= 4
		for j in range(65 if foreground else 45):
			var a := rng.randf_range(0,TAU)
			var r := sqrt(rng.randf())*(2.3 if foreground else 1.7)
			var p: Vector3 = center+Vector3(cos(a)*r,0.04,sin(a)*r)
			if ClearingLayout.on_path(p,0.3):
				continue
			var color := palette.pine_light if foreground else palette.meadow
			stamp(tuft,p,Vector3.ONE*rng.randf_range(0.7,1.65 if foreground else 1.1),color if j%5 else palette.gold,a)
			if j%7 == 0:
				stamp(pebble,p+Vector3.UP*0.45,Vector3(0.21,0.11,0.21),palette.flowers)
		for j in range(3):
			var p: Vector3 = center+Vector3(j*0.65-0.5,0,cos(j)*0.6)
			stamp(pebble,p+Vector3.UP*0.3,Vector3(1.2,0.85,1.0),Color("80877B"),j)
			for k in range(3):
				stamp(pebble,p+Vector3(k*0.35,0.5,-0.8),Vector3(1.05,0.95,0.9),palette.pine if foreground else ([palette.gold,palette.pine_light,palette.rust][j%3]),k)
	# Sparse scalloped verge growth follows the same tapering curve as the road.
	for j in range(260):
		var z := rng.randf_range(2.9,23.5)
		var side := 1.0 if j%2 else -1.0
		var x := ClearingLayout.path_center(z)+side*(ClearingLayout.path_half_width(z)+rng.randf_range(0.1,0.75))
		var p := Vector3(x,0.055,z)
		if j%3 == 0:
			stamp(tuft,p,Vector3.ONE*rng.randf_range(0.25,0.65),palette.meadow,j)
		else:
			stamp(pebble,p,Vector3(0.16,0.025,0.09),palette.gold if j%4 else palette.rust,j)

func rock_mesh() -> ArrayMesh:
	var st := SurfaceTool.new()
	st.begin(Mesh.PRIMITIVE_TRIANGLES)
	st.set_smooth_group(-1)
	var ring := PackedVector3Array()
	for j in range(7):
		var a := j*TAU/7
		ring.append(Vector3(cos(a)*0.5,0.03+sin(j*2.7)*0.09,sin(a)*0.48))
	for j in range(7):
		var k := (j+1)%7
		triangle(st,ring[j],Vector3(0.09,0.5,-0.07),ring[k])
		triangle(st,ring[k],Vector3(-0.06,-0.4,0.03),ring[j])
	st.generate_normals()
	return st.commit()

func mound_height(p: Vector2, center: Vector2, radius: Vector2, height: float) -> float:
	return -0.55+height*maxf(0.0,1.0-((p-center)/radius).length())

func wooded_mound(center: Vector2, radius: Vector2, height: float, color: Color) -> void:
	var st := SurfaceTool.new()
	st.begin(Mesh.PRIMITIVE_TRIANGLES)
	st.set_smooth_group(-1)
	for i in range(20):
		var a := i*TAU/20
		var b := (i+1)*TAU/20
		var p := Vector3(center.x,-0.55+height,center.y)
		var v := Vector3(center.x+cos(a)*radius.x,-0.55,center.y+sin(a)*radius.y)
		var w := Vector3(center.x+cos(b)*radius.x,-0.55,center.y+sin(b)*radius.y)
		triangle(st,p,w,v)
	st.generate_normals()
	var n := S.mesh(self,st.commit(),Vector3.ZERO,color.to_html())
	n.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
