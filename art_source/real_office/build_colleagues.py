"""Build the two original, posed NPCs for ENV-REAL-01 using Blender 4.x.

Run from the repository root:
    blender -b -t 2 -P art_source/real_office/build_colleagues.py

Coordinates are in metres; the models face Blender -Y / Godot +Z.
"""
import math
from pathlib import Path

import bpy
from mathutils import Vector

OUTPUT = Path("assets/story/office_models")


def pigment(name, rgb):
    def linear(channel):
        v = int(channel, 16) / 255
        return v / 12.92 if v < 0.04045 else ((v + 0.055) / 1.055) ** 2.4

    material = bpy.data.materials.new(name)
    material.use_nodes = True
    color = (*[linear(rgb[index:index + 2]) for index in (0, 2, 4)], 1)
    material.diffuse_color = color
    shader = material.node_tree.nodes.get("Principled BSDF")
    shader.inputs["Base Color"].default_value = color
    shader.inputs["Roughness"].default_value = 0.87
    return material


def mesh(name, vertices, faces, material, smooth=False):
    data = bpy.data.meshes.new(name)
    data.from_pydata(vertices, [], faces)
    data.update()
    obj = bpy.data.objects.new(name, data)
    bpy.context.collection.objects.link(obj)
    data.materials.append(material)
    for polygon in data.polygons:
        polygon.use_smooth = smooth
    return obj


def loft(name, rings, material, sides=10, smooth=False):
    """Each ring specifies elevation, center x/y, half width, and half depth."""
    vertices = [
        (x + w * math.cos(i * math.tau / sides),
         y + d * math.sin(i * math.tau / sides), z)
        for z, x, y, w, d in rings
        for i in range(sides)
    ]
    faces = [tuple(reversed(range(sides)))]
    for ring in range(len(rings) - 1):
        for i in range(sides):
            a = ring * sides + i
            b = ring * sides + (i + 1) % sides
            faces.append((a, b, b + sides, a + sides))
    faces.append(tuple(range(len(vertices) - sides, len(vertices))))
    return mesh(name, vertices, faces, material, smooth)


def taper(name, points, radii, material, sides=8):
    """Continuous joint silhouettes, using rings aligned to each limb."""
    vertices = []
    faces = []
    for i, (point, radius) in enumerate(zip(points, radii)):
        tangent = Vector(points[min(i + 1, len(points) - 1)]) - Vector(points[max(0, i - 1)])
        tangent.normalize()
        axis = tangent.cross(Vector((0, 1, 0)))
        if axis.length < 0.01:
            axis = tangent.cross(Vector((1, 0, 0)))
        axis.normalize()
        other = tangent.cross(axis)
        for j in range(sides):
            theta = math.tau * j / sides
            vertices.append(Vector(point) + (axis * math.cos(theta) + other * math.sin(theta)) * radius)
    faces.append(tuple(reversed(range(sides))))
    for i in range(len(points) - 1):
        faces.extend((i * sides + j, i * sides + (j + 1) % sides,
                      (i + 1) * sides + (j + 1) % sides, (i + 1) * sides + j)
                     for j in range(sides))
    faces.append(tuple(range(len(vertices) - sides, len(vertices))))
    return mesh(name, vertices, faces, material, True)


def volume(name, at, scale, material, segments=12, rings=8, smooth=False):
    bpy.ops.mesh.primitive_uv_sphere_add(segments=segments, ring_count=rings, radius=1, location=at)
    obj = bpy.context.object
    obj.name = name
    obj.scale = scale
    obj.data.materials.append(material)
    for face in obj.data.polygons:
        face.use_smooth = smooth
    return obj


def head(z, y, skin, hair, ink, long_hair):
    def p(x, depth, height):
        return (x, depth + y, height + z)

    loft("Face · jaw, temples and crown", [
        (z - .117, 0, y - .026, .044, .053),
        (z - .093, 0, y - .006, .078, .082),
        (z - .05, 0, y, .112, .105),
        (z + .012, 0, y + .004, .119, .108),
        (z + .067, 0, y + .009, .113, .103),
        (z + .109, 0, y + .016, .088, .080),
        (z + .133, 0, y + .018, .039, .048),
    ], skin, 14, True)
    for side in (-1, 1):
        volume("Ear", p(side * .112, .001, -.026), (.025, .024, .043), skin, 8, 6, True)
        x = side * .046
        eye = volume("Eye", p(x, -.092, .008), (.024, .008, .015), ink, 10, 6, True)
        eye.rotation_euler.z = side * .31
        volume("Eye glint", p(x - .005, -.099, .013), (.005, .003, .005), pigment("Eye glint", "F6E5CA"), 6, 4)
        brow = volume("Brow", p(x, -.095, .039), (.025, .006, .006), hair, 8, 6, True)
        brow.rotation_euler.y = side * .12
    mesh("Nose bridge", [p(-.014, -.101, .009), p(.014, -.101, .009),
        p(.018, -.099, -.038), p(-.018, -.099, -.038), p(0, -.132, -.026)],
        [(0, 1, 4), (1, 2, 4), (2, 3, 4), (3, 0, 4)], skin, True)
    volume("Mouth", p(0, -.095, -.064), (.024, .005, .004), pigment("Lips", "8D564F"), 10, 6, True)
    # The lower ring follows the hairline instead of cutting through eyes.
    count = 18
    vertices = []
    for layer in range(3):
        for i in range(count):
            angle = math.tau * i / count
            front = max(0.0, -math.sin(angle))
            asymmetry = .024 * math.cos(angle + .35) if front > .1 else 0
            if layer == 0:
                bottom = (-.103 if long_hair else -.040) + front ** 2 * (.161 if long_hair else .113)
                vertices.append(p(.124 * math.cos(angle), .014 + .112 * math.sin(angle), bottom + asymmetry))
            elif layer == 1:
                vertices.append(p(.129 * math.cos(angle), .014 + .115 * math.sin(angle), .104 + asymmetry * .46))
            else:
                vertices.append(p(.081 * math.cos(angle), .014 + .077 * math.sin(angle), .144 + asymmetry * .4))
    vertices.append(p(.014, .019, .156))
    faces = []
    for layer in range(2):
        faces.extend((layer * count + i, layer * count + (i + 1) % count,
                      (layer + 1) * count + (i + 1) % count, (layer + 1) * count + i)
                     for i in range(count))
    faces.extend((2 * count + i, 2 * count + (i + 1) % count, 3 * count) for i in range(count))
    mesh("Sculpted hair and asymmetric hairline", vertices, faces, hair)
    mesh("Swept fringe", [p(-.119, -.042, .09), p(-.088, -.094, .12), p(.076, -.094, .114),
        p(.111, -.046, .095), p(.060, -.091, .060), p(-.034, -.106, .048), p(-.093, -.079, .004),
        p(-.112, -.106, .056), p(.014, -.106, .106)],
        [(0, 1, 7), (1, 8, 7), (1, 2, 8), (2, 3, 8), (3, 4, 8), (4, 5, 8),
         (5, 7, 8), (5, 6, 7), (0, 7, 6)], hair)
    if long_hair:
        volume("Hair ends", p(.068, .061, -.081), (.080, .079, .070), hair, 9, 6)
        volume("Hair ends", p(-.062, .061, -.08), (.080, .079, .073), hair, 9, 6)


def joined(name, objects):
    bpy.ops.object.select_all(action="DESELECT")
    for obj in objects:
        obj.select_set(True)
    bpy.context.view_layer.objects.active = objects[0]
    bpy.ops.object.join()
    obj = bpy.context.object
    obj.name = name
    return obj


def colleague(name, seated):
    bpy.ops.object.select_all(action="SELECT")
    bpy.ops.object.delete(use_global=False)
    skin = pigment("Skin", "C89073" if seated else "D7A88B")
    ink = pigment("Eyes", "302A27")
    hair = pigment("Hair", "49342D" if seated else "3A312E")
    jacket = pigment("Knit", "A9614D" if seated else "4B6B63")
    cuff = pigment("Knit trim", "884634" if seated else "3F5652")
    shirt = pigment("Linen shirt", "EFE4C7")
    pants = pigment("Trousers", "5C5551" if seated else "665B51")
    shoe = pigment("Shoes", "453D35")
    y = -.04 if seated else 0
    pelvis = .55 if seated else .90
    shoulder = 1.00 if seated else 1.39
    collar = shoulder + .071
    loft("Cardigan body", [
        (pelvis - .026, 0, 0, .127, .09),
        (pelvis + .058, 0, 0, .137, .079),
        (pelvis + .16, 0, y * .35, .12, .079),
        (shoulder - .10, 0, y * .62, .155, .09),
        (shoulder - .036, 0, y, .178, .079),
        (shoulder + .02, 0, y, .118, .067),
        (collar - .03, 0, y, .074, .053),
    ], jacket, 14, True)
    loft("Neck", [(collar - .06, 0, y, .053, .047), (collar + .075, 0, y, .055, .053)], skin, 10, True)
    mesh("Linen inset and folded collar", [
        (-.067, y - .062, collar - .012), (.067, y - .062, collar - .012),
        (.084, y - .091, shoulder - .069), (.012, y - .097, shoulder - .207),
        (-.084, y - .091, shoulder - .069), (0, y - .101, shoulder - .065),
    ], [(0, 5, 1), (0, 4, 5), (5, 2, 1), (4, 3, 5), (5, 3, 2)], shirt)
    before_head = set(bpy.context.scene.objects)
    head(collar + .148, y - .009, skin, hair, ink, seated)
    face = joined("IdleHead", [obj for obj in bpy.context.scene.objects if obj not in before_head])
    bpy.context.scene.cursor.location = (0, y - .009, collar + .036)
    bpy.ops.object.origin_set(type="ORIGIN_CURSOR")
    button = pigment("Horn buttons", "DFC7A0" if seated else "B3B694")
    for index in range(3):
        volume("Cardigan button", (-.006, y * .60 - .088, shoulder - .235 - index * .052),
               (.009, .005, .009), button, 8, 5)
    for side in (-1, 1):
        heel = .03 * side
        if seated:
            taper("Seated trouser leg", [(side * .083, 0, .57), (side * .095, -.176, .54),
                (side * .106, -.34, .48), (side * .102, -.38, .28), (side * .105, -.397, .075)],
                [.080, .074, .062, .049, .035], pants)
            hand = (side * .126, -.491, .885 if side == 1 else .864)
            wrist = (side * .15, -.417, hand[2] - .011)
            elbow = (side * .20, -.12, .825)
        else:
            taper("Standing trouser leg", [(side * .076, .015, .94), (side * .082, .005, .76),
                (side * .086, -.008 + heel, .49), (side * .094, .009 + heel, .28),
                (side * .103, .02 + heel, .09)], [.084, .077, .060, .049, .040], pants)
            hand = (side * .135, -.191 if side == 1 else -.016, 1.10 if side == 1 else .88)
            wrist = (side * .18, hand[1] + .045, hand[2] + .036)
            elbow = (side * .208, -.03, 1.143)
        shoe_y = -.429 if seated else -.038 + heel
        loft("Rounded toe and sole", [(0.012, side * .10, shoe_y, .050, .094),
            (.039, side * .10, shoe_y, .054, .095), (.084, side * .10, shoe_y + .023, .047, .063)],
            shoe, 10, True)
        taper("Sleeve", [(side * .127, y, shoulder - .039), (side * .171, y, shoulder - .081),
            elbow, wrist], [.074, .066, .049, .034], jacket)
        volume("Cuff", wrist, (.039, .052, .038), cuff, 9, 6, True)
        volume("Hand", hand, (.036, .047, .021 if seated else .036), skin, 10, 7, True)
        volume("Thumb", (hand[0] - side * .026, hand[1] - .009, hand[2] + .005),
               (.017, .032, .015), skin, 8, 6, True)
    if not seated:
        # Vertical folder carried close to the body, with a separate paper edge.
        paper_edge = pigment("Paper edge", "D8C9AC")
        cover = pigment("Folder cover", "B18C64")
        verts = [(.059, -.207, 1.073), (.202, -.181, 1.103),
                 (.155, -.173, 1.313), (.013, -.197, 1.285)]
        mesh("Folder cover", verts, [(0, 1, 2, 3)], cover)
        mesh("Folder pages", [(x, y + .009, z + .004) for x, y, z in verts],
             [(0, 1, 2, 3)], paper_edge)
    # Keep a separate head pivot so ambient gaze uses the same mesh in both layouts.
    joined(name, [obj for obj in bpy.context.scene.objects if obj != face])
    bpy.ops.export_scene.gltf(filepath=str(OUTPUT / (name + ".glb")), export_format="GLB")


if __name__ == "__main__":
    OUTPUT.mkdir(parents=True, exist_ok=True)
    colleague("desk_colleague", True)
    colleague("aisle_colleague", False)
