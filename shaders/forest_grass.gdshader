shader_type spatial;
render_mode cull_disabled,diffuse_burley;
#include "res://shaders/forest_floor_common.gdshaderinc"
uniform vec4 root_color:source_color=vec4(.33,.43,.28,1);
uniform vec4 tip_color:source_color=vec4(.48,.57,.35,1);
uniform float wind_strength=.018;
varying float blade_tip;
varying vec3 blade_world;
varying vec3 instance_tint;
void vertex() {
 blade_tip=COLOR.r;
 instance_tint=INSTANCE_CUSTOM.rgb;
 vec3 world=(MODEL_MATRIX*vec4(VERTEX,1)).xyz;
 VERTEX.x+=sin(TIME*.9+world.x*.8+world.z*.55)*wind_strength*blade_tip*blade_tip;
 blade_world=world;
}
void fragment() {
 float field=ground_field(blade_world.xz*.2);
 vec3 color=mix(root_color.rgb,tip_color.rgb,smoothstep(.0,.95,blade_tip)*.8);
 color*=mix(.88,1.10,field);
 NORMAL=normalize(mix(NORMAL,normalize((VIEW_MATRIX*vec4(0,1,0,0)).xyz),.45));
 ALBEDO=color*instance_tint;ROUGHNESS=1.0;SPECULAR=.12;
 // COLOR in this shader is instance tint; root-to-tip is passed separately.
}
