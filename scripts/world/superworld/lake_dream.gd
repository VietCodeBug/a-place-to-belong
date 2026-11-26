extends "res://scripts/world/superworld/lake_masonry.gd"
## Landmarks, submerged routes and visual effects for the western shelf.

const FIELD = preload("res://scripts/world/superworld/terrain_field.gd")
const BOTANY = preload("res://scripts/world/a1_botany.gd")
const VAULT = preload("res://scripts/world/superworld/lake_vault.gd")
const FLOW = preload("res://scripts/story/map_flow.gd")

var field: FIELD
var vault: VAULT
var garden_material: ShaderMaterial
var shafts_material: ShaderMaterial
var underwater_effects: Array[MeshInstance3D] = []

func setup(source: FIELD) -> void:
	field = source
	name = "LakeDream"
	rng.seed = 98411
	cube.size = Vector3.ONE
	for i in FIELD.LAKE_ROUTES.size():
		lay_route(FIELD.LAKE_ROUTES[i],i)
	place_outcrops()
	build_courtyard_statue()
	build_garden()
	build_shafts()
	build_bubbles(FIELD.DIVE_ENTRY+Vector2(3,-1),26,2.2,.7)
	build_bubbles(FIELD.LIGHT_GARDEN,38,9.0,4.1)
	build_fishing_spot()
	vault = VAULT.new()
	add_child(vault)
	vault.setup(field)
	set_underwater(false)

func bank_origin(point: Vector2, offset: float) -> Vector3:
	return Vector3(point.x,field.height(point)+offset,point.y)

func lay_route(route: Array, index: int) -> void:
	var anchor: Vector2 = route[0]
	var origin := Vector3(anchor.x,0,anchor.y)
	builder = SurfaceTool.new()
	builder.begin(Mesh.PRIMITIVE_TRIANGLES)
	for leg in range(route.size()-1):
		var from: Vector2 = route[leg]
		var to: Vector2 = route[leg+1]
		var direction := from.direction_to(to)
		var count := maxi(2,ceili(from.distance_to(to)/(1.57 if index==0 else 2.25)))
		for i in count:
			var at := from.lerp(to,float(i)/count)
			if at.distance_squared_to(FIELD.PAVILION)<49.0 or at.distance_squared_to(FIELD.STAIR_GATE)<81.0:
				continue
			if rng.randf()<(.14 if index==0 else .34):
				continue
			var angle := -direction.angle()+rng.randf_range(-.11,.11)
			var drift := direction.orthogonal()*rng.randf_range(-.35,.35)
			var width := rng.randf_range(1.55,2.15) if index==0 else rng.randf_range(.93,1.58)
			var stone := Vector3(rng.randf_range(.86,1.20),.22,width)
			block(bank_origin(at+drift,.013)-origin,stone,tint("89968B",rng.randf()*.61),angle)
			if i%7==3:
				var crumb := at-drift+direction.orthogonal()*rng.randf_range(1.04,1.34)
				block(bank_origin(crumb,.036)-origin,Vector3(.61,.19,.45),Color("778F84"),angle+.23)
	var path := stone_visual("SunkenRoute%d" % index)
	path.position = origin
	path.visibility_range_end = 126.0

func place_outcrops() -> void:
	var stones := Node3D.new()
	stones.name = "ShelfOutcrops"
	add_child(stones)
	# Offset each outcrop from the route so the silhouettes frame the swim corridor.
	for patch: Vector4 in [Vector4(239,-449,4.7,.73),Vector4(249,-469,5.3,1.29),
			Vector4(264,-447,6.6,1.19),Vector4(277,-450,4.3,.19),Vector4(288,-460,4.7,1.7),
			Vector4(350,-437,6.1,.53),Vector4(365,-440,8.2,1.84),Vector4(370,-434,5.7,.80),
			Vector4(354,-424,6.7,-.20),Vector4(363,-417,5.0,1.02),Vector4(380,-446,7.4,.79)]:
		var point := Vector2(patch.x,patch.y)
		place_outcrop(stones,bank_origin(point,-.21),patch.z,patch.w)
	# The vault sits beneath a fractured bedrock overhang, with a gap at its west door.
	var vault_y := field.height(FIELD.LAKE_VAULT)+.55
	for crown: Vector4 in [Vector4(387.6,-437.3,8.8,.34),Vector4(390.3,-442.1,7.6,1.06),Vector4(384.9,-442.6,4.9,2.08)]:
		place_outcrop(stones,Vector3(crown.x,vault_y+5.57,crown.y),crown.z,crown.w)
	for side: Vector4 in [Vector4(384.3,-434.0,6.0,-.26),Vector4(390.5,-433.7,7.1,1.10),Vector4(391.3,-445.3,6.6,1.70)]:
		place_outcrop(stones,bank_origin(Vector2(side.x,side.y),-.32),side.z,side.w)

func place_outcrop(parent: Node3D, origin: Vector3, width: float, yaw: float) -> void:
	var rock := BOTANY.place_stone(parent,origin,width,yaw,true)
	var rock_body := StaticBody3D.new()
	rock.add_child(rock_body)
	for mesh: MeshInstance3D in rock.find_children("*","MeshInstance3D",true,false):
		mesh.visibility_range_end = 88.0
		mesh.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
		var hull := mesh.mesh.create_convex_shape()
		var pose := rock.global_transform.affine_inverse()*mesh.global_transform
		var points := hull.points
		for i in points.size():
			points[i] = pose*points[i]
		hull.points = points
		var collider := CollisionShape3D.new()
		collider.shape = hull
		rock_body.add_child(collider)

func build_courtyard_statue() -> void:
	var at := bank_origin(FIELD.PAVILION+Vector2(9.0,-6.4),-.06)
	builder = SurfaceTool.new()
	builder.begin(Mesh.PRIMITIVE_TRIANGLES)
	drum(.66,.98,.34,Vector3.UP*.08,Color("7E958D"),.26)
	var carved := SphereMesh.new()
	carved.radial_segments = 9
	carved.rings = 4
	stamp(carved,Transform3D(Basis(Vector3.BACK,-.26).scaled_local(Vector3(1.8,2.25,.69)),Vector3(0,1.24,0)),
		Color("6D928C"))
	stamp(carved,Transform3D(Basis(Vector3.BACK,-.62).scaled_local(Vector3(.65,.98,.52)),Vector3(.56,2.03,.01)),
		Color("819A94"))
	block(Vector3(.24,1.37,-.33),Vector3(.98,.12,.15),Color("8AA29C"),-.04)
	var figure := stone_visual("WornCourtyardFigure")
	figure.position = at

func triangle_with_uv(mesh: SurfaceTool, a: Vector3, b: Vector3, c: Vector3, color: Color, glow: float) -> void:
	var normal := (c-a).cross(b-a).normalized()
	for p: Vector3 in [a,b,c]:
		mesh.set_normal(normal)
		mesh.set_color(color)
		mesh.set_uv(Vector2(0,glow))
		mesh.add_vertex(p)

func build_garden() -> void:
	var anchor := bank_origin(FIELD.LIGHT_GARDEN,0)
	var flowers := SurfaceTool.new()
	flowers.begin(Mesh.PRIMITIVE_TRIANGLES)
	var patches := [
		Vector4(-5,-3,2.7,9),Vector4(5,-3,2.9,10),Vector4(4,4,2.5,8),
		Vector4(-4,3,2.5,8),Vector4(-.8,-6.4,1.7,8),
	]
	for patch: Vector4 in patches:
		for i in int(patch.w):
			var offset := Vector2(patch.x,patch.y)+Vector2.from_angle(rng.randf()*TAU)*sqrt(rng.randf())*patch.z
			var plant := bank_origin(FIELD.LIGHT_GARDEN+offset,-.03)-anchor
			var scale := rng.randf_range(.46,.87)
			flower(flowers,plant,scale,i)
	flower(flowers,bank_origin(FIELD.LIGHT_GARDEN+Vector2(3.8,-4.2),-.03)-anchor,1.85,0)
	flower(flowers,bank_origin(FIELD.LIGHT_GARDEN+Vector2(5.2,-4.7),-.03)-anchor,1.25,1)
	flower(flowers,bank_origin(FIELD.LIGHT_GARDEN+Vector2(2.6,-5.5),-.03)-anchor,1.15,2)
	garden_material = ShaderMaterial.new()
	garden_material.shader = preload("res://shaders/a1_lake_garden.gdshader")
	var blooms := add_visual("LightGarden",flowers.commit(),garden_material)
	blooms.position = anchor
	blooms.visibility_range_end = 74.0

func flower(mesh: SurfaceTool, foot: Vector3, size: float, variant: int) -> void:
	var bearing := rng.randf()*TAU
	var lean := Vector3(cos(bearing),0,sin(bearing))*size
	var joints := [foot,foot+Vector3.UP*(.58*size),foot+Vector3.UP*(1.14*size)+lean*.19,
		foot+Vector3.UP*(1.65*size)+lean*.42]
	for face in 5:
		var ray := Vector3.RIGHT.rotated(Vector3.UP,bearing+float(face)*TAU/5.0)
		var next := ray.rotated(Vector3.UP,TAU/5.0)
		for segment in 3:
			var lower: Vector3 = joints[segment]
			var upper: Vector3 = joints[segment+1]
			var w := size*(.076-.010*segment)
			var green := Color("217D75").lerp(Color("5AADA0"),float(segment)/3.0)
			triangle_with_uv(mesh,lower+ray*w,upper+ray*w,lower+next*w,green,.10)
			triangle_with_uv(mesh,lower+next*w,upper+ray*w,upper+next*w,green,.10)
	var base: Vector3 = joints[3]
	var color: Color = [Color("D8FFF8"),Color("74D0C4"),Color("8FC6EE")][variant%3]
	for petal in 6:
		var outward := Vector3.RIGHT.rotated(Vector3.UP,bearing+petal*TAU/6.0)
		var side := outward.cross(Vector3.UP)
		var center := base+outward*(.44*size)+Vector3.UP*(.23*size)
		var tip := base+outward*(.85*size)+Vector3.UP*(.34*size)
		var fold := center+Vector3.UP*(.14*size)
		for ribbon_side: float in [-1.0,1.0]:
			var edge := center+side*(ribbon_side*.23*size)
			triangle_with_uv(mesh,base,fold,edge,color.darkened(.17),.61)
			triangle_with_uv(mesh,edge,fold,tip,color,.91)
	var crown := base+Vector3.UP*(.40*size)
	for i in 5:
		var direction := Vector3.RIGHT.rotated(Vector3.UP,i*TAU/5.0)*(.17*size)
		triangle_with_uv(mesh,base+direction,crown,base+direction.rotated(Vector3.UP,TAU/5.0),Color("E3FFFC"),1.0)

func build_shafts() -> void:
	var shafts := SurfaceTool.new()
	shafts.begin(Mesh.PRIMITIVE_TRIANGLES)
	for zone in [Vector2(267,-456),FIELD.LIGHT_GARDEN]:
		for i in 5:
			var top := Vector3(zone.x+float(i-2)*2.8,FIELD.WATER-.17,zone.y-3.4+sin(i*2.5)*3.9)
			var base := end_of_shaft(top)
			for axis: Vector3 in [Vector3.RIGHT,Vector3.BACK]:
				var vertices := [top-axis*.31,top+axis*.31,base-axis*(2.4+i*.19),base+axis*(2.4+i*.19)]
				var uvs := [Vector2.ZERO,Vector2.RIGHT,Vector2.DOWN,Vector2.ONE]
				for vertex in [0,2,1,1,2,3]:
					shafts.set_uv(uvs[vertex])
					shafts.add_vertex(vertices[vertex])
	shafts_material = ShaderMaterial.new()
	shafts_material.shader = preload("res://shaders/a1_underwater_shafts.gdshader")
	underwater_effects.append(add_visual("ShelfLightShafts",shafts.commit(),shafts_material))

func end_of_shaft(top: Vector3) -> Vector3:
	var p := Vector2(top.x-4.8,top.z+5.2)
	return bank_origin(p,.06)

func build_bubbles(center: Vector2, count: int, spread: float, travel: float) -> void:
	var mesh := SurfaceTool.new()
	mesh.begin(Mesh.PRIMITIVE_TRIANGLES)
	for i in count:
		var offset := Vector2.from_angle(rng.randf()*TAU)*sqrt(rng.randf())*spread
		var at := bank_origin(center+offset,rng.randf_range(.12,.34))
		var radius := rng.randf_range(.029,.076)
		var right := Vector3.RIGHT*radius
		var up := Vector3.UP*radius
		var points := [at-right-up,at+right-up,at+right+up,at-right+up]
		var uv := [Vector2.ZERO,Vector2.RIGHT,Vector2.ONE,Vector2.DOWN]
		var phase := Color(rng.randf(),rng.randf(),rng.randf())
		for j in [0,1,2,0,2,3]:
			mesh.set_color(phase)
			mesh.set_uv(uv[j])
			mesh.add_vertex(points[j])
	var material := ShaderMaterial.new()
	material.shader = preload("res://shaders/a1_lake_bubbles.gdshader")
	material.set_shader_parameter("travel",travel)
	var bubbles := add_visual("ClearwaterBubbles",mesh.commit(),material)
	bubbles.extra_cull_margin = 5.0
	bubbles.visibility_range_end = 31.0
	underwater_effects.append(bubbles)

func build_fishing_spot() -> void:
	var quiet_spot := StoryInteractable.new()
	quiet_spot.name = "QuietPier"
	quiet_spot.position = Vector3(222.9,FIELD.WATER+1.09,-447.92)
	quiet_spot.interaction_name = FLOW.text("Read the pier marker","Đọc dấu ở bến")
	quiet_spot.title = FLOW.text("Quiet water","Mặt nước yên")
	quiet_spot.category = FLOW.text("WEST PIER","BẾN TÂY")
	quiet_spot.message = FLOW.text("The current eases beside the pier. Small fish gather in the shade.",
		"Nước chảy chậm lại bên bến. Đàn cá nhỏ tụ dưới bóng ván.")
	quiet_spot.set_meta("focus_radius",.55)
	add_child(quiet_spot)
	builder = SurfaceTool.new()
	builder.begin(Mesh.PRIMITIVE_TRIANGLES)
	block(Vector3(0,-.27,0),Vector3(.12,.66,.12),Color("726849"))
	block(Vector3(0,.05,0),Vector3(.14,.48,.51),Color("9E9679"))
	var marker := stone_visual("QuietPierMarker")
	marker.position = quiet_spot.position

func set_underwater(below: bool) -> void:
	for effect in underwater_effects:
		effect.visible = below

func update_light(daylight: float, rain: float, event_active: bool) -> void:
	var intensity := daylight*(1.0-rain*.72)
	shafts_material.set_shader_parameter("strength",intensity*1.65)
	garden_material.set_shader_parameter("glow_strength",1.34 if event_active else lerpf(1.09,.84,intensity))
