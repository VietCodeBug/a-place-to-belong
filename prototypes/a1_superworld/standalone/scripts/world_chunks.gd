class_name A1WorldChunks
extends Node3D
## 4 km x 4 km world, streaming terrain and low-poly vegetation around player.
const GEN = preload("res://scripts/world_gen.gd")
const CHUNK_SIZE := 128.0
const ACTIVE_RADIUS := 4
const PHYSICS_RADIUS := 2
const BUILDS_PER_FRAME := 2
var generator: A1WorldGen
var target: Node3D
var season := 1
var chunks := {}
var accumulator := 0.0
var terrain_material: StandardMaterial3D
var wood_material: StandardMaterial3D
var leaf_materials: Array[StandardMaterial3D] = []
var grass_material: StandardMaterial3D
var rock_material: StandardMaterial3D
var trunk_mesh: CylinderMesh
var pine_mesh: CylinderMesh
var broad_mesh: SphereMesh
var bush_mesh: SphereMesh
var rock_mesh: SphereMesh

func setup(g: A1WorldGen, player:Node3D) -> void:
	generator = g
	target = player
	terrain_material = StandardMaterial3D.new()
	terrain_material.vertex_color_use_as_albedo = true
	terrain_material.roughness = 1.0
	wood_material = StandardMaterial3D.new()
	wood_material.albedo_color = Color("816a50")
	wood_material.roughness=1.0
	grass_material = StandardMaterial3D.new()
	grass_material.albedo_color = Color("7da468")
	grass_material.roughness=1.0
	rock_material = StandardMaterial3D.new()
	rock_material.albedo_color = Color("9da79b")
	rock_material.roughness=.95
	trunk_mesh = CylinderMesh.new()
	trunk_mesh.height=4.0
	trunk_mesh.top_radius=.24
	trunk_mesh.bottom_radius=.38
	trunk_mesh.radial_segments=7
	pine_mesh = CylinderMesh.new()
	pine_mesh.height=6.5
	pine_mesh.top_radius=.04
	pine_mesh.bottom_radius=2.35
	pine_mesh.radial_segments=8
	broad_mesh = SphereMesh.new()
	broad_mesh.radius=2.75
	broad_mesh.height=5.2
	broad_mesh.radial_segments=9
	broad_mesh.rings=5
	bush_mesh = SphereMesh.new()
	bush_mesh.radius=.65
	bush_mesh.height=.7
	bush_mesh.radial_segments=6
	bush_mesh.rings=3
	rock_mesh = SphereMesh.new()
	rock_mesh.radius=1.0
	rock_mesh.height=1.4
	rock_mesh.radial_segments=7
	rock_mesh.rings=4
	update_palette()

func update_palette() -> void:
	leaf_materials.clear()
	var cols: Array = [
		["c7a052","a37842","879a67","6e8367"],
		["8fc47a","78a966","99c889","699e78"],
		["598f58","427d4e","7ba25e","608c72"],
		["719b92","8aa6a4","acc0b6","537d70"]
	][season]
	for c in cols:
		var mat := StandardMaterial3D.new()
		mat.albedo_color=Color(c)
		mat.roughness=.96
		leaf_materials.append(mat)

func set_season(next_season:int) -> void:
	season = posmod(next_season,4)
	update_palette()
	var current := chunks.keys()
	for coord in current:
		var item: Node3D = chunks[coord]
		if is_instance_valid(item): item.queue_free()
	chunks.clear()
	ensure_spawn()

func chunk_of(p: Vector3) -> Vector2i:
	return Vector2i(floori(p.x/CHUNK_SIZE),floori(p.z/CHUNK_SIZE))

func ensure_spawn() -> void:
	var c := chunk_of(target.global_position)
	for dx in range(-1,2):
		for dz in range(-1,2):
			make_chunk(c+Vector2i(dx,dz),true)

func _process(delta:float) -> void:
	if generator==null or target==null: return
	accumulator+=delta
	if accumulator<.20: return
	accumulator=0.0
	var center := chunk_of(target.global_position)
	var doomed := chunks.keys()
	for coord in doomed:
		var offset: Vector2i=coord-center
		if maxi(absi(offset.x),absi(offset.y)) > ACTIVE_RADIUS+1:
			var n:Node3D=chunks[coord]
			if is_instance_valid(n): n.queue_free()
			chunks.erase(coord)
	# Keep the entire near physics ring ready before filling more scenery.
	for coord: Vector2i in chunks.keys():
		var offset := coord-center
		var node: Node3D = chunks[coord]
		var collider := node.get_node_or_null("TerrainBody")
		var nearby := maxi(absi(offset.x),absi(offset.y))<=PHYSICS_RADIUS
		if nearby and collider==null:
			enable_collision(node)
		elif not nearby and collider!=null:
			node.remove_child(collider)
			collider.queue_free()
	var added := 0
	for radius in range(ACTIVE_RADIUS+1):
		for x in range(-radius,radius+1):
			for z in range(-radius,radius+1):
				if maxi(absi(x),absi(z))!=radius: continue
				if added>=BUILDS_PER_FRAME: return
				var coord := center+Vector2i(x,z)
				if chunks.has(coord): continue
				if make_chunk(coord,radius<=PHYSICS_RADIUS): added+=1

func enable_collision(chunk: Node3D) -> void:
	var terrain: MeshInstance3D = chunk.get_node("Terrain")
	var body := StaticBody3D.new()
	body.name = "TerrainBody"
	var shape := CollisionShape3D.new()
	shape.shape = terrain.mesh.create_trimesh_shape()
	body.add_child(shape)
	chunk.add_child(body)

func make_chunk(coord:Vector2i,solid:bool) -> bool:
	if chunks.has(coord): return false
	var startx:=float(coord.x)*CHUNK_SIZE
	var startz:=float(coord.y)*CHUNK_SIZE
	if startx >= GEN.HALF or startx+CHUNK_SIZE <= -GEN.HALF or startz >= GEN.HALF or startz+CHUNK_SIZE <= -GEN.HALF:
		return false
	var chunk := Node3D.new()
	chunk.name = "Chunk_%s_%s"%[coord.x,coord.y]
	add_child(chunk)
	chunks[coord]=chunk
	var step := 8.0
	var samples := int(CHUNK_SIZE/step)
	var vertices := PackedVector3Array()
	var colors := PackedColorArray()
	for a in range(samples):
		for b in range(samples):
			var x:=startx+a*step
			var z:=startz+b*step
			var v00:=Vector3(x,generator.terrain_height(x,z),z)
			var v10:=Vector3(x+step,generator.terrain_height(x+step,z),z)
			var v01:=Vector3(x,generator.terrain_height(x,z+step),z+step)
			var v11:=Vector3(x+step,generator.terrain_height(x+step,z+step),z+step)
			for v in [v00,v01,v10,v10,v01,v11]:
				vertices.append(v)
				colors.append(ground_color(v.x,v.z,v.y))
	var surface := SurfaceTool.new()
	surface.begin(Mesh.PRIMITIVE_TRIANGLES)
	for i in vertices.size():
		surface.set_color(colors[i])
		surface.add_vertex(vertices[i])
	surface.generate_normals()
	var mesh := surface.commit()
	var render := MeshInstance3D.new()
	render.name="Terrain"
	render.mesh=mesh
	render.material_override=terrain_material
	render.cast_shadow=GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	chunk.add_child(render)
	if solid:
		enable_collision(chunk)
	place_vegetation(chunk,coord)
	return true

func ground_color(x:float,z:float,y:float) -> Color:
	var c:=generator.surface_color(x,z)
	if y<GEN.WATER_LEVEL+3.0 and generator.lake_ratio(x,z)<1.2:
		c=Color("c0b88b")
	if season==0: c=c.lerp(Color("b1a274"),.20)
	if season==1: c=c.lerp(Color("a3b77c"),.11)
	if season==2: c=c.lerp(Color("518d67"),.08)
	if season==3: c=c.lerp(Color("dce9e9"),.77 if y>GEN.WATER_LEVEL+1 else .10)
	return c

func place_vegetation(node:Node3D,coord:Vector2i) -> void:
	var seed:=absi(coord.x*73856093 ^ coord.y*19349663) % 2147483647
	var rng := RandomNumberGenerator.new()
	rng.seed=seed+12345
	var wood_poses:=[]
	var pine_poses:=[]
	var leaf_poses:=[[],[],[],[]]
	var bush_poses:=[]
	var rock_poses:=[]
	for i in range(58):
		var x:=float(coord.x)*CHUNK_SIZE+rng.randf()*CHUNK_SIZE
		var z:=float(coord.y)*CHUNK_SIZE+rng.randf()*CHUNK_SIZE
		var h:=generator.terrain_height(x,z)
		if h>170.0:
			if rng.randf()<.15:
				rock_poses.append(Transform3D(Basis.IDENTITY.scaled(Vector3(3.0,1.8,2.8)),Vector3(x,h,z)))
			continue
		if not generator.can_plant_tree(x,z):
			if rng.randf()<.14 and generator.lake_ratio(x,z)>1.05:
				rock_poses.append(Transform3D(Basis.IDENTITY.scaled(Vector3(1.2,.5,1.0)),Vector3(x,h,z)))
			continue
		var species:=rng.randi_range(0,3)
		var sc:=rng.randf_range(.7,1.5)
		var yaw:=rng.randf()*TAU
		var trunk:=Transform3D(Basis(Vector3.UP,yaw).scaled(Vector3(sc,sc,sc)),Vector3(x,h+2.0*sc,z))
		wood_poses.append(trunk)
		if species==0 or (generator.biome(x,z)=="Rừng thông cao nguyên" and rng.randf()<.6):
			pine_poses.append(Transform3D(Basis(Vector3.UP,yaw).scaled(Vector3(sc,sc,sc)),Vector3(x,h+5.0*sc,z)))
		else:
			leaf_poses[species].append(Transform3D(Basis(Vector3.UP,yaw).scaled(Vector3(sc,sc,sc)),Vector3(x,h+5.7*sc,z)))
	for i in range(90):
		var x:=float(coord.x)*CHUNK_SIZE+rng.randf()*CHUNK_SIZE
		var z:=float(coord.y)*CHUNK_SIZE+rng.randf()*CHUNK_SIZE
		if generator.lake_ratio(x,z)<1.21 or absf(z-generator.river_z(x))<26.0:continue
		var h:=generator.terrain_height(x,z)
		if h>100.0 or rng.randf()<.12: continue
		var sc:=rng.randf_range(.45,1.65)
		bush_poses.append(Transform3D(Basis(Vector3.UP,rng.randf()*TAU).scaled(Vector3(sc,sc*.7,sc)),Vector3(x,h+.3*sc,z)))
	batch(node,"TreeTrunks",trunk_mesh,wood_material,wood_poses)
	batch(node,"PineCanopies",pine_mesh,leaf_materials[3],pine_poses)
	for i in range(4):
		batch(node,"TreeCanopy_%d"%i,broad_mesh,leaf_materials[i],leaf_poses[i])
	batch(node,"MeadowShrubs",bush_mesh,grass_material,bush_poses)
	batch(node,"LowPolyRocks",rock_mesh,rock_material,rock_poses)

func batch(node:Node3D,title:String,mesh:Mesh,material:Material,poses:Array) -> void:
	if poses.is_empty():return
	var multi:=MultiMesh.new()
	multi.transform_format=MultiMesh.TRANSFORM_3D
	multi.mesh=mesh
	multi.instance_count=poses.size()
	for i in range(poses.size()): multi.set_instance_transform(i,poses[i])
	var visuals:=MultiMeshInstance3D.new()
	visuals.name=title
	visuals.multimesh=multi
	visuals.material_override=material
	visuals.cast_shadow=GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	node.add_child(visuals)

func active_count() -> int:
	return chunks.size()
