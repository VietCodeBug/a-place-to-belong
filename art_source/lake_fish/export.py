"""Bake the fish geometry and palette into single-surface GLBs for Godot."""
from pathlib import Path
import sys

import bpy


PALETTES = {
    "Fish1": [(0.47, 0.67, 0.66, 1), (0.18, 0.37, 0.40, 1), (0.38, 0.52, 0.44, 1)],
    "Fish2": [(0.35, 0.61, 0.64, 1), (0.54, 0.59, 0.47, 1), (0.13, 0.33, 0.39, 1)],
    "Fish3": [(0.50, 0.40, 0.18, 1), (0.25, 0.29, 0.15, 1), (0.14, 0.19, 0.17, 1)],
}


def export_fish(source_dir, output_dir, name, colors):
    bpy.ops.wm.read_factory_settings(use_empty=True)
    bpy.ops.import_scene.fbx(filepath=str(source_dir / f"{name}.fbx"))
    source = next(obj for obj in bpy.context.scene.objects if obj.type == "MESH")
    world_vertices = [source.matrix_world @ vertex.co for vertex in source.data.vertices]
    minimum = min(vertex.y for vertex in world_vertices)
    maximum = max(vertex.y for vertex in world_vertices)
    length = maximum - minimum
    middle = (minimum + maximum) / 2
    # Use a unit length and orient the head along +X for the swim shader.
    vertices = [((middle - p.y) / length, p.x / length, p.z / length) for p in world_vertices]
    polygons = [list(polygon.vertices) for polygon in source.data.polygons]
    material_ids = [polygon.material_index for polygon in source.data.polygons]
    for obj in list(bpy.context.scene.objects):
        bpy.data.objects.remove(obj, do_unlink=True)

    mesh = bpy.data.meshes.new(name)
    mesh.from_pydata(vertices, [], polygons)
    obj = bpy.data.objects.new(name, mesh)
    bpy.context.collection.objects.link(obj)
    paint = mesh.color_attributes.new(name="WaterPalette", type="FLOAT_COLOR", domain="CORNER")
    for polygon, material_id in zip(mesh.polygons, material_ids):
        for loop in polygon.loop_indices:
            paint.data[loop].color = colors[material_id]
    material = bpy.data.materials.new(f"{name}VertexPalette")
    material.diffuse_color = (1, 1, 1, 1)
    mesh.materials.append(material)
    bpy.ops.export_scene.gltf(
        filepath=str(output_dir / f"{name}.glb"),
        export_format="GLB",
        export_animations=False,
        export_vertex_color="ACTIVE",
    )


source_dir, output_dir = map(Path, sys.argv[sys.argv.index("--") + 1:])
output_dir.mkdir(parents=True, exist_ok=True)
for name, colors in PALETTES.items():
    export_fish(source_dir, output_dir, name, colors)
