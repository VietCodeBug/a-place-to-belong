shader_type spatial;
render_mode diffuse_burley,depth_prepass_alpha;
#include "res://shaders/forest_floor_common.gdshaderinc"
uniform vec4 soil_dark:source_color=vec4(.48,.37,.27,1);
uniform vec4 soil_light:source_color=vec4(.63,.51,.37,1);
uniform vec4 soil_pebble:source_color=vec4(.56,.52,.44,1);
uniform vec4 puddle_tint:source_color=vec4(.36,.45,.50,1);
uniform float wetness=0.0;
uniform bool continuous_trail=false;
uniform float village_snow=0.0;
varying vec3 floor_position;
void vertex() { floor_position=(MODEL_MATRIX*vec4(VERTEX,1.0)).xyz; }
void fragment() {
 vec2 p=floor_position.xz;
 float patches=ground_field(p*.55+ground_noise(p*.16));
 float fine=ground_noise(p*4.4);
 vec3 base=mix(soil_dark.rgb,soil_light.rgb,smoothstep(.24,.78,patches));
 float center_wear=exp(-pow(abs(UV.x)/max(UV.y*.78,.25),2.0));
 float tracks=exp(-pow((abs(UV.x)-UV.y*.42)/.29,2.0));
 base=mix(base,soil_light.rgb*1.05,tracks*.22+center_wear*.10);
 // Subtle low-poly mineral grain along edges without noisy photoreal textures
 float grit=smoothstep(.74,.90,fine)*(0.35+0.65*smoothstep(.25,.9,abs(UV.x)/max(UV.y,.3)));
 base=mix(base,soil_pebble.rgb,grit*.24);
 float edge=abs(UV.x)-UV.y;
 float ragged=(ground_noise(p*2.6)-.5)*.30+(ground_noise(p*.75)-.5)*.28;
 float verge_darken=smoothstep(-.35,.22,edge);
 base*=mix(1.0,.86,verge_darken*.55);
 // Rainwater puddles collect naturally in wheel ruts & shallow hollows
 float hollow=ground_field(p*.48+vec2(3.7,9.1));
 float puddle_mask=smoothstep(.46,.72,hollow*0.82+tracks*0.18)*(1.0-verge_darken*.85)*smoothstep(.12,.62,wetness);
 vec3 wet_soil=base*mix(1.0,.68,wetness);
 vec3 soil=mix(wet_soil,mix(wet_soil*.78,puddle_tint.rgb,.46),puddle_mask);
 float bank=smoothstep(.15,1.0,abs(UV.x)/max(UV.y,.3));
 float snow=village_snow*smoothstep(93.0,106.0,p.y)*smoothstep(.32,.68,patches*.58+bank*.6);
 ALBEDO=mix(soil,vec3(.69,.77,.82),snow);
 ROUGHNESS=mix(mix(.98,.52,wetness),.09,puddle_mask);
 SPECULAR=mix(mix(.08,.26,wetness),.62,puddle_mask);
 float porch_fade=smoothstep(4.22,4.75,p.y);
 ALPHA=(1.0-smoothstep(-.20+ragged,.56+ragged,edge))*(continuous_trail ? 1.0 : (1.0-smoothstep(22.9,24.2,p.y))*porch_fade);
}
