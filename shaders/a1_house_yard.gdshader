shader_type spatial;
#include "res://shaders/forest_floor_common.gdshaderinc"
uniform vec4 rock_footprints[8];
varying vec3 yard;
varying float rock_contact;
void vertex() {
	yard = (MODEL_MATRIX * vec4(VERTEX, 1.0)).xyz;
	rock_contact = 0.0;
	for (int i=0;i<8;i++) {
		vec4 rock = rock_footprints[i];
		vec2 r = (yard.xz-rock.xy)/max(rock.zw, vec2(.01));
		rock_contact = max(rock_contact,1.0-smoothstep(.52,1.65,length(r)));
	}
}
void fragment() {
	vec2 p = yard.xz;
	float broad = ground_noise(p * 0.17);
	float fine = ground_noise(p * 4.7);
	float trail_x = -.49 + (p.y - 3.6)*.145 + smoothstep(9.,20.,p.y)*2.*sin((p.y-9.)*.27);
	float margin = abs(p.x-trail_x) + (ground_noise(p * 0.69)-0.5)*0.31;
	float wear = (1.0-smoothstep(.42,1.34,margin))*smoothstep(3.,3.72,p.y)* (1.0-smoothstep(21.0,29.0,p.y));
	float eaves = 1.0-smoothstep(.03,.81,max(abs(p.x+.31)-3.39,abs(p.y)-2.59));
	float foot = rock_contact * (.79 + fine * .21);
	vec3 green = mix(vec3(.147,.227,.081),vec3(.277,.328,.13),broad);
	vec3 earth = mix(vec3(.221,.151,.084),vec3(.336,.252,.146),broad);
	vec3 color = mix(green,earth,max(wear,max(eaves*.68,foot*.7)));
	ALBEDO = color*(.94+fine*.12)*(1.0-foot*.13);
	ROUGHNESS=.97;
}
