extends SceneTree

const LAND = preload("res://scripts/world/landscape.gd")
const OUT = "res://docs/environment/review-a1-polish/"
var hub: Node3D
var camera: Camera3D

func _initialize() -> void:
	call_deferred("run")

func ground(x: float, z: float, height: float) -> Vector3:
	return Vector3(x, LAND.height_at(x,z)+height, z)

func shot(name: String, eye: Vector3, focus: Vector3) -> void:
	camera.position = eye
	camera.look_at(focus)
	await process_frame
	await RenderingServer.frame_post_draw
	var error := root.get_texture().get_image().save_png(OUT+name+".png")
	if error != OK:
		push_error("Screenshot write failed: "+name)

func run() -> void:
	root.content_scale_size = Vector2i.ZERO
	root.msaa_3d = Viewport.MSAA_2X
	root.size = Vector2i(1920,1080)
	hub = preload("res://scenes/world/forest_hub.tscn").instantiate()
	root.add_child(hub)
	hub.ui.hide()
	hub.player.hide()
	var weather := hub.get_node("ForestWeather")
	weather.set_time(15.15)
	weather.set_weather("clear",true)
	weather.set_process(false)
	camera = Camera3D.new()
	hub.add_child(camera)
	camera.fov = 61.0
	camera.make_current()
	var valley := hub.get_node("A1RiverValley")
	await shot("nha-a-trong-rung",ground(6.3,15.9,1.86),ground(13,13.4,2.15))
	await shot("san-nha-a",ground(9.4,9.7,1.75),ground(13.1,13.7,1.98))
	camera.fov = 66
	await shot("toan-canh",Vector3(32,31,92),Vector3(0,10,134))
	await shot("nha-tho",ground(3.75,122.45,1.95),ground(-3.35,133.2,4.55))
	await shot("mat-duong",ground(4.1,101.4,1.22),ground(4.3,104.75,.09))
	await shot("da-va-co",ground(-9.4,96.1,1.31),ground(-9.7,98.4,.67))
	for specification in [[1,"xuan"],[2,"he"],[0,"thu"],[3,"dong"]]:
		valley.set_season_palette(specification[0])
		await shot("mua-"+specification[1],ground(-4.3,116.7,1.68),ground(-5.1,126.4,1.52))
	valley.set_season_palette(1)
	weather.set_weather("heavy_rain",true)
	await shot("mat-duong-sau-mua",ground(4.10,101.4,1.28),ground(4.05,104.65,.12))
	hub.queue_free()
	await process_frame
	quit()
