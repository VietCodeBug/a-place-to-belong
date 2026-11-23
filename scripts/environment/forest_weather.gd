extends Node
## Real-time Compatibility atmosphere, time-of-day, stylized sky, rain/puddles, lantern sync, and forest ambience.
const WEATHER := {
	"clear": Vector4(.12, 0.0, .055, 0.0),
	"partly_cloudy": Vector4(.43, 0.0, .08, .08),
	"overcast": Vector4(.86, 0.0, .12, .42),
	"light_rain": Vector4(.90, .32, .15, .52),
	"heavy_rain": Vector4(.98, 1.0, .24, .68),
}
var hours := 16.5
var day_seconds := 1200.0
var paused := false
var static_lighting := false
var weather_name := "partly_cloudy"
var weather_value := Vector4(.43, 0, .08, .08)
var target_weather := weather_value
var transition_seconds := 12.0
var wetness := 0.0
var clock := 0.0
var wind_direction := Vector2(.85, .52).normalized()
var wind_multiplier := 1.0
var hub: Node3D
var sun: DirectionalLight3D
var moon: DirectionalLight3D
var environment: Environment
var sky_material: ShaderMaterial
var bright_a1_sky := false
var animated_materials: Array[ShaderMaterial] = []
var canopy_materials: Array[ShaderMaterial] = []
var wet_materials: Array[ShaderMaterial] = []
var path_materials: Array[ShaderMaterial] = []
var cafe_lights: Array[OmniLight3D] = []
var cafe_energy: Array[float] = []
var cafe_ranges: Array[float] = []
var outdoor_lanterns: Array[OmniLight3D] = []
var outdoor_energies: Array[float] = []
var outdoor_glass: Array[StandardMaterial3D] = []
var cafe_glass: Array[StandardMaterial3D] = []
var glass_cache: Dictionary = {}
var rain: CPUParticles3D
var rain_splashes: CPUParticles3D
var rain_audio: AudioStreamPlayer
var ambience: ForestAmbience
var backdrop: Node
var life: Node
var ready_to_update := false

func _ready() -> void:
	hub = get_parent()
	static_lighting = hub.has_meta("lighting_preset")
	for arg in OS.get_cmdline_user_args():
		if arg.begins_with("--lighting="): static_lighting = true
		elif arg.begins_with("--time="): hours = fposmod(float(arg.trim_prefix("--time=")), 24.)
		elif arg.begins_with("--day-seconds="): day_seconds = maxf(10., float(arg.trim_prefix("--day-seconds=")))
		elif arg == "--pause-time": paused = true
		elif arg.begins_with("--weather="): set_weather(arg.trim_prefix("--weather="), true)
		elif arg.begins_with("--wind="): wind_multiplier = clampf(float(arg.trim_prefix("--wind=")), 0., 3.)
	call_deferred("setup")

func setup() -> void:
	sun = hub.get_node("Sun")
	environment = hub.get_node("WorldEnvironment").environment
	backdrop = hub.get_node_or_null("ForestBackdrop")
	life = hub.get_node_or_null("ForestLife")
	if not static_lighting:
		sky_material = ShaderMaterial.new()
		sky_material.shader = preload("res://shaders/forest_sky.gdshader")
		bright_a1_sky = hub.superworld!=null
		sky_material.set_shader_parameter("a1_sky",bright_a1_sky)
		var sky := Sky.new()
		sky.sky_material = sky_material
		sky.radiance_size = Sky.RADIANCE_SIZE_32
		sky.process_mode = Sky.PROCESS_MODE_INCREMENTAL
		environment.sky = sky
		sun.sky_mode = DirectionalLight3D.SKY_MODE_LIGHT_ONLY
		moon = DirectionalLight3D.new()
		moon.name = "Moon"
		moon.light_color = Color("9EC0EA")
		moon.light_energy = .24
		moon.shadow_enabled = false
		moon.sky_mode = DirectionalLight3D.SKY_MODE_LIGHT_ONLY
		hub.add_child(moon)
	collect(hub)
	make_rain()
	ambience = preload("res://scripts/environment/forest_ambience.gd").new()
	ambience.name = "ForestAmbience"
	add_child(ambience)
	ready_to_update = true
	update_environment(0.)

func collect(node: Node) -> void:
	var cafe_root := hub.get_node_or_null("Cafe")
	if node is OmniLight3D:
		if cafe_root != null and cafe_root.is_ancestor_of(node):
			cafe_lights.append(node)
			cafe_energy.append(node.light_energy)
			cafe_ranges.append(node.omni_range)
		elif node.get_meta("story_lantern", false):
			outdoor_lanterns.append(node)
			outdoor_energies.append(node.light_energy)
	if node is MeshInstance3D and not static_lighting:
		if cafe_root != null and cafe_root.is_ancestor_of(node):
			for surface in range(node.mesh.get_surface_count()):
				var original: Material = node.get_active_material(surface)
				if original is StandardMaterial3D and original.resource_name in ["WarmWindowGlass", "LanternGlass"]:
					var key: int = original.get_instance_id()
					if not glass_cache.has(key):
						var glass: StandardMaterial3D = original.duplicate()
						glass_cache[key] = glass
						cafe_glass.append(glass)
					node.set_surface_override_material(surface, glass_cache[key])
		elif node.get_meta("lantern_bulb", false):
			var bulb_mat := node.material_override as StandardMaterial3D
			if bulb_mat != null and not outdoor_glass.has(bulb_mat):
				outdoor_glass.append(bulb_mat)
	if node is GeometryInstance3D:
		var mat: Material = node.material_override
		if mat is ShaderMaterial:
			var path: String = mat.shader.resource_path
			if path.ends_with("meadow_wind.gdshader") or path.ends_with("dense_meadow.gdshader"):
				if not animated_materials.has(mat):
					mat.set_meta("external_wind", true)
					mat.set_meta("wind_scale", float(mat.get_shader_parameter("wind_strength")) / .08)
					animated_materials.append(mat)
					if path.ends_with("dense_meadow.gdshader"):
						wind_direction = mat.get_shader_parameter("wind_direction")
				if not wet_materials.has(mat):
					wet_materials.append(mat)
			elif path.ends_with("forest_floor.gdshader") or path.ends_with("forest_path.gdshader"):
				if not wet_materials.has(mat):
					wet_materials.append(mat)
				if path.ends_with("forest_path.gdshader") and not path_materials.has(mat):
					path_materials.append(mat)
		elif node is MultiMeshInstance3D and mat is StandardMaterial3D:
			var woodland := hub.get_node_or_null("LicensedWoodland")
			var source_name: String = mat.resource_name.to_lower()
			if woodland != null and woodland.is_ancestor_of(node) and (source_name.contains("leaf") or source_name.contains("leaves") or source_name in ["green", "orange", "lightorange"]):
				var canopy := ShaderMaterial.new()
				canopy.shader = preload("res://shaders/canopy_wind.gdshader")
				canopy.set_shader_parameter("leaf_color", mat.albedo_color)
				var box: AABB = node.multimesh.mesh.get_aabb()
				canopy.set_shader_parameter("base_height", box.position.y + box.size.y * .14)
				canopy.set_shader_parameter("crown_top", box.position.y + box.size.y * .96)
				node.material_override = canopy
				node.extra_cull_margin = maxf(node.extra_cull_margin, .6)
				animated_materials.append(canopy)
				canopy_materials.append(canopy)
				wet_materials.append(canopy)
	for child in node.get_children():
		collect(child)

func set_time(value: float) -> void:
	hours = fposmod(value, 24.)
	if ready_to_update:
		update_environment(0.)

func set_weather(value: String, instant := false) -> bool:
	if not WEATHER.has(value):
		return false
	weather_name = value
	target_weather = WEATHER[value]
	if instant:
		weather_value = target_weather
		wetness = target_weather.y * .85
		if ready_to_update:
			update_environment(0.)
	return true

func time_period_label() -> String:
	var rainy := weather_name in ["light_rain", "heavy_rain"]
	var cloudy := weather_name == "overcast"
	if hours < 5.2 or hours >= 19.8:
		return "Rainy Night" if rainy else ("Cloudy Night" if cloudy else "Starlit Night")
	elif hours < 7.2:
		return "Misty Dawn"
	elif hours < 11.2:
		return "Rainy Morning" if rainy else ("Misty Morning" if cloudy else "Crisp Morning")
	elif hours < 15.3:
		return "Rainy Afternoon" if rainy else ("Cloudy Midday" if cloudy else "Sunlit Midday")
	elif hours < 18.0:
		return "Rainy Dusk" if rainy else ("Soft Afternoon" if cloudy else "Golden Hour")
	return "Amber Dusk"

func weather_display_label() -> String:
	match weather_name:
		"clear": return "Clear Sky"
		"partly_cloudy": return "Drifting Clouds"
		"overcast": return "Soft Overcast"
		"light_rain": return "Gentle Rain"
		"heavy_rain": return "Forest Downpour"
	return "Calm Air"

func _process(delta: float) -> void:
	if not ready_to_update:
		return
	clock += delta
	if not paused and not static_lighting:
		hours = fposmod(hours + delta * 24. / day_seconds, 24.)
	update_environment(delta)

func update_environment(delta: float) -> void:
	weather_value = weather_value.lerp(target_weather, 1. - exp(-delta / maxf(transition_seconds / 3., .01)))
	wetness = move_toward(wetness, weather_value.y * .85, delta / (18. if weather_value.y > wetness else 55.))
	var strength: float = weather_value.z * wind_multiplier
	for mat in animated_materials:
		mat.set_shader_parameter("wind_clock", clock)
		mat.set_shader_parameter("wind_direction", wind_direction)
		mat.set_shader_parameter("wind_strength", strength * float(mat.get_meta("wind_scale", 1.)))
	for mat in wet_materials:
		mat.set_shader_parameter("wetness", wetness)

	var phase: float = (hours - 6.) / 24. * TAU
	var altitude := sin(phase)
	var daylight := smoothstep(-.14, .20, altitude)
	if not static_lighting:
		update_light(altitude, daylight)
	if life != null and life.has_method("sync_state"):
		life.sync_state(clock, 1.0 if static_lighting else daylight, weather_value.y, wind_direction, strength)
	if ambience != null:
		ambience.update_mix(1.0 if static_lighting else daylight, weather_value.y, strength)

	if rain != null:
		var camera := get_viewport().get_camera_3d()
		if camera != null:
			var focus: Vector3 = camera.global_position - camera.global_basis.z * 11.5
			var lateral_limit := 22.0 if focus.z < 24.0 else ForestLandscape.VALLEY_HALF_WIDTH - 2.0
			var x := clampf(focus.x,-lateral_limit,lateral_limit)
			var z := focus.z if get_parent().superworld != null else clampf(focus.z,ForestLandscape.WOODLAND_START+2.0,ForestLandscape.VALLEY_END-2.0)
			var floor_y := ForestLandscape.height_at(x,z)
			var clamped := Vector3(x,floor_y+9.2,z)
			rain.global_position = clamped
			if rain_splashes != null:
				rain_splashes.global_position = Vector3(clamped.x, floor_y + 0.14, clamped.z)
		rain.emitting = weather_value.y > .025
		rain.mesh.material.set_shader_parameter("rain_strength", weather_value.y)
		rain.direction = Vector3(wind_direction.x * .20, -1., wind_direction.y * .20).normalized()
		if rain_splashes != null:
			rain_splashes.emitting = weather_value.y > .08
		var vol_scale := ambience.master_volume if (ambience != null and not ambience.muted) else 0.0
		rain_audio.volume_db = -72.0 if vol_scale <= 0.01 else lerpf(-62., -15., sqrt(weather_value.y) * vol_scale)
		if DisplayServer.get_name() != "headless" and not OS.get_cmdline_args().has("Dummy"):
			if weather_value.y > .025 and vol_scale > 0.01 and not rain_audio.playing:
				rain_audio.play()
			elif (weather_value.y < .005 or vol_scale <= 0.01) and rain_audio.playing:
				rain_audio.stop()

func colors_at(time: float) -> Array:
	# Cyclic authored keyframes:
	# [hour, sky_top, sky_horizon, ambient_color, cloud_body, cloud_shadow, ambient_energy]
	var keys := [
		[0.0,  "162A48", "334C6B", "7E9DC4", "556A88", "324663", 0.48],
		[5.0,  "2D4468", "C08E92", "9AB0CA", "C8B3B6", "6B6E8C", 0.50],
		[6.8,  "5F93C2", "F2C7A2", "BFD0DF", "F9DEC8", "96A4BE", 0.60],
		[10.0, "4E8EC6", "AAC2CC", "C2D4E4", "FCF9F0", "98B0C6", 0.64],
		[14.0, "4B89C0", "A9BBC6", "BDD0E2", "FAF4E6", "97ADC2", 0.64],
		[16.8, "5688B8", "CCBAA4", "BBC5DA", "FAD0AD", "8E9AB6", 0.58],
		[18.3, "455C8C", "E0968F", "A4B7D6", "CFA0A6", "5E6A8E", 0.52],
		[20.0, "203963", "597396", "8DA8CE", "6E84A4", "3E5272", 0.49],
		[24.0, "162A48", "334C6B", "7E9DC4", "556A88", "324663", 0.48],
	]
	for i in range(keys.size() - 1):
		if time <= keys[i + 1][0]:
			var a: Array = keys[i]
			var b: Array = keys[i + 1]
			var t := smoothstep(float(a[0]), float(b[0]), time)
			return [
				Color(a[1]).lerp(Color(b[1]), t),
				Color(a[2]).lerp(Color(b[2]), t),
				Color(a[3]).lerp(Color(b[3]), t),
				Color(a[4]).lerp(Color(b[4]), t),
				Color(a[5]).lerp(Color(b[5]), t),
				lerpf(float(a[6]), float(b[6]), t),
			]
	return []

func update_light(altitude: float, daylight: float) -> void:
	var occlusion: float = weather_value.w
	var colors := colors_at(hours)
	sun.rotation_degrees = Vector3(-altitude * 60., -52. + (hours - 16.5) * 15., 0)
	sun.light_energy = pow(maxf(altitude, 0.), .34) * 1.15 * (1. - smoothstep(.10,.48,occlusion) * .94)
	var sun_col := Color("FFC987").lerp(Color("FFF2DC"), smoothstep(.16, .78, altitude))
	sun.light_color = sun_col
	sun.shadow_opacity=.73*(1.0-smoothstep(.12,.55,occlusion))
	sun.shadow_enabled = altitude > .025 and occlusion<.58

	moon.rotation_degrees = Vector3(maxf(0.32, -altitude * 0.65) * -46., 128. + (hours - 16.5) * 15., 0)
	moon.light_energy = (1. - daylight) * .25 * (1. - occlusion * .42)

	var sky_top: Color = colors[0].lerp(Color("5D707B"), occlusion * .56 * daylight)
	var sky_hor: Color = colors[1].lerp(Color("94A4A8"), occlusion * .68 * daylight)
	var cloud_body: Color = colors[3]
	var cloud_shade: Color = colors[4]
	if bright_a1_sky:
		var blue_hour := smoothstep(7.2,10.1,hours)*(1.0-smoothstep(16.1,18.3,hours))
		var clearing := blue_hour*(1.0-smoothstep(.13,.52,occlusion))
		sky_top = sky_top.lerp(Color("247DCA"),clearing*.97)
		sky_hor = sky_hor.lerp(Color("9FC6EE"),clearing*.87)
		cloud_body = cloud_body.lerp(Color("FFFAF2"),clearing)
		cloud_shade = cloud_shade.lerp(Color("BCC1E5"),clearing*.86)
	var amb_col: Color = colors[2].lerp(Color("8FA1AA"), occlusion * .38 * daylight)
	environment.ambient_light_color = amb_col.lerp(Color("A4B7C3"), daylight * .32)
	environment.ambient_light_energy = (float(colors[5]) + daylight * .20) * (1. - occlusion * .16)
	environment.fog_light_color = sky_hor.lerp(Color("718B99"), .58)
	environment.fog_light_energy = lerpf(0.75, 0.84, daylight)
	environment.fog_depth_begin = lerpf(58., 36., occlusion)
	environment.fog_depth_end = lerpf(228., 140., occlusion)

	sky_material.set_shader_parameter("top_color", sky_top)
	sky_material.set_shader_parameter("horizon_color", sky_hor)
	sky_material.set_shader_parameter("cloud_color", cloud_body.darkened(occlusion * .24))
	sky_material.set_shader_parameter("cloud_shadow_color", cloud_shade.darkened(occlusion * .20))
	sky_material.set_shader_parameter("sun_direction", sun.global_basis.z)
	sky_material.set_shader_parameter("moon_direction", moon.global_basis.z)
	sky_material.set_shader_parameter("daylight", daylight)
	sky_material.set_shader_parameter("cloud_cover", weather_value.x)
	sky_material.set_shader_parameter("cloud_clock", clock)
	sky_material.set_shader_parameter("wind_direction", wind_direction)

	var haze_col := sky_hor.lerp(sky_top, 0.35)
	for cmat in canopy_materials:
		cmat.set_shader_parameter("daylight", daylight * (1.0 - occlusion * 0.55))
		cmat.set_shader_parameter("sun_direction", sun.global_basis.z)
		cmat.set_shader_parameter("sun_tint", sun_col)
		cmat.set_shader_parameter("distance_haze", haze_col)
	for pmat in path_materials:
		pmat.set_shader_parameter("puddle_tint", sky_hor.lerp(sky_top, 0.5).darkened(0.18))
	if backdrop != null and backdrop.has_method("apply_atmosphere"):
		backdrop.apply_atmosphere(sky_top, sky_hor, amb_col, daylight, occlusion, sun.global_basis.z)

	# Warm cozy cafe & lantern glow wakes up at dusk/night and gently during heavy rain
	var rain_cozy := weather_value.y * 0.38
	var warm_factor := clampf(1.0 - daylight + rain_cozy * daylight, 0.0, 1.0)
	for glass in cafe_glass:
		glass.emission_energy_multiplier = lerpf(0.62, 3.15, warm_factor)
	for i in range(cafe_lights.size()):
		cafe_lights[i].light_energy = cafe_energy[i] * lerpf(0.55, 2.25, warm_factor)
		cafe_lights[i].omni_range = cafe_ranges[i] * lerpf(1.0, 1.72, warm_factor)
	var lantern_factor := smoothstep(0.12, 0.72, warm_factor)
	for i in range(outdoor_lanterns.size()):
		outdoor_lanterns[i].light_energy = outdoor_energies[i] * lantern_factor
		outdoor_lanterns[i].visible = lantern_factor > 0.02
	for bulb in outdoor_glass:
		bulb.emission_energy_multiplier = lerpf(0.25, 2.6, lantern_factor)

func make_rain() -> void:
	rain = CPUParticles3D.new()
	rain.name = "Rain"
	rain.amount = 1100
	rain.lifetime = 1.08
	rain.preprocess = .5
	rain.emission_shape = CPUParticles3D.EMISSION_SHAPE_BOX
	rain.emission_box_extents = Vector3(14., 2.2, 14.)
	rain.initial_velocity_min = 11.5
	rain.initial_velocity_max = 15.5
	rain.gravity = Vector3(0, -4.5, 0)
	rain.spread = 2.8
	rain.local_coords = false
	var mesh := QuadMesh.new()
	mesh.size = Vector2(.016, .30)
	var mat := ShaderMaterial.new()
	mat.shader = preload("res://shaders/rain.gdshader")
	mesh.material = mat
	rain.mesh = mesh
	add_child(rain)

	# Subtle ground raindrop splash flecks across the clearing & path
	rain_splashes = CPUParticles3D.new()
	rain_splashes.name = "RainSplashes"
	rain_splashes.amount = 160
	rain_splashes.lifetime = 0.28
	rain_splashes.emission_shape = CPUParticles3D.EMISSION_SHAPE_BOX
	rain_splashes.emission_box_extents = Vector3(11.0, 0.08, 11.0)
	rain_splashes.direction = Vector3.UP
	rain_splashes.spread = 32.0
	rain_splashes.initial_velocity_min = 0.65
	rain_splashes.initial_velocity_max = 1.25
	rain_splashes.gravity = Vector3(0, -5.5, 0)
	rain_splashes.local_coords = false
	var drop_mesh := QuadMesh.new()
	drop_mesh.size = Vector2(0.045, 0.045)
	var drop_mat := StandardMaterial3D.new()
	drop_mat.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	drop_mat.billboard_mode = BaseMaterial3D.BILLBOARD_ENABLED
	drop_mat.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	drop_mat.albedo_color = Color(0.80, 0.88, 0.94, 0.36)
	drop_mesh.material = drop_mat
	rain_splashes.mesh = drop_mesh
	rain_splashes.emitting = false
	add_child(rain_splashes)

	rain_audio = AudioStreamPlayer.new()
	rain_audio.name = "RainAmbience"
	rain_audio.stream = load("res://assets/audio/rain_loop.wav")
	rain_audio.volume_db = -65.
	add_child(rain_audio)

func _exit_tree() -> void:
	if environment != null and not static_lighting:
		environment.background_mode = Environment.BG_COLOR
		environment.sky = null
	sky_material = null
	if is_instance_valid(rain):
		rain.emitting = false
	if is_instance_valid(rain_splashes):
		rain_splashes.emitting = false
	if is_instance_valid(rain_audio):
		rain_audio.stop()
		rain_audio.stream = null
	animated_materials.clear()
	canopy_materials.clear()
	wet_materials.clear()
	path_materials.clear()
