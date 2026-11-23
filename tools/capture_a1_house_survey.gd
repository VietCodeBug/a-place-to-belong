extends SceneTree
## Debug-only overview of the current interior and the actual House A site.
const HUB = preload("res://scenes/world/forest_hub.tscn")

func _initialize() -> void:
	call_deferred("run")

func run() -> void:
	var args := OS.get_cmdline_user_args()
	if args.is_empty():
		quit(2)
		return
	var out := args[0]
	DirAccess.make_dir_recursive_absolute(out)
	root.size = Vector2i(1280,720)
	var hub := HUB.instantiate()
	hub.set_meta("story_prototype",true)
	root.add_child(hub)
	var story: Node3D = hub.story_prototype
	story.set_process(false)
	hub.ui.hide()
	for mesh: MeshInstance3D in story.house.find_children("*","MeshInstance3D",true,false):
		if mesh.global_position.y>=2.72:
			mesh.hide()
	var camera: Camera3D = story.house.camera
	camera.projection = Camera3D.PROJECTION_ORTHOGONAL
	camera.size = 8.7
	camera.look_at_from_position(Vector3(0,12,0),Vector3.ZERO,Vector3.FORWARD)
	await capture(out+"/mat-bang-nha-a.png")
	story.skip_intro()
	story.enter_outdoors()
	var view := Camera3D.new()
	view.projection = Camera3D.PROJECTION_ORTHOGONAL
	view.size = 51.0
	view.far = 200.0
	hub.add_child(view)
	view.make_current()
	view.look_at_from_position(Vector3(16,41,-338),Vector3(16,.92,-338),Vector3.FORWARD)
	var marker := Label3D.new()
	marker.text = "Nhà A · X 16 / Z −338"
	marker.font_size = 55
	marker.pixel_size = .038
	marker.billboard = BaseMaterial3D.BILLBOARD_ENABLED
	marker.outline_size = 14
	hub.add_child(marker)
	marker.position = Vector3(16,10,-334)
	await capture(out+"/khu-rung-quanh-nha-a.png")
	hub.queue_free()
	await process_frame
	quit()

func capture(path: String) -> void:
	for i in 5:
		await RenderingServer.frame_post_draw
	assert(root.get_texture().get_image().save_png(path)==OK)
	print("SAVED ",path)
