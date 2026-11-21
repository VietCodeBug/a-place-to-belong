extends "res://tools/a1_story_walkthrough.gd"
## QA camera starts at an existing lane. Time changes use the prototype clock and its normal schedules.

func walkthrough() -> bool:
	if "--meeting" in OS.get_cmdline_user_args():
		return await lunch_exchange()
	boundary(false)
	stage.skip_intro()
	stage.enter_outdoors()
	stage.weather.set_time(6.25)
	var verge := Vector2(-7.6,114.4)
	hub.superworld.prepare_at(verge)
	player.position = hub.ground(verge.x,verge.y,.06)
	player.velocity = Vector3.ZERO
	await pause(1.4)
	var hazel: Node3D = stage.actor(WORK.HAZEL)
	if not check(hazel!=null and hazel.task=="REST","Start of schedule QA must be at home"):
		return false
	var start: Vector2 = hazel.point
	boundary(true,"QA · 06:15 ở nhà, sau đó tua đồng hồ tới ca sáng")
	ui.story_notice("QA lịch NPC · đứng ở lề ngõ · 06:15")
	aim_to(hazel.global_position+Vector3.UP*1.1)
	await pause(1.10)
	stage.weather.set_time(8.60)
	ui.story_notice("QA lịch NPC · đổi giờ sang 08:36")
	var carried := false
	var moved := false
	for i in 174:
		aim_to(hazel.global_position+Vector3.UP*1.01)
		moved = moved or hazel.point.distance_to(start)>2.0
		carried = carried or hazel.visual.hauling
		if carried and hazel.work_phase=="resting":
			break
		await pause(.14)
	await still("hazel-ca-sang")
	var done: int = stage.village.work_completions
	print("NPC_WORKDAY start=",start," end=",hazel.point," carried=",carried," finished=",done)
	return check(moved and carried and done>0,"Hazel did not traverse the scheduled route and use the prop")

func lunch_exchange() -> bool:
	boundary(false)
	stage.skip_intro()
	stage.enter_outdoors()
	stage.weather.set_time(13.05)
	var verge := Vector2(5.2,125.2)
	hub.superworld.prepare_at(verge)
	player.position = hub.ground(verge.x,verge.y,.06)
	player.velocity = Vector3.ZERO
	var population: Node3D = stage.village
	while not population.ready_to_visit:
		await physics_frame
	var clara: Node3D = stage.actor("VLA-06")
	var grace: Node3D = stage.actor("VLA-23")
	var meeting: Vector2 = (Vector2(population.stations["VLA-06"][2])+Vector2(population.stations["VLA-23"][2]))*.5
	aim_to(hub.ground(meeting.x,meeting.y)+Vector3.UP*1.48)
	for tick in 240:
		if population.exchange.get("id","")=="VLA-OVH-02":
			break
		await pause(.27)
	if not check(population.exchange.get("id","")=="VLA-OVH-02","Scheduled exchange did not appear near the community table"):
		return false
	boundary(true,"QA · Clara và Grace gặp nhau giờ nghỉ")
	ui.story_notice("QA lịch NPC · 13:03 ở sân chung")
	await pause(2.0)
	await still("clara-grace-san-chung")
	var first_seen: bool = clara.visual.gesture_label.visible
	var second_seen := false
	for tick in 34:
		first_seen = first_seen or clara.visual.gesture_label.visible
		second_seen = second_seen or grace.visual.gesture_label.visible
		await pause(.23)
	print("NPC_EXCHANGE clara=",clara.point," grace=",grace.point," both_spoke=",first_seen and second_seen," player_dialogue=",stage.conversation.is_open())
	return check(first_seen and second_seen and not stage.conversation.is_open(),"Clara and Grace did not exchange lines independently")
