extends Node3D
## Props move between fixed support points in the room's own physics world.

const USE = preload("res://scripts/story/prototype/interaction.gd")
const DETAILS = preload("res://scripts/story/prototype/house_a_details.gd")
const CARRY_OFFSET := Vector3(.248,-.222,-.618)

class Slot:
	var target: Node3D
	var prop: Prop
	var label: String
	var width: float

class Prop:
	var model: Node3D
	var target: Node3D
	var label: String
	var width: float
	var yaw: float
	var grip_at: Vector3

var slots: Dictionary = {}
var props: Dictionary = {}
var carried: Prop
var source: Slot
var enabled := false
var camera: Camera3D
var carry_mount: Node3D
var hand: Node3D
var lift: Tween
var stage: Node3D

func setup(room_stage: Node3D, room_camera: Camera3D) -> void:
	stage = room_stage
	camera = room_camera
	carry_mount = Node3D.new()
	carry_mount.name = "HeldHouseholdItem"
	carry_mount.position = CARRY_OFFSET
	camera.add_child(carry_mount)
	hand = DETAILS.grip(carry_mount)
	carry_mount.hide()
	set_process(false)

func add_slot(id: String, label: String, at: Vector3, width: float) -> void:
	var slot := Slot.new()
	slot.label = label
	slot.width = width
	slot.target = point(id,Vector3.UP*.021,width*.5,put_down.bind(slot))
	slot.target.position = at
	slots[id] = slot

func add_prop(id: String, label: String, slot_id: String, width: float, height: float, yaw: float, grip_at: Vector3, build: Callable) -> void:
	var prop := Prop.new()
	prop.label = label
	prop.width = width
	prop.yaw = yaw
	prop.grip_at = grip_at
	prop.model = Node3D.new()
	prop.model.name = id
	add_child(prop.model)
	build.call(prop.model)
	prop.target = point("Pick_"+id,Vector3.UP*(height*.49),maxf(width,height)*.50,pick_up.bind(prop))
	prop.target.interaction_name = "Nhặt "+label
	props[id] = prop
	put_in_slot(prop,slots[slot_id])

func point(id: String, focus: Vector3, radius: float, command: Callable) -> Node3D:
	var target := USE.new()
	target.name = id
	target.set_meta("focus_at",focus)
	target.set_meta("focus_radius",radius)
	target.set_meta("physical_prop",true)
	target.interaction_radius = 1.48
	target.action = command
	add_child(target)
	target.set_available(false)
	return target

func set_enabled(value: bool) -> void:
	if not value:
		put_back()
	enabled = value
	refresh_targets()

func pick_up(prop: Prop) -> void:
	if carried!=null or not enabled:
		return
	for slot: Slot in slots.values():
		if slot.prop==prop:
			source = slot
			break
	if source==null:
		return
	carried = prop
	source.prop = null
	stage.sound("tap",prop.model.global_position,self)
	carry_mount.show()
	prop.model.reparent(carry_mount,true)
	var orientation := Basis.from_euler(Vector3(.06,-.30,.06))
	# Move the grip, not the prop origin, to the hand position on camera.
	var rest := Transform3D(orientation,-(orientation*prop.grip_at))
	hand.position = Vector3.ZERO
	lift = create_tween().set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	lift.tween_property(prop.model,"transform",rest,.22)
	set_process(true)
	refresh_targets()

func put_down(slot: Slot) -> void:
	if carried==null or slot.prop!=null or carried.width>slot.width:
		return
	if lift!=null and lift.is_running():
		lift.kill()
	put_in_slot(carried,slot)
	stage.sound("tap",slot.target.global_position,self)
	carried = null
	source = null
	carry_mount.hide()
	set_process(false)
	refresh_targets()

func put_in_slot(prop: Prop, slot: Slot) -> void:
	if prop.model.get_parent()!=self:
		prop.model.reparent(self,false)
	prop.model.position = slot.target.position
	prop.model.rotation = Vector3(0,prop.yaw,0)
	prop.target.position = slot.target.position
	slot.prop = prop

func put_back() -> void:
	if carried!=null:
		put_down(source)

func carry_label() -> String:
	return carried.label if carried!=null else ""

func refresh_targets() -> void:
	for prop: Prop in props.values():
		prop.target.set_available(enabled and carried==null)
	for slot: Slot in slots.values():
		var accepts := enabled and carried!=null and slot.prop==null and carried.width<=slot.width
		slot.target.set_available(accepts)
		if accepts:
			slot.target.interaction_name = "Đặt %s lên %s" % [carried.label,slot.label]

func _process(delta: float) -> void:
	var reach := CARRY_OFFSET
	if stage.hub.eyes.head_bob:
		reach.y += stage.hub.eyes.bob*.85
	var from := camera.global_position
	var to := camera.to_global(reach.normalized()*(reach.length()+carried.width*.33))
	var query := PhysicsRayQueryParameters3D.create(from,to,1,[stage.hub.player.get_rid()])
	var collision := camera.get_world_3d().direct_space_state.intersect_ray(query)
	if not collision.is_empty():
		var safe_depth := from.distance_to(collision.position)-carried.width*.35
		reach *= clampf(safe_depth/reach.length(),.42,1.0)
	carry_mount.position = carry_mount.position.lerp(reach,1.0-exp(-21.0*delta))
