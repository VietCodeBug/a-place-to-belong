"""Convert the user-supplied Character A FBX without changing the original.

blender -b -P art_source/real_office/convert_character_a.py -- /path/to/source.fbx
"""
import sys
from pathlib import Path

import bpy


source = Path(sys.argv[sys.argv.index("--") + 1])
destination = Path("assets/story/office_models/character_a.glb")

bpy.ops.wm.read_factory_settings(use_empty=True)
bpy.ops.import_scene.fbx(filepath=str(source))
scene = bpy.context.scene
rig = next(obj for obj in scene.objects if obj.type == "ARMATURE")
body = next(obj for obj in scene.objects if obj.type == "MESH")
rig.name = "CharacterRig"
body.name = "OfficeBody"

# Keep the original material and skin weights while making the head independently
# visible to a review camera. In first person, the head only casts shadows.
bpy.ops.object.select_all(action="DESELECT")
body.select_set(True)
bpy.context.view_layer.objects.active = body
bpy.context.tool_settings.mesh_select_mode = (False, False, True)
for polygon in body.data.polygons:
    polygon.select = (body.matrix_world @ polygon.center).z > 1.397
bpy.ops.object.mode_set(mode="EDIT")
bpy.ops.mesh.separate(type="SELECTED")
bpy.ops.object.mode_set(mode="OBJECT")
head = next(obj for obj in scene.objects if obj.type == "MESH" and obj != body)
head.name = "OfficeHead"

for image in bpy.data.images:
    if image.size[0] > 2048:
        image.scale(2048, 2048)
        image.pack()

bpy.ops.export_scene.gltf(
    filepath=str(destination),
    export_format="GLB",
    export_animations=False,
    export_all_influences=True,
)
