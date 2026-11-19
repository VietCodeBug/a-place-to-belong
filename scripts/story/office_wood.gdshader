shader_type spatial;

// Smoked oak boards with staggered joints and a fine grain.
uniform vec4 wood : source_color = vec4(0.46, 0.30, 0.21, 1.0);
uniform bool boards = true;
varying vec3 world_point;

void vertex() {
	world_point = (MODEL_MATRIX * vec4(VERTEX, 1.0)).xyz;
}

float hash21(vec2 cell) {
	return fract(sin(dot(cell, vec2(28.91, 87.15))) * 18471.67);
}

float grain_noise(vec2 point) {
	vec2 cell = floor(point);
	vec2 f = fract(point);
	f = f * f * (3.0 - 2.0 * f);
	return mix(mix(hash21(cell), hash21(cell + vec2(1, 0)), f.x),
		mix(hash21(cell + vec2(0, 1)), hash21(cell + vec2(1, 1)), f.x), f.y);
}

void fragment() {
	vec2 point = world_point.xz;
	float board = floor(point.x / 0.204);
	float end_joint = (point.y + hash21(vec2(board, 49.0)) * 1.74) / 1.96;
	vec2 cell = vec2(board, floor(end_joint));
	float broad = grain_noise(point * vec2(14.1, 0.83));
	float fine = grain_noise(point * vec2(111.0, 2.34));
	float warp = grain_noise(point * vec2(4.0, 0.38));
	float grain = sin((point.x + warp * 0.024) * 174.0) * 0.5 + 0.5;
	float tone = 0.88 + broad * 0.15 + fine * 0.06 + grain * 0.038;
	if (boards) {
		float side = abs(fract(point.x / 0.204) - 0.5);
		float end = abs(fract(end_joint) - 0.5);
		float seam = max(smoothstep(0.480, 0.5, side), smoothstep(0.496, 0.5, end));
		tone *= 0.85 + 0.26 * hash21(cell) - seam * 0.21;
	}
	ALBEDO = wood.rgb * tone;
	ROUGHNESS = mix(0.72, 0.86, broad);
	SPECULAR = 0.31;
}
