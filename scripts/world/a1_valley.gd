extends Node3D

const BOTANY = preload("res://scripts/world/a1_botany.gd")
const VILLAGE_PLAN = preload("res://scripts/world/village_a_layout.gd")
const VILLAGE = preload("res://scripts/world/village_a.gd")
const L = preload("res://scripts/world/landscape.gd")
const S = preload("res://scripts/world/shapes.gd")
const A = preload("res://scripts/world/field_assets.gd")
const MAPS = preload("res://scripts/story/map_flow.gd")
const WILDLIFE = preload("res://scripts/world/a1_wildlife.gd")
const PETS = preload("res://scripts/world/village_a_pets.gd")
var birds: Array[Node3D] = []
var clock := 0.0
var current_season := BOTANY.DEFAULT_SEASON
var habitat_floor: Array[Node3D] = []
var habitat_trees: Array[Node3D] = []
var sun: DirectionalLight3D
var original_shadow_distance: float
var original_shadow_mode: int
var local_shadows := false
var foliage_tick := .0

func _ready() -> void:
	sun = get_parent().get_node("Sun")
	original_shadow_distance = sun.directional_shadow_max_distance
	original_shadow_mode = sun.directional_shadow_mode
	if get_parent().superworld == null:
		build_mountains()
		build_distant_foothills()
	build_river()
	build_bridge()
	if get_parent().superworld != null:
		dress_river_banks()
	build_house_grove()
	if get_parent().superworld != null:
		dress_ancient_grove()
	build_groves()
	var village := VILLAGE.new()
	village.name = "VillageA"
	add_child(village)
	village.coat(get_parent().get_node("ForestHouseA"),.53)
	var planting := preload("res://scripts/world/a1_planting.gd").new()
	planting.name = "SeasonalPlanting"
	add_child(planting)
	build_overlook()
	build_reveal()
	build_understory()
	detail_slices()
	set_season_palette(BOTANY.DEFAULT_SEASON)
	for argument in OS.get_cmdline_user_args():
		if argument.begins_with("--a1-season="):
			var season := ["autumn", "spring", "summer", "winter"].find(argument.get_slice("=", 1))
			if season >= 0:
				set_season_palette(season)
	add_child(WILDLIFE.new())
	var pets := PETS.new()
	pets.name = "VillagePets"
	add_child(pets)
	for i in range(5):
		var bird := Node3D.new()
		add_child(bird)
		bird.scale = Vector3.ONE * 0.51
		facet(bird, Vector3.ZERO, Vector3(0.20, 0.20, 0.54), "667481")
		for side in [-1, 1]:
			var wing := Node3D.new()
			bird.add_child(wing)
			facet(wing, Vector3(side * 0.38, 0, -0.04), Vector3(0.84, 0.07, 0.32), "74818A")
		birds.append(bird)

func ground(x: float, z: float) -> Vector3:
	return Vector3(x, L.height_at(x, z), z)

func build_mountains() -> void:
	var rng := RandomNumberGenerator.new()
	rng.seed = 4221
	for layer in range(3):
		var mountains := SurfaceTool.new()
		mountains.begin(Mesh.PRIMITIVE_TRIANGLES)
		var distance := 259.0 - 23.0 * layer
		var palette := [Color("97ABBC"), Color("7F98A5"), Color("627F84")]
		var crest := PackedVector3Array()
		var foothill := PackedVector3Array()
		var floor := PackedVector3Array()
		for i in range(61):
			var x := -420.0 + i * 14.0
			var peaks := pow(0.5 + 0.5 * sin(x * 0.031 + layer * 2.2 + .48*sin(x*.081)), 1.35)
			var height := 17.0 + 30.0 * peaks + 3.2 * sin(x * 0.12 + layer) + 2.1*cos(x*.247 + layer)
			var z := distance + 11.0 * cos(x * 0.045 + layer)
			crest.append(Vector3(x, height, z))
			foothill.append(Vector3(x, height * 0.46 - 1.8, z - 16.0))
			floor.append(Vector3(x, -95.0, z - 36.0))
		for i in range(crest.size() - 1):
			for face in [[crest[i], crest[i + 1], foothill[i]], [crest[i + 1], foothill[i + 1], foothill[i]],
				[foothill[i], foothill[i + 1], floor[i]], [foothill[i + 1], floor[i + 1], floor[i]]]:
				var color: Color = palette[layer].lightened(rng.randf_range(-0.027, 0.036))
				for vertex in face:
					var haze := 0.82 if vertex.y < 0.0 else (0.19 if vertex.y < 18.0 else 0.06)
					mountains.set_color(color.lerp(Color("8FA2A5"), haze))
					mountains.add_vertex(vertex)
		var ridge := MeshInstance3D.new()
		ridge.mesh = mountains.commit()
		var material := StandardMaterial3D.new()
		material.vertex_color_use_as_albedo = true
		material.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
		material.disable_fog = true
		material.cull_mode = BaseMaterial3D.CULL_DISABLED
		ridge.material_override = material
		ridge.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
		add_child(ridge)

func build_distant_foothills() -> void:
	var mesh := SurfaceTool.new()
	mesh.begin(Mesh.PRIMITIVE_TRIANGLES)
	for x in range(-210,210,7):
		for z in range(155,330,7):
			for offset in [Vector2.ZERO,Vector2(7,0),Vector2(0,7),Vector2(7,0),Vector2(7,7),Vector2(0,7)]:
				var p: Vector2 = Vector2(x,z)+offset
				var blend := smoothstep(178.0,220.0,p.y)
				var rises := 6.5 + 9.0 * pow(.5 + .5*sin(p.x*.047 + p.y*.031),2.5)
				rises += 4.0*sin(p.x*.023-p.y*.054)+2.4*cos(p.y*.115+p.x*.092)
				var height := lerpf(-4.0,rises,blend)
				var color := Color("596F66").lerp(Color("7A9286"),smoothstep(-1.0,18.0,height)*.75)
				mesh.set_color(color)
				mesh.add_vertex(Vector3(p.x,height,p.y))
	mesh.generate_normals()
	var foothills := MeshInstance3D.new()
	foothills.name = "DistantFoothills"
	foothills.mesh = mesh.commit()
	var shade := StandardMaterial3D.new()
	shade.vertex_color_use_as_albedo = true
	shade.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	shade.disable_fog = true
	shade.roughness = 1.0
	foothills.material_override = shade
	foothills.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	add_child(foothills)

func build_river() -> void:
	var surface := SurfaceTool.new()
	surface.begin(Mesh.PRIMITIVE_TRIANGLES)
	for x in range(-49, 49):
		var a := L.river_center(x)
		var b := L.river_center(x + 1)
		for vertex in [Vector3(x, 1.25, a - 6), Vector3(x + 1, 1.25, b - 6),
			Vector3(x, 1.25, a + 6), Vector3(x + 1, 1.25, b - 6),
			Vector3(x + 1, 1.25, b + 6), Vector3(x, 1.25, a + 6)]:
			surface.add_vertex(vertex)
	surface.generate_normals()
	var water := MeshInstance3D.new()
	water.name = "A1River"
	water.mesh = surface.commit()
	var material := ShaderMaterial.new()
	material.shader = preload("res://shaders/a1_river.gdshader")
	material.set_shader_parameter("superworld_water",get_parent().superworld != null)
	water.material_override = material
	water.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	add_child(water)
	# The river is a visible boundary until swimming is introduced.
	for side in [-1, 1]:
		for x in range(-39, 40, 2):
			if abs(x) < 3:
				continue
			S.box(self, Vector3(x, 2.2, L.river_center(x) + side * 5.2), Vector3(2.1, 4, 0.9), "FFFFFF", true).hide()

func dress_ancient_grove() -> void:
	var rng := RandomNumberGenerator.new()
	rng.seed = 164447
	var understory := Node3D.new()
	understory.name = "AncientGroveFloor"
	add_child(understory)
	var moss: Array[Vector3] = []
	for origin: Vector2 in [Vector2(-6.8,-321.4),Vector2(-14.4,-312.1),Vector2(4.8,-309.7),Vector2(-16.9,-300.6)]:
		if ForestFloorDesign.reserved(origin,3.2):
			continue
		# Each root starts against the same trunk as its surrounding moss and stones.
		var tree_id := "NormalTree_3" if origin.x<0 else "BirchTree_2"
		var base := ground(origin.x,origin.y)
		habitat_trees.append(BOTANY.place_tree(understory,tree_id,base,rng.randf_range(12.5,15.5),rng.randf()*TAU))
		for i in 5:
			var dir := Vector2.from_angle(i*TAU/5.0+rng.randf_range(-.24,.24))
			var near := origin+dir*.36
			var end := origin+dir*rng.randf_range(1.23,2.3)
			if ForestFloorDesign.reserved(end,.25):
				continue
			var elbow := near.lerp(end,.54)+dir.orthogonal()*.19
			var raised := ground(elbow.x,elbow.y)+Vector3.UP*.12
			S.beam(understory,ground(near.x,near.y)+Vector3.UP*.24,raised,.22,"564433")
			S.beam(understory,raised,ground(end.x,end.y)-Vector3.UP*.05,.11,"5D513A")
		for i in 55:
			var p := origin+Vector2.from_angle(rng.randf()*TAU)*rng.randf_range(.78,3.2)
			if not ForestFloorDesign.reserved(p,.56):
				moss.append(ground(p.x,p.y))
		var rock := origin+Vector2(-2.3,.9)
		if not ForestFloorDesign.reserved(rock,1.1):
			BOTANY.place_stone(understory,ground(rock.x,rock.y)-Vector3.UP*.14,rng.randf_range(1,1.7),rng.randf()*TAU)
	if not moss.is_empty():
		habitat_floor.append(BOTANY.grass_batch(understory,moss,1327,62.0,.24,1.4,true))

func dress_river_banks() -> void:
	var rng := RandomNumberGenerator.new()
	rng.seed = 70745
	for side in [-1.0,1.0]:
		var sedges: Array[Vector3] = []
		for index in 23:
			var x := rng.randf_range(-31.0,31.0)
			if absf(x)<4.3:
				continue
			var z: float = L.river_center(x)+side*rng.randf_range(3.5,6.9)
			var point := ground(x,z)
			var width := rng.randf_range(.56,1.9)
			BOTANY.place_stone(self,point-Vector3.UP*.15,width,rng.randf()*TAU,index%4==0)
			for tuft in 9:
				var p := ground(x+rng.randf_range(-1.05,1.05),z+side*rng.randf_range(.5,1.6))
				if p.y>1.31:
					sedges.append(p)
		habitat_floor.append(BOTANY.grass_batch(self,sedges,503 if side<0 else 705,76.0,.32,1.43,true))

func bridge_top(z: float) -> float:
	var t := clampf((z-65.76)/16.44,0,1)
	var landing := lerpf(L.height_at(0,65.76),L.height_at(0,82.20),t)
	return landing + .065 + sin(PI*t)*1.02

func build_bridge() -> void:
	var bridge := Node3D.new()
	bridge.name = "TimberArchBridge"
	add_child(bridge)
	for i in range(39):
		var z := 66.0 + i * 0.42
		var y := bridge_top(z)
		S.box(bridge, Vector3(0, y - 0.085, z), Vector3(4.35, 0.17, 0.47), ["AD8058", "C09467", "BA885D"][i % 3])
		for side in [-1, 1]:
			var x: float = side * 2.05
			S.box(bridge, Vector3(x, y + 0.69, z), Vector3(0.14, 0.13, 0.5), "684935")
			S.box(bridge, Vector3(x, y + 0.46, z), Vector3(0.12, 0.92, 0.46), "FFFFFF", true).hide()
			if i % 4 == 0:
				S.box(bridge, Vector3(x, y + 0.48, z), Vector3(0.21, 1.12, 0.22), "805638")
			if i in [0, 38]:
				lantern(bridge, Vector3(x, y + 1.10, z))
	var deck := PackedVector3Array()
	for i in range(40):
		var a_z := lerpf(65.76,82.20,float(i)/40)
		var b_z := lerpf(65.76,82.20,float(i+1)/40)
		var a := Vector3(-2.17,bridge_top(a_z),a_z)
		var b := Vector3(2.17,bridge_top(a_z),a_z)
		var c := Vector3(-2.17,bridge_top(b_z),b_z)
		var d := Vector3(2.17,bridge_top(b_z),b_z)
		deck.append_array(PackedVector3Array([a,b,c,b,d,c]))
	var deck_shape := ConcavePolygonShape3D.new()
	deck_shape.set_faces(deck)
	var deck_collision := CollisionShape3D.new()
	deck_collision.shape = deck_shape
	var deck_body := StaticBody3D.new()
	deck_body.add_child(deck_collision)
	bridge.add_child(deck_body)
	for z in [68.0, 80.0]:
		for x in [-1.66, 1.66]:
			S.box(bridge, Vector3(x, 1.75, z), Vector3(0.44, 2.85, 0.53), "696A67")
	for side in [-1, 1]:
		var x: float = side * 1.83
		for i in range(20):
			var z := 66.0 + i * 0.8
			var y := bridge_top(z) - .30
			var next_y := bridge_top(z+.8) - .30
			S.beam(bridge, Vector3(x,y,z), Vector3(x,next_y,z+0.81), 0.28, "795738")

func build_house_grove() -> void:
	var rng := RandomNumberGenerator.new()
	rng.seed = 80433
	var home := VILLAGE_PLAN.HOUSE_A
	for entry in [["BirchTree_2",-4.0,-6.2,9.8],["NormalTree_3",4.3,-5.0,9.7],
		["PineTree_1",5.0,2.0,13.4],["PineTree_2",3.5,6.5,11.6],
		["NormalTree_4",-2.5,8,11.8],["BirchTree_3",-13.0,4,10.4]]:
		var p := home + Vector2(entry[1],entry[2])
		habitat_trees.append(BOTANY.place_tree(self,entry[0],ground(p.x,p.y),entry[3],p.x))
	for i in range(1,VILLAGE_PLAN.HOUSE_APPROACH.size()-4):
		var center: Vector2 = VILLAGE_PLAN.HOUSE_APPROACH[i]
		for side in [-1.0,1.0]:
			for depth in [0,1,2]:
				var spot := center + Vector2(side*(4.6+depth*7.3+rng.randf_range(-1.9,2.5)),rng.randf_range(-5.2,5.8))
				if ForestFloorDesign.reserved(spot,1.5) or spot.distance_to(home)<8:
					continue
				var id: String = ["PineTree_2","BirchTree_2","NormalTree_3","PineTree_5","MapleTree_3"][(i+depth)%5]
				var height := rng.randf_range(8.4,15.3)
				habitat_trees.append(BOTANY.place_tree(self,id,ground(spot.x,spot.y),height,rng.randf()*TAU))
		if i%4==1 and i>1:
			var spot := center + Vector2(-6.7 if i%3==0 else 6.9,-3.9)
			if not ForestFloorDesign.reserved(spot,2.9):
				BOTANY.place_stone(self,ground(spot.x,spot.y),rng.randf_range(1.7,2.6),rng.randf()*TAU,true)
				spot += Vector2(-1.3,-.8)
				BOTANY.place_stone(self,ground(spot.x,spot.y),.95,rng.randf()*TAU)
	for x in [-37,-26,29,39]:
		for z in range(int(home.y)-10,-83,13):
			var spot := Vector2(x+rng.randf_range(-5.3,5.3),z+rng.randf_range(-5.2,5.2))
			var tree := BOTANY.place_tree(self,"PineTree_%d" % rng.randi_range(1,5),
				ground(spot.x,spot.y),rng.randf_range(10.4,17.5),rng.randf()*TAU)
			habitat_trees.append(tree)
	# Frame the clearing with woodland across the ridge behind the cottage.
	for depth in [0,1,2]:
		for i in range(13):
			var spot := home + Vector2(
				12.0+depth*11.5+rng.randf_range(-4.5,4.4),
				-37.0+i*5.6+rng.randf_range(-3.0,3.9))
			var id: String = ["PineTree_4","NormalTree_2","PineTree_1","BirchTree_3"][(i+depth)%4]
			habitat_trees.append(BOTANY.place_tree(self,id,ground(spot.x,spot.y),
				rng.randf_range(8.6,15.2),rng.randf()*TAU))
	for entry in [[-4.6,-3.1,1.28],[-3.8,-3.6,.67],[.2,6.4,1.82],[1.1,6.1,.96]]:
		var p := home + Vector2(entry[0],entry[1])
		BOTANY.place_stone(self,ground(p.x,p.y),entry[2],p.x,entry[2]>1.5)

func build_groves() -> void:
	var rng := RandomNumberGenerator.new()
	rng.seed = 19841
	# Height and species follow groves anchored to shoulders of the valley and its woodland edge.
	var stands := [
		[Vector2(-21,32),"PineTree",10.0], [Vector2(14,35),"BirchTree",9.3],
		[Vector2(-16,46),"NormalTree",9.0], [Vector2(16,51),"PineTree",11.1],
		[Vector2(-30,64),"BirchTree",9.0], [Vector2(25,67),"BirchTree",8.5],
		[Vector2(-25,87),"PineTree",11.6], [Vector2(23,85),"NormalTree",9.8],
		[Vector2(-29,105),"PineTree",10.7], [Vector2(29,103),"PineTree",11.4],
		[Vector2(-25,130),"BirchTree",9.2], [Vector2(29,130),"NormalTree",9.7],
		[Vector2(-27,153),"PineTree",11.4], [Vector2(30,153),"PineTree",11.2],
		[Vector2(-18,172),"PineTree",10.4], [Vector2(21,173),"PineTree",11.2],
	]
	var planted: Array[Vector2] = []
	for stand in stands:
		var center: Vector2 = stand[0]
		for i in range(11):
			var p := center + Vector2(rng.randfn(0,4.7),rng.randfn(0,4.8))
			if absf(p.x)>38.0 or p.y<27 or p.y>183 or absf(p.x-L.valley_path(p.y))<5.2:
				continue
			if absf(p.y-L.river_center(p.x))<8.4 or L.in_overlook_view(p.x,p.y):
				continue
			if p.y>100 and p.y<167 and p.x>-22 and p.x<25:
				continue
			if planted.any(func(other:Vector2) -> bool: return p.distance_squared_to(other) < 8.5):
				continue
			planted.append(p)
			var at := ground(p.x,p.y)
			var height: float = stand[2]+rng.randf_range(-2.6,1.6)
			habitat_trees.append(BOTANY.place_tree(self,"%s_%d" % [stand[1],1+i%5],at,height,rng.randf()*TAU))
			S.box(self,at+Vector3.UP*1.5,Vector3(.72,3,.72),"FFFFFF",true).hide()

func build_overlook() -> void:
	var lookout := ground(-22.5, 50.0)
	var bench := Node3D.new()
	add_child(bench)
	bench.position = lookout
	bench.rotation.y = 0.60
	S.box(bench, Vector3(0, 0.53, 0), Vector3(2.15, 0.12, 0.60), "A07850")
	S.box(bench, Vector3(0, 0.87, -0.27), Vector3(2.15, 0.34, 0.10), "95704E")
	for x in [-0.77, 0.77]:
		S.box(bench, Vector3(x, 0.28, 0), Vector3(0.17, 0.55, 0.51), "624938")
	lantern(self, lookout + Vector3(1.8, 0.50, 0))
	signpost(ground(L.valley_path(49) + 2.1, 49),
		MAPS.text("River bridge  ↑", "Cầu qua sông  ↑"))
	signpost(ground(2.4, 85), MAPS.text("Village  ↑", "Lối lên làng  ↑"))

func signpost(at: Vector3, title: String) -> void:
	S.box(self, at + Vector3.UP * 0.79, Vector3(0.14, 1.60, 0.14), "73543D")
	S.box(self, at + Vector3.UP * 1.43, Vector3(1.85, 0.40, 0.12), "886142")
	var text := Label3D.new()
	text.text = title
	text.font_size = 50
	text.pixel_size = 0.0038
	text.outline_size = 3
	text.modulate = Color("FFE8BE")
	add_child(text)
	text.position = at + Vector3(0, 1.43, -0.064)
	text.rotation.y = PI

func lantern(parent: Node3D, at: Vector3) -> void:
	var mesh := S.box(parent, at, Vector3(0.27, 0.34, 0.27), "E6AE64")
	glow(mesh)
	S.box(parent, at + Vector3.UP * 0.19, Vector3(0.36, 0.10, 0.36), "604739")

func glow(mesh: MeshInstance3D) -> void:
	var material := mesh.material_override.duplicate() as StandardMaterial3D
	material.emission_enabled = true
	material.emission = Color("EDAE67")
	material.emission_energy_multiplier = 0.55
	mesh.material_override = material

func facet(parent: Node3D, at: Vector3, size: Vector3, color: String) -> MeshInstance3D:
	var shape := SphereMesh.new()
	shape.radial_segments = 6
	shape.rings = 3
	var mesh := S.mesh(parent, shape, at, color)
	mesh.scale = size
	return mesh

func _process(delta: float) -> void:
	var camera := get_viewport().get_camera_3d()
	if camera != null:
		foliage_tick -= delta
		if foliage_tick <= .0:
			foliage_tick = .18
			BOTANY.update_lod(habitat_trees,camera.global_position)
			BOTANY.update_lod(get_node("VillageA").trees,camera.global_position)
			var woodland := get_parent().get_node_or_null("LicensedWoodland")
			if woodland != null:
				BOTANY.update_lod(woodland.seasonal_trees,camera.global_position)
		var village_view := camera.global_position.z > (24.0 if local_shadows else 27.0)
		if village_view != local_shadows:
			local_shadows = village_view
			sun.directional_shadow_max_distance = minf(original_shadow_distance, 48.0) if local_shadows else original_shadow_distance
			sun.directional_shadow_mode = DirectionalLight3D.SHADOW_PARALLEL_2_SPLITS if local_shadows else original_shadow_mode
	clock += delta
	for i in birds.size():
		var bird := birds[i]
		var t := clock * 0.24 + i * 0.13
		bird.position = Vector3(29.0 * sin(t), 24.0 + i * 0.42 + sin(t * 2.0), 83.0 + 25.0 * cos(t) + i * 1.4)
		bird.rotation.y = atan2(cos(t) * 29.0, -sin(t) * 25.0)
		bird.get_child(1).rotation.z = sin(clock * 8.1 + i * 0.76) * 0.58
		bird.get_child(2).rotation.z = -bird.get_child(1).rotation.z

func detail_slices() -> void:
	for group in [[-23.5,49.5,2.9],[-13.2,55.8,1.4],[-17.4,62.1,2.1],[11.5,59.2,2.7],
		[-12.5,83.8,2.65],[11.0,85.0,1.95],[-9.7,98.4,2.2],[14.2,93.6,2.1],
		[-18.8,119.9,2.7],[20.7,143.0,2.1]]:
		var p := Vector2(group[0],group[1])
		var width: float = group[2]
		BOTANY.place_stone(self,ground(p.x,p.y),width,p.x,true)
		BOTANY.place_stone(self,ground(p.x+width*.66,p.y+.21),width*.54,p.x+.61)
		BOTANY.place_stone(self,ground(p.x-width*.37,p.y-.64),width*.35,p.x-.45)

func build_understory() -> void:
	var rng := RandomNumberGenerator.new()
	rng.seed = 88157
	for patch_z in [34.0,44.0,56.0,89.0]:
		var tufts: Array[Vector3] = []
		for cluster in range(6):
			var bank := -1.0 if cluster%2==0 else 1.0
			var z: float = patch_z + rng.randf_range(-4.2,4.2)
			var x := L.valley_path(z) + bank * rng.randf_range(3.0,5.7)
			for sample in range(24):
				var p := Vector2(x+rng.randfn(0,.40),z+rng.randfn(0,.91))
				if absf(p.x-L.valley_path(p.y)) < 2.48:
					continue
				tufts.append(ground(p.x,p.y))
			if cluster%2==0:
				var shrub := "Bush_Large" if cluster%4==0 else "Flower_4_Clump"
				habitat_floor.append(BOTANY.place(self,shrub,ground(x,z),.58 if cluster%4==0 else .37,cluster*1.9))
		var layer := BOTANY.grass_batch(self,tufts,int(patch_z)+1309,38.0,.22)
		layer.name = "ForestUnderstory%d" % int(patch_z)
		habitat_floor.append(layer)

func set_season_palette(season: int) -> void:
	current_season = season
	if get_parent().superworld != null:
		get_parent().superworld.set_season(season)
	var meadow := get_parent().get_node_or_null("CuratedGroundCover/DenseMeadow") as Node3D
	if meadow != null:
		meadow.visible = season != 3
	for patch in habitat_floor:
		patch.visible = season != 3
	for tree in habitat_trees:
		BOTANY.season_tree(tree,season)
	var terrain := get_parent().find_child("ContinuousMap01Terrain",true,false) as MeshInstance3D
	if terrain != null:
		(terrain.material_override as ShaderMaterial).set_shader_parameter("a1_season", season)
	var road := get_parent().find_child("ExistingDeliveryPath",true,false) as MeshInstance3D
	if road != null:
		(road.material_override as ShaderMaterial).set_shader_parameter("village_snow",.92 if season==3 else 0.0)
	var woodland := get_parent().get_node_or_null("LicensedWoodland")
	if woodland != null:
		for tree in woodland.seasonal_trees:
			BOTANY.season_tree(tree,season)
		for shrub in woodland.seasonal_shrubs:
			BOTANY.apply_season(shrub,season)
	get_node("VillageA").set_season(season)
	get_node("SeasonalPlanting").set_season(season)

func build_reveal() -> void:
	for item in [[-7.3,85.0,11.2],[-5.5,90.6,10.8],[0.0,93.5,9.1],[10.8,91.1,10.2],
		[10.2,96.2,8.3],[-6.4,98.1,9.5],[-12.9,95.5,11.4],[13.7,98.0,9.2]]:
		var p := ground(item[0],item[1])
		var index := habitat_trees.size()
		var family: String = ["PineTree","BirchTree","NormalTree","MapleTree"][index%4]
		habitat_trees.append(BOTANY.place_tree(self,"%s_%d" % [family,1+index%5],p,item[2],item[0]))
	# Taller, offset groves frame the trail. A set-back meadow stays clear on the other side.
	for item in [["BirchTree_3",-11.4,33.5,12.4],["MapleTree_2",-7.1,38.6,10.2],
		["PineTree_4",-14.8,38.7,13.6],["BirchTree_5",3.2,34.8,9.9],
		["NormalTree_3",6.5,41.2,12.8],["MapleTree_4",2.9,45.4,7.0],
		["BirchTree_2",-6.4,45.5,10.6],["NormalTree_2",-11.8,47.5,13.6],
		["BirchTree_1",6.8,62.0,9.6],["BirchTree_4",8.5,64.7,10.2],
		["BirchTree_3",-8.1,85.8,9.9],["NormalTree_1",8.2,87.2,11.0]]:
		habitat_trees.append(BOTANY.place_tree(self,item[0],ground(item[1],item[2]),item[3],item[0].length()*1.1))
