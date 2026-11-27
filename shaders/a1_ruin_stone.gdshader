shader_type spatial;
render_mode cull_disabled;

#include "res://shaders/a1_lake_caustics.gdshaderinc"
#include "res://shaders/forest_floor_common.gdshaderinc"

varying vec3 world_pos;
varying float up;

void vertex() {
	world_pos = (MODEL_MATRIX * vec4(VERTEX, 1.0)).xyz;
	up = (MODEL_NORMAL_MATRIX * NORMAL).y;
}

void fragment() {
	float fine = ground_noise(world_pos.xz * 3.3 + world_pos.y * 4.7);
	float age = ground_noise(world_pos.xz * .66 + world_pos.y * .49);
	float algae = smoothstep(.51,.78,age) * (1.0 - smoothstep(-1.7,2.8,world_pos.y));
	vec3 limestone = COLOR.rgb * (.81 + .25 * fine);
	ALBEDO = mix(limestone, limestone * vec3(.62,.88,.70), algae * .75);
	float light = lake_caustic(world_pos.xz + world_pos.y * vec2(.36,.22),TIME);
	EMISSION = vec3(.093,.175,.197) * light * (.39+.61*abs(up)) * (1.0-smoothstep(1.0,17.0,5.0-world_pos.y));
	ROUGHNESS = .86;
	SPECULAR = .25;
}
