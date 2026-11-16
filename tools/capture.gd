extends SceneTree
func _initialize() -> void:
	call_deferred("capture")
func capture() -> void:
	var hub = load("res://scenes/world/forest_hub.tscn").instantiate()
	root.add_child(hub)
	for i in range(20):
		await process_frame
	await RenderingServer.frame_post_draw
	root.get_texture().get_image().save_png("/tmp/forest-post-cafe.png")
	quit()
