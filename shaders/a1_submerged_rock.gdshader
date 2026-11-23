shader_type spatial;
render_mode cull_disabled;
#include "res://shaders/a1_lake_caustics.gdshaderinc"
#include "res://shaders/forest_floor_common.gdshaderinc"
varying vec3 world;
varying float face;
void vertex() {
	world = (MODEL_MATRIX*vec4(VERTEX,1.0)).xyz;
	face = (MODEL_NORMAL_MATRIX*NORMAL).y;
}
void fragment() {
	float mineral = ground_noise(world.xz*.86+world.y*.26);
	float shelves = smoothstep(.04,.15,abs(fract(world.y*1.19 + world.x*.095 + world.z*.1 + mineral*.24)-.41));
	float moss = smoothstep(.44,.68,ground_noise(world.xz*.53 + world.y*.59)) * (.45+.55*abs(face));
	vec3 rock = mix(vec3(.105,.16,.157),vec3(.22,.28,.24),mineral) * (.73+.27*shelves);
	float light = lake_caustic(world.xz,TIME)*.030*max(0.0,face);
	ALBEDO = mix(rock,vec3(.14,.248,.13),moss*.69) + vec3(.53,.875,.68)*light;
	ROUGHNESS = .91;
}
