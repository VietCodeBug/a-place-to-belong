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
	# Playable -24..24 stays mathematically unchanged (outside == 0.0 inside bounds).
	# Outer non-playable backdrop rolls into layered surrounding foothills that meet ForestBackdrop.
	var outside := smoothstep(24.0,42.0,maxf(absf(x),absf(z)))
	if outside > 0.0:
		var ridges := 8.5*exp(-(Vector2(x,z)-Vector2(-31,-38)).length_squared()/780.0)
		ridges += 11.5*exp(-(Vector2(x,z)-Vector2(30,-55)).length_squared()/1050.0)
		ridges += 9.2*exp(-(Vector2(x,z)-Vector2(-52,-14)).length_squared()/1150.0)
		ridges += 7.8*exp(-(Vector2(x,z)-Vector2(54,-12)).length_squared()/1200.0)
		ridges += 6.4*exp(-(Vector2(x,z)-Vector2(48,24)).length_squared()/1350.0)
		ridges += 7.2*exp(-(Vector2(x,z)-Vector2(-46,32)).length_squared()/1250.0)
		ridges += 5.5*exp(-(Vector2(x,z)-Vector2(-12,56)).length_squared()/1400.0)
		var dist := Vector2(x,z).length()
		var bowl := smoothstep(46.0,148.0,dist)*(4.8+2.6*sin(atan2(z,x)*3.0+0.9)+1.5*cos(atan2(z,x)*5.0))
		# Keep the SE wide-camera corridor (around +27, +34) gently low so aerial shots stay clear.
		var se_corridor := 1.0 - 0.72*exp(-(Vector2(x,z)-Vector2(30,36)).length_squared()/720.0)
		h += outside*(ridges + bowl)*se_corridor
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
	# Playable grid at fine 2m step out to +-64m, seamlessly joined by 4m outer foothill skirt to 164m.
	for x in range(-64,64,2):
		for z in range(-64,64,2):
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
	for x in range(-164,164,4):
		for z in range(-164,164,4):
			if x>=-64 and x<64 and z>=-64 and z<64:
				continue
			if Vector2(x+2,z+2).length()>164:
				continue
			var a := Vector3(x,sculpt(x,z),z)
			var b := Vector3(x+4,sculpt(x+4,z),z)
			var c := Vector3(x,sculpt(x,z+4),z+4)
			var d := Vector3(x+4,sculpt(x+4,z+4),z+4)
			for v in [a,b,c,b,d,c]:
				var tint := 0.5+0.5*sin(v.x*0.11+sin(v.z*0.09))
				st.set_color(Color("586E59").lerp(Color("7A8A68"),tint*0.5))
				st.add_vertex(v)
	st.generate_normals()
	var mesh := MeshInstance3D.new()
	mesh.name = "ContinuousMap01Terrain"
	# Receive tree/building shadows, but avoid coplanar terrain self-shadow bands.
	mesh.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	mesh.mesh = st.commit()
	var mat := ShaderMaterial.new()
	mat.shader = preload("res://shaders/forest_floor.gdshader")
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
	# Same centerline and core width, starting cleanly under the porch ramp (z=4.25) with feathered verges.
	var st := SurfaceTool.new()
	st.begin(Mesh.PRIMITIVE_TRIANGLES)
	var steps := 132
	for i in range(steps):
		var z0 := lerpf(4.25,24.2,float(i)/steps)
		var z1 := lerpf(4.25,24.2,float(i+1)/steps)
		var p := Vector2(ClearingLayout.path_center(z0),z0)
		var q := Vector2(ClearingLayout.path_center(z1),z1)
		for strip in range(14):
			var cells: Array[Vector3] = []
			var coords: Array[Vector2] = []
			for item in [[p,strip],[p,strip+1],[q,strip],[q,strip+1]]:
				var point: Vector2 = item[0]
				var half := ClearingLayout.path_half_width(point.y)
				var lateral := lerpf(-half-0.78,half+0.78,float(item[1])/14.0)
				var x := point.x+lateral
				cells.append(Vector3(x,height_at(x,point.y)+0.024,point.y))
				coords.append(Vector2(lateral,half))
			for index in [0,1,2,1,3,2]:
				st.set_uv(coords[index])
				st.add_vertex(cells[index])
	st.generate_normals()
	var n := MeshInstance3D.new()
	n.mesh = st.commit()
	n.name = "ExistingDeliveryPath"
	var dirt := ShaderMaterial.new()
	dirt.shader = preload("res://shaders/forest_path.gdshader")
	n.material_override = dirt
	n.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	add_child(n)
