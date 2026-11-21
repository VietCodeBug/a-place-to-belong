shader_type spatial;
#include "res://shaders/forest_floor_common.gdshaderinc"
uniform vec4 base_tint : source_color = vec4(.66,.62,.51,1.);
uniform float snow = 0.;
uniform float age = .56;
uniform float texture_scale = 3.;
varying vec3 world_position;
varying float topness;
varying float local_height;
void vertex() {
	world_position=(MODEL_MATRIX*vec4(VERTEX,1.)).xyz;
	local_height=VERTEX.y;
	topness=normalize(MODEL_NORMAL_MATRIX* NORMAL).y;
}
void fragment() {
	float lines=sin(world_position.x*texture_scale + sin(world_position.z*2.3))*sin(world_position.y*4.3+world_position.z*2.1);
	vec2 facade=vec2(world_position.x+world_position.z*.73,world_position.y);
	float cracks=ground_noise(facade*6.5);
	float rain_runs=smoothstep(.48,.78,ground_noise(facade*vec2(9.6,.83)));
	float stain=ground_noise(facade*vec2(1.71,.73));
	float wall=1.0-smoothstep(.26,.63,abs(topness));
	float damp=wall*(1.0-smoothstep(.13,1.32,local_height))*(.55+lines*.32);
	float weather=.96+lines*.035-wall*age*(.14*rain_runs+.09*stain+.035*cracks);
	vec3 aged=mix(base_tint.rgb*weather,base_tint.rgb*vec3(.77,.78,.67),damp*age*.70);
	ALBEDO=mix(aged,vec3(.68,.80,.91),snow*smoothstep(.39,.78,topness));
	ROUGHNESS=.92;
}
