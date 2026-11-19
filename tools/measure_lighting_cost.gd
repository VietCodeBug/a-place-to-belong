extends SceneTree
## Coarse wall-frame comparison on this host, not a GPU timer or Windows benchmark.
const RIG=preload("res://scripts/lighting/lighting_rig.gd")
func _initialize() -> void: call_deferred("run")
func run() -> void:
	var hub=load("res://scenes/world/forest_hub.tscn").instantiate()
	root.add_child(hub)
	for i in range(15): await process_frame
	hub.player.blocked=true
	hub.player.set_physics_process(false)
	root.get_camera_3d().set_process(false)
	for material in hub.get_node("CuratedGroundCover").materials.values(): material.set_shader_parameter("wind_strength",0.0)
	var results:={"renderer":RenderingServer.get_current_rendering_method(),"measurement":"wall frame intervals on frozen default view, software Mesa llvmpipe; not hardware GPU timing","samples":12,"profiles":{}}
	for name in ["pr09_baseline","golden_hour","blue_hour"]:
		RIG.apply(hub,load("res://assets/lighting/"+name+".tres"))
		for i in range(15): await process_frame
		var times: Array[float]=[]
		var previous:=Time.get_ticks_usec()
		for i in range(12):
			await process_frame
			await RenderingServer.frame_post_draw
			var now:=Time.get_ticks_usec()
			times.append(float(now-previous)/1000.0)
			previous=now
		times.sort()
		results.profiles[name]={"median_frame_ms":(times[5]+times[6])/2.0,"min_frame_ms":times[0],"max_frame_ms":times[-1],"draw_calls":Performance.get_monitor(Performance.RENDER_TOTAL_DRAW_CALLS_IN_FRAME),"primitives":Performance.get_monitor(Performance.RENDER_TOTAL_PRIMITIVES_IN_FRAME)}
	var file:=FileAccess.open("/tmp/lighting-cost.json",FileAccess.WRITE)
	file.store_string(JSON.stringify(results,"\t"))
	print(JSON.stringify(results))
	quit()
