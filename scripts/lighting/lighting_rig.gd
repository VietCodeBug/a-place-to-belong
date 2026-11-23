extends RefCounted
const PRESETS := {
	"baseline":"res://assets/lighting/pr09_baseline.tres",
	"golden_hour":"res://assets/lighting/golden_hour.tres",
	"blue_hour":"res://assets/lighting/blue_hour.tres"
}
static func from_arguments() -> Resource:
	var selected := "golden_hour"
	for arg in OS.get_cmdline_user_args():
		if arg.begins_with("--lighting=") and PRESETS.has(arg.trim_prefix("--lighting=")):
			selected=arg.trim_prefix("--lighting=")
	return load(PRESETS[selected])

static func apply(hub: Node3D,preset: ForestLightingPreset) -> void:
	# Replace only this rig's environment and directional light when reviewing candidates.
	for child in hub.get_children():
		if child.get_meta("map01_lighting",false): child.free()
	var world:=WorldEnvironment.new()
	world.name="WorldEnvironment"
	world.set_meta("map01_lighting",true)
	var env:=Environment.new()
	env.background_mode=Environment.BG_SKY
	var sky:=Sky.new()
	var atmosphere:=ProceduralSkyMaterial.new()
	atmosphere.sky_top_color=preset.sky_top
	atmosphere.sky_horizon_color=preset.sky_horizon
	atmosphere.ground_horizon_color=preset.ground_horizon
	atmosphere.ground_bottom_color=preset.ground_bottom
	atmosphere.sky_energy_multiplier=preset.sky_energy
	if preset.sky_curve>=0: atmosphere.sky_curve=preset.sky_curve
	if preset.sun_glow_angle>=0: atmosphere.sun_angle_max=preset.sun_glow_angle
	sky.sky_material=atmosphere
	env.sky=sky
	env.background_color=Color("AABCB7")
	env.ambient_light_source=Environment.AMBIENT_SOURCE_COLOR
	env.ambient_light_color=preset.ambient_color
	env.ambient_light_energy=preset.ambient_energy
	# Keep PR09's verified, restrained SSAO settings across all presets.
	env.ssao_enabled=true
	env.ssao_radius=.55
	env.ssao_intensity=.65
	env.ssao_power=1.1
	env.fog_enabled=true
	env.fog_light_color=preset.fog_color
	env.fog_light_energy=preset.fog_energy
	env.fog_mode=Environment.FOG_MODE_DEPTH
	env.fog_depth_begin=preset.fog_begin
	env.fog_depth_end=preset.fog_end
	env.fog_sky_affect=preset.fog_sky_affect
	world.environment=env
	hub.add_child(world)
	var sun:=DirectionalLight3D.new()
	sun.name="Sun"
	sun.set_meta("map01_lighting",true)
	sun.rotation_degrees=preset.sun_rotation
	sun.light_color=preset.sun_color
	sun.light_energy=preset.sun_energy
	sun.light_angular_distance=preset.sun_angular_distance
	sun.sky_mode=DirectionalLight3D.SKY_MODE_LIGHT_AND_SKY if preset.sun_in_sky else DirectionalLight3D.SKY_MODE_LIGHT_ONLY
	sun.shadow_enabled=true
	sun.shadow_normal_bias=preset.shadow_normal_bias
	sun.shadow_bias=preset.shadow_bias
	sun.shadow_blur=preset.shadow_blur
	sun.directional_shadow_mode=DirectionalLight3D.SHADOW_PARALLEL_4_SPLITS
	sun.directional_shadow_blend_splits=preset.shadow_blend_splits
	sun.directional_shadow_max_distance=preset.shadow_distance
	hub.add_child(sun)
	hub.set_meta("active_lighting",preset.preset_name)
	print("Lighting preset: ",preset.preset_name," sun=",preset.sun_rotation," energy=",preset.sun_energy," ambient=",preset.ambient_energy)
