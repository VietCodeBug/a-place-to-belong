extends SceneTree

const SCENE := preload("res://scenes/environment/a1_house_gate.tscn")

func _initialize() -> void:
	call_deferred("check_yard")

func check_yard() -> void:
	var scene := SCENE.instantiate()
	root.add_child(scene)
	await physics_frame
	await physics_frame
	var clearing := scene.get_node("ForestClearing")
	assert(clearing.counts[0]>900 and clearing.counts[1]>1000 and clearing.counts[2]>100)
	assert(clearing.counts.reduce(func(total: int,count: int) -> int: return total+count,0)<8000)
	for location in [Vector2.ZERO, Vector2(-0.49,3.2), Vector2(.2,8.3),Vector2(2.0,4.05)]:
		assert(clearing.grass_mask(location)==0.0)
	var groups := clearing.get_node("ForestEdgeBoulders")
	assert(groups.get_child_count()==3 and clearing.rocks.size()==8)
	var space: PhysicsDirectSpaceState3D = scene.get_world_3d().direct_space_state
	for group in groups.get_children():
		var at: Vector3 = group.get_child(0).global_position
		var hit := space.intersect_ray(PhysicsRayQueryParameters3D.create(
			Vector3(at.x,at.y+4,at.z),Vector3(at.x,at.y+0.22,at.z)))
		assert(not hit.is_empty() and group.is_ancestor_of(hit.collider),str(group.name))
	assert(absf(clearing.height(-12,1))>0.80)
	var test := Vector3(13.30,0,-6.35)
	var ground := space.intersect_ray(PhysicsRayQueryParameters3D.create(test+Vector3.UP*10,test-Vector3.UP*2))
	assert(not ground.is_empty() and absf(ground.position.y-clearing.height(test.x,test.z)) < 0.002)
	scene.set_physics_process(false)
	scene.walker.position = Vector3(-0.49,0.07,8.20)
	scene.walker.velocity = Vector3.ZERO
	for frame in range(107):
		await physics_frame
		scene.move_walker(Vector2(0,-1),1.0/60.0)
	assert(scene.walker.position.z < 3.22)
	assert(scene.walker.position.y > 0.13 and scene.walker.is_on_floor())
	for tile in clearing.grass_chunks:
		assert(not (tile.models[0].visible and tile.models[1].visible))
	print("PASS terrain height matches collider, three boulder clusters, grass masks/LOD, approach and porch climb")
	quit()
