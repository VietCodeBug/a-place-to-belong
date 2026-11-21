shader_type spatial;
#include "res://shaders/a1_lake_caustics.gdshaderinc"
#include "res://shaders/forest_floor_common.gdshaderinc"
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
	float grain = ground_noise(world.xz * 2.8);
	float strokes = ground_noise(world.xz * .27 + world.y*.12);
	float moss = smoothstep(.44,.69,strokes);
	float gradient = normalize((INV_VIEW_MATRIX*vec4(NORMAL,0.0)).xyz).y;
	float steep = 1.0-smoothstep(.21,.69,gradient);
	float seams = 1.0-smoothstep(.03,.12,abs(fract(world.y*.37 + world.x*.075 - world.z*.039 + strokes*.28)-.39));
	float sand = 1.0-smoothstep(2.3,5.7,abs(world.y-5.0));
	albedo *= .67+.21*grain+.32*strokes;
	albedo = mix(albedo, mix(vec3(.14,.142,.131),vec3(.276,.251,.212),strokes)*(1.0-seams*.18),steep*.7*(1.0-sand));
	if (world.y > 5.5) {
		if (season == 0) {
			albedo = mix(albedo, vec3(.30,.23,.095), .23);
		} else if (season == 3) {
			albedo = mix(albedo, vec3(.68,.78,.84), .75*(1.0-steep*.57)*(.65+moss*.35));
		}
	}
	float depth = 5.0 - world.y;
	float caustic = 0.0;
	if (depth > 0.0 && depth < 15.0 && length((world.xz-lake_center)/lake_radii)<1.09) {
		caustic = lake_caustic(world.xz,TIME) * (1.0-smoothstep(1.0,12.0,depth));
		albedo *= mix(vec3(.99,.98,.88),vec3(.46,.73,.72),smoothstep(2.0,23.0,depth));
	}
	ALBEDO = albedo * (1.0 - wetness * .22) + vec3(.092,.135,.092)*caustic;
	ROUGHNESS = .94 - wetness * .30;
	SPECULAR = .13;
}
