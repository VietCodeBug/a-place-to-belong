extends Node3D
## Freshwater plants share three meshes. Nearby beds are culled in 32 m cells.

const FIELD = preload("res://scripts/world/superworld/terrain_field.gd")
const CELL := 32.0
const PATCHES := [
	Vector4(233,-466,10,51), Vector4(242,-500,14,35), Vector4(260,-460,14,73),
	Vector4(283,-484,13,60), Vector4(302,-481,10,51), Vector4(316,-459,11,56),
	Vector4(324,-445,10,54), Vector4(330,-470,12,40), Vector4(347,-448,10,54),
	Vector4(350,-472,14,46), Vector4(349,-430,17,47), Vector4(363,-406,12,56),
	Vector4(378,-428,10,73), Vector4(387,-405,9,51), Vector4(395,-452,15,65),
	Vector4(403,-484,11,52), Vector4(419,-461,11,75), Vector4(421,-489,10,60),
	Vector4(435,-431,11,57), Vector4(439,-452,10,50), Vector4(457,-412,10,49),
	Vector4(473,-421,11,64), Vector4(478,-389,11,48), Vector4(490,-408,9,54),
	Vector4(492,-450,12,50), Vector4(501,-493,11,47), Vector4(517,-429,13,45),
	Vector4(548,-453,12,40),
]
const CLEARINGS := [
	Vector3(FIELD.PAVILION.x,FIELD.PAVILION.y,7.0),
	Vector3(FIELD.STAIR_GATE.x,FIELD.STAIR_GATE.y,7.3),
	Vector3(FIELD.COLONNADE.x,FIELD.COLONNADE.y,8.9),
	Vector3(FIELD.BROKEN_TOWER.x,FIELD.BROKEN_TOWER.y,6.5),
]

var rng := RandomNumberGenerator.new()
var instance_count := 0

func setup(field: FIELD) -> void:
	name = "LakeHabitats"
	rng.seed = 333113
	var meshes: Array[ArrayMesh] = []
	for species in 3:
		meshes.append(make_species(species))
	var material := ShaderMaterial.new()
	material.shader = preload("res://shaders/a1_submerged_plants.gdshader")
	var cells := {}
	for patch: Vector4 in PATCHES:
		plant_patch(field,patch,cells)
	for id: Vector3i in cells:
		var poses: Array = cells[id]
		var batch := MultiMesh.new()
		batch.transform_format = MultiMesh.TRANSFORM_3D
		batch.mesh = meshes[id.z]
		batch.instance_count = poses.size()
		for i in poses.size():
			batch.set_instance_transform(i,poses[i])
		instance_count += batch.instance_count
		var cluster := MultiMeshInstance3D.new()
		cluster.multimesh = batch
		cluster.material_override = material
		cluster.position = Vector3(id.x*CELL,0,id.y*CELL)
		cluster.visibility_range_end = [87.0,100.0,80.0][id.z]
		cluster.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
		add_child(cluster)

func plant_patch(field: FIELD, patch: Vector4, cells: Dictionary) -> void:
	var center := Vector2(patch.x,patch.y)
	for i in int(patch.w):
		var fan := Vector2.from_angle(rng.randf()*TAU)*sqrt(rng.randf())*patch.z
		var spot := center+fan
		var h := field.height(spot)
		var depth := FIELD.WATER-h
		if depth<.55 or depth>24.0 or field.trench_influence(spot)>.53 or keep_open(spot):
			continue
		var pick := rng.randf()
		var species := 0
		if depth>4.0 and pick<(.56 if depth>9.0 else .31):
			species = 1
		elif pick>.62:
			species = 2
		var width := rng.randf_range(.51,1.26)
		var height := minf(width*rng.randf_range(.73,1.35),depth*[.44,.36,.52][species])
		var tile := (spot/CELL).floor()
		var key := Vector3i(int(tile.x),int(tile.y),species)
		var local := spot-tile*CELL
		var pose := Basis(Vector3.UP,rng.randf()*TAU).scaled_local(Vector3(width,height,width))
		if not cells.has(key):
			cells[key] = []
		cells[key].append(Transform3D(pose,Vector3(local.x,h-.045,local.y)))

func keep_open(p: Vector2) -> bool:
	if absf(p.x-FIELD.ARCH.x)<13.0 and absf(p.y-FIELD.ARCH.y)<2.65:
		return true
	if p.x>FIELD.STAIR_GATE.x-11.0 and p.x<FIELD.STAIR_GATE.x and absf(p.y-FIELD.STAIR_GATE.y)<2.8:
		return true
	for clearing: Vector3 in CLEARINGS:
		if p.distance_squared_to(Vector2(clearing.x,clearing.y)) < clearing.z*clearing.z:
			return true
	return false

func ribbon(builder: SurfaceTool, spine: PackedVector3Array, widths: PackedFloat32Array,
		side: Vector3, max_height: float, color_kind: Color) -> void:
	var corners := [Vector2i(0,-1),Vector2i(1,-1),Vector2i(0,1),Vector2i(1,-1),Vector2i(1,1),Vector2i(0,1)]
	for segment in range(spine.size()-1):
		for corner: Vector2i in corners:
			var index := segment+corner.x
			var at := spine[index]
			builder.set_color(Color(clampf(at.y/max_height,0,1),color_kind.g,color_kind.b))
			builder.add_vertex(at+side*widths[index]*corner.y)

func make_species(species: int) -> ArrayMesh:
	var mesh := SurfaceTool.new()
	mesh.begin(Mesh.PRIMITIVE_TRIANGLES)
	for i: int in range([8,4,7][species]):
		var heading := Vector3.RIGHT.rotated(Vector3.UP,i*2.4+species*.7)
		var side := heading.cross(Vector3.UP)
		var high: float = rng.randf_range(.54,1.25)*[1.24,2.92,.66][species]
		var spread: float = rng.randf_range(.23,.57)*[1.10,.63,1.33][species]
		var tint := Color(0,rng.randf_range(.30,.94),species*.50)
		var spine := PackedVector3Array()
		var widths := PackedFloat32Array()
		for step in range(7):
			var t := float(step)/6.0
			var bend := heading*(.11+spread*t*t)+side*sin(t*5.5+i)*t*.09
			var width: float = sin(PI*(.08+t*.92))*[.108,.052,.122][species]
			if species==1:
				width *= 1.0+.30*cos(t*7.0+i)
			spine.append(bend+Vector3.UP*(high*t))
			widths.append(width)
		ribbon(mesh,spine,widths,side,high,tint)
		if species==1:
			for tier in range(2,6):
				var joint := spine[tier]
				for sign_x: float in [-1.0,1.0]:
					var blade := side*sign_x*(.31-.032*tier)+heading*.17
					var blade_spine := PackedVector3Array([joint,joint+blade*.55+Vector3.UP*.12,joint+blade+Vector3.UP*.25])
					var blade_side := blade.cross(Vector3.UP).normalized()
					ribbon(mesh,blade_spine,PackedFloat32Array([.025,.071,.001]),blade_side,high,tint)
	mesh.generate_normals()
	return mesh.commit()
