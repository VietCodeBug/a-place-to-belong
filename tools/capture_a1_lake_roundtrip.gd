extends SceneTree
## Godot Movie Maker records the actual gameplay camera and normal-speed controller input.
## godot --path . --fixed-fps 8 --write-movie /tmp/a1-lake.avi --script tools/capture_a1_lake_roundtrip.gd

const HUB = preload("res://scenes/world/forest_hub.tscn")
const FIELD = preload("res://scripts/world/superworld/terrain_field.gd")
const MOVEMENT := ["move_left","move_right","move_up","move_down"]
var hub: Node3D
var player: CharacterBody3D
var title: Label
var physics_ticks := 0

func _initialize() -> void:
	call_deferred("run")

func release_direction() -> void:
	for action in MOVEMENT:
		Input.action_release(action)

func follow(target: Vector2) -> bool:
	var distance := target.distance_to(Vector2(player.position.x,player.position.z))
	var budget := ceili((distance+7.0)*27.0)
	for tick in budget:
		var direction := target-Vector2(player.position.x,player.position.z)
		if direction.length()<.52:
			release_direction()
			return true
		var key := direction.normalized().rotated(PI/4.0)
		release_direction()
		Input.action_press("move_left" if key.x<0 else "move_right",absf(key.x))
		Input.action_press("move_up" if key.y<0 else "move_down",absf(key.y))
		physics_ticks += 1
		await physics_frame
	push_error("Round trip blocked at %s, player at %s" % [target,player.position])
	return false

func trail(points: Array) -> bool:
	for point: Vector2 in points:
		if not await follow(point):
			return false
	return true

func display(message: String) -> void:
	title.text = message
	print("ROUNDTRIP ",message," ",player.position)

func close(code: int) -> void:
	release_direction()
	for action in ["jog","a1_dive","a1_surface"]:
		Input.action_release(action)
	hub.queue_free()
	await process_frame
	quit(code)

func run() -> void:
	root.content_scale_size = Vector2i.ZERO
	TranslationServer.set_locale("vi")
	hub = HUB.instantiate()
	hub.set_meta("a1_superworld",true)
	root.add_child(hub)
	player = hub.player
	var world: Node3D = hub.superworld
	var weather := hub.get_node("ForestWeather")
	weather.set_time(14.65)
	weather.set_weather("clear",true)
	weather.set_process(false)
	# Recording preset only. Default scene and benchmark lighting retain shadows and SSAO.
	hub.get_node("Sun").shadow_enabled = false
	player.get_world_3d().environment.ssao_enabled = false
	var caption := CanvasLayer.new()
	caption.layer = 24
	root.add_child(caption)
	title = Label.new()
	title.position = Vector2(13,root.size.y-32)
	title.add_theme_font_size_override("font_size",14)
	title.add_theme_color_override("font_outline_color",Color("172A25"))
	title.add_theme_constant_override("outline_size",5)
	caption.add_child(title)
	hub.ui.hide()

	var route: Array = FIELD.TRAILS[1].duplicate()
	var start: Vector2 = route[0]
	world.prepare_at(start)
	player.position = Vector3(start.x,world.field.height(start)+.12,start.y)
	player.velocity = Vector3.ZERO
	player.blocked = false
	hub.get_node("GameplayCamera").set_scenic_mode(false,true)
	Input.action_press("jog")
	display("Làng A → bờ tây hồ")
	if not await trail(route.slice(1)):
		await close(1)
		return

	Input.action_release("jog")
	display("Xuống nước và bơi ra gờ nông")
	if not await trail([Vector2(224,-461),Vector2(244,-462),Vector2(275,-465),Vector2(296,-471)]):
		await close(1)
		return
	if player.state!="swimming":
		await close(1)
		return
	display("Lặn qua vòm đá")
	Input.action_press("a1_dive")
	if not await trail([Vector2(299,-471),Vector2(309,-471),Vector2(320,-471)]):
		await close(1)
		return
	Input.action_release("a1_dive")
	display("Ra khỏi vòm, nổi lên và bơi về bờ")
	Input.action_press("a1_surface")
	if not await trail([Vector2(309,-462),Vector2(274,-462),Vector2(236,-462),Vector2(220,-462),FIELD.SHORE]):
		await close(1)
		return
	Input.action_release("a1_surface")
	if player.state=="swimming":
		push_error("Player did not exit the water")
		await close(1)
		return

	display("Bờ tây hồ → trở lại Làng A")
	Input.action_press("jog")
	route.reverse()
	if not await trail(route.slice(1)):
		await close(1)
		return
	display("Đã trở lại Làng A")
	for i in 45:
		await physics_frame
	print("ROUNDTRIP PASS movement_ticks=",physics_ticks)
	await close(0)
