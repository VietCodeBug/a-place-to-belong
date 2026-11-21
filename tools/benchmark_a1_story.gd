extends SceneTree
## Run from either revision. Pass --story-prototype for the Phase 3 run.

const HUB = preload("res://scenes/world/forest_hub.tscn")
const SAMPLES := 32

func _initialize() -> void:
	call_deferred("run")

func run() -> void:
	root.content_scale_size = Vector2i.ZERO
	root.size = Vector2i(960,540)
	DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_DISABLED)
	var hub := HUB.instantiate()
	hub.set_meta("a1_superworld",true)
	hub.set_meta("show_map_title",false)
	root.add_child(hub)
	var village := Vector2(5.8,128.6)
	var story := hub.get_node_or_null("Chapter01Prototype")
	if story != null:
		story.skip_intro()
		story.enter_outdoors()
	var world: Node3D = hub.superworld
	world.prepare_at(village)
	hub.player.position = hub.ground(village.x,village.y,.06)
	var weather := hub.get_node("ForestWeather")
	weather.set_time(10.3)
	weather.set_weather("clear",true)
	weather.set_process(false)
	hub.get_node("GameplayCamera").set_scenic_mode(false,true)
	for i in 40:
		await RenderingServer.frame_post_draw
	var timings: Array[float] = []
	var draws: Array[float] = []
	var last := Time.get_ticks_usec()
	for i in SAMPLES:
		await RenderingServer.frame_post_draw
		var now := Time.get_ticks_usec()
		timings.append((now-last)*.001)
		draws.append(Performance.get_monitor(Performance.RENDER_TOTAL_DRAW_CALLS_IN_FRAME))
		last = now
	timings.sort()
	draws.sort()
	print("VILLAGE_BENCH ",JSON.stringify({"story":story!=null,"renderer":RenderingServer.get_video_adapter_name(),
		"p50_ms":snappedf(timings[16],.1),"p95_ms":snappedf(timings[30],.1),"median_draws":draws[16],
		"near_npcs":story.village.active_count() if story!=null else 0,"samples":SAMPLES}))
	hub.queue_free()
	await process_frame
	quit()
