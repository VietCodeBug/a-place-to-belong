extends SceneTree
## Matched first-person review of House A's actual interior and exterior material state.

const HUB = preload("res://scenes/world/forest_hub.tscn")
var output := "/tmp/a1-house-wear"
var hub: Node3D
var stage: Node3D
var viewer: CharacterBody3D

func _initialize() -> void:
	call_deferred("run")

func frame(at: Vector3, target: Vector3, file_name: String) -> void:
	RenderingServer.render_loop_enabled = false
	if not stage.inside:
		hub.superworld.prepare_at(Vector2(at.x,at.z))
	viewer.position = at
	viewer.velocity = Vector3.ZERO
	var camera := viewer.get_viewport().get_camera_3d()
	hub.eyes.aim(target-(viewer.global_position+Vector3.UP*1.55))
	hub.eyes.place(camera,viewer,0.0,true)
	for tick in 12:
		await process_frame
	RenderingServer.render_loop_enabled = true
	for tick in 4:
		await RenderingServer.frame_post_draw
	assert(root.get_texture().get_image().save_png(output+"/"+file_name+".png")==OK)
	print("HOUSE_WEAR_SHOT ",file_name)

func outdoors(spot: Vector3, target: Vector3, file_name: String) -> void:
	var shell := hub.get_node("ForestHouseA/CottageShell") as Node3D
	var at := shell.to_global(spot)
	await frame(hub.ground(at.x,at.z,.085),shell.to_global(target),file_name)

func run() -> void:
	var comparison := -1.0
	for arg in OS.get_cmdline_user_args():
		if arg.begins_with("--out="):
			output = arg.trim_prefix("--out=")
		elif arg.begins_with("--wear="):
			comparison = float(arg.trim_prefix("--wear="))
	DirAccess.make_dir_recursive_absolute(output)
	root.size = Vector2i(1280,720)
	hub = HUB.instantiate()
	hub.set_meta("story_prototype",true)
	root.add_child(hub)
	stage = hub.story_prototype
	viewer = hub.player
	stage.skip_intro()
	hub.ui.hide()
	stage.weather.paused = true
	stage.weather.set_time(9.67)
	stage.weather.set_weather("clear",true)
	if comparison>=0.0:
		stage.set_house_wear(comparison)
	await frame(Vector3(.57,.055,2.62),Vector3(2.25,1.13,-1.87),"01-phong-chung")
	if comparison<0.0:
		await frame(Vector3(-2.28,.055,-.96),Vector3(-3.56,.90,-2.49),"02-phong-ngu")
		await frame(Vector3(2.66,.055,-2.45),Vector3(4.05,1.22,-2.87),"03-bep-go")
		await frame(Vector3(-.86,.055,1.95),Vector3(-4.15,1.20,1.80),"04-lo-suoi")
	stage.enter_outdoors()
	hub.ui.hide()
	await outdoors(Vector3(4.80,0,7.45),Vector3(-.35,2.05,1.12),"05-nha-trong-rung")
	if comparison<0.0:
		await outdoors(Vector3(2.54,0,4.72),Vector3(.33,1.22,2.22),"06-cua-va-chan-tuong")
		await outdoors(Vector3(-4.01,0,6.48),Vector3(-1.78,1.87,1.31),"07-hien-va-mai")
	print("HOUSE_WEAR_CAPTURE PASS ",output)
	hub.queue_free()
	await process_frame
	quit()
