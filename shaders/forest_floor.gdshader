shader_type spatial;
render_mode diffuse_burley;
#include "res://shaders/forest_floor_common.gdshaderinc"
uniform vec4 meadow_dark:source_color=vec4(.40,.51,.25,1);
uniform vec4 meadow_light:source_color=vec4(.48,.58,.31,1);
uniform vec4 moss:source_color=vec4(.27,.36,.24,1);
uniform vec4 earth:source_color=vec4(.40,.29,.20,1);
uniform vec4 soil:source_color=vec4(.55,.42,.29,1);
uniform float wetness=0.0;
varying vec3 floor_position;
void vertex() { floor_position=(MODEL_MATRIX*vec4(VERTEX,1.0)).xyz; }
void fragment() {
 vec2 p=floor_position.xz;
 vec2 warp=vec2(ground_noise(p*.12),ground_noise(p*.12+19.0))*2.5;
 float large=ground_field((p+warp)*.18);
 float small=ground_field(p*1.3);
 float woods=forest_weight(p);
 vec3 lawn=mix(meadow_dark.rgb,meadow_light.rgb,smoothstep(.32,.69,large));
 vec3 woodland=mix(earth.rgb,moss.rgb,smoothstep(.37,.64,ground_field((p+warp)*.53)));
 vec3 color=mix(lawn,woodland,woods*.85);
 float exposed=smoothstep(.67,.87,ground_noise(p*.38+warp))*(.12+.6*woods);
 color=mix(color,earth.rgb,exposed);
 // Larger damp/needle pockets are color fields, not repeating texture tiles.
 color*=mix(.94,1.045,small);
 float margin=abs(p.x-path_center_visual(p.y))-path_width_visual(p.y);
 float shoulder=(1.0-smoothstep(-.1,1.5+ground_noise(p*.9)*.35,margin))*smoothstep(4.5,5.2,p.y)*(1.0-smoothstep(23.5,25.0,p.y));
 color=mix(color,soil.rgb,shoulder*.62);
 float root=max(grove(p,vec2(-14,-7),1.7),grove(p,vec2(-17,10),1.5));
 root=max(root,grove(p,vec2(-12,4),1.0));root=max(root,grove(p,vec2(20,-4),1.5));root=max(root,grove(p,vec2(12,-16),1.7));
 ALBEDO=color*(1.0-root*.16)*mix(1.0,.77,wetness);
 ROUGHNESS=mix(1.0,.63,wetness);SPECULAR=mix(.12,.22,wetness);
 AO=1.0-root*.2;AO_LIGHT_AFFECT=.15;
}
