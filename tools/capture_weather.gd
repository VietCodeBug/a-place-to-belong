extends SceneTree
var folder:="/tmp/v09-weather"
func _initialize() -> void: call_deferred("capture")
func capture() -> void:
	for arg in OS.get_cmdline_user_args():
		if arg.begins_with("--output="): folder=arg.trim_prefix("--output=")
	DirAccess.make_dir_recursive_absolute(folder)
	var hub=load("res://scenes/world/forest_hub.tscn").instantiate();root.add_child(hub)
	for i in range(8): await process_frame
	var weather=hub.get_node("ForestWeather");weather.paused=true
	hub.player.blocked=true
	var camera: Camera3D=root.get_camera_3d();camera.set_process(false)
	var gameplay: Transform3D=camera.transform
	for item in [["day",12.,"partly_cloudy"],["sunset",17.5,"partly_cloudy"],["night",22.,"clear"],["overcast",12.,"overcast"],["light-rain",15.,"light_rain"],["heavy-rain",15.,"heavy_rain"]]:
		weather.set_time(item[1]);weather.set_weather(item[2],true);weather.update_environment(0.)
		camera.transform=gameplay;hub.ui.show()
		await save(item[0]+"-gameplay.png")
		hub.ui.hide()
		camera.position=Vector3(15,2.1,-4);camera.fov=58;camera.look_at(Vector3(-7,6.5,5))
		await save(item[0]+"-sky.png")
		camera.fov=42
	print("WEATHER CAPTURES COMPLETE")
	hub.queue_free();await process_frame;quit()
func save(name: String) -> void:
	for i in range(6): await process_frame
	await RenderingServer.frame_post_draw
	root.get_texture().get_image().save_png(folder.path_join(name))
