"""Three small curved-blade tufts, authored in Blender; no external source assets."""
import bpy,random,math,json
from pathlib import Path
ROOT=Path(__file__).resolve().parents[2]
bpy.ops.wm.read_factory_settings(use_empty=True)
variants=[]
for variant in range(3):
 rng=random.Random(606+variant);verts=[];faces=[]
 for blade in range([7,9,6][variant]):
  a=rng.random()*math.tau;length=rng.uniform(.12,.24);w=rng.uniform(.018,.032)
  bx,by=rng.uniform(-.06,.06),rng.uniform(-.06,.06)
  side=(math.cos(a),math.sin(a));lean=(-math.sin(a)*length*.35,math.cos(a)*length*.35)
  start=len(verts)
  for t,width in [(0,1),(.48,.72),(.82,.35)]:
   for sign in [-1,1]:
    verts.append((bx+lean[0]*t*t+side[0]*w*width*sign,by+lean[1]*t*t+side[1]*w*width*sign,length*t))
  verts.append((bx+lean[0],by+lean[1],length))
  faces.extend([(start,start+1,start+2),(start+1,start+3,start+2),(start+2,start+3,start+4),(start+3,start+5,start+4),(start+4,start+5,start+6)])
 data=bpy.data.meshes.new(f'CurvedBlades{variant}');data.from_pydata(verts,[],faces);data.update()
 obj=bpy.data.objects.new(f'MeadowTuft{variant}',data);bpy.context.collection.objects.link(obj)
 mat=bpy.data.materials.new(['MeadowSage','MeadowOlive','MeadowStraw'][variant]);mat.use_nodes=True
 rgb=[(.13,.21,.095,1),(.18,.25,.12,1),(.28,.29,.14,1)][variant]
 mat.diffuse_color=rgb;bs=mat.node_tree.nodes.get('Principled BSDF');bs.inputs['Base Color'].default_value=rgb;bs.inputs['Roughness'].default_value=1
 mat.use_backface_culling=False;data.materials.append(mat)
 bpy.ops.object.select_all(action='DESELECT');obj.select_set(True);bpy.context.view_layer.objects.active=obj
 bpy.ops.export_scene.gltf(filepath=str(ROOT/f'assets/vegetation/meadow/tuft_{variant}.glb'),export_format='GLB',use_selection=True,export_yup=True)
 variants.append({'name':obj.name,'triangles':len(faces),'height_m':max(v[2]for v in verts)})
bpy.context.preferences.filepaths.save_version=0
bpy.ops.wm.save_as_mainfile(filepath=str(ROOT/'art_source/meadow_v06/meadow_tufts.blend'))
(ROOT/'art_source/meadow_v06/build_report.json').write_text(json.dumps(variants,indent=2)+'\n')
