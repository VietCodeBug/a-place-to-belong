shader_type spatial;
#include "res://shaders/forest_floor_common.gdshaderinc"
varying vec3 yard;
void vertex() {
	yard = (MODEL_MATRIX * vec4(VERTEX, 1.0)).xyz;
}
void fragment() {
	vec2 p = yard.xz;
	float mottling = ground_field(p * 0.57);
	float grain = ground_noise(p * 15.0);
	float path = abs(p.x + 0.49 - (p.y - 3.6) * 0.15) + mottling * 0.31;
	float wear = (1.0 - smoothstep(0.38, 1.22, path)) * smoothstep(2.9, 3.6, p.y);
	float skirt = 1.0 - smoothstep(0.0, 1.4, max(abs(p.x) - 3.4, abs(p.y)-2.8));
	vec3 leaf = mix(vec3(0.14,0.21,0.082),vec3(0.31,0.37,0.145),mottling);
	vec3 earth = mix(vec3(0.23,0.166,0.101),vec3(0.347,0.269,0.172),mottling);
	ALBEDO = mix(leaf,earth,max(wear,skirt * 0.58)) * (0.92 + grain * 0.14);
	ROUGHNESS=0.96;
}
