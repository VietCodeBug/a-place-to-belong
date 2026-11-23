extends "res://tools/a1_story_walkthrough.gd"
## Exercises the full controller route before testing alternate world state.

func extra_checks() -> void:
	var registry: Dictionary = stage.village.registry
	var stations: Dictionary = stage.village.stations
	var graph: AStarGrid2D = stage.village.graph
	check(registry.size()==30 and not registry.has("THOMAS"),"Resident IDs changed")
	var totals := {"core":0,"supporting":0,"ambient":0}
	var edges := {}
	for row in stage.snapshot.residents:
		var person: Node3D = registry[row.id]
		var anchors: Array = stations[row.id]
		check(person.data.name_en==row.name_en and person.data.household_id==row.household_id,"Roster was renamed")
		totals[row.narrative_priority] += 1
		check(stage.village.layout.building_use[stage.village.layout.homes[row.household_id]]=="residence","Mapped home is not residential")
		for cell: Vector2i in anchors:
			check(not graph.is_point_solid(cell),"NPC station intersects a collider")
		for pair in [[anchors[0],anchors[1]],[anchors[1],anchors[2]]]:
			var route := graph.get_id_path(pair[0],pair[1])
			check(not route.is_empty(),"NPC route missing for "+row.id)
			for index in range(1,route.size()):
				edges[Vector2(route[index-1]+route[index])*.5] = true
	check(totals=={"core":8,"supporting":10,"ambient":12},"Roster tiers changed")
	check_route_clearance(edges)
	check(stage.session.memory(WORK.HAZEL).heard.has("after_help"),"Garden feedback missing")
	check(stage.session.memory(WORK.OWEN).heard.has("after_help"),"Repair feedback missing")
	var camera := player.get_viewport().get_camera_3d()
	check(camera.global_position.distance_to(player.global_position+Vector3.UP*1.55)<.08,"Room camera left the eye")
	check((camera.cull_mask&(1<<18))==0,"Avatar still intersects the local view")
	var before: float = stage.weather.hours
	await pause(1.4)
	check(stage.weather.hours>before,"Clock stopped indoors")
	stage.weather.set_weather("heavy_rain",true)
	await pause(.4)
	check(stage.house.rain.emitting,"Window did not follow rain")
	stage.weather.set_weather("clear",true)
	if not await use(stage.house.targets.front_door,Vector2(-.42,2.84)) or not await press_target(stage.exterior_door):
		return
	check(stage.inside and stage.house.items.slots.basin_side.prop==stage.house.items.props.mug and player==hub.player,"Second doorway lost the relocated cup")
	check(not stage.house.targets.has("window_01"),"Window still exposes an interaction")
	var things: Node3D = stage.house.items
	things.pick_up(things.props.basket)
	check(not things.slots.shelf_free.target.is_in_group("interactables"),"An oversized basket fits the narrow shelf")
	things.put_down(things.slots.shelf_free)
	check(things.carried==things.props.basket,"Oversized basket was placed on the narrow shelf")
	stage.enter_outdoors()
	check(things.carried==null and things.slots.cupboard.prop==things.props.basket,"Leaving the house lost the held basket")
	var key := InputEventKey.new()
	key.physical_keycode = KEY_M
	key.pressed = true
	ui._unhandled_input(key)
	check(ui.valley_map.visible and player.blocked,"M lost map access")
	ui._unhandled_input(key)
	var outdoor := player.get_viewport().get_camera_3d()
	check(outdoor.global_position.distance_to(player.global_position+Vector3.UP*1.55)<.07,"Outdoor camera not at eye")
	var thomas: Node3D = stage.thomas
	player.position = hub.ground(PLAN.THOMAS.x+.92,PLAN.THOMAS.y,.09)
	player.velocity = Vector3.ZERO
	await pause(.54)
	player.eyes.yaw = -.5*PI
	await pause(.25)
	check(ui.active!=thomas.target,"Thomas was selected while looking away")
	if not await press_target(thomas.target):
		return
	check(ui.story_text.text.contains("củi") and not ui.panel.visible,"Thomas should acknowledge the world change in a compact card")
	ui.close()
	var hazel: Node3D = registry[WORK.HAZEL]
	stage.conversation.open(hazel)
	check(ui.story_text.text.contains("luống lúc nãy ổn"),"Hazel should remember the watered beds")
	ui.close()
	var owen: Node3D = registry[WORK.OWEN]
	stage.conversation.open(owen)
	check(ui.story_text.text.contains("nêm cậu chọn"),"Owen should remember that the player fitted the wedge")
	ui.close()
	player.position = hub.ground(hazel.point.x+.88,hazel.point.y,.08)
	player.velocity = Vector3.ZERO
	stage.weather.set_time(10.9)
	await pause(3.0)
	stage.weather.set_time(21.0)
	await pause(2.5)
	var home: Vector2 = Vector2(stations[WORK.HAZEL][0])
	check(hazel.task=="REST" and (not hazel.route.is_empty() or hazel.point.distance_to(home)<.13),"Hazel failed to route home at night")
	stage.session.objects.erase(WORK.OWEN+"_result")
	stage.session.activities.erase(WORK.OWEN)
	stage.session.memory(WORK.OWEN).activity_done = false
	stage.activities.begin(WORK.OWEN,"hold")
	stage.activities.repair()
	check(stage.session.objects.wooden_latch=="held","Hold choice did not lift the piece")
	stage.activities.repair()
	check(stage.session.objects.wooden_latch=="fixed" and not stage.activities.fitted_wedge.visible,"Hold choice silently installed a wedge")
	stage.weather.set_time(10.9)
	await pause(.6)
	stage.conversation.open(owen)
	check(ui.story_text.text.contains("mình chỉnh lại"),"Owen should remember the repair without a wedge")
	ui.close()
	stage.session.object_state(CASES.MEAL,"available")
	stage.situations.begin(CASES.MEAL)
	stage.situations.pickup(CASES.MEAL)
	stage.situations.finish(CASES.MEAL,"player")
	check(stage.situations.table_bowl.visible and stage.session.memory("VLA-06")[CASES.MEAL]=="player","Community table did not persist")
	stage.session.objects.erase(WORK.HAZEL+"_result")
	stage.session.objects.erase("garden_1")
	stage.session.activities.erase(WORK.HAZEL)
	stage.session.memory(WORK.HAZEL).activity_done = false
	stage.activities.begin(WORK.HAZEL)
	stage.activities.take_can()
	check(stage.activities.progress(WORK.HAZEL)==3,"Picking up the watering can should preserve the wet bed")
	stage.session.object_state(CASES.WOOD,"available")
	stage.situations.begin(CASES.WOOD)
	stage.situations.pickup(CASES.WOOD)
	player.position = hub.ground(7.2,151.3,.08)
	player.velocity = Vector3.ZERO
	await pause(1.0)
	check(not stage.activities.in_progress(WORK.HAZEL) and stage.session.objects.watering_can=="by_garden", "Walking away did not release Hazel's watering can")
	check(stage.session.objects.garden_0=="watered" and stage.situations.status(CASES.WOOD)=="available", "Leaving undid a watered bed or lost the firewood")
	await pause(38.0)
	check(stage.session.objects.get(WORK.HAZEL+"_result")=="self" and stage.situations.status(CASES.WOOD)=="self", "NPCs should be able to finish if A walks away")
	var shore := Vector2(205,-462)
	hub.superworld.prepare_at(shore)
	player.position = hub.ground(shore.x,shore.y,.08)
	player.velocity = Vector3.ZERO
	await pause(.55)
	if not await path_to(Vector2(242,-462),.55):
		return
	check(player.state=="swimming","A1 first-person failed to switch to swim")
	Input.action_press("a1_dive")
	var crossed := await path_to(Vector2(272,-462),.55)
	Input.action_release("a1_dive")
	check(crossed and outdoor.global_position.distance_to(player.global_position+Vector3.UP*.98)<.23 and hub.superworld.lake.underwater,
		"First-person camera failed to follow the avatar underwater")
	check(stage.village.work_completions>0,"No NPC completed any real prop delivery")
	print("CHAPTER31_TEST registry=",registry.size()," route_edges=",edges.size()," work_deliveries=",stage.village.work_completions,
		" transition_us=",stage.transition_usec)

func check_route_clearance(edges: Dictionary) -> void:
	var space: PhysicsDirectSpaceState3D = stage.village.get_world_3d().direct_space_state
	var test := PhysicsShapeQueryParameters3D.new()
	var shape := BoxShape3D.new()
	shape.size = Vector3(.4,1.0,.4)
	test.shape = shape
	for at: Vector2 in edges:
		test.transform.origin = hub.ground(at.x,at.y,.82)
		if not check(space.intersect_shape(test,1).is_empty(),"Scheduled route crosses a collider near %s" % at):
			return
