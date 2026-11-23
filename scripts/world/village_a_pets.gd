extends Node3D
## Decorative pets use closed, ground-following routes and yield to people on the lanes.
const L = preload("res://scripts/world/landscape.gd")
const DOG = preload("res://assets/vendor/quaternius/a1_wildlife/ShibaInu.glb")
const CAT = preload("res://assets/village_a/pets/GingerCat.glb")
const RANGE_SQUARED := 52.0*52.0
const DOG_ROUTE := [Vector2(6.36,121.80),Vector2(5.79,125.72),Vector2(5.93,129.42),
	Vector2(6.50,134.34),Vector2(6.31,140.76),Vector2(6.49,142.56),Vector2(7.04,141.41),
	Vector2(7.54,136.25),Vector2(7.35,130.36),Vector2(7.58,124.58),Vector2(7.04,122.03)]
const CAT_ROUTE := [Vector2(.65,128.70),Vector2(2.70,129.60),Vector2(5.23,130.82),
	Vector2(7.02,130.61),Vector2(7.83,129.12),Vector2(7.32,127.40),Vector2(5.70,126.88),
	Vector2(4.03,127.71),Vector2(2.86,128.63),Vector2(1.23,128.19)]

class Pet:
	var body: Node3D
	var animator: AnimationPlayer
	var route: Curve2D
	var offset: float
	var walk: StringName
	var run: StringName
	var idle: StringName
	var pace: float
	var run_pace: float
	var direction := 1.0
	var rest := 0.0
	var blocked := 0.0
	var traveled := 0.0
	var stride_time := 0.0
	var clearance: float

var pets: Array[Pet] = []
var probe := PhysicsShapeQueryParameters3D.new()
var clearance_shape := SphereShape3D.new()
var hub: Node3D

func _ready() -> void:
	hub = get_parent().get_parent()
	probe.shape = clearance_shape
	probe.collision_mask = 1
	probe.exclude = [hub.player.get_rid()]
	add_pet("Shiba",DOG,DOG_ROUTE,.58,1.12,2.85,4.0,1.85,.19,"Gallop")
	add_pet("GingerCat",CAT,CAT_ROUTE,.45,.86,2.12,1.25,.08,.14,"Trot")

func loop_route(points: Array) -> Curve2D:
	var curve := Curve2D.new()
	curve.bake_interval = .13
	for i in points.size()+1:
		var anchor: Vector2 = points[i%points.size()]
		var next: Vector2 = points[(i+1)%points.size()]
		var prev: Vector2 = points[posmod(i-1,points.size())]
		var tangent := (next-prev).limit_length(6.4)*.16
		curve.add_point(anchor,-tangent,tangent)
	return curve

func add_pet(id: String, source: PackedScene, points: Array, height: float, pace: float, run_pace: float,
		start: float, initial_rest: float, clearance: float, sprint_clip: String) -> void:
	var pet := Pet.new()
	pet.route = loop_route(points)
	pet.offset = start
	pet.rest = initial_rest
	pet.pace = pace
	pet.run_pace = run_pace
	pet.clearance = clearance
	pet.body = Node3D.new()
	pet.body.name = id
	var model := source.instantiate() as Node3D
	pet.body.add_child(model)
	FieldAssets.style(model)
	var aabb := FieldAssets.bounds(model)
	var factor := height/maxf(aabb.size.y,.001)
	model.scale *= factor
	model.position -= Vector3(aabb.get_center().x,aabb.position.y,aabb.get_center().z)*factor
	pet.animator = pet.body.find_children("*","AnimationPlayer",true,false)[0] as AnimationPlayer
	pet.idle = animation_name(pet.animator,"Idle")
	pet.walk = animation_name(pet.animator,"Walk")
	pet.run = animation_name(pet.animator,sprint_clip)
	for clip in [pet.idle,pet.walk,pet.run]:
		pet.animator.get_animation(clip).loop_mode = Animation.LOOP_LINEAR
	add_child(pet.body)
	var p := point_on(pet,pet.offset)
	var forward := point_on(pet,pet.offset+.24)-p
	pet.body.position = on_ground(p)
	pet.body.rotation.y = atan2(forward.x,forward.y)
	pet.body.visible = false
	pet.animator.play(pet.idle)
	pet.animator.active = false
	pets.append(pet)

func animation_name(animator: AnimationPlayer, suffix: String) -> StringName:
	for clip in animator.get_animation_list():
		if String(clip)==suffix or String(clip).ends_with("|"+suffix) or String(clip).ends_with("_"+suffix):
			return clip
	push_error("Village pet animation is missing: "+suffix)
	return &""

func point_on(pet: Pet, at: float) -> Vector2:
	return pet.route.sample_baked(fposmod(at,pet.route.get_baked_length()),true)

func on_ground(p: Vector2) -> Vector3:
	return Vector3(p.x,L.height_at(p.x,p.y)+.008,p.y)

func _physics_process(delta: float) -> void:
	var stage: Node = hub.story_prototype
	var outside: bool = stage==null or not stage.inside
	var observer: Vector3 = hub.player.global_position
	for pet in pets:
		var near: bool = outside and pet.body.global_position.distance_squared_to(observer)<RANGE_SQUARED
		if near!=pet.body.visible:
			pet.body.visible = near
			pet.animator.active = near
		if near:
			advance_pet(pet,delta,stage,Vector2(observer.x,observer.z))

func advance_pet(pet: Pet, delta: float, stage: Node, observer: Vector2) -> void:
	if pet.rest>0.0:
		pet.rest -= delta
		play(pet,pet.idle)
		return
	var running := pet.stride_time<2.75
	var pace: float = pet.run_pace if running else pet.pace
	var current := point_on(pet,pet.offset)
	var turn := point_on(pet,pet.offset+pet.direction*.28)-current
	var yaw := atan2(turn.x,turn.y)
	pet.body.rotation.y = rotate_toward(pet.body.rotation.y,yaw,delta*7.0)
	if absf(angle_difference(pet.body.rotation.y,yaw))>.79:
		play(pet,pet.idle)
		return
	var next_offset := pet.offset+pace*delta*pet.direction
	var ahead := point_on(pet,next_offset)
	if not clear(pet,current,ahead,observer,stage):
		pet.blocked += delta
		if pet.blocked>(2.2 if pet.pace>1.0 else 1.6):
			pet.direction *= -1.0
			pet.blocked = 0.0
			pet.rest = .3
		play(pet,pet.idle)
		return
	pet.blocked = 0.0
	pet.stride_time += delta
	pet.offset = fposmod(next_offset,pet.route.get_baked_length())
	pet.body.position = on_ground(ahead)
	pet.traveled += current.distance_to(ahead)
	play(pet,pet.run if running else pet.walk)
	if pet.stride_time>6.3:
		pet.rest = 1.08 if pet.pace>1.0 else 1.8
		pet.stride_time = 0.0

func clear(pet: Pet,current:Vector2,ahead: Vector2,observer: Vector2,stage: Node) -> bool:
	if approaching(current,ahead,observer,.87):
		return false
	for other in pets:
		if other==pet or not other.body.visible:
			continue
		var location := other.body.position
		if approaching(current,ahead,Vector2(location.x,location.z),.74):
			return false
	if stage!=null:
		for resident in stage.village.registry.values():
			if resident.active and approaching(current,ahead,resident.point,.62):
				return false
	clearance_shape.radius = pet.clearance
	probe.transform = Transform3D(Basis.IDENTITY,on_ground(ahead)+Vector3.UP*(pet.clearance+.14))
	return get_world_3d().direct_space_state.intersect_shape(probe,1).is_empty()

func approaching(from: Vector2,to: Vector2,obstacle:Vector2,radius:float) -> bool:
	var near := to.distance_squared_to(obstacle)
	return near<radius*radius and near<from.distance_squared_to(obstacle)

func play(pet: Pet,clip: StringName) -> void:
	if pet.animator.current_animation!=clip:
		pet.animator.play(clip,.13,.94 if clip==pet.idle else 1.0)
