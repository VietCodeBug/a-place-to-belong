extends Node3D
## Rain fills the exterior volumes. Wet panes and lightning use the same office scene.
const RAIN = preload("res://scripts/story/office_rain.gdshader")
const GLASS = preload("res://scripts/story/office_wet_glass.gdshader")
const CLOUDS = preload("res://scripts/story/office_clouds.gdshader")
const BOLT = preload("res://scripts/story/office_lightning.gdshader")
const FIRST_STRIKE := 14.0
const FLASH_DURATION := 0.27
const DAYLIGHT := 0.068
const AMBIENT := 0.45

var atmosphere: Environment
var daylight: DirectionalLight3D
var cloud_material: ShaderMaterial
var bolt_mesh := ImmediateMesh.new()
var bolt: MeshInstance3D
var bolt_material: ShaderMaterial
var rain_audio: AudioStreamPlayer
var thunder: AudioStreamPlayer3D
var rng := RandomNumberGenerator.new()
var elapsed := 0.0
var next_strike := FIRST_STRIKE
var next_cloud_update := 0.0
var flash_at := -1.0
var thunder_at := -1.0
var west := true
var flash := 0.0
var reading_mail := false
var flashes_enabled := true

func configure(environment: Environment, light: DirectionalLight3D) -> void:
	atmosphere = environment
	daylight = light
	rng.seed = 22086
	cloud_material = ShaderMaterial.new()
	cloud_material.shader = CLOUDS
	var sky := Sky.new()
	sky.radiance_size = Sky.RADIANCE_SIZE_32
	sky.process_mode = Sky.PROCESS_MODE_INCREMENTAL
	sky.sky_material = cloud_material
	atmosphere.sky = sky
	atmosphere.background_mode = Environment.BG_SKY
	atmosphere.ambient_light_energy = AMBIENT
	atmosphere.ambient_light_color = Color("bacbdc")
	daylight.light_energy = DAYLIGHT
	daylight.light_color = Color("cfdef1")

	rain_sheet(Vector3(-36.0, -3.8, -18.0), Vector3(27.48, 15.5, 29.0), 2450)
	rain_sheet(Vector3(-8.48, -3.8, -34.0), Vector3(28.98, 15.5, 27.45), 2390)
	bolt_material = ShaderMaterial.new()
	bolt_material.shader = BOLT
	bolt = MeshInstance3D.new()
	bolt.name = "ExteriorLightning"
	bolt.mesh = bolt_mesh
	bolt.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	bolt.hide()
	add_child(bolt)

	rain_audio = AudioStreamPlayer.new()
	rain_audio.name = "RainThroughGlass"
	rain_audio.stream = preload("res://assets/audio/rain_loop.wav")
	rain_audio.volume_db = -20.5
	add_child(rain_audio)
	if DisplayServer.get_name() != "headless":
		rain_audio.play()
	thunder = AudioStreamPlayer3D.new()
	thunder.name = "DistantThunder"
	thunder.stream = preload("res://assets/story/office_thunder.wav")
	thunder.unit_size = 19.0
	thunder.volume_db = -11.0
	thunder.max_db = -9.0
	add_child(thunder)

func add_window_panes(wall: Node3D, width: float, bays: int) -> void:
	var pitch := width / bays
	for index in range(bays):
		var pane := MeshInstance3D.new()
		pane.name = "RainOnGlass"
		pane.position = Vector3(-0.5 * width + (index + 0.5) * pitch, 1.87, -0.048)
		pane.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
		var quad := QuadMesh.new()
		quad.size = Vector2(pitch - 0.035, 2.22)
		var wet := ShaderMaterial.new()
		wet.shader = GLASS
		wet.set_shader_parameter("pane_width", quad.size.x)
		wet.set_shader_parameter("pane_seed", float(index + bays * 17))
		pane.mesh = quad
		pane.material_override = wet
		wall.add_child(pane)

func rain_sheet(lower: Vector3, span: Vector3, count: int) -> void:
	var material := ShaderMaterial.new()
	material.shader = RAIN
	material.set_shader_parameter("lower", lower)
	material.set_shader_parameter("span", span)
	var drop := QuadMesh.new()
	drop.size = Vector2(0.029, 0.45)
	drop.material = material
	var batch := MultiMesh.new()
	batch.transform_format = MultiMesh.TRANSFORM_3D
	batch.use_custom_data = true
	batch.mesh = drop
	batch.instance_count = count
	batch.custom_aabb = AABB(lower, span).grow(0.5)
	for index in range(count):
		var point := lower + span * Vector3(rng.randf(), rng.randf(), rng.randf())
		batch.set_instance_transform(index, Transform3D(Basis.IDENTITY, point))
		batch.set_instance_custom_data(index, Color(rng.randf(), rng.randf(), rng.randf(), rng.randf()))
	var sheet := MultiMeshInstance3D.new()
	sheet.name = "ExteriorRain"
	sheet.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	sheet.multimesh = batch
	add_child(sheet)

func _process(delta: float) -> void:
	elapsed += delta
	if elapsed >= next_cloud_update:
		cloud_material.set_shader_parameter("drift", elapsed)
		next_cloud_update = elapsed + 0.50
	if elapsed >= next_strike:
		if reading_mail:
			next_strike = elapsed + 7.0
		else:
			strike()
			next_strike = elapsed + rng.randf_range(27.0, 46.0)
	if thunder_at >= 0.0 and elapsed >= thunder_at:
		thunder.play()
		thunder_at = -1.0
	var age := elapsed - flash_at
	var amount := (1.0 - smoothstep(0.035, FLASH_DURATION, age)) if flash_at >= 0.0 else 0.0
	if not flashes_enabled:
		amount = 0.0
	if not is_equal_approx(amount, flash):
		apply_flash(amount)

func strike() -> void:
	flash_at = elapsed
	thunder_at = elapsed + (0.94 if west else 1.22)
	var start := Vector3(-19.8, 10.8, -3.4) if west else Vector3(-4.2, 11.0, -20.8)
	var sweep := Vector3.BACK if west else Vector3.RIGHT
	thunder.position = start - Vector3(0.0, 6.5, 0.0)
	bolt_mesh.clear_surfaces()
	bolt_mesh.surface_begin(Mesh.PRIMITIVE_TRIANGLES, bolt_material)
	var trunk: Array[Vector3] = [start]
	for step in range(1, 13):
		var jitter := sweep * rng.randf_range(-0.73, 0.73)
		trunk.append(start - Vector3.UP * (step * 0.80) + sweep * step * 0.11 + jitter)
	draw_branch(trunk, sweep, 0.176)
	for fork in [4, 7, 9]:
		var origin := trunk[fork]
		var direction := 1.0 if fork != 7 else -1.0
		var twig: Array[Vector3] = [origin]
		for step in range(1, 5):
			twig.append(origin + sweep * (direction * step * 0.44 + rng.randf_range(-0.26, 0.26))
				- Vector3.UP * (step * rng.randf_range(0.36, 0.54)))
		draw_branch(twig, sweep, 0.097)
	bolt_mesh.surface_end()
	west = not west

func draw_branch(points: Array[Vector3], horizontal: Vector3, width: float) -> void:
	var uv := [Vector2(0, 0), Vector2(1, 0), Vector2(1, 1), Vector2(0, 1)]
	for index in range(points.size() - 1):
		var size := width * lerpf(1.0, 0.46, float(index) / (points.size() - 1))
		var side := horizontal * size
		var a := points[index]
		var b := points[index + 1]
		var quad := [a - side, a + side, b + side * 0.91, b - side * 0.91]
		for corner in [0, 1, 2, 0, 2, 3]:
			bolt_mesh.surface_set_uv(uv[corner])
			bolt_mesh.surface_add_vertex(quad[corner])

func apply_flash(amount: float) -> void:
	flash = amount
	daylight.light_energy = DAYLIGHT + amount * 0.40
	atmosphere.ambient_light_energy = AMBIENT + amount * 0.08
	cloud_material.set_shader_parameter("flash", amount)
	bolt_material.set_shader_parameter("flash", amount)
	bolt.visible = amount > 0.025

func _exit_tree() -> void:
	if is_instance_valid(rain_audio):
		rain_audio.stop()
		rain_audio.stream = null
	if is_instance_valid(thunder):
		thunder.stop()
		thunder.stream = null
