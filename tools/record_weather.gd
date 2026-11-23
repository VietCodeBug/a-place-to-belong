extends SceneTree
## Deterministic actual Godot frames, encode externally at 12 fps. No image generation.
var folder:="/tmp/v09-record"
var clip:="wind"
func _initialize() -> void: call_deferred("record")
func record() -> void:
	for arg in OS.get_cmdline_user_args():
		if arg.begins_with("--output="): folder=arg.trim_prefix("--output=")
		if arg.begins_with("--clip="): clip=arg.trim_prefix("--clip=")
	DirAccess.make_dir_recursive_absolute(folder)
	var hub=load("res://scenes/world/forest_hub.tscn").instantiate();root.add_child(hub)
	for i in range(8): await process_frame
	var weather=hub.get_node("ForestWeather");weather.paused=true
	hub.player.blocked=true
	var camera: Camera3D=root.get_camera_3d();camera.set_process(false)
	if clip in ["grass-close","wind"]:
		hub.ui.hide();camera.position=Vector3(14,2.8,17);camera.fov=50;camera.look_at(Vector3(9,.25,12))
	if clip=="day":
		hub.ui.hide();camera.position=Vector3(15,2.1,-4);camera.fov=58;camera.look_at(Vector3(-7,6.5,5))
	weather.set_time(12. if clip=="day" else (22. if clip=="night" else 16.5))
	weather.set_weather("heavy_rain" if clip=="rain" else "partly_cloudy",true)
	weather.wind_multiplier=1.5 if clip=="wind" else 1.
	weather.update_environment(0.)
	for i in range(8): await process_frame
	var frame_count:=48 if clip=="grass-close" else 24
	for frame in range(frame_count):
		if clip=="sunset": weather.set_time(16.5+float(frame)/float(frame_count-1)*3.)
		await process_frame
		await RenderingServer.frame_post_draw
		root.get_texture().get_image().save_png(folder.path_join("%04d.png"%frame))
	var metadata={"clip":clip,"frames":frame_count,"fps":12,"renderer":"gl_compatibility","render_size":str(root.size),"grass_preset":hub.get_node("CuratedGroundCover/DenseMeadow").settings.resource_path,"camera_transform":str(camera.transform),"time_lapse":clip=="sunset","weather":weather.weather_name,"final_hours":weather.hours,"wind_multiplier":weather.wind_multiplier}
	var file:=FileAccess.open(folder.path_join("capture.json"),FileAccess.WRITE);file.store_string(JSON.stringify(metadata,"\t"));file.close()
	hub.queue_free();await process_frame;quit()
