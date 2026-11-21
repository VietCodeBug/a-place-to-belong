extends Node3D
## The same seeded populations supply detailed and proxy trees. Terrain owns all ground levels.
const FIELD = preload("res://scripts/world/superworld/terrain_field.gd")
const BOTANY = preload("res://scripts/world/a1_botany.gd")
const MEADOW = preload("res://environment/vegetation/scripts/meadow_meshes.gd")
const GARDENS := "res://assets/vegetation/a1_gardens/"
const IDS := ["NormalTree_3","NormalTree_4","BirchTree_2","MapleTree_3","PineTree_1","PineTree_3"]
const PROXIES := ["tree_oak_fall","tree_pineRoundC","tree_pineTallA_detailed","tree_pineTallC_detailed"]
const MID := [0,0,0,0,2,3]
const FLOWERS := ["Flower_1","Flower_2","Flower_3_Clump","Flower_5_Clump"]
const DETAIL_RANGE := 94.0
var field: FIELD
var season := 1
var parts: Dictionary = {}
var proxy_meshes: Dictionary = {}
var proxy_material := ShaderMaterial.new()
var far_material := ShaderMaterial.new()
var grass_material := ShaderMaterial.new()
var grass: ArrayMesh
var short_grass: ArrayMesh
var rocks: Array[Array] = []
var winter_layers: Array[MultiMeshInstance3D] = []
var deciduous_layers: Array[MultiMeshInstance3D] = []
var tree_leaves: Array[MultiMeshInstance3D] = []

func setup(source: FIELD) -> void:
	field = source
	proxy_material.shader = preload("res://shaders/a1_forest_proxy.gdshader")
	far_material.shader = proxy_material.shader
	far_material.set_shader_parameter("panorama",true)
	grass = meadow_tuft()
	short_grass = MEADOW.grass(0,2,true)
	grass_material.shader = preload("res://environment/vegetation/shaders/dense_meadow.gdshader")
	grass_material.set_shader_parameter("lod_level",-1)
	grass_material.set_shader_parameter("wind_strength",.061)
	grass_material.set_shader_parameter("wind_direction",Vector2(.85,.52))
	for id in IDS:
		var node := BOTANY.instance(id,1.0)
		parts[id] = extract_parts(node)
		node.free()
	for id in FLOWERS:
		var node := BOTANY.instance(id,1.0,GARDENS)
		var floral := extract_parts(node)
		for part in floral:
			var previous: StandardMaterial3D = part[1]
			var soft := ShaderMaterial.new()
			soft.shader = preload("res://shaders/a1_meadow_flowers.gdshader")
			soft.set_shader_parameter("petals",previous.albedo_texture)
			soft.set_shader_parameter("tint",Color("EFDDD1") if id=="Flower_1" else Color("E3E0C6"))
			part[1] = soft
		parts[id] = floral
		node.free()
	var shrub := BOTANY.instance("Bush_Large",1.0)
	parts["Bush_Large"] = extract_parts(shrub)
	shrub.free()
	for id in ["rock_largeA","rock_largeB"]:
		var node := FieldAssets.model("nature",id,1.0)
		FieldAssets.style(node)
		var strata := ShaderMaterial.new()
		strata.shader = preload("res://shaders/a1_rock_surface.gdshader")
		strata.set_shader_parameter("stone_tint",Color("777261") if id=="rock_largeA" else Color("6E7369"))
		var model := extract_parts(node)
		for part in model:
			part[1] = strata
		rocks.append(model)
		node.free()
	for id in PROXIES:
		var node := FieldAssets.model("nature",id,1.0)
		var builder := SurfaceTool.new()
		builder.begin(Mesh.PRIMITIVE_TRIANGLES)
		for visual in node.find_children("*","MeshInstance3D",true,false):
			for i in visual.mesh.get_surface_count():
				builder.append_from(visual.mesh,i,relative_pose(visual,node))
		proxy_meshes[id] = builder.commit()
		node.free()
	set_season(season)

func meadow_tuft() -> ArrayMesh:
	var rng := RandomNumberGenerator.new()
	rng.seed = 42864
	var vertices := PackedVector3Array()
	var colors := PackedColorArray()
	for i in 11:
		var a := TAU*i*.618034
		var out := Vector3(cos(a),0,sin(a))
		var n := out.cross(Vector3.UP)
		var base := out*rng.randf_range(.015,.27)
		var rise := rng.randf_range(.16,.31)
		var bend := rng.randf_range(.055,.26)
		var width := rng.randf_range(.009,.021)
		var shoulder := base + Vector3.UP*rise*.60 + out*bend*.28
		var tip := base + Vector3.UP*rise + out*bend
		var left := shoulder-n*width*.60
		var right := shoulder+n*width*.60
		MEADOW.triangle(vertices,colors,base-n*width,base+n*width,left,0,0,.58)
		MEADOW.triangle(vertices,colors,base+n*width,right,left,0,.58,.58)
		MEADOW.triangle(vertices,colors,left,right,tip,.58,.58,1)
	return MEADOW.finish(vertices,colors)

func relative_pose(visual: Node3D, root: Node3D) -> Transform3D:
	var pose := visual.transform
	var parent := visual.get_parent_node_3d()
	while parent != root:
		pose = parent.transform*pose
		parent = parent.get_parent_node_3d()
	return pose

func extract_parts(root: Node3D) -> Array:
	var result := []
	for item in root.find_children("*","MeshInstance3D",true,false):
		var visual := item as MeshInstance3D
		for index in visual.mesh.get_surface_count():
			var source := visual.mesh.surface_get_material(index)
			var label := source.resource_name if source != null else ""
			var output := SurfaceTool.new()
			output.create_from(visual.mesh,index)
			var separate := output.commit()
			result.append([separate,visual.get_active_material(index),relative_pose(visual,root),label])
	return result

func set_season(index: int) -> void:
	season = index
	proxy_material.set_shader_parameter("season",index)
	far_material.set_shader_parameter("season",index)
	grass_material.set_shader_parameter("root_color",[Color("5D522D"),Color("465F2C"),Color("47612B"),Color("555839")][index])
	grass_material.set_shader_parameter("tip_color",[Color("A1904A"),Color("809B48"),Color("80964A"),Color("757852")][index])
	for leaf in tree_leaves:
		apply_leaf(leaf)
	for layer in winter_layers:
		layer.visible = index != 3
	for layer in deciduous_layers:
		layer.visible = index in [1,2]

func apply_leaf(leaf: MultiMeshInstance3D) -> void:
	var label: String = leaf.get_meta("leaf")
	leaf.visible = season!=3 or label.begins_with("PineTree")
	var original: StandardMaterial3D = leaf.get_meta("source")
	var key := "superworld:%s:%d" % [label,season]
	if not BOTANY.materials.has(key):
		var material := original.duplicate() as StandardMaterial3D
		material.albedo_color = BOTANY.tint(label,season).darkened(.16)
		BOTANY.materials[key] = material
	leaf.material_override = BOTANY.materials[key]

func weather(wetness: float, wind: Vector2, clock: float) -> void:
	grass_material.set_shader_parameter("wind_direction",wind)
	grass_material.set_shader_parameter("wind_clock",clock)
	grass_material.set_shader_parameter("wetness",wetness)

func make_batch(parent: Node3D, id: String, mesh: Mesh, material: Material, transforms: Array[Transform3D],
		start: float, end: float, local: Transform3D = Transform3D.IDENTITY, colors := PackedColorArray()) -> MultiMeshInstance3D:
	var instance := MultiMeshInstance3D.new()
	instance.name = id
	var multi := MultiMesh.new()
	multi.transform_format = MultiMesh.TRANSFORM_3D
	multi.use_colors = not colors.is_empty()
	multi.mesh = mesh
	multi.instance_count = transforms.size()
	for i in transforms.size():
		multi.set_instance_transform(i,transforms[i]*local)
		if multi.use_colors:
			multi.set_instance_color(i,colors[i])
	instance.multimesh = multi
	instance.material_override = material
	instance.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	instance.visibility_range_begin = start
	instance.visibility_range_end = end
	parent.add_child(instance,true)
	return instance

func draw_parts(parent: Node3D, id: String, models: Array, poses: Array[Transform3D], range_m: float) -> void:
	if poses.is_empty():
		return
	for part in models:
		var batch := make_batch(parent,id,part[0],part[1],poses,0,range_m,part[2])
		if id=="Grass":
			batch.visible = season!=3
			winter_layers.append(batch)
		elif id=="MeadowFlowers":
			batch.visible = season in [1,2]
			deciduous_layers.append(batch)
		elif String(part[3]).ends_with("_Leaves") and id!="Shrubs":
			batch.set_meta("leaf",part[3])
			batch.set_meta("source",part[1])
			tree_leaves.append(batch)
			apply_leaf(batch)

func forget(tile: Node3D) -> void:
	for layers in [winter_layers,deciduous_layers,tree_leaves]:
		for i in range(layers.size()-1,-1,-1):
			if tile.is_ancestor_of(layers[i]):
				layers.remove_at(i)

func ground_at(p: Vector2, origin: Vector2, grid: PackedVector3Array) -> float:
	var cells := int(field.chunk_size/FIELD.STEP)+1
	var local := (p-origin)/FIELD.STEP
	var corner := Vector2i(local.floor())
	var f := local-Vector2(corner)
	var first := corner.y*cells+corner.x
	var b := grid[first+1].y
	var c := grid[first+cells].y
	if f.x+f.y<=1.0:
		var a := grid[first].y
		return a+(b-a)*f.x+(c-a)*f.y
	var d := grid[first+cells+1].y
	return d+(c-d)*(1.0-f.x)+(b-d)*(1.0-f.y)

func pose(p: Vector2, height: float, center: Vector2, scale: Vector3, yaw: float) -> Transform3D:
	return Transform3D(Basis(Vector3.UP,yaw).scaled(scale),Vector3(p.x-center.x,height,p.y-center.y))

func tree_group(habitat: FIELD.Habitat, roll: float) -> int:
	match habitat:
		FIELD.Habitat.CONIFER,FIELD.Habitat.ROCK:
			return 4 if roll<.56 else 5
		FIELD.Habitat.OLD_GROVE:
			return 0 if roll<.44 else 1 if roll<.75 else 2 if roll<.91 else 5
		FIELD.Habitat.SHORE:
			return 2 if roll<.48 else 1 if roll<.88 else 4
		FIELD.Habitat.HIGHLAND:
			return 4 if roll<.44 else 2 if roll<.74 else 0
		_:
			return 0 if roll<.29 else 2 if roll<.61 else 3 if roll<.82 else 5

func open_sight(p: Vector2) -> bool:
	var ledge := p-FIELD.OVERLOOK
	var sight := (FIELD.LAKE-FIELD.OVERLOOK).normalized()
	return ledge.length_squared()<115.0*115.0 and ledge.dot(sight)>-1.0 and absf(ledge.cross(sight))<19.0

func decorate(tile: MeshInstance3D,id: Vector2i,quarter: int) -> void:
	var origin := Vector2(id)*field.chunk_size
	var ground_only := quarter>=0
	var width := float(field.chunk_size)
	var start := origin
	if ground_only:
		width *= .5
		start += Vector2(quarter%2,floori(quarter*.5))*width
	var center := start+Vector2.ONE*width*.5
	var rng := RandomNumberGenerator.new()
	rng.seed = (id.x*73856093 ^ id.y*19349663) + (5513+(quarter*13613) if ground_only else 0)
	var grid: PackedVector3Array = tile.mesh.surface_get_arrays(0)[Mesh.ARRAY_VERTEX]
	var patch := Node3D.new()
	patch.name = "Verge%d" % quarter if ground_only else "Canopy"
	patch.position = Vector3(center.x,0,center.y)
	tile.add_child(patch)
	if ground_only:
		plant_ground(patch,origin,start,center,width,grid,rng)
		return
	var groups := []
	for i in IDS.size():
		var transforms: Array[Transform3D] = []
		groups.append(transforms)
	for i in 53:
		var p := origin+Vector2(rng.randf(),rng.randf())*field.chunk_size
		var h := ground_at(p,origin,grid)
		if h<FIELD.WATER+.95 or field.lake_ratio(p)<1.013 or open_sight(p):
			continue
		var zone := field.habitat(p,h)
		var cover := field.forest_cover(p)
		var density: float = [.80,.74,.73,.065,.22,.46,.28,.39][zone] * lerpf(.32,1.14,smoothstep(.26,.78,cover))
		if rng.randf()>density or field.trail_distance(p)<4.4:
			continue
		var group := tree_group(zone,rng.randf())
		var size := rng.randf_range(5.2,11.0)
		if zone==FIELD.Habitat.OLD_GROVE:
			size *= rng.randf_range(1.0,1.62)
		var swell := rng.randf_range(.83,1.17)
		groups[group].append(pose(p,h-.12,center,Vector3(size*swell,size,size*swell),rng.randf()*TAU))
	var proxies := {}
	for i in IDS.size():
		var trees: Array[Transform3D] = groups[i]
		if trees.is_empty():
			continue
		draw_parts(patch,"Tree"+str(i),parts[IDS[i]],trees,DETAIL_RANGE)
		if not proxies.has(MID[i]):
			var merged: Array[Transform3D] = []
			proxies[MID[i]] = merged
		for tree in trees:
			var silhouette: Vector3 = [Vector3(1.10,.89,1.03),Vector3(.98,.94,1.10),Vector3(.60,1.12,.61),
				Vector3(1.14,.93,1.12),Vector3(1,.98,1),Vector3(.83,1.06,.88)][i]
			tree.basis = tree.basis.scaled_local(silhouette)
			proxies[MID[i]].append(tree)
	for id_proxy in proxies:
		var proxy_poses: Array[Transform3D] = proxies[id_proxy]
		var colors := PackedColorArray()
		var tint := Color("43634D") if id_proxy != 0 else Color("627145")
		for i in proxy_poses.size():
			colors.append(tint.lightened(rng.randf_range(0,.22)))
		make_batch(patch,"TreeProxy",proxy_meshes[PROXIES[id_proxy]],proxy_material,proxy_poses,DETAIL_RANGE,270,Transform3D.IDENTITY,colors)

func plant_ground(parent: Node3D, origin: Vector2, start: Vector2, center: Vector2, width: float, grid: PackedVector3Array, rng: RandomNumberGenerator) -> void:
	var meadow := center.distance_squared_to(FIELD.MEADOW_COURSE) < 220.0*220.0
	var upland := center.distance_squared_to(FIELD.OVERLOOK) < 245.0*245.0
	var ground: Array[Transform3D] = []
	var low_growth: Array[Transform3D] = []
	var shrubs: Array[Transform3D] = []
	var boulders: Array[Transform3D] = []
	var flowers := []
	for i in FLOWERS.size():
		var transforms: Array[Transform3D] = []
		flowers.append(transforms)
	for i in (555 if meadow else 145):
		var p := start+Vector2(rng.randf(),rng.randf())*(width-.002)
		var h := ground_at(p,origin,grid)
		if h<FIELD.WATER+.18 or field.lake_ratio(p)<.998 or rng.randf()<.12:
			continue
		var trail := field.trail_distance(p)
		if trail<1.92:
			continue
		var ribbons := sin((p.x-p.y*.44)*.103+1.15*sin(p.y*.060))*.54 + cos(p.y*.061+p.x*.019)*.46
		var skirts := sin(p.x*.063+p.y*.042)*.32
		var short := ribbons+skirts<-.21
		var size := rng.randf_range(1.1,2.7)*(1.25 if meadow else .89)
		var spread := size * (1.42 if ribbons>.1 else 1.06)
		var tuft := pose(p,h-.027,center,Vector3(spread,size*.76,spread),rng.randf()*TAU)
		if short and meadow:
			low_growth.append(tuft)
		else:
			ground.append(tuft)
		var shoulder_band := trail<9.2 and ribbons>-.04 and sin(p.x*.20+p.y*.082)>.26
		var flowering := ribbons+skirts>.215 or shoulder_band
		if meadow and flowering and rng.randf()<.69:
			var style := posmod(floori((p.x+p.y*.63)*.078),FLOWERS.size())
			if rng.randf()<.21:
				style = (style+1)%FLOWERS.size()
			var tall := rng.randf_range(.34,.75) if style!=1 else rng.randf_range(.52,.87)
			flowers[style].append(pose(p,h+.012,center,Vector3(tall*1.28,tall,tall*1.28),rng.randf()*TAU))
		elif i < (22 if upland else 5) and trail>3.0:
			if rng.randf()<.39:
				var radius := rng.randf_range(.48,1.36)
				shrubs.append(pose(p,h-.06,center,Vector3.ONE*radius,rng.randf()*TAU))
			elif rng.randf()<(.45 if upland else .22):
				var radius := rng.randf_range(.57,2.15) * (1.5 if upland else 1.0)
				boulders.append(pose(p,h-radius*.24,center,Vector3(radius*1.2,radius,radius*.86),rng.randf()*TAU))
	draw_parts(parent,"Grass",[[grass,grass_material,Transform3D.IDENTITY,""]],ground,78.0 if meadow else 63.0)
	draw_parts(parent,"Grass",[[short_grass,grass_material,Transform3D.IDENTITY,""]],low_growth,71.0)
	draw_parts(parent,"Shrubs",parts["Bush_Large"],shrubs,105.0)
	draw_parts(parent,"Boulders",rocks[0 if meadow else 1],boulders,155.0)
	for i in FLOWERS.size():
		draw_parts(parent,"MeadowFlowers",parts[FLOWERS[i]],flowers[i],83.0)

func populate_macro(parent: Node3D, start: Vector2, width: int, step: int, heights: PackedVector3Array) -> void:
	var center := start+Vector2.ONE*width*.5
	var holder := Node3D.new()
	holder.name = "PanoramaGroves"
	holder.position = Vector3(center.x,0,center.y)
	parent.add_child(holder)
	var rng := RandomNumberGenerator.new()
	rng.seed = int(start.x)*7391 ^ int(start.y)*1307
	var groups := [[],[],[],[]]
	var side := int(width/float(step))+1
	for z in range(side-1):
		for x in range(side-1):
			var anchor := Vector2(x+rng.randf_range(.19,.81),z+rng.randf_range(.19,.81))
			var coordinates := start+anchor*step
			var cover := field.forest_cover(coordinates)
			if cover<.41 or not field.bounds.has_point(coordinates):
				continue
			var number := 3 if cover>.87 else 2 if cover>.73 else 1
			for i in number:
				var at := (anchor+Vector2.from_angle(rng.randf()*TAU)*rng.randf_range(.01,.26)).clamp(
					Vector2(x+.013,z+.013),Vector2(x+.987,z+.987))
				var p := start+at*step
				if FIELD.CORE.grow(24).has_point(p) or open_sight(p) or field.lake_ratio(p)<1.015:
					continue
				var f := at-Vector2(x,z)
				var a := z*side+x
				var lower := heights[a+side].y
				var right := heights[a+1].y
				var base := heights[a].y
				var h := base+(right-base)*f.x+(lower-base)*f.y
				if f.x+f.y>1.0:
					var y := heights[a+side+1].y
					h = y+(lower-y)*(1.0-f.x)+(right-y)*(1.0-f.y)
				if h<FIELD.WATER-5.0 or h>167.0:
					continue
				var zone := field.habitat(p,h+8.0)
				var density: float = [.82,.81,.77,.03,.12,.59,.095,.33][zone]
				if rng.randf()>density:
					continue
				var tree := tree_group(zone,rng.randf())
				var variant: int = MID[tree] if tree!=2 else 0
				if tree>=4 and rng.randf()<.26:
					variant = 1
				var size := rng.randf_range(6.2,16.4)
				var spread := rng.randf_range(.73,1.16)*(1.21 if tree in [0,1,3] else .74)
				groups[variant].append(pose(p,h+.25,center,Vector3(size*spread,size,size*spread),rng.randf()*TAU))
	for group in groups.size():
		var poses: Array[Transform3D] = []
		poses.assign(groups[group])
		if poses.is_empty():
			continue
		var colors := PackedColorArray()
		var tint: Color = [Color("60734A"),Color("476353"),Color("385747"),Color("3C6250")][group]
		for i in poses.size():
			colors.append(tint.lightened(rng.randf_range(0,.20)))
		make_batch(holder,"FarGrove",proxy_meshes[PROXIES[group]],far_material,poses,0,0,Transform3D.IDENTITY,colors)
