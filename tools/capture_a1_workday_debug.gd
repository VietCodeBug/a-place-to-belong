extends "res://tools/a1_story_walkthrough.gd"
## QA camera starts at an existing lane. Time changes use the prototype clock and its normal schedules.

func walkthrough() -> bool:
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
