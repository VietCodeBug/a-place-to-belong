extends SceneTree
## Captures honest in-engine Godot runtime PNGs for V10 review:
## 1) Exact camera-matched views to V09 (capture_ground.gd poses)
## 2) Full V10 suite: Scenic Title Menu, Default Player Camera, Café Exterior, Path Close-up,
##    Forest Floor & Woodland, Wide Environment, Morning, Sunset, Night, Rain, Letter UI, Pause Menu.

var folder := "C:/Users/phamv/.gemini/antigravity/brain/5103b2d3-009b-447e-94f7-1d5361b8e009/scratch/v10-captures"

func _initialize() -> void:
	call_deferred("capture")

func capture() -> void:
	if DisplayServer.get_name() == "headless":
		push_error("A real rendering display is required for V10 visual captures.")
		quit(1)
		return
	for arg in OS.get_cmdline_user_args():
		if arg.begins_with("--output="):
			folder = arg.trim_prefix("--output=")
	DirAccess.make_dir_recursive_absolute(folder)
	DirAccess.make_dir_recursive_absolute(folder.path_join("matched-v09"))

	var hub = load("res://scenes/world/forest_hub.tscn").instantiate()
	root.add_child(hub)
	for i in range(18):
		await process_frame

	var weather = hub.get_node("ForestWeather")
	weather.paused = true
	weather.set_time(16.5)
	weather.set_weather("partly_cloudy", true)
	weather.update_environment(0.0)
	hub.player.blocked = true

	var camera: Camera3D = root.get_camera_3d()

	# 0. Scenic Main Menu (new V10 Title Screen)
	hub.ui.enter_title_menu(true)
	await save_frame("00-scenic-title-menu.png")

	# 1. Actual Default Starting Gameplay Camera + Compact Cozy HUD (First 30 seconds)
	hub.ui.exit_title_menu(true)
	camera.set_process(false)
	camera.aim = camera.focus_position()
	camera.position = camera.desired_position()
	camera.fov = 43.0
	camera.look_at(camera.aim)
	var default_gameplay_transform: Transform3D = camera.transform
	var default_fov: float = camera.fov
	await save_frame("01-default-player-camera.png")

	# 2. Exact V09-matched camera poses (from tools/capture_ground.gd) for 1:1 before/after review
	hub.ui.show()
	var v09_focus: Vector3 = hub.player.position + Vector3(-2.0, 2.3, -5.0)
	var v09_eye: Vector3 = hub.player.position + Vector3.UP * 1.5 + Vector3(0.62, 0.54, 0.57).normalized() * 26.0
	pose(camera, v09_eye, v09_focus, 42.0)
	await save_frame("matched-v09/01-default-gameplay.png")

	hub.ui.hide()
	pose(camera, Vector3(14, 2.8, 17), Vector3(9, 0.25, 12), 50.0)
	await save_frame("matched-v09/02-ground-grass.png")
	pose(camera, Vector3(-8, 3.5, 19), Vector3(0.2, 0.3, 10), 47.0)
	await save_frame("matched-v09/03-path-transitions.png")
	pose(camera, Vector3(-8.5, 4.0, 7.5), Vector3(-12.4, 0.2, 3.5), 52.0)
	await save_frame("matched-v09/04-forest-floor.png")
	pose(camera, Vector3(27, 26, 34), Vector3(0, 2, 0), 46.0)
	await save_frame("matched-v09/05-map01-composition.png")

	# 3. V10 Composition & Environment Showcase Views
	pose(camera, Vector3(12.5, 4.6, 15.8), Vector3(-1.2, 2.8, -1.5), 42.0)
	await save_frame("02-cafe-exterior.png")

	pose(camera, Vector3(-5.2, 2.45, 15.4), Vector3(2.2, 1.05, 5.2), 46.0)
	await save_frame("03-path-closeup.png")

	pose(camera, Vector3(-3.8, 2.8, 13.6), Vector3(-10.2, 1.8, 5.6), 48.0)
	await save_frame("04-forest-floor-woodland.png")

	pose(camera, Vector3(25.5, 18.5, 32.0), Vector3(-1.0, 2.6, -2.0), 45.0)
	await save_frame("05-wide-environment.png")

	# 4. Time-of-Day & Weather Views from Actual Default Player Camera (with live HUD)
	hub.ui.show()
	camera.transform = default_gameplay_transform
	camera.fov = default_fov

	weather.set_time(8.2)
	weather.set_weather("partly_cloudy", true)
	await save_frame("06-morning.png")

	weather.set_time(17.35)
	weather.set_weather("partly_cloudy", true)
	await save_frame("07-sunset.png")

	weather.set_time(21.75)
	weather.set_weather("clear", true)
	await save_frame("08-night.png")

	weather.set_time(15.2)
	weather.set_weather("heavy_rain", true)
	for r_i in range(18):
		await process_frame
	await save_frame("09-rain.png")

	# Sky & stylized cloud close-up check
	weather.set_time(11.5)
	weather.set_weather("partly_cloudy", true)
	hub.ui.hide()
	pose(camera, Vector3(15.0, 2.1, -4.0), Vector3(-7.0, 6.5, 5.0), 58.0)
	await save_frame("12-stylized-sky-clouds.png")

	# 5. UI Interaction & Pause Menu Captures
	weather.set_time(16.5)
	weather.set_weather("partly_cloudy", true)
	hub.ui.show()
	camera.transform = default_gameplay_transform
	camera.fov = default_fov
	hub.mailbox.interact()
	await save_frame("10-ui-mailbox-letter.png")
	hub.ui.close()

	hub.ui.set_pause_menu(true)
	await save_frame("11-ui-pause-atmosphere-menu.png")
	hub.ui.set_pause_menu(false)

	print("V10 CAPTURES COMPLETE -> ", folder)
	hub.queue_free()
	await process_frame
	quit(0)

func pose(camera: Camera3D, eye: Vector3, focus: Vector3, lens: float) -> void:
	camera.position = eye
	camera.fov = lens
	camera.look_at(focus)

func save_frame(file_name: String) -> void:
	for i in range(6):
		await process_frame
	await RenderingServer.frame_post_draw
	var err := root.get_texture().get_image().save_png(folder.path_join(file_name))
	if err != OK:
		push_error("PNG save failed: " + file_name)
		quit(1)
