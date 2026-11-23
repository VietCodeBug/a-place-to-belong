extends SceneTree

const SCENE := preload("res://scenes/environment/a1_house_gate.tscn")
const ROUTE := [Vector2(2.4,16.4),Vector2(0.70,11.0),Vector2(0.17,7.2),Vector2(3.2,6.4),Vector2(5.1,4.0),Vector2(4.66,-0.35)]

func _initialize() -> void:
	call_deferred("record")

func record() -> void:
	var output := OS.get_environment("A1_REVIEW_DIR")
	assert(DirAccess.dir_exists_absolute(output))
	root.size = Vector2i(960,540)
	var scene := SCENE.instantiate()
	root.add_child(scene)
	scene.get_node("Help").hide()
	scene.set_physics_process(false)
	var walker: CharacterBody3D = scene.walker
	var eye: Camera3D = scene.eye
	var at: Vector2 = ROUTE[0]
	walker.position = Vector3(at.x,scene.get_node("ForestClearing").height(at.x,at.y)+0.04,at.y)
	var index := 1
	var frames := 0
	for frame in range(80):
		await physics_frame
		for step in range(6):
			var position := Vector2(walker.position.x,walker.position.z)
			var target: Vector2 = ROUTE[index]
			if position.distance_to(target)<0.23:
				index += 1
				if index >= ROUTE.size():
					break
				target = ROUTE[index]
			var direction := (target-position).normalized()
			scene.move_walker(direction,1.0/60.0)
		if index >= ROUTE.size():
			break
		var orientation := Basis.looking_at(Vector3(0.18,2.0,0.6)-eye.global_position)
		eye.basis = orientation if frame==0 else eye.basis.slerp(orientation,.20)
		await RenderingServer.frame_post_draw
		root.get_texture().get_image().save_png(output.path_join("%03d.png" % frames))
		frames += 1
	print("WALK frames=",frames," reached=",index,"/",ROUTE.size()," pos=",walker.position)
	quit(0 if index==ROUTE.size() else 1)
