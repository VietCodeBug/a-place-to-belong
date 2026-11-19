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

func check_boss_footing(office: Node3D) -> void:
	var supervisor: Node3D = office.boss.actor
	var rig: Skeleton3D = supervisor.skeleton
	var lowest_sole := INF
	var deepest_bend := 0.0
	for sample in range(180):
		await tick(2)
		for i in range(2):
			var side := "L" if i == 0 else "R"
			var thigh := rig.get_bone_global_pose(supervisor.bones["Thigh" + side]).origin
			var shin := rig.get_bone_global_pose(supervisor.bones["Shin" + side]).origin
			var shoe := rig.get_bone_global_pose(supervisor.bones["Foot" + side])
			var toe := rig.get_bone_global_pose(supervisor.toe_bones[i])
			var heel_marker: Vector3 = supervisor.heel_markers[i]
			var toe_marker: Vector3 = supervisor.toe_markers[i]
			lowest_sole = minf(lowest_sole, minf(rig.to_global(shoe * heel_marker).y, rig.to_global(toe * toe_marker).y))
			deepest_bend = maxf(deepest_bend, (shin - thigh).angle_to(shoe.origin - shin))
	check(lowest_sole >= -0.003 and deepest_bend < 1.23, "Boss shoes should clear the floor and knees should keep a walking range.")

func check_typing_contacts(typist: Node3D) -> void:
	var contacts := {}
	var good_contact := true
	var clock_before: float = typist.clock
	var pose := Vector3(typist.typing, typist.mouse_use, typist.desk_rest)
	typist.typing = 0.90
	typist.mouse_use = 0.0
	typist.desk_rest = 0.0
	for sample in range(240):
		typist.resync(1.0 / 60.0, Vector3.ZERO)
		for i in range(2):
			if typist.key_pressure[i] < 0.99:
				continue
			var side := "L" if i == 0 else "R"
			var digit: int = typist.active_digits[i]
			var key: int = typist.active_keys[i]
			var pad: Vector3 = typist.skeleton.to_global(typist.fingertip(side, digit))
			var key_top: Vector3 = typist.key_face(key)
			contacts[side + str(digit)] = true
			good_contact = good_contact and pad.distance_to(key_top) < 0.004
			good_contact = good_contact and typist.key_caps[key].position.y < typist.key_rest_height - 0.0017
	check(contacts.size() == 6 and good_contact, "Three fingers per hand should reach and depress their target keys.")
	typist.clock = clock_before
	typist.typing = pose.x
	typist.mouse_use = pose.y
	typist.desk_rest = pose.z
	typist.resync(0.0, Vector3.ZERO)

func check_mouse_contact(typist: Node3D) -> void:
	var previous: float = typist.mouse_use
	typist.mouse_use = 1.0
	typist.resync(0.0, Vector3.ZERO)
	var tip: Vector3 = typist.skeleton.to_global(typist.fingertip("R", 0))
	var mouse_top: Vector3 = typist.mouse_prop.to_global(Vector3(-0.011, 0.029, -0.004))
	check(tip.distance_to(mouse_top) < 0.022, "The right index should reach the actual mouse prop.")
	typist.mouse_use = previous
	typist.resync(0.0, Vector3.ZERO)

func check_conversation_fingers(coworker: Node3D) -> void:
	var rig: Skeleton3D = coworker.skeleton
	var fingers_gather := true
	var fingers_flex := true
	for side in ["Left", "Right"]:
		var hand_index := rig.find_bone(side + "Hand")
		var hand_rest := rig.get_bone_global_rest(hand_index)
		var middle_knuckle := rig.get_bone_global_rest(rig.find_bone(side + "HandMiddle1")).origin
		var index_knuckle := rig.get_bone_global_rest(rig.find_bone(side + "HandIndex1")).origin
		var pinky_knuckle := rig.get_bone_global_rest(rig.find_bone(side + "HandPinky1")).origin
		var forward := (middle_knuckle - hand_rest.origin).normalized()
		var across := (index_knuckle - pinky_knuckle).slide(forward).normalized()
		var inward := forward.cross(across)
		var thumb := rig.get_bone_global_rest(rig.find_bone(side + "HandThumb3")).origin
		if (thumb - hand_rest.origin).dot(inward) < 0.0:
			inward = -inward
		var digits: Array[int] = []
		for name in ["Index", "Middle", "Ring", "Pinky"]:
			digits.append(rig.find_bone(side + "Hand" + name + "3"))
		var index_rest := rig.get_bone_global_rest(digits[0]).origin
		var resting_span := (index_rest - rig.get_bone_global_rest(digits[-1]).origin).dot(across)
		for gesture in [0.0, 0.5, 1.0]:
			coworker.pose_standing_coworker(0.0, gesture, 1.0 - gesture)
			var palm_pose := rig.get_bone_global_pose(hand_index) * hand_rest.affine_inverse()
			var lateral := (palm_pose.basis * across).normalized()
			var palm_side := (palm_pose.basis * inward).normalized()
			var index_tip := rig.get_bone_global_pose(digits[0]).origin
			var span := (index_tip - rig.get_bone_global_pose(digits[-1]).origin).dot(lateral)
			fingers_gather = fingers_gather and span < resting_span * 0.86
			fingers_flex = fingers_flex and (index_tip - palm_pose * index_rest).dot(palm_side) > 0.01
			for i in range(3):
				var gap := rig.get_bone_global_pose(digits[i]).origin - rig.get_bone_global_pose(digits[i + 1]).origin
				fingers_gather = fingers_gather and gap.dot(lateral) > 0.010
	check(fingers_gather and fingers_flex, "Conversation fingers should gather without crossing and flex toward the palm.")

func run() -> void:
	var office := load("res://scenes/story/real_office.tscn").instantiate() as Node3D
	root.add_child(office)
	current_scene = office
	await tick(3)
	var rig: Skeleton3D = office.actor.skeleton
	var view: Camera3D = office.camera
	check(view.get_parent() == office.player and view.current, "The opening must use the eye camera.")
	check(get_nodes_in_group("office_colleagues").size() == 18, "Both desk banks and the printer corner should be occupied.")
	check(office.seated_coworkers.size() == 15 and office.standing_coworkers.size() == 3,
		"The office should have staff at the desks, meeting table and printer.")
	for coworker in get_nodes_in_group("office_colleagues"):
		check(coworker.model in office.COWORKER_MODELS, "Every coworker should use one of the supplied models.")
	for coworker in office.standing_coworkers:
		var standing_rig: Skeleton3D = coworker.skeleton
		var wrist_index: int = coworker.bones["Hand" + coworker.gesture_side]
		coworker.pose_standing_coworker(0.0, 0.0, 1.0)
		var at_rest := standing_rig.get_bone_global_pose(wrist_index).origin
		coworker.pose_standing_coworker(0.0, 1.0, 0.0)
		var speaking := standing_rig.get_bone_global_pose(wrist_index).origin
		check(speaking.y - at_rest.y > 0.16 and speaking.z - at_rest.z > 0.14,
			"Standing coworkers should gesture while speaking and lower their hand while listening.")
		check_conversation_fingers(coworker)
	check_mouse_contact(office.actor)
	check_mouse_contact(office.typing_colleague)
	var boss_start: Vector3 = office.boss.position
	var supervisor: Node3D = office.boss.actor
	var boss_rig: Skeleton3D = supervisor.skeleton
	check(boss_rig.get_bone_count() == 57, "The office boss should keep the source rig.")
	check(supervisor.walk_clip.resource_name == "human_000089" and supervisor.walk_distance > 1.5,
		"The boss patrol must read the supplied walk clip and its forward travel.")
	for side in ["Left", "Right"]:
		check(boss_rig.find_bone(side + "HandIndex3") >= 0 and boss_rig.find_bone(side + "ToeBase") >= 0,
			"The boss rig must retain articulated fingers and feet.")
	await check_storm(office)
	var desk := office.get_node("PlayerWorkstation") as Node3D
	var neighbor: Node3D = office.typing_colleague
	check(desk.position.x < -3.0 and absf(neighbor.position.x - desk.position.x) < 2.1,
		"The player should have a station at the end of the shared desk bank.")
	check(is_equal_approx(neighbor.position.z + office.STAFF_CHAIR_INSET, office.player.position.z),
		"NPC 1 should be in the same seating row and pulled up to the keyboard.")
	check(neighbor.name == &"ColleagueNPC01" and neighbor.skeleton.get_bone_count() == 55,
		"The nearest coworker should load the textured NPC 1 rig.")
	var male: Node3D = office.male_colleague
	check(male.name == &"ColleagueNPC02" and male.skeleton.get_bone_count() == 57 and male.seated == 1.0,
		"The male coworker must use the uploaded 57-bone rig in the next seat.")
	check(is_equal_approx(male.position.x - neighbor.position.x, office.DESK_SPACING)
		and is_equal_approx(male.position.z, neighbor.position.z), "Both imported coworkers should share A's desk row.")
	var npc_mesh := neighbor.find_child("ColleagueBody", true, false) as MeshInstance3D
	check(npc_mesh != null, "NPC 1 mesh must be attached to its rig.")
	if npc_mesh:
		var npc_material := npc_mesh.get_active_material(0) as StandardMaterial3D
		check(npc_material.albedo_texture != null and npc_material.normal_texture != null
			and npc_material.roughness_texture != null and npc_material.metallic_texture != null,
			"NPC 1 must retain the embedded PBR textures.")
	for coworker in office.seated_coworkers:
		check(coworker.key_caps.size() == 36 or coworker.keyboard_targets.size() == 2,
			"Every seated coworker needs a workstation keyboard or resting points at the meeting table.")
	for typist in [office.actor, neighbor, male]:
		check_typing_contacts(typist)
	check(desk.has_node("PinnedClippings") and desk.get_node("PinnedClippings").get_child_count() >= 6,
		"Clippings should be pinned above A's desk.")
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
	check(view.position.y < 1.25, "The intro should start in the chair.")
	office.interact()
	check(not office.read_mail, "Skipping or starting the intro must not mark the email read.")
	office.finish_intro()
	await tick(2)
	check(view.position.y > 1.5 and office.near_desk(), "Intro handoff must stand at the workstation.")
	office.camera.look_with_mouse(Vector2(-340, 65), 0.0)
	await tick(9)
	check(view.rotation.y > 0.6 and view.rotation.x < -0.2, "Mouse input should look right or left and up or down from the eyes.")
	check(not office.mail.visible and not office.read_mail, "Skipping the cinematic must not open or read mail.")
	office.deliver_email()
	check(office.mail.inbox_row.get_parent().visible and office.mail.unread_dot.visible, "The desk monitor shows an unread message.")
	office.interact()
	check(office.read_mail and office.mail.visible and not office.mail.unread_dot.visible, "Opening the message should update its inbox state.")
	await tick(38)
	check(office.camera.focus_weight >= 0.99 and office.camera.fov < 59.0, "Email reading should ease the view toward the monitor.")
	var escape := InputEventKey.new()
	escape.keycode = KEY_ESCAPE
	escape.pressed = true
	office._unhandled_input(escape)
	check(not office.mail.visible and not office.in_pause_menu, "Esc closes email before it can pause the office.")
	office.interact()
	check(office.mail.visible, "The original email remains available to read again.")
	office.mail.close_button.pressed.emit()
	check(not office.mail.visible, "The close button returns to first-person control.")
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
	office.camera.yaw = PI * 0.5
	office.camera.pitch = -1.29
	await tick(8)
	check(view.global_position.x > -7.94, "Crouching the view toward the glass must keep the near plane indoors.")
	office.camera.yaw = 0.0
	office.camera.pitch = -0.13
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
	check(office.boss.position.distance_to(boss_start) > 2.0, "The boss must patrol during normal play.")
	await check_boss_footing(office)
	office.set_pause_menu(true)
	check(office.pause_overlay.visible, "Map 01 uses the shared pause menu.")
	office.storybook.open_page("Settings")
	var sensitivity := office.root_ui.find_child("OfficeSensitivity", true, false) as HSlider
	var head_bob := office.root_ui.find_child("OfficeHeadBob", true, false) as CheckButton
	sensitivity.value = 1.45
	head_bob.button_pressed = false
	check(not office.camera.head_bob and is_equal_approx(office.camera.sensitivity, 1.45), "Settings change the live camera.")
	var office_volume := office.root_ui.find_child("MasterVolume", true, false) as HSlider
	office_volume.value = 0.65
	office.set_pause_menu(false)
	office.interact()
	check(office.complete, "After reading the email, interacting with the exit starts the handoff.")
	await scene_changed
	var apartment := current_scene
	check(apartment.scene_file_path == "res://scenes/story/rented_apartment.tscn", "The office exit opens PRO-003.")
	check(apartment.camera.current and apartment.alarm_ringing and apartment.stage == 0, "PRO-003 opens at the bedside with the alarm active.")
	check(not apartment.camera.head_bob and is_equal_approx(apartment.camera.sensitivity, 1.45), "First-person settings follow the player to the apartment.")
	var alarm: Label3D = apartment.alarm_display
	var desk_screen: Label3D = apartment.laptop
	apartment.examine()
	check(not apartment.alarm_ringing, "The player can silence the alarm.")
	apartment.advance()
	await tick(90)
	check(apartment.stage == 1 and not apartment.laptop.text.is_empty(), "Continuing shows the application phase in the same room.")
	apartment.advance()
	await tick(90)
	check(apartment.stage == 2 and apartment.laptop.text.is_empty(), "The last phase shows the disabled alarm and sleeping laptop.")
	check(alarm == apartment.alarm_display and desk_screen == apartment.laptop, "PRO-003 reuses the room and its key props.")
	apartment.advance()
	await tick(90)
	check(apartment.resting and current_scene == apartment, "Sitting on the bed closes the prototype at the PRO-004 boundary.")
	check(is_equal_approx(db_to_linear(AudioServer.get_bus_volume_db(0)), 0.65), "Master volume stays set during the scene change.")
	AudioServer.set_bus_volume_db(0, 0.0)
	print("OFFICE FIRST PERSON; failures=%d" % failures)
	quit(1 if failures else 0)
