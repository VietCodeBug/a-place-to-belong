shader_type spatial;
render_mode cull_front, unshaded;

#include "res://shaders/a1_lake_caustics.gdshaderinc"

varying vec3 world;
void vertex() {
	world = (MODEL_MATRIX * vec4(VERTEX, 1.0)).xyz;
}

void fragment() {
	vec3 eye_ray = normalize(world-CAMERA_POSITION_WORLD);
	float above = smoothstep(.03,.86,eye_ray.y);
	float reach = smoothstep(.78,1.0,UV.x);
	float depth = max(0.0,world.y-CAMERA_POSITION_WORLD.y);
	float glint = lake_caustic(world.xz*.68,TIME*.78);
	float broad = .5+.5*sin(world.x*.43+world.z*.34+TIME*.72);
	vec3 turquoise = mix(vec3(.037,.39,.60),vec3(.10,.74,.91),above);
	turquoise = mix(turquoise,vec3(.055,.52,.67),reach*.37);
	turquoise += vec3(.12,.29,.34)*glint*(.06+above*.28)*(.51+.49*broad);
	float attenuate = smoothstep(3.0,28.0,depth);
	ALBEDO = mix(turquoise,vec3(.025,.265,.441),.64*attenuate);
}
