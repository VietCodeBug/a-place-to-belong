extends Node3D

const PLAN = preload("res://scripts/world/village_a_layout.gd")
const L = preload("res://scripts/world/landscape.gd")
const S = preload("res://scripts/world/shapes.gd")
const A = preload("res://scripts/world/field_assets.gd")
const SURFACE = preload("res://shaders/village_a_surface.gdshader")
const MODELS := {
	"porch": preload("res://assets/village_a/porch.glb"),
	"gable": preload("res://assets/village_a/gable.glb"),
	"long": preload("res://assets/village_a/long.glb"),
	"craft": preload("res://assets/village_a/craft.glb"),
	"hall": preload("res://assets/village_a/hall.glb"),
	"hewn": preload("res://assets/a1_house_gate/hewn_eaves_cottage.glb"),
}
var palettes: Dictionary = {}
var route_material: ShaderMaterial
var seasonal: Array[Node3D] = []
var verge_meshes: Array[MultiMeshInstance3D] = []

func _ready() -> void:
	for spec in PLAN.BUILDINGS:
		building(spec)
	build_routes()
	build_shared_spaces()
	build_greenery()
	build_verges()
	set_season(0)

func at(p: Vector2,lift := 0.0) -> Vector3:
	return Vector3(p.x,L.height_at(p.x,p.y)+lift,p.y)

func building(spec: Array) -> void:
	var slot := Node3D.new()
	slot.name = spec[0]
	add_child(slot)
	var p := Vector2(spec[2],spec[3])
	slot.position = at(p)
	slot.rotation.y = spec[4]
	var visual := (MODELS[spec[1]] as PackedScene).instantiate() as Node3D
	slot.add_child(visual)
	coat(visual)
	var width: float = {"porch":5.13,"gable":5.6,"long":8.25,"hewn":6.7,"craft":6.02,"hall":7.47}[spec[1]]
	var depth := 5.06 if spec[1]=="hall" else 4.38
	var foundation := S.box(slot,Vector3(0,-.61,0),Vector3(width*.92,1.34,depth*.94),"807264")
	coat_mesh(foundation)
	S.box(slot,Vector3(0,1.62,0),Vector3(width,3.24,depth),"FFFFFF",true).hide()
	var entry := slot.to_global(Vector3(0.0,0,3.95))
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
		A.place(self,"quaternius","Rock_Moss_1",at(garden+Vector2(.27,.34)),.37)
		planter.name = "DoorGarden"
	var post := slot.to_global(Vector3(width*.37,0,3.05))
	lantern(at(Vector2(post.x,post.z)),false)

func coat(visual: Node3D) -> void:
	for child in visual.find_children("*","MeshInstance3D",true,false):
		coat_mesh(child as MeshInstance3D)

func coat_mesh(mesh: MeshInstance3D) -> void:
	for i in range(mesh.mesh.get_surface_count()):
		var source := mesh.get_active_material(i) as StandardMaterial3D
		if source==null or source.emission_enabled:
			continue
		var rgb := source.albedo_color
		var key := str(rgb)
		if not palettes.has(key):
			var mat := ShaderMaterial.new()
			mat.shader = SURFACE
			mat.set_shader_parameter("base_tint",rgb)
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
	var rng := RandomNumberGenerator.new()
	rng.seed = 3165
	for n in range(29):
		var z := 106.0+n*1.95
		var x := L.valley_path(z)+rng.randf_range(-1.05,1.17)
		var flat := A.place(self,"nature","rock_smallC",at(Vector2(x,z),-.012),.059,rng.randf()*TAU,"warm_stone")
		flat.scale.x = 2.5
		flat.scale.z = 1.7
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
		coat(table)
	A.place(common,"fantasy-town","cart",at(PLAN.CRAFT+Vector2(-.16,1.48)),1.10,.72)
	A.place(common,"nature","log_stack",at(PLAN.CRAFT+Vector2(1.07,-1.4)),.76,1.61)
	for p in [Vector2(-10.6,122.4),Vector2(14.8,128.8),Vector2(2.0,128.8),Vector2(9.3,143.8)]:
		lantern(at(p),true)

func build_greenery() -> void:
	for entry in [[-10,104,7.6],[-14,109,7.3],[17.9,105.1,8.7],[-17,123,9.2],[22.4,112.8,7.7],
		[21.9,137.2,7.1],[-8.4,130.3,6.6],[-16.4,150,8.3],[8.9,165.2,8.5],[-7.4,170.9,9.3],
		[15.9,173,10.0],[-14,169,10.3],[25,156,7.6]]:
		var p := Vector2(entry[0],entry[1])
		coat(A.place(self,"quaternius","PineTree_3",at(p),entry[2],p.x,"sage"))
	for i in range(4):
		var set := Node3D.new()
		set.name=["Autumn","Spring","Summer","Winter"][i]
		add_child(set)
		seasonal.append(set)
		for j in range(7):
			var p: Vector2 = [Vector2(-10.9,115.4),Vector2(9.4,119.9),Vector2(0.1,123.0),Vector2(9.4,135.8),
				Vector2(-5.8,142.3),Vector2(13.9,159.7),Vector2(-3.4,160.4)][j]
			if i==3:
				bare_tree(set,at(p),6.8+j%3*.52,j)
			else:
				leafy_tree(set,at(p),6.3+j%3*.68,j,i)
				if i==0:
					for k in range(7):
						var offset := Vector2(cos(k*2.2),sin(k*2.2))*1.54
						var leaf := S.box(set,at(p+offset,.013),Vector3(.16,.016,.086),"AD7043")
						leaf.rotation.y=k*1.48
		for j in range(32):
			var position := PLAN.GARDEN+Vector2((j%4-1.5)*1.14, float(j/4)*.46-1.52)
			if i==3:
				S.box(set,at(position,.091),Vector3(.51,.10,.37),"DCE8EF")
			else:
				A.place(set,"nature",["grass_leafs","flower_purpleB","flower_yellowA"][i],at(position,.08),[.21,.29,.46][i],j*.8)
		for j in range(10):
			var z := 109.0+5.18*j
			var p := Vector2(L.valley_path(z)+2.48*(-1 if j%2==0 else 1),z)
			if i==3:
				var cap := SphereMesh.new()
				cap.radial_segments=7
				cap.rings=3
				var snow := S.mesh(set,cap,at(p,.16),"D9E6EF")
				snow.scale=Vector3(1.17,.37,.71)
			else:
				A.place(set,"nature",["grass_large","flower_redC","flower_yellowA"][i],at(p),[.26,.34,.56][i],j)

func build_verges() -> void:
	var rng := RandomNumberGenerator.new()
	rng.seed = 20319
	var blade := PrismMesh.new()
	blade.size = Vector3(.17,.54,.062)
	var material := StandardMaterial3D.new()
	material.vertex_color_use_as_albedo = true
	material.roughness = 1.0
	blade.material = material
	for band in range(4):
		var locations: Array[Vector3] = []
		for cluster in range(16):
			var z := 103.0+17.0*band+rng.randf()*16.4
			var side := -1.0 if cluster%2==0 else 1.0
			var center := Vector2(L.valley_path(z)+side*rng.randf_range(2.75,6.4),z)
			for sample in range(27):
				var p := center+Vector2(rng.randfn(0,.74),rng.randfn(0,1.15))
				if p.distance_to(nearest_lane(p)) < 2.32 or p.distance_to(PLAN.COMMON) < 3.7:
					continue
				var on_lot := false
				for lot in PLAN.BUILDINGS:
					if p.distance_to(Vector2(lot[2],lot[3])) < 4.3:
						on_lot = true
						break
				if not on_lot:
					locations.append(at(p))
		var instances := MultiMesh.new()
		instances.transform_format = MultiMesh.TRANSFORM_3D
		instances.use_colors = true
		instances.mesh = blade
		instances.instance_count = locations.size()*3
		for i in locations.size():
			for j in range(3):
				var random_size := rng.randf_range(.35,.90)
				var yaw := rng.randf()*TAU
				var offset := Vector3(cos(yaw)*.07,random_size*.215,sin(yaw)*.07)
				var basis := Basis(Vector3.FORWARD,rng.randf_range(-.25,.25)).rotated(Vector3.UP,yaw)
				instances.set_instance_transform(i*3+j,Transform3D(basis.scaled(Vector3.ONE*random_size),locations[i]+offset))
				instances.set_instance_color(i*3+j,Color("4C6833").lerp(Color("A5A45C"),rng.randf()))
		var patch := MultiMeshInstance3D.new()
		patch.name = "PathVerge%d" % (band+1)
		patch.multimesh = instances
		patch.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
		patch.visibility_range_end = 52.0
		add_child(patch)
		verge_meshes.append(patch)

func leafy_tree(parent: Node3D, base: Vector3, height: float, seed: int, season: int) -> void:
	var fork := base + Vector3(.27, height*.52, .12)
	S.beam(parent,base,fork,.31,"6D5141")
	var colors: Array = [
		["A76538","C89049","DFA955","C58140","AB743F"],
		["749055","8DA65F","CE8FA7","E7AEC0","A7BC72"],
		["45693F","5C8048","678648","839957","729658"],
	][season]
	for k in range(5):
		var angle := k*2.39+seed
		var crown := fork+Vector3(cos(angle)*1.16,height*(.15+.103*(k%3)),sin(angle)*1.08)
		S.beam(parent,fork,crown,.13,"735946")
		var canopy := SphereMesh.new()
		canopy.radial_segments=8
		canopy.rings=3
		var leaves := S.mesh(parent,canopy,crown,colors[k])
		leaves.rotation.y=angle
		leaves.scale=Vector3(2.64,2.47,2.72)*(1.0+.13*sin(angle))

func bare_tree(parent: Node3D,base: Vector3,size: float,seed: int) -> void:
	var fork := base+Vector3(.18,size*.55,0)
	S.beam(parent,base,fork,.29,"796353")
	S.beam(parent,fork,base+Vector3(.38,size*.93,.17),.19,"877461")
	for branch in range(6):
		var angle := branch*2.33+seed
		var end := fork+Vector3(cos(angle)*1.88,size*(.23+branch*.018),sin(angle)*1.65)
		S.beam(parent,fork+Vector3.UP*(branch*.073),end,.10,"887663")
		S.beam(parent,end,end+Vector3(cos(angle+.38)*.57,.74,sin(angle+.38)*.51),.055,"A2988B")
		S.beam(parent,fork+Vector3.UP*.052,end+Vector3.UP*.04,.061,"D9E4EB")

func set_season(index: int) -> void:
	for patch in verge_meshes:
		patch.visible = index != 3
	for i in seasonal.size():
		seasonal[i].visible=i==index
	for mat: ShaderMaterial in palettes.values():
		mat.set_shader_parameter("snow",.91 if index==3 else 0.0)
	if route_material!=null:
		route_material.set_shader_parameter("village_snow",.96 if index==3 else 0.0)
