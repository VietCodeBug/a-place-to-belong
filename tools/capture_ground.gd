extends SceneTree
## Actual ground-environment review. Main camera, café and actors are not restaged.
var folder := "/tmp/forest-ground-review"
func _initialize() -> void: call_deferred("capture")
func capture() -> void:
	if DisplayServer.get_name()=="headless":
		push_error("A rendering display is required")
		quit(1)
		return
	for arg in OS.get_cmdline_user_args():
		if arg.begins_with("--output="): folder=arg.trim_prefix("--output=")
	DirAccess.make_dir_recursive_absolute(folder)
	var hub=load("res://scenes/world/forest_hub.tscn").instantiate()
	root.add_child(hub)
	for i in range(15): await process_frame
	await save_frame("01-default-gameplay.png")
	hub.ui.hide()
	hub.player.blocked=true
	var camera: Camera3D=root.get_camera_3d()
	camera.set_process(false)
	pose(camera,Vector3(14,2.8,17),Vector3(9,.25,12),50)
	await save_frame("02-ground-grass.png")
	pose(camera,Vector3(-8,3.5,19),Vector3(.2,.3,10),47)
	await save_frame("03-path-transitions.png")
	pose(camera,Vector3(-8.5,4,7.5),Vector3(-12.4,.2,3.5),52)
	await save_frame("04-forest-floor.png")
	pose(camera,Vector3(27,26,34),Vector3(0,2,0),46)
	await save_frame("05-map01-composition.png")
	print("Actual ground review captured: ",folder)
	quit()
func pose(camera: Camera3D,eye: Vector3,focus: Vector3,lens: float) -> void:
	camera.position=eye
	camera.fov=lens
	camera.look_at(focus)
func save_frame(name: String) -> void:
	for i in range(4): await process_frame
	await RenderingServer.frame_post_draw
	if root.get_texture().get_image().save_png(folder.path_join(name))!=OK:
		push_error("PNG write failed: "+name)
		quit(1)
