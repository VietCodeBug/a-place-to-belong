shader_type spatial;
render_mode cull_disabled;

uniform float glow_strength = 1.0;
varying float bloom;

void vertex() {
	bloom = UV.y;
	float sway = sin(TIME * 0.79 + VERTEX.x * 0.33 + VERTEX.z * 0.64);
	VERTEX.x += sway * 0.063 * bloom;
	VERTEX.z += cos(TIME * 0.6 + VERTEX.z * 0.59) * 0.054 * bloom;
}

void fragment() {
	float ripple = 0.92 + 0.08 * sin(TIME * 0.83 + VERTEX.x * 0.50 + VERTEX.z * 0.64);
	ALBEDO = COLOR.rgb;
	EMISSION = COLOR.rgb * bloom * glow_strength * ripple * 0.39;
	BACKLIGHT = vec3(0.021, 0.078, 0.087);
	ROUGHNESS = 0.62;
}
