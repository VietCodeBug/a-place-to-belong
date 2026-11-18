extends SceneTree
var failures:=0
func _initialize():call_deferred("run")
func check(value: bool,text: String):
	print("PASS: " if value else "FAIL: ",text)
	if not value:failures+=1
func run():
	var hub=load("res://scenes/world/forest_hub.tscn").instantiate();root.add_child(hub)
	for i in range(4):await process_frame
	var weather=hub.get_node("ForestWeather");weather.paused=true
	check(hub.ui.pause_time_slider is DaylightDial,"interactive illustrated daylight dial installed")
	weather.set_time(12.);weather.set_weather("clear",true);var energy: float=weather.sun.light_energy
	weather.set_weather("heavy_rain",true)
	check(weather.sun.light_energy<energy*.2 and not weather.sun.shadow_enabled,"downpour suppresses sun and hard shadows")
	var habitat=hub.get_node("ForestLife/AuthoredHabitats")
	weather.set_weather("clear",true);weather.set_time(10.);habitat._process(0.)
	check(habitat.rabbits.size()==3 and habitat.rabbits[0].visible,"bounded rabbit habitat appears in daytime")
	weather.set_time(22.);habitat._process(0.)
	check(not habitat.rabbits[0].visible and habitat.insects[0].visible,"night habitat replaces rabbits with moths")
	weather.set_weather("heavy_rain",true);habitat._process(0.)
	check(not habitat.insects[0].visible,"insects shelter in heavy rain")
	print("V11 COMPLETE; failures=",failures);hub.queue_free();await process_frame;quit(1 if failures else 0)
