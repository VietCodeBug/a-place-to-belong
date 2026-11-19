extends SceneTree
## Run with godot --headless --path . --script tests/office_first_person_test.gd

var failures := 0

func _initialize() -> void:
	call_deferred("run")

func check(condition: bool, message: String) -> void:
	if not condition:
		failures += 1
		push_error(message)

func tick(count: int) -> void:
	for frame in range(count):
		await physics_frame

func check_storm(office: Node3D) -> void:
	var storm = office.storm
	var exterior_batches := 0
	for child in storm.get_children():
		if child is MultiMeshInstance3D:
			exterior_batches += 1
			var bounds: AABB = child.multimesh.custom_aabb
			check(bounds.end.x < -8.0 or bounds.end.z < -6.0, "Rain must stay beyond the glass.")
	check(exterior_batches == 2 and storm.rain_audio.stream != null, "The two exterior façades need rain and ambience.")
	storm.set_process(false)
	check(not storm.bolt.visible, "The bolt should be hidden between strikes.")
	var normal_energy: float = storm.daylight.light_energy
	storm._process(storm.FIRST_STRIKE + 0.01)
	check(storm.bolt.visible and storm.daylight.light_energy > normal_energy,
		"The automatic strike should light the office.")
	check(not storm.thunder.playing and storm.thunder_at > storm.elapsed,
		"Thunder should follow the flash with a delay.")
	storm._process(0.35)
	check(not storm.bolt.visible and is_equal_approx(storm.daylight.light_energy, normal_energy),
		"The flash should fade back to overcast daylight.")
	storm._process(0.75)
	await tick(2)
	check(storm.thunder_at < 0.0 and storm.thunder.playing, "The delayed thunder should play.")
	storm.set_process(true)

func run() -> void:
	var office := load("res://scenes/story/real_office.tscn").instantiate() as Node3D
	root.add_child(office)
	await tick(3)
	var rig: Skeleton3D = office.actor.skeleton
	var view: Camera3D = office.camera
	check(view.get_parent() == office.player and view.current, "The opening must use the eye camera.")
	check(get_nodes_in_group("office_colleagues").size() == 18, "Both desk banks and the printer corner should be occupied.")
	check(office.colleague_materials.size() >= 6, "The crowd should use a selection of clothing colors.")
	await check_storm(office)
	var desk := office.get_node("PlayerWorkstation") as Node3D
	var neighbor: Node3D = office.typing_colleague
	check(desk.position.x < -3.0 and absf(neighbor.position.x - desk.position.x) < 2.1,
		"The player should have a station at the end of the shared desk bank.")
	check(is_equal_approx(neighbor.position.z, office.player.position.z),
		"The closest coworker should be in the same seating row.")
	check(rig.get_bone_count() == 71, "Character A lost joints during import.")
	for side in ["Left", "Right"]:
		for finger in ["Thumb", "Index", "Middle", "Ring", "Pinky"]:
			for joint in range(1, 4):
				check(rig.find_bone("%sHand%s%d" % [side, finger, joint]) >= 0, "Missing finger joint.")
		for region in ["Eye", "UpperEyelid", "LowerEyelid", "Brow", "Cheek", "MouthCorner", "UpperLip", "LowerLip"]:
			check(rig.find_bone(side + region) >= 0, "Missing facial joint.")
	for joint in ["Jaw", "UpperLipCenter", "LowerLipCenter"]:
		check(rig.find_bone(joint) >= 0, "Missing mouth joint.")
	var head: MeshInstance3D = office.actor.first_person_head
	check(head.cast_shadow == GeometryInstance3D.SHADOW_CASTING_SETTING_SHADOWS_ONLY, "The first-person head can obstruct the camera.")
	var surface := head.get_active_material(0) as StandardMaterial3D
	check(surface.albedo_texture.get_width() == 2048 and surface.normal_texture != null
		and surface.roughness_texture != null and surface.metallic_texture != null, "Missing Character A material maps.")
	var finger_index := rig.find_bone("RightHandIndex2")
	var finger_pose := rig.get_bone_pose_rotation(finger_index)
	await tick(6)
	check(not rig.get_bone_pose_rotation(finger_index).is_equal_approx(finger_pose), "Typing must articulate fingers.")
	check(view.position.y < 1.25, "The intro should start in the chair.")
	office.interact()
	check(not office.read_mail, "Skipping or starting the intro must not mark the email read.")
	office.finish_intro()
	await tick(2)
	check(view.position.y > 1.5 and office.near_desk(), "Intro handoff must stand at the workstation.")
	office.camera.look_with_mouse(Vector2(-340, 65), 0.0)
	await tick(2)
	check(view.rotation.y > 0.6 and view.rotation.x < -0.2, "Mouse input should look right or left and up or down from the eyes.")
	office.deliver_email()
	office.interact()
	check(office.read_mail and office.dialog.visible, "The player must be able to open the email.")
	office.dialog.hide()
	office.seat_requested = true
	await tick(43)
	check(office.actor.seated > 0.98 and view.position.y < 1.25, "Seating must lower the first-person view.")
	office.seat_requested = false
	await tick(43)
	check(office.actor.seated == 0.0 and view.position.y > 1.5, "Standing must restore eye height.")
	Input.action_press("office_left")
	var start: Vector3 = office.player.position
	await tick(55)
	Input.action_release("office_left")
	check(office.player.position.distance_to(start) > 1.0, "The first-person view must preserve movement.")
	Input.action_press("office_left")
	Input.action_press("office_jog")
	await tick(35)
	Input.action_release("office_left")
	Input.action_release("office_jog")
	check(office.player.get_real_velocity().length() > 2.6, "Jogging should increase movement speed.")
	office.player.position = Vector3(-7.30, 0.02, 3.3)
	office.player.velocity = Vector3.ZERO
	office.camera.yaw = 0.0
	Input.action_press("office_left")
	await tick(66)
	Input.action_release("office_left")
	check(office.player.position.x > -7.90 and view.global_position.x > -7.93, "The glass wall must stop the player and eye camera.")
	office.player.position = office.DESK_STAND
	office.player.velocity = Vector3.ZERO
	Input.action_press("office_back")
	await tick(51)
	Input.action_release("office_back")
	check(office.player.position.z > 3.25, "The chair must open onto the aisle behind the desk bank.")
	Input.action_press("office_right")
	Input.action_press("office_jog")
	await tick(126)
	Input.action_release("office_right")
	Input.action_release("office_jog")
	check(absf(office.player.position.x) < 1.30, "The shared-desk aisle must reach the main exit corridor.")
	Input.action_press("office_back")
	await tick(64)
	Input.action_release("office_back")
	check(office.near_exit(), "The player should be able to walk from their chair to the exit.")
	office.interact()
	check(office.complete, "After reading the email, the exit must complete the scene.")
	print("OFFICE FIRST PERSON; failures=%d" % failures)
	office.queue_free()
	await process_frame
	quit(1 if failures else 0)
