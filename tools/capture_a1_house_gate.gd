extends SceneTree

const SCENE := preload("res://scenes/environment/a1_house_gate.tscn")

func _initialize() -> void:
	call_deferred("capture")

func capture() -> void:
	var output := OS.get_environment("A1_REVIEW_DIR")
	if output.is_empty():
		output = "res://docs/environment/review-a1-house-gate"
	root.size = Vector2i(1280, 720)
	var scene := SCENE.instantiate()
	root.add_child(scene)
	scene.get_node("Help").hide()
	var shot := Camera3D.new()
	scene.add_child(shot)
	shot.make_current()
	var views := [
		["front",Vector3(0,2.75,12.3),Vector3(-0.36,2.55,0.4),44.0],
		["side",Vector3(11.1,3.08,1.4),Vector3(0.1,2.52,0.65),44.0],
		["three-quarter",Vector3(8.4,5.6,10.5),Vector3(-0.36,2.24,0.7),43.0],
		["eye-level",Vector3(-4.35,1.67,7.8),Vector3(-0.24,2.3,0.92),58.0]
	]
	if OS.get_environment("A1_REVIEW_DETAIL") == "1":
		views = [
			["verge",Vector3(0.1,0.75,6.55),Vector3(-1.5,0.18,4.2),60.0],
			["boulder-foot",Vector3(-4.8,0.88,6.3),Vector3(-6.0,0.55,3.48),58.0],
			["porch",Vector3(-0.35,1.22,6.5),Vector3(-0.47,0.73,2.8),57.0]
		]
	for view in views:
		shot.position = view[1]
		shot.fov = view[3]
		shot.look_at(view[2])
		for i in range(4):
			await RenderingServer.frame_post_draw
		var start := Time.get_ticks_usec()
		for i in range(12):
			await RenderingServer.frame_post_draw
		var ms := (Time.get_ticks_usec() - start) / 12000.0
		print("%s %.1f ms %.2f FPS draw_calls=%d" % [view[0],ms,1000.0/ms,
			RenderingServer.viewport_get_render_info(root.get_viewport_rid(),
				RenderingServer.VIEWPORT_RENDER_INFO_TYPE_VISIBLE, RenderingServer.VIEWPORT_RENDER_INFO_DRAW_CALLS_IN_FRAME)])
		var error := root.get_texture().get_image().save_png(output.path_join("%s.png" % view[0]))
		if error != OK:
			quit(1)
			return
	quit()
