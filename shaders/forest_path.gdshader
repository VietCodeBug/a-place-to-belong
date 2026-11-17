shader_type spatial;
render_mode diffuse_burley,depth_prepass_alpha;
#include "res://shaders/forest_floor_common.gdshaderinc"
uniform vec4 soil_dark:source_color=vec4(.52,.41,.30,1);
uniform vec4 soil_light:source_color=vec4(.59,.47,.34,1);
uniform float wetness=0.0;
varying vec3 floor_position;
void vertex() { floor_position=(MODEL_MATRIX*vec4(VERTEX,1.0)).xyz; }
void fragment() {
 vec2 p=floor_position.xz;
 float patches=ground_field(p*.55+ground_noise(p*.16));
 vec3 base=mix(soil_dark.rgb,soil_light.rgb,smoothstep(.28,.78,patches));
 float tracks=exp(-pow((abs(UV.x)-UV.y*.42)/.33,2.0));
 base=mix(base,soil_light.rgb,tracks*.13);
 float edge=abs(UV.x)-UV.y;
 float ragged=(ground_noise(p*3.0)-.5)*.23+(ground_noise(p*.8)-.5)*.22;
 ALBEDO=base*mix(1.0,.74,wetness);ROUGHNESS=mix(1.0,.55,wetness);SPECULAR=mix(.1,.25,wetness);
 ALPHA=(1.0-smoothstep(-.13+ragged,.43+ragged,edge))*(1.0-smoothstep(23.0,24.3,p.y));
}
