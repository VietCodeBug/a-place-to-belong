extends SceneTree
const RIG=preload("res://scripts/lighting/lighting_rig.gd")
var failures:=0
func _initialize() -> void: call_deferred("run")
func check(ok: bool,label: String) -> void:
	print("PASS: " if ok else "FAIL: ",label)
	if not ok: failures+=1
func run() -> void:
	var hub:=Node3D.new()
	root.add_child(hub)
	var cafe:=Node3D.new()
	hub.add_child(cafe)
	var lantern:=OmniLight3D.new()
	lantern.light_color=Color("FFD298")
	lantern.light_energy=.65
	cafe.add_child(lantern)
	for name in ["pr09_baseline","golden_hour","blue_hour"]:
		var preset: ForestLightingPreset=load("res://assets/lighting/"+name+".tres")
		RIG.apply(hub,preset)
		var env: Environment=hub.get_node("WorldEnvironment").environment
		var sun: DirectionalLight3D=hub.get_node("Sun")
		check(hub.get_child_count()==3,name+": exactly one sky/environment and one directional light, no extra geometry")
		check(is_instance_valid(lantern) and is_equal_approx(lantern.light_energy,.65) and lantern.light_color==Color("FFD298"),name+": original café local light is untouched")
		check(env.ssao_enabled and is_equal_approx(env.ssao_radius,.55) and is_equal_approx(env.ssao_intensity,.65) and is_equal_approx(env.ssao_power,1.1),name+": verified SSAO settings retained")
		if name=="pr09_baseline":
			check(sun.rotation_degrees.is_equal_approx(Vector3(-32,-44,0)) and is_equal_approx(sun.light_energy,.82) and is_equal_approx(env.ambient_light_energy,.85),"PR09 sun and ambient baseline reproduced")
			check(env.sky.sky_material.sky_top_color==Color("789794") and env.sky.sky_material.sky_horizon_color==Color("DDCCAD") and env.fog_depth_begin==38.0 and env.fog_depth_end==155.0,"PR09 sky and fog baseline reproduced")
		elif name=="golden_hour":
			check(sun.light_color.r>sun.light_color.b and env.ambient_light_energy<.85 and sun.light_energy>.82,"Golden Hour has warm directional emphasis with reduced ambient")
			check(sun.sky_mode==DirectionalLight3D.SKY_MODE_LIGHT_AND_SKY and sun.light_angular_distance>0,"Golden sky sun uses the actual directional light")
		else:
			check(sun.light_color.b>sun.light_color.r and sun.light_energy<.3,"Blue Hour uses low-energy cool directional fill")
			check(sun.sky_mode==DirectionalLight3D.SKY_MODE_LIGHT_ONLY,"Blue Hour does not add an inconsistent visible sun disc")
	check(ProjectSettings.get_setting("rendering/renderer/rendering_method")=="gl_compatibility","Compatibility remains the renderer")
	print("LIGHTING PRESETS COMPLETE; failures=",failures)
	quit(1 if failures else 0)
