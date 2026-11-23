extends SceneTree
var folder:="/tmp/circular-ui"
func _initialize():call_deferred("run")
func run():
	for arg in OS.get_cmdline_user_args():
		if arg.begins_with("--output="):folder=arg.trim_prefix("--output=")
	DirAccess.make_dir_recursive_absolute(folder)
	var hub=load("res://scenes/world/forest_hub.tscn").instantiate();root.add_child(hub)
	for i in range(4):await process_frame
	var weather=hub.get_node("ForestWeather");weather.paused=true
	var cam=hub.get_node("GameplayCamera");hub.ui.exit_title_menu(true);cam.set_process(false);cam.aim=cam.focus_position();cam.position=cam.desired_position();cam.look_at(cam.aim)
	await save("01-day-hud.png")
	weather.set_time(22.);weather.set_weather("clear",true);await save("02-night-hud.png")
	weather.set_time(16.5);weather.set_weather("partly_cloudy",true)
	hub.mailbox.interact();await save("03-envelope.png")
	if hub.ui.envelope_tween!=null:hub.ui.envelope_tween.custom_step(2.)
	if hub.ui.letter_tween!=null:hub.ui.letter_tween.custom_step(2.)
	await save("04-letter-wax-seal.png")
	hub.ui.close();await save("05-closing-envelope.png")
	if hub.ui.envelope_tween!=null:hub.ui.envelope_tween.custom_step(2.)
	hub.ui.enter_title_menu(true);await save("06-title.png")
	hub.ui.exit_title_menu(true);hub.ui.set_pause_menu(true);await save("07-pause.png")
	hub.queue_free();await process_frame;quit()
func save(name: String):
	await process_frame;await RenderingServer.frame_post_draw
	root.get_texture().get_image().save_png(folder.path_join(name))
