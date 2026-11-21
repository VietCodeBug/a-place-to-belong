extends "res://tools/a1_story_walkthrough.gd"
## Run with --headless --fixed-fps 60 --disable-render-loop.

func before_accept(id: String) -> void:
	if not choose("Để lúc khác"):
		return
	await continue_lines()
	check(stage.activities.progress(id)==0 and not stage.session.memory(id).activity_done,"Declining should leave the activity available")
	if choose("Đề nghị giúp"):
		await continue_lines()

func extra_checks() -> void:
	var registry: Dictionary = stage.village.registry
	var stations: Dictionary = stage.village.stations
	var graph: AStarGrid2D = stage.village.graph
	var edges: Dictionary = {}
	check(registry.size()==30 and not registry.has("THOMAS"),"Registry must contain only the 30 village residents")
	var totals := {"core":0,"supporting":0,"ambient":0}
	var work_cells: Dictionary = {}
	for row in stage.snapshot.residents:
		var resident: Node3D = registry[row.id]
		var anchors: Array = stations[row.id]
		check(resident.data.name_en==row.name_en and resident.data.household_id==row.household_id,"Roster mapping changed")
		totals[row.narrative_priority] += 1
		check(stage.village.layout.building_use[stage.village.layout.homes[row.household_id]]=="residence","Mapped home is not residential")
		check(not work_cells.has(anchors[1]),"Two resident work points overlap")
		work_cells[anchors[1]] = true
		for cell: Vector2i in anchors:
			check(not graph.is_point_solid(cell),"NPC station intersected a collider for "+row.id)
		for endpoints in [[anchors[0],anchors[1]],[anchors[1],anchors[2]]]:
			var route := graph.get_id_path(endpoints[0],endpoints[1])
			check(not route.is_empty(),"Missing schedule route for "+row.id)
			for index in range(1,route.size()):
				var midpoint := Vector2(route[index-1]+route[index])*.5
				edges[midpoint] = true
	check(totals=={"core":8,"supporting":10,"ambient":12},"Roster tiers changed")
	check_route_clearance(edges)
	check(stage.session.memory(WORK.HAZEL).heard.has("after_help") and stage.session.memory(WORK.OWEN).heard.has("after_help"),"Completion feedback was not recorded")
	check(stage.session.memory("THOMAS").heard.has("THOMAS_DIRECTIONS") and not stage.session.memory("THOMAS").heard.has("THOMAS_ABOUT_HOUSE"),"Thomas should not auto-play all topics")
	for i in 2:
		if not await use(stage.house.targets.front_door,here(stage.house.targets.front_door)):
			return
		if not await use(stage.exterior_door,PLAN.HOUSE_APPROACH[0]):
			return
		check(stage.inside and player.get_world_3d()==stage.room_view.find_world_3d() and player==hub.player,"Repeated doorway reset the player or world")
	var before: float = stage.weather.hours
	await pause(2.0)
	check(stage.weather.hours>before,"Clock did not advance while indoors")
	stage.weather.set_weather("heavy_rain",true)
	await pause(.5)
	check(stage.house.rain.emitting,"Window did not follow outdoor rain")
	stage.weather.set_weather("clear",true)
	stage.enter_outdoors()
	var map_key := InputEventKey.new()
	map_key.physical_keycode = KEY_M
	map_key.pressed = true
	ui._unhandled_input(map_key)
	check(ui.valley_map.visible and player.blocked,"Story mode lost the outdoor A1 map")
	ui._unhandled_input(map_key)
	check(not ui.valley_map.visible and not player.blocked,"Closing the story map did not restore movement")
	stage.weather.set_time(10.9)
	var thomas: Node3D = stage.thomas
	player.position = hub.ground(PLAN.THOMAS.x+.85,PLAN.THOMAS.y,.09)
	player.velocity = Vector3.ZERO
	await pause(.55)
	if not await use(thomas.target,PLAN.THOMAS+Vector2(.78,0)):
		return
	check(stage.conversation.last_group=="THOMAS_REPEAT","Thomas repeated the introductory lines")
	ui.close()
	var hazel: Node3D = registry[WORK.HAZEL]
	player.position = hub.ground(hazel.point.x+.75,hazel.point.y,.09)
	player.velocity = Vector3.ZERO
	await pause(.55)
	if not await use(hazel.target,hazel.point+Vector2(.72,0)):
		return
	check(stage.conversation.last_group=="revisit" and stage.session.memory(WORK.HAZEL).return_visit,"Hazel did not recognize a later visit")
	await continue_lines()
	check(choose("Trò chuyện thêm"),"Real help and a separate return should allow the familiar topic")
	await continue_lines()
	ui.close()
	var before_walk: Vector2 = hazel.point
	stage.weather.set_time(21.0)
	await pause(2.5)
	check(hazel.behavior=="RETURN_HOME" and hazel.point.distance_to(before_walk)>1.0,"Schedule did not drive movement toward home")
	print("CHAPTER01_TEST registry=",registry.size()," unique_work=",work_cells.size()," route_edges=",edges.size()," states=",stage.session.flags)

func check_route_clearance(edges: Dictionary) -> void:
	var space: PhysicsDirectSpaceState3D = stage.village.get_world_3d().direct_space_state
	var probe := PhysicsShapeQueryParameters3D.new()
	var body := BoxShape3D.new()
	body.size = Vector3(.40,1.0,.40)
	probe.shape = body
	probe.collision_mask = 1
	for site: Vector2 in edges:
		probe.transform.origin = hub.ground(site.x,site.y,.82)
		if not check(space.intersect_shape(probe,1).is_empty(),"Schedule passes through a collider near %s" % site):
			return
