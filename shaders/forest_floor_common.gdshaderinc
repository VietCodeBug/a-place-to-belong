float hash_ground(vec2 p) { return fract(sin(dot(p,vec2(127.1,311.7)))*43758.5453); }
float ground_noise(vec2 p) {
 vec2 i=floor(p),f=fract(p);f=f*f*(3.0-2.0*f);
 return mix(mix(hash_ground(i),hash_ground(i+vec2(1,0)),f.x),mix(hash_ground(i+vec2(0,1)),hash_ground(i+vec2(1,1)),f.x),f.y);
}
float ground_field(vec2 p) { return ground_noise(p)*0.65+ground_noise(p*2.13+7.3)*0.35; }
float grove(vec2 p,vec2 center,float radius) { return 1.0-smoothstep(radius*0.35,radius,length(p-center)); }
float forest_weight(vec2 p) {
 float f=max(grove(p,vec2(-14,-7),8.0),grove(p,vec2(-12,4),4.0));
 f=max(f,grove(p,vec2(-12,-19),9.0)); f=max(f,grove(p,vec2(12,-16),9.0));
 f=max(f,grove(p,vec2(20,-4),8.0)); f=max(f,grove(p,vec2(-17,10),7.0));
 f=max(f,grove(p,vec2(-20,17),7.0)); f=max(f,grove(p,vec2(19,-19),8.0));
 return max(f,grove(p,vec2(3,-24),8.0));
}
float path_center_visual(float z) { float t=clamp((z-2.4)/21.6,0.0,1.0);return sin(t*4.71238898)*2.6-t*3.0; }
float path_width_visual(float z) { return mix(.95,2.7,clamp((z-2.4)/21.6,0.0,1.0)); }
