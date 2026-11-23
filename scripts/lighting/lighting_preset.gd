class_name ForestLightingPreset
extends Resource
## Static visual settings only; no clock, transitions, geometry or café light overrides.
@export var preset_name := ""
@export var sun_rotation := Vector3(-32,-44,0)
@export var sun_color := Color("FFD0A1")
@export var sun_energy := .82
@export var ambient_color := Color("A8B5AC")
@export var ambient_energy := .85
@export var sky_top := Color("789794")
@export var sky_horizon := Color("DDCCAD")
@export var ground_horizon := Color("BFC6B4")
@export var ground_bottom := Color("7A8E82")
@export var sky_energy := .65
@export var sky_curve := -1.0
@export var sun_glow_angle := -1.0
@export var sun_angular_distance := 0.0
@export var sun_in_sky := true
@export var fog_color := Color("B3BFAF")
@export var fog_energy := .45
@export var fog_begin := 38.0
@export var fog_end := 155.0
@export var fog_sky_affect := 1.0
@export var shadow_bias := .09
@export var shadow_normal_bias := 1.1
@export var shadow_blur := 2.0
@export var shadow_distance := 100.0
@export var shadow_blend_splits := false
