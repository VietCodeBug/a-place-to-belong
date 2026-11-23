extends SceneTree
## godot --path . --script tools/capture_a1_phase21.gd -- /tmp/a1-review --six

const HUB = preload("res://scenes/world/forest_hub.tscn")
const FIELD = preload("res://scripts/world/superworld/terrain_field.gd")
var hub: Node3D
var world: Node3D
var camera: Camera3D
var out: String
var frozen_poses: Dictionary = {}

func _initialize() -> void:
	call_deferred("run")

func shot(id: String, eye: Vector2, focus: Vector2, height: float, aim_height: float) -> void:
	world.prepare_at(eye)
	if world.streamer.has_method("prepare_review") and id!="overview":
		world.streamer.prepare_review(eye)
	hub.player.position = Vector3(eye.x,world.field.height(eye)+.12,eye.y)
	hub.player.velocity = Vector3.ZERO
	var eyeline: float = world.field.height(eye)+height
	var look := Vector3(focus.x,world.field.height(focus)+aim_height,focus.y)
	camera.environment = null
	if id=="highland":
		look.y = FIELD.WATER+3.0
	if id=="overview":
		eyeline = 1770
	camera.position = Vector3(eye.x,eyeline,eye.y)
	if frozen_poses.has(id):
		var eye_values: Array = frozen_poses[id][0]
		var aim_values: Array = frozen_poses[id][1]
		camera.position = Vector3(eye_values[0],eye_values[1],eye_values[2])
		look = Vector3(aim_values[0],aim_values[1],aim_values[2])
	camera.look_at(look)
	if id=="overview":
		await process_frame
		await process_frame
		var env := camera.get_world_3d().environment.duplicate() as Environment
		env.fog_mode = Environment.FOG_MODE_EXPONENTIAL
		env.fog_density = .00022
		camera.environment = env
	for i in 3:
		await process_frame
	await RenderingServer.frame_post_draw
	assert(root.get_texture().get_image().save_png(out+"/"+id+".png")==OK)
	print("SAVED ",id)

func run() -> void:
	var arguments := OS.get_cmdline_user_args()
	out = arguments[0] if not arguments.is_empty() else ProjectSettings.globalize_path("user://a1-phase21-review")
	for argument in arguments:
		if argument.begins_with("--poses="):
			var payload = JSON.parse_string(FileAccess.get_file_as_string(argument.trim_prefix("--poses=")))
			if payload is Dictionary:
				frozen_poses = payload
	DirAccess.make_dir_recursive_absolute(out)
	root.content_scale_size=Vector2i.ZERO
	root.size = Vector2i(1920,1080)
	TranslationServer.set_locale("vi")
	hub = HUB.instantiate()
	hub.set_meta("a1_superworld",true)
	root.add_child(hub)
	world = hub.superworld
	hub.ui.hide()
	hub.player.hide()
	hub.player.blocked = true
	var weather := hub.get_node("ForestWeather")
	weather.set_time(14.65)
	weather.set_weather("clear",true)
	weather.set_process(false)
	camera = Camera3D.new()
	camera.fov = 59.0
	camera.far = 6500.0
	hub.add_child(camera)
	camera.make_current()
	if "--map-only" in arguments:
		await map_shot()
		hub.queue_free()
		await process_frame
		quit()
		return
	if "--lake-only" in arguments:
		await shot("shore",Vector2(205,-464),Vector2(244,-447),1.65,1.1)
		await shot("underwater",Vector2(295,-473),Vector2(306,-471),1.62,1.25)
		hub.queue_free()
		await process_frame
		quit()
		return
	if "--shoreline-details" in arguments:
		await shot("shore-grove",Vector2(205,-447),Vector2(221,-479),1.65,2.5)
		await shot("shore-birches",Vector2(194,-421),Vector2(230,-439),1.65,1.8)
		hub.queue_free()
		await process_frame
		quit()
		return
	await shot("meadow",Vector2(319,145),Vector2(352,126),1.65,2.2)
	await shot("highland",Vector2(283,-811),FIELD.LAKE,1.85,0)
	await shot("shore",Vector2(205,-464),Vector2(244,-447),1.65,1.1)
	await shot("underwater",Vector2(295,-473),Vector2(306,-471),1.62,1.25)
	await shot("overview",Vector2(1150,1260),Vector2(0,-250),0,0)
	await shot("midwater",Vector2(369,-462),Vector2(381,-474),2.25,1.3)
	await shot("basin",Vector2(648,-447),Vector2(636,-463),2.45,1.7)
	if "--six" in OS.get_cmdline_user_args():
		await shot("woodland",Vector2(-4,-318),Vector2(-10,-298),1.65,1.8)
		await shot("bridge",Vector2(-11,67),Vector2(3,78),1.7,1.65)
		await shot("village",Vector2(6.8,120.9),Vector2(-2,133),1.64,2.6)
		await map_shot()
	hub.queue_free()
	await process_frame
	quit()


func map_shot() -> void:
	hub.ui.show()
	var atlas: Control = hub.ui.valley_map
	atlas.show()
	atlas.zoom = 3.15
	atlas.center = Vector2(225,-327)
	atlas.toggle_chunks()
	for i in 4:
		await process_frame
	await RenderingServer.frame_post_draw
	assert(root.get_texture().get_image().save_png(out+"/map.png")==OK)
