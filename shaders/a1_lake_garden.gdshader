shader_type spatial;
render_mode cull_disabled;

uniform float glow_strength = 1.0;
varying float shimmer;

void vertex() {
	float bend = COLOR.a * COLOR.a;
	float phase = INSTANCE_CUSTOM.r * TAU;
	float current = sin(TIME * 0.72 + phase);
	float drift = cos(TIME * 0.56 - phase);
	VERTEX.x += (0.035 + INSTANCE_CUSTOM.g * 0.028) * current * bend;
	VERTEX.z += 0.038 * drift * bend;
	shimmer = 0.92 + 0.08 * sin(TIME * 0.69 + phase);
}

void fragment() {
	float across = abs(UV.y * 2.0 - 1.0);
	float detail = 1.0 - smoothstep(0.035, 0.19, fwidth(UV.x) + fwidth(UV.y));
	float rib_fade = smoothstep(0.04, 0.22, UV.x) * (1.0 - smoothstep(0.72, 0.99, UV.x));
	float midrib = 1.0 - smoothstep(0.019, 0.078, across);
	float fine_ribs = pow(0.5 + 0.5 * cos(45.0 * (UV.x - 0.22 * across + 0.085 * across * across)), 12.0);
	float branching = fine_ribs * smoothstep(0.08, 0.25, across) * (1.0 - smoothstep(0.33, 0.91, across));
	float vein = rib_fade * UV2.y * (midrib * 0.07 + branching * 0.085) * detail;
	float edge = smoothstep(0.40, 0.99, across) * UV2.y * UV.x;
	ALBEDO = COLOR.rgb * (0.89 - vein + edge * 0.055);
	EMISSION = COLOR.rgb * UV2.x * glow_strength * shimmer * 0.46;
	BACKLIGHT = vec3(0.042, 0.086, 0.082) * (0.38 + 0.62 * UV.x) * (0.28 + 0.72 * UV2.y);
	SPECULAR = 0.22;
	ROUGHNESS = 0.76 - edge * 0.13;
}
