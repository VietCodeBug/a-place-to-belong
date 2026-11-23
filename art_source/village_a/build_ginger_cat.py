"""Build the original Village A cat rig, source scene and runtime glTF."""
from pathlib import Path
from math import cos, pi, sin

import bmesh
import bpy
from mathutils import Vector


ROOT = Path(__file__).resolve().parents[2]
bpy.ops.object.select_all(action="SELECT")
bpy.ops.object.delete(use_global=False)
scene = bpy.context.scene
scene.render.fps = 24
scene.unit_settings.system = "METRIC"


def material(name, rgb):
    result = bpy.data.materials.new(name)
    result.diffuse_color = (*rgb, 1)
    result.use_nodes = True
    shader = result.node_tree.nodes.get("Principled BSDF")
    shader.inputs["Base Color"].default_value = (*rgb, 1)
    shader.inputs["Roughness"].default_value = 0.91
    return result


FUR = material("Apricot fur", (0.57, 0.233, 0.075))
SHADE = material("Cinnamon tabby", (0.326, 0.108, 0.040))
CREAM = material("Cream ruff", (0.90, 0.73, 0.48))
EAR = material("Warm inner ear", (0.55, 0.218, 0.149))
NOSE = material("Rose nose", (0.37, 0.103, 0.089))
INK = material("Coffee pupils", (0.044, 0.024, 0.015))
IRIS = material("Honey eyes", (0.61, 0.43, 0.157))

armature = bpy.data.armatures.new("GingerCatSkeleton")
rig = bpy.data.objects.new("GingerCat", armature)
scene.collection.objects.link(rig)
bpy.context.view_layer.objects.active = rig
rig.select_set(True)
bpy.ops.object.mode_set(mode="EDIT")


def bone(name, start, end, parent=None):
    result = armature.edit_bones.new(name)
    result.head = start
    result.tail = end
    if parent:
        result.parent = armature.edit_bones[parent]


bone("hips", (0, 0, 0.235), (0, -0.135, 0.262))
bone("head", (0, -0.129, 0.279), (0, -0.244, 0.334), "hips")
legs = {}
for front in (True, False):
    for side in (-1, 1):
        tag = ("front" if front else "rear") + ("_left" if side < 0 else "_right")
        x = side * (0.061 if front else 0.064)
        y = -0.128 if front else 0.117
        start = Vector((x, y, 0.253 if front else 0.247))
        knee = Vector((x, y + (0.013 if front else -0.040), 0.134))
        paw = Vector((x, y + (0.006 if front else 0.012), 0.035))
        bone(tag, start, knee, "hips")
        bone(tag + "_shin", knee, paw, tag)
        legs[tag] = start, knee, paw

tail_knots = [(0, 0.161, 0.248), (0, 0.253, 0.280), (0.014, 0.337, 0.341),
              (0.035, 0.377, 0.415), (0.056, 0.362, 0.478)]
for i in range(4):
    bone(f"tail_{i}", tail_knots[i], tail_knots[i + 1], f"tail_{i - 1}" if i else "hips")
bpy.ops.object.mode_set(mode="OBJECT")

pieces = []


def bind(obj, name, joint, paint):
    obj.name = name
    obj.data.materials.append(paint)
    obj.vertex_groups.new(name=joint).add(list(range(len(obj.data.vertices))), 1, "REPLACE")
    pieces.append(obj)
    return obj


def ellipsoid(name, center, size, joint, paint, angle=0):
    bpy.ops.mesh.primitive_uv_sphere_add(segments=10, ring_count=5, radius=1, location=center)
    obj = bpy.context.object
    obj.scale = size
    obj.rotation_euler.x = angle
    return bind(obj, name, joint, paint)


def mesh(name, coordinates, faces, joint, paint):
    geometry = bpy.data.meshes.new(name)
    geometry.from_pydata(coordinates, [], faces)
    editable = bmesh.new()
    editable.from_mesh(geometry)
    bmesh.ops.recalc_face_normals(editable, faces=list(editable.faces))
    editable.to_mesh(geometry)
    editable.free()
    obj = bpy.data.objects.new(name, geometry)
    scene.collection.objects.link(obj)
    return bind(obj, name, joint, paint)


def segment(name, a, b, r1, r2, joint, paint):
    a, b = Vector(a), Vector(b)
    axis = (b - a).normalized()
    across = axis.cross(Vector((1, 0, 0))).normalized()
    around = across.cross(axis).normalized()
    rings = [a + r1 * (across * cos(i*pi/5) + around * sin(i*pi/5)) for i in range(10)]
    rings += [b + r2 * (across * cos(i*pi/5) + around * sin(i*pi/5)) for i in range(10)]
    faces = [(i, (i+1) % 10, (i+1) % 10+10, i+10) for i in range(10)]
    faces += [tuple(range(10)), tuple(range(10, 20))]
    return mesh(name, rings, faces, joint, paint)


# One continuous torso, with irregular ribs and a cream underside.
profile = [(-0.160, .035, .055, .250), (-0.126, .075, .100, .237),
           (-0.042, .086, .091, .238), (0.048, .080, .087, .238),
           (0.119, .089, .096, .230), (0.165, .055, .069, .235), (0.182, .019, .027, .242)]
vertices = [(rx*cos(i*pi/6), y, z+rz*sin(i*pi/6)) for y, rx, rz, z in profile for i in range(12)]
polygons = [(12*j+i, 12*j+(i+1)%12, 12*(j+1)+(i+1)%12, 12*(j+1)+i)
            for j in range(len(profile)-1) for i in range(12)]
polygons += [tuple(range(12)), tuple(range(72, 84))]
torso = mesh("Torso", vertices, polygons, "hips", FUR)
torso.data.materials.append(CREAM)
torso.data.materials.append(SHADE)
for face in torso.data.polygons[:72]:
    ring, side = divmod(face.index, 12)
    if side in (7, 8, 9, 10):
        face.material_index = 1
    elif ring in (2, 4) and side in (1, 2, 3, 4):
        face.material_index = 2

ellipsoid("Ruff", (0, -.148, .259), (.063, .058, .085), "head", CREAM)
ellipsoid("Head", (0, -.188, .344), (.090, .080, .078), "head", FUR)
for sign in (-1, 1):
    x = sign * .063
    ear_coords = [(x-.035,-.158,.389),(x+.030,-.162,.390),(x+sign*.006,-.170,.477),
                  (x-.025,-.116,.395),(x+.026,-.118,.395)]
    mesh("Ear",ear_coords,[(0,1,2),(0,2,3),(1,4,2),(2,4,3),(0,3,4,1)],"head",FUR)
    mesh("Inner ear",[(x-.020,-.162,.401),(x+.017,-.165,.401),(x+sign*.006,-.172,.454),
                       (x,-.153,.406)],[(0,2,1),(0,1,3),(0,3,2),(1,2,3)],"head",EAR)
    ellipsoid("Eye rim", (sign*.047,-.243,.357), (.025,.018,.019), "head", INK)
    ellipsoid("Eye", (sign*.047,-.252,.357), (.019,.013,.015), "head", IRIS)
    ellipsoid("Slit pupil", (sign*.045,-.262,.357), (.005,.004,.012), "head", INK)
    ellipsoid("Catchlight", (sign*.051,-.267,.363), (.003,.002,.004), "head", CREAM)
    ellipsoid("Whisker cushion", (sign*.026,-.247,.313), (.038,.035,.025), "head", CREAM)
    for n in range(2):
        ellipsoid("Whisker fleck", (sign*(.035+.009*n),-.271,.317-.006*n), (.003,.003,.003), "head", SHADE)
ellipsoid("Chin", (0,-.234,.293), (.045,.043,.016), "head", CREAM)
mesh("Nose",[(-.014,-.279,.330),(.014,-.279,.330),(0,-.283,.316),(0,-.263,.327)],
     [(0,2,1),(0,1,3),(0,3,2),(1,2,3)],"head",NOSE)
for name, (hip,knee,paw) in legs.items():
    front = name.startswith("front")
    segment("Thigh",hip+(hip-knee).normalized()*.025,knee+(knee-hip).normalized()*.013,
            .032 if front else .043,.023,name,FUR)
    segment("Shin",knee+(knee-paw).normalized()*.019,paw,.024,.015,name+"_shin",FUR)
    ellipsoid("Paw", (paw.x,paw.y-.009,paw.z-.009),(.027,.037,.024),name+"_shin",CREAM)
for index in range(4):
    a, b = Vector(tail_knots[index]), Vector(tail_knots[index+1])
    radius = .029-index*.005
    joint = f"tail_{index}"
    segment("Tail",a,b.lerp(a,.40),radius,radius-.001,joint,FUR)
    segment("Tail ring",a.lerp(b,.60),b,radius-.001,max(.006,radius-.005),joint,SHADE)
ellipsoid("Tail tip", tail_knots[-1], (.009,.012,.012), "tail_3", SHADE)

# Join the rigid-weighted parts and export a single skinned character mesh.
bpy.ops.object.select_all(action="DESELECT")
for obj in pieces:
    obj.select_set(True)
bpy.context.view_layer.objects.active = torso
bpy.ops.object.join()
torso.name = "GingerCatMesh"
modifier = torso.modifiers.new("Ginger cat skin", "ARMATURE")
modifier.object = rig
torso.parent = rig
for joint in rig.pose.bones:
    joint.rotation_mode = "XYZ"


def clip(name, cycle, stride):
    action = bpy.data.actions.new(name)
    rig.animation_data_create()
    rig.animation_data.action = action
    for index in range(cycle + 1):
        frame = index + 1
        phase = index * 2*pi/cycle
        for joint in rig.pose.bones:
            joint.rotation_euler = (0,0,0)
        for leg in legs:
            front = leg.startswith("front")
            left = leg.endswith("left")
            offset = (0 if left == front else pi) if stride>.55 else (0 if left else pi)+(0 if front else pi*.52)
            angle = phase+offset
            lift = max(0,sin(angle))
            rig.pose.bones[leg].rotation_euler.x = cos(angle)*stride
            rig.pose.bones[leg+"_shin"].rotation_euler.x = lift*stride*(1.15 if front else -1.02)
        rig.pose.bones["head"].rotation_euler = (.055*sin(phase*(2 if stride else 1)),0,.15*sin(phase) if not stride else .024*sin(phase))
        for i in range(4):
            rig.pose.bones[f"tail_{i}"].rotation_euler.z = (.12 if not stride else .19)*sin(phase-i*.53)
        for joint in rig.pose.bones:
            joint.keyframe_insert(data_path="rotation_euler",frame=frame,group=joint.name)
    rig.animation_data.action = None
    track = rig.animation_data.nla_tracks.new()
    track.name = name
    track.strips.new(name,1,action)
    track.mute = True
    return track


idle = clip("Idle",60,0)
clip("Walk",22,.41)
clip("Trot",15,.64)
idle.mute = False
scene.frame_start, scene.frame_end = 1, 61
scene.frame_set(1)
source = ROOT / "art_source/village_a/ginger_cat.blend"
bpy.ops.wm.save_as_mainfile(filepath=str(source), compress=True)
for track in rig.animation_data.nla_tracks:
    track.mute = False
bpy.ops.export_scene.gltf(filepath=str(ROOT / "assets/village_a/pets/GingerCat.glb"),
                          export_format="GLB", export_animation_mode="NLA_TRACKS", export_force_sampling=True,
                          export_yup=True, export_texcoords=False)
