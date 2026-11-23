extends Node3D
## Replace this presentation node without changing resident IDs, schedules or memory.

const S = preload("res://scripts/world/shapes.gd")
const SAMPLE = preload("res://scripts/story/prototype/sample_cast.gd")
const FABRICS := ["657D50","78586D","896144","496B73","62768C","9D7656","876C48","657669","965D53","58617A"]
const SKIN := ["D2A77B","AF805B","E3BE98","BD906B","8B624A"]
static var palette_material: StandardMaterial3D
var name_label: Label3D
var gesture_label: Label3D
var head: Node3D
var left_arm: Node3D
var right_arm: Node3D
var left_leg: Node3D
var right_leg: Node3D
var axe: Node3D
var work_item: Node3D
var hauling := false
var clock := 0.0
var pose := "IDLE"
var is_thomas := false
var sample: SAMPLE

func setup(data: Dictionary, index: int) -> void:
	is_thomas = data.id=="THOMAS"
	var height := clampf(1.12+float(data.get("age_suggested",31))*.018,1.26,1.76)
	var body := Node3D.new()
	body.scale = Vector3(1.18 if is_thomas else .90+(index%4)*.055,height/1.66,1.08 if is_thomas else 1.0)
	add_child(body)
	var coat: String = "49604C" if is_thomas else FABRICS[index%FABRICS.size()]
	var skin: String = SKIN[index%SKIN.size()]
	var torso := CapsuleMesh.new()
	torso.radius = .205
	torso.height = .62
	torso.radial_segments = 10
	torso.rings = 4
	S.mesh(body,torso,Vector3(0,1.055,0),coat)
	S.box(body,Vector3(0,.87,-.004),Vector3(.33,.080,.245),"594637")
	if is_thomas:
		S.box(body,Vector3(0,1.103,-.15),Vector3(.30,.40,.13),"715540")
	left_arm = limb(body,Vector3(-.217,1.24,0),Vector3(.116,.43,.134),coat)
	right_arm = limb(body,Vector3(.217,1.24,0),Vector3(.116,.43,.134),coat)
	for arm in [left_arm,right_arm]:
		S.box(arm,Vector3(0,-.435,0),Vector3(.104,.14,.105),skin)
	left_leg = limb(body,Vector3(-.091,.86,0),Vector3(.145,.69,.152),"514D4B")
	right_leg = limb(body,Vector3(.091,.86,0),Vector3(.145,.69,.152),"514D4B")
	for leg in [left_leg,right_leg]:
		S.box(leg,Vector3(0,-.749,-.04),Vector3(.16,.17,.23),"413A32")
	head = Node3D.new()
	head.position = Vector3(0,1.504,0)
	body.add_child(head)
	var face := SphereMesh.new()
	face.radius = .145
	face.height = .31
	face.radial_segments = 12
	face.rings = 6
	S.mesh(head,face,Vector3.ZERO,skin)
	var hair: String = ["4C382C","6C4733","61442E","746257","483B31"][posmod(index,5)]
	if int(data.get("age_suggested",31))>59:
		hair = "8A8175"
	S.box(head,Vector3(.005,.106,.011),Vector3(.212,.081,.187),hair)
	for side in [-1,1]:
		S.box(head,Vector3(side*.050,.014,-.134),Vector3(.035,.027,.020),"4B3A2C")
	if is_thomas:
		axe = Node3D.new()
		axe.position = Vector3(0,-.40,-.035)
		right_arm.add_child(axe)
		S.box(axe,Vector3(0,0,-.115),Vector3(.045,.052,.49),"826144")
		S.box(axe,Vector3(0,-.056,-.33),Vector3(.075,.135,.180),"7E837D")
		S.box(axe,Vector3(0,-.132,-.36),Vector3(.075,.057,.140),"B4B6A6")
	elif data.narrative_priority!="ambient":
		work_item = Node3D.new()
		work_item.position = Vector3(0,-.43,-.058)
		right_arm.add_child(work_item)
		build_work_prop(work_item,data.id)
		batch_joint(work_item)
	for joint in [body,head,left_arm,right_arm,left_leg,right_leg,axe]:
		if joint!=null:
			batch_joint(joint)
	if SAMPLE.enabled():
		sample = SAMPLE.new()
		add_child(sample)
		sample.setup(height,true)
		for prop in [axe,work_item]:
			if prop!=null:
				sample.grip(prop)
		body.hide()
	name_label = label_at(str(data.get("name_en","Thomas")),Vector3(0,height+.33,0),30)
	gesture_label = label_at("",Vector3(0,height+.65,0),24)
	visit(false)

static func build_work_prop(parent: Node3D,id: String) -> void:
	match id:
		"VLA-01":
			var can := CylinderMesh.new()
			can.top_radius = .10
			can.bottom_radius = .12
			can.height = .20
			can.radial_segments = 10
			S.mesh(parent,can,Vector3.ZERO,"61877B")
			S.beam(parent,Vector3(.075,.01,0),Vector3(.25,.108,0),.033,"789A89")
		"VLA-04", "VLA-20":
			S.box(parent,Vector3(-.06,-.035,0),Vector3(.43,.068,.19),"9F7652")
		"VLA-06", "VLA-23":
			var bowl := CylinderMesh.new()
			bowl.top_radius = .16
			bowl.bottom_radius = .082
			bowl.height = .086
			bowl.radial_segments = 10
			S.mesh(parent,bowl,Vector3.ZERO,"B39A72")
		"VLA-13":
			S.box(parent,Vector3(0,-.013,0),Vector3(.25,.083,.21),"8D6E85")
		"VLA-15":
			var jar := CylinderMesh.new()
			jar.top_radius = .071
			jar.bottom_radius = .096
			jar.height = .19
			jar.radial_segments = 10
			S.mesh(parent,jar,Vector3.ZERO,"9C9A79")
		_:
			S.box(parent,Vector3(0,-.016,0),Vector3(.18,.18,.22),"9C8465")

func batch_joint(joint: Node3D) -> void:
	# One material and one draw per moving joint, even where boots or cuffs have a different color.
	if palette_material==null:
		palette_material = StandardMaterial3D.new()
		palette_material.vertex_color_use_as_albedo = true
		palette_material.vertex_color_is_srgb = true
		palette_material.roughness = .94
	var positions := PackedVector3Array()
	var normals := PackedVector3Array()
	var colors := PackedColorArray()
	var indices := PackedInt32Array()
	for child in joint.get_children():
		if not child is MeshInstance3D:
			continue
		var part := child as MeshInstance3D
		var arrays := part.mesh.surface_get_arrays(0)
		var start := positions.size()
		var surface := part.get_active_material(0) as StandardMaterial3D
		for vertex: Vector3 in arrays[Mesh.ARRAY_VERTEX]:
			positions.append(part.transform*vertex)
			colors.append(surface.albedo_color)
		for normal: Vector3 in arrays[Mesh.ARRAY_NORMAL]:
			normals.append((part.transform.basis*normal).normalized())
		for index: int in arrays[Mesh.ARRAY_INDEX]:
			indices.append(start+index)
		joint.remove_child(part)
		part.queue_free()
	var arrays := []
	arrays.resize(Mesh.ARRAY_MAX)
	arrays[Mesh.ARRAY_VERTEX] = positions
	arrays[Mesh.ARRAY_NORMAL] = normals
	arrays[Mesh.ARRAY_COLOR] = colors
	arrays[Mesh.ARRAY_INDEX] = indices
	var mesh := ArrayMesh.new()
	mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES,arrays)
	mesh.surface_set_material(0,palette_material)
	var visual := MeshInstance3D.new()
	visual.mesh = mesh
	joint.add_child(visual)

func limb(parent: Node3D, at: Vector3, size: Vector3, tint: String) -> Node3D:
	var pivot := Node3D.new()
	pivot.position = at
	parent.add_child(pivot)
	S.box(pivot,Vector3(0,-size.y*.5,0),size,tint)
	return pivot

func label_at(text: String, at: Vector3, size: int) -> Label3D:
	var label := Label3D.new()
	label.text = text
	label.position = at
	label.font_size = size
	label.pixel_size = .0038
	label.billboard = BaseMaterial3D.BILLBOARD_ENABLED
	label.modulate = Color("F0E1C9")
	label.outline_modulate = Color("27322B")
	label.outline_size = 11
	label.hide()
	add_child(label)
	return label

func visit(active: bool) -> void:
	visible = active
	set_process(active)
	if not active:
		name_label.hide()
		gesture_label.hide()

func _process(delta: float) -> void:
	clock += delta
	var walk := pose in ["WALK","RETURN_HOME"]
	var work := pose=="WORK"
	var chat := pose=="SOCIALIZE" or pose=="TALK_TO_PLAYER"
	var sway := sin(clock*(9.5 if walk else 3.0))
	left_leg.rotation.x = sway*.56 if walk else 0.0
	right_leg.rotation.x = -left_leg.rotation.x
	left_arm.rotation.x = -sway*.42 if walk else -.25+.17*sway if work or chat else -.08
	if is_thomas and work:
		var cycle := fposmod(clock,3.2)
		var lift := sin(smoothstep(.30,1.30,cycle)*PI*.5)*(1.0-smoothstep(1.37,1.65,cycle))
		right_arm.rotation.x = -.38+lift*2.56
		left_arm.rotation.x = -.19+lift*.53
	else:
		right_arm.rotation.x = sway*.42 if walk else -.47+.28*sway if work or chat else -.05
	head.rotation.y = sway*.18 if chat else 0.0
	head.rotation.x = -.12-.10*sway if work else .10 if pose=="REST" else 0.0
	if axe!=null:
		axe.visible = work
	if work_item!=null:
		work_item.visible = hauling
		if hauling:
			right_arm.rotation.x = -.87+.06*sway
			left_arm.rotation.x = -.68-.055*sway
	if sample!=null:
		sample.village_pose(left_arm.rotation.x,right_arm.rotation.x,left_leg.rotation.x,
			Vector2(head.rotation.x,head.rotation.y),is_thomas and work,hauling)
