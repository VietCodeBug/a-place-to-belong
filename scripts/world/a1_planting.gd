extends Node3D
## Authored habitat clumps and planted crops. One MultiMesh per local mesh/season group.
const A = preload("res://scripts/world/a1_botany.gd")
const L = preload("res://scripts/world/landscape.gd")
const S = preload("res://scripts/world/shapes.gd")
const PLAN = preload("res://scripts/world/village_a_layout.gd")
const DIR := "res://assets/vegetation/a1_gardens/"
const KENNEY := "res://assets/vendor/kenney/nature/"
const WILD := [
	[Vector2(7.35,12.45),["Flower_1","Flower_3_Clump","Bush_Small_Flowers"]],
	[Vector2(11.55,17.0),["Flower_2","Flower_5_Clump","Flower_3_Clump"]],
	[Vector2(-6.35,16.2),["Plant_Flowers","flower_yellowA","flower_purpleB"]],
	[Vector2(5.4,21.7),["Flower_1","Flower_4_Clump","Flower_5_Clump"]],
	[Vector2(-9.75,33.5),["Flower_3_Clump","flower_yellowA","Plant_Flowers"]],
	[Vector2(5.45,42.2),["Flower_2","Flower_5_Clump","flower_redC"]],
	[Vector2(-15.0,55.7),["Flower_1","Flower_4_Clump","flower_purpleB"]],
	[Vector2(8.0,66.45),["Plant_Flowers","Flower_3_Clump","Plant_Flowers"]],
	[Vector2(-7.1,84.2),["Flower_2","Flower_4_Clump","Plant_Flowers"]],
	[Vector2(8.8,94.25),["Flower_1","Flower_5_Clump","flower_purpleB"]],
	[Vector2(-5.5,113.1),["Flower_2","Flower_4_Clump","flower_redC"]],
	[Vector2(-6.2,123.6),["Flower_1","Flower_5_Clump","Bush_Small_Flowers"]],
	[Vector2(9.0,134.25),["Flower_3_Clump","Flower_4_Clump","Flower_5_Clump"]],
	[Vector2(-4.45,155.35),["Flower_2","flower_yellowA","flower_redC"]],
	[Vector2(9.7,168.1),["Flower_1","Flower_5_Clump","Plant_Flowers"]],
	[Vector2(-1.2,176.4),["Plant_Flowers","Flower_4_Clump","flower_purpleB"]],
]
# Meadow pockets follow the trail sequence. Each pocket gets one or two flower types.
const BLOOMS := [
	["Flower_1","Flower_5_Clump"],
	["Flower_3_Clump","Plant_Flowers"],
	["Flower_2","Flower_4_Clump"],
]
var verge_cover: Array[MultiMeshInstance3D] = []
var seasons: Array[Node3D] = []

func _ready() -> void:
	for i in range(4):
		var group := Node3D.new()
		group.name = ["Autumn","Spring","Summer","Winter"][i]
		add_child(group)
		seasons.append(group)
		if i!=3:
			flowers(group,i)
		crops(group,i)
	build_verge_cover()
	garden_tools()
	set_season(A.DEFAULT_SEASON)

func set_season(index: int) -> void:
	A.grass_season(index)
	for patch in verge_cover:
		patch.visible = index!=3
	for i in seasons.size():
		seasons[i].visible = i==index

func build_verge_cover() -> void:
	var rng := RandomNumberGenerator.new()
	rng.seed = 27184
	var village := get_parent().get_node("VillageA")
	for segment in range(PLAN.HOUSE_APPROACH.size()-1):
		var a: Vector2 = PLAN.HOUSE_APPROACH[segment]
		var b: Vector2 = PLAN.HOUSE_APPROACH[segment+1]
		var side := (b-a).normalized().orthogonal()
		# A jittered ground grid gives consistent coverage while the height and
		# outer edge undulate over several metres.
		var carpet: Array[Vector3] = []
		var skirts: Array[Vector3] = []
		var length := a.distance_to(b)
		var rows := ceili(length / .38)
		for row in rows:
			var t := (row+.5)/rows
			var center := a.lerp(b,t)
			for direction in [-1.0,1.0]:
				var shoulder := 5.8 + 1.55*sin(center.y*.18+direction)
				for column in 17:
					var offset := 1.39+column*.38+rng.randf_range(-.135,.135)
					var p: Vector2 = center+side*offset*direction + (b-a).normalized()*rng.randf_range(-.115,.115)
					if offset > shoulder or not can_plant_forest(p,.09):
						continue
					carpet.append(position_on_ground(p,-.012))
				for column in 7:
					var offset := shoulder+column*.82+rng.randf_range(-.28,.28)
					var p: Vector2 = center+side*offset*direction
					if row%2!=0 or not can_plant_forest(p,.18):
						continue
					skirts.append(position_on_ground(p,-.016))
		verge_cover.append(A.grass_batch(self,carpet,segment+803,32.0,.23,1.57))
		verge_cover.append(A.grass_batch(self,skirts,segment+1203,46.0,.22,2.3,true))

	var house_carpet: Array[Vector3] = []
	for row in range(-25,28):
		for column in range(-36,23):
			var offset := Vector2(column,row)*.36 + Vector2(rng.randf_range(-.13,.13),rng.randf_range(-.13,.13))
			var p := PLAN.HOUSE_A + offset
			var radius := offset/Vector2(13.6,10.5)
			if radius.length() > 1.0+.09*sin(offset.x*1.9+offset.y*1.6) or not can_plant_forest(p,.11):
				continue
			house_carpet.append(position_on_ground(p,-.01))
	verge_cover.append(A.grass_batch(self,house_carpet,6701,44.0,.25,1.54))
	for band in [32,52,71,90,107,128,148,169]:
		var cover: Array[Vector3] = []
		for i in range(430):
			var z: float = band + rng.randf_range(-6.2,7.0)
			var offset := rng.randf_range(2.75,5.30) * (-1.0 if i%2==0 else 1.0)
			var p := Vector2(L.valley_path(z)+offset,z)
			if absf(p.y-L.river_center(p.x))<6.4:
				continue
			if z>=100 and not village.is_open_ground(p,2.05):
				continue
			cover.append(position_on_ground(p,-.008))
		var patch := A.grass_batch(self,cover,int(band),34.0,.20,1.45)
		patch.name = "MeadowVerge%d" % int(band)
		verge_cover.append(patch)

func can_plant_forest(p: Vector2, margin: float) -> bool:
	return absf(p.x)<23.85 and p.y>L.WOODLAND_START and not ForestFloorDesign.reserved(p,margin)

func position_on_ground(p: Vector2, lift: float = 0.0) -> Vector3:
	return Vector3(p.x,L.height_at(p.x,p.y)+lift,p.y)

func flowers(parent: Node3D, season: int) -> void:
	var rng := RandomNumberGenerator.new()
	rng.seed = 10439
	forest_flowers(parent,season,rng)
	for cluster in WILD:
		var center: Vector2 = cluster[0]
		var id: String = cluster[1][[2,0,1][season]]
		var poses: Array[Transform3D] = []
		for i in range(5 if season==0 else 8):
			var p := center+Vector2(rng.randfn(0,.34),rng.randfn(0,.32))
			if absf(p.x)>38.0 or p.y<23 and ForestFloorDesign.reserved(p,.16):
				continue
			if p.y>=24.0 and absf(p.x-L.valley_path(p.y))<2.7:
				continue
			if p.y>=100.0 and not get_parent().get_node("VillageA").is_open_ground(p,1.25):
				continue
			poses.append(pose(p,.007,rng.randf_range(.70,1.19),rng.randf()*TAU))
		var kenney := id.begins_with("flower_")
		var folder := KENNEY if kenney else A.DIR if id=="Flower_4_Clump" else DIR
		batch(parent,id,folder,.29 if season!=2 else .39,poses,not kenney,38.0)

func forest_flowers(parent: Node3D, season: int, rng: RandomNumberGenerator) -> void:
	var grouping := Node3D.new()
	grouping.name = "ForestFlowers"
	parent.add_child(grouping)
	for segment in range(PLAN.HOUSE_APPROACH.size()-1):
		var a: Vector2 = PLAN.HOUSE_APPROACH[segment]
		var b: Vector2 = PLAN.HOUSE_APPROACH[segment+1]
		var side := (b-a).normalized().orthogonal()
		var ids: Array = BLOOMS[(floori(segment * .5) + season)%BLOOMS.size()]
		for i in range(1 if season==0 else 2):
			var center := a.lerp(b,.27+i*.48)+side*(2.35+i*.85)*(-1.0 if (segment+i)%2==0 else 1.0)
			flower_pocket(grouping,ids[i],center,Vector2(2.0,2.7),24 if season==0 else 43,rng)

	for center in [Vector2(-4.35,-2.0),Vector2(-6.4,-4.0),Vector2(-8.0,2.45),Vector2(-3.8,3.2),Vector2(-9.2,-5.2),Vector2(-10.6,-.2)]:
		var id: String = BLOOMS[rng.randi_range(0,BLOOMS.size()-1)][season%2]
		flower_pocket(grouping,id,PLAN.HOUSE_A+center,Vector2(1.65,1.30),36 if season==0 else 68,rng)

func flower_pocket(parent: Node3D, id: String, center: Vector2, radius: Vector2, count: int, rng: RandomNumberGenerator) -> void:
	var poses: Array[Transform3D] = []
	for i in count:
		var offset := Vector2.from_angle(rng.randf()*TAU)*sqrt(rng.randf())*radius
		var p := center+offset
		if can_plant_forest(p,.26):
			poses.append(pose(p,.004,rng.randf_range(.80,1.21),rng.randf()*TAU))
	var folder := A.DIR if id=="Flower_4_Clump" else DIR
	batch(parent,id,folder,.35,poses,true,33.0)

func crops(parent: Node3D, season: int) -> void:
	var garden := Node3D.new()
	garden.name = "VegetableBeds"
	parent.add_child(garden)
	var varieties: Array = [
		["Carrot_4", "Beet_3", "", "Pumpkin_4"],
		["Carrot_2", "Lettuce_2", "Tomato_2", "Pumpkin_2"],
		["Carrot_4", "Lettuce_4", "Tomato_4", "Pumpkin_2"],
		["", "Lettuce_2", "", ""],
	][season]
	for row in range(4):
		var id: String = varieties[row]
		if id.is_empty():
			continue
		var poses: Array[Transform3D] = []
		var height: float = [.40,.29,.74,.43][row]
		if season==1:
			height *= .69
		for plant in range(4 if row!=3 else 3):
			var p := Vector2(PLAN.GARDEN.x+(row-1.5)*1.14+sin(plant*1.6)*.045,
				118.63+plant*(.83 if row!=3 else 1.27))
			var rooted := .085
			if id.begins_with("Carrot") or id.begins_with("Beet"):
				rooted -= height*.53
			poses.append(pose(p,rooted,.89+.13*cos(plant*2.3),plant*.62))
		batch(garden,id,DIR,height,poses,false,58.0)
	if season<3:
		var p := Vector2(-13.8,123.35)
		for i in range(3):
			var plant: Array[Transform3D] = [pose(p+Vector2(0,i*.45),.08,1.0,i*.8)]
			batch(garden,"Lettuce_2" if season==1 else "Beet_3",DIR,.29,plant,false,36.0)
	if season in [0,2]:
		var corn: Array[Transform3D] = []
		for i in range(4):
			corn.append(pose(Vector2(-10.3,119.05+i*.47),.03,1.0,i*.62))
		batch(garden,"Corn_4",DIR,1.04,corn,false,45.0)

func garden_tools() -> void:
	for i in range(4):
		var p := Vector2(PLAN.GARDEN.x+.70,118.60+i*.83)
		var foot := position_on_ground(p)
		S.beam(self,foot,foot+Vector3(.06,1.07,.04),.031,"85664B")
	for i in [0,1]:
		var p := Vector2(-13.8,123.35+i*.90)
		S.box(self,position_on_ground(p,.044),Vector3(.58,.10,.90),"76543B")
	var crate := position_on_ground(Vector2(-10.15,121.72),.12)
	S.box(self,crate,Vector3(.49,.19,.39),"76513A")
	for side in [-1.0,1.0]:
		S.box(self,crate+Vector3(side*.215,.095,0),Vector3(.046,.20,.39),"906F50")
	var can := position_on_ground(Vector2(-9.95,121.28),.14)
	S.cone(self,can,.115,.25,"739086",.095)
	S.beam(self,can+Vector3(.08,-.05,0),can+Vector3(.29,.10,0),.066,"739086")

func pose(p: Vector2, lift: float, scale_factor: float, yaw: float) -> Transform3D:
	return Transform3D(Basis(Vector3.UP,yaw).scaled(Vector3.ONE*scale_factor),position_on_ground(p,lift))

func batch(parent: Node3D, id: String, folder: String, height: float, poses: Array[Transform3D], styled: bool, distance: float) -> void:
	if poses.is_empty():
		return
	var source := A.instance(id,height,folder,styled)
	for node in source.find_children("*","MeshInstance3D",true,false):
		var visual := node as MeshInstance3D
		var local := visual.transform
		var ancestor := visual.get_parent_node_3d()
		while ancestor!=source:
			local = ancestor.transform*local
			ancestor = ancestor.get_parent_node_3d()
		var instances := MultiMesh.new()
		instances.transform_format = MultiMesh.TRANSFORM_3D
		instances.mesh = visual.mesh
		instances.instance_count = poses.size()
		for i in poses.size():
			instances.set_instance_transform(i,poses[i]*local)
		var plant := MultiMeshInstance3D.new()
		plant.name = id
		plant.multimesh = instances
		plant.material_override = visual.material_override
		plant.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
		plant.visibility_range_end = distance
		plant.visibility_range_end_margin = 4.0
		parent.add_child(plant,true)
	source.free()
