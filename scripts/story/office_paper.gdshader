shader_type spatial;
render_mode cull_disabled;

uniform vec4 stock : source_color = vec4(0.91, 0.885, 0.82, 1.0);
uniform int form = 0;

float rect(vec2 p, vec2 lo, vec2 hi) {
	vec2 inner = min(p - lo, hi - p);
	return smoothstep(-0.004, 0.003, min(inner.x, inner.y));
}

float hash(vec2 p) {
	return fract(sin(dot(p, vec2(23.438, 72.082))) * 15731.38);
}

vec3 newspaper(vec2 p, vec3 paper, vec3 ink) {
	float title = rect(p, vec2(0.09, 0.075), vec2(0.79, 0.15));
	float letter = step(0.14, fract(p.x * 13.0)) * step(0.13, hash(vec2(floor(p.x * 19.0), floor(p.y * 65.0))));
	float rule = rect(p, vec2(0.08, 0.185), vec2(0.92, 0.195));
	float headline = rect(p, vec2(0.09, 0.225), vec2(0.69, 0.27));
	vec3 color = mix(paper, ink * 0.74, max(title * letter, max(rule, headline * letter)));
	float photo = rect(p, vec2(0.09, 0.32), vec2(0.57, 0.59));
	float blocks = rect(p, vec2(0.13, 0.42), vec2(0.27, 0.59))
		+ rect(p, vec2(0.29, 0.35), vec2(0.41, 0.59)) + rect(p, vec2(0.43, 0.46), vec2(0.57, 0.59));
	float grain = hash(floor(p * 170.0));
	color = mix(color, paper * (0.71 - 0.26 * blocks + 0.12 * grain), photo);
	float rows = step(0.72, fract(p.y * 39.0));
	float uneven = step(0.14, hash(vec2(floor(p.x * 67.0), floor(p.y * 39.0))));
	float print_area = rect(p, vec2(0.09, 0.62), vec2(0.57, 0.91))
		+ rect(p, vec2(0.62, 0.31), vec2(0.90, 0.91));
	return mix(color, ink, rows * uneven * print_area * 0.78);
}

void fragment() {
	vec2 p = UV;
	vec3 ink = stock.rgb * vec3(0.47, 0.55, 0.56);
	vec3 highlight = stock.rgb * vec3(0.94, 0.66, 0.39);
	vec3 color = stock.rgb * (0.97 + 0.035 * hash(floor(p * vec2(340.0, 440.0))));
	color = mix(color, ink * 0.79, rect(p, vec2(0.10, 0.10), vec2(0.55, 0.131)));
	color = mix(color, ink, rect(p, vec2(0.10, 0.161), vec2(0.36, 0.17)));
	color = mix(color, ink * 1.27, rect(p, vec2(0.10, 0.218), vec2(0.9, 0.23)));
	for (int i = 0; i < 13; i++) {
		float row = float(i);
		float y = 0.268 + row * 0.041;
		float end = 0.72 + hash(vec2(row, 1.0 + float(form))) * 0.16;
		float broken = step(0.17, hash(vec2(floor(p.x * 47.0), row)));
		if (form == 1) {
			float selected = rect(p, vec2(0.09, y - 0.006), vec2(0.88, y + 0.02));
			if (i == 3 || i == 8) { color = mix(color, highlight, selected * 0.55); }
			end = i % 4 == 1 ? 0.49 : 0.86;
		}
		color = mix(color, ink, rect(p, vec2(0.105, y), vec2(end, y + 0.009)) * broken * 0.72);
	}
	if (form == 1) {
		vec2 mark = p - vec2(0.75, 0.834);
		mark = mat2(vec2(0.94, 0.34), vec2(-0.34, 0.94)) * mark;
		float stamp = rect(mark, vec2(-0.13, -0.049), vec2(0.13, 0.049))
			- rect(mark, vec2(-0.122, -0.041), vec2(0.122, 0.041));
		stamp += rect(mark, vec2(-0.085, -0.009), vec2(0.082, 0.008));
		color = mix(color, stock.rgb * vec3(0.68, 0.31, 0.27), clamp(stamp, 0.0, 1.0) * 0.82);
	}
	ALBEDO = form == 2 ? newspaper(p, stock.rgb, ink) : color;
	ROUGHNESS = 0.89;
	SPECULAR = 0.13;
}
