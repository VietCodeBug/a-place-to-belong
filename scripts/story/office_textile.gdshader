shader_type spatial;

uniform vec4 cloth : source_color = vec4(0.26, 0.38, 0.39, 1.0);
varying vec3 world_point;

void vertex() {
	world_point = (MODEL_MATRIX * vec4(VERTEX, 1.0)).xyz;
}

void fragment() {
	vec2 textile = vec2(world_point.x + world_point.z, world_point.y + world_point.z);
	float weave = sin(textile.x * 481.0) * sin(textile.y * 422.0);
	float fade = 1.0 - clamp(length(fwidth(textile * 92.0)), 0.0, 1.0);
	float shade = sin(textile.x * 13.0 + sin(textile.y * 7.0)) * 0.025;
	ALBEDO = cloth.rgb * (0.97 + shade + weave * fade * 0.033);
	ROUGHNESS = 0.96;
	SPECULAR = 0.21;
}
