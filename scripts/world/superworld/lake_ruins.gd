extends Node3D
## The flooded pavilion batches the architecture by material.

const FIELD = preload("res://scripts/world/superworld/terrain_field.gd")
const STONE = preload("res://shaders/a1_ruin_stone.gdshader")
const CENTER := FIELD.PAVILION
const RADIUS := 5.25
const SEGMENTS := 32

var builder := SurfaceTool.new()
var body: StaticBody3D
var shafts: MeshInstance3D
var rng := RandomNumberGenerator.new()
var cube := BoxMesh.new()

func setup(field: FIELD) -> void:
	name = "FloodedPavilion"
	rng.seed = 4297
	position = Vector3(CENTER.x,field.height(CENTER)+.54,CENTER.y)
	body = StaticBody3D.new()
	body.name = "SwimCollision"
	add_child(body)
	builder.begin(Mesh.PRIMITIVE_TRIANGLES)
	cube.size = Vector3.ONE
	build_court()
	build_columns()
	build_dome()
	build_fragments(field)
	var stone := ShaderMaterial.new()
	stone.shader = STONE
	add_visual("WeatheredLimestone",builder.commit(),stone)
	build_marker()
	build_shaft_mesh()

func add_visual(label: String, mesh: Mesh, material: Material) -> MeshInstance3D:
	var visual := MeshInstance3D.new()
	visual.name = label
	visual.mesh = mesh
	visual.material_override = material
	visual.visibility_range_end = 94.0
	visual.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	add_child(visual)
	return visual

func tint(color: String, variation: float) -> Color:
	return Color(color).lerp(Color("8D9A91"),variation)

func drum(top: float, bottom: float, height: float, at: Vector3, color: Color, shear := 0.0) -> void:
	var mesh := CylinderMesh.new()
	mesh.top_radius = top
	mesh.bottom_radius = bottom
	mesh.height = height
	mesh.radial_segments = 10
	mesh.rings = 0
	stamp(mesh,Transform3D(Basis(Vector3.UP,shear),at),color)

func stamp(mesh: Mesh, pose: Transform3D, color: Color) -> void:
	var source := mesh.surface_get_arrays(0)
	var points: PackedVector3Array = source[Mesh.ARRAY_VERTEX]
	var normals: PackedVector3Array = source[Mesh.ARRAY_NORMAL]
	var normal_basis := pose.basis.inverse().transposed()
	for index: int in source[Mesh.ARRAY_INDEX]:
		builder.set_color(color)
		builder.set_normal((normal_basis*normals[index]).normalized())
		builder.add_vertex(pose*points[index])

func block(at: Vector3, size: Vector3, color: Color, yaw := 0.0) -> void:
	stamp(cube,Transform3D(Basis(Vector3.UP,yaw).scaled_local(size),at),color)

func collide(shape: Shape3D, at: Vector3) -> void:
	var collider := CollisionShape3D.new()
	collider.shape = shape
	collider.position = at
	body.add_child(collider)

func build_court() -> void:
	drum(6.45,6.67,.34,Vector3(0,-.44,0),Color("556D70"),.16)
	drum(6.05,6.28,.26,Vector3(0,-.19,0),Color("6D8482"),.16)
	var deck := CylinderShape3D.new()
	deck.radius = 5.92
	deck.height = .28
	collide(deck,Vector3(0,-.14,0))
	for row in range(-5,6):
		for col in range(-5,6):
			var center := Vector2(col*1.14+(.3 if row%2==0 else -.3),row*1.02)
			if center.length()>5.66 or (col*19+row*11)%23==9:
				continue
			var size := Vector3(rng.randf_range(.98,1.10),rng.randf_range(.10,.17),rng.randf_range(.88,.99))
			var color := tint("617D78",rng.randf_range(.03,.80))
			block(Vector3(center.x,-.02,center.y),size,color,rng.randf_range(-.07,.07))
	for step in 3:
		var x := -6.08-step*.34
		block(Vector3(x,-.24-step*.16,.8),Vector3(.48,.25,3.05-step*.10),Color("6D8984"))

func build_columns() -> void:
	for i in 8:
		# Two lost uprights make a wide entry from the old rock arch.
		if i in [3,4]:
			continue
		var theta := (float(i)+.4)*TAU/8.0
		var axis := Vector2.from_angle(theta)*RADIUS
		var foot := Vector3(axis.x,.0,axis.y)
		drum(.61,.71,.21,foot+Vector3.UP*.12,Color("6A837D"),theta)
		drum(.46,.58,.17,foot+Vector3.UP*.30,Color("83A197"),theta)
		for j in 4:
			var width := .365-float(j)*.021
			drum(width*.94,width,.655,foot+Vector3.UP*(.71+j*.665),tint("7E9690",rng.randf()*.56),theta)
		drum(.57,.34,.25,foot+Vector3.UP*2.88,Color("6C8E85"),theta)
		block(foot+Vector3.UP*3.08,Vector3(1.05,.22,.94),Color("698C86"),theta)
		var column := CylinderShape3D.new()
		column.radius = .53
		column.height = 3.18
		collide(column,foot+Vector3.UP*1.56)

func dome_vertex(segment: int, phi: float, radius: float, height: float) -> Vector3:
	var angle := float(segment)*TAU/SEGMENTS
	var cut := 1.0+.030*sin(angle*7.0)+.023*cos(angle*11.0)
	return Vector3(cos(angle)*radius*cos(phi)*cut,3.41+height*sin(phi),sin(angle)*radius*cos(phi)*cut)

func triangle(a: Vector3, b: Vector3, c: Vector3, color: Color) -> void:
	var normal := (c-a).cross(b-a).normalized()
	for point: Vector3 in [a,b,c]:
		builder.set_color(color)
		builder.set_normal(normal)
		builder.add_vertex(point)

func build_dome() -> void:
	var architecture := builder
	builder = SurfaceTool.new()
	builder.begin(Mesh.PRIMITIVE_TRIANGLES)
	for i in SEGMENTS:
		# The western breach leaves a jagged opening through the canopy.
		if i in [12,13,14,15,16,17]:
			continue
		var angle := (float(i)+.5)*TAU/SEGMENTS
		var axis := Vector2.from_angle(angle)
		block(Vector3(axis.x*5.18,3.30,axis.y*5.18),Vector3(.83,.37,1.10),
			tint("435F69",rng.randf()*.44),-angle)
		for ring in 5:
			var lower := float(ring)*PI/10.0
			var upper := float(ring+1)*PI/10.0
			var a := dome_vertex(i,lower,5.70,2.04)
			var b := dome_vertex(i+1,lower,5.70,2.04)
			var c := dome_vertex(i,upper,5.70,2.04)
			var d := dome_vertex(i+1,upper,5.70,2.04)
			var shade := tint("506F7A",rng.randf()*.66)
			triangle(a,c,b,shade)
			if ring<4:
				triangle(b,c,d,shade.lerp(Color("31535D"),.17))
	# Keep the ceiling collision open at the breach and match the curved roof.
	var roof := builder.commit()
	var roof_shape := roof.create_trimesh_shape()
	roof_shape.backface_collision = true
	collide(roof_shape,Vector3.ZERO)
	builder = architecture
	builder.append_from(roof,0,Transform3D.IDENTITY)

func build_fragments(field: FIELD) -> void:
	for i in 22:
		var offset := Vector2(rng.randf_range(-15.0,14.0),rng.randf_range(-12.0,13.0))
		if offset.length()<6.4 or (offset.x<-3.0 and absf(offset.y)<3.8):
			continue
		var y := field.height(CENTER+offset)-position.y
		var size := Vector3(rng.randf_range(.35,1.44),rng.randf_range(.27,.69),rng.randf_range(.50,1.36))
		block(Vector3(offset.x,y+.04,offset.y),size,tint("526B6D",rng.randf()*.52),rng.randf()*TAU)
	for side in [-1.0,1.0]:
		for i in 3:
			var offset := Vector2(-10.0-i*2.9,side*2.8)
			var y := field.height(CENTER+offset)-position.y
			drum(.31,.53,[.90,.53,.34][i],Vector3(offset.x,y+.25,offset.y),Color("647E82"),i*.46)

func build_marker() -> void:
	var base := CylinderMesh.new()
	base.radial_segments = 8
	base.top_radius = .69
	base.bottom_radius = .98
	base.height = .36
	builder = SurfaceTool.new()
	builder.begin(Mesh.PRIMITIVE_TRIANGLES)
	stamp(base,Transform3D(Basis.IDENTITY,Vector3(0,.18,0)),Color("526A70"))
	var stone := ShaderMaterial.new()
	stone.shader = STONE
	add_visual("MarkerPedestal",builder.commit(),stone)
	var base_collider := CylinderShape3D.new()
	base_collider.radius = .72
	base_collider.height = .36
	collide(base_collider,Vector3.UP*.18)
	var light := OmniLight3D.new()
	light.position = Vector3(0,.86,0)
	light.light_color = Color("57D5FB")
	light.light_energy = .54
	light.omni_range = 5.0
	add_child(light)
	var gem := PrismMesh.new()
	gem.size = Vector3(.44,.68,.44)
	var glass := StandardMaterial3D.new()
	glass.albedo_color = Color("7FE1ED")
	glass.emission_enabled = true
	glass.emission = Color("57B6D3")
	glass.emission_energy_multiplier = .7
	add_visual("BlueStone",gem,glass)
	get_node("BlueStone").position.y = .62

func build_shaft_mesh() -> void:
	var beams := SurfaceTool.new()
	beams.begin(Mesh.PRIMITIVE_TRIANGLES)
	var surface_y := FIELD.WATER - position.y - .14
	for i in 5:
		var origin := Vector3(float(i)*3.8-6.0,surface_y,-7.3+sin(i*2.6)*4.4)
		var end := origin+Vector3(-2.9,-surface_y+.24,3.7)
		for side in [Vector3.RIGHT,Vector3.BACK]:
			var corners := [origin-side*.13,origin+side*.13,end-side*(1.13+.13*i),end+side*(1.13+.13*i)]
			var uvs := [Vector2(0,0),Vector2(1,0),Vector2(0,1),Vector2(1,1)]
			for index in [0,2,1,1,2,3]:
				beams.set_uv(uvs[index])
				beams.add_vertex(corners[index])
	var scatter := ShaderMaterial.new()
	scatter.shader = preload("res://shaders/a1_underwater_shafts.gdshader")
	shafts = add_visual("SunShafts",beams.commit(),scatter)
	shafts.hide()
