"""Original A1 glacial stones. Run from Blender background mode."""
import math
import random
from pathlib import Path
import bpy

root = Path(__file__).resolve().parents[2]
bpy.ops.wm.read_factory_settings(use_empty=True)
palette = []
stone_colors = []
for color in [(0.26,.245,.217),(.30,.29,.25),(.35,.325,.276),(.215,.216,.197),(.25,.27,.178),(.295,.31,.205)]:
    stone_colors.append(tuple(c*.72 for c in color))
    mat = bpy.data.materials.new("Weathered granite")
    mat.diffuse_color = (*color,1.0)
    mat.use_nodes = True
    bsdf = mat.node_tree.nodes["Principled BSDF"]
    bsdf.inputs["Base Color"].default_value = (*color,1.0)
    bsdf.inputs["Roughness"].default_value = .94
    palette.append(mat)

node_tree=palette[0].node_tree
paint=node_tree.nodes.new("ShaderNodeVertexColor")
paint.layer_name="Granite facets"
node_tree.links.new(paint.outputs["Color"],node_tree.nodes["Principled BSDF"].inputs["Base Color"])
shapes=[("Ledge",1.72,1.11,1.24,-.43),("Erratic",1.32,1.06,1.56,.35),("Slab",1.45,.89,.84,-.27)]
objects=[]
for index,(name,w,d,h,lean) in enumerate(shapes):
    rng=random.Random(531+index*39)
    n=11
    angles=[i*math.tau/n+rng.uniform(-.08,.08) for i in range(n)]
    radial=[rng.uniform(.87,1.12) for _ in range(n)]
    verts=[]
    for ring,(z,r) in enumerate([(-.19,.72),(.10,.94),(.47,1.0),(.79,.83),(.97,.55)]):
        for i,a in enumerate(angles):
            offset=rng.uniform(-.068,.068)
            verts.append((math.cos(a)*w*r*(radial[i]+offset)+lean*z,
                          math.sin(a)*d*r*(radial[i]+offset)+.19*z,
                          h*(z+rng.uniform(-.07,.07)+.075*math.cos(a+.5))))
    verts.append((lean*.9,.14,h*.99))
    faces=[tuple(reversed(range(n)))]
    ids=[3]
    for level in range(4):
        for i in range(n):
            a=level*n+i
            b=level*n+(i+1)%n
            faces.extend([(a,b,b+n),(a,b+n,a+n)])
            base=rng.choice([0,0,1,1,2,3] if level>0 else [0,1,3,4])
            ids.extend([base,base if rng.random()<.69 else rng.choice([0,1,2,4])])
    for i in range(n):
        faces.append((4*n+i,4*n+(i+1)%n,5*n))
        ids.append(rng.choice([1,1,2,2,4,5]))
    mesh=bpy.data.meshes.new(name)
    mesh.from_pydata(verts,[],faces)
    attribute=mesh.color_attributes.new(name="Granite facets",type="FLOAT_COLOR",domain="CORNER")
    for face,mid in zip(mesh.polygons,ids):
        for loop_index in face.loop_indices:
            attribute.data[loop_index].color=(*stone_colors[mid],1.0)
    mesh.color_attributes.active_color=attribute
    mesh.materials.append(palette[0])
    obj=bpy.data.objects.new(name,mesh)
    bpy.context.collection.objects.link(obj)
    bevel=obj.modifiers.new("Weathered edge breaks","BEVEL")
    bevel.width=.055
    bevel.segments=1
    objects.append(obj)

bpy.context.preferences.filepaths.save_version=0
for i,obj in enumerate(objects):
    obj.location.x=i*4.
bpy.ops.wm.save_as_mainfile(filepath=str(root/"art_source/a1_clearing/boulders.blend"))
for obj in objects:
    bpy.ops.object.select_all(action="DESELECT")
    obj.location.x=0
    obj.select_set(True)
    bpy.context.view_layer.objects.active=obj
    bpy.ops.export_scene.gltf(filepath=str(root/f"assets/a1_house_gate/clearing_{obj.name.lower()}.glb"),
                             export_format="GLB",use_selection=True,export_all_vertex_colors=False)
