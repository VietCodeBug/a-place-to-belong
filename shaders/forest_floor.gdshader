shader_type spatial;
render_mode diffuse_burley;
#include "res://shaders/forest_floor_common.gdshaderinc"
uniform vec4 meadow_dark:source_color=vec4(.38,.50,.25,1);
uniform vec4 meadow_light:source_color=vec4(.50,.60,.32,1);
uniform vec4 moss:source_color=vec4(.25,.37,.24,1);
uniform vec4 earth:source_color=vec4(.41,.30,.20,1);
uniform vec4 soil:source_color=vec4(.56,.43,.30,1);
uniform vec4 foothill_sage:source_color=vec4(.33,.46,.37,1);
uniform float wetness=0.0;
uniform int a1_season = 0;
varying vec3 floor_position;
void vertex() { floor_position=(MODEL_MATRIX*vec4(VERTEX,1.0)).xyz; }
void fragment() {
 vec2 p=floor_position.xz;
 vec2 warp=vec2(ground_noise(p*.12),ground_noise(p*.12+19.0))*2.5;
 float large=ground_field((p+warp)*.18);
 float small=ground_field(p*1.3);
 float woods=forest_weight(p);
 vec3 lawn=mix(meadow_dark.rgb,meadow_light.rgb,smoothstep(.28,.72,large));
 vec3 woodland=mix(earth.rgb,moss.rgb,smoothstep(.34,.66,ground_field((p+warp)*.53)));
 vec3 color=mix(lawn,woodland,woods*.86);
 float exposed=smoothstep(.66,.86,ground_noise(p*.38+warp))*(.12+.6*woods);
 color=mix(color,earth.rgb,exposed);
 color*=mix(.93,1.055,small);
 float margin=abs(p.x-path_center_visual(p.y))-path_width_visual(p.y);
 float shoulder=(1.0-smoothstep(-.15,1.85+ground_noise(p*.85)*.45,margin))*smoothstep(4.0,5.1,p.y)*(1.0-smoothstep(23.2,24.8,p.y));
 color=mix(color,soil.rgb,shoulder*.68);
 // Cafe porch apron warmth so timber deck meets compacted earth naturally
 float porch_apron=(1.0-smoothstep(0.0,1.6,max(abs(p.x)-8.1,max(p.y-5.4,-12.5-p.y))));
 color=mix(color,soil.rgb*.92,porch_apron*.42);
 // Gentle atmospheric sage transition across outer foothills (>30m)
 float outer_blend=smoothstep(30.0,115.0,length(p));
 color=mix(color,mix(foothill_sage.rgb,moss.rgb,smoothstep(.3,.7,large)),outer_blend*.58);
 float valley=smoothstep(28.0,36.0,p.y);
 float painterly=ground_field(p*.53+warp*.65);
 float mineral=ground_field(p*3.0);
 vec3 upland=mix(vec3(.155,.216,.103),vec3(.273,.345,.155),smoothstep(.26,.75,large));
 upland=mix(upland,vec3(.195,.157,.10),smoothstep(.56,.76,painterly)*.61);
 float river=74.0+6.0*sin(p.x*.057)*smoothstep(3.0,16.0,abs(p.x));
 float shore=1.0-smoothstep(4.1,8.0,abs(p.y-river)+small*.65);
 vec3 silt=mix(vec3(.17,.16,.12),vec3(.29,.255,.19),painterly);
 color=mix(color,mix(upland,silt,shore*.95)*(0.87+0.23*mineral),valley);
 float street_x = 5.2 * smoothstep(84.0,111.0,p.y) + 1.45 * sin((p.y-112.0)*.112) * smoothstep(112.0,123.0,p.y);
 float street_bed = smoothstep(98.0,102.0,p.y) * (1.0-smoothstep(1.55,2.9,abs(p.x-street_x)+small*.26));
 color=mix(color,mix(vec3(.28,.219,.153),vec3(.35,.288,.207),mineral),street_bed*.95);
 if (a1_season == 1) {
   color=mix(color,vec3(.30,.43,.18),valley*(.22+.18*large)*(1.0-shore)*(1.0-street_bed));
 } else if (a1_season == 2) {
   color=mix(color,vec3(.30,.38,.13),valley*.30*(1.0-shore)*(1.0-street_bed));
 } else if (a1_season == 3) {
   float snow = smoothstep(.27,.64,painterly+small*.14)*(1.0-street_bed*.72)*(1.0-shore*.55);
   color=mix(color,mix(vec3(.51,.62,.68),vec3(.84,.89,.92),mineral),valley*snow*.94);
 }
 float root=max(grove(p,vec2(-14,-7),1.7),grove(p,vec2(-17,10),1.5));
 root=max(root,grove(p,vec2(-12,4),1.0));root=max(root,grove(p,vec2(20,-4),1.5));root=max(root,grove(p,vec2(12,-16),1.7));
 float damp_hollow=smoothstep(.58,.84,ground_field(p*.34+4.1))*wetness;
 ALBEDO=color*(1.0-root*.16)*mix(1.0,.72,wetness)*mix(1.0,.86,damp_hollow);
 ROUGHNESS=mix(.98,.46,wetness*(.65+.35*damp_hollow));
 SPECULAR=mix(.10,.28,wetness);
 AO=1.0-root*.2;AO_LIGHT_AFFECT=.15;
}
