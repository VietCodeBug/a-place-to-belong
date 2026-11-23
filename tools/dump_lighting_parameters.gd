extends SceneTree
const RIG=preload("res://scripts/lighting/lighting_rig.gd")
func _initialize() -> void: call_deferred("run")
func run() -> void:
	var hub:=Node3D.new()
	root.add_child(hub)
	var output:={}
	for name in ["pr09_baseline","golden_hour","blue_hour"]:
		var preset: ForestLightingPreset=load("res://assets/lighting/"+name+".tres")
		var record:={}
		for property in preset.get_property_list():
			if property.usage & PROPERTY_USAGE_SCRIPT_VARIABLE:
				var value: Variant=preset.get(property.name)
				if value is Color: value="#"+value.to_html(false)
				elif value is Vector3: value=[value.x,value.y,value.z]
				record[property.name]=value
		RIG.apply(hub,preset)
		record["effective_sky_curve"]=hub.get_node("WorldEnvironment").environment.sky.sky_material.sky_curve
		record["effective_sun_glow_angle"]=hub.get_node("WorldEnvironment").environment.sky.sky_material.sun_angle_max
		record["exposure"]=hub.get_node("WorldEnvironment").environment.tonemap_exposure
		record["tonemap_mode"]=hub.get_node("WorldEnvironment").environment.tonemap_mode
		record["directional_shadow_mode"]=hub.get_node("Sun").directional_shadow_mode
		record["sky_light_mode"]=hub.get_node("Sun").sky_mode
		output[name]=record
	var file:=FileAccess.open("/tmp/lighting-parameters.json",FileAccess.WRITE)
	file.store_string(JSON.stringify(output,"\t"))
	print(JSON.stringify(output))
	quit()
