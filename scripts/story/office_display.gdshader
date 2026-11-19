shader_type spatial;
render_mode unshaded, shadows_disabled;

uniform int layout = 0;

float rect(vec2 p, vec2 lo, vec2 hi) {
	vec2 distance_to_edge = min(p - lo, hi - p);
	return smoothstep(-0.001, 0.004, min(distance_to_edge.x, distance_to_edge.y));
}

void fragment() {
	vec2 p = UV;
	vec3 background = vec3(0.24, 0.34, 0.36);
	vec3 panel = vec3(0.56, 0.66, 0.63);
	vec3 detail = vec3(0.32, 0.45, 0.44);
	vec3 warm = vec3(0.76, 0.65, 0.47);
	vec3 color = background;
	color = mix(color, vec3(0.36, 0.48, 0.47), rect(p, vec2(0.0), vec2(1.0, 0.115)));
	color = mix(color, warm, rect(p, vec2(0.033, 0.048), vec2(0.057, 0.074)));
	color = mix(color, panel, rect(p, vec2(0.16, 0.14), vec2(0.982, 0.957)));
	if (layout == 2) {
		for (int i = 0; i < 4; i++) {
			float x = 0.27 + float(i) * 0.15;
			float bar_height = 0.18 + mod(float(i) * 0.77, 0.43);
			color = mix(color, mix(detail, warm, float(i) / 4.0), rect(p, vec2(x, 0.82 - bar_height), vec2(x + 0.079, 0.82)));
		}
	} else {
		for (int i = 0; i < 4; i++) {
			float row = 0.37 + float(i) * 0.136;
			color = mix(color, detail, rect(p, vec2(0.205, row), vec2(0.566 - float(i) * 0.029, row + 0.019)));
			color = mix(color, detail * 1.28, rect(p, vec2(0.205, row + 0.039), vec2(0.412 + float(i) * 0.07, row + 0.051)));
			color = mix(color, detail * 1.32, rect(p, vec2(0.205, row + 0.083), vec2(0.928, row + 0.090)));
		}
	}
	for (int i = 0; i < 5; i++) {
		float y = 0.21 + float(i) * 0.138;
		color = mix(color, detail * 1.38, rect(p, vec2(0.036, y), vec2(0.116, y + 0.014)));
	}
	float reflection = smoothstep(0.12, 0.44, 1.0 - p.x - p.y * 0.92) * 0.025;
	ALBEDO = color + reflection;
}
