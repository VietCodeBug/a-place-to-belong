extends SceneTree
## V04 captures actual gameplay and separate authored review presets.
var folder := "/tmp/forest-v04-captures"
func _initialize() -> void:
	call_deferred("capture")
func capture() -> void:
	if DisplayServer.get_name() == "headless":
		push_error("Capture requires a rendering display")
		quit(1)
		return
	for arg in OS.get_cmdline_user_args():
		if arg.begins_with("--output="):
			folder = arg.trim_prefix("--output=")
	DirAccess.make_dir_recursive_absolute(folder)
	var hub = load("res://scenes/world/forest_hub.tscn").instantiate()
	root.add_child(hub)
	for i in range(30):
		await process_frame
	await save_frame("01-map01-gameplay.png")
	hub.ui.hide()
	var camera: Camera3D = root.get_camera_3d()
	hub.player.position = Vector3(0.8,hub.cafe_base+0.4,2.9)
	hub.player.velocity = Vector3.ZERO
	hub.player.blocked = true
	ForestReviewCameras.apply(camera,"lodge")
	await save_frame("02-cafe-player-scale.png")
	ForestReviewCameras.apply(camera,"detail")
	await save_frame("03-architecture-detail.png")
	ForestReviewCameras.apply(camera,"forest")
	await save_frame("04-forest-lighting.png")
	ForestReviewCameras.apply(camera,"wide")
	await save_frame("05-map01-wide.png")
	print("Map 01 V04 real-engine captures: ",folder)
	quit()
func save_frame(name: String) -> void:
	for i in range(5):
		await process_frame
	await RenderingServer.frame_post_draw
	var error := root.get_texture().get_image().save_png(folder.path_join(name))
	if error != OK:
		push_error("Screenshot write failed: "+name)
		quit(1)
