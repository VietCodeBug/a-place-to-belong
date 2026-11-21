extends SceneTree
## Run at --fixed-fps 3. Captured samples retain actual gameplay physics.
const L = preload("res://scripts/world/landscape.gd")
const PLAN = preload("res://scripts/world/village_a_layout.gd")
const OUT := "user://a1-v5-review-walk/"
const INPUTS := ["move_left","move_right","move_up","move_down"]

func _initialize() -> void:
	call_deferred("run")

func run() -> void:
	DirAccess.make_dir_recursive_absolute(OUT)
	Engine.max_physics_steps_per_frame = 20
	root.content_scale_size = Vector2i.ZERO
	root.size = Vector2i(704,396)
	var hub := preload("res://scenes/world/forest_hub.tscn").instantiate()
	root.add_child(hub)
	hub.ui.hide()
	var weather := hub.get_node("ForestWeather")
	weather.set_time(15.15)
	weather.set_weather("clear",true)
	weather.set_process(false)
	var player: CharacterBody3D = hub.player
	var camera: Camera3D = hub.get_node("GameplayCamera")
	camera.distance = 13
	camera.set_scenic_mode(false,true)
	var valley := hub.get_node("A1RiverValley")
	var path: Array[Vector2] = []
	path.assign(PLAN.HOUSE_APPROACH)
	path.append_array(PLAN.THOMAS_APPROACH.slice(1))
	var spur_return := PLAN.THOMAS_APPROACH.slice(0,-1)
	spur_return.reverse()
	path.append_array(spur_return)
	for z in range(19,25):
		path.append(Vector2(ClearingLayout.path_center(z),z))
	for z in range(27,181,3):
		path.append(Vector2(L.valley_path(z),z))
	var outbound := path.size()
	var returning := path.slice(0,-1)
	returning.reverse()
	path.append_array(returning)
	Input.action_press("jog")
	var target := 1
	for frame in range(285):
		var planar := Vector2(player.position.x,player.position.z)
		while target<path.size() and planar.distance_to(path[target])<.79:
			target+=1
			if target==outbound:
				print("TURN ",player.position)
				valley.set_season_palette(0)
		if target>=path.size():
			break
		var input := (path[target]-planar).normalized().rotated(PI/4)
		for action in INPUTS:
			Input.action_release(action)
		Input.action_press("move_left" if input.x<0 else "move_right",absf(input.x))
		Input.action_press("move_up" if input.y<0 else "move_down",absf(input.y))
		await process_frame
		await RenderingServer.frame_post_draw
		root.get_texture().get_image().save_jpg("%s/%04d.jpg" % [OUT,frame],.91)
	print("WALK ",target,"/",path.size()," ",player.position," ",ProjectSettings.globalize_path(OUT))
	for action in INPUTS:
		Input.action_release(action)
	Input.action_release("jog")
	quit(0 if target>=path.size() else 1)
