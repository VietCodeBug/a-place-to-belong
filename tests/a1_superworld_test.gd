extends SceneTree
## godot --headless --path . --disable-render-loop --fixed-fps 60 --script tests/a1_superworld_test.gd
const HUB = preload("res://scenes/world/forest_hub.tscn")
const PLAN = preload("res://scripts/world/village_a_layout.gd")
const FIELD = preload("res://scripts/world/superworld/terrain_field.gd")
const INPUTS := ["move_left","move_right","move_up","move_down"]
var failed := false
var hub: Node3D
var world: Node3D
var actor: CharacterBody3D
var field: FIELD
var stream_samples: Array[int] = []
var cover_samples: Array[int] = []

func _initialize() -> void:
	call_deferred("run")

func check(condition: bool, message: String) -> void:
	if not condition:
		push_error(message)
		failed = true

func put(p: Vector2) -> void:
	world.prepare_at(p)
	actor.position = Vector3(p.x,field.height(p)+.16,p.y)
	actor.velocity = Vector3.ZERO
	for i in 12:
		await physics_frame

func steer(destination: Vector2) -> void:
	for action in INPUTS:
		Input.action_release(action)
	var d := (destination-Vector2(actor.position.x,actor.position.z)).normalized().rotated(PI/4.0)
	Input.action_press("move_left" if d.x<0 else "move_right",absf(d.x))
	Input.action_press("move_up" if d.y<0 else "move_down",absf(d.y))

func walk(destination: Vector2) -> bool:
	var start := Vector2(actor.position.x,actor.position.z)
	var budget := ceili((start.distance_to(destination)+7.0)*24.0)
	for i in budget:
		if destination.distance_to(Vector2(actor.position.x,actor.position.z))<.44:
			return true
		steer(destination)
		await physics_frame
		if world.streamer.frame_tiles_changed>0:
			stream_samples.append(world.streamer.frame_build_usec)
		if world.streamer.frame_cover_jobs>0:
			cover_samples.append(world.streamer.frame_cover_usec)
	return false

func release() -> void:
	for action in INPUTS+["jog","a1_dive","a1_surface"]:
		Input.action_release(action)

func probe(p: Vector2) -> void:
	var y := field.height(p)
	var query := PhysicsRayQueryParameters3D.create(Vector3(p.x,y+.70,p.y),Vector3(p.x,y-.70,p.y))
	var hit := actor.get_world_3d().direct_space_state.intersect_ray(query)
	check(not hit.is_empty() and absf(hit.position.y-y)<.05,"Terrain sample/collider mismatch at %s" % p)

func press_key(key: Key) -> void:
	var event := InputEventKey.new()
	event.keycode=key
	event.physical_keycode=key
	event.pressed=true
	hub.ui._unhandled_input(event)

func run() -> void:
	var started := Time.get_ticks_msec()
	hub = HUB.instantiate()
	hub.set_meta("a1_superworld",true)
	root.add_child(hub)
	world = hub.superworld
	actor = hub.player
	field = world.field
	print("boot_ms=",Time.get_ticks_msec()-started)
	check(field.bounds.size==Vector2(4096,4096),"Registry dimensions changed")
	check(field.regions.filter(func(region: Dictionary) -> bool: return region.playable).size()==1,"Only A1 is playable")
	var cottage: Node3D = hub.get_node("ForestHouseA")
	check(Vector2(cottage.position.x,cottage.position.z)==PLAN.HOUSE_A,"House A moved")
	var village := hub.get_node("A1RiverValley/VillageA")
	for entry in PLAN.BUILDINGS:
		var lot := village.get_node(entry[0]) as Node3D
		check(Vector2(lot.position.x,lot.position.z).distance_to(Vector2(entry[2],entry[3]))<.001,"Village lot moved")
	await put(Vector2(62,-303))
	for p in [Vector2(63.95,-306.8),Vector2(64.0,-306.8),Vector2(64.05,-306.8),Vector2(127.97,-308),Vector2(128.03,-308)]:
		probe(p)
	var other := FIELD.new(Callable(ForestLandscape,"height_at"))
	check(is_equal_approx(other.height(Vector2(752,732)),field.height(Vector2(752,732))),"Terrain seed changed on reload")

	# Explore far from the corridor and confirm that the previous physics ring was unloaded.
	await put(Vector2(-2037,1757))
	probe(Vector2(-2045,1754))
	check(world.streamer.solid.has(field.tile(Vector2(-2037,1757))),"Far chunk is not physical")
	check(not world.streamer.solid.has(Vector2i(1,-5)),"Distant collider was retained")
	await put(FIELD.LAKE+Vector2(2,-3))
	probe(FIELD.LAKE)
	check(actor.position.y<FIELD.WATER-27.0,"Center basin did not load deep collision")
	await put(Vector2(209,-462))
	for p in [Vector2(223,-462),Vector2(256.04,-462),Vector2(269,-470)]:
		probe(p)
	check(field.height(FIELD.LAKE)<FIELD.WATER-28.0,"Lake has no deep basin")
	check(await walk(Vector2(244,-462)) and actor.state=="swimming","Continuous shore approach failed")
	Input.action_press("a1_dive")
	check(await walk(Vector2(274,-462)),"Underwater swim blocked")
	release()
	check(actor.position.y<FIELD.WATER-2.0 and world.lake.underwater,"Dive/camera never went underwater")
	check(world.lake.underside.visible,"Dive did not reveal the underside of the lake")
	probe(Vector2(271,-463))
	Input.action_press("a1_surface")
	for i in 210:
		if actor.position.y>FIELD.WATER-1.05:
			break
		await physics_frame
	check(actor.position.y>FIELD.WATER-1.12,"Surfacing from depth failed")
	check(await walk(Vector2(208,-462)) and actor.state!="swimming","Could not leave lake")
	release()
	for i in 3:
		await process_frame
	check(not world.lake.underside.visible,"Submerged surface remained visible on shore")

	await put(Vector2(299,-471))
	check(world.lake.get_node("UnderwaterArch").find_children("*","CollisionShape3D",true,false).size()==1,"Underwater arch collision is missing")
	var arch := world.lake.get_node("UnderwaterArch") as MeshInstance3D
	var roof := PhysicsRayQueryParameters3D.create(Vector3(FIELD.ARCH.x,8,FIELD.ARCH.y),
		Vector3(FIELD.ARCH.x,field.height(FIELD.ARCH)+1.0,FIELD.ARCH.y))
	var roof_hit := actor.get_world_3d().direct_space_state.intersect_ray(roof)
	check(not roof_hit.is_empty() and arch.is_ancestor_of(roof_hit.collider),"Ray missed the arch roof collider")
	Input.action_press("a1_dive")
	check(await walk(Vector2(311,-471)),"Submerged arch passage blocked")
	release()
	await put(FIELD.PAVILION+Vector2(-8,0))
	actor.position.y = -.58
	var pavilion: Node3D = world.lake.get_node("FloodedPavilion")
	var crown := Vector3(FIELD.PAVILION.x+.72,FIELD.WATER+.3,FIELD.PAVILION.y-.42)
	var ceiling := PhysicsRayQueryParameters3D.create(crown,crown-Vector3.UP*4.0)
	var ceiling_hit := actor.get_world_3d().direct_space_state.intersect_ray(ceiling)
	check(not ceiling_hit.is_empty() and pavilion.is_ancestor_of(ceiling_hit.collider),"Flooded pavilion roof is missing collision")
	var fish_meshes := {}
	for school: MultiMeshInstance3D in world.lake.schools:
		fish_meshes[school.multimesh.mesh.get_instance_id()] = true
	check(fish_meshes.size()==3 and world.lake.schools.size()==4,"Underwater schools did not load all silhouettes")
	check(await walk(FIELD.PAVILION+Vector2(2.25,.1)) and actor.state=="swimming","Open pavilion entry does not allow swimming")
	release()
	for site in [["StairGate",FIELD.STAIR_GATE,Vector2(-10,0),Vector2(3,0)],
			["Colonnade",FIELD.COLONNADE,Vector2(-10,0),Vector2(6,0)],
			["BrokenTower",FIELD.BROKEN_TOWER,Vector2(-7,-.94),Vector2(0,-.94)]]:
		var center: Vector2 = site[1]
		var ruin: Node3D = world.lake.get_node(site[0])
		await put(center+site[2])
		actor.position.y = ruin.position.y+.93
		var site_floor := Vector3(center.x,ruin.position.y,center.y)
		var query := PhysicsRayQueryParameters3D.create(site_floor+Vector3.UP*.3,site_floor-Vector3.UP*1.4)
		var foundation_hit := actor.get_world_3d().direct_space_state.intersect_ray(query)
		check(not foundation_hit.is_empty() and ruin.is_ancestor_of(foundation_hit.collider),"Ruin floor collision missing: "+site[0])
		check(await walk(center+site[3]) and actor.state=="swimming","Ruin entrance blocked: "+site[0])
		release()
	var plants: Node3D = world.lake.get_node("LakeHabitats")
	var plant_meshes := {}
	for cluster: MultiMeshInstance3D in plants.get_children():
		plant_meshes[cluster.multimesh.mesh.get_instance_id()] = true
	check(plant_meshes.size()==3 and plants.instance_count>=1000,"Submerged plant habitat incomplete")
	print("lake_plant_clumps=",plants.instance_count," lake_plant_batches=",plants.get_child_count())
	for trench: Vector2 in [FIELD.WEST_TRENCH,FIELD.EAST_TRENCH]:
		world.prepare_at(trench)
		actor.position = Vector3(trench.x,-4.0,trench.y)
		actor.velocity = Vector3.ZERO
		for settle in 12:
			await physics_frame
		probe(trench)
		check(FIELD.WATER-field.height(trench)>40.0,"Trench geometry is too shallow")
		Input.action_press("a1_dive")
		for tick in 290:
			await physics_frame
		var limit: float = world.lake.lowest_swim_height(trench)
		check(absf(actor.position.y-limit)<.12 and world.lake.at_dive_limit(actor.position),"Held dive bypassed trench current")
		release()
		Input.action_press("a1_surface")
		for tick in 145:
			await physics_frame
		check(actor.position.y>limit+5.0,"Trench current trapped ascent")
		release()
	await put(Vector2(488,-475))
	actor.position.y = -17.3
	Input.action_press("a1_dive")
	check(await walk(FIELD.EAST_TRENCH) and world.lake.at_dive_limit(actor.position),"Lateral trench entry did not follow the safe ascent edge")
	check(actor.position.y>=world.lake.lowest_swim_height(Vector2(actor.position.x,actor.position.z))-.12,"Lateral approach bypassed the trench current")
	release()
	await put(Vector2(208,-462))
	var weather: Node = hub.get_node("ForestWeather")
	weather.paused = true
	weather.set_time(13.50)
	weather.set_weather("light_rain",true)
	for tick in 30:
		await process_frame
	var compass: Control = hub.ui.compass_map
	check(compass.visible and compass.map_tile!=null,"A1 minimap did not generate a local terrain tile")
	check(compass.pin.distance_to(Vector2(208,-462))<.4 and compass.readout=="13:30" and compass.glyph.icon_kind=="rain",
		"Minimap position or live weather readout diverged from gameplay")
	weather.set_weather("partly_cloudy",true)
	weather.paused = false

	press_key(KEY_M)
	check(hub.ui.valley_map.visible and actor.blocked,"M did not open map and pause movement")
	await process_frame
	await process_frame
	check(not compass.visible and hub.ui.valley_map.zoom==15.0 and hub.ui.valley_map.center.distance_to(compass.pin)<.4,
		"First map visit should replace the minimap with the detailed area around the player")
	check(hub.ui.valley_map.texture!=null and hub.ui.valley_map.explored.has(field.tile(Vector2(208,-462))),"World map discovery mismatch")
	press_key(KEY_TAB)
	check(hub.ui.valley_map.atlas,"Region registry tab did not open")
	press_key(KEY_F7)
	check(hub.ui.valley_map.show_chunks,"Chunk map toggle failed")
	press_key(KEY_M)
	check(not actor.blocked,"Map failed to return control")
	await process_frame
	check(compass.visible,"Minimap did not return after closing the full map")

	var route: Array = FIELD.TRAILS[1].duplicate()
	route.reverse()
	Input.action_press("jog")
	var encountered := {}
	for waypoint: Vector2 in route:
		if not await walk(waypoint):
			check(false,"Lake-to-village trail blocked at %s; player at %s" % [waypoint,actor.position])
			break
		encountered[field.tile(waypoint)]=true
	release()
	check(encountered.size()>=10,"Lake approach did not traverse enough distinct chunks")
	await put(Vector2(272,151))
	Input.action_press("jog")
	check(await walk(FIELD.MEADOW),"Meadow path could not be walked")
	release()
	var meadow_tile: Node3D = world.streamer.chunks[field.tile(FIELD.MEADOW)]
	for i in 100:
		if meadow_tile.has_node("Verge3"):
			break
		await process_frame
	var flowers := meadow_tile.find_child("MeadowFlowers",true,false) as MultiMeshInstance3D
	check(flowers!=null and flowers.visible,"Spring meadow has no flower groups")
	# Walk and close the two optional loops from their published trail vertices.
	var stops := world.get_node("ScenicRestPoints")
	check(stops.get_child_count()>=FIELD.RESTS.size(),"Exploration stops are missing")
	for index in [4,5]:
		var loop: Array = FIELD.TRAILS[index]
		await put(loop[0])
		Input.action_press("jog")
		for destination: Vector2 in loop.slice(1):
			var reached := await walk(destination)
			check(reached,"Exploration loop %d blocked near %s" % [index,destination])
			if not reached:
				break
		release()
	await put(FIELD.MEADOW)
	for i in 100:
		meadow_tile = world.streamer.chunks[field.tile(FIELD.MEADOW)]
		if meadow_tile.has_node("Verge3"):
			break
		await process_frame
	flowers = meadow_tile.find_child("MeadowFlowers",true,false) as MultiMeshInstance3D
	var climate := hub.get_node("ForestWeather")
	climate.set_weather("heavy_rain",true)
	for i in 3:
		await process_frame
	check(world.streamer.material.get_shader_parameter("wetness")>.2,"Rain did not reach new terrain")
	check(world.streamer.panorama_material.get_shader_parameter("wetness")>.2,"Rain did not reach the panorama")
	check(world.lake.water_material.get_shader_parameter("rain")>.2,"Rain did not reach lake surface")
	check(world.lake.outer_water.get_shader_parameter("rain")>.2,"Rain did not reach shallow water")
	climate.set_weather("clear",true)
	hub.get_node("A1RiverValley").set_season_palette(3)
	check(flowers!=null and not flowers.visible,"Snow season must remove meadow flowers")
	await put(Vector2(223,-746))
	var slope_base := actor.position.y
	Input.action_press("jog")
	check(await walk(Vector2(239,-796)) and await walk(FIELD.OVERLOOK),"Highland path could not be walked")
	release()
	check(actor.position.y > slope_base+7.0,"Overlook route did not climb the terrain")
	check(world.streamer.material.get_shader_parameter("season")==3,"Streamed terrain did not follow seasons")
	check(world.streamer.panorama_material.get_shader_parameter("season")==3,"Panorama did not follow seasons")
	print("tiles=",world.streamer.chunks.size()," physical=",world.streamer.solid.size()," total_created=",world.streamer.built_count,
		" far=",world.streamer.far_count," reached_waypoint_tiles=",encountered.size()," final_player=",actor.position)
	cover_samples.sort()
	if not cover_samples.is_empty():
		print("cover_jobs=",cover_samples.size()," cover_p50_us=",cover_samples[cover_samples.size()>>1],
			" cover_p95_us=",cover_samples[floori(cover_samples.size()*.95)]," cover_max_us=",cover_samples.back())
	stream_samples.sort()
	if not stream_samples.is_empty():
		print("stream_frames=",stream_samples.size()," stream_p50_us=", stream_samples[stream_samples.size()>>1],
			" stream_p95_us=",stream_samples[floori(stream_samples.size()*.95)]," stream_max_us=",stream_samples.back())
	print("A1_SUPERWORLD_TEST ", "FAILED" if failed else "PASS")
	quit(1 if failed else 0)
