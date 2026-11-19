extends SceneTree
var failures:=0
func _initialize() -> void: call_deferred("run")
func check(ok: bool,label: String) -> void:
	print("PASS: " if ok else "FAIL: ",label)
	if not ok: failures+=1
func run() -> void:
	var hub=load("res://scenes/world/forest_hub.tscn").instantiate();root.add_child(hub)
	for i in range(3): await process_frame
	var weather=hub.get_node("ForestWeather")
	weather.paused=true
	weather.set_time(12.)
	var noon_energy: float=weather.sun.light_energy
	var noon_cafe: float=weather.cafe_lights[0].light_energy
	check(noon_energy>1.,"daylight energizes actual directional sun")
	check(weather.environment.sky.sky_material is ShaderMaterial,"dynamic sky uses Compatibility shader")
	weather.set_time(0.)
	check(weather.sun.light_energy==0. and not weather.sun.shadow_enabled,"night disables below-horizon sunlight/shadows")
	check(weather.moon.light_energy>0.,"night has real moon illumination")
	check(weather.cafe_glass.size()>0 and weather.cafe_glass[0].emission_energy_multiplier>2.,"runtime window/lantern emission follows nighttime")
	check(weather.cafe_lights[0].light_energy>noon_cafe*2.,"existing cafe local lights brighten at night")
	weather.set_time(23.999);var c1: Color=weather.environment.ambient_light_color
	weather.set_time(.001)
	check(c1.is_equal_approx(weather.environment.ambient_light_color),"lighting wraps smoothly at midnight")
	var hour: float=weather.hours;weather._process(1.)
	check(weather.hours==hour,"pause holds time while wind remains active")
	weather.paused=false;weather._process(weather.day_seconds/24.)
	check(absf(weather.hours-hour-1.)<.01,"configurable duration advances one hour correctly")
	weather.set_weather("clear",true)
	var start: Vector4=weather.weather_value
	check(not weather.set_weather("invalid"),"unknown weather rejected")
	weather.set_weather("heavy_rain")
	weather.update_environment(.1)
	check(weather.weather_value.y>start.y and weather.weather_value.y<1.,"rain transitions gradually")
	weather.update_environment(60.)
	check(weather.wetness>.6 and weather.rain.emitting,"rain wets ground and starts CPU particles")
	check(weather.rain.mesh.material.get_shader_parameter("rain_strength")>.9,"heavy rain shader receives intensity")
	weather.set_weather("clear",true);weather.wetness=.8;weather.update_environment(1.)
	check(weather.wetness>0. and weather.wetness<.8,"ground dries gradually after rain")
	check(weather.rain_audio.stream.loop_mode!=AudioStreamWAV.LOOP_DISABLED,"rain ambience loops")
	var canopy_count:=0
	for mat in weather.animated_materials:
		if mat.shader.resource_path.ends_with("canopy_wind.gdshader"): canopy_count+=1
	check(canopy_count>0,"shared wind reaches actual tree/bush foliage")
	check(weather.wet_materials.size()>0,"ground/grass materials receive wetness")
	var meadow=hub.get_node("CuratedGroundCover/DenseMeadow")
	for layer in range(3):
		check(meadow.meshes["%d:0:1"%layer].get_faces().size()<meadow.meshes["%d:0:0"%layer].get_faces().size(),"LOD simplifies layer "+str(layer))
	print("WEATHER COMPLETE; failures=",failures)
	hub.queue_free();await process_frame;await process_frame
	quit(1 if failures else 0)
