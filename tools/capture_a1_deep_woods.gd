extends SceneTree
const L = preload("res://scripts/world/landscape.gd")
const PLAN = preload("res://scripts/world/village_a_layout.gd")
const OUT := "user://a1-forest-journey/"
var camera: Camera3D
var valley: Node3D

func _initialize() -> void:
	call_deferred("run")

func mark(x: float,z: float,h: float) -> Vector3:
	return Vector3(x,L.height_at(x,z)+h,z)

func shot(id: String, eye: Vector3, focus: Vector3) -> void:
	camera.position = eye
	camera.look_at(focus)
	valley.foliage_tick = 0.0
	await process_frame
	await process_frame
	await RenderingServer.frame_post_draw
	var result := root.get_texture().get_image().save_png(OUT+id+".png")
	assert(result==OK, "Failed screenshot "+id)

func run() -> void:
	DirAccess.make_dir_recursive_absolute(OUT)
	root.content_scale_size = Vector2i.ZERO
	root.msaa_3d = Viewport.MSAA_2X
	root.size = Vector2i(1920,1080)
	var hub := preload("res://scenes/world/forest_hub.tscn").instantiate()
	root.add_child(hub)
	hub.ui.hide()
	hub.player.hide()
	var weather := hub.get_node("ForestWeather")
	weather.set_time(15.15)
	weather.set_weather("clear",true)
	weather.set_process(false)
	camera = Camera3D.new()
	camera.fov = 63
	hub.add_child(camera)
	camera.make_current()
	valley = hub.get_node("A1RiverValley")
	valley.set_season_palette(1)
	var home := PLAN.HOUSE_A
	var start: Vector2 = PLAN.HOUSE_APPROACH[0]
	await RenderingServer.frame_post_draw
	await shot("nha-a",mark(home.x-9.6,home.y+1.3,1.65),mark(home.x,home.y,2.24))
	await shot("hoa-ven-hien",mark(start.x-2.8,start.y-.1,1.25),mark(home.x-1.5,home.y-1.95,.85))
	await shot("cao-ven-nha",mark(home.x-8.9,home.y-1.15,1.18),mark(home.x-6.0,home.y-3.4,.31))
	await shot("duong-roi-nha-a",mark(9.45,-336.55,1.65),mark(-.8,-322.5,1.42))
	await shot("doi-rung",mark(3.8,-274.4,1.66),mark(13.4,-260,1.80))
	await shot("huou-trong-rung",mark(11.7,-245.3,1.54),mark(8.1,-243.7,.75))
	await shot("bia-rung",mark(L.valley_path(85),85,1.65),mark(5.1,111,2.2))
	await shot("vao-lang",mark(L.valley_path(101),101,1.65),mark(5.2,121,2.3))
	valley.set_season_palette(3)
	await shot("nha-a-dong",mark(home.x-9.6,home.y+1.3,1.65),mark(home.x,home.y,2.24))
	print(ProjectSettings.globalize_path(OUT))
	hub.queue_free()
	await process_frame
	quit()
