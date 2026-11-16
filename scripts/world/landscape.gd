class_name ForestLandscape
extends Node3D
## Map 01 only. The playable bounds remain -24..24; outer mesh is non-playable backdrop.
const CAFE_LEVEL := 0.0
const S = preload("res://scripts/world/shapes.gd")
const STEP := 2.0

static func sculpt(x: float,z: float) -> float:
	var h := sin(x*0.115)*0.38+cos(z*0.13)*0.28+sin((x+z)*0.18)*0.17
	var clearing := maxf(absf(x)/12.5,absf(z+3)/13.0)
	h *= smoothstep(0.85,1.55,clearing)
	# Existing background receives ridge silhouettes instead of the previous giant flat plane.
	var outside := smoothstep(24,40,maxf(absf(x),absf(z)))
	h += outside*(8.0*exp(-(Vector2(x,z)-Vector2(-31,-38)).length_squared()/750)+11.0*exp(-(Vector2(x,z)-Vector2(30,-55)).length_squared()/1000))
	return h

static func height_at(x: float,z: float) -> float:
	# Exactly the same triangle interpolation as the terrain/collider, not a second approximation.
	var a := floorf(x/STEP)*STEP
	var b := floorf(z/STEP)*STEP
	var u := (x-a)/STEP
	var v := (z-b)/STEP
	if u+v <= 1:
		return sculpt(a,b)+(sculpt(a+STEP,b)-sculpt(a,b))*u+(sculpt(a,b+STEP)-sculpt(a,b))*v
	var d := sculpt(a+STEP,b+STEP)
	return d+(sculpt(a,b+STEP)-d)*(1-u)+(sculpt(a+STEP,b)-d)*(1-v)

static func road_point(t: float) -> Vector2:
	var z := lerpf(5.0,24.0,clampf(t,0,1))
	return Vector2(ClearingLayout.path_center(z),z)

static func on_road(p: Vector2,margin := 0.0) -> bool:
	return p.y >= 4.5 and absf(p.x-ClearingLayout.path_center(p.y))<ClearingLayout.path_half_width(p.y)+margin

func _ready() -> void:
	terrain()
	road()
	# Original Map 01 collision limits; no expanded playable region.
	for p in [Vector3(-24,3,0),Vector3(24,3,0)]:
		S.box(self,p,Vector3(0.3,8,48),"496B59",true).visible=false
	for z in [-24,24]:
		S.box(self,Vector3(0,3,z),Vector3(48,8,0.3),"496B59",true).visible=false

func terrain() -> void:
	var st := SurfaceTool.new()
	st.begin(Mesh.PRIMITIVE_TRIANGLES)
	st.set_smooth_group(-1)
	var faces := PackedVector3Array()
	for x in range(-110,110,2):
		for z in range(-110,110,2):
			if Vector2(x,z).length()>110:
				continue
			var a := Vector3(x,sculpt(x,z),z)
			var b := Vector3(x+2,sculpt(x+2,z),z)
			var c := Vector3(x,sculpt(x,z+2),z+2)
			var d := Vector3(x+2,sculpt(x+2,z+2),z+2)
			for v in [a,b,c,b,d,c]:
				var tint := 0.5+0.5*sin(v.x*0.17+sin(v.z*0.12))
				st.set_color(Color("687B64").lerp(Color("8C9468"),tint*0.55))
				st.add_vertex(v)
				if x>=-24 and x<24 and z>=-24 and z<24:
					faces.append(v)
	st.generate_normals()
	var mesh := MeshInstance3D.new()
	mesh.name = "ContinuousMap01Terrain"
	mesh.mesh = st.commit()
	var mat := StandardMaterial3D.new()
	mat.vertex_color_use_as_albedo = true
	mat.roughness = 1
	mesh.material_override = mat
	add_child(mesh)
	var body := StaticBody3D.new()
	var collider := CollisionShape3D.new()
	var shape := ConcavePolygonShape3D.new()
	shape.set_faces(faces)
	collider.shape = shape
	body.add_child(collider)
	add_child(body)

func road() -> void:
	var st := SurfaceTool.new()
	st.begin(Mesh.PRIMITIVE_TRIANGLES)
	for i in range(120):
		var p := road_point(float(i)/120)
		var q := road_point(float(i+1)/120)
		var half := ClearingLayout.path_half_width(p.y)
		var next_half := ClearingLayout.path_half_width(q.y)
		var verts: Array[Vector3] = []
		for v in [p-Vector2(half,0),p+Vector2(half,0),q-Vector2(next_half,0),q+Vector2(next_half,0)]:
			verts.append(Vector3(v.x,height_at(v.x,v.y)+0.075,v.y))
		for index in [0,1,2,1,3,2]:
			st.set_color(Color(1,1,1,1-smoothstep(22.0,24.0,verts[index].z)))
			st.add_vertex(verts[index])
	st.generate_normals()
	var n := S.mesh(self,st.commit(),Vector3.ZERO,"A9977A")
	n.name = "ExistingDeliveryPath"
	var dirt: StandardMaterial3D = n.material_override.duplicate()
	dirt.vertex_color_use_as_albedo = true
	dirt.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	n.material_override = dirt
	n.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
