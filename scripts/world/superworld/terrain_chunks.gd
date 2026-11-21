extends Node3D
## The near render mesh is the collision source. Distant meshes have no physics.
const FIELD = preload("res://scripts/world/superworld/terrain_field.gd")
const NEAR := 4
const SOLID := 2
const BUDGET_USEC := 2400
const MACRO := 512
const COARSE := 32
var field: FIELD
var target: Node3D
var chunks: Dictionary = {}
var solid: Dictionary = {}
var near_order: Array[Vector2i] = []
var previous := Vector2i(0xFFFF,0xFFFF)
var frame_build_usec := 0
var built_count := 0
var frame_tiles_changed := 0
var current_season := 1
var far_count := 0
var material := ShaderMaterial.new()
var pine_mesh: ArrayMesh
var flower_mesh: ArrayMesh
var flower_material := StandardMaterial3D.new()
var pine_material := StandardMaterial3D.new()

func setup(source: FIELD, player: Node3D) -> void:
	field = source
	target = player
	material.shader = preload("res://shaders/a1_streamed_land.gdshader")
	material.set_shader_parameter("lake_center",FIELD.LAKE)
	material.set_shader_parameter("lake_radii",FIELD.RADII)
	for r in range(NEAR+1):
		for x in range(-r,r+1):
			for z in range(-r,r+1):
				if maxi(absi(x),absi(z))==r:
					near_order.append(Vector2i(x,z))
	build_panorama()
	pine_material.albedo_color = Color("537258")
	pine_material.roughness = 1.0
	# One previously licensed tree proxy per group, populated after collision.
	var proxy := FieldAssets.model("quaternius","PineTree_2",11.0)
	pine_mesh = bake_tree(proxy)
	proxy.free()
	var flower := preload("res://environment/vegetation/scripts/meadow_meshes.gd").flower(false)
	flower_mesh = flower
	flower_material.cull_mode = BaseMaterial3D.CULL_DISABLED
	flower_material.albedo_color = Color("FFF1BB")
	flower_material.vertex_color_use_as_albedo = true
	flower_material.roughness = .96
	prepare_at(Vector2(target.position.x,target.position.z))

func build_panorama() -> void:
	# The atlas and panorama span the whole region. Chunks above it become physical.
	for x in range(int(field.bounds.position.x),int(field.bounds.end.x),MACRO):
		for z in range(int(field.bounds.position.y),int(field.bounds.end.y),MACRO):
			var visual := MeshInstance3D.new()
			visual.mesh = make_mesh(Vector2(x,z),MACRO,COARSE,8.0)
			visual.material_override = material
			visual.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
			add_child(visual)
			far_count += 1

func make_mesh(start: Vector2, width: int, step: int, sink: float = 0.0) -> ArrayMesh:
	var side := floori(float(width)/step)+1
	var vertices := PackedVector3Array()
	var colors := PackedColorArray()
	var normals := PackedVector3Array()
	var indices := PackedInt32Array()
	# Each corner is shared by several normals. Sample one padded lattice
	# for both heights and central differences instead of evaluating corners five times.
	var padded := side+2
	var heights := PackedFloat32Array()
	heights.resize(padded*padded)
	for row in padded:
		for column in padded:
			heights[row*padded+column] = field.vertex(start+Vector2(column-1,row-1)*step)
	for row in side:
		for column in side:
			var p := start+Vector2(column,row)*step
			var index := (row+1)*padded+column+1
			var y := heights[index]
			var hx := heights[index+1]-heights[index-1]
			var hz := heights[index+padded]-heights[index-padded]
			vertices.append(Vector3(p.x,y-sink,p.y))
			normals.append(Vector3(-hx,2.0*step,-hz).normalized())
			colors.append(field.ground_color(p,y))
	for row in range(side-1):
		for column in range(side-1):
			var a := row*side+column
			var c := a+side
			if sink > 0.0 and FIELD.CORE.has_point(start+Vector2(column+.5,row+.5)*step):
				continue
			indices.append_array([a,a+1,c,a+1,c+1,c])
	var data := []
	data.resize(Mesh.ARRAY_MAX)
	data[Mesh.ARRAY_VERTEX] = vertices
	data[Mesh.ARRAY_NORMAL] = normals
	data[Mesh.ARRAY_COLOR] = colors
	data[Mesh.ARRAY_INDEX] = indices
	var output := ArrayMesh.new()
	output.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES,data)
	return output

func prepare_at(p: Vector2) -> void:
	var center := field.tile(p)
	clear_remote(center)
	for i in range(9):
		ensure(center+near_order[i],true)
	previous = center

func _process(_delta: float) -> void:
	if target == null:
		return
	var start := Time.get_ticks_usec()
	var center := field.tile(Vector2(target.position.x,target.position.z))
	if center != previous:
		clear_remote(center)
		previous = center
	frame_tiles_changed = 0
	for offset in near_order:
		var id := center+offset
		var needs_collision := maxi(absi(offset.x),absi(offset.y)) <= SOLID
		if ensure(id,needs_collision):
			frame_tiles_changed += 1
			if Time.get_ticks_usec()-start >= BUDGET_USEC:
				break
	frame_build_usec = int(Time.get_ticks_usec()-start)

func clear_remote(center: Vector2i) -> void:
	for id: Vector2i in solid.keys():
		var o := id-center
		if maxi(absi(o.x),absi(o.y)) > SOLID:
			var body: StaticBody3D = solid[id]
			body.get_parent().remove_child(body)
			body.queue_free()
			solid.erase(id)
	for id: Vector2i in chunks.keys():
		var o := id-center
		if maxi(absi(o.x),absi(o.y)) > NEAR+1:
			var chunk: MeshInstance3D = chunks[id]
			remove_child(chunk)
			chunk.queue_free()
			chunks.erase(id)

func ensure(id: Vector2i, collision: bool) -> bool:
	if not field.tile_valid(id) or field.is_core_tile(id):
		return false
	if not chunks.has(id):
		var chunk := MeshInstance3D.new()
		chunk.name = "Tile_%d_%d" % [id.x,id.y]
		chunk.mesh = make_mesh(Vector2(id)*field.chunk_size,field.chunk_size,int(FIELD.STEP))
		chunk.material_override = material
		chunk.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
		add_child(chunk)
		chunks[id] = chunk
		if collision:
			enable_collision(id)
		if pine_mesh != null:
			plant_trees(chunk,id)
			plant_meadow(chunk,id)
		built_count += 1
		return true
	if collision and not solid.has(id):
		enable_collision(id)
		return true
	return false

func enable_collision(id: Vector2i) -> void:
	var chunk: MeshInstance3D = chunks[id]
	var collider := CollisionShape3D.new()
	collider.shape = chunk.mesh.create_trimesh_shape()
	var body := StaticBody3D.new()
	body.add_child(collider)
	chunk.add_child(body)
	solid[id] = body

func set_season(index: int) -> void:
	current_season = index
	for chunk in chunks.values():
		var flowers := chunk.get_node_or_null("MeadowFlowers") as MultiMeshInstance3D
		if flowers != null:
			flowers.visible = index in [1,2]
	material.set_shader_parameter("season",index)
	pine_material.albedo_color = [Color("657958"),Color("5C7D50"),Color("4B7051"),Color("83968A")][index]

func bake_tree(proxy: Node3D) -> ArrayMesh:
	var builder := SurfaceTool.new()
	builder.begin(Mesh.PRIMITIVE_TRIANGLES)
	for item in proxy.find_children("*","MeshInstance3D",true,false):
		var mesh := item as MeshInstance3D
		var pose := mesh.transform
		var ancestor := mesh.get_parent_node_3d()
		while ancestor != proxy:
			pose = ancestor.transform*pose
			ancestor = ancestor.get_parent_node_3d()
		for i in mesh.mesh.get_surface_count():
			builder.append_from(mesh.mesh,i,pose)
	return builder.commit()

func plant_trees(chunk: MeshInstance3D, id: Vector2i) -> void:
	var rng := RandomNumberGenerator.new()
	rng.seed = id.x*73856093 ^ id.y*19349663
	var origins: Array[Transform3D] = []
	for i in range(22):
		var p := Vector2(id)*field.chunk_size+Vector2(rng.randf(),rng.randf())*field.chunk_size
		var y := field.height(p)
		if y > 135.0 or y < FIELD.WATER+1.2 or field.trail_distance(p)<5.0 or field.lake_ratio(p)<1.022:
			continue
		var meadow := p.distance_to(FIELD.MEADOW)<113.0
		if meadow and i%6!=0:
			continue
		if field.folds.get_noise_2d(p.x*2.3,p.y*2.3) < -.23:
			continue
		var scale_factor := rng.randf_range(.64,1.36)
		origins.append(Transform3D(Basis(Vector3.UP,rng.randf()*TAU).scaled(Vector3.ONE*scale_factor),Vector3(p.x,y,p.y)))
	if origins.is_empty():
		return
	var multi := MultiMesh.new()
	multi.transform_format = MultiMesh.TRANSFORM_3D
	multi.mesh = pine_mesh
	multi.instance_count = origins.size()
	for i in origins.size():
		multi.set_instance_transform(i,origins[i])
	var visual := MultiMeshInstance3D.new()
	visual.multimesh = multi
	visual.material_override = pine_material
	visual.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	visual.visibility_range_end = 290.0
	chunk.add_child(visual)


func plant_meadow(chunk: MeshInstance3D, id: Vector2i) -> void:
	var origin := Vector2(id)*field.chunk_size
	if origin.distance_to(FIELD.MEADOW)>187.0:
		return
	var rng := RandomNumberGenerator.new()
	rng.seed = (id.x*6413) ^ (id.y*941)
	var grid: PackedVector3Array = chunk.mesh.surface_get_arrays(0)[Mesh.ARRAY_VERTEX]
	var grid_width := int(field.chunk_size/FIELD.STEP)+1
	var positions: Array[Transform3D] = []
	var colors := PackedColorArray()
	for batch_id in 15:
		var center := origin+Vector2(rng.randf(),rng.randf())*field.chunk_size
		if center.distance_to(FIELD.MEADOW)>105.0 or field.trail_distance(center)<5.4:
			continue
		var tint: Color = [Color("FFF2C4"),Color("DDACDC"),Color("FFD678")][batch_id%3]
		for i in range(46):
			var p := center+Vector2.from_angle(rng.randf()*TAU)*sqrt(rng.randf())*2.7
			if field.tile(p)!=id:
				continue
			var local := (p-origin)/FIELD.STEP
			var corner := Vector2i(local.floor())
			var frac := local-Vector2(corner)
			var first := corner.y*grid_width+corner.x
			var b := grid[first+1].y
			var c := grid[first+grid_width].y
			var y: float
			if frac.x+frac.y<=1.0:
				var a := grid[first].y
				y = a+(b-a)*frac.x+(c-a)*frac.y
			else:
				var d := grid[first+grid_width+1].y
				y = d+(c-d)*(1.0-frac.x)+(b-d)*(1.0-frac.y)
			var pose := Basis(Vector3.UP,rng.randf()*TAU).scaled(Vector3.ONE*rng.randf_range(.82,1.44))
			positions.append(Transform3D(pose,Vector3(p.x,y,p.y)))
			colors.append(tint)
	if positions.is_empty():
		return
	var multi := MultiMesh.new()
	multi.transform_format = MultiMesh.TRANSFORM_3D
	multi.use_colors = true
	multi.mesh = flower_mesh
	multi.instance_count = positions.size()
	for i in positions.size():
		multi.set_instance_transform(i,positions[i])
		multi.set_instance_color(i,colors[i])
	var flower := MultiMeshInstance3D.new()
	flower.name = "MeadowFlowers"
	flower.multimesh = multi
	flower.material_override = flower_material
	flower.visible = current_season in [1,2]
	flower.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	flower.visibility_range_end = 68.0
	chunk.add_child(flower)
