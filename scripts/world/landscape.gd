class_name ForestLandscape
extends Node3D
## Forest hub terrain, including the connected A1 river valley.
const CAFE_LEVEL := 0.0
const S = preload("res://scripts/world/shapes.gd")
const STEP := 2.0

const VALLEY_END := 186
const VALLEY_HALF_WIDTH := 40
const BRIDGE_Z := 74.0
# x, z, visible width radius and visible length radius. Positions align with terrain samples.
const POTHOLES := [Vector4(4,16,.82,.69),Vector4(4,104,.77,.94),
	Vector4(6,122,.72,1.05),Vector4(6,136,.86,.83),Vector4(4,150,.81,1.10)]

# Off-trail shoulders only. x/z, radius, signed vertical relief in metres.
const RELIEF := [
	Vector4(6,20,3.2,.39), Vector4(16,8,3.0,.48), Vector4(-11,16,3.6,-.34),
	Vector4(-14,31,5.2,.58), Vector4(9,38,4.5,-.37), Vector4(-10,45,5,.61),
	Vector4(-19,58,4.8,.44), Vector4(13,65,4.6,.45), Vector4(-13,83,4.5,.52),
	Vector4(16,91,4.0,-.39), Vector4(-11,94,5.0,.54), Vector4(9.8,98,2.7,.32),
	Vector4(-21,122,3.7,.42), Vector4(25,146,3.5,-.39), Vector4(-13,168,4.1,.49),
	Vector4(12,176,4.0,.57), Vector4(-4,177,3.8,-.35),
]

static func road_potholes() -> PackedVector4Array:
	return PackedVector4Array(POTHOLES)

static func in_overlook_view(x: float, z: float) -> bool:
	return z >= 48.0 and z < 95.0 and absf(x - (-22.5 + (z - 50.0) * 0.44)) < 8.2

static func river_center(x: float) -> float:
	return BRIDGE_Z + 6.0 * sin(x * 0.057) * smoothstep(3.0, 16.0, absf(x))

static func valley_path(z: float) -> float:
	return lerpf(ClearingLayout.path_center(24.0), 0.0, smoothstep(24.0, 66.0, z)) \
		+ 3.9 * sin((z - 24.0) * 0.13) * smoothstep(24.0, 38.0, z) * (1.0 - smoothstep(54.0, 65.0, z)) \
		+ 5.2 * smoothstep(84.0, 111.0, z) + 1.45*sin((z-112.0)*0.112)*smoothstep(112.0,123.0,z)

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
	if z > 24.0:
		var blend := smoothstep(24.0, 38.0, z) * (1.0 - smoothstep(40.0, 62.0, absf(x)))
		var banks := 3.0 + 0.45 * sin(x * 0.17) + 0.36 * cos(z * 0.22)
		banks = lerpf(banks, 3.0, 1.0 - smoothstep(9.0, 16.0, absf(z - BRIDGE_Z)))
		var hills := 4.8 * exp(-Vector2(x + 25.0, z - 54.0).length_squared() / 225.0)
		hills += 9.0 * exp(-Vector2(x - 29.0, z - 97.0).length_squared() / 290.0)
		var rise := 5.3 * smoothstep(86.0, 112.0, z) + 1.55*smoothstep(127.0,153.0,z) - 1.9*smoothstep(166.0,185.0,z)
		var reveal := 4.2 * exp(-Vector2(x + 4.5, z - 92.0).length_squared()/66.0)
		reveal += 2.1*exp(-Vector2(x-10.4,z-92.5).length_squared()/44.0)
		var river := 4.0 * (1.0 - smoothstep(3.4, 7.8, absf(z - river_center(x))))
		h = lerpf(h, banks + hills + rise + reveal - river, blend)
	for mound: Vector4 in RELIEF:
		if absf(z-mound.y)<mound.z and absf(x-mound.x)<mound.z:
			var radius := Vector2(x-mound.x,z-mound.y).length()
			h += mound.w*(1.0-smoothstep(0,mound.z,radius))
	for hollow: Vector4 in POTHOLES:
		if absf(x-hollow.x) < STEP and absf(z-hollow.y) < STEP:
			h -= .13*(1.0-smoothstep(0.0,STEP,Vector2(x-hollow.x,z-hollow.y).length()))
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
	for x in [-24, 24]:
		S.box(self, Vector3(x, 3, 0), Vector3(0.3, 14, 48), "496B59", true).hide()
	for x in [-40, 40]:
		S.box(self, Vector3(x, 11, 105), Vector3(0.3, 32, 162), "496B59", true).hide()
	for x in [-32, 32]:
		S.box(self, Vector3(x, 6, 24), Vector3(16, 18, 0.3), "496B59", true).hide()
	S.box(self, Vector3(0, 3, -24), Vector3(48, 14, 0.3), "496B59", true).hide()
	S.box(self, Vector3(0, 13, VALLEY_END), Vector3(80, 32, 0.3), "496B59", true).hide()

func terrain() -> void:
	var st := SurfaceTool.new()
	st.begin(Mesh.PRIMITIVE_TRIANGLES)
	st.set_smooth_group(-1)
	var faces := PackedVector3Array()
	# Playable grid at fine 2m step out to +-64m, seamlessly joined by 4m outer foothill skirt to 164m.
	for x in range(-64,64,2):
		for z in range(-64,VALLEY_END,2):
			var a := Vector3(x,sculpt(x,z),z)
			var b := Vector3(x+2,sculpt(x+2,z),z)
			var c := Vector3(x,sculpt(x,z+2),z+2)
			var d := Vector3(x+2,sculpt(x+2,z+2),z+2)
			for v in [a,b,c,b,d,c]:
				var tint := 0.5+0.5*sin(v.x*0.17+sin(v.z*0.12))
				st.set_color(Color("687B64").lerp(Color("8C9468"),tint*0.55))
				st.add_vertex(v)
				if (x>=-24 and x<24 and z>=-24 and z<24) or (x>=-VALLEY_HALF_WIDTH and x<VALLEY_HALF_WIDTH and z>=24):
					faces.append(v)
	for x in range(-164,164,4):
		for z in range(-164,252,4):
			if x>=-64 and x<64 and z>=-64 and z<VALLEY_END-2:
				continue
			if z < 0 and Vector2(x+2,z+2).length()>164:
				continue
			var start_z := maxi(z,VALLEY_END) if x>=-64 and x<64 and z>=VALLEY_END-2 else z
			var a := Vector3(x,sculpt(x,start_z),start_z)
			var b := Vector3(x+4,sculpt(x+4,start_z),start_z)
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
	var steps := 720
	for i in range(steps):
		var z0 := lerpf(4.25,183.0,float(i)/steps)
		var z1 := lerpf(4.25,183.0,float(i+1)/steps)
		if z1 > 66.3 and z0 < 81.7:
			continue
		var p := Vector2(valley_path(z0) if z0 > 24.0 else ClearingLayout.path_center(z0),z0)
		var q := Vector2(valley_path(z1) if z1 > 24.0 else ClearingLayout.path_center(z1),z1)
		for strip in range(14):
			var cells: Array[Vector3] = []
			var coords: Array[Vector2] = []
			for item in [[p,strip],[p,strip+1],[q,strip],[q,strip+1]]:
				var point: Vector2 = item[0]
				var half := lerpf(ClearingLayout.path_half_width(point.y), 1.9, smoothstep(24.0, 39.0, point.y))
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
	dirt.set_shader_parameter("continuous_trail",true)
	dirt.set_shader_parameter("potholes",road_potholes())
	n.material_override = dirt
	n.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	add_child(n)
