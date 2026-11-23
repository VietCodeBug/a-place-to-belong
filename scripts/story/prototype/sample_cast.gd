extends Node3D
## Temporary shared presentation for the Pixiv VRM sample.

const MODEL = preload("res://assets/characters/pixiv_vrm_sample/pixiv_twist_sample.glb")
const MANIFEST = preload("res://assets/characters/pixiv_vrm_sample/manifest.json")
const AXES := {
	"X": Vector3.RIGHT, "Y": Vector3.UP, "Z": Vector3.BACK,
	"PositiveX": Vector3.RIGHT, "NegativeX": Vector3.LEFT, "NegativeY": Vector3.DOWN,
}
const ROLES := [
	"Hips","Spine","Spine1","Spine2","Neck","Head",
	"LeftShoulder","LeftArm","LeftForeArm","LeftHand","RightShoulder","RightArm","RightForeArm","RightHand",
	"LeftUpLeg","LeftLeg","LeftFoot","LeftToeBase","RightUpLeg","RightLeg","RightFoot","RightToeBase",
]
const FINGERS := ["Thumb","Index","Middle","Ring","Pinky"]
var rig: Skeleton3D
var joints: Dictionary[String, int] = {}
var rotators: Array[Array] = []
var aimers: Array[Array] = []
var driven: Array[Array] = []
var arm_contacts: Array[Array] = []
var driver: Skeleton3D
var motion_scale := 1.0
var root_joint := -1
var source_root_joint := -1
var idle_rotation: Dictionary[int, Quaternion] = {}

static func enabled() -> bool:
	return not "--original-cast" in OS.get_cmdline_user_args()

func setup(height: float, faces_negative_z := false) -> void:
	name = "TemporaryPixivCast"
	var character := MODEL.instantiate() as Node3D
	add_child(character)
	var box := FieldAssets.bounds(character)
	var factor := height / maxf(.01, box.size.y)
	character.scale = Vector3.ONE * factor
	character.rotation.y = PI if faces_negative_z else 0.0
	character.position = -(character.basis * Vector3(box.get_center().x,box.position.y,box.get_center().z))
	rig = character.find_children("*","Skeleton3D",true,false)[0] as Skeleton3D
	for role in ROLES:
		joints[role] = rig.find_bone(role)
	for side in ["Left", "Right"]:
		for finger in FINGERS:
			for segment in range(1, 4):
				var label: String = side + "Hand" + finger + str(segment)
				joints[label] = rig.find_bone(label)
		var arm := joints[side + "Arm"]
		var forearm := joints[side + "ForeArm"]
		var start := rig.get_bone_global_rest(arm)
		var straight := (rig.get_bone_global_rest(forearm).origin - start.origin).normalized()
		var relaxed := Vector3(signf(start.origin.x)*.20,-.97,.03).normalized()
		idle_rotation[arm] = local_delta(arm,Quaternion(straight,relaxed))
	for row: Array in MANIFEST.data.constraints:
		var target := rig.find_bone(row[0])
		var origin := rig.find_bone(row[1])
		assert(mini(target,origin)>=0,"Pixiv constraint lost its bound joint")
		var axis: Vector3 = AXES[row[3]]
		var rule := [target,origin,axis,float(row[4])]
		if row[2]=="aim":
			aimers.append(rule)
		else:
			rotators.append(rule)
	pose_idle()
	set_process(false)

func pose_idle() -> void:
	rig.reset_bone_poses()
	for arm in idle_rotation:
		rig.set_bone_pose_rotation(arm,idle_rotation[arm])
	apply_constraints()

func set_first_person() -> void:
	# Separate Face and Hair can shadow without drawing in front of the eye camera.
	for part: MeshInstance3D in find_children("*","MeshInstance3D",true,false):
		if part.name in [&"Face",&"Hair"]:
			part.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_SHADOWS_ONLY

func follow(source: Skeleton3D, match_wrist_positions := false) -> void:
	driver = source
	var source_roles: Dictionary[String,int] = {}
	for index in source.get_bone_count():
		var label := String(source.get_bone_name(index)).trim_prefix("mixamorig_").trim_prefix("mixamorig:")
		source_roles[label] = index
	source_root_joint = source_roles.get("Hips",-1)
	root_joint = joints["Hips"]
	if source_root_joint>=0:
		# Only the locomotion/root offset is copied. Limbs keep their own proportions.
		motion_scale = rig.get_bone_global_rest(root_joint).origin.y / maxf(.01,source.get_bone_global_rest(source_root_joint).origin.y)
	var palms: Dictionary[String,Basis] = {}
	for side in ["Left", "Right"]:
		if not source_roles.has(side+"HandIndex1") or not source_roles.has(side+"HandPinky1"):
			continue
		if not source_roles.has(side+"HandMiddle1") or not source_roles.has(side+"Hand"):
			continue
		palms[side] = palm_frame(source,source_roles,side)*palm_frame(rig,joints,side).inverse()
		if match_wrist_positions:
			arm_contacts.append([joints[side+"Arm"],joints[side+"ForeArm"],joints[side+"Hand"],source_roles[side+"ForeArm"],source_roles[side+"Hand"]])
	for label in joints:
		var source_index: int = source_roles.get(label,-1)
		if source_index<0 or joints[label]<0:
			continue
		var target := joints[label]
		var input_basis := source.get_bone_global_rest(source_index).basis.orthonormalized()
		var output_basis := rig.get_bone_global_rest(target).basis.orthonormalized()
		var correction := Basis.IDENTITY
		if label.begins_with("LeftHand"):
			correction = palms.get("Left",Basis.IDENTITY)
		elif label.begins_with("RightHand"):
			correction = palms.get("Right",Basis.IDENTITY)
		driven.append([target,source_index,input_basis.inverse()*correction*output_basis])
	driven.sort_custom(func(a: Array,b: Array) -> bool: return int(a[0])<int(b[0]))
	if not driven.is_empty():
		sync_driver()
	set_process(not driven.is_empty())

func palm_frame(skeleton: Skeleton3D, indices: Dictionary[String,int], side: String) -> Basis:
	var hand := skeleton.get_bone_global_rest(indices[side+"Hand"]).origin
	var forward := (skeleton.get_bone_global_rest(indices[side+"HandMiddle1"]).origin-hand).normalized()
	var across := skeleton.get_bone_global_rest(indices[side+"HandIndex1"]).origin-skeleton.get_bone_global_rest(indices[side+"HandPinky1"]).origin
	across = across.slide(forward).normalized()
	return Basis(across,forward.cross(across),forward)

func _process(_delta: float) -> void:
	sync_driver()

func sync_driver() -> void:
	if not is_instance_valid(driver):
		return
	if source_root_joint>=0:
		var root_motion := driver.get_bone_pose_position(source_root_joint) - driver.get_bone_rest(source_root_joint).origin
		rig.set_bone_pose_position(root_joint,rig.get_bone_rest(root_joint).origin + root_motion*motion_scale)
	for link: Array in driven:
		var target: int = link[0]
		var pose := rig.get_bone_global_pose(target)
		pose.basis = (driver.get_bone_global_pose(link[1]).basis * link[2]).orthonormalized()
		rig.set_bone_global_pose(target,pose)
	for contact: Array in arm_contacts:
		match_wrist(contact)
	apply_constraints()

func match_wrist(contact: Array) -> void:
	var upper := rig.get_bone_global_pose(contact[0])
	var lower := rig.get_bone_global_pose(contact[1])
	var wrist := rig.get_bone_global_pose(contact[2])
	var target := rig.to_local(driver.to_global(driver.get_bone_global_pose(contact[4]).origin))
	var source_elbow := rig.to_local(driver.to_global(driver.get_bone_global_pose(contact[3]).origin))
	var upper_segment := lower.origin-upper.origin
	var lower_segment := wrist.origin-lower.origin
	var length_a := upper_segment.length()
	var length_b := lower_segment.length()
	var axis := (target-upper.origin).normalized()
	var distance := clampf(target.distance_to(upper.origin),absf(length_a-length_b)+.002,length_a+length_b-.002)
	var bend := (source_elbow-upper.origin).slide(axis).normalized()
	if bend.length_squared()<.001:
		bend = Vector3.DOWN.slide(axis).normalized()
	var along := (length_a*length_a-length_b*length_b+distance*distance)/(2.0*distance)
	var upper_direction := axis*along+bend*sqrt(maxf(0.0,length_a*length_a-along*along))
	var lower_direction := axis*distance-upper_direction
	upper.basis = Basis(Quaternion(upper_segment.normalized(),upper_direction.normalized()))*upper.basis
	lower.basis = Basis(Quaternion(lower_segment.normalized(),lower_direction.normalized()))*lower.basis
	lower.origin = upper.origin+upper_direction
	wrist.origin = upper.origin+axis*distance
	rig.set_bone_global_pose(contact[0],upper)
	rig.set_bone_global_pose(contact[1],lower)
	rig.set_bone_global_pose(contact[2],wrist)

func local_delta(index: int, rotation: Quaternion) -> Quaternion:
	var basis := rig.get_bone_global_rest(index).basis.orthonormalized().get_rotation_quaternion()
	var base := rig.get_bone_rest(index).basis.orthonormalized().get_rotation_quaternion()
	return base * basis.inverse() * rotation * basis

func swing(role: String, axis: Vector3, angle: float) -> void:
	var index := joints[role]
	var rest := rig.get_bone_rest(index).basis.orthonormalized().get_rotation_quaternion()
	var delta := rest.inverse() * local_delta(index,Quaternion(axis,angle))
	var previous := rig.get_bone_pose_rotation(index)
	rig.set_bone_pose_rotation(index,previous * delta)

func village_pose(left: float, right: float, stride: float, glance: Vector2, chopping: bool, holding: bool) -> void:
	rig.reset_bone_poses()
	for arm in idle_rotation:
		rig.set_bone_pose_rotation(arm,idle_rotation[arm])
	swing("LeftArm",Vector3.RIGHT,-left)
	swing("RightArm",Vector3.RIGHT,-right)
	swing("LeftUpLeg",Vector3.RIGHT,-stride)
	swing("RightUpLeg",Vector3.RIGHT,stride)
	swing("LeftLeg",Vector3.RIGHT,maxf(0.0,stride)*.71)
	swing("RightLeg",Vector3.RIGHT,maxf(0.0,-stride)*.71)
	swing("Head",Vector3.RIGHT,-glance.x)
	swing("Head",Vector3.UP,glance.y)
	if chopping or holding:
		swing("RightForeArm",Vector3.UP,-.33)
		close_hand("Right",.53)
	apply_constraints()

func close_hand(side: String, amount: float) -> void:
	var wrist := rig.get_bone_global_rest(joints[side+"Hand"]).origin
	var ahead := (rig.get_bone_global_rest(joints[side+"HandMiddle1"]).origin-wrist).normalized()
	var across := rig.get_bone_global_rest(joints[side+"HandIndex1"]).origin-rig.get_bone_global_rest(joints[side+"HandPinky1"]).origin
	var palm := ahead.cross(across).normalized()
	if palm.y>0.0:
		palm = -palm
	for finger in ["Index","Middle","Ring","Pinky"]:
		for segment in range(1,4):
			var label: String = side+"Hand"+finger
			var joint := joints[label+str(segment)]
			var direction := rig.get_bone_global_rest(joints[label+str(2 if segment==3 else segment+1)]).origin-rig.get_bone_global_rest(joint).origin
			if segment==3:
				direction = -direction
			swing(label+str(segment),direction.cross(palm).normalized(),amount*[.74,1.0,.70][segment-1])

func grip(prop: Node3D) -> void:
	var wrist := joints["RightHand"]
	var hand := rig.get_bone_global_rest(wrist)
	var knuckle := rig.get_bone_global_rest(joints["RightHandMiddle1"]).origin
	var across := rig.get_bone_global_rest(joints["RightHandIndex1"]).origin-rig.get_bone_global_rest(joints["RightHandPinky1"]).origin
	var forward := (knuckle-hand.origin).normalized()
	var shaft := across.slide(forward).normalized()
	var attachment := BoneAttachment3D.new()
	attachment.bone_name = rig.get_bone_name(wrist)
	rig.add_child(attachment)
	var palm_marker := Node3D.new()
	attachment.add_child(palm_marker)
	palm_marker.transform = hand.affine_inverse()*Transform3D(Basis(forward,forward.cross(-shaft),-shaft),hand.origin.lerp(knuckle,.65))
	prop.reparent(palm_marker,false)
	prop.transform = Transform3D.IDENTITY

func apply_constraints() -> void:
	for row: Array in rotators:
		var target: int = row[0]
		var origin: int = row[1]
		var dest_rest := rig.get_bone_rest(target).basis.orthonormalized().get_rotation_quaternion()
		var src_rest := rig.get_bone_rest(origin).basis.orthonormalized().get_rotation_quaternion()
		var axis: Vector3 = row[2]
		var delta := (dest_rest.inverse()*rig.get_bone_pose_rotation(origin)*src_rest.inverse()*dest_rest).normalized()
		var twist := Quaternion(delta*axis,axis)*delta
		rig.set_bone_pose_rotation(target,dest_rest * Quaternion.IDENTITY.slerp(twist,row[3]))
	for row: Array in aimers:
		var target: int = row[0]
		var parent_pose := rig.get_bone_global_pose(rig.get_bone_parent(target))
		var current := parent_pose * rig.get_bone_rest(target)
		var direction := rig.get_bone_global_pose(row[1]).origin-current.origin
		if direction.length_squared()<.000001:
			continue
		var axis: Vector3 = current.basis * row[2]
		var aim := Quaternion.IDENTITY.slerp(Quaternion(axis.normalized(),direction.normalized()),row[3])
		current.basis = Basis(aim)*current.basis
		rig.set_bone_global_pose(target,current)
