extends SceneTree
## V07: actual Samatha texture/role review; no altered lighting or material overrides.
var folder := "/tmp/forest-v07-characters"
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
	for i in range(12): await process_frame
	await save_frame("01-samatha-gameplay.png")
	hub.ui.hide()
	hub.player.position=Vector3(0.85,0.38,2.7)
	hub.player.velocity=Vector3.ZERO
	hub.player.blocked=true
	hub.player.model.rotation.y=PI
	var camera: Camera3D=root.get_camera_3d()
	camera.set_process(false)
	pose(camera,Vector3(3.8,2.5,7.2),Vector3(0.85,1.25,2.7),32)
	await save_frame("02-samatha-original-color.png")
	var skeleton: Skeleton3D=hub.player.avatar_skeleton
	var head: int=hub.player.bone_suffix(skeleton,"Head")
	var focus: Vector3=skeleton.global_transform*skeleton.get_bone_global_pose(head).origin+Vector3(0,0.06,0)
	pose(camera,focus+Vector3(0.6,0,1.6),focus,28)
	await save_frame("03-samatha-face.png")
	var eggeght: Node3D=hub.get_node("Eggeght")
	pose(camera,eggeght.position+Vector3(2.8,2.1,4.8),eggeght.position+Vector3(0,0.95,0),32)
	await save_frame("04-eggeght-npc.png")
	hub.player.position=hub.ground(1,13,0.15)
	hub.player.blocked=false
	pose(camera,Vector3(5,3.5,18),Vector3(0,1,12),38)
	Input.action_press("move_up")
	for i in range(8): await physics_frame
	await save_frame("05-samatha-walking.png")
	Input.action_release("move_up")
	print("V07 actual Samatha and eggeght captures: ",folder)
	quit()
func pose(camera: Camera3D,eye: Vector3,focus: Vector3,lens: float) -> void:
	camera.position=eye
	camera.fov=lens
	camera.look_at(focus)
func save_frame(name: String) -> void:
	for i in range(3): await process_frame
	await RenderingServer.frame_post_draw
	if root.get_texture().get_image().save_png(folder.path_join(name))!=OK:
		push_error("PNG write failed: "+name)
		quit(1)
