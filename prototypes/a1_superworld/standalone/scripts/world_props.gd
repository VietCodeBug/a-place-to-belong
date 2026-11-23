class_name A1WorldProps
extends Node3D
## Playable blockouts only. Replace with approved authored GLBs at art-pass time.
const G = preload("res://scripts/world_gen.gd")
var gen: A1WorldGen
var mats := {}
var lake_surface:MeshInstance3D

func setup(g:A1WorldGen) -> void:
	gen=g
	for key in {
		"walls":"e6d8b6", "wood":"936b4a", "roof":"896e70", "roof2":"a76f50",
		"roof3":"728b79", "stone":"a4aca0", "path":"c8b58d",
		"water":"3f9fbd", "dock":"9c8262", "ruin":"7b9d91", "kelp":"4ca8a4"
	}.keys():
		var m:=StandardMaterial3D.new()
		m.albedo_color=Color({
			"walls":"e6d8b6", "wood":"936b4a", "roof":"896e70", "roof2":"a76f50",
			"roof3":"728b79", "stone":"a4aca0", "path":"c8b58d",
			"water":"3f9fbd", "dock":"9c8262", "ruin":"7b9d91", "kelp":"4ca8a4"}[key])
		m.roughness=.9
		mats[key]=m
	build_world_backdrop()
	build_lake()
	build_river()
	build_bridge()
	build_house(G.HOUSE,6.3,5.8,8.5,0,"roof2","NHÀ A")
	build_village()
	build_pier()
	build_underwater()
	build_wayfinding()

func cube(parent:Node3D,p:Vector3,extent:Vector3,mat:Material,solid:=false,yaw:=0.0) -> Node3D:
	var root:=Node3D.new()
	root.position=p
	root.rotation.y=yaw
	parent.add_child(root)
	var mesh:=BoxMesh.new()
	mesh.size=extent
	var node:=MeshInstance3D.new()
	node.mesh=mesh
	node.material_override=mat
	root.add_child(node)
	if solid:
		var b:=StaticBody3D.new()
		var collision:=CollisionShape3D.new()
		var s:=BoxShape3D.new()
		s.size=extent
		collision.shape=s
		b.add_child(collision)
		root.add_child(b)
	return root

func sphere(parent:Node3D,p:Vector3,scale:Vector3,mat:Material) -> void:
	var m:=SphereMesh.new()
	m.radius=1.0
	m.height=2.0
	m.radial_segments=8
	m.rings=4
	var inst:=MeshInstance3D.new()
	inst.mesh=m
	inst.material_override=mat
	inst.position=p
	inst.scale=scale
	parent.add_child(inst)

func text3d(label:String,p:Vector3,font_size:=68) -> void:
	var txt:=Label3D.new()
	txt.text=label
	txt.font_size=font_size
	txt.pixel_size=.006
	txt.outline_size=9
	txt.billboard=BaseMaterial3D.BILLBOARD_ENABLED
	txt.position=p
	add_child(txt)

func build_house(p:Vector2,w:float,d:float,h:float,yaw:float,roof_color:String,sign:String="") -> void:
	var ground:=gen.terrain_height(p.x,p.y)
	var root:=Node3D.new()
	root.name="Cottage_%.0f_%.0f"%[p.x,p.y]
	root.position=Vector3(p.x,ground,p.y)
	root.rotation.y=yaw
	add_child(root)
	cube(root,Vector3(0,1.9,0),Vector3(w,3.8,d),mats["walls"],true)
	for side in [-1,1]:
		var panel:=cube(root,Vector3(side*w*.26,4.55,0),Vector3(w*.61,.28,d+.7),mats[roof_color])
		panel.rotation.z=side*.47
	cube(root,Vector3(0,1.38,-d*.505),Vector3(1.25,2.45,.12),mats["wood"])
	for xp in [-w*.28,w*.28]:
		cube(root,Vector3(xp,2.50,-d*.515),Vector3(.78,.90,.12),mats["roof3"])
	cube(root,Vector3(0,.18,-d*.66),Vector3(2.1,.33,1.8),mats["stone"],true)
	if sign!="":text3d(sign,Vector3(p.x,ground+6.6,p.y))

func build_village() -> void:
	var rng:=RandomNumberGenerator.new()
	rng.seed=541095
	for i in range(20):
		var row:=i/5
		var col:=i%5
		var x:float=-145.0+float(col)*70.0+rng.randf_range(-13.0,13.0)
		var z:float=385.0+float(row)*78.0+rng.randf_range(-11.0,11.0)
		if Vector2(x,z).distance_to(G.VILLAGE)<34.0: x+=33.0
		build_house(Vector2(x,z),rng.randf_range(5.0,8.5),rng.randf_range(6,10),rng.randf_range(5.0,8.2),rng.randf_range(-.22,.22),["roof","roof2","roof3"][i%3])
	var center:=Vector3(G.VILLAGE.x,gen.terrain_height(G.VILLAGE.x,G.VILLAGE.y)+.3,G.VILLAGE.y)
	cube(self,center,Vector3(20.0,.25,20.0),mats["path"])
	text3d("LÀNG A",center+Vector3(0,8,0),88)
	for k in range(8):
		var x:float=-210.0+float(k)*60.0
		var z:float=455.0+15.0*sin(float(k)*.8)
		cube(self,Vector3(x,gen.terrain_height(x,z)+.09,z),Vector3(38,.12,7),mats["path"])

func build_bridge() -> void:
	# Across the stream at x=0. Stream bed is lower than the deck.
	var y:=G.WATER_LEVEL+3.2
	for z in range(199,282,5):
		cube(self,Vector3(0,y,float(z)),Vector3(15,.60,4.7),mats["dock"],true)
	for x in [-6.6,6.6]:
		for z in range(203,280,15):
			cube(self,Vector3(x,y+1.0,float(z)),Vector3(.35,2.0,.35),mats["wood"])

func create_water_mesh(points:PackedVector3Array,name:String,alpha:float) -> void:
	var st:=SurfaceTool.new()
	st.begin(Mesh.PRIMITIVE_TRIANGLES)
	for p in points: st.add_vertex(p)
	st.generate_normals()
	var visual:=MeshInstance3D.new()
	visual.name=name
	visual.mesh=st.commit()
	var mat:=StandardMaterial3D.new()
	mat.albedo_color=Color(.16,.53,.68,alpha)
	mat.transparency=BaseMaterial3D.TRANSPARENCY_ALPHA
	mat.cull_mode=BaseMaterial3D.CULL_DISABLED
	mat.shading_mode=BaseMaterial3D.SHADING_MODE_PER_PIXEL
	mat.roughness=.18
	mat.metallic=.12
	visual.material_override=mat
	visual.cast_shadow=GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	add_child(visual)
	if name=="LakeSurface": lake_surface=visual

func build_world_backdrop() -> void:
	# Coarse panorama for the full 16.78 km²; fine collidable chunks stream over it.
	# Offset well below streamed terrain to avoid z-fighting near the player.
	var st:=SurfaceTool.new()
	st.begin(Mesh.PRIMITIVE_TRIANGLES)
	var step:=64.0
	for xi in range(64):
		for zi in range(64):
			var x:float=-G.HALF+float(xi)*step
			var z:float=-G.HALF+float(zi)*step
			var a:=Vector3(x,gen.terrain_height(x,z)-6.0,z)
			var b:=Vector3(x,gen.terrain_height(x,z+step)-6.0,z+step)
			var c:=Vector3(x+step,gen.terrain_height(x+step,z)-6.0,z)
			var d:=Vector3(x+step,gen.terrain_height(x+step,z+step)-6.0,z+step)
			for v in [a,b,c,c,b,d]:
				st.set_color(gen.surface_color(v.x,v.z))
				st.add_vertex(v)
	st.generate_normals()
	var mesh:=MeshInstance3D.new()
	mesh.name="FullRegionBackground_VisualOnly"
	mesh.mesh=st.commit()
	var mat:=StandardMaterial3D.new()
	mat.vertex_color_use_as_albedo=true
	mat.roughness=1.0
	mesh.material_override=mat
	mesh.cast_shadow=GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	add_child(mesh)

func build_lake() -> void:
	var verts:=PackedVector3Array()
	for i in range(144):
		var a:=TAU*float(i)/144.0
		var b:=TAU*float(i+1)/144.0
		verts.append(Vector3(G.LAKE_CENTER.x,G.WATER_LEVEL,G.LAKE_CENTER.y))
		verts.append(Vector3(G.LAKE_CENTER.x+cos(b)*G.LAKE_RADIUS.x,G.WATER_LEVEL,G.LAKE_CENTER.y+sin(b)*G.LAKE_RADIUS.y))
		verts.append(Vector3(G.LAKE_CENTER.x+cos(a)*G.LAKE_RADIUS.x,G.WATER_LEVEL,G.LAKE_CENTER.y+sin(a)*G.LAKE_RADIUS.y))
	create_water_mesh(verts,"LakeSurface",.70)

func build_river() -> void:
	var verts:=PackedVector3Array()
	for i in range(200):
		var x0:float=-2048.0+float(i)*4096.0/200.0
		var x1:float=-2048.0+float(i+1)*4096.0/200.0
		var c0:=gen.river_z(x0)
		var c1:=gen.river_z(x1)
		var a:=Vector3(x0,G.WATER_LEVEL+.09,c0-11.0)
		var b:=Vector3(x0,G.WATER_LEVEL+.09,c0+11.0)
		var c:=Vector3(x1,G.WATER_LEVEL+.09,c1-11.0)
		var d:=Vector3(x1,G.WATER_LEVEL+.09,c1+11.0)
		for v in [a,b,c,b,d,c]:verts.append(v)
	create_water_mesh(verts,"RiverSurface",.74)

func build_pier() -> void:
	var pos:=G.PIER
	var y:=G.WATER_LEVEL+1.6
	for i in range(15):
		var x:=pos.x+float(i)*9.5
		cube(self,Vector3(x,y,pos.y),Vector3(9.3,.35,10.0),mats["dock"],true)
		if i%3==0:
			for dz in [-4.6,4.6]:
				cube(self,Vector3(x,y-2.0,pos.y+dz),Vector3(.6,4.0,.6),mats["wood"])
	text3d("BẾN CÂU CÁ  ·  FEATURE SAU",Vector3(pos.x+58.0,y+6.0,pos.y))

func build_underwater() -> void:
	var rng:=RandomNumberGenerator.new()
	rng.seed=260120
	for i in range(85):
		var a:=rng.randf()*TAU
		var distance:=rng.randf_range(20,195)
		var x:=G.UNDERWATER.x+cos(a)*distance
		var z:=G.UNDERWATER.y+sin(a)*distance*.65
		var y:=gen.terrain_height(x,z)
		if y>=G.WATER_LEVEL-2:continue
		if i%4==0:
			var height:=rng.randf_range(3,8)
			cube(self,Vector3(x,y+height*.5,z),Vector3(rng.randf_range(1,2.2),height,rng.randf_range(1,2.2)),mats["ruin"])
		else:
			var size:=rng.randf_range(.7,2.8)
			sphere(self,Vector3(x,y+.7*size,z),Vector3(size,.7*size,size),mats["stone"])
	for i in range(120):
		var x:=G.UNDERWATER.x+rng.randf_range(-230,230)
		var z:=G.UNDERWATER.y+rng.randf_range(-175,175)
		var y:=gen.terrain_height(x,z)
		if y>G.WATER_LEVEL-4.0:continue
		var height:=rng.randf_range(1.8,6.5)
		var stem:=CylinderMesh.new()
		stem.bottom_radius=.16
		stem.top_radius=.015
		stem.height=height
		stem.radial_segments=5
		var n:=MeshInstance3D.new()
		n.mesh=stem
		n.material_override=mats["kelp"]
		n.position=Vector3(x,y+height*.5,z)
		add_child(n)
	text3d("VƯỜN ĐÁ DƯỚI HỒ",Vector3(G.UNDERWATER.x,G.WATER_LEVEL-8,G.UNDERWATER.y),68)

func build_wayfinding() -> void:
	text3d("BÃI CỎ HOA",Vector3(-600,gen.terrain_height(-600,950)+9,950))
	text3d("RỪNG CỔ THỤ",Vector3(-1000,gen.terrain_height(-1000,-1050)+9,-1050))
	text3d("ĐỈNH NGẮM CẢNH",Vector3(-1200,gen.terrain_height(-1200,710)+12,710))
	text3d("THUNG LŨNG PHÍA ĐÔNG",Vector3(1380,gen.terrain_height(1380,660)+12,660))
	text3d("BỜ HỒ ÁNH SAO",Vector3(G.PIER.x-58,gen.terrain_height(G.PIER.x-58,G.PIER.y)+8,G.PIER.y))
