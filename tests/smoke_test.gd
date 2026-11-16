extends SceneTree
var failures := 0

func check(condition: bool, description: String) -> void:
	if condition:
		print("PASS: ", description)
	else:
		push_error("FAIL: " + description)
		failures += 1

func frames(count: int) -> void:
	for i in range(count):
		await physics_frame

func _initialize() -> void:
	call_deferred("run")

func run() -> void:
	var hub = load("res://scenes/world/forest_hub.tscn").instantiate()
	root.add_child(hub)
	await frames(30)
	var player = hub.player
	check(player.is_on_floor(), "player settles on ground")
	var start: Vector3 = player.position
	Input.action_press("move_down")
	await frames(45)
	Input.action_release("move_down")
	check(player.position.distance_to(start)>1, "WASD moves player")
	await frames(30)
	check(Vector2(player.velocity.x,player.velocity.z).length()<0.01, "smooth deceleration reaches idle")
	check(player.state == "idle", "idle state restored")
	player.position = hub.collision_probe
	player.velocity = Vector3.ZERO
	await frames(20)
	# W + D cancels the rotated X components and moves directly toward the front wall.
	Input.action_press("move_up")
	Input.action_press("move_right")
	await frames(90)
	Input.action_release("move_up")
	Input.action_release("move_right")
	check(player.position.z > 0.23 and player.position.z < 1.3 and absf(player.velocity.z)<0.05, "cafe collision prevents walking through front wall")
	player.position = hub.mailbox.position+Vector3(0,0.15,1.6)
	player.velocity = Vector3.ZERO
	await frames(20)
	check(hub.ui.active == hub.mailbox, "mailbox selected within range")
	var interact := InputEventAction.new()
	interact.action = "interact"
	interact.pressed = true
	Input.parse_input_event(interact)
	await frames(2)
	check(hub.ui.panel.visible, "E opens mailbox panel")
	check(hub.ui.heading.text == "Welcome to Forest Post Café!", "correct welcome text")
	check(player.blocked, "dialogue blocks movement")
	var escape := InputEventAction.new()
	escape.action = "ui_cancel"
	escape.pressed = true
	Input.parse_input_event(escape)
	await frames(2)
	check(not hub.ui.panel.visible and not player.blocked, "Esc closes panel and restores movement")
	player.position = hub.ground(18,19,0.15)
	await frames(5)
	check(hub.ui.active == null, "distant mailbox cannot be selected")
	var camera: Camera3D = hub.get_viewport().get_camera_3d()
	for i in range(30):
		var wheel := InputEventMouseButton.new()
		wheel.button_index = MOUSE_BUTTON_WHEEL_UP
		wheel.pressed = true
		camera._unhandled_input(wheel)
	check(camera.distance == 10, "zoom respects minimum distance")
	await frames(90)
	check(camera.position.distance_to(camera.desired_position()) < 0.1, "camera converges on player smoothly")
	print("FUNCTIONAL CHECKS COMPLETE; failures=", failures)
	quit(1 if failures else 0)
