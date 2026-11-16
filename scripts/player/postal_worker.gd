extends CharacterBody3D

var blocked := false
var state := "idle"
var walk_time := 0.0
@onready var model: Node3D = $Model
var left_leg: MeshInstance3D
var right_leg: MeshInstance3D

func _ready() -> void:
	if load_user_avatar():
		return
	ForestShapes.box(model, Vector3(0,1.0,0), Vector3(0.55,0.6,0.32), "496B59")
	ForestShapes.box(model, Vector3(0,1.53,0), Vector3(0.48,0.45,0.43), "E5BA93")
	ForestShapes.cone(model, Vector3(0,1.79,0), 0.32, 0.13, "C87760", 0.27)
	for x in [-0.12,0.12]:
		ForestShapes.box(model, Vector3(x,1.56,-0.222), Vector3(0.045,0.045,0.02), "343C38")
	for x in [-0.36,0.36]:
		ForestShapes.box(model, Vector3(x,0.99,0), Vector3(0.15,0.56,0.2), "B88254")
	left_leg = ForestShapes.box(model, Vector3(-0.16,0.36,0), Vector3(0.22,0.65,0.25), "384E52")
	right_leg = ForestShapes.box(model, Vector3(0.16,0.36,0), Vector3(0.22,0.65,0.25), "384E52")
	ForestShapes.box(model, Vector3(0.34,0.8,0.12), Vector3(0.24,0.35,0.3), "C87760")

func _physics_process(delta: float) -> void:
	var input := Vector2.ZERO if blocked else Input.get_vector("move_left", "move_right", "move_up", "move_down")
	var direction := Vector3(input.x,0,input.y).rotated(Vector3.UP, PI/4)
	var speed := 4.5 if Input.is_action_pressed("jog") else 2.8
	velocity.x = move_toward(velocity.x, direction.x*speed, 12*delta)
	velocity.z = move_toward(velocity.z, direction.z*speed, 12*delta)
	velocity.y -= 20*delta
	if is_on_floor():
		velocity.y = 0
	move_and_slide()
	state = "walking" if direction.length() > 0.1 else "idle"
	if state == "walking":
		model.rotation.y = lerp_angle(model.rotation.y, atan2(-direction.x,-direction.z), 1-exp(-12*delta))
		walk_time += delta*9
	var stride := sin(walk_time)*0.22 if state == "walking" else 0.0
	if left_leg != null:
		left_leg.rotation.x = stride
	if right_leg != null:
		right_leg.rotation.x = -stride

func load_user_avatar() -> bool:
	var path := "res://assets/characters/postal_worker/base.glb"
	if not ResourceLoader.exists(path):
		return false
	var avatar: Node3D = load(path).instantiate()
	var box := FieldAssets.bounds(avatar)
	var factor := 1.8/maxf(0.001,box.size.y)
	avatar.scale *= factor
	avatar.rotation.y = PI
	avatar.position -= avatar.basis*Vector3(box.get_center().x,box.position.y,box.get_center().z)
	normalize_skin_weights(avatar)
	matte_avatar(avatar)
	model.add_child(avatar)
	var skeleton := find_skeleton(avatar)
	if skeleton != null:
		relax_arms(skeleton)
	return true

func find_skeleton(node: Node) -> Skeleton3D:
	if node is Skeleton3D:
		return node
	for child in node.get_children():
		var result := find_skeleton(child)
		if result != null:
			return result
	return null

func relax_arms(skeleton: Skeleton3D) -> void:
	# A static review pose, not an invented animation clip; skin and 52 bones stay intact.
	for bone_name in ["LeftArm","RightArm"]:
		var index := skeleton.find_bone(bone_name)
		var forearm := skeleton.find_bone("LeftForeArm" if bone_name == "LeftArm" else "RightForeArm")
		if index < 0 or forearm < 0:
			continue
		var pose := skeleton.get_bone_global_pose(index)
		var child := skeleton.get_bone_global_pose(forearm)
		var direction := (child.origin-pose.origin).normalized()
		var desired := Vector3(0.25 if pose.origin.x>0 else -0.25,-0.96,0.04).normalized()
		var world_rotation := Basis(Quaternion(direction,desired))*pose.basis
		var parent := skeleton.get_bone_parent(index)
		var parent_basis := skeleton.get_bone_global_pose(parent).basis if parent >= 0 else Basis.IDENTITY
		var local := skeleton.get_bone_rest(index).basis.inverse()*parent_basis.inverse()*world_rotation
		skeleton.set_bone_pose_rotation(index,local.orthonormalized().get_rotation_quaternion())

func matte_avatar(node: Node) -> void:
	if node is MeshInstance3D:
		for i in range(node.mesh.get_surface_count()):
			var source: Material = node.get_active_material(i)
			if source is StandardMaterial3D:
				var material: StandardMaterial3D = source.duplicate()
				material.roughness = 0.8
				material.metallic = 0.0
				node.set_surface_override_material(i,material)
	for child in node.get_children():
		matte_avatar(child)

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
