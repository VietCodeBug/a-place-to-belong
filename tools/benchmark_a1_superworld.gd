extends SceneTree
## Graphical 960 × 540 frametime, one scenario per invocation.
const HUB = preload("res://scenes/world/forest_hub.tscn")
const SAMPLES := 32

func _initialize() -> void:
	call_deferred("run")

func run() -> void:
	var args := OS.get_cmdline_user_args()
	var scenario := "classic" if "--classic" in args else "lake" if "--lake" in args else "expanded"
	root.content_scale_size=Vector2i.ZERO
	root.size = Vector2i(960,540)
	DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_DISABLED)
	var start := Time.get_ticks_msec()
	var hub := HUB.instantiate()
	if scenario!="classic":
		hub.set_meta("a1_superworld",true)
	root.add_child(hub)
	var build_ms := Time.get_ticks_msec()-start
	var weather := hub.get_node("ForestWeather")
	weather.set_time(13.8)
	weather.set_weather("clear",true)
	weather.set_process(false)
	var world: Node3D = hub.superworld
	if scenario=="lake":
		var p := Vector2(214,-466)
		world.prepare_at(p)
		hub.player.position = Vector3(p.x,world.field.height(p)+.10,p.y)
		hub.get_node("GameplayCamera").set_scenic_mode(false,true)
	for i in 28:
		await RenderingServer.frame_post_draw
	var samples: Array[float] = []
	var counts: Array[float] = []
	var last := Time.get_ticks_usec()
	for i in SAMPLES:
		await RenderingServer.frame_post_draw
		var now := Time.get_ticks_usec()
		samples.append((now-last)*.001)
		last = now
		counts.append(Performance.get_monitor(Performance.RENDER_TOTAL_DRAW_CALLS_IN_FRAME))
	samples.sort()
	counts.sort()
	var result := {
		"scenario":scenario,
		"runtime_build_ms":build_ms,"samples":SAMPLES,
		"p50_ms":snappedf(samples[16],.1),"p95_ms":snappedf(samples[30],.1),
		"median_draw_calls":counts[16],
		"engine_static_mib":snappedf(Performance.get_monitor(Performance.MEMORY_STATIC)/1048576.0,.1),
		"video_memory_mib":snappedf(Performance.get_monitor(Performance.RENDER_VIDEO_MEM_USED)/1048576.0,.1)
	}
	if world!=null:
		result["near_meshes"] = world.streamer.chunks.size()
		result["physical_tiles"] = world.streamer.solid.size()
	print("BENCH ",JSON.stringify(result))
	if scenario=="classic":
		TranslationServer.set_locale("vi")
		var key := InputEventKey.new()
		key.physical_keycode = KEY_M
		key.pressed = true
		hub.ui._unhandled_input(key)
		for i in 3:
			await RenderingServer.frame_post_draw
		root.get_texture().get_image().save_png("user://a1-superworld-review/ban-do-truoc.png")
	hub.queue_free()
	await process_frame
	quit()
