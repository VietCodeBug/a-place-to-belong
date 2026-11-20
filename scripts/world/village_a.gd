extends Node3D

const PLAN = preload("res://scripts/world/village_a_layout.gd")
const L = preload("res://scripts/world/landscape.gd")
const S = preload("res://scripts/world/shapes.gd")
const A = preload("res://scripts/world/field_assets.gd")
const BOTANY = preload("res://scripts/world/a1_botany.gd")
const SURFACE = preload("res://shaders/village_a_surface.gdshader")
const MODELS := {
	"porch": preload("res://assets/village_a/porch.glb"),
	"gable": preload("res://assets/village_a/gable.glb"),
	"long": preload("res://assets/village_a/long.glb"),
	"craft": preload("res://assets/village_a/craft.glb"),
	"chapel": preload("res://assets/village_a/chapel.glb"),
	"barn": preload("res://assets/village_a/barn.glb"),
	"stonehouse": preload("res://assets/village_a/stonehouse.glb"),
	"gallery": preload("res://assets/village_a/gallery.glb"),
	"split": preload("res://assets/village_a/split.glb"),
	"loft": preload("res://assets/village_a/loft.glb"),
	"shed": preload("res://assets/village_a/shed.glb"),
	"wing": preload("res://assets/village_a/wing.glb"),
	"hewn": preload("res://assets/a1_house_gate/hewn_eaves_cottage.glb"),
}
var palettes: Dictionary = {}
var route_material: ShaderMaterial
var seasonal: Array[Node3D] = []
var trees: Array[Node3D] = []
var verge_meshes: Array[MultiMeshInstance3D] = []

func _ready() -> void:
	for spec in PLAN.BUILDINGS:
		building(spec)
	build_routes()
	build_shared_spaces()
	build_greenery()
	build_verges()
	set_season(BOTANY.DEFAULT_SEASON)

func at(p: Vector2,lift := 0.0) -> Vector3:
	return Vector3(p.x,L.height_at(p.x,p.y)+lift,p.y)

func building(spec: Array) -> void:
	var slot := Node3D.new()
	slot.name = spec[0]
	if spec[1]=="chapel":
		slot.set_meta("landmark","chapel")
	add_child(slot)
	var p := Vector2(spec[2],spec[3])
	slot.position = at(p)
	slot.rotation.y = spec[4]
	var visual := (MODELS[spec[1]] as PackedScene).instantiate() as Node3D
	slot.add_child(visual)
	coat(visual)
	var width: float = {"porch":5.13,"gable":5.6,"long":8.25,"hewn":6.7,"craft":6.02,"chapel":6.95,"barn":5.7,"stonehouse":4.74,"gallery":5.32,"split":6.08,"loft":4.54,"shed":3.74,"wing":5.62}[spec[1]]
	var depth: float = {"chapel":5.07,"barn":4.32,"stonehouse":4.67,"gallery":4.42,"loft":4.90,"shed":3.22,"wing":4.40,"split":4.42}.get(spec[1],4.38)
	var center_x := .63 if spec[1] in ["split","wing"] else 0.0
	var foundation := S.box(slot,Vector3(center_x,-.61,0),Vector3(width*.92,1.34,depth*.94),"807264")
	coat_mesh(foundation)
	S.box(slot,Vector3(center_x,1.62,0),Vector3(width,3.24,depth),"FFFFFF",true).hide()
	var front_offsets := {"porch":-.66,"gable":.82,"long":-1.16,"craft":-1.01,"split":.46,"loft":-.85,"shed":-.59,"wing":-.59,"barn":.62,"stonehouse":.72,"gallery":-.91}
	var entry := slot.to_global(Vector3(front_offsets.get(spec[1],0.0),0,depth*.5 + 1.28))
	var door := Vector2(entry.x,entry.z)
	var nearest := nearest_lane(door)
	if door.distance_to(nearest) > .38:
		route([door,nearest],0.59)
	# Gardens follow the facade instead of being scattered inside the road.
	for side in [-1,1]:
		var corner := slot.to_global(Vector3(side*width*.47,0,3.48))
		var garden := Vector2(corner.x,corner.z)
		var distance := garden.distance_to(nearest_lane(garden))
		if distance < 1.60:
			continue
		var planter := A.place(self,"nature","flower_purpleB" if side<0 else "flower_yellowA",at(garden),0.36,slot.rotation.y)
		BOTANY.place_stone(self,at(garden+Vector2(.27,.34)),.48,float(side))
		planter.name = "DoorGarden"
	var post := slot.to_global(Vector3(width*.37,0,3.05))
	lantern(at(Vector2(post.x,post.z)),false)

func coat(visual: Node3D, old_cottage := false) -> void:
	for child in visual.find_children("*","MeshInstance3D",true,false):
		coat_mesh(child as MeshInstance3D,old_cottage)

func coat_mesh(mesh: MeshInstance3D, old_cottage := false) -> void:
	for i in range(mesh.mesh.get_surface_count()):
		var source := mesh.get_active_material(i) as StandardMaterial3D
		if source == null:
			continue
		var label := source.resource_name.to_lower()
		if source.emission_enabled:
			if label.contains("glass"):
				var glass_key := "glass:"+str(source.albedo_color)
				if not palettes.has(glass_key):
					var glass := source.duplicate() as StandardMaterial3D
					glass.emission_energy_multiplier = .32
					glass.albedo_color = glass.albedo_color.lerp(Color("A69870"),.45)
					palettes[glass_key] = glass
				mesh.set_surface_override_material(i,palettes[glass_key])
			continue
		var rgb := source.albedo_color
		if old_cottage:
			if label.contains("limewash"):
				rgb = rgb.lerp(Color("B4A58E"),.62)
			elif label.contains("oak") or label.contains("clay") or label.contains("slate"):
				rgb = rgb.darkened(.24)
		var key := "%s/%s" % [rgb,old_cottage]
		if not palettes.has(key):
			var mat := ShaderMaterial.new()
			mat.shader = SURFACE
			mat.set_shader_parameter("base_tint",rgb)
			mat.set_shader_parameter("age",.87 if old_cottage else .56)
			palettes[key] = mat
		mesh.set_surface_override_material(i,palettes[key])

func nearest_lane(p: Vector2) -> Vector2:
	var best := Vector2(L.valley_path(p.y),p.y)
	for lane in PLAN.LANES:
		for i in range(lane.size()-1):
			var q := Geometry2D.get_closest_point_to_segment(p,lane[i],lane[i+1])
			if q.distance_squared_to(p)<best.distance_squared_to(p):
				best=q
	return best

func build_routes() -> void:
	route(PLAN.HOUSE_APPROACH,1.10)
	for lane in PLAN.LANES:
		route(lane,0.96)
	var exit_path: Array[Vector2] = []
	for z in range(165,185,2):
		exit_path.append(Vector2(L.valley_path(z),z))
	route(exit_path,1.22)
	# Inlaid stone clusters at thresholds and junctions, with earth remaining between them.
	var rng := RandomNumberGenerator.new()
	rng.seed = 3165
	for junction in [111.0,123.2,128.0,140.4,151.9,161.8]:
		for n in range(8):
			var z: float = junction + (n%4-1.5)*.39
			var x := L.valley_path(z) + (n/4-.5)*.70+rng.randf_range(-.12,.12)
			var flat := BOTANY.place(self,"Rock_4",at(Vector2(x,z),-.032),.073,rng.randf()*TAU)
			flat.scale.x = rng.randf_range(1.7,2.9)
			flat.scale.z = rng.randf_range(1.3,2.3)
			for rock in flat.find_children("*","MeshInstance3D",true,false):
				rock.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	for z in [103.0,114.0,130.0,145.0,157.0,169.0]:
		lantern(at(Vector2(L.valley_path(z)+2.02,z)),true)

func route(points: Array, half_width: float) -> void:
	var mesh := SurfaceTool.new()
	mesh.begin(Mesh.PRIMITIVE_TRIANGLES)
	for i in range(points.size()-1):
		var a: Vector2 = points[i]
		var b: Vector2 = points[i+1]
		var side := (b-a).normalized().orthogonal()
		var steps := maxi(2,ceili(a.distance_to(b)*2.0))
		for step in range(steps):
			var p := a.lerp(b,float(step)/steps)
			var q := a.lerp(b,float(step+1)/steps)
			for entry in [[p,-1.0],[p,1.0],[q,-1.0],[p,1.0],[q,1.0],[q,-1.0]]:
				var center: Vector2 = entry[0]
				var offset: float = entry[1]*(half_width+.29)
				mesh.set_uv(Vector2(offset,half_width))
				mesh.add_vertex(at(center+side*offset,.044))
	mesh.generate_normals()
	var street := MeshInstance3D.new()
	street.mesh=mesh.commit()
	street.cast_shadow=GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	if route_material==null:
		route_material=ShaderMaterial.new()
		route_material.shader=preload("res://shaders/forest_path.gdshader")
	route_material.set_shader_parameter("continuous_trail",true)
	route_material.set_shader_parameter("potholes",L.road_potholes())
	street.material_override=route_material
	add_child(street)

func lantern(base:Vector3,tall:bool) -> void:
	var height := 1.64 if tall else .71
	S.box(self,base+Vector3.UP*(height*.49),Vector3(.12,height,.12),"70523B")
	var fixture := A.place(self,"fantasy-town","lantern",base+Vector3.UP*(height-.04),.41)
	fixture.rotation.y=.27
	var light := OmniLight3D.new()
	light.light_color=Color("FFC180")
	light.light_energy=.15
	light.omni_range=2.2
	add_child(light)
	light.position=base+Vector3.UP*(height+.23)

func build_shared_spaces() -> void:
	var garden := Node3D.new()
	garden.name="SharedGarden"
	add_child(garden)
	for row in range(4):
		var x := PLAN.GARDEN.x+(row-1.5)*1.14
		for z in [118.6,119.6,120.6,121.6]:
			var soil := at(Vector2(x,z))
			S.box(garden,soil+Vector3.UP*.029,Vector3(.75,.08,1.02),"79553D")
			S.box(garden,soil+Vector3(.41,.053,0),Vector3(.078,.132,1.03),"977653")
		for z in [117.9,122.1]:
			coat(A.place(garden,"fantasy-town","fence",at(Vector2(x,z)),.63,0))
	var common := Node3D.new()
	common.name="SharedCourtyard"
	add_child(common)
	route([PLAN.COMMON+Vector2(-3.0,0),PLAN.COMMON+Vector2(2.4,0)],2.35)
	route([PLAN.CRAFT+Vector2(-1.5,0),PLAN.CRAFT+Vector2(2.0,.2)],1.85)
	for dx in [-2.9,2.5]:
		var table := A.place(common,"fantasy-town","stall-bench",at(PLAN.COMMON+Vector2(dx,0.3)),.82,1.48)
		A.recolor(table,"836C52")
	A.place(common,"fantasy-town","cart",at(PLAN.CRAFT+Vector2(-.16,1.48)),1.10,.72)
	A.place(common,"nature","log_stack",at(PLAN.CRAFT+Vector2(1.07,-1.4)),.76,1.61)
	for p in [Vector2(-10.6,122.4),Vector2(14.8,128.8),Vector2(2.0,128.8),Vector2(9.3,143.8)]:
		lantern(at(p),true)

func build_greenery() -> void:
	var tree_plan := [
		["BirchTree_2",-10.1,103.4,10.0],["BirchTree_1",-12.4,107.5,7.5],
		["BirchTree_4",21.7,106.3,8.4],["NormalTree_1",2.1,119.9,11.3],
		["MapleTree_2",-2.4,123.8,8.6],["NormalTree_5",9.25,124.5,6.2],
		["PineTree_2",26.4,113.9,12.6],["BirchTree_3",-20.2,122.4,9.8],
		["NormalTree_4",9.8,135.8,8.4],["PineTree_4",27.0,136.8,12.1],
		["NormalTree_3",-4.1,143.8,10.4],["BirchTree_1",11.1,142.7,8.6],
		["NormalTree_4",12.1,168.1,11.3],["PineTree_5",-11.2,169.2,11.8],
		["PineTree_1",-18.2,168.1,13.0],["BirchTree_5",18.1,171.2,9.7],
		["NormalTree_2",26.4,154.8,11.0],["BirchTree_2",-9.8,155.2,9.0],
	]
	for item in tree_plan:
		var p := Vector2(item[1],item[2])
		if is_open_ground(p,1.4):
			trees.append(BOTANY.place_tree(self,item[0],at(p),item[3],p.x))
	for i in range(4):
		var set := Node3D.new()
		set.name=["Autumn","Spring","Summer","Winter"][i]
		add_child(set)
		seasonal.append(set)
		for j in range(24):
			var z := 105.4 + j*2.96
			var x := L.valley_path(z) + (-1.0 if j%2==0 else 1.0)*(2.9+.49*sin(j*2.7))
			var p := Vector2(x,z)
			if not is_open_ground(p,1.85):
				continue
			if i==3:
				snow_bank(set,p,.65+.27*absf(sin(j)),.9 + .18*cos(j))
			else:
				BOTANY.place(set,"Flower_4_Clump" if i!=0 and j%3!=0 else "Bush_Large",
					at(p),[.52,.42,.61][i]+.15*absf(sin(j)),j*1.31)
		if i == 3:
			for x in [-9.5,-8.4,-7.3,-6.2]:
				snow_bank(set,Vector2(x,122.32),.46,.30)

func is_open_ground(p: Vector2, lane_clearance: float) -> bool:
	if p.distance_to(nearest_lane(p)) < lane_clearance:
		return false
	if p.distance_to(PLAN.GARDEN) < 2.5 or p.distance_to(PLAN.COMMON) < 3.15:
		return false
	for lot in PLAN.BUILDINGS:
		if p.distance_to(Vector2(lot[2],lot[3])) < 3.3:
			return false
	return true

func snow_bank(parent: Node3D, p: Vector2, width: float, length: float) -> void:
	var mesh := SurfaceTool.new()
	mesh.begin(Mesh.PRIMITIVE_TRIANGLES)
	for i in range(10):
		var angle := TAU*i/10.0
		var next := TAU*(i+1)/10.0
		for point in [Vector3(p.x, L.height_at(p.x,p.y)+.24,p.y),
			at(p+Vector2(cos(angle)*width,sin(angle)*length),.028),
			at(p+Vector2(cos(next)*width,sin(next)*length),.028)]:
			mesh.add_vertex(point)
	mesh.generate_normals()
	var bank := S.mesh(parent,mesh.commit(),Vector3.ZERO,"D6E3EB")
	bank.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF

func build_verges() -> void:
	var rng := RandomNumberGenerator.new()
	rng.seed = 20319
	for band in range(4):
		var locations: Array[Vector3] = []
		for cluster in range(8):
			var z := 103.0+17.0*band+rng.randf()*16.4
			var side := -1.0 if cluster%2==0 else 1.0
			var center := Vector2(L.valley_path(z)+side*rng.randf_range(2.85,4.4),z)
			for sample in range(27):
				var p := center+Vector2(rng.randfn(0,.36),rng.randfn(0,.92))
				if p.distance_to(nearest_lane(p)) < 2.32 or p.distance_to(PLAN.COMMON) < 3.7:
					continue
				var on_lot := false
				for lot in PLAN.BUILDINGS:
					if p.distance_to(Vector2(lot[2],lot[3])) < 4.3:
						on_lot = true
						break
				if not on_lot:
					locations.append(at(p))
		var patch := BOTANY.grass_batch(self,locations,31613+band,52.0,.20)
		patch.name = "PathVerge%d" % (band+1)
		verge_meshes.append(patch)

func set_season(index: int) -> void:
	for tree in trees:
		BOTANY.season_tree(tree,index)
	for patch in verge_meshes:
		patch.visible = index != 3
	for i in seasonal.size():
		seasonal[i].visible=i==index
	for mat in palettes.values():
		if mat is ShaderMaterial:
			mat.set_shader_parameter("snow",.91 if index==3 else 0.0)
	if route_material!=null:
		route_material.set_shader_parameter("village_snow",.96 if index==3 else 0.0)
