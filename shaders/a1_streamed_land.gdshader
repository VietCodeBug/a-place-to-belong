shader_type spatial;
#include "res://shaders/a1_lake_caustics.gdshaderinc"
#include "res://shaders/forest_floor_common.gdshaderinc"
uniform vec2 lake_center;
uniform vec2 lake_radii;

uniform int season = 1;
uniform float wetness = 0.0;
uniform bool coarse_land = false;
varying vec3 world;

void vertex() {
	world = (MODEL_MATRIX * vec4(VERTEX, 1.0)).xyz;
}

vec3 season_tint(vec3 albedo, float steep, float moss, float height) {
	if (height > 5.5) {
		if (season == 0) {
			return mix(albedo, vec3(.30,.23,.095), .23);
		} else if (season == 3) {
			return mix(albedo, vec3(.68,.78,.84), .75*(1.0-steep*.57)*(.65+moss*.35));
		}
	}
	return albedo;
}

vec3 detail_ground(vec3 albedo, vec3 ground_position, float steep) {
	float grain = ground_noise(ground_position.xz * 2.8);
	float strokes = ground_noise(ground_position.xz * .27 + ground_position.y*.12);
	float moss = smoothstep(.44,.69,strokes);
	float seams = 1.0-smoothstep(.03,.12,abs(fract(ground_position.y*.37 + ground_position.x*.075 - ground_position.z*.039 + strokes*.28)-.39));
	float sand = 1.0-smoothstep(2.3,5.7,abs(ground_position.y-5.0));
	albedo *= .67+.21*grain+.32*strokes;
	albedo = mix(albedo, mix(vec3(.14,.142,.131),vec3(.276,.251,.212),strokes)*(1.0-seams*.18),steep*.7*(1.0-sand));
	albedo = season_tint(albedo,steep,moss,ground_position.y);
	float depth = 5.0 - ground_position.y;
	float caustic = 0.0;
	if (depth > 0.0 && depth < 15.0 && length((ground_position.xz-lake_center)/lake_radii)<1.09) {
		caustic = lake_caustic(ground_position.xz,TIME) * (1.0-smoothstep(.7,9.0,depth));
		albedo *= mix(vec3(.99,.98,.88),vec3(.46,.73,.72),smoothstep(2.0,23.0,depth));
	}
	return albedo * (1.0 - wetness * .22) + vec3(.029,.047,.039)*caustic;
}

void fragment() {
	float gradient = normalize((INV_VIEW_MATRIX*vec4(NORMAL,0.0)).xyz).y;
	float steep = 1.0-smoothstep(.21,.69,gradient);
	if (coarse_land) {
		vec3 base = mix(COLOR.rgb*.92,vec3(.214,.198,.171),steep*.52);
		ALBEDO = season_tint(base,steep,.48,world.y)*(1.0-wetness*.22);
	} else {
		ALBEDO = detail_ground(COLOR.rgb,world,steep);
	}
	ROUGHNESS = .94 - wetness * .30;
	SPECULAR = .13;
}
