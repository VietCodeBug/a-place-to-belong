extends SceneTree

const ACTOR = preload("res://scenes/story/opening_actor.tscn")
const BEHAVIOR = preload("res://scripts/story/coworker_behavior.gd")
const MAPS = preload("res://scripts/story/map_flow.gd")
const STEP := 1.0 / 60.0
var failures := 0

func _initialize() -> void:
	call_deferred("run")

func check(condition: bool, message: String) -> void:
	if not condition:
		failures += 1
		push_error(message)

func tick(count: int) -> void:
	for i in count:
		await physics_frame

func run() -> void:
	var actor := ACTOR.instantiate()
	root.add_child(actor)
	check_face(actor)
	check_steps(actor)
	actor.free()
	check_behavior()
	assert(change_scene_to_file(MAPS.OFFICE_SCENE) == OK)
	await scene_changed
	check_office_contacts(current_scene)
	assert(change_scene_to_file(MAPS.APARTMENT_SCENE) == OK)
	await scene_changed
	await check_apartment_contacts(current_scene)
	print("CHARACTER PHASE 01; failures=%d" % failures)
	quit(1 if failures else 0)

func check_face(actor: Node3D) -> void:
	var rig: Skeleton3D = actor.skeleton
	check(rig.get_bone_count() == 71 and actor.face_joints.has("RightEye"), "Character A requires its existing facial and body rig.")
	actor.set_expression("Sad", 0.9, 0.45)
	actor.resync(STEP, Vector3.ZERO)
	check(actor.performance.face.length() < 0.09, "Facial transition should start from the previous pose.")
	for i in 45:
		actor.resync(STEP, Vector3.ZERO)
	check(actor.performance.face.z < -0.45, "Sad expression should reach the lip corner channel.")
	actor.play_expression("Surprised", 1.0, 0.31, 0.10)
	for i in 11:
		actor.resync(STEP, Vector3.ZERO)
	check(actor.performance.face.x > 0.6, "A brief event should override the default face.")
	for i in 48:
		actor.resync(STEP, Vector3.ZERO)
	check(actor.performance.face.z < -0.45, "The default expression should return after the story cue.")
	actor.set_expression("Neutral")
	actor.set_attention(rig.to_global(Vector3(2.0, 1.52, -3.0)))
	actor.resync(STEP, Vector3.ZERO)
	check(absf(actor.performance.gaze.y) > 0.02 and absf(actor.performance.head.y) < 0.02,
		"Eyes should lead before head rotation.")
	for i in 60:
		actor.resync(STEP, Vector3.ZERO)
	check(absf(actor.performance.head.y) <= 0.721 and absf(actor.performance.gaze.y) <= 0.251,
		"Attention to a rear target must stay within angles.")
	var jaw: int = actor.bones["Jaw"]
	actor.set_viseme_weights(Vector4(1, 0, 0, 0))
	actor.resync(STEP, Vector3.ZERO)
	var closed := rig.get_bone_global_pose(jaw).basis.get_rotation_quaternion()
	actor.set_viseme_weights(Vector4(0, 1, 0, 0))
	actor.resync(STEP, Vector3.ZERO)
	var opened := rig.get_bone_global_pose(jaw).basis.get_rotation_quaternion()
	check(closed.angle_to(opened) > 0.09 and actor.visemes.y == 1.0, "External viseme weights should actuate the jaw.")
	actor.clear_viseme_override()

func check_steps(actor: Node3D) -> void:
	var rig: Skeleton3D = actor.skeleton
	actor.resync(0.0, Vector3.ZERO)
	var stationary_slip := 0.0
	var maximum_knee := 0.0
	var separation := INF
	var ground_count := 0
	var speed := 0.0
	var planted_error := 0.0
	var peak_context := Vector3.ZERO
	for i in 315:
		var desired_speed := 1.63 if i < 110 else (3.05 if i < 175 else 0.0)
		speed = move_toward(speed, desired_speed, 8.0 * STEP)
		var velocity := Vector3.BACK * speed
		var old_yaw: PackedFloat32Array = actor.planted_yaw.duplicate()
		var old_phase: PackedFloat32Array = actor.swing_progress.duplicate()
		actor.rotation.y = 0.92 * smoothstep(225, 262, i)
		actor.position += velocity * STEP
		actor.resync(STEP, velocity)
		var left := rig.get_bone_global_pose(actor.bones["FootL"]).origin
		var right := rig.get_bone_global_pose(actor.bones["FootR"]).origin
		separation = minf(separation, left.x - right.x)
		for j in 2:
			var side := "L" if j == 0 else "R"
			var thigh := rig.get_bone_global_pose(actor.bones["Thigh" + side]).origin
			var knee := rig.get_bone_global_pose(actor.bones["Shin" + side]).origin
			var shoe := rig.get_bone_global_pose(actor.bones["Foot" + side]).origin
			maximum_knee = maxf(maximum_knee, (knee - thigh).angle_to(shoe - knee))
			if actor.swing_progress[j] < 0.0 and old_phase[j] < 0.0:
				ground_count += 1
				var difference: float = rig.to_global(shoe).distance_to(actor.feet[j])
				if difference > planted_error:
					planted_error = difference
					peak_context = Vector3(i, speed, (rig.to_local(actor.feet[j]) - thigh).length())
				if i > 220:
					stationary_slip = maxf(stationary_slip, absf(angle_difference(old_yaw[j], actor.planted_yaw[j])))
	check(ground_count > 200 and stationary_slip < 0.002, "Shoes on the floor must keep their planted yaw during stops and turns.")
	print("Steps test | separation %.3f m | knee %.3f rad | planted IK error %.3f m" % [separation, maximum_knee, planted_error])
	print("Peak foot context ", peak_context)
	check(separation > 0.10 and maximum_knee < 1.53, "A forward step should maintain leg spacing and a bounded walking knee.")
	actor.position += Vector3(3.0, 0.0, 2.0)
	actor.resync(0.0, Vector3.ZERO)
	check(actor.feet[0].distance_to(rig.to_global(actor.rest["FootL"].origin)) < 0.002,
		"Teleporting should release the previous floor anchors.")

func check_behavior() -> void:
	var profile := BEHAVIOR.new()
	var same := BEHAVIOR.new()
	var different := BEHAVIOR.new()
	profile.setup(15, 0, false, false)
	same.setup(15, 0, false, false)
	different.setup(81, 2, false, false)
	var matches := 0
	var replays := true
	for i in 960:
		profile.update(0.1, true)
		same.update(0.1, true)
		different.update(0.1, true)
		matches += int(profile.state == different.state)
		replays = replays and profile.state == same.state and profile.glance == same.glance
	check(replays and profile.changes > 10 and matches < 770, "NPC profiles should diverge and still replay with their seed.")

func check_office_contacts(office: Node3D) -> void:
	office.set_process(false)
	var actor: Node3D = office.meeting_listener
	var rig: Skeleton3D = actor.skeleton
	var cup: Node3D = actor.drink_prop
	var previous := cup.global_position
	var maximum_step := 0.0
	var maximum_error := 0.0
	var lift := 0.0
	for i in 241:
		var t := i * STEP
		actor.drink_amount = smoothstep(0.1, 1.55, t) * (1.0 - smoothstep(2.32, 3.9, t))
		actor.resync(STEP, Vector3.ZERO)
		maximum_step = maxf(maximum_step, previous.distance_to(cup.global_position))
		previous = cup.global_position
		lift = maxf(lift, cup.global_position.y - actor.drink_rest.origin.y)
		if actor.drink_in_hand:
			var pad := rig.to_global(actor.fingertip("L", 0))
			maximum_error = maxf(maximum_error, pad.distance_to(cup.to_global(actor.MUG_HANDLE)))
	print("Mug test | lift %.3f m | largest frame move %.3f m | handle error %.3f m" % [lift, maximum_step, maximum_error])
	check(lift > 0.17 and maximum_step < 0.047 and maximum_error < 0.038 and cup.global_transform.is_equal_approx(actor.drink_rest),
		"The cup should reach the face, follow the grip without a jump and return to its original transform.")

func check_apartment_contacts(apartment: Node3D) -> void:
	set_meta(MAPS.QUIET_UI, true)
	await tick(3)
	var actor: Node3D = apartment.actor
	var rig: Skeleton3D = actor.skeleton
	check(actor.first_person_body and actor.first_person_head.cast_shadow == GeometryInstance3D.SHADOW_CASTING_SETTING_SHADOWS_ONLY,
		"The apartment should use the first-person rig with its head out of the color pass.")
	apartment.examine()
	await tick(38)
	var alarm_pad := rig.to_global(actor.fingertip("L", 0))
	var alarm_error: float = alarm_pad.distance_to(apartment.alarm_contact.global_position)
	print("Alarm test | pad error %.3f m" % alarm_error)
	check(not apartment.alarm_ringing and alarm_error < 0.045,
		"The physical alarm should stop when the index reaches the clock.")
	await tick(87)
	check(apartment.acting == &"free" and actor.seated == 0.0, "Clock interaction should return movement.")
	apartment.advance()
	await tick(5)
	apartment.player.position = Vector3(-0.13, 0.024, -0.85)
	await tick(3)
	apartment.examine()
	await tick(105)
	var laptop_error := 0.0
	for i in 2:
		var pad := rig.to_global(actor.fingertip("L" if i == 0 else "R", i))
		laptop_error = maxf(laptop_error, pad.distance_to(apartment.laptop_contacts[i].global_position))
	print("Laptop test | largest pad error %.3f m" % laptop_error)
	check(apartment.acting == &"laptop" and actor.seated > 0.98 and laptop_error < 0.032, "Both hands should reach the laptop surface.")
	await tick(260)
	apartment.advance()
	await tick(6)
	apartment.advance()
	await tick(89)
	check(apartment.resting and apartment.acting == &"bed" and actor.seated > 0.99,
		"The third day should end in a stable seated pose.")
