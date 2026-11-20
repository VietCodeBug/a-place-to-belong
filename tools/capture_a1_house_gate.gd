extends SceneTree

const SCENE := preload("res://scenes/environment/a1_house_gate.tscn")

func _initialize() -> void:
	call_deferred("capture")

func capture() -> void:
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
	for view in views:
		shot.position = view[1]
		shot.fov = view[3]
		shot.look_at(view[2])
		await process_frame
		await RenderingServer.frame_post_draw
		var error := root.get_texture().get_image().save_png(
			"res://docs/environment/review-a1-house-gate/%s.png" % view[0])
		if error != OK:
			quit(1)
			return
	quit()
