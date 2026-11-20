shader_type spatial;
render_mode cull_disabled, shadows_disabled, depth_draw_never;

uniform float wear : hint_range(0.0, 1.0) = 0.0;
varying vec3 room_point;

void vertex() {
	room_point = (MODEL_MATRIX * vec4(VERTEX, 1.0)).xyz;
}

float hash_cell(vec2 p) {
	return fract(sin(dot(p, vec2(43.82, 91.19))) * 17731.51);
}

float film(vec2 p) {
	vec2 cell = floor(p);
	vec2 f = fract(p);
	f = f * f * (3.0 - 2.0 * f);
	return mix(mix(hash_cell(cell), hash_cell(cell + vec2(1.0, 0.0)), f.x),
		mix(hash_cell(cell + vec2(0.0, 1.0)), hash_cell(cell + vec2(1.0, 1.0)), f.x), f.y);
}

void fragment() {
	vec2 pane = room_point.zy;
	vec2 scaled = pane * vec2(31.0, 23.0);
	vec2 cell = floor(scaled);
	vec2 offset = vec2(hash_cell(cell), hash_cell(cell + 3.41)) * 0.46 + 0.27;
	float edge = 1.0 - smoothstep(0.076, 0.146, length((fract(scaled) - offset) * vec2(1.12, 0.83)));
	float spots = edge * smoothstep(0.43, 0.71, hash_cell(cell + 4.3));
	float marks = smoothstep(0.68, 0.94, film(pane * vec2(53.0, 2.1))) * film(pane * 7.0);
	float lower = 1.0 - smoothstep(0.25, 0.80, room_point.y);
	float deposits = max(spots * 0.57, marks * 0.59) * wear;
	float haze = (0.22 + 0.48 * lower) * smoothstep(0.26, 0.80, film(pane * 9.0)) * wear;
	ALBEDO = mix(vec3(0.48, 0.63, 0.59), vec3(0.66, 0.63, 0.48), max(deposits, haze));
	ROUGHNESS = mix(0.26, 0.86, clamp(deposits + haze, 0.0, 1.0));
	ALPHA = 0.14 + 0.54 * deposits + 0.36 * haze;
}
