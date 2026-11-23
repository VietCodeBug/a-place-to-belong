extends SceneTree
## V06 architecture-first review; camera 01 is the actual unmodified gameplay camera.
var folder := "/tmp/forest-v06-captures"
func _initialize() -> void: call_deferred("capture")
func capture() -> void:
	if DisplayServer.get_name()=="headless":
		push_error("A real rendering display is required")
		quit(1)
		return
	for arg in OS.get_cmdline_user_args():
		if arg.begins_with("--output="): folder=arg.trim_prefix("--output=")
	DirAccess.make_dir_recursive_absolute(folder)
	var hub=load("res://scenes/world/forest_hub.tscn").instantiate()
	root.add_child(hub)
	for i in range(30): await process_frame
	await save_frame("01-gameplay-hero.png")
	hub.ui.hide()
	hub.player.position=Vector3(0.85,0.38,2.7)
	hub.player.velocity=Vector3.ZERO
	hub.player.blocked=true
	hub.player.model.rotation.y=PI
	var camera: Camera3D=root.get_camera_3d()
	camera.set_process(false)
	pose(camera,Vector3(7,4.8,10),Vector3(-0.6,2.6,0.2),38)
	await save_frame("02-wood-material-closeup.png")
	pose(camera,Vector3(13,6.9,16),Vector3(-0.4,2.6,-0.6),42)
	await save_frame("03-player-entrance-scale.png")
	pose(camera,Vector3(18,11,22),Vector3(-0.5,3.3,-2),40)
	await save_frame("04-golden-hour-exterior.png")
	pose(camera,Vector3(10,12,12),Vector3(-2,5,-3),38)
	await save_frame("05-roof-joinery.png")
	pose(camera,Vector3(3.8,2.5,7.2),Vector3(0.85,1.32,2.7),32)
	await save_frame("06-character-color.png")
	pose(camera,Vector3(12,4,20),Vector3(6,0.15,14),42)
	await save_frame("07-meadow-detail.png")
	print("V06 actual architecture review captured: ",folder)
	quit()
func pose(camera: Camera3D,eye: Vector3,focus: Vector3,lens: float) -> void:
	camera.position=eye
	camera.fov=lens
	camera.look_at(focus)
func save_frame(name: String) -> void:
	for i in range(5): await process_frame
	await RenderingServer.frame_post_draw
	var error:=root.get_texture().get_image().save_png(folder.path_join(name))
	if error!=OK:
		push_error("PNG write failed: "+name)
		quit(1)
