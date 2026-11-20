extends RefCounted
## Catalogued Quaternius meshes. GLB surface names identify the source texture and deciduous foliage.
const DIR := "res://assets/vegetation/trees/"
const DEFAULT_SEASON := 1
const FAMILIES := ["BirchTree", "MapleTree", "NormalTree", "PineTree"]
static var materials: Dictionary = {}
static var scenes: Dictionary = {}

static func codes() -> PackedStringArray:
	var result := PackedStringArray()
	for family in FAMILIES:
		for index in range(1,6):
			result.append("%s_%d" % [family, index])
	return result

static func instance(id: String, height: float) -> Node3D:
	var wrapper := Node3D.new()
	if not scenes.has(id):
		scenes[id] = load(DIR + id + ".glb")
	var scene := scenes[id] as PackedScene
	var model := scene.instantiate() as Node3D
	wrapper.add_child(model)
	var bounds := FieldAssets.bounds(model)
	var factor := height / maxf(.01,bounds.size.y)
	model.scale *= factor
	model.position -= Vector3(bounds.get_center().x,bounds.position.y,bounds.get_center().z)*factor
	apply_season(wrapper,2)
	return wrapper

static func place(parent: Node3D, id: String, position: Vector3, height: float, yaw := 0.0) -> Node3D:
	var tree := instance(id,height)
	parent.add_child(tree)
	tree.position = position
	tree.rotation.y = yaw
	return tree

static func apply_season(tree: Node3D, season: int) -> void:
	for child in tree.find_children("*","MeshInstance3D",true,false):
		var mesh := child as MeshInstance3D
		var source := mesh.mesh.surface_get_material(0)
		if source == null:
			continue
		var name_key := source.resource_name
		var leaves := name_key.ends_with("_Leaves")
		var pine := name_key.begins_with("PineTree")
		mesh.visible = not ((leaves and not pine or name_key=="Flowers") and season==3)
		var key := "%s/%d" % [name_key,season if leaves else 2]
		if not materials.has(key):
			var material := StandardMaterial3D.new()
			material.roughness = .93
			var texture_path := DIR+"textures/"+name_key+".png"
			if ResourceLoader.exists(texture_path):
				material.albedo_texture = load(texture_path)
				material.texture_filter = BaseMaterial3D.TEXTURE_FILTER_LINEAR_WITH_MIPMAPS_ANISOTROPIC
			else:
				material.albedo_color = Color("8C8171")
			if leaves or name_key == "Flowers":
				material.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA_SCISSOR
				material.alpha_scissor_threshold = .52 if season in [0,1] and leaves and not pine else .46
				material.cull_mode = BaseMaterial3D.CULL_DISABLED
			if leaves:
				material.albedo_color = tint(name_key,season)
			materials[key] = material
		mesh.material_override = materials[key]

static func tint(name_key: String, season: int) -> Color:
	if name_key == "Bush_Leaves":
		return Color("69785A") if season==0 else Color("688155")
	if name_key.begins_with("PineTree"):
		return [Color("71805F"), Color("7DA267"), Color("567E57"), Color("819385")][season]
	if season == 1:
		return Color("AAC878")
	if season == 0:
		return Color("AD6848") if name_key.begins_with("MapleTree") else Color("C3A458")
	return Color("718E57")

static func place_stone(parent: Node3D, spot: Vector3, size: float, yaw: float, ridge: bool = false) -> Node3D:
	var packed := preload("res://assets/village_a/split_boulder.glb") if ridge else preload("res://assets/village_a/layered_ledge.glb")
	var rock := packed.instantiate() as Node3D
	var bounds := FieldAssets.bounds(rock)
	var factor := size/maxf(bounds.size.x,bounds.size.z)
	var base := Node3D.new()
	parent.add_child(base)
	base.position = spot
	base.rotation.y = yaw
	base.add_child(rock)
	rock.scale *= factor
	rock.position = -Vector3(bounds.get_center().x,bounds.position.y + bounds.size.y*.19,bounds.get_center().z)*factor
	for child in rock.find_children("*","MeshInstance3D",true,false):
		var model := child as MeshInstance3D
		for i in model.mesh.get_surface_count():
			var previous := model.mesh.surface_get_material(i) as StandardMaterial3D
			if previous == null:
				continue
			var key := "stone:"+previous.resource_name
			if not materials.has(key):
				var shader := ShaderMaterial.new()
				shader.shader = preload("res://shaders/a1_rock_surface.gdshader")
				shader.set_shader_parameter("stone_tint",previous.albedo_color.lerp(Color("79766C"),.34))
				materials[key] = shader
			model.set_surface_override_material(i,materials[key])
	return base

static func grass_batch(parent: Node3D, positions: Array[Vector3], seed: int, distance: float, height: float = .29) -> MultiMeshInstance3D:
	var grass := instance("Grass_Large_Extruded",height)
	var visual := grass.find_children("*","MeshInstance3D",true,false)[0] as MeshInstance3D
	var blade := visual.mesh.duplicate() as ArrayMesh
	var pose := visual.get_parent_node_3d().transform*visual.transform
	var material := visual.material_override.duplicate() as StandardMaterial3D
	material.vertex_color_use_as_albedo = true
	blade.surface_set_material(0,material)
	grass.free()

	var rng := RandomNumberGenerator.new()
	rng.seed = seed
	var instances := MultiMesh.new()
	instances.transform_format = MultiMesh.TRANSFORM_3D
	instances.use_colors = true
	instances.mesh = blade
	instances.instance_count = positions.size()
	for i in positions.size():
		var scale_factor := rng.randf_range(.70,1.25)
		var basis := Basis(Vector3.UP,rng.randf()*TAU).scaled(Vector3.ONE*scale_factor)
		instances.set_instance_transform(i,Transform3D(basis,positions[i])*pose)
		instances.set_instance_color(i,Color("A5AD78").lerp(Color("D1CC9D"),rng.randf()))
	var patch := MultiMeshInstance3D.new()
	patch.multimesh = instances
	patch.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	patch.visibility_range_end = distance
	parent.add_child(patch)
	return patch

static func place_tree(parent: Node3D, id: String, position: Vector3, height: float, yaw: float) -> Node3D:
	var root := Node3D.new()
	parent.add_child(root)
	root.position = position
	root.rotation.y = yaw
	root.set_meta("tree_family",id.get_slice("_",0))
	var detail := instance(id,height)
	detail.name = "Near"
	root.add_child(detail)
	var number := int(id.get_slice("_",1))
	var proxy: Node3D
	if id.begins_with("PineTree"):
		proxy = FieldAssets.model("quaternius","PineTree_%d" % number,height)
	elif id.begins_with("BirchTree"):
		proxy = FieldAssets.model("quaternius","BirchTree_Autumn_1" if number%2!=0 else "BirchTree_Autumn_3",height)
	else:
		proxy = FieldAssets.model("nature","tree_oak_fall",height)
	proxy.name = "Far"
	root.add_child(proxy)
	for child in proxy.find_children("*","MeshInstance3D",true,false):
		child.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	# Initial draw is near until a current camera is available.
	proxy.hide()
	season_tree(root,DEFAULT_SEASON)
	return root

static func season_tree(root: Node3D, season: int) -> void:
	var detail := root.get_node("Near") as Node3D
	var proxy := root.get_node("Far") as Node3D
	var family: String = root.get_meta("tree_family")
	root.set_meta("bare",season==3 and family!="PineTree")
	apply_season(detail,season)
	for child in proxy.find_children("*","MeshInstance3D",true,false):
		var mesh := child as MeshInstance3D
		for i in mesh.mesh.get_surface_count():
			var source := mesh.mesh.surface_get_material(i) as StandardMaterial3D
			if source == null:
				continue
			var label := source.resource_name.to_lower()
			if not (label.contains("leaf") or label.contains("leaves") or label.contains("needle")
					or label in ["grass","green","orange","lightorange"]):
				continue
			var key := "proxy:%d:%s:%d" % [source.get_instance_id(),family,season]
			if not materials.has(key):
				var material := source.duplicate() as StandardMaterial3D
				material.albedo_color = tint(family,season).darkened(.12)
				materials[key] = material
			mesh.set_surface_override_material(i,materials[key])

static func update_lod(roots: Array[Node3D], eye: Vector3) -> void:
	for root in roots:
		var detail := root.get_node("Near") as Node3D
		var proxy := root.get_node("Far") as Node3D
		var range_limit := 78.0 if detail.visible else 68.0
		var show_detail: bool = root.get_meta("bare",false) == true or eye.distance_squared_to(root.global_position) < range_limit*range_limit
		detail.visible = show_detail
		proxy.visible = not show_detail
