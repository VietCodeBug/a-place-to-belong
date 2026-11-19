shader_type spatial;
render_mode cull_disabled,diffuse_burley;
uniform vec4 root_color:source_color=vec4(.40,.51,.25,1);
uniform vec4 tip_color:source_color=vec4(.69,.76,.39,1);
uniform vec2 wind_direction=vec2(.85,.52);
uniform float wind_clock=0.;
uniform float wind_speed=1.3;
uniform float wind_strength=.065;
uniform float wetness=0.;
uniform float lod_begin=24.;
uniform float lod_end=34.;
uniform int lod_level=0;
uniform bool flower=false;
varying float t;
varying float seed;
varying float range;
varying vec2 position_world;
void vertex(){
 t=COLOR.r;seed=INSTANCE_CUSTOM.a;
 vec3 root=MODEL_MATRIX[3].xyz;
 position_world=root.xz;
 range=distance(root,CAMERA_POSITION_WORLD);
 float fade=smoothstep(lod_begin,lod_end,range);
 bool hidden=(lod_level==0 && seed<fade)||(lod_level==1 && seed>=fade);
 vec2 dir=normalize(wind_direction);
 float gust=.45+.55*sin(dot(root.xz,dir)*.40-wind_clock*wind_speed);
 float flutter=sin(wind_clock*2.1+seed*17.)*.10;
 vec3 bend=vec3(dir.x,0.,dir.y)*wind_strength*(.3+.7*gust+flutter)*t*t;
 VERTEX+=transpose(mat3(MODEL_MATRIX))*bend/dot(MODEL_MATRIX[0].xyz,MODEL_MATRIX[0].xyz);
 // Reject whole clumps before rasterization; fragment discard alone still rasterizes dense hidden geometry.
 POSITION=hidden?vec4(2.,2.,2.,1.):PROJECTION_MATRIX*MODELVIEW_MATRIX*vec4(VERTEX,1.);
}
void fragment(){
 float fade=smoothstep(lod_begin,lod_end,range);
 if(lod_level==0 && seed<fade)discard;
 if(lod_level==1 && seed>=fade)discard;
 // Low contrast roots and upward-biased normals keep the carpet soft rather than black/hatchy.
 vec3 color=mix(root_color.rgb,tip_color.rgb,smoothstep(0.,1.,t));
 float broad=sin(position_world.x*.19+sin(position_world.y*.15))*sin(position_world.y*.13);
 color*=1.+broad*.045;
 ALBEDO=color*mix(1.,.82,wetness);
 NORMAL=normalize(mix(NORMAL,normalize((VIEW_MATRIX*vec4(0,1,0,0)).xyz),flower?.35:.85));
 ROUGHNESS=.95;SPECULAR=.10;
}
