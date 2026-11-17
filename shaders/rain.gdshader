shader_type spatial;
render_mode unshaded,cull_disabled,depth_draw_never;
uniform float rain_strength=0.0;
varying vec3 position_world;
void vertex(){
 // Camera-facing streaks, geometry rather than image textures.
 MODELVIEW_MATRIX=VIEW_MATRIX*mat4(INV_VIEW_MATRIX[0],INV_VIEW_MATRIX[1],INV_VIEW_MATRIX[2],MODEL_MATRIX[3]);
 position_world=(INV_VIEW_MATRIX*MODELVIEW_MATRIX*vec4(VERTEX,1.)).xyz;
}
void fragment(){
 if(position_world.y<.12)discard;
 if(abs(position_world.x)<8.4 && position_world.z> -12.4 && position_world.z<5.25 && position_world.y<8.)discard;
 ALBEDO=vec3(.64,.76,.82);ALPHA=.40*rain_strength;
}
