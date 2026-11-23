shader_type spatial;
render_mode diffuse_burley;
#include "res://shaders/forest_floor_common.gdshaderinc"
uniform vec4 root_color:source_color=vec4(.32,.43,.26,1);
uniform vec4 tip_color:source_color=vec4(.55,.63,.38,1);
uniform vec2 wind_direction=vec2(.85,.52);
uniform float wind_strength=.08;
uniform float wind_clock=0.0;
uniform float wetness=0.0;
uniform float lod_start=30.0;
uniform float lod_end=40.0;
uniform int lod_level=-1;
varying float blade_tip;
varying float root_distance;
varying vec3 grass_position;
varying float seed;
void vertex(){
 blade_tip=COLOR.r;
 vec3 world=(MODEL_MATRIX*vec4(VERTEX,1.0)).xyz;
 vec3 root=MODEL_MATRIX[3].xyz;
 grass_position=world;seed=INSTANCE_CUSTOM.a;
 root_distance=distance(root,CAMERA_POSITION_WORLD);
 vec2 direction=normalize(wind_direction);
 float wave=sin(dot(root.xz,direction)*.38-wind_clock*1.5);
 float gust=smoothstep(-.65,.85,wave);
 float flutter=sin(wind_clock*3.1+seed*19.0+dot(world.xz,vec2(1.7,.6)))*.12;
 vec2 bend=direction*wind_strength*(.24+.9*gust+flutter)*blade_tip*blade_tip;
 vec3 displacement=vec3(bend.x,-length(bend)*.10,bend.y);
 // Instances have orthogonal uniform-scale bases: transpose / scale² avoids a per-vertex 4x4 inverse.
 VERTEX+=transpose(mat3(MODEL_MATRIX))*displacement/dot(MODEL_MATRIX[0].xyz,MODEL_MATRIX[0].xyz);
}
void fragment(){
 float fade=smoothstep(lod_start,lod_end,root_distance);
 if(lod_level==0 && seed<fade)discard;
 if(lod_level==1 && seed>=fade)discard;
 float field=ground_field(grass_position.xz*.19);
 vec3 tip=mix(tip_color.rgb,vec3(.43,.52,.37),smoothstep(.35,.8,field)*.35);
 vec3 color=mix(root_color.rgb,tip,smoothstep(0.,1.,blade_tip)*.85);
 color*=mix(.92,1.06,ground_field(grass_position.xz*.12));
 ALBEDO=color*mix(1.,.82,wetness);
 NORMAL=normalize(mix(NORMAL,normalize((VIEW_MATRIX*vec4(0,1,0,0)).xyz),.45));
 ROUGHNESS=mix(.92,.66,wetness);SPECULAR=.16;
}
