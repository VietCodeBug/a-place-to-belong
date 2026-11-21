extends Node3D

const VISUAL = preload("res://scripts/story/prototype/npc_visual.gd")
const USE = preload("res://scripts/story/prototype/interaction.gd")
const LAND = preload("res://scripts/world/landscape.gd")
var data: Dictionary
var stage: Node
var visual: Node3D
var target: Node3D
var point := Vector2.ZERO
var route: Array[Vector2] = []
var task := "IDLE"
var behavior := "IDLE"
var talking := false
var active := false
var schedule_slot := -1
var nick := ""
var work_phase := ""
var work_wait := 0.0
var facing := Vector2.UP

func setup(profile: Dictionary, index: int, at: Vector2, owner_stage: Node) -> void:
	data = profile
	nick = str(profile.get("name_en","Thomas"))
	stage = owner_stage
	point = at
	position = grounded(point)
	visual = VISUAL.new()
	visual.name = "NpcVisual"
	add_child(visual)
	visual.setup(profile,index)
	target = USE.new()
	target.name = "Talk"
	target.interaction_name = "Nói chuyện với %s" % nick
	target.interaction_radius = 2.45
	target.set_meta("focus_at",Vector3.UP*1.15)
	target.set_meta("focus_radius",.43)
	target.action = stage.conversation.open.bind(self)
	add_child(target)
	target.set_available(false)

func grounded(p: Vector2) -> Vector3:
	return Vector3(p.x,LAND.height_at(p.x,p.y)+.035,p.y)

func expose(value: bool) -> void:
	if active==value:
		return
	active = value
	visual.visit(value)
	target.set_available(value)

func face(p: Vector2) -> void:
	var heading := p-point
	if heading.length_squared()>.005:
		facing = heading.normalized()

func advance(delta: float, observer: Vector2) -> void:
	if active:
		rotation.y = lerp_angle(rotation.y,atan2(-facing.x,-facing.y),1.0-exp(-12.0*delta))
	if talking:
		face(observer)
		set_behavior("TALK_TO_PLAYER")
		return
	if route.is_empty():
		set_behavior(task)
		return
	var next: Vector2 = route[0]
	var step := point.move_toward(next,delta*1.34)
	if active and step.distance_squared_to(observer)<.58*.58 and step.distance_to(observer)<point.distance_to(observer):
		set_behavior("IDLE")
		return
	if active:
		face(next)
	point = step
	if active:
		position = grounded(point)
	if point.distance_squared_to(next)<.0036:
		route.pop_front()
	set_behavior("RETURN_HOME" if task=="REST" else "WALK")

func set_behavior(next: String) -> void:
	behavior = next
	visual.pose = next
