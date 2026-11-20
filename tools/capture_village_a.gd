extends SceneTree
## Render the review gallery with this project's graphical Godot renderer.
const PLAN = preload("res://scripts/world/village_a_layout.gd")
const L = preload("res://scripts/world/landscape.gd")
const OUT := "res://docs/environment/review-village-a/"
var hub: Node3D
var camera: Camera3D

func _initialize() -> void:
	call_deferred("run")

func grab(name: String) -> void:
	await process_frame
	await RenderingServer.frame_post_draw
	root.get_texture().get_image().save_png(OUT+name+".png")

func shot(origin: Vector3, target: Vector3) -> void:
	camera.position = origin
	camera.look_at(target)

func ground(x: float,z: float,height: float) -> Vector3:
	return Vector3(x,L.height_at(x,z)+height,z)

func annotate_plan() -> CanvasLayer:
	var labels := CanvasLayer.new()
	hub.add_child(labels)
	var markers: Array = []
	for lot in PLAN.BUILDINGS:
		markers.append([Vector2(lot[2],lot[3]), lot[0]])
	markers.append_array([[PLAN.GARDEN,"Vườn chung"],[PLAN.COMMON,"Sân chung"],[PLAN.CRAFT,"Sân thủ công"],[PLAN.EXIT,"Ra rừng"]])
	for marker in markers:
		var spot: Vector2 = marker[0]
		var label := Label.new()
		label.text = marker[1]
		label.add_theme_font_size_override("font_size",15)
		label.add_theme_color_override("font_outline_color",Color("242C26"))
		label.add_theme_constant_override("outline_size",6)
		var label_offset := Vector2(-14,14) if spot == PLAN.CRAFT else Vector2(-14,-14)
		label.position = camera.unproject_position(ground(spot.x,spot.y,1.0)) + label_offset
		labels.add_child(label)
	return labels

func run() -> void:
	root.content_scale_size = Vector2i.ZERO
	root.size = Vector2i(1152,648)
	hub = load("res://scenes/world/forest_hub.tscn").instantiate()
	root.add_child(hub)
	hub.ui.hide()
	hub.player.hide()
	var weather := hub.get_node("ForestWeather")
	weather.set_time(15.15)
	weather.set_weather("clear",true)
	weather.set_process(false)
	camera=Camera3D.new()
	hub.add_child(camera)
	camera.make_current()
	camera.fov=66
	var only_plan := OS.get_cmdline_user_args().has("--plan-only")
	var valley := hub.get_node("A1RiverValley")
	shot(Vector3(32,31,92),Vector3(0,10,134))
	if not only_plan:
		await grab("toan-canh")
	camera.projection=Camera3D.PROJECTION_ORTHOGONAL
	camera.size=86
	camera.position=Vector3(4,92,140)
	camera.look_at(Vector3(4,5,140),Vector3.BACK)
	var labels := annotate_plan()
	await grab("quy-hoach")
	labels.hide()
	labels.queue_free()
	if only_plan:
		hub.queue_free()
		await process_frame
		quit()
		return
	camera.projection=Camera3D.PROJECTION_PERSPECTIVE
	shot(ground(L.valley_path(99),99,1.68),ground(5.2,121,2.3))
	await grab("vao-lang")
	hub.player.position = ground(L.valley_path(102),102,.12)
	hub.player.show()
	var follow: Camera3D = hub.get_node("GameplayCamera")
	follow.set_scenic_mode(false,true)
	follow.make_current()
	await grab("camera-nguoi-choi")
	hub.player.hide()
	camera.make_current()
	shot(ground(-4.3,116.7,1.68),ground(-5.1,126.4,1.52))
	await grab("duong-va-vuon")
	for season in [[1,"xuan"],[2,"he"],[0,"thu"],[3,"dong"]]:
		valley.set_season_palette(season[0])
		await grab("mua-"+season[1])
	valley.set_season_palette(0)
	shot(ground(9.5,14.2,1.68),ground(L.valley_path(100),100,3.2))
	await grab("tu-nha-a")
	shot(ground(L.valley_path(91),91,1.68),ground(5.2,121,2.3))
	await grab("mai-nha-qua-tan-cay")
	hub.queue_free()
	await process_frame
	quit()
