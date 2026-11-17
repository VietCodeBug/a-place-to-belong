extends SceneTree
## V10 visual, UI/UX, backdrop, NPC pose, and living environment regression checks.

var failures := 0

func _initialize() -> void:
	call_deferred("run")

func check(ok: bool, label: String) -> void:
	print("PASS: " if ok else "FAIL: ", label)
	if not ok:
		failures += 1

func run() -> void:
	var hub = load("res://scenes/world/forest_hub.tscn").instantiate()
	root.add_child(hub)
	for i in range(6):
		await process_frame

	# 1. Backdrop & horizon rings exist without adding physics colliders
	var backdrop: Node3D = hub.get_node_or_null("ForestBackdrop")
	check(backdrop != null and backdrop.get_child_count() == 3, "3 layered low-poly distant mountain/valley rings present")
	check(count_physics(backdrop) == 0, "distant backdrop rings add zero physics colliders")

	# 2. Living environment systems present and lightweight
	var life: Node3D = hub.get_node_or_null("ForestLife")
	check(life != null, "ForestLife node present")
	for child_name in ["ChimneySmoke", "FlowerButterflies", "WoodlandBirds", "FallingAutumnLeaves", "NightFireflies"]:
		check(life.get_node_or_null(child_name) is MultiMeshInstance3D, "environmental life MultiMesh present: " + child_name)
	check(count_physics(life) == 0, "environmental life adds zero physics colliders")

	# 3. Dynamic UI time/weather badge replaces hardcoded morning banner
	var weather = hub.get_node("ForestWeather")
	weather.paused = true
	weather.set_time(22.0)
	weather.set_weather("clear", true)
	hub.ui._process(0.1)
	check("Starlit Night" in hub.ui.hud_time_label.text and not ("quiet morning" in hub.ui.hud_time_label.text.to_lower()), "nighttime HUD displays accurate Starlit Night label instead of hardcoded morning")
	check(hub.life_check == null if "life_check" in hub else not life.butterfly_node.visible and life.firefly_node.visible, "nighttime hides butterflies and enables glowing fireflies")

	weather.set_time(9.0)
	weather.set_weather("heavy_rain", true)
	hub.ui._process(0.1)
	check("Crisp Morning" in hub.ui.hud_time_label.text and "Downpour" in hub.ui.hud_weather_label.text, "HUD dynamically updates morning + rain status")
	check(not life.butterfly_node.visible and not life.firefly_node.visible, "heavy rain shelters butterflies and fireflies")

	# 4. Scenic Title Menu & Cozy Pause Menu transitions
	hub.ui.enter_title_menu(true)
	check(hub.ui.in_title_menu and hub.player.blocked and hub.get_node("GameplayCamera").scenic_mode, "Scenic Title Menu engages live 3D camera and locks movement")
	hub.ui.exit_title_menu(true)
	check(not hub.ui.in_title_menu and not hub.player.blocked and not hub.get_node("GameplayCamera").scenic_mode, "exiting Title Menu restores gameplay camera and movement")

	hub.ui.set_pause_menu(true)
	check(hub.ui.in_pause_menu and hub.player.blocked, "Pause Menu opens and pauses player movement")
	hub.ui.set_pause_menu(false)
	check(not hub.ui.in_pause_menu and not hub.player.blocked, "closing Pause Menu resumes movement")

	# 5. Eggeght arms lowered naturally & friendly chat interactable registered
	var eggeght: Node3D = hub.get_node("Eggeght")
	var pose = eggeght.get_node_or_null("EggeghtPose")
	check(pose != null and pose.skeleton != null, "Eggeght runtime pose helper attached")
	if pose != null and pose.skeleton != null:
		var l_arm: int = pose.bone_suffix(pose.skeleton, "LeftArm")
		var l_fore: int = pose.bone_suffix(pose.skeleton, "LeftForeArm")
		var dir: Vector3 = (pose.skeleton.get_bone_global_pose(l_fore).origin - pose.skeleton.get_bone_global_pose(l_arm).origin).normalized()
		check(dir.y < -0.85, "Eggeght arms relaxed downward instead of stiff A-pose")
	check(eggeght.get_node_or_null("EggeghtChat") != null and eggeght.get_node("EggeghtChat").is_in_group("interactables"), "Eggeght has contextual chat interaction")

	print("V10 OVERHAUL CHECKS COMPLETE; failures=", failures)
	hub.queue_free()
	await process_frame
	quit(1 if failures else 0)

func count_physics(node: Node) -> int:
	if node == null:
		return 0
	var c := 1 if node is PhysicsBody3D else 0
	for child in node.get_children():
		c += count_physics(child)
	return c
