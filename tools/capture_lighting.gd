extends SceneTree
## Same five cameras and frozen actors/wind for PR09/Golden/Blue comparison.
const FILES={"baseline":"pr09_baseline","golden_hour":"golden_hour","blue_hour":"blue_hour"}
var folder:="/tmp/forest-lighting"
var selected:="golden_hour"
var candidate:=""
var quick:=false
var measurements:={}
func _initialize() -> void: call_deferred("capture")
func capture() -> void:
	if DisplayServer.get_name()=="headless":
		push_error("A rendering display is required")
		quit(1)
		return
	for arg in OS.get_cmdline_user_args():
		if arg.begins_with("--output="): folder=arg.trim_prefix("--output=")
		if arg.begins_with("--preset="): selected=arg.trim_prefix("--preset=")
		if arg.begins_with("--candidate="): candidate=arg.trim_prefix("--candidate=")
		if arg=="--quick": quick=true
	if not FILES.has(selected):
		push_error("Unknown lighting preset")
		quit(1)
		return
	var preset: ForestLightingPreset=load("res://assets/lighting/"+FILES[selected]+".tres").duplicate()
	if not candidate.is_empty():
		preset.ambient_color=Color("A7BDD5")
		preset.sky_top=Color("6E9DC2")
		preset.sky_energy=.8
	if candidate=="side":
		preset.sun_rotation=Vector3(-22,-62,0);preset.sun_energy=1.1;preset.ambient_energy=.58
	elif candidate=="low":
		preset.sun_rotation=Vector3(-16,-72,0);preset.sun_energy=1.2;preset.ambient_energy=.6
	elif candidate=="front":
		preset.sun_rotation=Vector3(-26,-32,0);preset.sun_energy=1.0;preset.ambient_energy=.52
	DirAccess.make_dir_recursive_absolute(folder)
	var hub=load("res://scenes/world/forest_hub.tscn").instantiate()
	hub.set_meta("lighting_preset",preset)
	root.add_child(hub)
	for material in hub.get_node("CuratedGroundCover").materials.values(): material.set_shader_parameter("wind_strength",0.0)
	for i in range(15): await process_frame
	hub.player.blocked=true
	hub.player.set_physics_process(false)
	var camera: Camera3D=root.get_camera_3d()
	camera.set_process(false)
	await save_frame("01-gameplay.png")
	hub.ui.hide()
	pose(camera,Vector3(13,6.9,16),Vector3(-.4,2.6,-.6),42)
	await save_frame("02-cafe-exterior.png")
	pose(camera,Vector3(11,4.8,20),Vector3(1,.4,8),50)
	await save_frame("03-forest-clearing.png")
	if not quick:
		pose(camera,Vector3(15,2.1,-4),Vector3(-7,6.5,5),58)
		await save_frame("04-low-sky.png")
		pose(camera,Vector3(27,26,34),Vector3(0,2,0),46)
		await save_frame("05-wide-composition.png")
	var record:={"preset":preset.preset_name,"candidate":candidate,"sun_rotation":str(preset.sun_rotation),"sun_energy":preset.sun_energy,"ambient_energy":preset.ambient_energy,"rendering_method":RenderingServer.get_current_rendering_method(),"measurements":measurements}
	var file:=FileAccess.open(folder.path_join("capture.json"),FileAccess.WRITE)
	file.store_string(JSON.stringify(record,"\t"))
	print("Lighting review captured: ",folder," ",record)
	quit()
func pose(camera: Camera3D,eye: Vector3,focus: Vector3,fov: float) -> void:
	camera.position=eye
	camera.fov=fov
	camera.look_at(focus)
func save_frame(name: String) -> void:
	for i in range(5): await process_frame
	await RenderingServer.frame_post_draw
	measurements[name]={"draw_calls":Performance.get_monitor(Performance.RENDER_TOTAL_DRAW_CALLS_IN_FRAME),"primitives":Performance.get_monitor(Performance.RENDER_TOTAL_PRIMITIVES_IN_FRAME)}
	if root.get_texture().get_image().save_png(folder.path_join(name))!=OK:
		push_error("PNG write failed: "+name)
		quit(1)
