extends Node3D
## Small wildlife follows short habitat routes, with pauses to eat or look around.
const L = preload("res://scripts/world/landscape.gd")
const PLAN = preload("res://scripts/world/village_a_layout.gd")
const DIR := "res://assets/vendor/quaternius/a1_wildlife/"

class Animal:
	var body: Node3D
	var animator: AnimationPlayer
	var pace: float
	var points: PackedVector2Array
	var next := 1
	var rest := 0.0
	var idle: StringName
	var walk: StringName
	var eat: StringName

var animals: Array[Animal] = []

func _ready() -> void:
	name = "ForestWildlife"
	var house := PLAN.HOUSE_A
	add_animal("Fox",.48,.88,[house+Vector2(-6.0,-3.4),house+Vector2(-8.0,-4.6),house+Vector2(-9.1,-8.2),house+Vector2(-5.4,-8.2)],4.2)
	add_animal("Deer",1.04,.79,[Vector2(8.7,-242),Vector2(8.2,-239.5),Vector2(6,-237.9),Vector2(5.3,-243.1)],6.1)
	add_animal("Deer",.91,.79,[Vector2(6.0,-246.5),Vector2(7.4,-244.6),Vector2(7.2,-242.9),Vector2(5,-243.7)],8.2)
	add_animal("Fox",.46,.88,[Vector2(-9,46),Vector2(-12,47),Vector2(-12.5,42),Vector2(-8.7,42.9)],3.0)

func add_animal(species: String, height: float, pace: float, route: PackedVector2Array, rest: float) -> void:
	var animal := Animal.new()
	animal.points = route
	animal.rest = rest
	animal.pace = pace
	var source := load(DIR+species+".glb") as PackedScene
	var model := source.instantiate() as Node3D
	animal.body = Node3D.new()
	animal.body.add_child(model)
	var bounds := FieldAssets.bounds(model)
	var factor := height/maxf(.01,bounds.size.y)
	model.scale *= factor
	model.position -= Vector3(bounds.get_center().x,bounds.position.y,bounds.get_center().z)*factor
	animal.body.name = species
	add_child(animal.body,true)
	animal.body.position = Vector3(route[0].x,L.height_at(route[0].x,route[0].y),route[0].y)
	animal.animator = animal.body.find_children("*","AnimationPlayer",true,false)[0] as AnimationPlayer
	for clip in animal.animator.get_animation_list():
		var key := String(clip).to_lower()
		if key.ends_with("walk"):
			animal.walk = clip
		elif key.ends_with("eating"):
			animal.eat = clip
		elif key.ends_with("idle"):
			animal.idle = clip
	for clip in [animal.walk,animal.eat,animal.idle]:
		animal.animator.get_animation(clip).loop_mode = Animation.LOOP_LINEAR
	animal.animator.play(animal.idle)
	var facing := route[1]-route[0]
	animal.body.rotation.y = atan2(facing.x,facing.y)
	animals.append(animal)

func _process(delta: float) -> void:
	var camera := get_viewport().get_camera_3d()
	for animal in animals:
		var near := camera != null and camera.global_position.distance_squared_to(animal.body.global_position)<56.0*56.0
		animal.body.visible = near
		animal.animator.active = near
		if not near:
			continue
		if animal.rest>0.0:
			animal.rest -= delta
			continue
		if animal.animator.current_animation != animal.walk:
			animal.animator.play(animal.walk,.22,1.0)
		var pos := Vector2(animal.body.position.x,animal.body.position.z)
		var destination := animal.points[animal.next]
		var heading := destination-pos
		var target_turn := atan2(heading.x,heading.y)
		animal.body.rotation.y = rotate_toward(animal.body.rotation.y,target_turn,delta*2.8)
		pos = pos.move_toward(destination,delta*animal.pace)
		animal.body.position = Vector3(pos.x,L.height_at(pos.x,pos.y),pos.y)
		if pos.distance_squared_to(destination)<.0025:
			animal.next = (animal.next+1)%animal.points.size()
			animal.rest = 2.2 + animal.next*.8
			animal.animator.play(animal.eat if animal.next%2==0 else animal.idle,.27)
