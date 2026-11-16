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

func tree(p: Vector3, category: int, variant: int, distant := false, autumn := false) -> void:
	tree_counts[category] += 1
	silhouette_counts[variant] += 1
	var height: float = [6.8,9.2,12.0][category]*rng.randf_range(0.9,1.1)
	var width: float = [1.65,2.05,2.5][category]
	if variant == 1:
		width *= 1.22
	var bark := Color("79644D") if not distant else Color("81958A")
	stamp(trunk,p+Vector3.UP*height*0.29,Vector3(0.25,height*0.58,0.25),bark)
	if not distant:
		var body := StaticBody3D.new()
		var c := CollisionShape3D.new()
		var shape := CylinderShape3D.new()
		shape.radius = 0.3
		shape.height = height*0.6
		c.shape = shape
		body.add_child(c)
		add_child(body)
		body.position = p+Vector3.UP*height*0.3
	var tiers := 4 if variant == 0 else 3
	for tier in range(tiers):
		var t := float(tier)/tiers
		var color := palette.pine if tier%2 == 0 else palette.pine_light
		if autumn:
			color = palette.gold.lerp(palette.pine_light,0.18+0.12*(tier%2))
		if distant:
			color = color.lerp(palette.haze,0.42)
		var at := p+Vector3(sin(tier*2.1)*0.14,height*(0.20+t*0.53),0)
		stamp(crowns[variant],at,Vector3(width*(1-t*0.68),height*0.38,width*(1-t*0.68)),color,rng.randf_range(0,TAU))

func plant_forest() -> void:
	# Clumps frame an open café clearing; keep the southeast follow-camera corridor open.
	var centers := [Vector2(-14,-9),Vector2(-6,-15),Vector2(4,-16),Vector2(14,-12),Vector2(-17,2),Vector2(18,-3),Vector2(-18,13)]
	for cluster in range(centers.size()):
		for j in range(8):
			var a := j*2.4+cluster
			var r := sqrt(float(j))*1.6
			var v: Vector2 = centers[cluster]+Vector2(cos(a),sin(a))*r
			tree(Vector3(v.x,0,v.y),(j+cluster)%3,(j+cluster*2)%3,false,(j+cluster*3)%9 == 0)
	# Cool, staggered outer treeline, outside the playable boundary.
	for j in range(35):
		var p := Vector3(-38+(j%18)*4.4,-0.5,-28-floorf(j/18.0)*9)
		tree(p,1+j%2,j%3,true)
	for j in range(11):
		tree(Vector3(-29,0,-18+j*4),j%3,j%3,true)

func plant_gardens() -> void:
	# Organic islands, with clear walking space through the middle of the path.
	var gardens := [Vector3(-7,0,7),Vector3(-8,0,0),Vector3(7.5,0,0),Vector3(8,0,7),Vector3(-6,0,14),Vector3(6.5,0,15),Vector3(-11,0,-7),Vector3(11,0,-8),Vector3(-3,0,19)]
	for center in gardens:
		for j in range(80):
			var a := rng.randf_range(0,TAU)
			var r := sqrt(rng.randf())*2.8
			var p: Vector3 = center+Vector3(cos(a)*r,0.03,sin(a)*r)
			stamp(tuft,p,Vector3.ONE*rng.randf_range(0.4,1.3),palette.meadow if j%3 else palette.gold,a)
			if j%8 == 0:
				var bloom := palette.flowers if j%16 == 0 else palette.rust
				stamp(pebble,p+Vector3.UP*0.35,Vector3(0.17,0.09,0.17),bloom)
				stamp(tuft,p,Vector3(0.3,0.65,0.3),palette.pine_light,a)
		for j in range(4):
			var p: Vector3 = center+Vector3(rng.randf_range(-2,2),0,rng.randf_range(-2,2))
			stamp(pebble,p+Vector3.UP*0.25,Vector3(0.8,0.6,0.65),Color("969787"),j)
			for k in range(3):
				stamp(pebble,p+Vector3(k*0.25,0.5,-0.7),Vector3(0.8,0.8,0.75),palette.gold if j%3 == 0 else (palette.pine_light if j%3 == 1 else palette.rust),k)
	# Leaf litter hugs the verges, never covers the whole meadow.
	for j in range(190):
		var z := rng.randf_range(3,23)
		var x := sin(z*0.22)*2+(1 if j%2 else -1)*rng.randf_range(1.65,2.8)
		stamp(pebble,Vector3(x,0.045,z),Vector3(0.14,0.025,0.09),palette.gold if j%3 else palette.rust,j)

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
