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
	[Vector2(-9.3,16.2),["Plant_Flowers","flower_yellowA","flower_purpleB"]],
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
	for patch in verge_cover:
		patch.visible = index!=3
	for i in seasons.size():
		seasons[i].visible = i==index

func build_verge_cover() -> void:
	var rng := RandomNumberGenerator.new()
	rng.seed = 27184
	var village := get_parent().get_node("VillageA")
	for band in [32,52,71,90,107,128,148,169]:
		var cover: Array[Vector3] = []
		for i in range(270):
			var z: float = band + rng.randf_range(-6.2,7.0)
			var offset := rng.randf_range(2.75,5.30) * (-1.0 if i%2==0 else 1.0)
			var p := Vector2(L.valley_path(z)+offset,z)
			if sin(z*.75 + offset*.9)+cos(z*.28-offset*1.9) < -.24:
				continue
			if absf(p.y-L.river_center(p.x))<6.4:
				continue
			if z>=100 and not village.is_open_ground(p,2.05):
				continue
			cover.append(position_on_ground(p,-.008))
		var patch := A.grass_batch(self,cover,int(band),34.0,.16)
		patch.name = "MeadowVerge%d" % int(band)
		verge_cover.append(patch)

func position_on_ground(p: Vector2, lift: float = 0.0) -> Vector3:
	return Vector3(p.x,L.height_at(p.x,p.y)+lift,p.y)

func flowers(parent: Node3D, season: int) -> void:
	var rng := RandomNumberGenerator.new()
	rng.seed = 10439
	for cluster in WILD:
		var center: Vector2 = cluster[0]
		var id: String = cluster[1][[2,0,1][season]]
		var poses: Array[Transform3D] = []
		for i in range(4 if season==0 else 7):
			var p := center+Vector2(rng.randfn(0,.45),rng.randfn(0,.40))
			if absf(p.x)>38.0 or p.y<23 and ForestFloorDesign.reserved(p,.16):
				continue
			if p.y>=24.0 and absf(p.x-L.valley_path(p.y))<2.7:
				continue
			if p.y>=100.0 and not get_parent().get_node("VillageA").is_open_ground(p,1.25):
				continue
			poses.append(pose(p,.007,rng.randf_range(.70,1.19),rng.randf()*TAU))
		var kenney := id.begins_with("flower_")
		var folder := KENNEY if kenney else A.DIR if id=="Flower_4_Clump" else DIR
		batch(parent,id,folder,.23 if season!=2 else .32,poses,not kenney,38.0)

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
		var height: float = [.44,.32,.83,.47][row]
		if season==1:
			height *= .69
		for plant in range(5 if row!=3 else 3):
			var p := Vector2(PLAN.GARDEN.x+(row-1.5)*1.14+sin(plant*1.6)*.075,
				118.63+plant*(.68 if row!=3 else 1.27))
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
	for i in range(5):
		var p := Vector2(PLAN.GARDEN.x+.70,118.60+i*.68)
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
		parent.add_child(plant,true)
	source.free()
