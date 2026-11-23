"""Non-destructive, reproducible region palette for the user's single-material rig."""
import bpy,json,hashlib
from pathlib import Path
from mathutils import Vector
ROOT=Path(__file__).resolve().parents[2]
SOURCE=ROOT/'assets/characters/postal_worker/base.glb'
OUT=ROOT/'assets/characters/postal_worker/postal_worker_colored_v06.glb'
bpy.ops.wm.read_factory_settings(use_empty=True)
bpy.ops.import_scene.gltf(filepath=str(SOURCE))
# Blender's importer can create a joint-display Icosphere. Export the actual rig only.
mesh=next(o for o in bpy.data.objects if o.type=='MESH' and len(o.data.vertices)>1000)
arm=next(o for o in bpy.data.objects if o.type=='ARMATURE')
palette={'Skin':'D99B70','Hair':'493326','Jacket':'49776B','Shirt':'E8D9B5','Trousers':'425466','Boots':'69432E','Leather':'97633E','Brass':'C59B52','Sole':'352E29'}
def linear(c):return c/12.92 if c<=.04045 else ((c+.055)/1.055)**2.4
for name,hexcolor in palette.items():
 mat=bpy.data.materials.new(name);mat.use_nodes=True
 rgba=tuple(linear(int(hexcolor[i:i+2],16)/255)for i in [0,2,4])+(1,)
 mat.diffuse_color=rgba
 bsdf=mat.node_tree.nodes.get('Principled BSDF');bsdf.inputs['Base Color'].default_value=rgba
 bsdf.inputs['Roughness'].default_value=.83;bsdf.inputs['Metallic'].default_value=.35 if name=='Brass' else 0
 mesh.data.materials.append(mat)
# Keep geometry, skeleton, vertex groups, bind matrices and source pose untouched.
# Boundaries follow face centers in Blender source coordinates (Z up, front -Y).
slots={m.name:i for i,m in enumerate(mesh.data.materials)}
counts={name:0 for name in palette}
for face in mesh.data.polygons:
 x,y,z=sum((mesh.data.vertices[i].co for i in face.vertices),Vector())/len(face.vertices)
 ax=abs(x)
 if z<.045:role='Sole'
 elif z<.235:role='Boots'
 elif z<1.06 and ax<.30:role='Trousers'
 elif z<1.10 and ax<.25:role='Leather'
 elif ax>.405 and z<1.09:role='Skin'
 elif ax>.34 and z<1.12:role='Leather'
 elif z<1.455:
  role='Jacket'
  if y<-.09 and ax<.064 and z>1.12:role='Shirt'
  if y<-.11 and abs(x+.115)<.023 and 1.12<z<1.40:role='Leather'
  if y<-.12 and ax<.013 and (abs(z-1.23)<.015 or abs(z-1.36)<.015):role='Brass'
 elif z<1.55:role='Skin'
 else:
  role='Skin'
  # Separate crown/back and temple hair from the face; preserve the sculpted silhouette.
  if z>1.77 or (y>.055 and z>1.60) or (ax>.146 and z>1.68):role='Hair'
 face.material_index=slots[role];counts[role]+=1
# Remove the unused gray slot; Blender remaps the assigned slots.
mesh.data.materials.pop(index=0)
bpy.context.preferences.filepaths.save_version=0
bpy.ops.wm.save_as_mainfile(filepath=str(ROOT/'art_source/postal_worker_v06/postal_worker_colored_v06.blend'))
bpy.ops.object.select_all(action='DESELECT');mesh.select_set(True);arm.select_set(True)
bpy.context.view_layer.objects.active=mesh
bpy.ops.export_scene.gltf(filepath=str(OUT),export_format='GLB',use_selection=True,export_yup=True,export_animations=False,export_skins=True,export_all_influences=False)
report={'source_sha256':hashlib.sha256(SOURCE.read_bytes()).hexdigest(),'output_sha256':hashlib.sha256(OUT.read_bytes()).hexdigest(),'palette_srgb':palette,'faces_by_material':counts,'rig_bones':len(arm.data.bones),'method':'source-coordinate face material assignment, original topology and rig preserved','animations_added':0}
(ROOT/'art_source/postal_worker_v06/build_report.json').write_text(json.dumps(report,indent=2)+'\n')
