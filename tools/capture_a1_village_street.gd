extends SceneTree
## Matched, eye-height Village A review captures through the normal gameplay camera.

const HUB = preload("res://scenes/world/forest_hub.tscn")
var hub: Node3D
var stage: Node3D
var output := "/tmp/a1-village-street"

func _initialize() -> void:
	call_deferred("run")

func settle(count: int) -> void:
	for frame in count:
		await process_frame

func view(p: Vector2, toward: Vector2, aim_height := 2.2) -> void:
	RenderingServer.render_loop_enabled = false
	hub.superworld.prepare_at(p)
	hub.player.position = hub.ground(p.x,p.y,.065)
	hub.player.velocity = Vector3.ZERO
	var camera := hub.get_node("GameplayCamera") as Camera3D
	var look: Vector3 = hub.ground(toward.x,toward.y,aim_height)
	hub.eyes.aim(look-(hub.player.global_position+Vector3.UP*1.55))
	hub.eyes.place(camera,hub.player,0.0,true)
	await settle(21)
	RenderingServer.render_loop_enabled = true

func grab(file_name: String) -> void:
	for tick in 4:
		await RenderingServer.frame_post_draw
	root.get_texture().get_image().save_png(output+"/"+file_name+".png")

func run() -> void:
	TranslationServer.set_locale("vi")
	for arg in OS.get_cmdline_user_args():
		if arg.begins_with("--out="):
			output = arg.trim_prefix("--out=")
	DirAccess.make_dir_recursive_absolute(output)
	root.size = Vector2i(1280,720)
	hub = HUB.instantiate()
	hub.set_meta("story_prototype",true)
	root.add_child(hub)
	stage = hub.story_prototype
	stage.skip_intro()
	stage.enter_outdoors()
	hub.ui.notice.text = ""
	var weather: Node = stage.weather
	weather.paused = true
	weather.set_time(11.17)
	weather.set_weather("partly_cloudy",true)
	await view(Vector2(5.72,123.7),Vector2(5.6,149),2.65)
	await grab("01-san-chung")
	await view(Vector2(10.7,122.5),Vector2(19.8,132.5),2.55)
	await grab("02-loi-xuong")
	await view(Vector2(ForestLandscape.valley_path(105),105),Vector2(4.1,136.4),2.65)
	await grab("03-duong-vao")
	if not OS.get_cmdline_user_args().has("--compare-only"):
		await view(Vector2(6.47,126.05),Vector2(12.8,131.5),2.9)
		await grab("06-quay-mai-vai")
		weather.set_weather("light_rain",true)
		weather.set_time(15.60)
		await view(Vector2(5.72,123.7),Vector2(5.6,149),2.65)
		await grab("04-san-chung-mua")
		var key := InputEventKey.new()
		key.physical_keycode = KEY_M
		key.keycode = KEY_M
		key.pressed = true
		hub.ui._unhandled_input(key)
		await settle(4)
		await grab("05-ban-do-m")
		assert(hub.ui.valley_map.visible)
		hub.ui._unhandled_input(key)
		assert(not hub.ui.valley_map.visible and not hub.player.blocked)
		var valley := hub.get_node("A1RiverValley")
		var props := valley.get_node("VillageA/StreetFurnishings")
		for batch in props.find_children("*","MultiMeshInstance3D",false,false):
			print("VILLAGE_FURNISHINGS ",batch.name," instances=",batch.multimesh.instance_count)
		valley.set_season_palette(3)
		weather.set_weather("partly_cloudy",true)
		weather.set_time(11.17)
		await view(Vector2(5.72,123.7),Vector2(5.6,149),2.65)
		await grab("07-san-chung-mua-dong")
	print("VILLAGE_STREET_CAPTURE PASS ",output)
	hub.queue_free()
	await process_frame
	quit()
