extends SceneTree
## DISPLAY=:139 godot --path . --write-movie /tmp/a1-superworld.avi --resolution 800x450 --fixed-fps 16 --script tools/capture_a1_superworld.gd
const HUB = preload("res://scenes/world/forest_hub.tscn")
const FIELD = preload("res://scripts/world/superworld/terrain_field.gd")
const PLAN = preload("res://scripts/world/village_a_layout.gd")
const OUT := "user://a1-superworld-review/"
const ACTIONS := ["move_left","move_right","move_up","move_down"]
var hub: Node3D
var world: Node3D
var actor: CharacterBody3D
var camera: Camera3D
var caption: Label
var shots_only := false
const FPS := 16

func _initialize() -> void:
	call_deferred("run")

func wait_frames(n: int) -> void:
	for i in n:
		await process_frame

func title(message: String) -> void:
	caption.text = message

func place(p: Vector2) -> void:
	world.prepare_at(p)
	actor.position = Vector3(p.x,world.field.height(p)+.10,p.y)
	actor.velocity = Vector3.ZERO
	camera.set_scenic_mode(false,true)

func save_image(id: String) -> void:
	await RenderingServer.frame_post_draw
	assert(root.get_texture().get_image().save_png(OUT+id+".png")==OK)

func move_to(p: Vector2, seconds: float, snapshot_at: int = -1, shot := "") -> void:
	for i in ceili(seconds*FPS):
		var d := p-Vector2(actor.position.x,actor.position.z)
		if d.length()>.28:
			var key := d.normalized().rotated(PI/4.0)
			release()
			Input.action_press("move_left" if key.x<0 else "move_right",absf(key.x))
			Input.action_press("move_up" if key.y<0 else "move_down",absf(key.y))
		else:
			release()
		await process_frame
		if i == snapshot_at:
			await save_image(shot)
	release()

func release() -> void:
	for action in ACTIONS:
		Input.action_release(action)

func press_map(key: Key) -> void:
	var event := InputEventKey.new()
	event.physical_keycode=key
	event.keycode=key
	event.pressed=true
	hub.ui._unhandled_input(event)

func run() -> void:
	DirAccess.make_dir_recursive_absolute(OUT)
	shots_only = "--shots-only" in OS.get_cmdline_user_args()
	root.content_scale_size = Vector2i.ZERO
	root.size = Vector2i(800,450)
	TranslationServer.set_locale("vi")
	hub = HUB.instantiate()
	hub.set_meta("a1_superworld",true)
	root.add_child(hub)
	world = hub.superworld
	actor = hub.player
	camera = hub.get_node("GameplayCamera")
	var weather := hub.get_node("ForestWeather")
	weather.set_time(13.80)
	weather.set_weather("clear",true)
	weather.set_process(false)
	if not shots_only:
		# Reduce renderer cost for recording on software Mesa. Game settings are untouched.
		hub.get_node("Sun").shadow_enabled = false
		camera.get_world_3d().environment.ssao_enabled = false
	var ui := CanvasLayer.new()
	ui.layer = 25
	root.add_child(ui)
	caption = Label.new()
	caption.position = Vector2(19,416)
	caption.add_theme_font_size_override("font_size",17)
	caption.add_theme_constant_override("outline_size",8)
	caption.add_theme_color_override("font_outline_color",Color("223E35"))
	ui.add_child(caption)
	hub.ui.controls_hint_panel.hide()

	if "--surface-only" in OS.get_cmdline_user_args():
		place(Vector2(294,-472))
		title("Rời vòm đá  ·  Giữ Space để nổi lên")
		await wait_frames(5)
		Input.action_press("a1_surface")
		await move_to(Vector2(288,-473),2.4)
		Input.action_release("a1_surface")
		print("surface_end_y=",actor.position.y)
		await wait_frames(9)
		hub.queue_free()
		await process_frame
		quit()
		return
	if not shots_only:
		title("Nhà A  ·  Đi bộ bằng WASD")
		await wait_frames(5)
		await save_image("nha-a")
		await move_to(Vector2(4,-329),2.3)
	title("Bờ tây  ·  Đi theo bờ dốc xuống nước")
	place(Vector2(216,-466))
	await wait_frames(4)
	await save_image("bo-ho")
	if shots_only:
		await art_shot(camera,"ben-go",Vector2(213,-454),Vector2(237,-447),1.66,1.4)
	if not shots_only:
		await move_to(Vector2(224,-466),3.1)
		title("Bơi trên mặt hồ  ·  WASD")
		await move_to(Vector2(236,-466),3.5,37,"boi")

		title("Ngoài bờ tây  ·  Giữ Ctrl để lặn")
		place(Vector2(285,-471))
		actor.position.y = FIELD.WATER-.92
		camera.set_scenic_mode(false,true)
		Input.action_press("a1_dive")
		await move_to(Vector2(302,-471),4.15,55,"lan")
		Input.action_release("a1_dive")
		title("Ra ngoài vòm đá và giữ Space để nổi lên")
		await move_to(Vector2(292,-471),3.2)
		Input.action_press("a1_surface")
		await wait_frames(29)
		Input.action_release("a1_surface")
		print("demo_end=",actor.position," mode=",actor.state)
	title("")
	press_map(KEY_M)
	await wait_frames(3)
	await save_image("ban-do-a1")
	press_map(KEY_F7)
	hub.ui.valley_map.zoom=4.8
	hub.ui.valley_map.center_on_player()
	await wait_frames(3)
	await save_image("chunk-duoi-ho")
	press_map(KEY_TAB)
	await wait_frames(3)
	await save_image("registry")
	press_map(KEY_M)
	hub.ui.hide()
	actor.hide()
	var overview := Camera3D.new()
	overview.far = 7200.0
	overview.fov = 55
	hub.add_child(overview)
	overview.position = Vector3(1150,1710,1260)
	overview.look_at(Vector3(0,0,-250))
	overview.make_current()
	var panorama_environment := overview.get_world_3d().environment.duplicate() as Environment
	panorama_environment.fog_density = .00014
	overview.environment = panorama_environment
	await wait_frames(3)
	await save_image("toan-canh-a1")
	overview.environment = null
	await art_shot(overview,"rung-co-thu",Vector2(-4,-318),Vector2(-10,-298),1.65,1.8)
	await art_shot(overview,"dong-co-hoa",Vector2(320,147),Vector2(365,126),1.6,2.7)
	await art_shot(overview,"song-va-cau",Vector2(-11,67),Vector2(3,78),1.7,1.65)
	await art_shot(overview,"lang-a",Vector2(6.8,120.9),Vector2(-2,133),1.64,2.6)
	await art_shot(overview,"cao-nguyen",FIELD.OVERLOOK+Vector2(9,9),FIELD.LAKE,2.0,19.0)
	print("REVIEW COMPLETE ",ProjectSettings.globalize_path(OUT))
	hub.queue_free()
	await process_frame
	quit()


func art_shot(review_camera: Camera3D, id: String, eye: Vector2, aim: Vector2, eye_height: float, focus_height: float) -> void:
	review_camera.make_current()
	place(eye)
	review_camera.make_current()
	review_camera.position = Vector3(eye.x,world.field.height(eye)+eye_height,eye.y)
	review_camera.look_at(Vector3(aim.x,world.field.height(aim)+focus_height,aim.y))
	await wait_frames(4)
	await save_image(id)
