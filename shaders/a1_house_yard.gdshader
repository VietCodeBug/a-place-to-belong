shader_type spatial;
#include "res://shaders/forest_floor_common.gdshaderinc"
varying vec3 yard;
void vertex() {
	yard = (MODEL_MATRIX * vec4(VERTEX, 1.0)).xyz;
}
void fragment() {
	vec2 p = yard.xz;
	float broad = ground_noise(p * 0.105);
	float grain = ground_noise(p * 7.0);
	float center = p.x + 0.49 - (p.y - 3.6) * 0.145;
	float margin = abs(center) + (ground_noise(p * 0.69)-0.5)*0.27;
	float wear = (1.0 - smoothstep(0.45,1.30,margin)) * smoothstep(3.0,3.72,p.y);
	float under_eaves = 1.0 - smoothstep(0.0,0.76,max(abs(p.x+0.22)-3.16,abs(p.y)-2.52));
	vec3 green = mix(vec3(0.248,0.306,0.128),vec3(0.301,0.363,0.164),broad);
	vec3 earth = mix(vec3(0.34,0.245,0.145),vec3(0.408,0.309,0.194),broad);
	ALBEDO = mix(green,earth,max(wear,under_eaves*0.52)) * (0.977 + grain * 0.046);
	ROUGHNESS = 0.96;
}
