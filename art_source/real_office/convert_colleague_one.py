"""Convert a user-supplied rigged PBR FBX for the rainy office scene.

blender -b -P art_source/real_office/convert_colleague_one.py -- /path/to/source.fbx
"""
from argparse import ArgumentParser
import sys
from pathlib import Path

import bpy


parser = ArgumentParser()
parser.add_argument("source", type=Path)
parser.add_argument("--output", type=Path, default=Path("assets/story/office_models/colleague_npc_01.glb"))
parser.add_argument("--keep-topology", action="store_true", help="Keep the original triangle count.")
options = parser.parse_args(sys.argv[sys.argv.index("--") + 1:])

bpy.ops.wm.read_factory_settings(use_empty=True)
bpy.ops.import_scene.fbx(filepath=str(options.source))
body = next(obj for obj in bpy.context.scene.objects if obj.type == "MESH")
rig = next(obj for obj in bpy.context.scene.objects if obj.type == "ARMATURE")
material = body.data.materials[0]
surface = material.node_tree.nodes.get("Principled BSDF")
color = surface.inputs["Base Color"]
if not color.is_linked or not color.links[0].from_node.image.packed_file:
    raise ValueError("Expected the textured FBX with a packed base color map.")

body.name = "ColleagueBody"
rig.name = "ColleagueRig"
if not options.keep_topology:
    bpy.context.view_layer.objects.active = body
    decimate = body.modifiers.new("Office runtime mesh", "DECIMATE")
    decimate.ratio = 0.38
    bpy.ops.object.modifier_apply(modifier=decimate.name)
body.data.calc_loop_triangles()
print(f"{options.output.stem}: {len(body.data.loop_triangles)} triangles, {len(rig.data.bones)} bones.")

bpy.ops.export_scene.gltf(
    filepath=str(options.output),
    export_format="GLB",
    export_animations=False,
    export_all_influences=True,
    export_tangents=True,
)
