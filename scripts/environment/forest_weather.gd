extends Node
## Real-time Compatibility environment. Controls are developer CLI/API, not gameplay UI.
const WEATHER := {"clear":Vector4(.12,0.0,.055,0.0),"partly_cloudy":Vector4(.43,0.0,.08,.08),"overcast":Vector4(.86,0.0,.12,.42),"light_rain":Vector4(.90,.32,.15,.52),"heavy_rain":Vector4(.98,1.0,.24,.68)}
var hours:=16.5
var day_seconds:=1200.0
var paused:=false
var static_lighting:=false
var weather_name:="partly_cloudy"
var weather_value:=Vector4(.43,0,.08,.08)
var target_weather:=weather_value
var transition_seconds:=12.0
var wetness:=0.0
var clock:=0.0
var wind_direction:=Vector2(.85,.52).normalized()
var wind_multiplier:=1.0
var hub: Node3D
var sun: DirectionalLight3D
var moon: DirectionalLight3D
var environment: Environment
var sky_material: ShaderMaterial
var animated_materials: Array[ShaderMaterial]=[]
var wet_materials: Array[ShaderMaterial]=[]
var cafe_lights: Array[OmniLight3D]=[]
var cafe_energy: Array[float]=[]
var cafe_glass: Array[StandardMaterial3D]=[]
var glass_cache: Dictionary={}
var rain: CPUParticles3D
var rain_audio: AudioStreamPlayer
var ready_to_update:=false

func _ready() -> void:
	hub=get_parent()
	static_lighting=hub.has_meta("lighting_preset")
	for arg in OS.get_cmdline_user_args():
		if arg.begins_with("--lighting="): static_lighting=true
		elif arg.begins_with("--time="): hours=fposmod(float(arg.trim_prefix("--time=")),24.)
		elif arg.begins_with("--day-seconds="): day_seconds=maxf(10.,float(arg.trim_prefix("--day-seconds=")))
		elif arg=="--pause-time": paused=true
		elif arg.begins_with("--weather="): set_weather(arg.trim_prefix("--weather="),true)
		elif arg.begins_with("--wind="): wind_multiplier=clampf(float(arg.trim_prefix("--wind=")),0.,3.)
	call_deferred("setup")

func setup() -> void:
	sun=hub.get_node("Sun")
	environment=hub.get_node("WorldEnvironment").environment
	if not static_lighting:
		sky_material=ShaderMaterial.new()
		sky_material.shader=preload("res://shaders/forest_sky.gdshader")
		var sky:=Sky.new();sky.sky_material=sky_material
		sky.radiance_size=Sky.RADIANCE_SIZE_32
		sky.process_mode=Sky.PROCESS_MODE_INCREMENTAL
		environment.sky=sky
		sun.sky_mode=DirectionalLight3D.SKY_MODE_LIGHT_ONLY
		moon=DirectionalLight3D.new();moon.name="Moon"
		moon.light_color=Color("98B6DE");moon.light_energy=.10
		moon.shadow_enabled=false;moon.sky_mode=DirectionalLight3D.SKY_MODE_LIGHT_ONLY
		hub.add_child(moon)
	collect(hub)
	make_rain()
	ready_to_update=true
	update_environment(0.)

func collect(node: Node) -> void:
	if node is OmniLight3D and hub.get_node("Cafe").is_ancestor_of(node):
		cafe_lights.append(node);cafe_energy.append(node.light_energy)
	if node is MeshInstance3D and hub.get_node("Cafe").is_ancestor_of(node) and not static_lighting:
		for surface in range(node.mesh.get_surface_count()):
			var original: Material=node.get_active_material(surface)
			if original is StandardMaterial3D and original.resource_name in ["WarmWindowGlass","LanternGlass"]:
				var key: int=original.get_instance_id()
				if not glass_cache.has(key):
					var glass: StandardMaterial3D=original.duplicate()
					glass_cache[key]=glass
					cafe_glass.append(glass)
				node.set_surface_override_material(surface,glass_cache[key])
	if node is GeometryInstance3D:
		var mat: Material=node.material_override
		if mat is ShaderMaterial:
			var path: String=mat.shader.resource_path
			if path.ends_with("meadow_wind.gdshader") or path.ends_with("dense_meadow.gdshader"):
				if not animated_materials.has(mat):
					mat.set_meta("external_wind",true)
					mat.set_meta("wind_scale",float(mat.get_shader_parameter("wind_strength"))/.08)
					animated_materials.append(mat)
					if path.ends_with("dense_meadow.gdshader"): wind_direction=mat.get_shader_parameter("wind_direction")
				if not wet_materials.has(mat): wet_materials.append(mat)
			elif path.ends_with("forest_floor.gdshader") or path.ends_with("forest_path.gdshader"):
				if not wet_materials.has(mat): wet_materials.append(mat)
		elif node is MultiMeshInstance3D and mat is StandardMaterial3D:
			var source_name: String=mat.resource_name.to_lower()
			if hub.get_node("LicensedWoodland").is_ancestor_of(node) and (source_name.contains("leaf") or source_name.contains("leaves") or source_name in ["green","orange","lightorange"]):
				var canopy:=ShaderMaterial.new();canopy.shader=preload("res://shaders/canopy_wind.gdshader")
				canopy.set_shader_parameter("leaf_color",mat.albedo_color)
				var box: AABB=node.multimesh.mesh.get_aabb()
				canopy.set_shader_parameter("base_height",box.position.y+box.size.y*.15)
				node.material_override=canopy
				node.extra_cull_margin=maxf(node.extra_cull_margin,.5)
				animated_materials.append(canopy)
	for child in node.get_children(): collect(child)

func set_time(value: float) -> void:
	hours=fposmod(value,24.)
	if ready_to_update: update_environment(0.)

func set_weather(value: String, instant:=false) -> bool:
	if not WEATHER.has(value): return false
	weather_name=value;target_weather=WEATHER[value]
	if instant:
		weather_value=target_weather
		wetness=target_weather.y*.8
	return true

func _process(delta: float) -> void:
	if not ready_to_update: return
	clock+=delta
	if not paused and not static_lighting: hours=fposmod(hours+delta*24./day_seconds,24.)
	update_environment(delta)

func update_environment(delta: float) -> void:
	weather_value=weather_value.lerp(target_weather,1.-exp(-delta/maxf(transition_seconds/3.,.01)))
	wetness=move_toward(wetness,weather_value.y*.8,delta/(20. if weather_value.y>wetness else 55.))
	var strength: float=weather_value.z*wind_multiplier
	for mat in animated_materials:
		mat.set_shader_parameter("wind_clock",clock)
		mat.set_shader_parameter("wind_direction",wind_direction)
		mat.set_shader_parameter("wind_strength",strength*float(mat.get_meta("wind_scale",1.)))
	for mat in wet_materials: mat.set_shader_parameter("wetness",wetness)
	if not static_lighting: update_light()
	if rain!=null:
		var camera:=get_viewport().get_camera_3d()
		if camera!=null:
			# Follow the viewed clearing, rather than spawn a world-sized particle storm.
			var focus: Vector3=camera.global_position-camera.global_basis.z*12.
			rain.global_position=Vector3(clampf(focus.x,-22.,22.),9.,clampf(focus.z,-22.,22.))
		rain.emitting=weather_value.y>.025
		rain.mesh.material.set_shader_parameter("rain_strength",weather_value.y)
		rain.direction=Vector3(wind_direction.x*.18,-1.,wind_direction.y*.18).normalized()
		rain_audio.volume_db=lerpf(-65.,-16.,sqrt(weather_value.y))
		# Headless/Dummy has no audible output; avoid starting undrained audio playbacks in tests.
		if DisplayServer.get_name()!="headless" and not OS.get_cmdline_args().has("Dummy"):
			if weather_value.y>.025 and not rain_audio.playing: rain_audio.play()
			elif weather_value.y<.005 and rain_audio.playing: rain_audio.stop()

func colors_at(time: float) -> Array:
	# Cyclic authored keyframes: hour, sky top, horizon, ambient, cloud tint, ambient energy.
	var keys=[
		[0.,"142640","34485F","8BA7C8","52647F",.34],
		[5.,"304566","B88D93","9AADC5","BCACB0",.40],
		[6.5,"749DC5","EBC6AA","B6C5D6","F1CFC0",.56],
		[10.,"659DCC","D7DEDA","BCCDE0","F0F3EB",.62],
		[14.,"6097C4","DFDBCA","B7C8DF","F2EDE0",.62],
		[17.,"6496BF","F3C79C","B3BED5","F0C4A5",.56],
		[18.5,"4E638F","D99D9C","A6B7D3","BF9AA4",.48],
		[20.,"243D67","8FA2C1","9BAED1","7186A4",.40],
		[24.,"142640","34485F","8BA7C8","52647F",.34]]
	for i in range(keys.size()-1):
		if time<=keys[i+1][0]:
			var a: Array=keys[i];var b: Array=keys[i+1]
			var t:=smoothstep(float(a[0]),float(b[0]),time)
			return [Color(a[1]).lerp(Color(b[1]),t),Color(a[2]).lerp(Color(b[2]),t),Color(a[3]).lerp(Color(b[3]),t),Color(a[4]).lerp(Color(b[4]),t),lerpf(float(a[5]),float(b[5]),t)]
	return []

func update_light() -> void:
	var phase: float=(hours-6.)/24.*TAU
	var altitude:=sin(phase)
	var daylight:=smoothstep(-.13,.18,altitude)
	var occlusion: float=weather_value.w
	var colors:=colors_at(hours)
	sun.rotation_degrees=Vector3(-altitude*60.,-52.+(hours-16.5)*15.,0)
	sun.light_energy=pow(maxf(altitude,0.),.35)*1.3*(1.-occlusion*.78)
	sun.light_color=Color("FFDAA2").lerp(Color("FFF1D8"),smoothstep(.2,.8,altitude))
	sun.shadow_enabled=altitude>.025
	moon.rotation_degrees=Vector3(altitude*48.,128.+(hours-16.5)*15.,0)
	moon.light_energy=(1.-daylight)*.10*(1.-occlusion*.5)
	environment.ambient_light_color=colors[2]
	environment.ambient_light_energy=colors[4]*(1.-occlusion*.22)
	environment.fog_light_color=colors[1].lerp(colors[0],.55)
	environment.fog_depth_begin=lerpf(55.,32.,occlusion)
	environment.fog_depth_end=lerpf(180.,125.,occlusion)
	sky_material.set_shader_parameter("top_color",colors[0].lerp(Color("657783"),occlusion*.5*daylight))
	sky_material.set_shader_parameter("horizon_color",colors[1].lerp(Color("9AA8AC"),occlusion*.65*daylight))
	sky_material.set_shader_parameter("cloud_color",colors[3].darkened(occlusion*.28))
	sky_material.set_shader_parameter("sun_direction",sun.global_basis.z)
	sky_material.set_shader_parameter("moon_direction",moon.global_basis.z)
	sky_material.set_shader_parameter("daylight",daylight)
	sky_material.set_shader_parameter("cloud_cover",weather_value.x)
	sky_material.set_shader_parameter("cloud_clock",clock)
	sky_material.set_shader_parameter("wind_direction",wind_direction)
	for glass in cafe_glass:
		glass.emission_energy_multiplier=lerpf(3.0,.65,daylight)
	for i in range(cafe_lights.size()):
		cafe_lights[i].light_energy=cafe_energy[i]*lerpf(1.65,.60,daylight)

func make_rain() -> void:
	rain=CPUParticles3D.new();rain.name="Rain"
	rain.amount=1000;rain.lifetime=1.15;rain.preprocess=.5
	rain.emission_shape=CPUParticles3D.EMISSION_SHAPE_BOX
	rain.emission_box_extents=Vector3(13.,2.,13.)
	rain.initial_velocity_min=10.;rain.initial_velocity_max=14.
	rain.gravity=Vector3(0,-4.,0);rain.spread=3.
	rain.local_coords=false
	var mesh:=QuadMesh.new();mesh.size=Vector2(.014,.24)
	var mat:=ShaderMaterial.new();mat.shader=preload("res://shaders/rain.gdshader")
	mesh.material=mat;rain.mesh=mesh
	add_child(rain)
	rain_audio=AudioStreamPlayer.new();rain_audio.name="RainAmbience"
	rain_audio.stream=load("res://assets/audio/rain_loop.wav")
	rain_audio.volume_db=-65.;add_child(rain_audio)

func _exit_tree() -> void:
	if environment!=null and not static_lighting:environment.sky=null
	sky_material=null
	if is_instance_valid(rain):
		rain.emitting=false
	if is_instance_valid(rain_audio):
		rain_audio.stop()
		rain_audio.stream=null
	animated_materials.clear()
	wet_materials.clear()
