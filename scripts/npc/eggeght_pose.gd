extends Node3D
## Relaxes Eggeght's imported A-pose shoulders at runtime without modifying source GLB bytes,
## and adds a calm, subtle idle breathing motion.

var skeleton: Skeleton3D
var base_rotations: Dictionary = {}
var spine_bone := -1
var clock := 0.0

func _ready() -> void:
	var parent_npc := get_parent()
	if parent_npc == null:
		return
	var visual := parent_npc.get_node_or_null("Visual") as Node3D
	if visual != null:
		visual.rotation.y = 0.52
	skeleton = find_skeleton(parent_npc)
	if skeleton == null:
		return
	skeleton.reset_bone_poses()
	for side in ["Left", "Right"]:
		var arm_idx := bone_suffix(skeleton, side + "Arm")
		var forearm_idx := bone_suffix(skeleton, side + "ForeArm")
		if arm_idx < 0 or forearm_idx < 0:
			continue
		var pose := skeleton.get_bone_global_pose(arm_idx)
		var child := skeleton.get_bone_global_pose(forearm_idx)
		var dir := (child.origin - pose.origin).normalized()
		var desired := Vector3(0.16 if pose.origin.x > 0.0 else -0.16, -0.98, 0.06).normalized()
		var world_rot := Basis(Quaternion(dir, desired)) * pose.basis
		var p_idx := skeleton.get_bone_parent(arm_idx)
		var p_basis := skeleton.get_bone_global_pose(p_idx).basis if p_idx >= 0 else Basis.IDENTITY
		var local_q := (p_basis.inverse() * world_rot).orthonormalized().get_rotation_quaternion()
		skeleton.set_bone_pose_rotation(arm_idx, local_q)
		base_rotations[arm_idx] = local_q
	spine_bone = bone_suffix(skeleton, "Spine1")
	if spine_bone >= 0:
		base_rotations[spine_bone] = skeleton.get_bone_pose_rotation(spine_bone)

func _process(delta: float) -> void:
	if skeleton == null or spine_bone < 0:
		return
	clock += delta
	var breath := sin(clock * 1.45) * 0.018
	var sway := cos(clock * 0.72) * 0.014
	var base_q: Quaternion = base_rotations[spine_bone]
	skeleton.set_bone_pose_rotation(spine_bone, base_q * Quaternion.from_euler(Vector3(breath, sway, 0.0)))

func bone_suffix(skel: Skeleton3D, suffix: String) -> int:
	for i in range(skel.get_bone_count()):
		if skel.get_bone_name(i).ends_with(suffix):
			return i
	return -1

func find_skeleton(node: Node) -> Skeleton3D:
	if node is Skeleton3D:
		return node
	for child in node.get_children():
		var found := find_skeleton(child)
		if found != null:
			return found
	return null
