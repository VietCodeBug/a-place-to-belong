"""Original modular forest-floor meshes; metric, no external images or models."""
import bpy,math,random,json,hashlib
from pathlib import Path
ROOT=Path(__file__).resolve().parents[2]
bpy.ops.wm.read_factory_settings(use_empty=True)
report=[]
def mesh(name,verts,faces,colors):
 data=bpy.data.meshes.new(name);data.from_pydata(verts,[],faces);data.update()
 obj=bpy.data.objects.new(name,data);bpy.context.collection.objects.link(obj)
 attr=data.color_attributes.new(name='RootToTip',type='FLOAT_COLOR',domain='POINT')
 for i,color in enumerate(colors):attr.data[i].color=color
 mat=bpy.data.materials.get('ForestFloorBase')
 if not mat:
  mat=bpy.data.materials.new('ForestFloorBase');mat.diffuse_color=(.25,.35,.12,1);mat.use_nodes=True;mat.use_backface_culling=False
 data.materials.append(mat)
 bpy.ops.object.select_all(action='DESELECT');obj.select_set(True);bpy.context.view_layer.objects.active=obj
 bpy.ops.export_scene.gltf(filepath=str(ROOT/f'assets/vegetation/forest_floor/{name}.glb'),export_format='GLB',use_selection=True,export_yup=True,export_vertex_color='ACTIVE')
 report.append({'name':name,'triangles':sum(len(f)-2 for f in faces),'height':max(v[2]for v in verts)})
 return obj
for variant,(name,count,nominal)in enumerate([('short_blades',6,.18),('soft_fan',8,.28),('meadow_sweep',7,.42),('tall_sedge',9,.78)]):
 rng=random.Random(5700+variant);verts=[];faces=[];colors=[]
 for blade in range(count):
  angle=rng.random()*math.tau;h=nominal*rng.uniform(.6,1.15);w=rng.uniform(.008,.019)*(1 if variant<2 else 1.15)
  base=(rng.uniform(-.12,.12),rng.uniform(-.12,.12));lean=(math.cos(angle)*h*.45,math.sin(angle)*h*.45);side=(-math.sin(angle),math.cos(angle))
  start=len(verts)
  for t,width in [(0,1),(.52,.7)]:
   for sign in [-1,1]:
    verts.append((base[0]+lean[0]*t*t+side[0]*w*width*sign,base[1]+lean[1]*t*t+side[1]*w*width*sign,h*t));colors.append((t,t,t,1))
  verts.append((base[0]+lean[0],base[1]+lean[1],h));colors.append((1,1,1,1))
  faces += [(start,start+1,start+2),(start+1,start+3,start+2),(start+2,start+3,start+4)]
 mesh(name,verts,faces,colors)
# Fern fronds: paired tapered leaflets along five arched, radial stems.
verts=[];faces=[];colors=[]
for frond in range(5):
 a=frond*math.tau/5+.3;forward=(math.cos(a),math.sin(a));side=(-math.sin(a),math.cos(a))
 start=len(verts)
 for segment in range(9):
  t=segment/8
  for sign in [-1,1]:
   verts.append((forward[0]*.48*t+side[0]*.005*sign,forward[1]*.48*t+side[1]*.005*sign,.48*math.sin(t*1.9)))
   colors.append((t*.5+.3,)*3+(1,))
 for segment in range(8):
  k=start+segment*2;faces.extend([(k,k+1,k+2),(k+1,k+3,k+2)])
 for row in range(1,8):
  t=row/8;distance=.48*t;height=.48*math.sin(t*1.9);length=.15*(1-t*.75)
  for sign in [-1,1]:
   center=(forward[0]*distance,forward[1]*distance,height);idx=len(verts)
   points=[center,(center[0]+side[0]*sign*length*.6-forward[0]*.035,center[1]+side[1]*sign*length*.6-forward[1]*.035,height+.012),(center[0]+side[0]*sign*length+forward[0]*.04,center[1]+side[1]*sign*length+forward[1]*.04,height-.025),(center[0]+side[0]*sign*length*.55+forward[0]*.055,center[1]+side[1]*sign*length*.55+forward[1]*.055,height-.008)]
   verts.extend(points);colors.extend([(t*.5+.3,)*3+(1,)]*4);faces.extend([(idx,idx+1,idx+2),(idx,idx+2,idx+3)])
mesh('fern_rosette',verts,faces,colors)
# Oak-like fallen leaf, shallow midrib; instanced in small wind-gathered pockets.
mesh('fallen_leaf',[(0,0,.012),(-.045,-.045,.005),(-.055,.018,.004),(-.025,.065,.002),(0,.10,.004),(.025,.065,.002),(.055,.018,.004),(.045,-.045,.005)],[(0,i,1 if i==7 else i+1)for i in range(1,8)],[(.5,.5,.5,1)]*8)
mesh('twig', [(-.22,-.008,.004),(-.22,.008,.004),(.22,-.006,.014),(.22,.006,.014),(.04,-.002,.009),(.09,.09,.013),(.10,.09,.013)],[(0,1,2),(1,3,2),(4,5,6)],[(.3,.3,.3,1)]*7)
bpy.context.preferences.filepaths.save_version=0
bpy.ops.wm.save_as_mainfile(filepath=str(ROOT/'art_source/forest_floor/forest_floor.blend'))
(ROOT/'art_source/forest_floor/build_report.json').write_text(json.dumps(report,indent=2)+'\n')
