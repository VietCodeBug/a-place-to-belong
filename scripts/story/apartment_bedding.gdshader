shader_type spatial;

uniform vec4 cloth : source_color = vec4(0.34, 0.45, 0.39, 1.0);
uniform float wear : hint_range(0.0, 1.0) = 0.0;
uniform float stitched = 1.0;
varying vec3 fabric_point;

void vertex() {
	fabric_point = VERTEX;
}

void fragment() {
	vec2 uv = UV;
	vec2 edge = min(uv, 1.0 - uv);
	float binding = 1.0 - smoothstep(0.014, 0.030, min(edge.x, edge.y));
	float line = (1.0 - smoothstep(0.001, 0.005, abs(edge.x - 0.061))) * stitched;
	float rows = (1.0 - smoothstep(0.012, 0.044, abs(fract(uv.y * 5.0) - 0.5))) * stitched;
	float material_grain = sin(fabric_point.x * 292.0) * sin(fabric_point.z * 278.0);
	float dry_grain = (1.0 - min(1.0, length(fwidth(fabric_point.xz * 69.0)))) * material_grain * 0.035;
	float crease_tone = 0.98 + sin(uv.x * 14.0 + sin(uv.y * 9.1)) * 0.028 + dry_grain;
	vec2 stain_shape = (uv - vec2(0.72, 0.67)) * vec2(1.26, 0.98);
	float mark = 1.0 - smoothstep(0.063, 0.24, length(stain_shape) + 0.026 * sin(uv.x * 41.0) * cos(uv.y * 27.0));
	float worn_hem = (1.0 - smoothstep(0.020, 0.10, edge.y)) * (0.5 + 0.5 * sin(uv.x * 22.0));
	vec3 tint = cloth.rgb * crease_tone;
	tint *= 1.0 - binding * 0.21 - (line + rows) * 0.13;
	ALBEDO = mix(tint, tint * vec3(0.54, 0.60, 0.49), wear * (mark * 0.53 + worn_hem * 0.40));
	ROUGHNESS = 0.95;
	SPECULAR = 0.17;
}
