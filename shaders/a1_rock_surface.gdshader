shader_type spatial;
render_mode diffuse_burley;
#include "res://shaders/forest_floor_common.gdshaderinc"

uniform vec4 stone_tint : source_color = vec4(.36,.36,.33,1.);
varying vec3 stone_position;
varying float up_facing;

void vertex() {
	stone_position = (MODEL_MATRIX * vec4(VERTEX,1.)).xyz;
	up_facing = normalize(MODEL_NORMAL_MATRIX * NORMAL).y;
}

void fragment() {
	vec2 face = stone_position.xz + stone_position.y * vec2(.58,.74);
	float coarse = ground_noise(face * 3.7);
	float pores = ground_noise(face * 29.);
	float seam_axis = stone_position.y * 7.4 + dot(stone_position.xz,vec2(.63,-.52)) + coarse*1.03;
	float layers = 1.0-smoothstep(.02,.09,abs(fract(seam_axis)-.38));
	float lichen = smoothstep(.55,.81,coarse + pores*.16) * smoothstep(-.1,.76,up_facing);
	vec3 dry = stone_tint.rgb * (.78+.31*coarse+.14*pores-layers*.13);
	ALBEDO = mix(dry * .58,vec3(.20,.25,.10),lichen*.73);
	ROUGHNESS = .90;
	SPECULAR = .14;
}
