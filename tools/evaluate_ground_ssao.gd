extends SceneTree
var folder := "/tmp"
func _initialize() -> void: call_deferred("run")
func run() -> void:
	for arg in OS.get_cmdline_user_args():
		if arg.begins_with("--output="): folder=arg.trim_prefix("--output=")
	DirAccess.make_dir_recursive_absolute(folder)
	var hub=load("res://scenes/world/forest_hub.tscn").instantiate()
	root.add_child(hub)
	for i in range(12): await process_frame
	hub.ui.hide()
	hub.player.blocked=true
	hub.player.set_physics_process(false)
	var camera: Camera3D=root.get_camera_3d()
	camera.set_process(false)
	camera.position=Vector3(14,2.8,17)
	camera.fov=50
	camera.look_at(Vector3(9,.25,12))
	for material in hub.get_node("CuratedGroundCover").materials.values(): material.set_shader_parameter("wind_strength",0.0)
	var env: Environment
	for child in hub.get_children():
		if child is WorldEnvironment: env=child.environment
	env.ssao_radius=.55
	env.ssao_intensity=.65
	env.ssao_power=1.1
	for enabled in [false,true]:
		env.ssao_enabled=enabled
		for i in range(6): await process_frame
		await RenderingServer.frame_post_draw
		root.get_texture().get_image().save_png(folder.path_join("ground-ssao-on.png" if enabled else "ground-ssao-off.png"))
		print("SSAO requested=",enabled," renderer=",RenderingServer.get_current_rendering_method())
	quit()
