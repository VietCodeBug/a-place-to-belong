extends SceneTree
var failures := 0
func _initialize() -> void: call_deferred("run")
func check(ok: bool, message: String) -> void:
	if ok: print("PASS: ",message)
	else:
		push_error(message)
		failures += 1
func run() -> void:
	var hub = load("res://scenes/world/forest_hub.tscn").instantiate()
	root.add_child(hub)
	for i in range(35): await physics_frame
	var space: PhysicsDirectSpaceState3D = hub.get_world_3d().direct_space_state
	for p in [Vector2(1,13),Vector2(-4,20),Vector2(18,18),Vector2(-20,6)]:
		var ray := PhysicsRayQueryParameters3D.create(Vector3(p.x,30,p.y),Vector3(p.x,-5,p.y))
		ray.exclude = [hub.player.get_rid()]
		var hit := space.intersect_ray(ray)
		check(not hit.is_empty() and absf(hit.position.y-ForestLandscape.height_at(p.x,p.y))<0.05,"terrain/collider conformance "+str(p))
	for p in [Vector2(35,10),Vector2(-40,0),Vector2(0,35)]:
		var ray := PhysicsRayQueryParameters3D.create(Vector3(p.x,40,p.y),Vector3(p.x,-10,p.y))
		check(space.intersect_ray(ray).is_empty(),"background has no expanded playable floor "+str(p))
	check(is_equal_approx(hub.mailbox.position.x,3.6) and is_equal_approx(hub.mailbox.position.z,3.5),"mailbox keeps its Map 01 horizontal location")
	check(hub.get_node_or_null("CreekBridge")==null,"no creek crossing or new region introduced")
	var player = hub.player
	player.position = hub.ground(0,7,0.15)
	player.velocity = Vector3.ZERO
	for i in range(25): await physics_frame
	Input.action_press("move_up")
	Input.action_press("move_right")
	for i in range(100): await physics_frame
	Input.action_release("move_up")
	Input.action_release("move_right")
	print("Porch approach feet: ",player.position)
	check(player.position.z < 3.5,"player walks from the road onto the porch")
	check(player.position.y > 0.3 and player.position.y < 0.5,"porch supports player at deck height")
	print("MAP 01 SCOPE COMPLETE; failures=",failures)
	quit(1 if failures else 0)
