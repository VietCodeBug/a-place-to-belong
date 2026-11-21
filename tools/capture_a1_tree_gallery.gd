extends SceneTree
const BOTANY = preload("res://scripts/world/a1_botany.gd")
const S = preload("res://scripts/world/shapes.gd")
const OUT := "res://docs/environment/review-village-a-v3/"
var world: Node3D
var camera: Camera3D
var trees: Array[Node3D] = []

func _initialize() -> void:
	call_deferred("run")

func grab(name: String, eye: Vector3, target: Vector3, size: float) -> void:
	camera.position = eye
	camera.look_at(target)
	camera.size = size
	await process_frame
	await RenderingServer.frame_post_draw
	root.get_texture().get_image().save_png(OUT+name+".png")

func run() -> void:
	root.content_scale_size = Vector2i.ZERO
	root.size = Vector2i(1920,1080)
	root.msaa_3d = Viewport.MSAA_2X
	world = Node3D.new()
	root.add_child(world)
	var environment := WorldEnvironment.new()
	environment.environment = Environment.new()
	environment.environment.background_mode = Environment.BG_COLOR
	environment.environment.background_color = Color("7D9DA8")
	environment.environment.ambient_light_source = Environment.AMBIENT_SOURCE_COLOR
	environment.environment.ambient_light_color = Color("B1C4CA")
	environment.environment.ambient_light_energy = .69
	world.add_child(environment)
	var sun := DirectionalLight3D.new()
	world.add_child(sun)
	sun.rotation_degrees = Vector3(-45,-34,0)
	sun.light_energy = .9
	sun.shadow_enabled = true
	S.box(world,Vector3(0,-.25,0),Vector3(140,.4,90),"5A7150")
	var ids := BOTANY.codes()
	for i in ids.size():
		var row := floori(float(i)/5)
		var location := Vector3(float(i%5-2)*8.5,0,-row*8.5+12)
		var height: float = [7.2,8.2,9.0,10.6][row] + sin(i*2.2)
		trees.append(BOTANY.place(world,ids[i],location,height,.7*i))
	camera = Camera3D.new()
	camera.projection = Camera3D.PROJECTION_ORTHOGONAL
	world.add_child(camera)
	camera.make_current()
	await grab("cay-gallery",Vector3(24,38,54),Vector3(0,3,-1),43)
	await grab("cay-can",Vector3(-8,6.4,22),Vector3(-7,4.5,12),6.5)
	await grab("cay-ben",Vector3(29,7,8),Vector3(1,5,8),19)
	for tree in trees:
		BOTANY.apply_season(tree,0)
	await grab("cay-thu",Vector3(24,38,54),Vector3(0,3,-1),43)
	for tree in trees:
		BOTANY.apply_season(tree,3)
	await grab("cay-dong",Vector3(24,38,54),Vector3(0,3,-1),43)
	for tree in trees:
		tree.hide()
	var lods: Array[Node3D] = []
	lods.append(BOTANY.place_tree(world,"BirchTree_2",Vector3(-4,0,0),9,0))
	lods.append(BOTANY.place_tree(world,"MapleTree_3",Vector3(4,0,0),9,.4))
	BOTANY.update_lod(lods,Vector3(0,5,40))
	await grab("cay-lod-gan",Vector3(0,6,40),Vector3(0,4,0),13)
	BOTANY.update_lod(lods,Vector3(0,5,90))
	await grab("cay-lod-xa",Vector3(0,6,90),Vector3(0,4,0),13)
	quit()
