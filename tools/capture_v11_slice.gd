extends SceneTree
func _initialize():call_deferred("run")
func run():
	DirAccess.make_dir_recursive_absolute("/tmp/v11-slice")
	var hub=load("res://scenes/world/forest_hub.tscn").instantiate();root.add_child(hub)
	for i in range(8):await process_frame
	var w=hub.get_node("ForestWeather");w.paused=true
	hub.ui.enter_title_menu(true);await save("menu.png")
	hub.ui.exit_title_menu(true);hub.ui.set_pause_menu(true);await save("weather-atlas.png");hub.ui.set_pause_menu(false)
	var cam: Camera3D=root.get_camera_3d();cam.set_process(false)
	cam.aim=cam.focus_position();cam.position=cam.desired_position();cam.look_at(cam.aim);await save("gameplay.png")
	w.set_weather("heavy_rain",true);w.update_environment(0.);await save("downpour.png")
	w.set_weather("partly_cloudy",true);w.update_environment(0.)
	hub.ui.hide();cam.position=Vector3(-8,2.,12);cam.fov=45;cam.look_at(Vector3(-11,.35,8));await save("habitat.png")
	cam.position=Vector3(13,6.9,16);cam.fov=48;cam.look_at(Vector3(-.4,7.,-18));await save("mountain-vista.png")
	w.set_time(22.);w.set_weather("clear",true);w.update_environment(0.)
	cam.position=Vector3(8,1.6,11);cam.look_at(Vector3(6,1.2,7.5));await save("night-habitat.png")
	hub.queue_free();await process_frame;quit()
func save(name: String):
	for i in range(4):await process_frame
	await RenderingServer.frame_post_draw
	root.get_texture().get_image().save_png("/tmp/v11-slice/"+name)
