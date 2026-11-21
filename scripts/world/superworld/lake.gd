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


func setup(source: FIELD) -> void:
	field = source
	make_surface()
	make_pier()
	make_shelf()
	make_shore()
	make_arch()
	make_fish()

func make_surface() -> void:
	var surface := SurfaceTool.new()
	surface.begin(Mesh.PRIMITIVE_TRIANGLES)
	var center := Vector3(FIELD.LAKE.x,FIELD.WATER,FIELD.LAKE.y)
	for i in 256:
		var a := Vector2.from_angle(i*TAU/256.0)*FIELD.RADII
		var b := Vector2.from_angle((i+1)*TAU/256.0)*FIELD.RADII
		for p in [center,center+Vector3(a.x,0,a.y),center+Vector3(b.x,0,b.y)]:
			surface.add_vertex(p)
	surface.generate_normals()
	var visual := MeshInstance3D.new()
	visual.name = "LakeSurface"
	visual.mesh = surface.commit()
	var material := ShaderMaterial.new()
	material.shader = preload("res://shaders/a1_superworld_lake.gdshader")
	material.set_shader_parameter("center",FIELD.LAKE)
	material.set_shader_parameter("radii",FIELD.RADII)
	visual.material_override = material
	visual.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	add_child(visual)

func make_pier() -> void:
	# The side of the pier remains open for water entry and exit.
	var z := FIELD.SHORE.y+6.0
	var start := FIELD.SHORE.x-6.0
	for i in range(7):
		var x := start+i*2.25
		var y := lerpf(field.height(Vector2(start,z))+.04,FIELD.WATER+.54,minf(i/4.0,1.0))
		SHAPES.box(self,Vector3(x,y-.11,z),Vector3(2.27,.22,3.0),"927754",true)
		if i%2==0:
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
	for i in 23:
		var spread := 18.0 if i<13 else 32.0
		var p := FIELD.SHELF+Vector2(rng.randf_range(-.6,1.0),rng.randf_range(-1.0,1.0))*spread
		var depth_m := FIELD.WATER-field.height(p)
		if depth_m < .9:
			continue
		var shape := SphereMesh.new()
		shape.radial_segments = 7
		shape.rings = 4
		var rock := SHAPES.mesh(self,shape,Vector3(p.x,FIELD.WATER-depth_m+.10,p.y),"647E70" if i%3==0 else "8B8C72")
		rock.scale = Vector3(rng.randf_range(1.7,4.3),rng.randf_range(1.0,2.6),rng.randf_range(1.9,4.6))
		rock.rotation.y = rng.randf()*TAU
		if i%3!=0:
			continue
		for strand in range(4):
			var off := Vector2(rng.randf_range(-2.3,2.3),rng.randf_range(-2.3,2.3))
			var base := Vector3(p.x+off.x,field.height(p+off),p.y+off.y)
			SHAPES.beam(self,base,base+Vector3(.34,rng.randf_range(.48,1.68),.16),.075,"5E8B66")

func make_shore() -> void:
	var rng := RandomNumberGenerator.new()
	rng.seed = 88023
	var locations: Array[Vector3] = []
	for i in range(920):
		var p := FIELD.SHORE + Vector2(rng.randf_range(-25,10),rng.randf_range(-40,44))
		var y := field.height(p)
		if y > FIELD.WATER+.70 and field.trail_distance(p) > 1.85 and absf(p.y+449)>4.2:
			locations.append(Vector3(p.x,y,p.y))
	shore_grass = BOTANY.grass_batch(self,locations,845,75.0,.29,1.8)
	for entry in [[-7,-21,2.5],[-12,-17,1.3],[-10,19,2.1],[2,26,1.2],[-5,-37,1.6],[7,-31,2.4]]:
		var p := FIELD.SHORE+Vector2(entry[0],entry[1])
		BOTANY.place_stone(self,Vector3(p.x,field.height(p),p.y),entry[2],float(entry[1]),entry[2]>2.0)
	for entry in [[-17,-26,"NormalTree_3"],[-18,17,"BirchTree_2"],[-18,-6,"NormalTree_1"],[-23,33,"PineTree_2"]]:
		var p := FIELD.SHORE+Vector2(entry[0],entry[1])
		var tree := BOTANY.place(self,entry[2],Vector3(p.x,field.height(p),p.y),8.5+float(absi(entry[1])%5),entry[1])
		shore_trees.append(tree)

func set_season(index: int) -> void:
	shore_grass.visible = index != 3
	for tree in shore_trees:
		BOTANY.apply_season(tree,index)

func make_arch() -> void:
	var stone := SurfaceTool.new()
	stone.begin(Mesh.PRIMITIVE_TRIANGLES)
	var floor_y := field.height(FIELD.ARCH)-.18
	var across := [-2.15,2.15]
	for segment in 12:
		var a := float(segment)*PI/12.0
		var b := float(segment+1)*PI/12.0
		var rings: Array[PackedVector3Array] = []
		for x in across:
			var section := PackedVector3Array()
			for r in [Vector2(3.95,3.78),Vector2(2.52,2.45)]:
				for angle in [a,b]:
					var fold := .12*sin(angle*19.0+x)
					section.append(Vector3(FIELD.ARCH.x+x,floor_y+sin(angle)*(r.y+fold),
						FIELD.ARCH.y+cos(angle)*(r.x+fold)))
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
	var material := StandardMaterial3D.new()
	material.albedo_color=Color("496A62")
	material.roughness=.84
	material.cull_mode=BaseMaterial3D.CULL_DISABLED
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
	material.roughness = .53
	material.cull_mode = BaseMaterial3D.CULL_DISABLED
	for i in 2:
		var fish := MultiMesh.new()
		fish.transform_format = MultiMesh.TRANSFORM_3D
		fish.mesh = mesh
		fish.instance_count = 18
		var school := MultiMeshInstance3D.new()
		school.multimesh = fish
		school.material_override = material
		school.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
		add_child(school)
		schools.append(school)

func _process(delta: float) -> void:
	clock += delta
	var camera := get_viewport().get_camera_3d()
	if camera == null:
		return
	for j in schools.size():
		var school := schools[j]
		var center := FIELD.SHELF+Vector2(j*30.0+7.0,(2*j-1)*14.0)
		var eye := Vector2(camera.global_position.x,camera.global_position.z)
		school.visible = eye.distance_squared_to(center)<100.0*100.0
		if not school.visible:
			continue
		for i in school.multimesh.instance_count:
			var a := clock*.25+j*2.9+i*.14
			var p := center+Vector2(cos(a),sin(a))*Vector2(7.0+(i%5)*.45,4.7+(i%4)*.7)
			var y := lerpf(field.height(p),FIELD.WATER,.51+sin(i*1.2+clock*.66)*.18)
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
		underwater_environment.background_color = Color("1B5773")
		underwater_environment.fog_enabled = true
		underwater_environment.fog_light_color = Color("286980")
		underwater_environment.fog_density = .058
		underwater_environment.ambient_light_energy *= .68
		camera.environment = underwater_environment
	else:
		camera.environment = null
