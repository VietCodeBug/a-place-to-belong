shader_type spatial;
render_mode cull_disabled;

uniform vec4 glazed_color : source_color = vec4(0.77, 0.78, 0.71, 1.0);
uniform vec4 rim_color : source_color = vec4(0.31, 0.46, 0.42, 1.0);
uniform float radius = 1.0;
uniform float painted_rim = 0.0;
uniform float wear : hint_range(0.0, 1.0) = 0.0;
uniform float fixture = 0.0;
varying vec3 local_point;

void vertex() {
	local_point = VERTEX;
}

float grain(vec2 position) {
	return fract(sin(dot(position, vec2(112.1, 71.7))) * 43758.5453);
}

float patch(vec2 position) {
	vec2 cell = floor(position);
	vec2 uv = fract(position);
	uv = uv * uv * (3.0 - 2.0 * uv);
	return mix(mix(grain(cell), grain(cell + vec2(1.0, 0.0)), uv.x),
		mix(grain(cell + vec2(0.0, 1.0)), grain(cell + vec2(1.0, 1.0)), uv.x), uv.y);
}

void fragment() {
	vec2 p = local_point.xz / radius;
	float radial = length(p);
	float flecks = patch(p * 14.0) * 0.38 + patch(p * 5.0) * 0.62;
	float inner = 1.0 - smoothstep(0.25, 0.94, radial);
	float lower = 1.0 - smoothstep(0.022, 0.086, local_point.y);
	float runoff = mix(0.90, 0.45 + inner * 0.41 + lower * 0.14, fixture);
	float deposits = smoothstep(0.41, 0.81, flecks + 0.13 * inner) * wear * runoff;
	float residue = (1.0 - smoothstep(0.009, 0.031, abs(radial - (0.63 + 0.12 * (flecks - 0.5)))))
		* smoothstep(0.26, 0.68, flecks) * wear;
	float band = smoothstep(0.81, 0.83, radial) * (1.0 - smoothstep(0.88, 0.90, radial));
	float fine_band = smoothstep(0.92, 0.928, radial) * (1.0 - smoothstep(0.944, 0.953, radial));
	vec3 clean = mix(glazed_color.rgb, rim_color.rgb, max(band, fine_band * 0.83) * painted_rim);
	vec3 stain = mix(glazed_color.rgb * vec3(0.30, 0.27, 0.18),
		glazed_color.rgb * vec3(0.59, 0.51, 0.34), flecks);
	ALBEDO = mix(clean, stain, min(0.81, deposits * 0.87 + residue * 0.46));
	ROUGHNESS = mix(0.34, 0.82, max(deposits, residue));
	SPECULAR = 0.31;
}
