extends Node3D

const FIELD = preload("res://scripts/world/superworld/terrain_field.gd")
const COVER = preload("res://scripts/world/superworld/biome_cover.gd")
const BOTANY = preload("res://scripts/world/a1_botany.gd")
const SHAPES = preload("res://scripts/world/shapes.gd")
const RUINS = preload("res://scripts/world/superworld/lake_ruins.gd")
const HABITATS = preload("res://scripts/world/superworld/lake_habitats.gd")
const LANDMARKS = preload("res://scripts/world/superworld/lake_landmarks.gd")
const TRENCH = preload("res://scripts/world/superworld/lake_trench.gd")
const DREAM = preload("res://scripts/world/superworld/lake_dream.gd")
const SWIM_SPEED := 3.8
const TRENCH_DIVE_METRES := 18.0
const TRENCH_FLOOR_Y := FIELD.WATER - TRENCH_DIVE_METRES - 1.2
const FISH := [
	preload("res://assets/vendor/quaternius/fish/Fish1.glb"),
	preload("res://assets/vendor/quaternius/fish/Fish2.glb"),
	preload("res://assets/vendor/quaternius/fish/Fish3.glb"),
]
# Center, orbit, count, mesh, size, height through the water column.
const SHOALS := [
	[FIELD.LAKE_MEADOW,Vector2(5.0,3.6),20,0,.43,.48],
	[Vector2(326,-448),Vector2(4.0,2.85),15,2,.62,.57],
	[Vector2(352,-461),Vector2(6.2,4.7),12,1,.92,.49],
	[Vector2(345,-473),Vector2(5.4,3.1),18,0,.66,.34],
	[FIELD.LIGHT_GARDEN+Vector2(3.0,-5.0),Vector2(3.0,2.3),7,0,.48,.34],
]
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
var fish_tick := 0.0
var shore_stones: Node3D
var pavilion: RUINS
var trenches: Array[TRENCH] = []
var dream: DREAM
var garden_event := false


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
	var habitats := HABITATS.new()
	add_child(habitats)
	habitats.setup(field)
	make_arch()
	pavilion = RUINS.new()
	add_child(pavilion)
	pavilion.setup(field)
	for site in LANDMARKS.SITES.size():
		var landmark := LANDMARKS.new()
		add_child(landmark)
		landmark.setup(field,site)
	for i in FIELD.TRENCHES.size():
		var trench := TRENCH.new()
		add_child(trench)
		trench.setup(field,FIELD.TRENCHES[i],i)
		trenches.append(trench)
	dream = DREAM.new()
	add_child(dream)
	dream.setup(field)
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
	var meshes: Array[Mesh] = []
	for fish_scene: PackedScene in FISH:
		var fish := fish_scene.instantiate()
		var source := fish.find_children("*","MeshInstance3D",true,false)[0] as MeshInstance3D
		meshes.append(source.mesh)
		fish.free()
	var material := ShaderMaterial.new()
	material.shader = preload("res://shaders/a1_school_fish.gdshader")
	for j in SHOALS.size():
		var config: Array = SHOALS[j]
		var center: Vector2 = config[0]
		var orbit: Vector2 = config[1]
		var bottom := -INF
		for segment in 12:
			bottom = maxf(bottom,field.height(center+Vector2.from_angle(segment*TAU/12.0)*(orbit+Vector2.ONE)))
		var height := lerpf(bottom+.52,FIELD.WATER-1.20,config[5])
		var mesh := MultiMesh.new()
		mesh.transform_format = MultiMesh.TRANSFORM_3D
		mesh.mesh = meshes[config[3]]
		mesh.use_colors = true
		mesh.use_custom_data = true
		mesh.instance_count = config[2]
		for slot in mesh.instance_count:
			var brightness := .86+float((slot*7)%13)*.017
			mesh.set_instance_color(slot,Color(brightness,brightness,brightness,1))
			mesh.set_instance_custom_data(slot,Color(float(slot%7)/7.0,float((slot*7)%19)/19.0,1.0 if j==SHOALS.size()-1 else 0,1))
		var school := MultiMeshInstance3D.new()
		school.name = "LakeSchool%d" % schools.size()
		school.position = Vector3(center.x,height,center.y)
		school.multimesh = mesh
		school.custom_aabb = AABB(Vector3(-orbit.x-2,-1.4,-orbit.y-2),Vector3((orbit.x+2)*2,2.8,(orbit.y+2)*2))
		school.material_override = material
		school.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
		school.hide()
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
	var eye := Vector2(camera.global_position.x,camera.global_position.z)
	for j in schools.size():
		var school := schools[j]
		var config: Array = SHOALS[j]
		var center: Vector2 = config[0]
		var orbit: Vector2 = config[1]
		school.visible = eye.distance_squared_to(center)<88.0*88.0 and (j<SHOALS.size()-1 or garden_event)
		if not school.visible:
			continue
		for i in school.multimesh.instance_count:
			var a := clock*(.24+j*.035)+j*2.9+i*.184
			var ring := orbit+Vector2(.37*float(i%5)-.64,.36*float(i%4)-.48)
			var p := Vector2.from_angle(a)*ring
			var bob := sin(i*1.26+clock*.98)*.38+cos(a*2.0)*.17
			var heading := Vector2(-sin(a)*ring.x,cos(a)*ring.y)
			var scale: float = config[4]*(.82+float(i%5)*.09)
			var basis := Basis(Vector3.UP,-heading.angle()).scaled(Vector3.ONE*scale)
			school.multimesh.set_instance_transform(i,Transform3D(basis,Vector3(p.x,bob,p.y)))

func contains(p: Vector3) -> bool:
	return field.lake_ratio(Vector2(p.x,p.z))<1.0 and p.y < FIELD.WATER-.29

func lowest_swim_height(at: Vector2) -> float:
	var influence := field.trench_influence(at)
	return lerpf(FIELD.WATER-65.0,TRENCH_FLOOR_Y,influence) if influence>0.0 else -INF

func at_dive_limit(p: Vector3) -> bool:
	return p.y <= lowest_swim_height(Vector2(p.x,p.z)) + .20

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
	var start := Vector2(player.position.x,player.position.z)
	var next := start+Vector2(player.velocity.x,player.velocity.z)*delta
	var floor_before := lowest_swim_height(start)
	var next_floor := lowest_swim_height(next)
	var start_y := player.position.y
	var needed := (next_floor-start_y)/delta
	# A swimmer arriving below the lip from the open basin must ascend before crossing.
	if needed>3.2 and next_floor>floor_before+.001:
		player.velocity.x = 0.0
		player.velocity.z = 0.0
	player.velocity.y = maxf(player.velocity.y,minf(needed,3.2))
	player.move_and_slide()
	if start_y>=floor_before-.001:
		var actual_floor := lowest_swim_height(Vector2(player.position.x,player.position.z))
		var correction := actual_floor-player.position.y
		if correction>.001:
			player.move_and_collide(Vector3.UP*correction)
			player.velocity.y = maxf(0.0,player.velocity.y)

func update_view(camera: Camera3D) -> void:
	var below := contains(camera.global_position)
	underside.visible = below
	pavilion.shafts.visible = below
	for trench in trenches:
		trench.current.visible = below
	if fog_camera != camera:
		if is_instance_valid(fog_camera):
			fog_camera.environment = null
		fog_camera = camera
		underwater = false
		dream.set_underwater(below)
	if below == underwater:
		return
	underwater = below
	dream.set_underwater(below)
	if below:
		var base := camera.get_world_3d().environment
		underwater_environment = base.duplicate() as Environment
		underwater_environment.background_mode = Environment.BG_COLOR
		underwater_environment.background_color = Color("42B8D1")
		underwater_environment.fog_enabled = true
		underwater_environment.fog_mode = Environment.FOG_MODE_EXPONENTIAL
		underwater_environment.fog_sky_affect = 0.0
		underwater_environment.fog_light_color = Color("42B8D1")
		underwater_environment.fog_density = .011
		underwater_environment.ambient_light_source = Environment.AMBIENT_SOURCE_COLOR
		underwater_environment.ambient_light_color = Color("C7F0F1")
		underwater_environment.ambient_light_energy *= .80
		camera.environment = underwater_environment
	else:
		camera.environment = null


func update_weather(weather: Node) -> void:
	var hours: float = weather.hours
	var daylight := smoothstep(0.0,.35,sin((hours-6.0)*TAU/24.0))
	var rain: float = weather.weather_value.y
	garden_event = hours>=16.5 and hours<18.5 and weather.weather_value.x<.28 and rain<.13
	for material in [water_material,outer_water]:
		material.set_shader_parameter("wind_strength",float(weather.weather_value.z)*.75)
		material.set_shader_parameter("rain",rain)
		material.set_shader_parameter("sky_horizon",Color("25404F").lerp(Color("9DB8B5"),daylight))
		material.set_shader_parameter("sky_zenith",Color("13293E").lerp(Color("4C839C"),daylight))
	if underwater and is_instance_valid(fog_camera):
		dream.update_light(daylight,rain,garden_event)
		(pavilion.shafts.material_override as ShaderMaterial).set_shader_parameter("strength",daylight*(1.3-rain*.71))
		var below := FIELD.WATER-fog_camera.global_position.y
		var middle := smoothstep(1.0,10.0,below)
		var basin := smoothstep(11.0,30.0,below)
		underwater_environment.fog_density = lerpf(.009,.015,middle)+basin*.009+rain*.003
		var scatter := Color("8DE3E8").lerp(Color("42B8D1"),middle).lerp(Color("1E6F95"),basin)
		underwater_environment.fog_light_color = Color("144D68").lerp(scatter,lerpf(.38,1.0,daylight))
		underwater_environment.background_color = underwater_environment.fog_light_color
		(underside.material_override as ShaderMaterial).set_shader_parameter("horizon_tint",underwater_environment.fog_light_color)
		underwater_environment.ambient_light_energy = lerpf(.84,.64,middle)*(1.0-basin*.32)*lerpf(.55,1.0,daylight)
