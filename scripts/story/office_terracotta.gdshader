shader_type spatial;

varying vec3 world_point;

void vertex() {
	world_point = (MODEL_MATRIX * vec4(VERTEX, 1.0)).xyz;
}

float hash(vec2 value) {
	return fract(sin(dot(value, vec2(72.7, 162.3))) * 43758.5453);
}

void fragment() {
	vec2 brick = world_point.xy / vec2(0.221, 0.087);
	brick.x += mod(floor(brick.y), 2.0) * 0.5;
	vec2 uv = fract(brick);
	vec2 edge = min(uv, 1.0 - uv);
	float bevel = smoothstep(0.036, 0.095, min(edge.x * 2.15, edge.y));
	float variation = hash(floor(brick));
	vec3 clay = mix(vec3(0.42, 0.26, 0.20), vec3(0.60, 0.40, 0.27), variation);
	clay *= 0.97 + 0.06 * sin(brick.x * 13.0 + sin(brick.y * 6.4));
	ALBEDO = mix(vec3(0.30, 0.28, 0.24), clay, bevel);
	ROUGHNESS = 0.88;
	SPECULAR = 0.24;
}
