shader_type spatial;
render_mode unshaded, cull_disabled, depth_draw_never, shadows_disabled;

uniform float flash = 0.0;

void fragment() {
	float distance_from_core = abs(UV.x * 2.0 - 1.0);
	float core = 1.0 - smoothstep(0.10, 0.32, distance_from_core);
	float halo = 1.0 - smoothstep(0.05, 1.0, distance_from_core);
	ALBEDO = mix(vec3(0.42, 0.65, 0.96), vec3(0.93, 0.98, 1.0), core);
	ALPHA = flash * (core * 0.91 + halo * 0.17);
}
