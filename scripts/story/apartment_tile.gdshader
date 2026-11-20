shader_type spatial;

uniform vec4 ceramic : source_color = vec4(0.56, 0.62, 0.59, 1.0);
uniform float tile_width = 0.22;
uniform float wear : hint_range(0.0, 1.0) = 0.0;
varying vec3 room_point;
varying vec3 axis;

void vertex() {
	room_point = (MODEL_MATRIX * vec4(VERTEX, 1.0)).xyz;
	axis = abs(normalize(MODEL_NORMAL_MATRIX * NORMAL));
}

float hash_cell(vec2 position) {
	return fract(sin(dot(position, vec2(59.2, 191.1))) * 3618.7);
}

float patch(vec2 position) {
	vec2 cell = floor(position);
	vec2 f = fract(position);
	f = f * f * (3.0 - 2.0 * f);
	return mix(mix(hash_cell(cell), hash_cell(cell + vec2(1.0, 0.0)), f.x),
		mix(hash_cell(cell + vec2(0.0, 1.0)), hash_cell(cell + vec2(1.0, 1.0)), f.x), f.y);
}

void fragment() {
	vec2 plane = axis.y > 0.6 ? room_point.xz : (axis.x > 0.6 ? room_point.zy : room_point.xy);
	vec2 grid = plane / tile_width;
	vec2 cell = floor(grid);
	vec2 edge = min(fract(grid), 1.0 - fract(grid));
	float join_line = smoothstep(0.008, 0.025, min(edge.x, edge.y));
	float shade = 0.92 + 0.14 * hash_cell(cell);
	float blotches = patch(plane * 4.0) * 0.61 + patch(plane * 14.0) * 0.29 + patch(plane * 43.0) * 0.10;
	float grit = patch(plane * 67.0);
	float damp = 1.0 - smoothstep(0.22, 1.22, room_point.y + blotches * 0.33);
	float drips = smoothstep(0.58, 0.89, patch(plane * vec2(35.0, 3.0))) * damp;
	float near_drain = 1.0 - smoothstep(0.13, 0.56, distance(room_point.xz, vec2(4.11, 0.435)));
	float around_toilet = 1.0 - smoothstep(0.16, 0.54, distance(room_point.xz, vec2(4.03, 1.57)));
	float floor_dirt = 0.23 + max(near_drain * 0.76, around_toilet * 0.64);
	float place_dirt = axis.y > 0.6 ? floor_dirt : 0.14 + damp * 0.74;
	float stain = clamp((smoothstep(0.33, 0.76, blotches + 0.19) * place_dirt + drips * 0.30) * wear, 0.0, 0.91);
	float dirty_grout = (1.0 - join_line) * wear * (0.29 + place_dirt * grit);
	vec3 clean = mix(ceramic.rgb * 0.70, ceramic.rgb * shade, join_line);
	vec3 old_dirt = clean * mix(vec3(0.30, 0.33, 0.20), vec3(0.62, 0.48, 0.29), blotches);
	ALBEDO = mix(clean, old_dirt, clamp(stain * 0.99 + dirty_grout, 0.0, 0.88));
	ROUGHNESS = mix(mix(0.91, 0.58, join_line), 0.34, stain * axis.y);
	SPECULAR = 0.24;
}
