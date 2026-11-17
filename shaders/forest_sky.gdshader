shader_type sky;
uniform vec4 top_color:source_color=vec4(.32,.57,.79,1);
uniform vec4 horizon_color:source_color=vec4(.94,.79,.61,1);
uniform vec4 cloud_color:source_color=vec4(.98,.94,.85,1);
uniform vec3 sun_direction=vec3(.5,.3,.5);
uniform vec3 moon_direction=vec3(-.5,.3,-.5);
uniform float daylight=1.;
uniform float cloud_cover=.4;
uniform float cloud_clock=0.;
uniform vec2 wind_direction=vec2(.85,.52);
float hash(vec2 p){return fract(sin(dot(p,vec2(127.1,311.7)))*43758.5453);}
float noise2(vec2 p){vec2 i=floor(p),f=fract(p);f=f*f*(3.-2.*f);return mix(mix(hash(i),hash(i+vec2(1,0)),f.x),mix(hash(i+vec2(0,1)),hash(i+vec2(1,1)),f.x),f.y);}
float field(vec2 p){return noise2(p)*.64+noise2(p*2.1+3.)*.25+noise2(p*4.3+7.)*.11;}
void sky(){
 float height=clamp(EYEDIR.y,0.,1.);
 vec3 color=mix(horizon_color.rgb,top_color.rgb,pow(height,.46));
 if(!AT_CUBEMAP_PASS){
 vec2 p=EYEDIR.xz/max(.15,EYEDIR.y+.20)*2.4;
 vec2 travel=wind_direction*cloud_clock*.007;
 float shape=field(p-travel);
 float layer=field(p*.64+vec2(16.,8.)-travel*.64);
 float threshold=mix(.82,.20,cloud_cover);
 float cloud=smoothstep(threshold,threshold+.16,shape)*.8;
 cloud=max(cloud,smoothstep(threshold+.07,threshold+.23,layer)*.45);
 cloud*=smoothstep(-.01,.14,EYEDIR.y);
 vec3 cloud_shade=cloud_color.rgb*mix(.76,1.04,smoothstep(.35,.8,shape));
 color=mix(color,cloud_shade,cloud);
 float sun=dot(EYEDIR,normalize(sun_direction));
 color+=vec3(1.,.76,.42)*pow(max(sun,0.),96.)*.14*daylight*(1.-cloud);
 float disk=smoothstep(cos(.007),cos(.005),sun)*daylight*(1.-cloud*.95);
 color=mix(color,vec3(1.,.90,.69),disk);
 float moon=smoothstep(cos(.010),cos(.008),dot(EYEDIR,normalize(moon_direction)))*(1.-daylight)*(1.-cloud);
 color=mix(color,vec3(.76,.84,.92),moon*.85);
 }
 COLOR=color;
}
