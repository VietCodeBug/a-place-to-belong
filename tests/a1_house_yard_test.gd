extends SceneTree

const SCENE := preload("res://scenes/environment/a1_house_gate.tscn")

func _initialize() -> void:
	call_deferred("check_yard")

func check_yard() -> void:
	var scene := SCENE.instantiate()
	root.add_child(scene)
	await physics_frame
	await physics_frame
	var meadow := scene.get_node("YardDenseMeadow")
	assert(meadow.counts.get("grass_carpet",0) > 4500)
	assert(meadow.counts.get("grass_main",0) > 350)
	assert(meadow.counts.get("grass_accent",0) > 10)
	assert(scene.grass_mask(Vector2.ZERO).r == 0.0)
	assert(scene.grass_mask(Vector2(-0.49,3.2)).r == 0.0)
	assert(scene.grass_mask(Vector2(0.2,8.3)).r == 0.0)
	var stones := scene.get_node("ForestEdgeBoulders")
	assert(stones.get_child_count() == 3)
	assert(scene.rock_exclusions.size() == 8)
	var space: PhysicsDirectSpaceState3D = scene.get_world_3d().direct_space_state
	for group in stones.get_children():
		var main := group.get_child(0) as Node3D
		var at := main.global_position
		var touch := space.intersect_ray(PhysicsRayQueryParameters3D.create(
			Vector3(at.x,at.y+5,at.z),Vector3(at.x,at.y+0.45,at.z)))
		assert(not touch.is_empty() and group.is_ancestor_of(touch.collider),str(group.name))
		var around := PhysicsTestMotionParameters3D.new()
		around.from = Transform3D(Basis.IDENTITY,Vector3(at.x,0.07,at.z+4.3))
		around.motion = Vector3(0,0,-1.0)
		assert(not PhysicsServer3D.body_test_motion(scene.walker.get_rid(),around),str(group.name))
	var route := PhysicsTestMotionParameters3D.new()
	route.from = Transform3D(Basis.IDENTITY,Vector3(0.4,0.065,9.0))
	route.motion = Vector3(-0.89,0.0,-5.20)
	assert(not PhysicsServer3D.body_test_motion(scene.walker.get_rid(),route),"The approach must remain clear.")
	var ramp := space.intersect_ray(PhysicsRayQueryParameters3D.create(
		Vector3(-0.49,0.65,3.05),Vector3(-0.49,0.03,3.05)))
	assert(not ramp.is_empty() and ramp.position.y > 0.12)
	scene.set_physics_process(false)
	scene.walker.position = Vector3(-0.49,0.07,8.20)
	scene.walker.velocity = Vector3.ZERO
	for frame in range(107):
		await physics_frame
		scene.move_walker(Vector2(0,-1),1.0/60.0)
	assert(scene.walker.position.z < 3.22)
	assert(scene.walker.position.y > 0.13 and scene.walker.is_on_floor())
	print("PASS first-person walker reaches porch via approach")
	print("PASS yard layers, exclusions, three colliding rock groups, approach clearance and porch ramp")
	quit()
