extends Node3D
## The office rig uses planted foot targets and two-bone IK. Distances are metres.
@export var model: PackedScene
const MIXAMO_BONES := {
	"Hips": "Hips", "Chest": "Spine2", "Head": "Head",
	"ThighL": "LeftUpLeg", "ThighR": "RightUpLeg",
	"ShinL": "LeftLeg", "ShinR": "RightLeg", "FootL": "LeftFoot", "FootR": "RightFoot",
	"ArmL": "LeftArm", "ArmR": "RightArm",
	"ForearmL": "LeftForeArm", "ForearmR": "RightForeArm", "HandL": "LeftHand", "HandR": "RightHand",
}
const SIDES := ["L", "R"]

var skeleton: Skeleton3D
var bones := {}
var rest := {}
var keyboard_palms := {}
var relaxed_palms := {}
var finger_joints := {}
var first_person_head: MeshInstance3D
var face_meshes: Array[MeshInstance3D] = []
var face_expression := "Neutral"
var expression_amount := 0.0
var clock := 0.0
var seated := 0.0
var typing := 0.0
var desk_rest := 0.0
var looking_out := 0.0
var sigh := 0.0
var phone_amount := 0.0
var thinking := 0.0
var reach := 0.0
var phone: MeshInstance3D

var feet: Array[Vector3] = []
var foot_start: Array[Vector3] = [Vector3.ZERO, Vector3.ZERO]
var foot_goal: Array[Vector3] = [Vector3.ZERO, Vector3.ZERO]
var swing_progress := PackedFloat32Array([-1.0, -1.0])
var swing_duration := PackedFloat32Array([0.0, 0.0])
var swing_height := PackedFloat32Array([0.0, 0.0])
var gait_phase := 0.0
var walking_mix := 0.0

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
		var across := skeleton.get_bone_global_rest(index_finger).origin - skeleton.get_bone_global_rest(pinky).origin
		across = (across - forward * across.dot(forward)).normalized()
		var source := Basis(across, forward.cross(across), forward)
		var inward := Vector3.LEFT if side == "L" else Vector3.RIGHT
		var destination := Basis(inward, Vector3.BACK.cross(inward), Vector3.BACK)
		keyboard_palms[side] = destination * source.inverse()
		relaxed_palms[side] = Basis(Vector3.BACK, Vector3.DOWN.cross(Vector3.BACK), Vector3.DOWN) * source.inverse()
		for finger in ["Index", "Middle", "Ring", "Pinky"]:
			store_finger(side, body_side + "Hand" + finger)
	first_person_head = visual.find_child("OfficeHead", true, false) as MeshInstance3D
	for node in visual.find_children("*", "MeshInstance3D", true, false):
		var node_mesh := node as MeshInstance3D
		if node_mesh.mesh.get_blend_shape_count() > 0:
			face_meshes.append(node_mesh)
	phone = MeshInstance3D.new()
	var casing := BoxMesh.new()
	casing.size = Vector3(0.065, 0.12, 0.012)
	var material := StandardMaterial3D.new()
	material.albedo_color = Color("4e5f55")
	casing.material = material
	phone.mesh = casing
	add_child(phone)
	phone.hide()

func find_rig_bone(name: String) -> int:
	var index := skeleton.find_bone(name)
	return index if index >= 0 else skeleton.find_bone("mixamorig_" + name)

func use_first_person() -> void:
	if first_person_head:
		first_person_head.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_SHADOWS_ONLY

func store_finger(side: String, name: String) -> void:
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
		finger_joints[index] = [side, axis, section]

func pose_fingers() -> void:
	for index in finger_joints:
		var joint: Array = finger_joints[index]
		var side_phase := 0.0 if joint[0] == "L" else PI
		var curl := lerpf(0.25, 0.045 + 0.065 * sin(clock * 15.0 + side_phase + float(index)), seated * typing)
		curl *= 0.65 if joint[2] == 3 else 1.0
		skeleton.set_bone_pose_rotation(index, skeleton.get_bone_pose_rotation(index) * Quaternion(joint[1], curl))

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
	hips.origin.y -= seated * 0.32 + drop
	hips.origin.z -= seated * 0.03
	var breath := sin(clock * 1.8) * 0.011
	hips.origin.y += breath * (1.0 - walking_mix)
	skeleton.set_bone_global_pose(bones["Hips"], hips)
	rotate_bone("Chest", Vector3(0.045 + seated * 0.12 + sigh * 0.16, looking_out * 0.18, 0.0))
	rotate_bone("Head", Vector3(0.10 * typing + 0.22 * phone_amount + 0.10 * sigh + (0.10 * expression_amount if face_expression in ["Tired", "Sad"] else 0.0), looking_out * 0.43, thinking * 0.10))
	for i in range(2):
		var side: String = SIDES[i]
		var sign_x := 1.0 if i == 0 else -1.0
		var foot: Vector3 = stance[i]
		if feet.size() == 2 and seated < 0.03:
			foot = skeleton.to_local(feet[i])
		else:
			foot.z += seated * 0.36
		solve_chain("Thigh" + side, "Shin" + side, "Foot" + side, foot, Vector3(0, 0, 1), Basis.IDENTITY)

		var hand := Vector3(sign_x * 0.211, 0.87 + breath, 0.065)
		hand.z += walking_mix * 0.135 * sin(clock * 7.0 + float(i) * PI)
		var at_keyboard := Vector3(sign_x * 0.113, 0.865 + sin(clock * 15.0 + float(i) * 2.0) * 0.009 * typing, 0.46)
		var rest_at_desk := Vector3(sign_x * 0.17, 0.59, 0.25) if i == 0 else Vector3(sign_x * 0.20, 0.868, 0.42)
		hand = hand.lerp(at_keyboard.lerp(rest_at_desk, desk_rest), seated)
		var palm_amount := seated * (1.0 - desk_rest * (0.80 if i == 0 else 0.11))
		if i == 0:
			hand = hand.lerp(Vector3(0.18, 1.29 - seated * 0.30, 0.40), phone_amount)
			hand = hand.lerp(Vector3(0.13, 1.35 - seated * 0.30, 0.18), thinking * 0.72)
			hand = hand.lerp(Vector3(0.23, 1.02, 0.43), reach)
			palm_amount = maxf(palm_amount, phone_amount * 0.42)
		var relaxed: Basis = relaxed_palms[side]
		solve_chain("Arm" + side, "Forearm" + side, "Hand" + side, hand, Vector3(sign_x * 0.65, -1.0, -0.27), relaxed.slerp(keyboard_palms[side], palm_amount))
	pose_fingers()
	var wrist := skeleton.get_bone_global_pose(bones["HandL"])
	phone.visible = phone_amount > 0.4
	phone.position = wrist.origin + Vector3(-0.02, -0.04, 0.058)
	phone.rotation.x = -0.38
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

func update_face() -> void:
	var blink := maxf(0.0, 1.0 - absf(fposmod(clock + 0.7, 4.3) - 4.05) / 0.085)
	for visual in face_meshes:
		for index in range(visual.mesh.get_blend_shape_count()):
			var name: StringName = visual.mesh.get_blend_shape_name(index)
			var amount := expression_amount if name == face_expression else 0.0
			if name == "Blink":
				amount = blink
			visual.set_blend_shape_value(index, amount)
