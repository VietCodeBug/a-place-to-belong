shader_type spatial;
render_mode diffuse_burley,depth_prepass_alpha;
#include "res://shaders/forest_floor_common.gdshaderinc"
uniform vec4 soil_dark:source_color=vec4(.54,.43,.31,1);
uniform vec4 soil_light:source_color=vec4(.66,.55,.41,1);
uniform vec4 soil_pebble:source_color=vec4(.56,.52,.44,1);
uniform vec4 puddle_tint:source_color=vec4(.36,.45,.50,1);
uniform float wetness=0.0;
uniform bool continuous_trail=false;
uniform vec4 potholes[5];
uniform float village_snow=0.0;
varying vec3 floor_position;
void vertex() { floor_position=(MODEL_MATRIX*vec4(VERTEX,1.0)).xyz; }
void fragment() {
 vec2 p=floor_position.xz;
 float patches=ground_field(p*.38+ground_noise(p*.16));
 float fine=ground_noise(p*2.7);
 vec3 base=mix(soil_dark.rgb,soil_light.rgb,smoothstep(.24,.78,patches));
 float center_wear=exp(-pow(abs(UV.x)/max(UV.y*.78,.25),2.0));
 float sway = .11*sin(p.y*.47)+.07*cos(p.y*.87);
 float tracks=exp(-pow((abs(UV.x+sway)-UV.y*.43)/.22,2.0));
 float pothole = 0.0;
 float broken_rim = 0.0;
 if (continuous_trail) {
  for (int i=0; i<5; i++) {
   vec4 spot=potholes[i];
   vec2 delta=(p-spot.xy)/max(spot.zw,vec2(.1));
   float r=length(delta)+(fine-.5)*.24;
   float active_hollow=step(.1,spot.z);
   pothole=max(pothole,(1.0-smoothstep(.52,1.0,r))*active_hollow);
   broken_rim=max(broken_rim,(smoothstep(.55,.78,r)-smoothstep(.88,1.15,r))*active_hollow);
  }
 }
 base=mix(base,soil_light.rgb*1.05,tracks*.09+center_wear*.08);
 base*=1.0-tracks*.035;
 // Subtle low-poly mineral grain along edges without noisy photoreal textures
 float grit=smoothstep(.74,.90,fine)*(0.35+0.65*smoothstep(.25,.9,abs(UV.x)/max(UV.y,.3)));
 base=mix(base,soil_pebble.rgb,grit*.20+broken_rim*.10);
 base=mix(base,base*vec3(.65,.66,.66),pothole*(.27+wetness*.30));
 float edge=abs(UV.x)-UV.y;
 float ragged=(ground_noise(p*2.6)-.5)*.30+(ground_noise(p*.75)-.5)*.28;
 float verge_darken=smoothstep(-.35,.22,edge);
 base*=mix(1.0,.86,verge_darken*.55);
 float village_grade=smoothstep(94.0,107.0,p.y)*(1.0-smoothstep(162.0,183.0,p.y));
 float gutter=exp(-pow((abs(UV.x)-UV.y+.24)/.20,2.0));
 base=mix(base,base*vec3(.78,.79,.79),(gutter*.22 + grit*.07)*village_grade);
 base*=mix(1.0,.97+fine*.045,village_grade);
 // Rainwater puddles collect naturally in wheel ruts & shallow hollows
 float hollow=ground_field(p*.48+vec2(3.7,9.1));
 float puddle_mask=smoothstep(.46,.72,hollow*0.82+tracks*0.18)*(1.0-verge_darken*.85)*smoothstep(.12,.62,wetness);
 puddle_mask=max(puddle_mask,smoothstep(.46,.84,pothole)*smoothstep(.23,.64,wetness)*.94);
 vec3 wet_soil=base*mix(1.0,.81,wetness);
 vec3 soil=mix(wet_soil,mix(wet_soil*.78,puddle_tint.rgb,.46),puddle_mask);
 float bank=smoothstep(.15,1.0,abs(UV.x)/max(UV.y,.3));
 float snow=village_snow*smoothstep(.32,.68,patches*.58+bank*.6);
 ALBEDO=mix(soil,vec3(.69,.77,.82),snow);
 ROUGHNESS=mix(mix(.98,.52,wetness),.09,puddle_mask);
 SPECULAR=mix(mix(.08,.26,wetness),.62,puddle_mask);
 float porch_fade=smoothstep(4.22,4.75,p.y);
 ALPHA=(1.0-smoothstep(-.20+ragged,.56+ragged,edge))*(continuous_trail ? 1.0 : (1.0-smoothstep(22.9,24.2,p.y))*porch_fade);
}
