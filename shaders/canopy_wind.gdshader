shader_type spatial;
render_mode cull_disabled,diffuse_burley;
uniform vec4 leaf_color:source_color=vec4(.3,.43,.23,1);
uniform vec2 wind_direction=vec2(.85,.52);
uniform float wind_strength=.08;
uniform float wind_clock=0.;
uniform float base_height=2.;
void vertex(){
 vec3 world=(MODEL_MATRIX*vec4(VERTEX,1.)).xyz;
 float anchor=smoothstep(base_height,base_height+7.,VERTEX.y);
 float gust=.3+.7*smoothstep(-.65,.85,sin(dot(world.xz,normalize(wind_direction))*.38-wind_clock*1.5));
 vec2 offset=normalize(wind_direction)*wind_strength*gust*anchor*.65;
 VERTEX+=transpose(mat3(MODEL_MATRIX))*vec3(offset.x,0.,offset.y)/dot(MODEL_MATRIX[0].xyz,MODEL_MATRIX[0].xyz);
}
void fragment(){ALBEDO=leaf_color.rgb;ROUGHNESS=.95;SPECULAR=.1;}
