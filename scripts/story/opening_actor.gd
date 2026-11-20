extends Node3D
## The office rig uses planted foot targets and two-bone IK. Distances are metres.
@export var model: PackedScene
@export var seated_hip_drop := 0.32
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
var drink_amount := 0.0
var face_joints: Dictionary = {}
var visemes := Vector4.ZERO

var feet: Array[Vector3] = []
var foot_start: Array[Vector3] = [Vector3.ZERO, Vector3.ZERO]
var foot_goal: Array[Vector3] = [Vector3.ZERO, Vector3.ZERO]
var swing_progress := PackedFloat32Array([-1.0, -1.0])
var swing_duration := PackedFloat32Array([0.0, 0.0])
var swing_height := PackedFloat32Array([0.0, 0.0])
var gait_phase := 0.0
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
		"LeftBrow", "RightBrow", "LeftCheek", "RightCheek",
		"LeftLipCorner", "RightLipCorner", "LeftMouthCorner", "RightMouthCorner",
		"LowerLip", "UpperLip", "LowerLipCenter", "UpperLipCenter",
	]:
		var joint := find_rig_bone(part)
		if joint >= 0:
			face_joints[part] = joint
	first_person_head = visual.find_child("OfficeHead", true, false) as MeshInstance3D
	for node in visual.find_children("*", "MeshInstance3D", true, false):
		var node_mesh := node as MeshInstance3D
		if node_mesh.mesh.get_blend_shape_count() > 0:
			face_meshes.append(node_mesh)

func find_rig_bone(name: String) -> int:
	var index := skeleton.find_bone(name)
	return index if index >= 0 else skeleton.find_bone("mixamorig_" + name)

func use_first_person() -> void:
	first_person_body = true
	if first_person_head:
		first_person_head.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_SHADOWS_ONLY

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
	for index in finger_joints:
		var joint: Array = finger_joints[index]
		var hand := 0 if joint[0] == "L" else 1
		var tap_curl := 0.30 if active_digits[hand] == joint[4] else 0.12
		var curl := lerpf(rest_curl, lerpf(0.12, tap_curl, key_pressure[hand]), keyboard_weight)
		curl *= 0.65 if joint[2] == 3 else 1.0
		var relax := Quaternion.IDENTITY.slerp(joint[3], close_spread) * Quaternion(joint[1], curl)
		skeleton.set_bone_pose_rotation(index, skeleton.get_bone_pose_rotation(index) * relax)

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
	var syllable := pow(maxf(0.0, sin(clock * 19.0 + 0.80 * sin(clock * 6.2))), 1.55)
	var nod := listening * pow(maxf(0.0, sin(clock * 2.6)), 5.0) * 0.073
	rotate_bone("Chest", Vector3(sin(clock * 1.45) * 0.012 + speaking * 0.04, 0.0, sin(clock * 0.8) * 0.024))
	rotate_bone("Head", Vector3(sin(clock * 0.9) * 0.025 + nod - syllable * speaking * 0.035,
		sin(clock * 0.68) * 0.045, sin(clock * 2.1) * speaking * 0.045))
	var shape := clock * 4.6
	visemes = Vector4(0.0, syllable, sin(shape) * 0.5 + 0.5, listening * 0.24) * speaking
	pose_face()
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

func set_expression(name: String, amount := 1.0) -> void:
	face_expression = name
	expression_amount = clampf(amount, 0.0, 1.0)

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
	var drop := 0.025 + clampf(speed / 3.1, 0.0, 1.0) * 0.105
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
	hips.origin.y -= seated * seated_hip_drop + drop
	hips.origin.z -= seated * 0.03
	var breath := sin(clock * 1.8) * 0.011
	hips.origin.y += breath * (1.0 - walking_mix)
	skeleton.set_bone_global_pose(bones["Hips"], hips)
	rotate_bone("Chest", Vector3(0.045 + seated * 0.12 + sigh * 0.16, looking_out * 0.18, 0.0))
	rotate_bone("Head", Vector3(0.10 * typing + 0.10 * sigh + (0.10 * expression_amount if face_expression in ["Tired", "Sad"] else 0.0), looking_out * 0.43, thinking * 0.10))
	update_keystrokes()
	pose_fingers()
	for i in range(2):
		var side: String = SIDES[i]
		var sign_x := 1.0 if i == 0 else -1.0
		var foot: Vector3 = stance[i]
		if feet.size() == 2 and seated < 0.03:
			foot = skeleton.to_local(feet[i])
		else:
			foot.z += seated * 0.36
		solve_chain("Thigh" + side, "Shin" + side, "Foot" + side, foot, Vector3.BACK, Basis.IDENTITY)

		var hand := Vector3(sign_x * 0.211, 0.87 + breath, 0.065)
		if first_person_body:
			hand = Vector3(sign_x * 0.231, 0.79 + breath, 0.014)
		hand.z += walking_mix * (0.094 if first_person_body else 0.135) * sin(clock * 7.0 + float(i) * PI)
		var at_keyboard := Vector3(sign_x * 0.113, 0.865 + sin(clock * 15.0 + float(i) * 2.0) * 0.009 * typing, 0.46)
		var rest_at_desk := Vector3(sign_x * 0.17, 0.59, 0.25) if i == 0 else Vector3(sign_x * 0.20, 0.868, 0.42)
		hand = hand.lerp(at_keyboard.lerp(rest_at_desk, desk_rest), seated)
		var palm_amount := seated * (1.0 - desk_rest * (0.80 if i == 0 else 0.11))
		if i == 0:
			hand = hand.lerp(Vector3(0.13, 1.35 - seated * 0.30, 0.18), thinking * 0.72 * seated)
			hand = hand.lerp(Vector3(0.23, 1.02, 0.43), reach)
		var relaxed: Basis = relaxed_palms[side]
		var palm := relaxed.slerp(keyboard_palms[side], palm_amount)
		if i == 1 and mouse_prop != null and mouse_use > 0.0 and fingertip_markers.has("R0"):
			var mouse_tip := mouse_prop.to_global(Vector3(-0.011, 0.029, -0.004))
			hand = hand.lerp(wrist_for_tip(side, 0, mouse_tip, palm), mouse_use)
		if i == 0 and drink_prop != null and drink_amount > 0.0:
			var grip := skeleton.to_local(drink_rest.origin) + Vector3(0.010, 0.042, -0.028)
			var lift := smoothstep(0.38, 0.96, drink_amount)
			var mouth := skeleton.get_bone_global_pose(bones["Head"]).origin + Vector3(0.035, -0.035, 0.102)
			hand = hand.lerp(grip.lerp(mouth, lift), smoothstep(0.0, 0.50, drink_amount))
			palm = palm.slerp(keyboard_palms[side] * Basis(Vector3.FORWARD, -0.74), drink_amount)
		if active_keys[i] >= 0 and fingertip_markers.has(side + str(active_digits[i])):
			var home: int = HOME_COLUMNS[i] * KEY_ROWS + 1
			var neutral := wrist_for_tip(side, 0, key_face(home) + Vector3.UP * 0.018, palm)
			var clearance := lerpf(0.019, 0.001, key_pressure[i])
			var stroke := wrist_for_tip(side, active_digits[i], key_face(active_keys[i]) + Vector3.UP * clearance, palm)
			hand = hand.lerp(neutral.lerp(stroke, key_travel[i]), keyboard_weight)
		elif keyboard_targets.size() == 2 and fingertip_markers.has(side + "0") and (i != 0 or drink_amount <= 0.0):
			hand = wrist_for_tip(side, 0, keyboard_targets[i], palm)
		solve_chain("Arm" + side, "Forearm" + side, "Hand" + side, hand, Vector3(sign_x * 0.65, -1.0, -0.27), palm)
		if active_keys[i] >= 0:
			clear_adjacent_keys(side, active_digits[i])
	if drink_prop != null:
		var wrist := skeleton.get_bone_global_pose(bones["HandL"])
		var hold := smoothstep(0.38, 0.72, drink_amount)
		var carried := skeleton.to_global(wrist.origin + Vector3(-0.010, -0.042, 0.028))
		drink_prop.global_position = drink_rest.origin.lerp(carried, hold)
		drink_prop.global_basis = Basis(Vector3.RIGHT, -hold * 0.35) * drink_rest.basis
	pose_face()
	update_face()

func step(delta: float, motion: Vector3, stance: Array) -> void:
	if feet.is_empty():
		for foot in stance:
			feet.append(skeleton.to_global(foot))
	var speed := motion.length()
	var jog := clampf((speed - 1.5) / 1.55, 0.0, 1.0)
	var cycle := lerpf(0.80, 0.53, jog)
	var support := lerpf(0.56, 0.46, jog)
	var moving := speed > 0.11
	if moving:
		gait_phase = fposmod(gait_phase + delta / cycle, 1.0)
	for i in range(2):
		var home := skeleton.to_global(stance[i])
		var phase := fposmod(gait_phase + i * 0.5, 1.0)
		var gap := Vector2(feet[i].x - home.x, feet[i].z - home.z).length()
		if swing_progress[i] < 0.0:
			var lagging := (home - feet[i]).dot(motion.normalized()) > 0.34
			var lift := moving and (lagging or (phase >= support and gap > 0.095))
			var settle := not moving and gap > 0.072 and swing_progress[1 - i] < 0.0
			if not lift and not settle:
				continue
			foot_start[i] = feet[i]
			swing_duration[i] = cycle * (1.0 - support) if moving else 0.24
			var lead := swing_duration[i] + support * cycle * 0.49
			foot_goal[i] = home + motion * lead
			swing_height[i] = lerpf(0.062, 0.14, jog) if moving else 0.038
			swing_progress[i] = 0.0
		swing_progress[i] = minf(1.0, swing_progress[i] + delta / swing_duration[i])
		var phase_lift := swing_progress[i]
		feet[i] = foot_start[i].lerp(foot_goal[i], smoothstep(0.0, 1.0, phase_lift))
		feet[i].y += sin(phase_lift * PI) * swing_height[i]
		if phase_lift >= 1.0:
			feet[i] = foot_goal[i]
			swing_progress[i] = -1.0

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
	var bend := (pole - axis * axis.dot(pole)).normalized()
	var projection := (upper_len * upper_len - lower_len * lower_len + distance * distance) / (2.0 * distance)
	var mid := root + axis * projection + bend * sqrt(maxf(0.0, upper_len * upper_len - projection * projection))
	var tip := root + axis * distance
	var base_rotation := Basis(Quaternion((b.origin - a.origin).normalized(), (mid - root).normalized()))
	var joint_rotation := Basis(Quaternion((c.origin - b.origin).normalized(), (tip - mid).normalized()))
	skeleton.set_bone_global_pose(bones[first], Transform3D(base_rotation * a.basis, root))
	skeleton.set_bone_global_pose(bones[second], Transform3D(joint_rotation * b.basis, mid))
	skeleton.set_bone_global_pose(bones[end], Transform3D(end_rotation * c.basis, tip))

func pose_face() -> void:
	# Four weights represent closed, open, round and wide. They are driven by
	# gesture timing until recorded dialogue is available.
	var opening := clampf(visemes.y - visemes.x * 0.8, 0.0, 1.0)
	if bones.has("Jaw"):
		rotate_bone("Jaw", Vector3((opening + visemes.z * 0.25) * 0.046, 0.0, 0.0))
	var blink := maxf(0.0, 1.0 - absf(fposmod(clock + 0.7, 4.3) - 4.05) / 0.085)
	var brow := 0.0
	var smile := 0.0
	match face_expression:
		"Surprised": brow = 0.84
		"Concerned", "Thinking": brow = 0.42
		"Sad", "Tired": brow = -0.41
		"Happy": smile = 0.88
	var gaze := sin(clock * 0.47) * 0.025 + looking_out * 0.08
	for side in ["Left", "Right"]:
		var lateral := 1.0 if side == "Left" else -1.0
		adjust_face_bone(side + "Eye", Vector3.ZERO, Vector3(0, gaze, 0))
		adjust_face_bone(side + "UpperEyelid", Vector3(0, -0.006 * blink, 0))
		adjust_face_bone(side + "Brow", Vector3(0, brow * expression_amount * 0.012, 0))
		adjust_face_bone(side + "Cheek", Vector3(0, smile * expression_amount * 0.005, 0))
		var corner: String = side + "LipCorner" if face_joints.has(side + "LipCorner") else side + "MouthCorner"
		adjust_face_bone(corner, Vector3(lateral * (visemes.w * 0.003 - visemes.z * 0.002), smile * expression_amount * 0.006, 0))
	var lower := "LowerLipCenter" if face_joints.has("LowerLipCenter") else "LowerLip"
	var upper := "UpperLipCenter" if face_joints.has("UpperLipCenter") else "UpperLip"
	adjust_face_bone(lower, Vector3(0, -opening * 0.003, visemes.z * 0.002))
	adjust_face_bone(upper, Vector3(0, opening * 0.0015, visemes.z * 0.002))

func adjust_face_bone(role: String, shift: Vector3, angles := Vector3.ZERO) -> void:
	if not face_joints.has(role) or (shift == Vector3.ZERO and angles == Vector3.ZERO):
		return
	var index: int = face_joints[role]
	var pose := skeleton.get_bone_global_pose(index)
	pose.origin += shift
	pose.basis = Basis.from_euler(angles) * pose.basis
	skeleton.set_bone_global_pose(index, pose)

func update_face() -> void:
	var blink := maxf(0.0, 1.0 - absf(fposmod(clock + 0.7, 4.3) - 4.05) / 0.085)
	for visual in face_meshes:
		for index in range(visual.mesh.get_blend_shape_count()):
			var name: StringName = visual.mesh.get_blend_shape_name(index)
			var amount := expression_amount if name == face_expression else 0.0
			if name == "Blink":
				amount = blink
			visual.set_blend_shape_value(index, amount)
