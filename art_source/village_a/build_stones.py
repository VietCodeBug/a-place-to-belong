"""Sculpt two stylized fieldstone profiles with layered fractures and weathered edges."""
import math
import random
from pathlib import Path

import bpy

source = Path(__file__).resolve().parent
destination = source.parents[1] / "assets/village_a"
bpy.ops.wm.read_factory_settings(use_empty=True)
palette = []
for number, tint in enumerate([(.28,.28,.25),(.31,.30,.26),(.26,.27,.25),(.34,.33,.29)]):
    material = bpy.data.materials.new("Weathered sandstone %d" % number)
    material.diffuse_color = (*tint,1)
    material.roughness = .92
    palette.append(material)

for index, name in enumerate(["layered_ledge","split_boulder"]):
    rng = random.Random(1904+index)
    sides = 28
    widths = [.71,.87,.91,.93,.91,.82,.74,.61,.44,.20]
    elevations = [0,.13,.24,.35,.48,.56,.66,.76,.84,.90]
    vertices = []
    axis_x, axis_y = (1.37,.67) if index==0 else (1.06,.88)
    for row,(radius,height) in enumerate(zip(widths,elevations)):
        offset_x = height * (.25 if index==0 else -.20)
        for side in range(sides):
            a = 2*math.pi*side/sides
            cx = math.copysign(abs(math.cos(a))**.77,math.cos(a))
            cy = math.copysign(abs(math.sin(a))**.80,math.sin(a))
            shape_noise = .94+.09*math.sin(a*3+.51)+.064*math.sin(a*6+.85)
            fracture = .064 if side in [4,5,6,16,17] and row in [2,3,5,6] else .0
            shell = radius * shape_noise-fracture+rng.uniform(-.017,.017)
            z = height + .065*cx + .038*cy + .026*math.sin(a*4+row*.45) + rng.uniform(-.014,.014)
            z *= .73 if index==0 else 1.11
            vertices.append((offset_x+cx*shell*axis_x,cy*shell*axis_y,z))
    faces = []
    for row in range(len(widths)-1):
        for side in range(sides):
            a = row*sides+side
            b = row*sides+(side+1)%sides
            faces += [(a,b,a+sides),(b,b+sides,a+sides)]
    faces += [tuple(range(sides-1,-1,-1)),tuple(range((len(widths)-1)*sides,len(widths)*sides))]
    mesh = bpy.data.meshes.new(name)
    mesh.from_pydata(vertices,[],faces)
    mesh.update()
    for material in palette:
        mesh.materials.append(material)
    for polygon in mesh.polygons:
        row, side = divmod(polygon.index//2,sides)
        polygon.material_index = ((side//5 + int(row in [2,4,7]))%4) if row<9 else 1
        polygon.use_smooth = row not in [2,5,9]
    rock = bpy.data.objects.new(name,mesh)
    bpy.context.collection.objects.link(rock)
    bpy.ops.object.select_all(action="DESELECT")
    rock.select_set(True)
    bpy.context.view_layer.objects.active = rock
    bpy.ops.export_scene.gltf(filepath=str(destination/(name+".glb")),export_format="GLB",use_selection=True)
    rock.location.x = index*3.3

bpy.context.preferences.filepaths.save_version = 0
bpy.ops.wm.save_as_mainfile(filepath=str(source/"fieldstone.blend"))
