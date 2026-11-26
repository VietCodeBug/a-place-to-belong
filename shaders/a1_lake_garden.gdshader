shader_type spatial;
render_mode cull_disabled;

uniform float glow_strength = 1.0;
varying float shimmer;

void vertex() {
	float bend = COLOR.a * COLOR.a;
	float phase = INSTANCE_CUSTOM.r * TAU;
	float current = sin(TIME * 0.72 + phase);
	float drift = cos(TIME * 0.56 - phase);
	VERTEX.x += (0.036 + INSTANCE_CUSTOM.g * 0.027) * current * bend;
	VERTEX.z += 0.041 * drift * bend;
	shimmer = 0.91 + 0.09 * sin(TIME * 0.69 + phase);
}

void fragment() {
	float glow = UV.y;
	ALBEDO = COLOR.rgb;
	EMISSION = COLOR.rgb * glow * glow_strength * shimmer * 0.43;
	BACKLIGHT = vec3(0.019, 0.079, 0.087) * (0.44 + 0.56 * UV.x);
	SPECULAR = 0.24;
	ROUGHNESS = 0.72;
}
