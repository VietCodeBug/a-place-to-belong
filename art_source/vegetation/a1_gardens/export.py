"""Convert selected Quaternius source FBX to Godot GLB, preserving UVs and leaf/bark separation."""
from pathlib import Path
import bpy
from mathutils import Matrix
from math import pi

source = Path(__file__).resolve().parent
target = source.parents[2] / "assets/vegetation/a1_gardens"
target.mkdir(parents=True, exist_ok=True)
for path in sorted(source.glob("*.fbx")):
    bpy.ops.wm.read_factory_settings(use_empty=True)
    bpy.ops.import_scene.fbx(filepath=str(path))
    for obj in list(bpy.context.scene.objects):
        if obj.type != "MESH":
            continue
        bpy.ops.object.select_all(action="DESELECT")
        obj.select_set(True)
        bpy.context.view_layer.objects.active = obj
        bpy.ops.object.mode_set(mode="EDIT")
        bpy.ops.mesh.select_all(action="SELECT")
        bpy.ops.mesh.separate(type="MATERIAL")
        bpy.ops.object.mode_set(mode="OBJECT")
    for obj in bpy.context.scene.objects:
        if obj.type == "MESH":
            material = obj.data.materials[0]
            obj.name = material.name
            if not path.stem.startswith("MapleTree"):
                obj.matrix_world = Matrix.Rotation(-pi/2, 4, "X") @ obj.matrix_world
            material.diffuse_color = (.345, .286, .233, 1)
            material.use_nodes = False
    bpy.ops.export_scene.gltf(
        filepath=str(target / (path.stem + ".glb")),
        export_format="GLB", export_materials="EXPORT", export_animations=False,
    )
