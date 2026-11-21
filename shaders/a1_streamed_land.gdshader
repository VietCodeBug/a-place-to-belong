shader_type spatial;
#include "res://shaders/a1_lake_caustics.gdshaderinc"
uniform vec2 lake_center;
uniform vec2 lake_radii;

uniform int season = 1;
uniform float wetness = 0.0;
varying vec3 world;

void vertex() {
	world = (MODEL_MATRIX * vec4(VERTEX, 1.0)).xyz;
}

void fragment() {
	vec3 albedo = COLOR.rgb;
	float sediment = smoothstep(.65, .95, sin(world.x * .32 + cos(world.z * .29)) *
		sin(world.z * .39 - world.x * .2));
	albedo *= 1.0 - .12 * sediment;
	if (world.y > 5.5) {
		if (season == 0) {
			albedo = mix(albedo, vec3(.44, .35, .19), .24);
		} else if (season == 3) {
			albedo = mix(albedo, vec3(.79, .87, .91), .78);
		}
	}
	float depth = 5.0 - world.y;
	float underwater = step(0.0,depth) * (1.0-step(1.0,length((world.xz-lake_center)/lake_radii)));
	float caustic = lake_caustic(world.xz,TIME) * underwater * (1.0-smoothstep(0.0,14.0,depth));
	ALBEDO = albedo * (1.0 - wetness * .22) + vec3(.20,.27,.18)*caustic*.50;
	ROUGHNESS = .91 - wetness * .35;
	SPECULAR = .13;
}
