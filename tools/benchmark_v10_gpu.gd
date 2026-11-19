extends SceneTree
## Profiles real 1920x1080 gameplay rendering on the active Windows GPU across Day, Night, and Heavy Rain.

func _initialize() -> void:
	call_deferred("run_benchmark")

func run_benchmark() -> void:
	if DisplayServer.get_name() == "headless":
		push_error("Real display required for GPU benchmark.")
		quit(1)
		return
	DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_DISABLED)
	DisplayServer.window_set_size(Vector2i(1920, 1080))
	root.size = Vector2i(1920, 1080)

	var hub = load("res://scenes/world/forest_hub.tscn").instantiate()
	root.add_child(hub)
	for i in range(25):
		await process_frame

	var adapter := RenderingServer.get_video_adapter_name()
	var vendor := RenderingServer.get_video_adapter_vendor()
	print("GPU Adapter: ", adapter, " (", vendor, ") | Viewport: ", root.size)

	var weather = hub.get_node("ForestWeather")
	weather.paused = true
	var results := {}

	for scenario in [
		["golden_gameplay", 16.5, "partly_cloudy"],
		["night_lanterns_fireflies", 21.8, "clear"],
		["heavy_rain_puddles", 15.2, "heavy_rain"],
	]:
		weather.set_time(scenario[1])
		weather.set_weather(scenario[2], true)
		for warm in range(20):
			await process_frame
		var frame_times: Array[float] = []
		var last_usec := Time.get_ticks_usec()
		for f in range(90):
			await process_frame
			var now := Time.get_ticks_usec()
			frame_times.append(float(now - last_usec) / 1000.0)
			last_usec = now
		frame_times.sort()
		var sum_ms := 0.0
		for ms in frame_times:
			sum_ms += ms
		var avg_ms := sum_ms / float(frame_times.size())
		var p95_ms := frame_times[int(frame_times.size() * 0.95)]
		var avg_fps := 1000.0 / maxf(avg_ms, 0.01)
		var p95_fps := 1000.0 / maxf(p95_ms, 0.01)
		results[scenario[0]] = {"avg_ms": snappedf(avg_ms, 0.01), "p95_ms": snappedf(p95_ms, 0.01), "avg_fps": snappedf(avg_fps, 0.1), "p95_fps": snappedf(p95_fps, 0.1)}
		print("BENCHMARK ", scenario[0], ": avg=", snappedf(avg_fps, 0.1), " FPS (", snappedf(avg_ms, 0.02), " ms) | 95th=", snappedf(p95_fps, 0.1), " FPS (", snappedf(p95_ms, 0.02), " ms)")

	hub.queue_free()
	await process_frame
	quit(0)
