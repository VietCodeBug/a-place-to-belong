extends SceneTree
const L = preload("res://scripts/world/landscape.gd")
const OUT := "user://a1-v4-review/"
var camera: Camera3D

func _initialize() -> void:
	call_deferred("run")

func mark(x: float,z: float,h: float) -> Vector3:
	return Vector3(x,L.height_at(x,z)+h,z)

func shot(id: String, eye: Vector3, focus: Vector3) -> void:
	camera.position = eye
	camera.look_at(focus)
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
	var valley := hub.get_node("A1RiverValley")
	valley.set_season_palette(2)
	if OS.get_cmdline_user_args().has("--flower-only"):
		await shot("10-can-hoa",mark(7.30,43.85,.75),mark(5.45,42.25,.23))
		hub.queue_free()
		await process_frame
		quit()
		return
	for view in [
		["01-nha-a",6.0,15.6,1.82,13.1,13.7,2.13],
		["02-san-nha-a",8.9,10.7,1.63,12.8,14.4,1.30],
		["03-rung-khoi-dau",2.8,20.0,1.65,-8.0,29.0,1.51],
		["04-duong-rung",L.valley_path(39),39,1.54,5.3,43.5,1.1],
		["05-bo-song",5.5,63.45,1.60,5,75,1.1],
		["06-vao-lang",L.valley_path(94),94,1.65,6.3,110,2.7],
		["07-duong-lang",5.65,127.2,1.69,-3.6,133.2,3.1],
		["08-vuon-rau",-4.3,116.65,2.30,-7.5,121.0,.96],
		["09-can-luong",-5.9,118.0,1.21,-8.35,120.3,.29],
		["10-can-hoa",7.30,43.85,.75,5.45,42.25,.23],
		["11-go-dat",-13.5,43.9,1.18,-7.6,48.4,.62],
		["12-ra-rung",L.valley_path(169),169,1.70,9.5,182,1.5],
		["13-diem-ngam",-21,50,2.3,4,85,1.5],
		["14-quan-rung",14,19,3.1,0,0,3.8],
		["15-san-thu-cong",12.0,125.35,1.52,20.7,128.3,1.92],
	]:
		await shot(view[0],mark(view[1],view[2],view[3]),mark(view[4],view[5],view[6]))
	for season in [[1,"xuan"],[2,"he"],[0,"thu"],[3,"dong"]]:
		valley.set_season_palette(season[0])
		await shot("mua-"+season[1],mark(-4.5,116.8,2.30),mark(-7.7,122.2,1.20))
	print(ProjectSettings.globalize_path(OUT))
	hub.queue_free()
	await process_frame
	quit()
