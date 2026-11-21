extends Node3D

const FIELD = preload("res://scripts/world/superworld/terrain_field.gd")
const COVER = preload("res://scripts/world/superworld/biome_cover.gd")
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
var outer_water: ShaderMaterial
var underside: MeshInstance3D
var surface_group: Node3D
var cover: COVER
var plant_material := ShaderMaterial.new()
var fish_tick := 0.0
var shore_stones: Node3D


func setup(source: FIELD, planting: COVER) -> void:
	field = source
	cover = planting
	make_surface()
	make_pier()
	shore_stones = Node3D.new()
	make_shelf()
	make_shore()
	make_arch_shoulders()
	merge_lakeside_stones()
	shore_stones.free()
	shore_stones = null
	make_aquatic_plants()
	make_arch()
	make_fish()

func make_surface() -> void:
	surface_group = Node3D.new()
	surface_group.name = "LakeSurface"
	add_child(surface_group)
	var limit := .855
	water_material = make_water_band("DeepWater",0,limit,preload("res://shaders/a1_lake_deep.gdshader")).material_override
	outer_water = make_water_band("ClearLittoral",limit,1.0,preload("res://shaders/a1_superworld_lake.gdshader")).material_override
	underside = make_water_band("SubmergedView",0,1.0,preload("res://shaders/a1_lake_underside.gdshader"))
	underside.hide()

func make_water_band(label: String, inner: float, outer: float, shader: Shader) -> MeshInstance3D:
	var surface := SurfaceTool.new()
	surface.begin(Mesh.PRIMITIVE_TRIANGLES)
	var center := Vector3(FIELD.LAKE.x,FIELD.WATER,FIELD.LAKE.y)
	for i in 256:
		var a := field.lake_outline(i*TAU/256.0)-FIELD.LAKE
		var b := field.lake_outline((i+1)*TAU/256.0)-FIELD.LAKE
		var va := Vector3(a.x,0,a.y)
		var vb := Vector3(b.x,0,b.y)
		surface.set_uv(Vector2(inner,0))
		surface.add_vertex(center+va*inner)
		surface.set_uv(Vector2(outer,0))
		surface.add_vertex(center+va*outer)
		surface.add_vertex(center+vb*outer)
		if inner>0.0:
			surface.set_uv(Vector2(inner,0))
			surface.add_vertex(center+va*inner)
			surface.set_uv(Vector2(outer,0))
			surface.add_vertex(center+vb*outer)
			surface.set_uv(Vector2(inner,0))
			surface.add_vertex(center+vb*inner)
	surface.generate_normals()
	var visual := MeshInstance3D.new()
	visual.name = label
	visual.mesh = surface.commit()
	var material := ShaderMaterial.new()
	material.shader = shader
	visual.material_override = material
	visual.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	surface_group.add_child(visual)
	return visual

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
	for i in 1800:
		var p := FIELD.SHORE+Vector2(rng.randf_range(-27,5),rng.randf_range(-79,72))
		var y := field.height(p)
		var d := field.lake_ratio(p)
		var thicket := field.shore_rockiness(p)+(sin(p.y*.23)+cos(p.x*.34))*.18
		if d > 1.007 and y>FIELD.WATER+.46 and thicket>.46 and absf(p.y+449.0)>3.3 and field.trail_distance(p)>2.2:
			locations.append(Vector3(p.x,y-.012,p.y))
	shore_grass = BOTANY.grass_batch(self,locations,845,89.0,.31,1.9,true)

	# Oak beach edge, birch inlet and a conifer headland, with the sandy pier approach open.
	for entry in [[-6,-20,"NormalTree_3",12.6],[-8,-15,"NormalTree_4",10.7],[-16,-21,"NormalTree_4",10.7],[-12,-27,"PineTree_3",13.2],
		[-22,-8,"NormalTree_1",10.5],[-10,21,"BirchTree_2",11.9],[-15,27,"BirchTree_3",9.8],
		[-9,32,"NormalTree_3",10.0],[-26,38,"PineTree_2",14.9],[-14,44,"PineTree_1",12.3],
		[-24,-55,"PineTree_3",12.8],[-17,-49,"PineTree_2",11.9],[-15,-42,"NormalTree_4",9.3]]:
		var p := FIELD.SHORE+Vector2(entry[0],entry[1])
		var y := field.height(p)
		if y < FIELD.WATER+.40 or field.trail_distance(p)<3.0:
			continue
		var tree := BOTANY.place(self,entry[2],Vector3(p.x,y-.10,p.y),entry[3],rng.randf()*TAU)
		set_draw_range(tree,113.0)
		shore_trees.append(tree)

	for cluster: Vector2 in [Vector2(-7,-16),Vector2(-6,-24),Vector2(-4,-45),Vector2(-8,25),Vector2(-12,46),Vector2(-5,58)]:
		var at := FIELD.SHORE+cluster
		var group := Node3D.new()
		group.position = Vector3(at.x,0,at.y)
		add_child(group)
		var flowers: Array[Transform3D] = []
		var bushes: Array[Transform3D] = []
		for i in 44:
			var offset := Vector2(rng.randfn(0,1.40),rng.randfn(0,2.65))
			var p := at+offset
			var h := field.height(p)
			if h < FIELD.WATER+.29 or field.trail_distance(p)<2.1:
				continue
			if i%7==0:
				bushes.append(cover.pose(p,h-.05,at,Vector3.ONE*rng.randf_range(.55,1.33),rng.randf()*TAU))
			else:
				flowers.append(cover.pose(p,h,at,Vector3.ONE*rng.randf_range(.37,.61),rng.randf()*TAU))
		cover.draw_parts(group,"Shrubs",cover.parts["Bush_Large"],bushes,82)
		cover.draw_parts(group,"MeadowFlowers",cover.parts["Flower_2"],flowers,65)

	for ledge in [[-5,-25,4.1],[-2,-33,3.3],[-4,21,3.2],[-3,40,3.6],[-7,47,4.8],[-2,-56,4.2]]:
		var point := FIELD.SHORE+Vector2(ledge[0],ledge[1])
		for i in 5:
			var p := point+Vector2(rng.randfn(0,1.14),rng.randfn(0,1.85))
			if field.trail_distance(p)<2.8:
				continue
			BOTANY.place_stone(shore_stones,Vector3(p.x,field.height(p)-.15,p.y),
				ledge[2]*rng.randf_range(.33,1.15),rng.randf()*TAU,i%2==0)

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
		Vector2(306,-479),Vector2(317,-462),Vector2(337,-484),Vector2(346,-493),Vector2(370,-453),Vector2(394,-483),Vector2(452,-438)]:
		var poses: Array[Transform3D] = []
		for i in (58 if center.x<335 else 36):
			var fan := Vector2.from_angle(rng.randf()*TAU)*sqrt(rng.randf())*rng.randf_range(2,14)
			var spot := center+fan
			var h := field.height(spot)
			var d := FIELD.WATER-h
			if d<.35 or (absf(spot.y-FIELD.ARCH.y)<2.5 and absf(spot.x-FIELD.ARCH.x)<13):
				continue
			var size := rng.randf_range(.44,1.54) * (1.34 if i%8==0 else .84)
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

func make_arch_shoulders() -> void:
	# Broken layers continue into the bed on both sides of the swim opening.
	var rng := RandomNumberGenerator.new()
	rng.seed = 10549
	for bank in [-1.0,1.0]:
		for i in 14:
			var off := Vector2(rng.randf_range(-6.1,9.8),bank*rng.randf_range(3.55,11.3))
			var p := FIELD.ARCH+off
			var h := field.height(p)
			var span := rng.randf_range(.71,2.9) * (1.39 if absf(off.y)<6.6 else .77)
			BOTANY.place_stone(shore_stones,Vector3(p.x,h-.31,p.y),span,.41+rng.randf_range(-.18,.45),i%3==0)
	for layer: Vector3 in [Vector3(378,-471,7.6),Vector3(390,-472,5.4),Vector3(641,-458,9.9),
		Vector3(633,-463,6.3),Vector3(639,-449,4.7)]:
		var center := Vector2(layer.x,layer.y)
		for i in 4:
			var p := center+Vector2(rng.randf_range(-2.8,2.8),rng.randf_range(-2.3,2.3))
			var h := field.height(p)
			var rock := BOTANY.place_stone(shore_stones,Vector3(p.x,h-.28,p.y),
				layer.z*rng.randf_range(.39,.87),.21+i*.28,true)
			rock.scale.y = .75+i*.10

func make_arch() -> void:
	var stone := SurfaceTool.new()
	stone.begin(Mesh.PRIMITIVE_TRIANGLES)
	stone.set_smooth_group(-1)
	var floor_y := field.height(FIELD.ARCH)-.18
	var across := [-3.0,.52,3.35]
	for segment in 12:
		var a := float(segment)*PI/12.0
		var b := float(segment+1)*PI/12.0
		var rings: Array[PackedVector3Array] = []
		for x: float in across:
			var section := PackedVector3Array()
			for r in [Vector2(4.68,3.97),Vector2(2.66,2.55)]:
				var shell := float(r.x>3.0)
				for angle in [a,b]:
					var slab := sin(angle*7.0+x*.65)+.63*cos(angle*13.0-x)
					var fold := .095*sin(angle*11.0+x)+shell*(.39*slab+.27*sin(angle*2.0))
					var face := x*(1.0+shell*.19*sin(angle*6.0))+.54*cos(angle*3.0+x*.58)
					var lean := .35*sin(angle*1.7)+x*.105
					var elevation: float = floor_y+sin(angle)*(r.y+fold)+shell*.32*cos(angle*3.0+x*.45)
					section.append(Vector3(FIELD.ARCH.x+face,elevation,FIELD.ARCH.y+cos(angle)*(r.x+fold)+lean))
			rings.append(section)
		for i in 2:
			var left := rings[i]
			var right := rings[i+1]
			for face in [[left[1],left[0],right[1],right[0]], [left[2],left[3],right[2],right[3]]]:
				for k in [0,1,2,1,3,2]:
					stone.add_vertex(face[k])
		for face in [[rings[0][0],rings[0][1],rings[0][2],rings[0][3]],
			[rings[2][1],rings[2][0],rings[2][3],rings[2][2]]]:
			for k in [0,1,2,1,3,2]:
				stone.add_vertex(face[k])
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
	underside.visible = below
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
	var hours: float = weather.hours
	var daylight := smoothstep(0.0,.35,sin((hours-6.0)*TAU/24.0))
	for material in [water_material,outer_water]:
		material.set_shader_parameter("wind_strength",float(weather.weather_value.z)*.75)
		material.set_shader_parameter("rain",float(weather.weather_value.y))
		material.set_shader_parameter("sky_horizon",Color("25404F").lerp(Color("9DB8B5"),daylight))
		material.set_shader_parameter("sky_zenith",Color("13293E").lerp(Color("4C839C"),daylight))
	if underwater and is_instance_valid(fog_camera):
		var below := FIELD.WATER-fog_camera.global_position.y
		var middle := smoothstep(2.3,11.5,below)
		var basin := smoothstep(11.0,28.0,below)
		underwater_environment.fog_density = lerpf(.023,.051,middle)+basin*.023+float(weather.weather_value.y)*.013
		underwater_environment.fog_light_color = Color("488571").lerp(Color("28617A"),middle).lerp(Color("132F48"),basin)
		underwater_environment.ambient_light_energy = lerpf(.64,.28,middle)*(1.0-basin*.48)*lerpf(.5,1.0,daylight)
