class_name ForestLife
extends Node3D
## Subtle, deterministic low-poly environmental life synced to time and weather:
## chimney smoke, flower-verge butterflies, canopy birds, falling autumn leaves, and nighttime fireflies.

const CHIMNEY_TOP := Vector3(-5.35, 7.28, -8.15)
const SMOKE_COUNT := 14
const BUTTERFLY_COUNT := 8
const BIRD_COUNT := 5
const LEAF_COUNT := 16
const FIREFLY_COUNT := 24

var clock := 0.0
var daylight := 1.0
var rain_amount := 0.0
var wind_dir := Vector2(0.85, 0.52).normalized()
var wind_speed := 0.08

var smoke_mm: MultiMesh
var smoke_mat: StandardMaterial3D
var butterfly_mm: MultiMesh
var butterfly_node: MultiMeshInstance3D
var bird_mm: MultiMesh
var bird_node: MultiMeshInstance3D
var leaf_mm: MultiMesh
var firefly_mm: MultiMesh
var firefly_node: MultiMeshInstance3D
var firefly_mat: StandardMaterial3D

const FLOWER_ZONES := [
	Vector2(6.0, 10.5),
	Vector2(-6.2, 16.7),
	Vector2(10.3, 10.4),
	Vector2(-9.1, 12.7),
]

const AUTUMN_TREES := [
	Vector3(-12.0, 6.2, 4.0),
	Vector3(18.0, 6.8, -9.0),
	Vector3(15.0, 5.8, 4.5),
	Vector3(-19.0, 6.4, -5.0),
]

const FIREFLY_ZONES := [
	Vector2(-11.4, 5.4),
	Vector2(10.4, 12.0),
	Vector2(-8.2, 15.0),
	Vector2(6.5, 8.2),
]

func _ready() -> void:
	build_chimney_smoke()
	build_butterflies()
	build_birds()
	build_falling_leaves()
	build_fireflies()
	update_life(0.0)
	var habitats=preload("res://scripts/environment/forest_habitats.gd").new()
	habitats.name="AuthoredHabitats";habitats.weather=get_parent().get_node("ForestWeather");add_child(habitats)

func sync_state(p_clock: float, p_daylight: float, p_rain: float, p_wind_dir: Vector2, p_wind_strength: float) -> void:
	clock = p_clock
	daylight = p_daylight
	rain_amount = p_rain
	if p_wind_dir.length_squared() > 0.001:
		wind_dir = p_wind_dir.normalized()
	wind_speed = p_wind_strength
	update_life(0.0)

func _process(delta: float) -> void:
	clock += delta
	update_life(delta)

func update_life(_delta: float) -> void:
	update_smoke()
	update_butterflies()
	update_birds()
	update_leaves()
	update_fireflies()

func build_chimney_smoke() -> void:
	var sphere := SphereMesh.new()
	sphere.radial_segments = 7
	sphere.rings = 4
	sphere.radius = 0.22
	sphere.height = 0.38
	smoke_mat = StandardMaterial3D.new()
	smoke_mat.albedo_color = Color(0.95, 0.92, 0.87, 0.58)
	smoke_mat.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	smoke_mat.roughness = 1.0
	smoke_mat.shading_mode = BaseMaterial3D.SHADING_MODE_PER_VERTEX
	smoke_mm = MultiMesh.new()
	smoke_mm.transform_format = MultiMesh.TRANSFORM_3D
	smoke_mm.mesh = sphere
	smoke_mm.instance_count = SMOKE_COUNT
	var inst := MultiMeshInstance3D.new()
	inst.name = "ChimneySmoke"
	inst.multimesh = smoke_mm
	inst.material_override = smoke_mat
	inst.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	add_child(inst)

func update_smoke() -> void:
	if smoke_mm == null:
		return
	var night_warm := Color(0.74, 0.72, 0.76, 0.44).lerp(Color(0.95, 0.92, 0.87, 0.54), daylight)
	smoke_mat.albedo_color = night_warm
	for i in range(SMOKE_COUNT):
		var phase := fposmod(clock * 0.22 + float(i) / float(SMOKE_COUNT), 1.0)
		var rise := phase * 4.4
		var drift := wind_dir * (pow(phase, 1.35) * (1.5 + wind_speed * 6.5))
		var swirl := Vector2(sin(phase * 5.2 + i), cos(phase * 4.4 + i * 1.7)) * (0.08 + phase * 0.24)
		var pos := CHIMNEY_TOP + Vector3(drift.x + swirl.x, rise, drift.y + swirl.y)
		var puff_scale := sin(phase * PI) * lerpf(0.55, 1.85, phase)
		puff_scale = maxf(0.01, puff_scale)
		var basis := Basis.from_euler(Vector3(phase * 1.2, float(i) * 0.8 + phase, phase * 0.7)).scaled(Vector3(puff_scale * 1.15, puff_scale * 0.92, puff_scale * 1.15))
		smoke_mm.set_instance_transform(i, Transform3D(basis, pos))

func build_butterflies() -> void:
	var st := SurfaceTool.new()
	st.begin(Mesh.PRIMITIVE_TRIANGLES)
	st.set_smooth_group(-1)
	# Simple folded two-wing low-poly butterfly mesh
	var left_a := Vector3(-0.075, 0.025, -0.045)
	var left_b := Vector3(-0.065, 0.020, 0.050)
	var right_a := Vector3(0.075, 0.025, -0.045)
	var right_b := Vector3(0.065, 0.020, 0.050)
	var c0 := Vector3(0.0, 0.0, -0.03)
	var c1 := Vector3(0.0, 0.0, 0.035)
	for tri in [[c0, left_a, c1], [c1, left_a, left_b], [c0, c1, right_a], [c1, right_b, right_a]]:
		for v in tri:
			st.add_vertex(v)
	st.generate_normals()
	var mat := StandardMaterial3D.new()
	mat.vertex_color_use_as_albedo = false
	mat.albedo_color = Color("F6DF9B")
	mat.emission_enabled = true
	mat.emission = Color("E8C878")
	mat.emission_energy_multiplier = 0.22
	mat.cull_mode = BaseMaterial3D.CULL_DISABLED
	mat.roughness = 0.95
	butterfly_mm = MultiMesh.new()
	butterfly_mm.transform_format = MultiMesh.TRANSFORM_3D
	butterfly_mm.use_colors = true
	butterfly_mm.mesh = st.commit()
	butterfly_mm.instance_count = BUTTERFLY_COUNT
	butterfly_node = MultiMeshInstance3D.new()
	butterfly_node.name = "FlowerButterflies"
	butterfly_node.multimesh = butterfly_mm
	butterfly_node.material_override = mat
	butterfly_node.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	mat.vertex_color_use_as_albedo = true
	add_child(butterfly_node)

func update_butterflies() -> void:
	if butterfly_mm == null:
		return
	var active_factor := smoothstep(0.28, 0.55, daylight) * (1.0 - smoothstep(0.08, 0.28, rain_amount))
	butterfly_node.visible = active_factor > 0.02
	if not butterfly_node.visible:
		return
	for i in range(BUTTERFLY_COUNT):
		var center: Vector2 = FLOWER_ZONES[i % FLOWER_ZONES.size()]
		var t := clock * (0.85 + float(i % 3) * 0.18) + float(i) * 1.9
		var orbit := Vector2(sin(t) * 1.15 + cos(t * 2.1) * 0.35, cos(t * 0.82) * 0.95 + sin(t * 1.7) * 0.3)
		var wx := center.x + orbit.x
		var wz := center.y + orbit.y
		var wy := ForestLandscape.height_at(wx, wz) + 0.42 + 0.22 * sin(t * 2.7)
		var heading := atan2(cos(t) * 1.15, -sin(t * 0.82) * 0.95)
		var flap := 0.55 + 0.45 * absf(sin(clock * 11.5 + float(i) * 2.3))
		var basis := Basis(Vector3.UP, heading) * Basis.from_scale(Vector3(flap, 1.0 + (1.0 - flap) * 0.6, 1.0) * active_factor)
		butterfly_mm.set_instance_transform(i, Transform3D(basis, Vector3(wx, wy, wz)))
		butterfly_mm.set_instance_color(i, Color("F7E39C") if i % 3 != 0 else Color("DEC0EA"))

func build_birds() -> void:
	var st := SurfaceTool.new()
	st.begin(Mesh.PRIMITIVE_TRIANGLES)
	st.set_smooth_group(-1)
	var beak := Vector3(0.0, 0.0, -0.18)
	var tail := Vector3(0.0, 0.02, 0.18)
	var belly := Vector3(0.0, -0.04, 0.0)
	var wing_l := Vector3(-0.24, 0.05, 0.01)
	var wing_r := Vector3(0.24, 0.05, 0.01)
	for tri in [[beak, wing_l, tail], [beak, tail, wing_r], [beak, belly, tail]]:
		for v in tri:
			st.add_vertex(v)
	st.generate_normals()
	var mat := StandardMaterial3D.new()
	mat.albedo_color = Color("5B4D42")
	mat.cull_mode = BaseMaterial3D.CULL_DISABLED
	mat.roughness = 1.0
	bird_mm = MultiMesh.new()
	bird_mm.transform_format = MultiMesh.TRANSFORM_3D
	bird_mm.mesh = st.commit()
	bird_mm.instance_count = BIRD_COUNT
	bird_node = MultiMeshInstance3D.new()
	bird_node.name = "WoodlandBirds"
	bird_node.multimesh = bird_mm
	bird_node.material_override = mat
	bird_node.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	add_child(bird_node)

func update_birds() -> void:
	if bird_mm == null:
		return
	var active := smoothstep(0.18, 0.45, daylight) * (1.0 - smoothstep(0.20, 0.55, rain_amount))
	bird_node.visible = active > 0.02
	if not bird_node.visible:
		return
	for i in range(BIRD_COUNT):
		var speed := 0.24 + float(i) * 0.035
		var a := clock * speed + float(i) * 1.45
		var rx := 15.0 + float(i % 3) * 4.5
		var rz := 12.5 + float(i % 2) * 4.0
		var cx := -2.0 + float(i - 2) * 3.0
		var cz := -4.0 + float(i % 2) * 4.0
		var pos := Vector3(cx + cos(a) * rx, 10.8 + float(i) * 1.05 + sin(a * 2.2) * 0.65, cz + sin(a) * rz)
		var vel := Vector3(-sin(a) * rx, cos(a * 2.2) * 0.4, cos(a) * rz).normalized()
		var yaw := atan2(-vel.x, -vel.z)
		var bank := sin(a) * 0.28
		# Alternate gentle wing beats with calm glides
		var glide_cycle := sin(clock * 0.9 + float(i) * 1.7)
		var flap := 1.0 if glide_cycle > 0.2 else (0.65 + 0.35 * sin(clock * 9.5 + float(i)))
		var basis := Basis.from_euler(Vector3(0.0, yaw, bank)) * Basis.from_scale(Vector3(1.0, flap, 1.0) * active)
		bird_mm.set_instance_transform(i, Transform3D(basis, pos))

func build_falling_leaves() -> void:
	var st := SurfaceTool.new()
	st.begin(Mesh.PRIMITIVE_TRIANGLES)
	var a := Vector3(0.0, 0.0, -0.07)
	var b := Vector3(-0.045, 0.01, 0.0)
	var c := Vector3(0.0, 0.0, 0.07)
	var d := Vector3(0.045, -0.01, 0.0)
	for tri in [[a, b, c], [a, c, d]]:
		for v in tri:
			st.add_vertex(v)
	st.generate_normals()
	var mat := StandardMaterial3D.new()
	mat.vertex_color_use_as_albedo = true
	mat.cull_mode = BaseMaterial3D.CULL_DISABLED
	mat.roughness = 0.95
	leaf_mm = MultiMesh.new()
	leaf_mm.transform_format = MultiMesh.TRANSFORM_3D
	leaf_mm.use_colors = true
	leaf_mm.mesh = st.commit()
	leaf_mm.instance_count = LEAF_COUNT
	var inst := MultiMeshInstance3D.new()
	inst.name = "FallingAutumnLeaves"
	inst.multimesh = leaf_mm
	inst.material_override = mat
	inst.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	add_child(inst)

func update_leaves() -> void:
	if leaf_mm == null:
		return
	for i in range(LEAF_COUNT):
		var origin: Vector3 = AUTUMN_TREES[i % AUTUMN_TREES.size()]
		var phase := fposmod(clock * (0.09 + float(i % 4) * 0.015) + float(i) * 0.173, 1.0)
		var ground_y := ForestLandscape.height_at(origin.x, origin.z)
		var y := lerpf(origin.y, ground_y + 0.08, phase)
		var spiral_r := 0.8 + phase * 1.4
		var ang := phase * 7.5 + float(i) * 2.1
		var drift := wind_dir * (phase * (1.8 + wind_speed * 5.0))
		var pos := Vector3(origin.x + cos(ang) * spiral_r + drift.x, y, origin.z + sin(ang) * spiral_r + drift.y)
		var fade := sin(clampf(phase * 1.08, 0.0, 1.0) * PI)
		var sc := maxf(0.01, clampf(fade * 1.6, 0.0, 1.0))
		var basis := Basis.from_euler(Vector3(ang * 0.9, ang, sin(ang) * 0.6)).scaled(Vector3.ONE * sc)
		leaf_mm.set_instance_transform(i, Transform3D(basis, pos))
		leaf_mm.set_instance_color(i, Color("D9964B") if i % 2 == 0 else Color("C66A43"))

func build_fireflies() -> void:
	var sphere := SphereMesh.new()
	sphere.radial_segments = 6
	sphere.rings = 3
	sphere.radius = 0.042
	sphere.height = 0.084
	firefly_mat = StandardMaterial3D.new()
	firefly_mat.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	firefly_mat.vertex_color_use_as_albedo = true
	firefly_mat.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	firefly_mm = MultiMesh.new()
	firefly_mm.transform_format = MultiMesh.TRANSFORM_3D
	firefly_mm.use_colors = true
	firefly_mm.mesh = sphere
	firefly_mm.instance_count = FIREFLY_COUNT
	firefly_node = MultiMeshInstance3D.new()
	firefly_node.name = "NightFireflies"
	firefly_node.multimesh = firefly_mm
	firefly_node.material_override = firefly_mat
	firefly_node.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	add_child(firefly_node)

func update_fireflies() -> void:
	if firefly_mm == null:
		return
	var night_factor := (1.0 - smoothstep(0.10, 0.42, daylight)) * (1.0 - smoothstep(0.18, 0.45, rain_amount))
	firefly_node.visible = night_factor > 0.02
	if not firefly_node.visible:
		return
	for i in range(FIREFLY_COUNT):
		var zone: Vector2 = FIREFLY_ZONES[i % FIREFLY_ZONES.size()]
		var t := clock * (0.48 + float(i % 5) * 0.07) + float(i) * 2.4
		var offset := Vector2(sin(t * 0.9 + float(i)) * 2.1, cos(t * 0.75 + float(i) * 0.6) * 1.8)
		var wx := zone.x + offset.x
		var wz := zone.y + offset.y
		var wy := ForestLandscape.height_at(wx, wz) + 0.55 + 0.42 * sin(t * 1.5 + float(i))
		var pulse := 0.30 + 0.70 * pow(0.5 + 0.5 * sin(clock * 2.3 + float(i) * 1.9), 2.0)
		var sc := maxf(0.01, (0.65 + 0.55 * pulse) * night_factor)
		firefly_mm.set_instance_transform(i, Transform3D(Basis.from_scale(Vector3.ONE * sc), Vector3(wx, wy, wz)))
		var glow := Color(1.0, 0.86, 0.44, pulse * night_factor * 0.92)
		firefly_mm.set_instance_color(i, glow)
