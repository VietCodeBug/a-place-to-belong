extends Node3D
## The office rig uses planted foot targets and two-bone IK. Distances are metres.
@export var model: PackedScene
@export var seated_hip_drop := 0.32
const PERFORMANCE = preload("res://scripts/story/character_performance.gd")
const SAMPLE = preload("res://scripts/story/prototype/sample_cast.gd")
const MIXAMO_BONES := {
	"Hips": "Hips", "Chest": "Spine2", "Head": "Head",
	"ThighL": "LeftUpLeg", "ThighR": "RightUpLeg",
	"ShinL": "LeftLeg", "ShinR": "RightLeg", "FootL": "LeftFoot", "FootR": "RightFoot",
	"ArmL": "LeftArm", "ArmR": "RightArm",
	"ForearmL": "LeftForeArm", "ForearmR": "RightForeArm", "HandL": "LeftHand", "HandR": "RightHand",
}
const SIDES := ["L", "R"]
const RELAXED_FINGER_CURL := Vector3(0.24, 0.37, 0.18)
const TYPING_DIGITS := ["Index", "Middle", "Ring"]
const SWING_KNEE_LIMIT := 1.44
const KEY_ROWS := 3
const HOME_COLUMNS := [4, 7]
const STROKE_PATTERN := [Vector2i(0, 1), Vector2i(1, 1), Vector2i(0, 0), Vector2i(2, 1),
	Vector2i(0, 2), Vector2i(1, 2), Vector2i(0, 1), Vector2i(1, 0)]
# Pad positions on the weighted mesh, in each distal joint's local space, left then right.
const FINGER_PADS := {
	"character_a.glb": [Vector3(-0.0011, 0.0159, 0.0006), Vector3(-0.0013, 0.0180, 0.0006), Vector3(-0.0013, 0.0143, 0.0028),
		Vector3(0.0011, 0.0158, 0.0006), Vector3(0.0013, 0.0179, 0.0006), Vector3(0.0013, 0.0142, 0.0028)],
	"colleague_npc_01.glb": [Vector3(0.0054, 0.0239, -0.0014), Vector3(0.0074, 0.0235, 0.0008), Vector3(0.0057, 0.0232, 0.0002),
		Vector3(-0.0033, 0.0207, 0.0018), Vector3(-0.0046, 0.0202, -0.0026), Vector3(-0.0055, 0.0177, 0.0007)],
	"colleague_npc_02.glb": [Vector3(0.0078, 0.0297, -0.0016), Vector3(0.0100, 0.0271, -0.0041), Vector3(0.0102, 0.0255, -0.0031),
		Vector3(-0.0089, 0.0282, -0.0018), Vector3(-0.0116, 0.0261, -0.0039), Vector3(-0.0106, 0.0242, -0.0059)],
}

var skeleton: Skeleton3D
var bones := {}
var rest := {}
var keyboard_palms := {}
var relaxed_palms := {}
var palm_directions := {}
var relaxed_thumbs := {}
var finger_joints := {}
var finger_indices := {"L": [], "R": []}
var conversation_joints := {}
var fingertip_markers := {}
var keyboard_targets: Array[Vector3] = []
var keyboard_grid: Node3D
var key_caps: Array[Node3D] = []
var key_rest_height := 0.0
var key_pitch := Vector2.ZERO
var keystroke_seconds := 0.38
var keyboard_weight := 0.0
var active_keys := PackedInt32Array([-1, -1])
var active_digits := PackedInt32Array([0, 0])
var key_pressure := PackedFloat32Array([0.0, 0.0])
var key_travel := PackedFloat32Array([0.0, 0.0])
var gesture_side := "R"
var first_person_head: MeshInstance3D
var first_person_body := false
var sample: SAMPLE
var face_meshes: Array[MeshInstance3D] = []
var face_expression := "Neutral"
var expression_amount := 0.0
var clock := 0.0
var seated := 0.0
var typing := 0.0
var desk_rest := 0.0
var looking_out := 0.0
var sigh := 0.0
var thinking := 0.0
var reach := 0.0
var mouse_prop: Node3D
var mouse_use := 0.0
var drink_prop: Node3D
var drink_rest: Transform3D
var drink_home: Transform3D
var drink_amount := 0.0
var drink_in_hand := false
const MUG_HANDLE := Vector3(0.074, 0.043, 0.001)
var face_joints: Dictionary = {}
var face_shapes: Dictionary = {}
var performance := PERFORMANCE.new()
var visemes := Vector4.ZERO
var external_visemes := false
var hand_contacts: Dictionary = {}
var seated_foot_reach := 0.36
var posture_drop := 0.0
var posture_lean := 0.0
var lap_rest := 0.0

var feet: Array[Vector3] = []
var foot_start: Array[Vector3] = [Vector3.ZERO, Vector3.ZERO]
var foot_goal: Array[Vector3] = [Vector3.ZERO, Vector3.ZERO]
var swing_progress := PackedFloat32Array([-1.0, -1.0])
var swing_duration := PackedFloat32Array([0.0, 0.0])
var swing_height := PackedFloat32Array([0.0, 0.0])
var gait_phase := 0.0
var stride_speed := 0.0
var steps_started := 0
var planted_yaw := PackedFloat32Array([0.0, 0.0])
var swing_from_yaw := PackedFloat32Array([0.0, 0.0])
var swing_to_yaw := PackedFloat32Array([0.0, 0.0])
var walking_mix := 0.0
var previous_root := Vector3.INF

func _ready() -> void:
	var visual := model.instantiate()
	add_child(visual)
	skeleton = visual.find_children("*", "Skeleton3D", true, false)[0]
	for role in MIXAMO_BONES:
		var index := skeleton.find_bone(role)
		if index < 0:
			index = find_rig_bone(MIXAMO_BONES[role])
		assert(index >= 0, "Opening rig is missing bone role " + role)
		bones[role] = index
		rest[role] = skeleton.get_bone_global_rest(index)
	for side in SIDES:
		var body_side := "Left" if side == "L" else "Right"
		var middle := find_rig_bone(body_side + "HandMiddle1")
		var index_finger := find_rig_bone(body_side + "HandIndex1")
		var pinky := find_rig_bone(body_side + "HandPinky1")
		if min(middle, index_finger, pinky) < 0:
			keyboard_palms[side] = Basis(Vector3.RIGHT, -1.35)
			relaxed_palms[side] = Basis.IDENTITY
			continue
		var wrist: Transform3D = rest["Hand" + side]
		var forward := (skeleton.get_bone_global_rest(middle).origin - wrist.origin).normalized()
		palm_directions[side] = wrist.basis.inverse() * forward
		var across := skeleton.get_bone_global_rest(index_finger).origin - skeleton.get_bone_global_rest(pinky).origin
		across = (across - forward * across.dot(forward)).normalized()
		var palm_normal := forward.cross(across)
		var source := Basis(across, palm_normal, forward)
		# The thumb lies on the palm side of these bind poses.
		var thumb_tip := find_rig_bone(body_side + "HandThumb3")
		if thumb_tip >= 0 and (skeleton.get_bone_global_rest(thumb_tip).origin - wrist.origin).dot(palm_normal) < 0.0:
			palm_normal = -palm_normal
		var inward := Vector3.LEFT if side == "L" else Vector3.RIGHT
		var destination := Basis(inward, Vector3.BACK.cross(inward), Vector3.BACK)
		keyboard_palms[side] = destination * source.inverse()
		relaxed_palms[side] = Basis(Vector3.BACK, Vector3.DOWN.cross(Vector3.BACK), Vector3.DOWN) * source.inverse()
		var palm_frame := Basis(across, palm_normal, forward)
		var digits := ["Index", "Middle", "Ring", "Pinky"]
		for i in range(digits.size()):
			store_finger(side, body_side + "Hand" + digits[i], palm_frame, i)
		store_relaxed_thumb(side, body_side, (forward - across * 0.09 + palm_normal * 0.45).normalized())
		var calibrated: Array = FINGER_PADS.get(model.resource_path.get_file(), [])
		for i in range(TYPING_DIGITS.size()):
			var finger: String = body_side + "Hand" + TYPING_DIGITS[i]
			var distal := find_rig_bone(finger + "3")
			var middle_joint := find_rig_bone(finger + "2")
			if min(distal, middle_joint) < 0:
				continue
			var end := skeleton.get_bone_global_rest(distal)
			var section := end.origin - skeleton.get_bone_global_rest(middle_joint).origin
			var marker := end.basis.inverse() * section * 0.84
			if not calibrated.is_empty():
				marker = calibrated[(0 if side == "L" else 3) + i]
			fingertip_markers[side + str(i)] = [distal, marker, find_rig_bone(finger + "1")]
	var jaw := find_rig_bone("Jaw")
	if jaw >= 0:
		bones["Jaw"] = jaw
	for part in [
		"LeftEye", "RightEye", "LeftUpperEyelid", "RightUpperEyelid",
		"LeftLowerEyelid", "RightLowerEyelid",
		"LeftBrow", "RightBrow", "LeftCheek", "RightCheek",
		"LeftLipCorner", "RightLipCorner", "LeftMouthCorner", "RightMouthCorner",
		"LowerLip", "UpperLip", "LowerLipCenter", "UpperLipCenter",
	]:
		var joint := find_rig_bone(part)
		if joint >= 0:
			face_joints[part] = joint
	performance.seed_clock(hash(str(name) + ":" + str(position) + ":" + model.resource_path))
	first_person_head = visual.find_child("OfficeHead", true, false) as MeshInstance3D
	for node in visual.find_children("*", "MeshInstance3D", true, false):
		var node_mesh := node as MeshInstance3D
		if node_mesh.mesh.get_blend_shape_count() > 0:
			face_meshes.append(node_mesh)
			for index in node_mesh.mesh.get_blend_shape_count():
				face_shapes[String(node_mesh.mesh.get_blend_shape_name(index))] = true
	if SAMPLE.enabled():
		sample = SAMPLE.new()
		add_child(sample)
		sample.setup(FieldAssets.bounds(visual).size.y)
		sample.follow(skeleton,true)
		visual.hide()

func find_rig_bone(name: String) -> int:
	var index := skeleton.find_bone(name)
	return index if index >= 0 else skeleton.find_bone("mixamorig_" + name)

func use_first_person() -> void:
	first_person_body = true
	if first_person_head:
		first_person_head.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_SHADOWS_ONLY
	if sample!=null:
		sample.set_first_person()

func store_finger(side: String, name: String, palm_frame: Basis, digit: int) -> void:
	for section in range(1, 4):
		var index := find_rig_bone(name + str(section))
		var neighbor := find_rig_bone(name + str(section + 1 if section < 3 else 2))
		if index < 0 or neighbor < 0:
			continue
		var rest_pose := skeleton.get_bone_global_rest(index)
		var direction := skeleton.get_bone_global_rest(neighbor).origin - rest_pose.origin
		if section == 3:
			direction = -direction
		var axis := (rest_pose.basis.inverse() * direction.cross(Vector3.DOWN)).normalized()
		var palm_axis := (rest_pose.basis.inverse() * direction.cross(palm_frame.y)).normalized()
		var toward_palm := Quaternion.IDENTITY
		var gather := Quaternion.IDENTITY
		if section == 1:
			var local_direction := (rest_pose.basis.inverse() * direction).normalized()
			var local_palm := (rest_pose.basis.inverse() * palm_frame.z).normalized()
			toward_palm = Quaternion(local_direction, local_palm)
			# Close the outward fan in the palm plane and keep each knuckle in place.
			var local_parallel := (rest_pose.basis.inverse() * direction.slide(palm_frame.x)).normalized()
			gather = Quaternion(local_direction, local_parallel)
		finger_indices[side].append(index)
		finger_joints[index] = [side, axis, section, toward_palm, digit]
		conversation_joints[index] = [palm_axis, gather]

func store_relaxed_thumb(side: String, body_side: String, palm_forward: Vector3) -> void:
	var base := find_rig_bone(body_side + "HandThumb1")
	var joint := find_rig_bone(body_side + "HandThumb2")
	if min(base, joint) < 0:
		return
	var rest_base := skeleton.get_bone_global_rest(base)
	var direction := (skeleton.get_bone_global_rest(joint).origin - rest_base.origin).normalized()
	var local_direction := (rest_base.basis.inverse() * direction).normalized()
	var local_palm := (rest_base.basis.inverse() * palm_forward).normalized()
	var toward_palm := Quaternion(local_direction, local_palm)
	relaxed_thumbs[side] = [base, toward_palm]

func pose_fingers(rest_curl := 0.25, close_spread := 0.0) -> void:
	for side in SIDES:
		pose_hand_fingers(side, rest_curl, close_spread)

func pose_hand_fingers(side: String, rest_curl: float, close_spread: float, replace := false) -> void:
	var hand := 0 if side == "L" else 1
	for index in finger_indices[side]:
		var joint: Array = finger_joints[index]
		var tap_curl := 0.30 if active_digits[hand] == joint[4] else 0.12
		var curl := lerpf(rest_curl, lerpf(0.12, tap_curl, key_pressure[hand]), keyboard_weight)
		curl *= 0.65 if joint[2] == 3 else 1.0
		var relax := Quaternion.IDENTITY.slerp(joint[3], close_spread) * Quaternion(joint[1], curl)
		var base := skeleton.get_bone_pose_rotation(index)
		if replace:
			base = skeleton.get_bone_rest(index).basis.get_rotation_quaternion()
		skeleton.set_bone_pose_rotation(index, base * relax)

func pose_relaxed_arms(speaking := 0.0) -> void:
	for side in SIDES:
		var signed_side := 1.0 if side == "L" else -1.0
		var shoulder: Vector3 = rest["Arm" + side].origin
		var elbow: Vector3 = rest["Forearm" + side].origin
		var wrist: Vector3 = rest["Hand" + side].origin
		var arm_length := shoulder.distance_to(elbow) + elbow.distance_to(wrist)
		var shoulder_pose := skeleton.get_bone_global_pose(bones["Arm" + side])
		var hand := shoulder_pose.origin + Vector3(signed_side * 0.046, -arm_length * 0.975, 0.035)
		var palms: Basis = relaxed_palms[side]
		if side == gesture_side and speaking > 0.0:
			var accent := sin(clock * 8.1) * 0.58 + sin(clock * 4.4) * 0.42
			var hand_up := shoulder_pose.origin + Vector3(signed_side * (0.032 + accent * 0.036),
				-arm_length * 0.43 + accent * 0.043, arm_length * (0.59 + accent * 0.11))
			var half_open: Basis = Basis(Vector3.BACK, -signed_side * (0.72 + accent * 0.20)) * keyboard_palms[side]
			hand = hand.lerp(hand_up, speaking)
			palms = palms.slerp(half_open, speaking)
		solve_chain("Arm" + side, "Forearm" + side, "Hand" + side, hand,
			Vector3(signed_side * 0.48, -1.0, -0.60), palms)

func pose_conversation_hands(speaking: float) -> void:
	for index in finger_joints:
		var joint: Array = finger_joints[index]
		var gesture := speaking if joint[0] == gesture_side else 0.0
		var section: int = joint[2] - 1
		var digit: int = joint[4]
		var pose: Array = conversation_joints[index]
		var curl := RELAXED_FINGER_CURL[section] * (0.90 + 0.073 * digit)
		var gather := Quaternion.IDENTITY.slerp(pose[1], lerpf(0.93, 0.83, gesture))
		var bend := Quaternion(pose[0], curl * lerpf(1.0, 0.82, gesture))
		var rotation := gather * bend
		skeleton.set_bone_pose_rotation(index, skeleton.get_bone_pose_rotation(index) * rotation)
	for side in SIDES:
		var gesture := speaking if side == gesture_side else 0.0
		if relaxed_thumbs.has(side):
			var thumb: Array = relaxed_thumbs[side]
			var tuck := Quaternion.IDENTITY.slerp(thumb[1], lerpf(0.86, 0.73, gesture))
			skeleton.set_bone_pose_rotation(thumb[0], skeleton.get_bone_pose_rotation(thumb[0]) * tuck)
		if palm_directions.has(side):
			var index: int = bones["Hand" + side]
			var wrist := skeleton.get_bone_global_pose(index)
			var forearm := skeleton.get_bone_global_pose(bones["Forearm" + side]).origin
			var axis := (wrist.origin - forearm).normalized()
			var palm: Vector3 = (wrist.basis * palm_directions[side]).normalized()
			var aligned := axis.slerp(palm, lerpf(0.37, 0.52, gesture)).normalized()
			var turn := lerpf(0.20, 0.035, gesture) * (1.0 if side == "L" else -1.0)
			wrist.basis = Basis(aligned, turn) * Basis(Quaternion(palm, aligned)) * wrist.basis
			skeleton.set_bone_global_pose(index, wrist)

func pose_standing_coworker(delta: float, speaking := 0.0, listening := 0.0) -> void:
	clock += delta
	skeleton.reset_bone_poses()
	advance_performance(delta)
	var syllable := pow(maxf(0.0, sin(clock * 19.0 + 0.80 * sin(clock * 6.2))), 1.55)
	var nod := listening * pow(maxf(0.0, sin(clock * 2.6)), 5.0) * 0.073
	rotate_bone("Chest", Vector3(sin(clock * 1.45) * 0.012 + speaking * 0.04, 0.0, sin(clock * 0.8) * 0.024))
	apply_head(Vector3(sin(clock * 0.9) * 0.025 + nod - syllable * speaking * 0.035,
		sin(clock * 0.68) * 0.027, sin(clock * 2.1) * speaking * 0.045))
	var shape := clock * 4.6
	if not external_visemes:
		visemes = Vector4(0.05, syllable, sin(shape + sin(clock * 1.7)) * 0.35 + 0.36,
			(0.5 + 0.5 * sin(clock * 7.1)) * 0.42) * speaking
	pose_face()
	update_face()
	pose_relaxed_arms(speaking)
	pose_conversation_hands(speaking)

func fingertip(side: String, digit: int) -> Vector3:
	var tip: Array = fingertip_markers[side + str(digit)]
	return skeleton.get_bone_global_pose(tip[0]) * tip[1]

func index_fingertip(side: String) -> Vector3:
	return fingertip(side, 0)

func bind_keyboard(keyboard: Node3D) -> void:
	keyboard_grid = keyboard
	key_caps.assign(keyboard.get_children())
	key_rest_height = key_caps[0].position.y
	key_pitch = Vector2(key_caps[KEY_ROWS].position.x - key_caps[0].position.x,
		key_caps[1].position.z - key_caps[0].position.z)

func update_keystrokes() -> void:
	keyboard_weight = smoothstep(0.10, 0.76, typing) * smoothstep(0.66, 1.0, seated)
	keyboard_weight *= (1.0 - desk_rest) * (1.0 - maxf(maxf(mouse_use, drink_amount), maxf(thinking, reach)))
	for i in range(2):
		if active_keys[i] >= 0:
			key_caps[active_keys[i]].position.y = key_rest_height
		active_keys[i] = -1
		key_pressure[i] = 0.0
		key_travel[i] = 0.0
		if key_caps.is_empty() or keyboard_weight <= 0.0:
			continue
		var cycles := clock / keystroke_seconds + float(i) * 0.5
		var phase := fposmod(cycles, 1.0)
		var stroke: Vector2i = STROKE_PATTERN[posmod(floori(cycles) + i * 3, STROKE_PATTERN.size())]
		active_digits[i] = stroke.x
		var column: int = HOME_COLUMNS[i] + stroke.x * (-1 if i == 0 else 1)
		active_keys[i] = column * KEY_ROWS + stroke.y
		key_travel[i] = smoothstep(0.03, 0.28, phase) * (1.0 - smoothstep(0.70, 0.97, phase))
		key_pressure[i] = smoothstep(0.32, 0.48, phase) * (1.0 - smoothstep(0.60, 0.74, phase))
		key_caps[active_keys[i]].position.y = key_rest_height - 0.002 * key_pressure[i] * keyboard_weight

func key_face(key: int) -> Vector3:
	return key_caps[key].to_global(Vector3.UP * 0.004)

func wrist_for_tip(side: String, digit: int, target: Vector3, palm: Basis) -> Vector3:
	var wrist := skeleton.get_bone_global_pose(bones["Hand" + side])
	var offset := wrist.affine_inverse() * fingertip(side, digit)
	var basis: Basis = palm * rest["Hand" + side].basis
	return skeleton.to_local(target) - basis * offset

func clear_adjacent_keys(side: String, active_digit: int) -> void:
	var first := key_caps[0].position
	for digit in range(TYPING_DIGITS.size()):
		if digit == active_digit or not fingertip_markers.has(side + str(digit)):
			continue
		var tip := fingertip(side, digit)
		var pad := keyboard_grid.to_local(skeleton.to_global(tip))
		var col := roundi((pad.x - first.x) / key_pitch.x)
		var row := roundi((pad.z - first.z) / key_pitch.y)
		if col < 0 or col >= key_caps.size() / KEY_ROWS or row < 0 or row >= KEY_ROWS:
			continue
		var offset := pad - key_caps[col * KEY_ROWS + row].position
		var overlap := 1.0 - smoothstep(0.83, 1.22, maxf(absf(offset.x) / 0.015, absf(offset.z) / 0.014))
		var lift := (0.0055 - offset.y) * overlap * keyboard_weight
		if lift <= 0.0:
			continue
		var joint: int = fingertip_markers[side + str(digit)][2]
		var pose := skeleton.get_bone_global_pose(joint)
		var from_pivot := tip - pose.origin
		pose.basis = Basis(Quaternion(from_pivot.normalized(), (from_pivot + Vector3.UP * lift).normalized())) * pose.basis
		skeleton.set_bone_global_pose(joint, pose)

func reset_steps() -> void:
	feet.clear()
	swing_progress = PackedFloat32Array([-1.0, -1.0])
	gait_phase = 0.0
	stride_speed = 0.0
	steps_started = 0

func set_expression(name: String, amount := 1.0, blend := 0.35) -> void:
	face_expression = name
	expression_amount = clampf(amount, 0.0, 1.0)
	performance.set_face(name, expression_amount, blend)

func play_expression(name: String, amount := 1.0, hold := 0.65, blend := 0.24) -> void:
	performance.emote(name, clampf(amount, 0.0, 1.0), hold, blend)

func set_viseme_weights(weights: Vector4) -> void:
	external_visemes = true
	visemes = weights.clamp(Vector4.ZERO, Vector4.ONE)

func clear_viseme_override() -> void:
	external_visemes = false
	visemes = Vector4.ZERO

func set_attention(target: Vector3 = Vector3.INF) -> void:
	performance.look_at_world(target)

func advance_performance(delta: float) -> void:
	var head := skeleton.get_bone_global_pose(bones["Head"])
	performance.tick(delta, skeleton, head.origin + Vector3(0.0, 0.065, 0.07),
		Vector2(typing * 0.075 + sigh * 0.075, looking_out * 0.45))

func apply_head(extra: Vector3) -> void:
	rotate_bone("Head", extra + Vector3(performance.head.x, performance.head.y, 0.0))

func bind_drink(prop: Node3D) -> void:
	drink_prop = prop
	drink_home = prop.transform
	drink_rest = prop.global_transform

func set_hand_contact(side: String, target: Marker3D, weight: float, digit := 0, curl := 0.25) -> void:
	if target == null or weight <= 0.0:
		hand_contacts.erase(side)
	else:
		hand_contacts[side] = [weakref(target), clampf(weight, 0.0, 1.0), digit, curl]

func clear_hand_contacts() -> void:
	hand_contacts.clear()

func resync(delta: float, planar_velocity: Vector3) -> void:
	clock += delta
	var speed := planar_velocity.length()
	var root_position := skeleton.global_position
	# Ground contacts are in world space. A scene cut or teleport invalidates
	# both contact points, unlike a normal step or turn.
	if previous_root.is_finite() and previous_root.distance_to(root_position) > maxf(0.44, speed * delta * 2.0):
		reset_steps()
		walking_mix = 0.0
	previous_root = root_position
	walking_mix = move_toward(walking_mix, minf(speed / 1.1, 1.0), delta * 6.5)
	var stance := [rest["FootL"].origin, rest["FootR"].origin]
	if seated > 0.99:
		reset_steps()
	elif seated < 0.03:
		step(delta, planar_velocity, stance)
	skeleton.reset_bone_poses()
	var hips: Transform3D = rest["Hips"]
	var drop := 0.025 + clampf(speed / 3.1, 0.0, 1.0) * 0.067
	if feet.size() == 2 and seated < 0.03:
		for i in range(2):
			if swing_progress[i] >= 0.0:
				continue
			var side: String = SIDES[i]
			var base: Transform3D = rest["Thigh" + side]
			var knee: Transform3D = rest["Shin" + side]
			var ankle: Transform3D = rest["Foot" + side]
			var target := skeleton.to_local(feet[i])
			var delta_foot := target - base.origin
			var reach: float = base.origin.distance_to(knee.origin) + knee.origin.distance_to(ankle.origin) - 0.012
			var horizontal := Vector2(delta_foot.x, delta_foot.z).length()
			var vertical := sqrt(maxf(0.0, reach * reach - horizontal * horizontal))
			drop = maxf(drop, clampf(-delta_foot.y - vertical, 0.0, 0.21))
	hips.origin.y -= seated * seated_hip_drop + drop + posture_drop
	hips.origin.z -= seated * 0.03
	var breath := (sin(clock * 1.68) + 0.22 * sin(clock * 0.77)) * 0.006
	var weight_shift := sin(clock * 0.63) * 0.011 * (1.0 - maxf(walking_mix, seated))
	hips.origin.x += weight_shift
	hips.basis = Basis(Vector3.UP, sin(gait_phase * TAU) * 0.065 * walking_mix) * hips.basis
	hips.origin.y += breath * (1.0 - walking_mix)
	skeleton.set_bone_global_pose(bones["Hips"], hips)
	rotate_bone("Chest", Vector3(0.045 + seated * 0.12 + sigh * 0.16 - breath * 2.1 + posture_lean, looking_out * 0.18 - sin(gait_phase * TAU) * 0.084 * walking_mix, weight_shift * 1.15))
	advance_performance(delta)
	apply_head(Vector3(0.05 * sigh - minf(0.0, performance.face.y) * 0.17, 0.0, thinking * 0.10))
	update_keystrokes()
	pose_fingers(0.25 + sin(clock * 0.82) * 0.035 * (1.0 - keyboard_weight))
	if is_instance_valid(drink_prop):
		var cup_parent := drink_prop.get_parent() as Node3D
		drink_rest = cup_parent.global_transform * drink_home
	var cup_pose := drink_rest
	var cup_wrist := Vector3.ZERO
	var cup_carry := 0.0
	drink_in_hand = false
	for i in range(2):
		var side: String = SIDES[i]
		var sign_x := 1.0 if i == 0 else -1.0
		var foot: Vector3 = stance[i]
		var shoe := Basis.IDENTITY
		if feet.size() == 2 and seated < 0.03:
			foot = skeleton.to_local(feet[i])
			shoe = Basis(Vector3.UP, angle_difference(skeleton.global_rotation.y, planted_yaw[i]))
			if swing_progress[i] >= 0.0:
				var joint := skeleton.get_bone_global_pose(bones["Thigh" + side]).origin
				var thigh_length: float = rest["Thigh" + side].origin.distance_to(rest["Shin" + side].origin)
				var shin_length: float = rest["Shin" + side].origin.distance_to(rest["Foot" + side].origin)
				var minimum_reach := thigh_length * thigh_length + shin_length * shin_length + 2.0 * thigh_length * shin_length * cos(SWING_KNEE_LIMIT)
				var horizontal := Vector2(foot.x - joint.x, foot.z - joint.z).length_squared()
				foot.y = minf(foot.y, joint.y - sqrt(maxf(0.0, minimum_reach - horizontal)))
		else:
			foot.z += seated * seated_foot_reach
		solve_chain("Thigh" + side, "Shin" + side, "Foot" + side, foot, Vector3.BACK, shoe)

		var hand := Vector3(sign_x * 0.211, 0.87 + breath, 0.065)
		if first_person_body:
			hand = Vector3(sign_x * 0.231, 0.79 + breath, 0.014)
		hand.z += walking_mix * (0.094 if first_person_body else 0.135) * sin(gait_phase * TAU + float(i) * PI)
		var at_keyboard := Vector3(sign_x * 0.113, 0.865 + sin(clock * 15.0 + float(i) * 2.0) * 0.009 * typing, 0.46)
		var rest_at_desk := Vector3(sign_x * 0.17, 0.59, 0.25) if i == 0 else Vector3(sign_x * 0.20, 0.868, 0.42)
		rest_at_desk = rest_at_desk.lerp(Vector3(sign_x * 0.13, 0.57, 0.29), lap_rest)
		hand = hand.lerp(at_keyboard.lerp(rest_at_desk, desk_rest), seated)
		var palm_amount := seated * (1.0 - desk_rest * lerpf(0.80 if i == 0 else 0.11, 0.42, lap_rest))
		if i == 0:
			hand = hand.lerp(Vector3(0.13, 1.35 - seated * 0.30, 0.18), thinking * 0.72 * seated)
			hand = hand.lerp(Vector3(0.23, 1.02, 0.43), reach)
		var relaxed: Basis = relaxed_palms[side]
		var palm := relaxed.slerp(keyboard_palms[side], palm_amount)
		if i == 1 and mouse_prop != null and mouse_use > 0.0 and fingertip_markers.has("R0"):
			var mouse_tip := mouse_prop.to_global(Vector3(-0.011, 0.029, -0.004))
			hand = hand.lerp(wrist_for_tip(side, 0, mouse_tip, palm), mouse_use)
		if i == 0 and is_instance_valid(drink_prop) and drink_amount > 0.0 and fingertip_markers.has("L0"):
			var reach_cup := smoothstep(0.0, 0.34, drink_amount)
			cup_carry = smoothstep(0.38, 0.97, drink_amount)
			var close_hand := smoothstep(0.14, 0.38, drink_amount)
			var mouth := skeleton.get_bone_global_pose(bones["Head"]).origin + Vector3(-0.022, 0.035, 0.172)
			var sip_pose := drink_rest
			sip_pose.basis = skeleton.global_basis * Basis(Vector3.RIGHT, -0.34) * skeleton.global_basis.inverse() * drink_rest.basis
			sip_pose.origin = skeleton.to_global(mouth) - sip_pose.basis * Vector3(0.0, 0.084, -0.021)
			cup_pose = drink_rest.interpolate_with(sip_pose, cup_carry)
			var grip_palm: Basis = Basis(Vector3.UP, -0.19) * Basis(Vector3.BACK, -0.47) * keyboard_palms[side]
			palm = palm.slerp(grip_palm, reach_cup)
			pose_hand_fingers(side, lerpf(0.25, 0.68, close_hand), close_hand * 0.52, true)
			if relaxed_thumbs.has(side):
				var thumb: Array = relaxed_thumbs[side]
				var thumb_rest := skeleton.get_bone_rest(thumb[0]).basis.get_rotation_quaternion()
				skeleton.set_bone_pose_rotation(thumb[0], thumb_rest * Quaternion.IDENTITY.slerp(thumb[1], close_hand * 0.78))
			cup_wrist = wrist_for_tip(side, 0, cup_pose * MUG_HANDLE, palm)
			hand = hand.lerp(cup_wrist, reach_cup)
		if active_keys[i] >= 0 and fingertip_markers.has(side + str(active_digits[i])):
			var home: int = HOME_COLUMNS[i] * KEY_ROWS + 1
			var neutral := wrist_for_tip(side, 0, key_face(home) + Vector3.UP * 0.018, palm)
			var clearance := lerpf(0.019, 0.001, key_pressure[i])
			var stroke := wrist_for_tip(side, active_digits[i], key_face(active_keys[i]) + Vector3.UP * clearance, palm)
			hand = hand.lerp(neutral.lerp(stroke, key_travel[i]), keyboard_weight)
		elif keyboard_targets.size() == 2 and fingertip_markers.has(side + "0") and (i != 0 or drink_amount <= 0.0):
			hand = wrist_for_tip(side, 0, keyboard_targets[i], palm)
		if hand_contacts.has(side):
			var contact: Array = hand_contacts[side]
			var marker := (contact[0] as WeakRef).get_ref() as Marker3D
			if is_instance_valid(marker) and marker.is_inside_tree():
				var contact_weight: float = contact[1]
				var contact_palm := (skeleton.global_basis.inverse() * marker.global_basis).orthonormalized()
				palm = palm.slerp(contact_palm * keyboard_palms[side], contact_weight)
				pose_hand_fingers(side, lerpf(0.25, contact[3], contact_weight), 0.25, true)
				var contact_point := skeleton.to_local(marker.global_position)
				if contact[2] >= 0 and fingertip_markers.has(side + str(contact[2])):
					contact_point = wrist_for_tip(side, contact[2], marker.global_position, palm)
				hand = hand.lerp(contact_point, contact_weight)
		solve_chain("Arm" + side, "Forearm" + side, "Hand" + side, hand, Vector3(sign_x * 0.65, -1.0, -0.27), palm)
		if active_keys[i] >= 0:
			clear_adjacent_keys(side, active_digits[i])
	if is_instance_valid(drink_prop):
		if cup_carry > 0.0:
			var wrist := skeleton.get_bone_global_pose(bones["HandL"])
			var error := skeleton.global_basis * (wrist.origin - cup_wrist)
			# Preserve handle contact when the arm's calibrated reach clamps the lift.
			cup_pose.origin += error * smoothstep(0.0, 0.16, cup_carry)
			drink_in_hand = (error.length() < 0.037 or cup_carry > 0.16)
		drink_prop.global_transform = cup_pose
	pose_face()
	update_face()

func step(delta: float, motion: Vector3, stance: Array) -> void:
	var facing := skeleton.global_rotation.y
	if feet.is_empty():
		for i in range(2):
			feet.append(skeleton.to_global(stance[i]))
			planted_yaw[i] = facing
	var speed := motion.length()
	var direction := motion.normalized()
	stride_speed = move_toward(stride_speed, speed, delta * (7.0 if speed > stride_speed else 10.0))
	var jog := smoothstep(1.5, 3.05, stride_speed)
	var cycle := lerpf(0.82, 0.54, jog)
	var support := lerpf(0.58, 0.49, jog)
	var moving := speed > 0.11
	if moving:
		gait_phase = fposmod(gait_phase + delta / cycle, 1.0)
	for i in range(2):
		var home := skeleton.to_global(stance[i])
		var phase := fposmod(gait_phase + i * 0.5, 1.0)
		var gap := Vector2(feet[i].x - home.x, feet[i].z - home.z).length()
		var yaw_gap := absf(angle_difference(planted_yaw[i], facing))
		if swing_progress[i] < 0.0:
			var trailing := (home - feet[i]).dot(direction)
			var other_trailing := (skeleton.to_global(stance[1 - i]) - feet[1 - i]).dot(direction)
			var other_swing := swing_progress[1 - i]
			var free_to_lift := other_swing < 0.0 or (jog > 0.65 and other_swing > 0.73)
			# Only the trailing foot may leave support. The lead foot can have a
			# large gap after striking and must not immediately swing again.
			var first_step := steps_started == 0
			var threshold := 0.065 if first_step else lerpf(0.13, 0.20, jog) + (0.04 if phase < support else 0.0)
			var lift := moving and free_to_lift and trailing >= threshold and trailing >= other_trailing - 0.025
			var settle := not moving and (gap > 0.065 or yaw_gap > 0.30) and other_swing < 0.0
			if not lift and not settle:
				continue
			foot_start[i] = feet[i]
			swing_from_yaw[i] = planted_yaw[i]
			swing_to_yaw[i] = facing
			swing_duration[i] = lerpf(0.29, 0.232, jog) if moving and not first_step else 0.23
			steps_started += int(lift)
			foot_goal[i] = step_landing(i, home, motion, swing_duration[i], support * cycle * 0.44)
			swing_height[i] = lerpf(0.058, 0.098, jog) if moving else 0.035
			swing_progress[i] = 0.0
		swing_progress[i] = minf(1.0, swing_progress[i] + delta / swing_duration[i])
		var swing := swing_progress[i]
		var eased := smoothstep(0.0, 1.0, swing)
		# Track a changing root forecast early in the swing, then commit to contact.
		if swing < 0.72:
			var time_to_land := (1.0 - swing) * swing_duration[i]
			var landing := step_landing(i, home, motion, time_to_land, support * cycle * 0.44)
			foot_goal[i] = foot_goal[i].lerp(landing, 1.0 - exp(-12.0 * delta))
		feet[i] = foot_start[i].lerp(foot_goal[i], eased)
		feet[i].y += sin(swing * PI) * swing_height[i]
		planted_yaw[i] = lerp_angle(swing_from_yaw[i], swing_to_yaw[i], eased)
		if swing >= 1.0:
			feet[i] = foot_goal[i]
			swing_progress[i] = -1.0

func step_landing(side: int, home: Vector3, motion: Vector3, travel_time: float, contact_lead: float) -> Vector3:
	var basis_local := skeleton.global_basis
	var local_motion := basis_local.inverse() * motion
	var lead := (local_motion * contact_lead).limit_length(0.38)
	lead.x = maxf(lead.x, -0.096) if side == 0 else minf(lead.x, 0.096)
	return home + motion * travel_time + basis_local * lead

func rotate_bone(name: String, angles: Vector3) -> void:
	var index: int = bones[name]
	var pose := skeleton.get_bone_global_pose(index)
	pose.basis = Basis.from_euler(angles) * pose.basis
	skeleton.set_bone_global_pose(index, pose)

func solve_chain(first: String, second: String, end: String, target: Vector3, pole: Vector3, end_rotation: Basis) -> void:
	var root := skeleton.get_bone_global_pose(bones[first]).origin
	var a: Transform3D = rest[first]
	var b: Transform3D = rest[second]
	var c: Transform3D = rest[end]
	var upper_len := a.origin.distance_to(b.origin)
	var lower_len := b.origin.distance_to(c.origin)
	var axis := (target - root).normalized()
	if axis.length_squared() < 0.01:
		axis = Vector3.DOWN
	var distance := clampf(root.distance_to(target), absf(upper_len - lower_len) + 0.001, upper_len + lower_len - 0.002)
	var bend := pole.slide(axis)
	if bend.length_squared() < 0.00001:
		var fallback := Vector3.RIGHT if absf(axis.x) < 0.8 else Vector3.FORWARD
		bend = fallback.slide(axis)
	bend = bend.normalized()
	var projection := (upper_len * upper_len - lower_len * lower_len + distance * distance) / (2.0 * distance)
	var mid := root + axis * projection + bend * sqrt(maxf(0.0, upper_len * upper_len - projection * projection))
	var tip := root + axis * distance
	var base_rotation := Basis(Quaternion((b.origin - a.origin).normalized(), (mid - root).normalized()))
	var joint_rotation := Basis(Quaternion((c.origin - b.origin).normalized(), (tip - mid).normalized()))
	skeleton.set_bone_global_pose(bones[first], Transform3D(base_rotation * a.basis, root))
	skeleton.set_bone_global_pose(bones[second], Transform3D(joint_rotation * b.basis, mid))
	skeleton.set_bone_global_pose(bones[end], Transform3D(end_rotation * c.basis, tip))

func pose_face() -> void:
	# Shape ownership is exclusive if a future import provides expression shapes.
	var expression := Vector4.ZERO if face_shapes.has(face_expression) else performance.face
	var blink := 0.0 if face_shapes.has("Blink") else performance.blink
	var opening := clampf(visemes.y - visemes.x * 0.80 + expression.w, 0.0, 1.0)
	var rich_face := face_joints.has("LeftEye")
	var roundness := visemes.z
	var width := visemes.w - roundness * 0.72
	if bones.has("Jaw"):
		rotate_bone("Jaw", Vector3((opening + roundness * 0.15) * (0.17 if rich_face else 0.061), 0.0, 0.0))
	for side in ["Left", "Right"]:
		var lateral := 1.0 if side == "Left" else -1.0
		var gaze := performance.gaze
		adjust_face_bone(side + "Eye", Vector3.ZERO, Vector3(gaze.x, gaze.y, 0.0))
		adjust_face_bone(side + "UpperEyelid", Vector3(0, expression.y * 0.014 - 0.012 * blink, 0))
		adjust_face_bone(side + "LowerEyelid", Vector3(0, -expression.y * 0.005 + blink * 0.004, 0))
		var inward := maxf(0.0, -expression.z) * 0.007
		adjust_face_bone(side + "Brow", Vector3(-inward * lateral, expression.x * (0.020 - inward), 0),
			Vector3(0, 0, lateral * inward * 7.0))
		adjust_face_bone(side + "Cheek", Vector3(0, maxf(0.0, expression.z) * 0.009, 0))
		var corner: String = side + "LipCorner" if face_joints.has(side + "LipCorner") else side + "MouthCorner"
		adjust_face_bone(corner, Vector3(lateral * (width * 0.006 + maxf(0.0, expression.z) * 0.003),
			expression.z * (0.013 if rich_face else 0.006), roundness * 0.002))
	var lower := "LowerLipCenter" if face_joints.has("LowerLipCenter") else "LowerLip"
	var upper := "UpperLipCenter" if face_joints.has("UpperLipCenter") else "UpperLip"
	adjust_face_bone(lower, Vector3(0, -opening * (0.007 if rich_face else 0.003), roundness * 0.004))
	adjust_face_bone(upper, Vector3(0, opening * 0.003, roundness * 0.003))

func adjust_face_bone(role: String, shift: Vector3, angles := Vector3.ZERO) -> void:
	if not face_joints.has(role) or (shift == Vector3.ZERO and angles == Vector3.ZERO):
		return
	var index: int = face_joints[role]
	var pose := skeleton.get_bone_global_pose(index)
	pose.origin += shift
	pose.basis = Basis.from_euler(angles) * pose.basis
	skeleton.set_bone_global_pose(index, pose)

func update_face() -> void:
	var blink := performance.blink
	for visual in face_meshes:
		for index in range(visual.mesh.get_blend_shape_count()):
			var name: StringName = visual.mesh.get_blend_shape_name(index)
			var amount := expression_amount if name == face_expression else 0.0
			if name == "Blink":
				amount = blink
			visual.set_blend_shape_value(index, amount)
