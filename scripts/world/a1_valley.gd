extends Node3D

const BOTANY = preload("res://scripts/world/a1_botany.gd")
const VILLAGE = preload("res://scripts/world/village_a.gd")
const L = preload("res://scripts/world/landscape.gd")
const S = preload("res://scripts/world/shapes.gd")
const A = preload("res://scripts/world/field_assets.gd")
const MAPS = preload("res://scripts/story/map_flow.gd")
var rabbits: Array[Node3D] = []
var squirrels: Array[Node3D] = []
var birds: Array[Node3D] = []
var clock := 0.0
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
	build_mountains()
	build_distant_foothills()
	build_river()
	build_bridge()
	build_groves()
	var village := VILLAGE.new()
	village.name = "VillageA"
	add_child(village)
	build_overlook()
	build_reveal()
	build_understory()
	detail_slices()
	set_season_palette(0)
	for argument in OS.get_cmdline_user_args():
		if argument.begins_with("--a1-season="):
			var season := ["autumn", "spring", "summer", "winter"].find(argument.get_slice("=", 1))
			if season >= 0:
				set_season_palette(season)
	for at in [Vector2(4, 37), Vector2(-7, 56), Vector2(5, 93)]:
		rabbits.append(small_animal(at, true))
	for at in [Vector2(-6, 44), Vector2(12, 91)]:
		squirrels.append(small_animal(at, false))
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
	water.material_override = material
	water.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	add_child(water)
	# The river is a visible boundary until swimming is introduced.
	for side in [-1, 1]:
		for x in range(-39, 40, 2):
			if abs(x) < 3:
				continue
			S.box(self, Vector3(x, 2.2, L.river_center(x) + side * 5.2), Vector3(2.1, 4, 0.9), "FFFFFF", true).hide()

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

func build_groves() -> void:
	var rng := RandomNumberGenerator.new()
	rng.seed = 19841
	for i in range(190):
		var z := rng.randf_range(26, 183)
		var x := rng.randf_range(-39, 39)
		var near_water := absf(z - L.river_center(x)) < 8.4
		var path_gap := absf(x - L.valley_path(z))
		if near_water or L.in_overlook_view(x, z) or path_gap < 4.8 or (z > 102 and z < 167 and x > -20 and x < 26):
			continue
		if z > 55 and z < 95 and absf(x) < 11:
			continue
		var at := ground(x, z)
		var height := rng.randf_range(5.7, 13.0)
		var yaw := rng.randf_range(0,TAU)
		var rim := absf(x) > 16.0
		var family: String = ["PineTree","BirchTree","NormalTree","MapleTree"][i%4]
		if rim and i%3!=0:
			family = "PineTree"
		var tree := BOTANY.place_tree(self,"%s_%d" % [family,1+i%5],at,height,yaw)
		habitat_trees.append(tree)
		S.box(self, at + Vector3.UP * 1.5, Vector3(0.8, 3, 0.8), "FFFFFF", true).hide()
	for i in range(132):
		var z := rng.randf_range(29, 103)
		var x := L.valley_path(z) + rng.randf_range(3.0, 12.0) * (-1.0 if i % 2 == 0 else 1.0)
		if absf(z - L.river_center(x)) < 6.2:
			continue
		var at := ground(x, z)
		if i % 5 == 0:
			facet(self, at + Vector3.UP * 0.27, Vector3(1.04, 0.74, 0.90), "81877B")
		else:
			facet(self, at + Vector3.UP * 0.17, Vector3(0.53, 0.42, 0.50), ["708650", "8B9E5B", "5B794B"][i % 3])
			if i % 3 == 0:
				for petal in range(3):
					facet(self, at + Vector3(0.14 * petal - 0.13, 0.39, sin(petal) * 0.18),
						Vector3(0.13, 0.09, 0.13), ["E8B66A", "E2D4B2", "B69BC5"][i % 3])

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

func small_animal(at: Vector2, rabbit: bool) -> Node3D:
	var animal := Node3D.new()
	add_child(animal)
	animal.position = ground(at.x, at.y)
	animal.set_meta("home", at)
	var fur := "A59079" if rabbit else "AB603F"
	facet(animal, Vector3(0, 0.21, 0), Vector3(0.31, 0.37, 0.53), fur)
	facet(animal, Vector3(0, 0.34, 0.23), Vector3(0.28, 0.26, 0.28), fur)
	for side in [-1, 1]:
		facet(animal, Vector3(side * 0.079, 0.49 if rabbit else 0.44, 0.18),
			Vector3(0.087, 0.29 if rabbit else 0.14, 0.085), fur)
		facet(animal, Vector3(side * 0.113, 0.38, 0.29), Vector3(0.035, 0.039, 0.03), "352924")
		facet(animal, Vector3(side * 0.105, 0.08, 0.065), Vector3(0.14, 0.12, 0.26), fur)
	var tail := facet(animal, Vector3(0, 0.25 if rabbit else 0.39, -0.26),
		Vector3(0.15, 0.15, 0.15) if rabbit else Vector3(0.23, 0.52, 0.25), "E4D6C2" if rabbit else "9B5038")
	tail.rotation.x = 0.37
	return animal

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
	for animal in rabbits + squirrels:
		var home: Vector2 = animal.get_meta("home")
		var visit := clock * 0.7 + home.y
		var pace := clampf(sin(visit * 1.8), 0.0, 1.0)
		var p := home + Vector2(sin(visit * 0.42), cos(visit * 0.42)) * 1.65
		animal.position = ground(p.x, p.y) + Vector3.UP * pace * absf(sin(visit * 5.0)) * 0.17
		animal.rotation.y = visit * 0.42 + PI * 0.5
	for i in birds.size():
		var bird := birds[i]
		var t := clock * 0.24 + i * 0.13
		bird.position = Vector3(29.0 * sin(t), 24.0 + i * 0.42 + sin(t * 2.0), 83.0 + 25.0 * cos(t) + i * 1.4)
		bird.rotation.y = atan2(cos(t) * 29.0, -sin(t) * 25.0)
		bird.get_child(1).rotation.z = sin(clock * 8.1 + i * 0.76) * 0.58
		bird.get_child(2).rotation.z = -bird.get_child(1).rotation.z

func detail_slices() -> void:
	var rng := RandomNumberGenerator.new()
	rng.seed = 92714
	var anchors := [Vector2(-22,50),Vector2(-13,52),Vector2(-27,57),Vector2(-31,50),
		Vector2(-10,63),Vector2(-23,66),Vector2(12,61),Vector2(11,84),Vector2(-10,102),
		Vector2(13,105),Vector2(0,112),Vector2(12,115),Vector2(4,124),Vector2(18,121)]
	for cluster in anchors.size():
		var center: Vector2 = anchors[cluster]
		for i in range(13):
			var p := center + Vector2(rng.randf_range(-4,4),rng.randf_range(-3,3))
			if absf(p.x-L.valley_path(p.y)) < 2.35:
				continue
			var at := ground(p.x,p.y)
			if i % 6 == 0:
				A.place(self,"quaternius","Rock_Moss_1",at,rng.randf_range(0.27,0.83),rng.randf_range(0,TAU))
			elif i % 4 == 0:
				A.place(self,"nature", ["flower_purpleB","flower_yellowA","flower_redC"][cluster%3],at,0.35+i*0.013,i)
			else:
				A.place(self,"nature","grass_leafs" if i%3==0 else "grass_large",at,rng.randf_range(0.21,0.50),i)
	for i in range(8):
		var x := -30.0 + 3.3 * i
		var z := 53.5 + 5.2 * sin(i*2.0)
		if L.in_overlook_view(x, z):
			continue
		var code := "BirchTree_3" if i%3==0 else "PineTree_%d" % (1+i%5)
		habitat_trees.append(BOTANY.place_tree(self,code,ground(x,z),7.5+float(i%4)*1.75,i))
	for side in [-1, 1]:
		for i in range(13):
			var x := -25.0 + i * 3.85
			if absf(x) < 3.2:
				continue
			var at := ground(x,L.river_center(x)+side*(5.7+0.42*sin(i*2.01)))
			A.place(self,"nature","rock_smallC",at,0.34+0.38*absf(sin(i)),i,"warm_stone")
			A.place(self,"nature","grass_leafs",at+Vector3(0.53,0,0.17),0.49,i)

func build_understory() -> void:
	var rng := RandomNumberGenerator.new()
	rng.seed = 88157
	for patch_z in [34.0,44.0,56.0,89.0]:
		var tufts: Array[Vector3] = []
		for cluster in range(11):
			var bank := -1.0 if cluster%2==0 else 1.0
			var z: float = patch_z + rng.randf_range(-4.2,4.2)
			var x := L.valley_path(z) + bank * rng.randf_range(2.7,8.9)
			for sample in range(24):
				var p := Vector2(x+rng.randfn(0,.90),z+rng.randfn(0,1.22))
				if absf(p.x-L.valley_path(p.y)) < 2.48:
					continue
				tufts.append(ground(p.x,p.y))
			if cluster%2==0:
				var shrub := "Bush_Large" if cluster%4==0 else "Flower_4_Clump"
				habitat_floor.append(BOTANY.place(self,shrub,ground(x,z),.58 if cluster%4==0 else .37,cluster*1.9))
		var layer := BOTANY.grass_batch(self,tufts,int(patch_z)+1309,38.0)
		layer.name = "ForestUnderstory%d" % int(patch_z)
		habitat_floor.append(layer)

func set_season_palette(season: int) -> void:
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
	get_node("VillageA").set_season(season)

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
