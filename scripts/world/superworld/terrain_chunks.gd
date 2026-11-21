extends Node3D
## The near render mesh is the collision source. Distant meshes have no physics.
const COVER = preload("res://scripts/world/superworld/biome_cover.gd")
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
var cover: COVER
var frame_cover_jobs := 0
var frame_cover_usec := 0

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
	cover = COVER.new()
	cover.name = "HabitatCover"
	add_child(cover)
	cover.setup(field)
	build_panorama()
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
			var grid: PackedVector3Array = visual.mesh.surface_get_arrays(0)[Mesh.ARRAY_VERTEX]
			cover.populate_macro(visual,Vector2(x,z),MACRO,COARSE,grid)
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
	frame_cover_jobs = 0
	frame_cover_usec = 0
	for offset in near_order:
		var id := center+offset
		var needs_collision := maxi(absi(offset.x),absi(offset.y)) <= SOLID
		if ensure(id,needs_collision):
			frame_tiles_changed += 1
			if Time.get_ticks_usec()-start >= BUDGET_USEC:
				break
	if Time.get_ticks_usec()-start < BUDGET_USEC:
		var foliage_start := Time.get_ticks_usec()
		frame_cover_jobs = int(populate_next(center))
		frame_cover_usec = int(Time.get_ticks_usec()-foliage_start)
	frame_build_usec = int(Time.get_ticks_usec()-start)

func populate_next(center: Vector2i) -> bool:
	for offset in near_order:
		var id := center+offset
		if not chunks.has(id):
			continue
		var tile: MeshInstance3D = chunks[id]
		if not tile.has_node("Canopy"):
			cover.decorate(tile,id,-1)
			return true
		if maxi(absi(offset.x),absi(offset.y))<=2:
			for quarter in 4:
				if not tile.has_node("Verge%d" % quarter):
					cover.decorate(tile,id,quarter)
					return true
	return false

# Used by the deterministic screenshot runner to wait for the composed eye-level scene.
func prepare_review(p: Vector2) -> void:
	var center := field.tile(p)
	clear_remote(center)
	for offset in near_order:
		ensure(center+offset,maxi(absi(offset.x),absi(offset.y))<=SOLID)
	while populate_next(center):
		pass

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
			cover.forget(chunk)
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
	material.set_shader_parameter("season",index)
	cover.set_season(index)
