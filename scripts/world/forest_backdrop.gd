class_name ForestBackdrop
extends Node3D
## Layered non-colliding low-poly mountain & valley ridge rings that frame Map 01
## from every camera angle and hide outer terrain edges without expanding playable bounds.

const RIDGE_SHADER := preload("res://shaders/distant_ridge.gdshader")
var layer_materials: Array[ShaderMaterial] = []

func _ready() -> void:
	build_ring("FoothillRidgeRing", 138.0, 96, -7.5, 30.0, 16.0, 0.26, Color("3A5648"), Color("56735D"), 1.0)
	build_ring("MidValleyRidgeRing", 205.0, 108, -10.0, 64.0, 28.0, 0.50, Color("446063"), Color("64807E"), 1.7)
	build_ring("FarMountainCrownRing", 290.0, 120, -14.0, 100.0, 36.0, 0.72, Color("57707D"), Color("7B939D"), 2.9)

func build_ring(ring_name: String, radius: float, segments: int, base_y: float, peak_scale: float, mist_height: float, haze: float, base_col: Color, top_col: Color, phase: float) -> void:
	var st := SurfaceTool.new()
	st.begin(Mesh.PRIMITIVE_TRIANGLES)
	st.set_smooth_group(0)
	var inner_r := radius * 0.62
	var outer_r := radius * 1.40
	for i in range(segments):
		var a0 := float(i) / float(segments) * TAU
		var a1 := float(i + 1) / float(segments) * TAU
		var am := (a0 + a1) * 0.5
		# The real A1 valley and its distant peaks fill the southern sector.
		# The legacy enclosing ridge would slice across its playable terrain.
		if sin(am) > .43 or (radius<150.0 and sin(am)<-.78):
			continue
		var h0 := ridge_profile(a0, peak_scale, phase)
		var h1 := ridge_profile(a1, peak_scale, phase)
		var hm := (h0 + h1) * 0.5 + ridge_detail(am * 3.0 + phase) * peak_scale * 0.008

		var in0 := Vector3(cos(a0) * inner_r, base_y, sin(a0) * inner_r)
		var in1 := Vector3(cos(a1) * inner_r, base_y, sin(a1) * inner_r)
		var pk0 := Vector3(cos(a0) * radius, h0, sin(a0) * radius)
		var pk1 := Vector3(cos(a1) * radius, h1, sin(a1) * radius)
		var pkm := Vector3(cos(am) * (radius * 0.985), hm, sin(am) * (radius * 0.985))
		var out0 := Vector3(cos(a0) * outer_r, base_y - 6.0, sin(a0) * outer_r)
		var out1 := Vector3(cos(a1) * outer_r, base_y - 6.0, sin(a1) * outer_r)

		# Faceted inner slopes facing the clearing
		add_tri(st, in0, pk0, pkm)
		add_tri(st, in0, pkm, in1)
		add_tri(st, in1, pkm, pk1)
		# Outer backslopes so wide/high angles never see hollow shells
		add_tri(st, pk0, out0, pkm)
		add_tri(st, pkm, out0, out1)
		add_tri(st, pkm, out1, pk1)

	st.generate_normals()
	var inst := MeshInstance3D.new()
	inst.name = ring_name
	inst.mesh = st.commit()
	inst.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	var mat := ShaderMaterial.new()
	mat.shader = RIDGE_SHADER
	mat.set_shader_parameter("ridge_color", base_col)
	mat.set_shader_parameter("crest_color", top_col)
	mat.set_shader_parameter("haze_amount", haze)
	mat.set_shader_parameter("foot_fade_height", mist_height)
	mat.set_shader_parameter("crest_height", peak_scale * 0.65)
	mat.set_meta("base_ridge_color", base_col)
	mat.set_meta("base_crest_color", top_col)
	mat.set_meta("base_haze", haze)
	inst.material_override = mat
	layer_materials.append(mat)
	add_child(inst)

func ridge_profile(angle: float, peak_scale: float, phase: float) -> float:
	# Intentional scenic composition: taller Alpine/woodland peaks behind the cafe (-Z, NW, NE),
	# rolling hills to East/West, and a gentler saddle in the SE (+X, +Z) so high wide cameras stay unobstructed.
	var dir := Vector2(cos(angle), sin(angle))
	var north_crown := smoothstep(-0.15, 0.85, -dir.y) * 0.42
	var twin_vistas := exp(-pow(angle_diff(angle, -2.18), 2.0) / 0.28) * 0.34 + exp(-pow(angle_diff(angle, -0.92), 2.0) / 0.32) * 0.38
	var side_hills := (exp(-pow(angle_diff(angle, 0.15), 2.0) / 0.45) + exp(-pow(angle_diff(angle, 2.85), 2.0) / 0.45)) * 0.24
	var se_saddle := 1.0 - 0.42 * exp(-pow(angle_diff(angle, 0.82), 2.0) / 0.36)
	var silhouette := 0.26 + north_crown + twin_vistas + side_hills
	var waves := 0.64 + 0.20 * sin(angle * 3.0 + phase) + 0.10 * cos(angle * 5.0 - phase * .6)
	return maxf(2.2, peak_scale * silhouette * waves * se_saddle + pow(maxf(0.,sin(angle*3.+phase)),8.)*.20)

func ridge_detail(t: float) -> float:
	return sin(t) * 0.6 + cos(t * 2.3 + 1.1) * 0.4

func angle_diff(a: float, b: float) -> float:
	return wrapf(a - b, -PI, PI)

func add_tri(st: SurfaceTool, a: Vector3, b: Vector3, c: Vector3) -> void:
	st.add_vertex(a)
	st.add_vertex(b)
	st.add_vertex(c)

func apply_atmosphere(sky_top: Color, sky_horizon: Color, ambient: Color, daylight: float, occlusion: float, sun_dir: Vector3) -> void:
	var haze := sky_horizon.lerp(sky_top, 0.28).lerp(Color("7A8B90"), occlusion * 0.45 * daylight)
	if daylight < 0.35:
		haze = haze.lerp(Color("1E314B"), (1.0 - daylight / 0.35) * 0.55)
	for i in range(layer_materials.size()):
		var mat := layer_materials[i]
		var base_r: Color = mat.get_meta("base_ridge_color")
		var base_c: Color = mat.get_meta("base_crest_color")
		var base_h: float = mat.get_meta("base_haze")
		var night_tint := Color("1C2D42").lerp(Color("293E59"), float(i) * 0.35)
		var lit_r := night_tint.lerp(base_r.lerp(ambient, 0.16), smoothstep(0.02, 0.55, daylight))
		var lit_c := night_tint.lightened(0.08).lerp(base_c.lerp(sky_horizon, 0.18), smoothstep(0.02, 0.55, daylight))
		lit_r = lit_r.darkened(occlusion * 0.18)
		lit_c = lit_c.darkened(occlusion * 0.15)
		mat.set_shader_parameter("ridge_color", lit_r)
		mat.set_shader_parameter("crest_color", lit_c)
		mat.set_shader_parameter("haze_color", haze)
		mat.set_shader_parameter("haze_amount", clampf(base_h + occlusion * 0.14, 0.18, 0.90))
		mat.set_shader_parameter("sun_warmth", daylight * (1.0 - occlusion * 0.75))
		mat.set_shader_parameter("sun_direction", sun_dir)
