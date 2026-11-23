extends "res://tools/capture_a1_village_street.gd"
## Review cameras use A's real eye height. Pets follow their runtime routes during capture.

func run() -> void:
	TranslationServer.set_locale("vi")
	var film := "--video" in OS.get_cmdline_user_args()
	for arg in OS.get_cmdline_user_args():
		if arg.begins_with("--out="):
			output = arg.trim_prefix("--out=")
	DirAccess.make_dir_recursive_absolute(output)
	root.size = Vector2i(640,360) if film else Vector2i(1280,720)
	hub = HUB.instantiate()
	hub.set_meta("story_prototype",true)
	root.add_child(hub)
	stage = hub.story_prototype
	stage.skip_intro()
	stage.enter_outdoors()
	hub.ui.notice.text = ""
	stage.weather.paused = true
	stage.weather.set_time(11.17)
	stage.weather.set_weather("partly_cloudy",true)
	var animals: Node3D = hub.get_node("A1RiverValley/VillagePets")
	if film:
		await view(Vector2(5.0,123.82),Vector2(5.5,131.2),.73)
		await record(0,54,animals.pets[0],animals.pets[1])
		var cat: Node3D = animals.pets[1].body
		var at := Vector2(cat.position.x,cat.position.z)
		await view(at+Vector2(.72,-2.1),at,.35)
		await record(54,42,animals.pets[0],animals.pets[1],cat)
	else:
		await view(Vector2(5.72,123.7),Vector2(5.6,149),2.65)
		await grab("01-loi-chinh")
		await view(Vector2(5.60,126.2),Vector2(10.30,130.40),1.59)
		await grab("02-sap-nong-san-va-gom")
		await view(Vector2(4.86,127.32),Vector2(2.27,126.55),1.21)
		await grab("03-sap-banh")
		await view(Vector2(4.62,131.35),Vector2(1.08,133.68),1.10)
		await grab("04-san-ben")
		await pet_portrait(animals.pets[0].body,"05-cho-shiba")
		await pet_portrait(animals.pets[1].body,"06-meo-gung")
	print("VILLAGE_MARKET_CAPTURE PASS ",output)
	hub.queue_free()
	await process_frame
	quit()

func record(start: int,count: int,dog,cat,focus: Node3D = null) -> void:
	var before_dog: float = dog.traveled
	var before_cat: float = cat.traveled
	for frame in range(start,start+count):
		if focus!=null:
			look_at_pet(focus)
		await RenderingServer.frame_post_draw
		root.get_texture().get_image().save_png(output+"/%06d.png"%frame)
	print("PET_MOTION ",start," dog_metres=",dog.traveled-before_dog," cat_metres=",cat.traveled-before_cat)

func pet_portrait(pet: Node3D, image: String) -> void:
	var at := Vector2(pet.position.x,pet.position.z)
	var direction := Vector2(sin(pet.rotation.y),cos(pet.rotation.y))
	var side := direction*1.30+direction.orthogonal()*1.25
	await view(at+side,at,.33)
	for tick in 4:
		look_at_pet(pet)
		await RenderingServer.frame_post_draw
	root.get_texture().get_image().save_png(output+"/"+image+".png")

func look_at_pet(pet: Node3D) -> void:
	var camera := hub.get_node("GameplayCamera") as Camera3D
	hub.eyes.aim(pet.global_position+Vector3.UP*.30-camera.global_position)
	hub.eyes.place(camera,hub.player,0.0,true)
