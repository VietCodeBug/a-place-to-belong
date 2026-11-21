extends CharacterBody3D
## Samatha is the temporary player; retain supplied textures and animation clips.
const AVATAR = preload("res://assets/characters/samatha/samatha.glb")
var blocked := false
var eyes: RefCounted
var superworld: Node3D
var state := "idle"
@onready var model: Node3D = $Model
var animation_player: AnimationPlayer
var avatar_skeleton: Skeleton3D
var idle_arms: Dictionary = {}
var idle_applied := false
var walking_clip := ""
var running_clip := ""

func _ready() -> void:
	var avatar: Node3D = AVATAR.instantiate()
	var box := FieldAssets.bounds(avatar)
	avatar.scale *= 1.7/maxf(0.001,box.size.y)
	avatar.rotation.y = PI
	avatar.position -= avatar.basis*Vector3(box.get_center().x,box.position.y,box.get_center().z)
	normalize_skin_weights(avatar)
	model.add_child(avatar)
	avatar_skeleton = find_skeleton(avatar)
	animation_player = find_animation_player(avatar)
	if animation_player != null:
		for clip in animation_player.get_animation_list():
			if clip == "RESET":
				continue
			animation_player.get_animation(clip).loop_mode = Animation.LOOP_LINEAR
			if clip.ends_with("Walking"): walking_clip = clip
			if clip.ends_with("Running"): running_clip = clip
	prepare_idle_arms()
	update_animation(false,false)

func _physics_process(delta: float) -> void:
	var input := Vector2.ZERO if blocked else Input.get_vector("move_left", "move_right", "move_up", "move_down")
	var direction := Vector3(input.x,0,input.y).rotated(Vector3.UP,eyes.yaw if eyes!=null else PI/4)
	if superworld != null and superworld.lake.contains(position):
		superworld.lake.swim(self,direction,blocked,delta)
		state = "swimming"
		if direction.length_squared()>.01:
			model.rotation.y = lerp_angle(model.rotation.y,atan2(-direction.x,-direction.z),1-exp(-12*delta))
		update_animation(false,false)
		return
	var speed := 4.5 if Input.is_action_pressed("jog") else 2.8
	velocity.x = move_toward(velocity.x, direction.x*speed, 12*delta)
	velocity.z = move_toward(velocity.z, direction.z*speed, 12*delta)
	velocity.y -= 20*delta
	if is_on_floor():
		velocity.y = 0
	move_and_slide()
	if superworld != null:
		var limit: Rect2 = superworld.field.bounds.grow(-1.0)
		position.x = clampf(position.x,limit.position.x,limit.end.x)
		position.z = clampf(position.z,limit.position.y,limit.end.y)
	state = "walking" if direction.length() > 0.1 else "idle"
	if state == "walking":
		model.rotation.y = lerp_angle(model.rotation.y, atan2(-direction.x,-direction.z), 1-exp(-12*delta))
	update_animation(state == "walking",Input.is_action_pressed("jog"))


func update_animation(moving: bool, jogging: bool) -> void:
	if moving and animation_player != null:
		idle_applied = false
		var clip := running_clip if jogging else walking_clip
		if not clip.is_empty() and (not animation_player.is_playing() or animation_player.current_animation != clip):
			animation_player.play(clip,0.15)
	elif not idle_applied:
		if animation_player != null:
			animation_player.stop()
		if avatar_skeleton != null:
			avatar_skeleton.reset_bone_poses()
			for index in idle_arms:
				avatar_skeleton.set_bone_pose_rotation(index,idle_arms[index])
		idle_applied = true

func prepare_idle_arms() -> void:
	# No idle clip was supplied: use a quiet static pose, not the walking cycle.
	if avatar_skeleton == null: return
	avatar_skeleton.reset_bone_poses()
	for side in ["Left","Right"]:
		var index := bone_suffix(avatar_skeleton,side+"Arm")
		var forearm := bone_suffix(avatar_skeleton,side+"ForeArm")
		if index < 0 or forearm < 0: continue
		var pose := avatar_skeleton.get_bone_global_pose(index)
		var child := avatar_skeleton.get_bone_global_pose(forearm)
		var direction := (child.origin-pose.origin).normalized()
		var desired := Vector3(0.18 if pose.origin.x>0 else -0.18,-0.98,0.03).normalized()
		var world_rotation := Basis(Quaternion(direction,desired))*pose.basis
		var parent := avatar_skeleton.get_bone_parent(index)
		var parent_basis := avatar_skeleton.get_bone_global_pose(parent).basis if parent >= 0 else Basis.IDENTITY
		var local := parent_basis.inverse()*world_rotation
		idle_arms[index] = local.orthonormalized().get_rotation_quaternion()

func bone_suffix(skeleton: Skeleton3D, suffix: String) -> int:
	for index in range(skeleton.get_bone_count()):
		if skeleton.get_bone_name(index).ends_with(suffix): return index
	return -1

func find_skeleton(node: Node) -> Skeleton3D:
	if node is Skeleton3D: return node
	for child in node.get_children():
		var result := find_skeleton(child)
		if result != null: return result
	return null

func find_animation_player(node: Node) -> AnimationPlayer:
	if node is AnimationPlayer: return node
	for child in node.get_children():
		var result := find_animation_player(child)
		if result != null: return result
	return null

func normalize_skin_weights(node: Node) -> void:
	# Preserve the source GLB; normalize its imported skin weights on a runtime mesh copy.
	if node is MeshInstance3D and node.mesh != null:
		var normalized := ArrayMesh.new()
		for surface in range(node.mesh.get_surface_count()):
			var arrays: Array = node.mesh.surface_get_arrays(surface)
			var weights: PackedFloat32Array = arrays[Mesh.ARRAY_WEIGHTS]
			var flags: int = node.mesh.surface_get_format(surface) & Mesh.ARRAY_FLAG_USE_8_BONE_WEIGHTS
			var influences := 8 if flags else 4
			for offset in range(0,weights.size(),influences):
				var total := 0.0
				for influence in range(influences):
					total += weights[offset+influence]
				if total > 0:
					for influence in range(influences):
						weights[offset+influence] /= total
			arrays[Mesh.ARRAY_WEIGHTS] = weights
			normalized.add_surface_from_arrays(node.mesh.surface_get_primitive_type(surface),arrays,[],{},flags)
			normalized.surface_set_material(surface,node.mesh.surface_get_material(surface))
		node.mesh = normalized
	for child in node.get_children():
		normalize_skin_weights(child)
