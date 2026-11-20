extends SceneTree
const LAND = preload("res://scripts/world/landscape.gd")
# Use --fixed-fps 10 and a graphical renderer. Frames are written outside the project.
const FRAME_DIRECTORY := "user://village-a-walk"
const ACTIONS := ["move_left","move_right","move_up","move_down"]

func _initialize() -> void:
	call_deferred("run")

func run() -> void:
	DirAccess.make_dir_recursive_absolute(FRAME_DIRECTORY)
	root.content_scale_size=Vector2i.ZERO
	root.size=Vector2i(704,396)
	var hub := preload("res://scenes/world/forest_hub.tscn").instantiate()
	root.add_child(hub)
	hub.ui.hide()
	var weather := hub.get_node("ForestWeather")
	weather.set_time(15.15)
	weather.set_weather("clear",true)
	weather.set_process(false)
	var player: CharacterBody3D = hub.player
	var camera: Camera3D = hub.get_node("GameplayCamera")
	player.position=hub.ground(LAND.valley_path(94),94,.09)
	camera.distance=13.0
	camera.set_scenic_mode(false,true)
	for frame in range(150):
		var z := player.position.z
		var to := Vector2(LAND.valley_path(z+1.6),z+1.6)
		var direction := (to-Vector2(player.position.x,z)).normalized().rotated(PI/4)
		for action in ACTIONS:
			Input.action_release(action)
		Input.action_press("move_left" if direction.x<0 else "move_right", absf(direction.x))
		Input.action_press("move_up" if direction.y<0 else "move_down", absf(direction.y))
		await process_frame
		await RenderingServer.frame_post_draw
		root.get_texture().get_image().save_png("%s/%04d.png" % [FRAME_DIRECTORY,frame])
	for action in ACTIONS:
		Input.action_release(action)
	print("WALK ",player.position,"; frames=",ProjectSettings.globalize_path(FRAME_DIRECTORY))
	var crossed := player.position.z > 133.0
	hub.queue_free()
	await process_frame
	quit(0 if crossed else 1)
