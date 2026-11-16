extends SceneTree
## Actual renderer capture. Requires a display; never substitute headless images.
## -- --output=/absolute/folder writes three reproducible angles.
func _initialize() -> void:
	call_deferred("capture")

func capture() -> void:
	if DisplayServer.get_name() == "headless":
		push_error("Capture requires an actual display and renderer")
		quit(1)
		return
	var folder := "/tmp/forest-captures"
	for arg in OS.get_cmdline_user_args():
		if arg.begins_with("--output="):
			folder = arg.trim_prefix("--output=")
	DirAccess.make_dir_recursive_absolute(folder)
	var hub = load("res://scenes/world/forest_hub.tscn").instantiate()
	root.add_child(hub)
	for i in range(12):
		await process_frame
	await save_frame(folder.path_join("01-playable-view.png"))
	hub.ui.hide()
	var camera: Camera3D = root.get_camera_3d()
	camera.set_process(false)
	camera.position = Vector3(19,16,24)
	camera.fov = 50
	camera.look_at(Vector3(-1,3,-3))
	await save_frame(folder.path_join("02-woodland-clearing.png"))
	camera.position = Vector3(10,7.8,13)
	camera.look_at(Vector3(0,2,0))
	await save_frame(folder.path_join("03-cafe-porch.png"))
	print("Rendered captures saved to ",folder)
	quit()

func save_frame(path: String) -> void:
	for i in range(3):
		await process_frame
	await RenderingServer.frame_post_draw
	var error := root.get_texture().get_image().save_png(path)
	if error != OK:
		push_error("PNG save failed: " + path)
		quit(1)
