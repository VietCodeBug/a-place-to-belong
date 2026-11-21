extends SceneTree
func _initialize() -> void:
	call_deferred("run")
func run() -> void:
	root.content_scale_size=Vector2i.ZERO
	root.size=Vector2i(1152,648)
	var hub := load("res://scenes/world/forest_hub.tscn").instantiate() as Node3D
	root.add_child(hub)
	hub.ui.hide()
	hub.player.hide()
	var weather := hub.get_node("ForestWeather")
	weather.set_time(15.15)
	weather.set_weather("clear",true)
	weather.set_process(false)
	var camera := Camera3D.new()
	hub.add_child(camera)
	camera.make_current()
	camera.fov=66
	for preset in [[Vector3(3.063,8.83,99),Vector3(5.2,10.8,121),"village-entry"],[Vector3(2.4,4.6,29),Vector3(0,4.5,48),"forest-control"]]:
		camera.position=preset[0]
		camera.look_at(preset[1])
		for frame in range(7):
			await RenderingServer.frame_post_draw
		var start := Time.get_ticks_usec()
		for frame in range(20):
			await RenderingServer.frame_post_draw
		var milliseconds := (Time.get_ticks_usec()-start)/20000.0
		print("BENCH ",preset[2],": ",snappedf(milliseconds,.1)," ms; draws=",Performance.get_monitor(Performance.RENDER_TOTAL_DRAW_CALLS_IN_FRAME),"; triangles=",Performance.get_monitor(Performance.RENDER_TOTAL_PRIMITIVES_IN_FRAME))
	hub.queue_free()
	await process_frame
	quit()
