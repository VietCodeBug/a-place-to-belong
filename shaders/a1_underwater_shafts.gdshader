shader_type spatial;
render_mode unshaded, blend_add, cull_disabled, depth_draw_never;

uniform float strength = 1.18;

void fragment() {
	float cross_section = 1.0 - abs(UV.x * 2.0 - 1.0);
	float taper = smoothstep(0.0, 0.18, UV.y) * (1.0 - smoothstep(0.40, 1.0, UV.y));
	float shimmer = 0.89 + 0.11 * sin(TIME * 0.67 + VERTEX.x * 0.21);
	ALBEDO = vec3(0.22, 0.79, 0.90);
	ALPHA = cross_section * cross_section * taper * shimmer * 0.095 * strength;
}
