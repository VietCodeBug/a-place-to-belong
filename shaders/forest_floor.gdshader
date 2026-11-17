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
 float root=max(grove(p,vec2(-14,-7),1.7),grove(p,vec2(-17,10),1.5));
 root=max(root,grove(p,vec2(-12,4),1.0));root=max(root,grove(p,vec2(20,-4),1.5));root=max(root,grove(p,vec2(12,-16),1.7));
 float damp_hollow=smoothstep(.58,.84,ground_field(p*.34+4.1))*wetness;
 ALBEDO=color*(1.0-root*.16)*mix(1.0,.72,wetness)*mix(1.0,.86,damp_hollow);
 ROUGHNESS=mix(.98,.46,wetness*(.65+.35*damp_hollow));
 SPECULAR=mix(.10,.28,wetness);
 AO=1.0-root*.2;AO_LIGHT_AFFECT=.15;
}
