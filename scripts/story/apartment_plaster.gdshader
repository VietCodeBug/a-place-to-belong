shader_type spatial;

uniform vec4 paint : source_color = vec4(0.66, 0.66, 0.59, 1.0);
uniform float wear : hint_range(0.0, 1.0) = 0.0;
varying vec3 room_point;
varying vec3 room_normal;

void vertex() {
	room_point = (MODEL_MATRIX * vec4(VERTEX, 1.0)).xyz;
	room_normal = abs(normalize(MODEL_NORMAL_MATRIX * NORMAL));
}

float hash2(vec2 p) {
	return fract(sin(dot(p, vec2(127.1, 311.7))) * 43758.5453);
}

float patches(vec2 p) {
	vec2 cell = floor(p);
	vec2 f = fract(p);
	f = f * f * (3.0 - 2.0 * f);
	return mix(mix(hash2(cell), hash2(cell + vec2(1.0, 0.0)), f.x),
		mix(hash2(cell + vec2(0.0, 1.0)), hash2(cell + vec2(1.0, 1.0)), f.x), f.y);
}

void fragment() {
	float axis = mix(room_point.x, room_point.z, room_normal.x);
	vec2 uv = vec2(axis, room_point.y);
	float larger = patches(uv * 1.97) * 0.68 + patches(uv * 6.8) * 0.32;
	float grain = patches(uv * 71.0) - 0.5;
	float low = 1.0 - smoothstep(0.0, 1.32, room_point.y);
	float moisture = smoothstep(0.45, 0.77, larger + low * 0.19) * (0.25 + 0.75 * low);
	float run = smoothstep(0.59, 0.84, patches(uv * vec2(14.0, 2.1))) * low;
	float depth = min(0.55, (moisture * 0.68 + run * 0.35) * wear);
	vec3 dull = paint.rgb * vec3(0.57, 0.58, 0.49);
	ALBEDO = mix(paint.rgb * (0.986 + grain * 0.047), dull, depth);
	ROUGHNESS = 0.99;
	SPECULAR = 0.16;
}
