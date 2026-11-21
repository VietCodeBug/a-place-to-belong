extends Node3D

const FIELD = preload("res://scripts/world/superworld/terrain_field.gd")
const BOTANY = preload("res://scripts/world/a1_botany.gd")
const SHAPES = preload("res://scripts/world/shapes.gd")
const SWIM_SPEED := 3.8
var field: FIELD
var underwater := false
var depth := 0.0
var underwater_environment: Environment
var fog_camera: Camera3D
var schools: Array[MultiMeshInstance3D] = []
var shore_trees: Array[Node3D] = []
var shore_grass: MultiMeshInstance3D
var clock := 0.0
var water_material: ShaderMaterial
var plant_material := ShaderMaterial.new()
var fish_tick := 0.0
var shore_stones: Node3D


func setup(source: FIELD) -> void:
	field = source
	make_surface()
	make_pier()
	shore_stones = Node3D.new()
	make_shelf()
	make_shore()
	merge_lakeside_stones()
	shore_stones.free()
	shore_stones = null
	make_aquatic_plants()
	make_arch()
	make_fish()

func make_surface() -> void:
	var surface := SurfaceTool.new()
	surface.begin(Mesh.PRIMITIVE_TRIANGLES)
	var center := Vector3(FIELD.LAKE.x,FIELD.WATER,FIELD.LAKE.y)
	for i in 256:
		var a := field.lake_outline(i*TAU/256.0)-FIELD.LAKE
		var b := field.lake_outline((i+1)*TAU/256.0)-FIELD.LAKE
		surface.set_uv(Vector2.ZERO)
		surface.add_vertex(center)
		surface.set_uv(Vector2(1,0))
		surface.add_vertex(center+Vector3(a.x,0,a.y))
		surface.add_vertex(center+Vector3(b.x,0,b.y))
	surface.generate_normals()
	var visual := MeshInstance3D.new()
	visual.name = "LakeSurface"
	visual.mesh = surface.commit()
	water_material = ShaderMaterial.new()
	water_material.shader = preload("res://shaders/a1_superworld_lake.gdshader")
	visual.material_override = water_material
	visual.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	add_child(visual)

func make_pier() -> void:
	# The side of the pier remains open for water entry and exit.
	var z := FIELD.SHORE.y+6.0
	var last_pole := Vector3.ZERO
	var start := FIELD.SHORE.x-6.0
	for i in range(7):
		var x := start+i*2.25
		var y := lerpf(field.height(Vector2(start,z))+.04,FIELD.WATER+.54,minf(i/4.0,1.0))
		var deck := SHAPES.box(self,Vector3(x,y-.11,z),Vector3(2.27,.22,3.0),"8F6A46",true)
		deck.hide()
		for j in 8:
			var left := x-1.12+(.14+j*.28)
			var shade: String = ["886748","9C754F","A47F55","805C3E"][(i*5+j*7)%4]
			SHAPES.box(self,Vector3(left,y-.067,z+sin(j*7.5+i)*.022),Vector3(.262,.134,3.03),shade)
		for side in [-1.25,1.25]:
			SHAPES.box(self,Vector3(x,y-.24,z+side),Vector3(2.27,.17,.16),"625039")
		if i%2==0:
			var pole := Vector3(x,y+.75,z+1.34)
			SHAPES.box(self,pole-Vector3.UP*.3,Vector3(.16,.92,.16),"775E47")
			if last_pole != Vector3.ZERO:
				SHAPES.beam(self,last_pole-Vector3.UP*.28,pole-Vector3.UP*.28,.09,"A48255")
			last_pole = pole
			for sign_z in [-1.0,1.0]:
				SHAPES.box(self,Vector3(x,y-1.2,z+sign_z*1.25),Vector3(.27,3.25,.27),"665741")
	var post := Vector3(start-1.5,field.height(Vector2(start-1.5,z))+1.18,z+1.9)
	SHAPES.box(self,post-Vector3.UP*.45,Vector3(.13,1.55,.13),"68563D")
	var label := Label3D.new()
	label.text = "BỜ HỒ  ·  LỐI XUỐNG NƯỚC"
	label.font_size = 40
	label.pixel_size = .009
	label.outline_size = 9
	label.position = post+Vector3.UP*.27
	label.billboard = BaseMaterial3D.BILLBOARD_ENABLED
	add_child(label)

func make_shelf() -> void:
	var rng := RandomNumberGenerator.new()
	rng.seed = 66715
	for shelf in [FIELD.SHELF+Vector2(-8,-6),FIELD.ARCH+Vector2(1,8),Vector2(344,-512),Vector2(384,-438)]:
		for i in 12:
			var a := rng.randf()*TAU
			var p: Vector2 = shelf+Vector2.from_angle(a)*rng.randf_range(3.0,24.0)
			var h := field.height(p)
			if h>=FIELD.WATER-.6 or (absf(p.y-FIELD.ARCH.y)<4.5 and absf(p.x-FIELD.ARCH.x)<16.0):
				continue
			var breadth := rng.randf_range(.63,3.5)*(1.24 if i%4==0 else 1.0)
			BOTANY.place_stone(shore_stones,Vector3(p.x,h-.16,p.y),breadth,a,i%3==0)
			if i%5==0:
				for j in range(3):
					var end := p+Vector2.from_angle(a+j*.39)*rng.randf_range(1.4,3.4)
					var r1 := Vector3(p.x,h+.35,p.y)
					var r2 := Vector3(end.x,field.height(end)+.08,end.y)
					var mid := r1.lerp(r2,.48)+Vector3.UP*.46
					SHAPES.beam(self,r1,mid,.18,"5C503B")
					SHAPES.beam(self,mid,r2,.12,"676049")

func set_draw_range(root: Node3D, end: float) -> void:
	for item in root.find_children("*","MeshInstance3D",true,false):
		item.visibility_range_end=end

func make_shore() -> void:
	var rng := RandomNumberGenerator.new()
	rng.seed = 88023
	var locations: Array[Vector3] = []
	for i in range(1470):
		var p := FIELD.SHORE + Vector2(rng.randf_range(-30,10),rng.randf_range(-68,62))
		var y := field.height(p)
		if y > FIELD.WATER+.70 and field.trail_distance(p) > 1.85 and absf(p.y+449)>3.0 and (sin(p.y*.55)+cos(p.x*.35)>-.65):
			locations.append(Vector3(p.x,y,p.y))
	shore_grass = BOTANY.grass_batch(self,locations,845,85.0,.35,2.1)
	for entry in [[-7,-21,2.5],[-12,-17,1.3],[-10,19,2.1],[2,26,1.2],[-5,-37,1.6],[7,-31,2.4]]:
		var p := FIELD.SHORE+Vector2(entry[0],entry[1])
		BOTANY.place_stone(shore_stones,Vector3(p.x,field.height(p),p.y),entry[2],float(entry[1]),entry[2]>2.0)
	for entry in [[-17,-26,"NormalTree_3"],[-18,17,"BirchTree_2"],[-18,-6,"NormalTree_1"],[-23,33,"PineTree_2"]]:
		var p := FIELD.SHORE+Vector2(entry[0],entry[1])
		var tree := BOTANY.place(self,entry[2],Vector3(p.x,field.height(p),p.y),8.5+float(absi(entry[1])%5),entry[1])
		shore_trees.append(tree)

	for i in 31:
		var offset := -58.0+i*3.82
		var p := FIELD.SHORE+Vector2(rng.randf_range(-6.4,1.7),offset)
		if absf(offset-6)<7.2 or field.trail_distance(p)<2.8:
			continue
		var breadth := rng.randf_range(.75,3.4)
		BOTANY.place_stone(shore_stones,Vector3(p.x,field.height(p)-.10,p.y),breadth,rng.randf()*TAU,i%4==0)
	for offset in [-37.0,-17.0,16.0,36.0]:
		var p := FIELD.SHORE+Vector2(-9.4,offset)
		var shrub := BOTANY.place(self,"Bush_Large",Vector3(p.x,field.height(p),p.y),1.36,offset)
		set_draw_range(shrub,98)

func merge_lakeside_stones() -> void:
	# The decorative stones share materials and remain static. Merge small spatial
	# cells so the renderer can still cull them independently.
	var cells := {}
	for rock in shore_stones.get_children():
		var center := (Vector2(rock.position.x,rock.position.z)/28.0).floor()*28.0+Vector2.ONE*14.0
		if not cells.has(center):
			cells[center] = {}
		var materials: Dictionary = cells[center]
		for item in rock.find_children("*","MeshInstance3D",true,false):
			var mesh := item as MeshInstance3D
			var pose := mesh.transform
			var ancestor := mesh.get_parent_node_3d()
			while ancestor!=shore_stones:
				pose = ancestor.transform*pose
				ancestor = ancestor.get_parent_node_3d()
			pose.origin -= Vector3(center.x,0,center.y)
			for index in mesh.mesh.get_surface_count():
				var material := mesh.get_active_material(index)
				if not materials.has(material):
					var builder := SurfaceTool.new()
					builder.begin(Mesh.PRIMITIVE_TRIANGLES)
					materials[material] = builder
				materials[material].append_from(mesh.mesh,index,pose)
	var clusters := Node3D.new()
	clusters.name = "LakesideStoneGroups"
	add_child(clusters)
	for center: Vector2 in cells:
		var materials: Dictionary = cells[center]
		for material in materials:
			var visual := MeshInstance3D.new()
			visual.mesh = materials[material].commit()
			visual.position = Vector3(center.x,0,center.y)
			visual.material_override = material
			visual.visibility_range_end = 153.0
			clusters.add_child(visual)

func make_aquatic_plants() -> void:
	var builder := SurfaceTool.new()
	builder.begin(Mesh.PRIMITIVE_TRIANGLES)
	var rng := RandomNumberGenerator.new()
	rng.seed = 333113
	for blade in 7:
		var a := Vector2.from_angle(blade*2.39)
		var side := a.orthogonal() * rng.randf_range(.055,.16)
		var base := a*rng.randf_range(.05,.24)
		var h := rng.randf_range(.42,1.34)
		var curve := rng.randf_range(.11,.49)
		for segment in 5:
			for corner: Vector2 in [Vector2(0,-1),Vector2(1,-1),Vector2(0,1),Vector2(1,-1),Vector2(1,1),Vector2(0,1)]:
				var t := (segment+corner.x)/5.0
				var p := base + a*curve*t*t + side*corner.y*sin(PI*(.08+t*.92))
				builder.set_color(Color(t,rng.randf_range(.38,.87)*t,0))
				builder.add_vertex(Vector3(p.x,h*t,p.y))
	builder.generate_normals()
	var mesh := builder.commit()
	plant_material.shader = preload("res://shaders/a1_submerged_plants.gdshader")
	for center: Vector2 in [Vector2(232,-465),Vector2(236,-501),Vector2(260,-460),Vector2(283,-484),
		Vector2(306,-479),Vector2(317,-462),Vector2(344,-494),Vector2(370,-453),Vector2(394,-483)]:
		var poses: Array[Transform3D] = []
		for i in 55:
			var fan := Vector2.from_angle(rng.randf()*TAU)*sqrt(rng.randf())*rng.randf_range(2,14)
			var spot := center+fan
			var h := field.height(spot)
			var d := FIELD.WATER-h
			if d<.35 or (absf(spot.y-FIELD.ARCH.y)<2.5 and absf(spot.x-FIELD.ARCH.x)<13):
				continue
			var size := rng.randf_range(.55,1.44)
			poses.append(Transform3D(Basis(Vector3.UP,rng.randf()*TAU).scaled(Vector3(size,minf(size,d*.68),size)),
				Vector3(fan.x,h-.08,fan.y)))
		if poses.is_empty():
			continue
		var multi := MultiMesh.new()
		multi.transform_format = MultiMesh.TRANSFORM_3D
		multi.mesh = mesh
		multi.instance_count = poses.size()
		for i in poses.size():
			multi.set_instance_transform(i,poses[i])
		var plant := MultiMeshInstance3D.new()
		plant.multimesh = multi
		plant.material_override = plant_material
		plant.position = Vector3(center.x,0,center.y)
		plant.visibility_range_end = 112.0
		plant.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
		add_child(plant)

func set_season(index: int) -> void:
	shore_grass.visible = index != 3
	for tree in shore_trees:
		BOTANY.apply_season(tree,index)

func make_arch() -> void:
	var stone := SurfaceTool.new()
	stone.begin(Mesh.PRIMITIVE_TRIANGLES)
	stone.set_smooth_group(-1)
	var floor_y := field.height(FIELD.ARCH)-.18
	var across := [-2.7,2.85]
	for segment in 12:
		var a := float(segment)*PI/12.0
		var b := float(segment+1)*PI/12.0
		var rings: Array[PackedVector3Array] = []
		for x: float in across:
			var section := PackedVector3Array()
			for r in [Vector2(4.48,3.92),Vector2(2.64,2.54)]:
				var shell := float(r.x>3.0)
				for angle in [a,b]:
					var fold := .10*sin(angle*11.0+x)+shell*(.42*sin(angle*5.0+x)+.15*cos(angle*13.0+x))
					var face := x * (1.0+shell*.22*sin(angle*7.0))+.35*cos(angle*3.0)
					var lean := .36*sin(angle*1.7)+x*.12
					section.append(Vector3(FIELD.ARCH.x+face,floor_y+sin(angle)*(r.y+fold)+shell*.20*cos(angle*3.0),
						FIELD.ARCH.y+cos(angle)*(r.x+fold)+lean))
			rings.append(section)
		var left := rings[0]
		var right := rings[1]
		for face in [[left[0],left[1],left[2],left[3]], [right[1],right[0],right[3],right[2]],
			[left[1],left[0],right[1],right[0]], [left[2],left[3],right[2],right[3]]]:
			for i in [0,1,2,1,3,2]:
				stone.add_vertex(face[i])
	stone.generate_normals()
	var rock := MeshInstance3D.new()
	rock.name = "UnderwaterArch"
	rock.mesh = stone.commit()
	var material := ShaderMaterial.new()
	material.shader = preload("res://shaders/a1_submerged_rock.gdshader")
	rock.material_override=material
	add_child(rock)
	var body := StaticBody3D.new()
	var collision := CollisionShape3D.new()
	var shape := rock.mesh.create_trimesh_shape()
	shape.backface_collision=true
	collision.shape=shape
	body.add_child(collision)
	rock.add_child(body)

func make_fish() -> void:
	var geometry := SurfaceTool.new()
	geometry.begin(Mesh.PRIMITIVE_TRIANGLES)
	var body := PackedVector3Array([Vector3(.29,0,0),Vector3(.025,.075,0),Vector3(.025,-.065,0),
		Vector3(-.17,0,0),Vector3(.04,0,.054),Vector3(.04,0,-.054),
		Vector3(-.29,.071,.014),Vector3(-.29,-.067,.014)])
	for face in [[0,1,4],[0,4,2],[0,2,5],[0,5,1],[3,4,1],[3,2,4],
		[3,5,2],[3,1,5],[3,6,7]]:
		for i in face:
			geometry.add_vertex(body[i])
	geometry.generate_normals()
	var mesh := geometry.commit()
	var material := StandardMaterial3D.new()
	material.albedo_color = Color("ABC0A4")
	material.roughness = .45
	material.vertex_color_use_as_albedo = true
	material.cull_mode = BaseMaterial3D.CULL_DISABLED
	for i in 3:
		var fish := MultiMesh.new()
		fish.transform_format = MultiMesh.TRANSFORM_3D
		fish.mesh = mesh
		fish.use_colors = true
		fish.instance_count = [14,12,17][i]
		for slot in fish.instance_count:
			var tint: Color = [Color("C2D4AE"),Color("A7C8C4"),Color("C6AF82")][i]
			fish.set_instance_color(slot,tint.darkened(.10+.06*(slot%5)))
		var school := MultiMeshInstance3D.new()
		school.multimesh = fish
		school.material_override = material
		school.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
		add_child(school)
		schools.append(school)

func _process(delta: float) -> void:
	clock += delta
	fish_tick += delta
	if fish_tick < 1.0/24.0:
		return
	fish_tick = fmod(fish_tick,1.0/24.0)
	var camera := get_viewport().get_camera_3d()
	if camera == null:
		return
	for j in schools.size():
		var school := schools[j]
		var center: Vector2 = [FIELD.SHELF+Vector2(5,-8),FIELD.ARCH+Vector2(-2,7),Vector2(352,-470)][j]
		var eye := Vector2(camera.global_position.x,camera.global_position.z)
		school.visible = eye.distance_squared_to(center)<100.0*100.0
		if not school.visible:
			continue
		for i in school.multimesh.instance_count:
			var a := clock*(.26+j*.048)+j*2.9+i*.139
			var p := center+Vector2(cos(a),sin(a))*Vector2(7.0+(i%5)*.45,4.7+(i%4)*.7)
			var y := lerpf(field.height(p),FIELD.WATER,.58-j*.095+sin(i*1.2+clock*.66)*.14)
			var basis := Basis(Vector3.UP,-a-PI*.5).scaled(Vector3.ONE*(1.05+float(i%5)*.14))
			school.multimesh.set_instance_transform(i,Transform3D(basis,Vector3(p.x,y,p.y)))

func contains(p: Vector3) -> bool:
	return field.lake_ratio(Vector2(p.x,p.z))<1.0 and p.y < FIELD.WATER-.29

func swim(player: CharacterBody3D, direction: Vector3, blocked: bool, delta: float) -> void:
	var velocity_target := 0.0
	if not blocked and Input.is_action_pressed("a1_dive"):
		velocity_target = -3.2
	elif not blocked and Input.is_action_pressed("a1_surface"):
		velocity_target = 3.2 if player.position.y < FIELD.WATER-.88 else 0.0
	elif player.position.y > FIELD.WATER-.80:
		velocity_target = -1.25
	player.velocity.x = move_toward(player.velocity.x,direction.x*SWIM_SPEED,delta*8.0)
	player.velocity.z = move_toward(player.velocity.z,direction.z*SWIM_SPEED,delta*8.0)
	player.velocity.y = move_toward(player.velocity.y,velocity_target,delta*9.0)
	player.move_and_slide()

func update_view(camera: Camera3D) -> void:
	var below := contains(camera.global_position)
	if fog_camera != camera:
		if is_instance_valid(fog_camera):
			fog_camera.environment = null
		fog_camera = camera
		underwater = false
	if below == underwater:
		return
	underwater = below
	if below:
		var base := camera.get_world_3d().environment
		underwater_environment = base.duplicate() as Environment
		underwater_environment.background_mode = Environment.BG_COLOR
		underwater_environment.background_color = Color("103C50")
		underwater_environment.fog_enabled = true
		underwater_environment.fog_mode = Environment.FOG_MODE_EXPONENTIAL
		underwater_environment.fog_light_color = Color("22727A")
		underwater_environment.fog_density = .043
		underwater_environment.ambient_light_energy *= .56
		camera.environment = underwater_environment
	else:
		camera.environment = null


func update_weather(weather: Node) -> void:
	water_material.set_shader_parameter("wind_strength",float(weather.weather_value.z)*.75)
	water_material.set_shader_parameter("rain",float(weather.weather_value.y))
	var hours: float = weather.hours
	var daylight := smoothstep(0.0,.35,sin((hours-6.0)*TAU/24.0))
	water_material.set_shader_parameter("sky_horizon",Color("25404F").lerp(Color("9DB8B5"),daylight))
	water_material.set_shader_parameter("sky_zenith",Color("13293E").lerp(Color("4C839C"),daylight))
	if underwater and is_instance_valid(fog_camera):
		var below := FIELD.WATER-fog_camera.global_position.y
		underwater_environment.fog_density = lerpf(.037,.076,smoothstep(.7,22.0,below)) + float(weather.weather_value.y)*.023
		underwater_environment.fog_light_color = Color("398787").lerp(Color("17384D"),smoothstep(2.0,25.0,below))
