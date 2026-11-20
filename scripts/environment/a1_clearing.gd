extends Node3D

const S = preload("res://scripts/world/shapes.gd")
const A = preload("res://scripts/world/field_assets.gd")
const STONES := [
	preload("res://assets/a1_house_gate/clearing_ledge.glb"),
	preload("res://assets/a1_house_gate/clearing_erratic.glb"),
	preload("res://assets/a1_house_gate/clearing_slab.glb"),
]
const FOOTPRINT := Rect2(-4.33,-3.0,8.0,5.90)
const PORCH := Rect2(-1.84,2.21,2.70,1.92)
const FENCE := Rect2(0.92,3.45,3.18,1.03)
const GRASS_CHUNK := 6.0
var rocks := PackedVector4Array()
var grass_chunks: Array[Dictionary] = []
var counts := [0,0,0]
var visual_batches: Dictionary = {}
var excluded_trunks := PackedVector3Array()

func _ready() -> void:
	build_stones()
	build_terrain()
	build_woodland()
	build_grass()

static func trail_x(z: float) -> float:
	return -0.49 + (z-3.6)*0.145 + smoothstep(9.0,20.0,z)*2.0*sin((z-9.0)*0.27)

static func sculpt(x: float, z: float) -> float:
	var p := Vector2(x,z)
	var clearing := smoothstep(0.94,1.62,maxf(absf(x+0.35)/4.8,absf(z-0.10)/5.4))
	var approach := 1.0 - (1.0-smoothstep(0.9,2.7,absf(x-trail_x(z)))) * smoothstep(2.1,3.1,z) * (1.0-smoothstep(9.1,12.8,z))
	var rise := 0.29*sin(x*.36+z*.18) + 0.19*cos(z*.43-x*.21)
	rise += 1.45*exp(-p.distance_squared_to(Vector2(-11.8,1.1))/40.0)
	rise += 1.62*exp(-p.distance_squared_to(Vector2(12.4,-3.8))/54.0)
	rise += 2.8*exp(-p.distance_squared_to(Vector2(-12.4,-15.4))/83.0)
	rise += 4.35*exp(-p.distance_squared_to(Vector2(15.2,-25.0))/155.0)
	rise += 2.5*exp(-p.distance_squared_to(Vector2(-20.0,-26.0))/96.0)
	return rise*clearing*approach

static func height(x: float,z: float) -> float:
	var ix := floorf(x)
	var iz := floorf(z)
	var tx := x-ix
	var tz := z-iz
	var a := sculpt(ix,iz)
	var b := sculpt(ix+1,iz)
	var c := sculpt(ix,iz+1)
	if tx+tz <= 1.0:
		return a+(b-a)*tx+(c-a)*tz
	var d := sculpt(ix+1,iz+1)
	return d+(c-d)*(1.0-tx)+(b-d)*(1.0-tz)

func build_terrain() -> void:
	var st := SurfaceTool.new()
	st.begin(Mesh.PRIMITIVE_TRIANGLES)
	for z in range(-43,32):
		for x in range(-42,42):
			var a := Vector3(x,sculpt(x,z),z)
			var b := Vector3(x+1,sculpt(x+1,z),z)
			var c := Vector3(x,sculpt(x,z+1),z+1)
			var d := Vector3(x+1,sculpt(x+1,z+1),z+1)
			for v in [a,b,c,b,d,c]:
				st.add_vertex(v)
	st.index()
	st.generate_normals()
	var earth := MeshInstance3D.new()
	earth.name = "ShapedClearingTerrain"
	earth.mesh = st.commit()
	earth.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	var mat := ShaderMaterial.new()
	mat.shader = preload("res://shaders/a1_house_yard.gdshader")
	mat.set_shader_parameter("rock_footprints", rocks)
	earth.material_override = mat
	add_child(earth)
	earth.create_trimesh_collision()

func build_stones() -> void:
	var groups := [
		["LeftForestEdge", [[0,-6.3,2.5,0.97,-0.46], [2,-4.95,3.54,0.82,0.17], [2,-7.25,1.46,0.67,0.76]]],
		["RightForestEdge", [[1,7.42,2.64,0.90,1.72], [0,8.6,1.92,0.67,1.22], [2,6.14,3.23,0.74,1.07]]],
		["RearForestEdge", [[0,5.5,-5.6,1.24,0.65], [2,6.86,-6.28,0.83,0.87]]],
	]
	var parent := Node3D.new()
	parent.name = "ForestEdgeBoulders"
	add_child(parent)
	for definition in groups:
		var cluster := Node3D.new()
		cluster.name = definition[0]
		parent.add_child(cluster)
		for spec in definition[1]:
			var x: float = spec[1]
			var z: float = spec[2]
			var scale_factor: float = spec[3]
			var at := Vector3(x,height(x,z)-0.13*scale_factor,z)
			var stone := STONES[spec[0]].instantiate() as Node3D
			cluster.add_child(stone)
			stone.position = at
			stone.rotation = Vector3(0.09*sin(x),spec[4],-0.09*cos(z))
			stone.scale = Vector3.ONE*scale_factor
			var span := (Vector2(1.56,1.02) if spec[0]==0 else (Vector2(1.23,0.97) if spec[0]==1 else Vector2(1.28,0.86)))*scale_factor
			rocks.append(Vector4(x,z,span.x,span.y))
			var body := S.box(cluster,at+Vector3.UP*(0.44*scale_factor),Vector3(span.x*1.26,scale_factor*1.14,span.y*1.34),"FFFFFF",true)
			body.rotation.y = spec[4]
			body.hide()

func grass_mask(p: Vector2) -> float:
	if FOOTPRINT.has_point(p) or PORCH.has_point(p) or FENCE.has_point(p):
		return 0.0
	for rock in rocks:
		if ((p-Vector2(rock.x,rock.y))/Vector2(rock.z*0.75,rock.w*0.74)).length_squared() < 1.0:
			return 0.0
	for trunk in excluded_trunks:
		if p.distance_squared_to(Vector2(trunk.x,trunk.y)) < trunk.z*trunk.z:
			return 0.0
	var edge := smoothstep(0.86,1.79,absf(p.x-trail_x(p.y))) if p.y>3.1 else 1.0
	return edge

func build_grass() -> void:
	var rng := RandomNumberGenerator.new()
	rng.seed = 15347
	var fields := FastNoiseLite.new()
	fields.seed = 6815
	fields.frequency = 0.22
	var mat := ShaderMaterial.new()
	mat.shader = preload("res://shaders/a1_clearing_grass.gdshader")
	var meshes: Array[ArrayMesh] = []
	for lod in range(2):
		for layer in range(3):
			meshes.append(grass_mesh(layer,lod == 1))
	for tx in range(-3,3):
		for tz in range(-3,3):
			var origin := Vector2(tx,tz)*GRASS_CHUNK
			var points: Array[Array] = [[],[],[]]
			for ix in range(15):
				for iz in range(15):
					var p := origin+(Vector2(ix,iz)+Vector2(rng.randf(),rng.randf()))*0.4
					var verge := grass_mask(p)
					var cluster := fields.get_noise_2dv(p)*0.5+0.5
					var patch := smoothstep(0.29,0.60,cluster)
					if rng.randf() > verge * (0.24+0.76*patch):
						continue
					var layer := 0
					if verge > 0.60 and p.length()>4.5 and cluster > .47:
						layer = 2 if cluster>.63 and rng.randf()<0.29 else 1
					var scaling := rng.randf_range(0.72,1.28)
					var pose := Transform3D(Basis(Vector3.UP,rng.randf()*TAU).scaled(
						Vector3(scaling,rng.randf_range(0.75,1.25),scaling)),
						Vector3(p.x,height(p.x,p.y)-0.018,p.y))
					points[layer].append([pose,Color(rng.randf(),patch,0,rng.randf())])
					counts[layer] += 1
			for layer in range(3):
				if points[layer].is_empty():
					continue
				var pair: Array[MultiMeshInstance3D] = []
				for lod in range(2):
					var mm := MultiMesh.new()
					mm.transform_format = MultiMesh.TRANSFORM_3D
					mm.use_custom_data = true
					mm.mesh = meshes[lod*3+layer]
					mm.instance_count = points[layer].size()
					for i in points[layer].size():
						mm.set_instance_transform(i,points[layer][i][0])
						mm.set_instance_custom_data(i, points[layer][i][1])
					var node := MultiMeshInstance3D.new()
					node.multimesh = mm
					node.material_override = mat
					node.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
					node.extra_cull_margin = 0.3
					add_child(node)
					node.hide()
					pair.append(node)
				grass_chunks.append({"center": origin+Vector2.ONE*3.0,"models":pair,"lod":-1})
	print("Clearing grass short/medium/high ",counts," batches ",grass_chunks.size())

func _process(_delta: float) -> void:
	var camera := get_viewport().get_camera_3d()
	if camera == null:
		return
	var at := Vector2(camera.global_position.x,camera.global_position.z)
	for tile in grass_chunks:
		var dist: float = at.distance_squared_to(tile.center)
		var lod := 0 if dist < (169.0 if tile.lod==0 else 144.0) else 1
		if dist > (961.0 if tile.lod>=0 else 900.0):
			lod = -1
		if tile.lod == lod:
			continue
		tile.models[0].visible = lod==0
		tile.models[1].visible = lod==1
		tile.lod = lod

func grass_mesh(layer: int, far: bool) -> ArrayMesh:
	var rng := RandomNumberGenerator.new()
	rng.seed = 937+layer*35
	var st := SurfaceTool.new()
	st.begin(Mesh.PRIMITIVE_TRIANGLES)
	var h: float = [0.13,0.29,0.52][layer]
	var count: int = [6,8,9][layer] if not far else [3,4,4][layer]
	for i in range(count):
		var angle := i*2.4+rng.randf_range(-0.25,0.25)
		var f := Vector3(cos(angle),0,sin(angle))
		var side := Vector3(-f.z,0,f.x)
		var base := f*rng.randf_range(0.028,0.158)
		var blade := h*rng.randf_range(0.61,1.16)
		var width := rng.randf_range(0.024,0.043)*(1.18 if layer==2 else 1.0)
		var arc := blade*rng.randf_range(0.32,0.88)
		var tip := base+f*arc+Vector3.UP*blade*0.87
		var middle := base+f*arc*0.37+Vector3.UP*blade*0.66
		if not far:
			tri(st,base-side*width*0.57,base+side*width*0.57,middle+side*width*0.71,0,0,0.64)
			tri(st,base-side*width*0.57,middle+side*width*0.71,middle-side*width*0.71,0,0.64,0.64)
			tri(st,middle-side*width*0.71,middle+side*width*0.71,tip,0.64,0.64,1)
		else:
			tri(st,base-side*width,base+side*width,tip,0,0,1)
	st.generate_normals()
	return st.commit()

func tri(st: SurfaceTool,a: Vector3,b: Vector3,c: Vector3,p: float,q: float,r: float) -> void:
	st.set_color(Color(p,0,0))
	st.add_vertex(a)
	st.set_color(Color(q,0,0))
	st.add_vertex(b)
	st.set_color(Color(r,0,0))
	st.add_vertex(c)

func build_woodland() -> void:
	# Main sightline is open; branches frame the clearing from its sides.
	var trees := [
		["BirchTree_Autumn_3","quaternius",-10.7,2.6,8.4,"autumn"],
		["PineTree_3","quaternius",-8.9,-3.3,10.6,"sage"],
		["tree_oak_fall","nature",8.9,-4.9,9.1,"autumn"],
		["PineTree_2","quaternius",12.6,1.0,10.8,"spruce"],
		["BirchTree_Autumn_1","quaternius",-13.1,-4.6,10.1,"russet"],
		["PineTree_4","quaternius",12.6,-8.7,6.8,"sage"],
		["PineTree_5","quaternius",-4.8,-8.1,7.2,"cedar"],
		["BirchTree_Autumn_3","quaternius",1.13,-10.9,9.6,"autumn"],
		["PineTree_2","quaternius",5.0,-11.6,12.8,"spruce"],
		["PineTree_1","quaternius",-0.7,-15.0,10.1,"sage"],
		["PineTree_4","quaternius",-10.0,-11.1,8.6,"spruce"],
		["BirchTree_Autumn_1","quaternius",14.7,6.5,7.2,"autumn"],
		["PineTree_3","quaternius",-13.8,8.4,7.4,"sage"],
		["PineTree_1","quaternius",15.9,-1.9,7.7,"sage"],
	]
	for i in trees.size():
		var t: Array = trees[i]
		var at := Vector3(t[2],height(t[2],t[3])-0.07,t[3])
		queue_plant(t[1],t[0],at,t[4],i*1.79,t[5], i in [0,1,2,3,6,7])
		excluded_trunks.append(Vector3(at.x,at.z,0.48))
		S.box(self,at+Vector3.UP*1.0,Vector3(0.64,2.0,0.64),"FFFFFF",true).hide()
	var rng := RandomNumberGenerator.new()
	rng.seed = 4288
	for i in range(43):
		var x := -31.0 + (i%15)*4.25 + rng.randf_range(-1.7,1.7)
		var z := -17.2-8.1*floorf(i/15.0)+rng.randf_range(-2.0,2.0)
		var size := 7.2+rng.randf()*5.2
		queue_plant("quaternius",["PineTree_1","PineTree_3","PineTree_4","PineTree_5"][i%4],
			Vector3(x,height(x,z)-0.05,z),size,rng.randf()*TAU,"spruce" if i%3==0 else "sage",false)
	var pockets := [Vector2(-7.4,4.3),Vector2(-5.6,2.8),Vector2(7.6,4.4),Vector2(6.1,2.9),
		Vector2(-8.8,-1.7),Vector2(8.6,-1.9),Vector2(5.8,-7.0),Vector2(-10.4,6.3),Vector2(-4.5,8.3),
		Vector2(3.3,10),Vector2(-3.3,5.2),Vector2(3.7,5.6),Vector2(11.4,-4.2)]
	for i in pockets.size():
		var p: Vector2 = pockets[i]
		for j in range(4):
			var q := p+Vector2(cos(j*2.1),sin(j*2.1))*j*0.43
			var at := Vector3(q.x,height(q.x,q.y)-0.018,q.y)
			if j == 0:
				queue_plant("quaternius","Bush_1",at,0.68+(i%3)*0.13,i,"sage")
			elif j == 1:
				queue_plant("nature","grass_leafs",at,0.43,i,"sage",false)
			else:
				queue_plant("nature","flower_purpleB" if i%3==0 else "flower_yellowA",at,0.22+j*0.06,i+j,"natural",false)
	for batch in visual_batches.values():
		var mm := MultiMesh.new()
		mm.transform_format = MultiMesh.TRANSFORM_3D
		mm.mesh = batch.mesh
		mm.instance_count = batch.poses.size()
		for i in batch.poses.size():
			mm.set_instance_transform(i,batch.poses[i])
		var node := MultiMeshInstance3D.new()
		node.multimesh = mm
		node.material_override = batch.mat
		node.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_ON if batch.shadow else GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
		add_child(node)
	visual_batches.clear()

var plant_sources: Dictionary = {}

func queue_plant(pack: String, kind: String, at: Vector3, size: float, yaw: float, role: String, shadow := true) -> void:
	var key := kind+role
	if not plant_sources.has(key):
		var source := A.model(pack,kind,1.0)
		A.style(source,role)
		var parts: Array[Dictionary] = []
		read_plant(source,Transform3D.IDENTITY,parts)
		plant_sources[key] = parts
		source.free()
	var root := Transform3D(Basis(Vector3.UP,yaw).scaled(Vector3.ONE*size),at)
	var parts: Array = plant_sources[key]
	for i in parts.size():
		var part: Dictionary = parts[i]
		var tag := "%s:%d:%s" % [key,i,shadow]
		if not visual_batches.has(tag):
			var mat := part.mat as Material
			visual_batches[tag] = {"mesh":part.mesh,"mat":mat,"poses":[],"shadow":shadow}
		visual_batches[tag].poses.append(root*part.at)

func read_plant(node: Node, inherited: Transform3D, parts: Array[Dictionary]) -> void:
	var at := inherited
	if node is Node3D:
		at *= node.transform
	if node is MeshInstance3D:
		for i in range(node.mesh.get_surface_count()):
			var mesh := ArrayMesh.new()
			mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES,node.mesh.surface_get_arrays(i))
			parts.append({"mesh":mesh,"mat":node.get_active_material(i),"at":at})
	for child in node.get_children():
		read_plant(child,at,parts)
