extends SceneTree
## Godot's Movie Maker command writes rendered frames and the actual game mix.
## Run with --write-movie /tmp/office.avi --fixed-fps 15. Movie Maker uses
## the configured project viewport. The capture keeps a 1280x720 UI canvas.
const MAPS = preload("res://scripts/story/map_flow.gd")

func _initialize() -> void:
	call_deferred("run")

func run() -> void:
	TranslationServer.set_locale("vi")
	root.content_scale_size = Vector2i(1280, 720)
	assert(change_scene_to_file(MAPS.OFFICE_SCENE) == OK)
	await scene_changed
	var office := current_scene
	while office.intro_active:
		await process_frame
	await create_timer(0.30).timeout
	office.interact()
	assert(office.mail.visible)
	await create_timer(5.2).timeout
	office.mail.close_message()
	office.camera.yaw = 0.0
	await move_until(office, "office_back", Vector3.BACK, 3.36)
	await create_timer(0.55).timeout
	office.camera.look_with_mouse(Vector2(0.0, 650.0), 0.0)
	await create_timer(1.25).timeout
	office.camera.pitch = -0.13
	await create_timer(0.26).timeout
	Input.action_press("office_jog")
	await move_until(office, "office_right", Vector3.RIGHT, -0.20)
	Input.action_release("office_jog")
	await move_until(office, "office_back", Vector3.BACK, 4.68)
	office.interact()
	assert(office.complete)
	await scene_changed
	assert(current_scene.scene_file_path == MAPS.APARTMENT_SCENE)
	await create_timer(2.3).timeout
	current_scene.examine()
	await create_timer(0.85).timeout
	print("OFFICE V2 MOVIE COMPLETE")
	quit.call_deferred()

func move_until(office: Node3D, action: String, axis: Vector3, target: float) -> void:
	Input.action_press(action)
	var expires: float = office.office_time + 8.0
	while office.player.position.dot(axis) < target and office.office_time < expires:
		await process_frame
	Input.action_release(action)
	assert(office.office_time < expires, "Office walkthrough could not reach the next waypoint.")
