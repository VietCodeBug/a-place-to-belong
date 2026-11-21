extends SceneTree
const L = preload("res://scripts/world/landscape.gd")
const OUT := "user://a1-deep-woods/"
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
	valley.set_season_palette(2)
	await shot("nha-a",mark(9.4,-84.6,1.62),mark(16,-84,2.2))
	await shot("hoa-ven-hien",mark(11.1,-84.65,.88),mark(12.4,-85.65,.33))
	await shot("roi-nha-a",mark(11.9,-83.1,1.65),mark(7.0,-71.8,1.9))
	await shot("giua-rung",mark(15.4,-52.1,1.64),mark(14.4,-38.5,1.7))
	await shot("bia-rung",mark(L.valley_path(85),85,1.65),mark(5.1,111,2.2))
	await shot("vao-lang",mark(L.valley_path(101),101,1.65),mark(5.2,121,2.3))
	print(ProjectSettings.globalize_path(OUT))
	hub.queue_free()
	await process_frame
	quit()
