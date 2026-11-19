extends "res://scripts/story/opening_actor.gd"
## Use the supplied walk on its original skeleton and let the office controller own translation.

const WALK_CLIP := &"human_000089"
const PIVOT_DURATION := 0.25
const KNEE_FLEX_LIMIT := 1.08
const SOLE_IN_CONTACT := 0.004

var walk_player: AnimationPlayer
var walk_clip: Animation
var walk_distance := 0.0
var walk_phase := 0.0
var walk_weight := 0.0
var standing_rotations: Array[Quaternion] = []
var foot_yaw := PackedFloat32Array([0.0, 0.0])
var pivot_start_yaw := 0.0
var pivot_target_yaw := 0.0
var pivot_foot := -1
var toe_bones := PackedInt32Array()
var heel_markers: Array[Vector3] = []
var toe_markers: Array[Vector3] = []

func _ready() -> void:
	super()
	walk_player = find_children("*", "AnimationPlayer", true, false)[0] as AnimationPlayer
	walk_player.callback_mode_process = AnimationMixer.ANIMATION_CALLBACK_MODE_PROCESS_MANUAL
	walk_clip = walk_player.get_animation(WALK_CLIP)
	var hips_path := NodePath("%s:Hips" % walk_player.get_node(walk_player.root_node).get_path_to(skeleton))
	var track := walk_clip.find_track(hips_path, Animation.TYPE_POSITION_3D)
	walk_distance = walk_clip.position_track_interpolate(track, walk_clip.length).z - walk_clip.position_track_interpolate(track, 0.0).z
	walk_player.play(WALK_CLIP)
	standing_rotations.resize(skeleton.get_bone_count())
	for i in range(2):
		var side: String = SIDES[i]
		var toe := find_rig_bone(("Left" if side == "L" else "Right") + "ToeBase")
		toe_bones.append(toe)
		# The original shoe sole in bind space runs from -0.145 to +0.145 m.
		var center := 0.14 if side == "L" else -0.14
		var foot_rest: Transform3D = rest["Foot" + side]
		heel_markers.append(foot_rest.affine_inverse() * Vector3(center, 0.004, -0.139))
		toe_markers.append(skeleton.get_bone_global_rest(toe).affine_inverse() * Vector3(center, 0.004, 0.141))

func resync(delta: float, planar_velocity: Vector3) -> void:
	clock += delta
	var speed := planar_velocity.length()
	walk_phase = fposmod(walk_phase + speed * delta / walk_distance, 1.0)
	walk_weight = move_toward(walk_weight, smoothstep(0.02, 0.58, speed), delta * 5.2)
	var hips_index: int = bones["Hips"]
	var standing_hips := Vector3.ZERO
	if walk_weight < 1.0:
		pose_standing(delta)
		if walk_weight == 0.0:
			correct_feet()
			return
		standing_hips = skeleton.get_bone_pose_position(hips_index)
		for i in standing_rotations.size():
			standing_rotations[i] = skeleton.get_bone_pose_rotation(i)
	else:
		feet.clear()
		pivot_foot = -1

	walk_player.seek(walk_phase * walk_clip.length, true, true)
	var hips := skeleton.get_bone_pose_position(hips_index)
	# Keep the clip's sway and vertical weight shift. Cancel only its forward travel.
	hips.z -= walk_phase * walk_distance
	if walk_weight < 1.0:
		hips = standing_hips.lerp(hips, walk_weight)
		for i in standing_rotations.size():
			var walking_rotation := skeleton.get_bone_pose_rotation(i)
			skeleton.set_bone_pose_rotation(i, standing_rotations[i].slerp(walking_rotation, walk_weight))
	skeleton.set_bone_pose_position(hips_index, hips)
	rotate_bone("Head", Vector3(0.0, looking_out * 0.32 * walk_weight, 0.0))
	pose_fingers(0.14 * walk_weight, 0.45 * walk_weight)
	correct_feet()

func correct_feet() -> void:
	for i in range(2):
		var side: String = SIDES[i]
		var thigh_index: int = bones["Thigh" + side]
		var shin_index: int = bones["Shin" + side]
		var foot_index: int = bones["Foot" + side]
		var thigh := skeleton.get_bone_global_pose(thigh_index)
		var shin := skeleton.get_bone_global_pose(shin_index)
		var shoe := skeleton.get_bone_global_pose(foot_index)
		var upper := shin.origin - thigh.origin
		var lower := shoe.origin - shin.origin
		var upper_length := upper.length()
		var lower_length := lower.length()
		var ankle_offset := shoe.origin - thigh.origin
		var min_reach := sqrt(upper_length * upper_length + lower_length * lower_length
			+ 2.0 * upper_length * lower_length * cos(KNEE_FLEX_LIMIT))
		var target := thigh.origin + ankle_offset.normalized() * maxf(ankle_offset.length(), min_reach)
		var toe := skeleton.get_bone_global_pose(toe_bones[i])
		var sole_y := minf((shoe * heel_markers[i]).y, (toe * toe_markers[i]).y)
		target.y = maxf(target.y, shoe.origin.y + SOLE_IN_CONTACT - sole_y)
		if target.distance_squared_to(shoe.origin) < 0.000001:
			continue
		# Keep the knee on the animated bend plane and retain the roll of the shoe.
		var axis := (target - thigh.origin).normalized()
		var reach := minf(target.distance_to(thigh.origin), upper_length + lower_length - 0.001)
		var pole := upper.slide(axis)
		if pole.length_squared() < 0.00001:
			pole = Vector3.BACK.slide(axis)
		var along := (upper_length * upper_length - lower_length * lower_length + reach * reach) / (2.0 * reach)
		var new_upper := axis * along + pole.normalized() * sqrt(maxf(0.0, upper_length * upper_length - along * along))
		var new_lower := axis * reach - new_upper
		thigh.basis = Basis(Quaternion(upper.normalized(), new_upper.normalized())) * thigh.basis
		shin.basis = Basis(Quaternion(lower.normalized(), new_lower.normalized())) * shin.basis
		shin.origin = thigh.origin + new_upper
		shoe.origin = thigh.origin + axis * reach
		skeleton.set_bone_global_pose(thigh_index, thigh)
		skeleton.set_bone_global_pose(shin_index, shin)
		skeleton.set_bone_global_pose(foot_index, shoe)

func pose_standing(delta: float) -> void:
	skeleton.reset_bone_poses()
	var stance := [rest["FootL"].origin, rest["FootR"].origin]
	settle_feet(delta, stance)
	var hips: Transform3D = rest["Hips"]
	var drop := 0.011 + sin(clock * 1.65) * 0.003
	var ankles: Array[Vector3] = []
	for i in range(2):
		var side: String = SIDES[i]
		var thigh: Vector3 = rest["Thigh" + side].origin
		var knee: Vector3 = rest["Shin" + side].origin
		var ankle: Vector3 = skeleton.to_local(feet[i])
		ankles.append(ankle)
		var leg_length: float = thigh.distance_to(knee) + knee.distance_to(stance[i]) - 0.003
		var offset := thigh - ankle
		var reach_y := sqrt(maxf(0.0, leg_length * leg_length - offset.x * offset.x - offset.z * offset.z))
		drop = maxf(drop, offset.y - reach_y)
	hips.origin.y -= drop
	skeleton.set_bone_global_pose(bones["Hips"], hips)
	rotate_bone("Head", Vector3(0.018, looking_out * 0.32, 0.0))
	pose_fingers(0.43, 0.62)
	pose_relaxed_arms()
	for i in range(2):
		var side: String = SIDES[i]
		var shoe := Basis(Vector3.UP, angle_difference(global_rotation.y, foot_yaw[i]))
		solve_chain("Thigh" + side, "Shin" + side, "Foot" + side, ankles[i], Vector3.BACK, shoe)

func settle_feet(delta: float, stance: Array) -> void:
	if feet.is_empty():
		for i in range(2):
			feet.append(skeleton.to_global(stance[i]))
			foot_yaw[i] = global_rotation.y
	if pivot_foot >= 0:
		var i := pivot_foot
		var phase := minf(swing_progress[i] + delta / PIVOT_DURATION, 1.0)
		var eased := smoothstep(0.0, 1.0, phase)
		feet[i] = foot_start[i].lerp(foot_goal[i], eased) + Vector3.UP * (sin(phase * PI) * 0.035)
		foot_yaw[i] = lerp_angle(pivot_start_yaw, pivot_target_yaw, eased)
		swing_progress[i] = phase
		if phase == 1.0:
			pivot_foot = -1
		return

	var best_gap := 0.057
	for i in range(2):
		var home := skeleton.to_global(stance[i])
		var gap := feet[i].distance_to(home) + absf(angle_difference(foot_yaw[i], global_rotation.y)) * 0.14
		if gap > best_gap:
			best_gap = gap
			pivot_foot = i
			foot_goal[i] = home
	if pivot_foot >= 0:
		foot_start[pivot_foot] = feet[pivot_foot]
		swing_progress[pivot_foot] = 0.0
		pivot_start_yaw = foot_yaw[pivot_foot]
		pivot_target_yaw = global_rotation.y
