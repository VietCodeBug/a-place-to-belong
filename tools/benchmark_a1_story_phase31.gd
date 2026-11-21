extends SceneTree
## Identical eye-height measurement camera in the archived Phase 3 and Phase 3.1.
const HUB = preload("res://scenes/world/forest_hub.tscn")
const TARGET := Vector2(5.8,128.6)

func _initialize() -> void:
	call_deferred("run")

func run() -> void:
	root.content_scale_size = Vector2i.ZERO
	root.size = Vector2i(960,540)
	DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_DISABLED)
	var hub := HUB.instantiate()
	hub.set_meta("story_prototype",true)
	root.add_child(hub)
	var story: Node = hub.story_prototype
	story.skip_intro()
	var start := Time.get_ticks_usec()
	story.enter_outdoors()
	var exit_us := Time.get_ticks_usec()-start
	start = Time.get_ticks_usec()
	story.enter_house(false)
	var enter_us := Time.get_ticks_usec()-start
	story.enter_outdoors()
	hub.superworld.prepare_at(TARGET)
	hub.player.position = hub.ground(TARGET.x,TARGET.y,.04)
	hub.player.velocity = Vector3.ZERO
	hub.player.model.hide()
	var weather := hub.get_node("ForestWeather")
	weather.set_time(10.3)
	weather.set_weather("clear",true)
	weather.set_process(false)
	var gameplay := hub.get_node("GameplayCamera") as Camera3D
	gameplay.set_process(false)
	var fixed := Camera3D.new()
	fixed.fov = 68.0
	fixed.far = 4300.0
	fixed.cull_mask = gameplay.cull_mask & ~(1<<18)
	hub.add_child(fixed)
	fixed.look_at_from_position(hub.ground(TARGET.x,TARGET.y,1.59),Vector3(8,8.8,138))
	fixed.make_current()
	# Let the same amount of simulation pass while measuring frame time on either revision.
	for i in 28:
		await RenderingServer.frame_post_draw
	var times: Array[float] = []
	var draws: Array[float] = []
	var npc: Array[float] = []
	var last := Time.get_ticks_usec()
	for i in 32:
		await RenderingServer.frame_post_draw
		var now := Time.get_ticks_usec()
		times.append((now-last)*.001)
		last = now
		draws.append(Performance.get_monitor(Performance.RENDER_TOTAL_DRAW_CALLS_IN_FRAME))
		npc.append(story.village.frame_cpu_usec*.001)
	times.sort()
	draws.sort()
	npc.sort()
	print("PHASE31_BENCH ",JSON.stringify({"p50_ms":times[16],"p95_ms":times[30],"median_draws":draws[16],
		"npc_tick_p50_ms":npc[16],"npc_tick_p95_ms":npc[30],"near_npcs":story.village.active_count(),
		"enter_us":enter_us,"exit_us":exit_us,"static_mib":Performance.get_monitor(Performance.MEMORY_STATIC)/1048576.0,
		"render_mib":Performance.get_monitor(Performance.RENDER_VIDEO_MEM_USED)/1048576.0,
		"renderer":RenderingServer.get_video_adapter_name(),"samples":32}))
	hub.queue_free()
	await process_frame
	quit()
