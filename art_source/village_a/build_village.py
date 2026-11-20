"""Build the editable Village A exterior kit and export its five Godot GLBs."""
import math
import random
from pathlib import Path

import bpy
import bmesh
from mathutils import Vector

ROOT = Path(__file__).resolve().parents[2]
SOURCE = ROOT / "art_source/village_a"
DEST = ROOT / "assets/village_a"
rng = random.Random(91)

bpy.ops.wm.read_factory_settings(use_empty=True)

def material(name, colors, roughness=0.82, glow=0):
    palette = []
    for i, rgb in enumerate(colors):
        m = bpy.data.materials.new(f"{name} {i+1:02d}")
        m.use_nodes = True
        shader = m.node_tree.nodes.get("Principled BSDF")
        shader.inputs["Base Color"].default_value = (*rgb, 1)
        shader.inputs["Roughness"].default_value = roughness
        shader.inputs["Emission Color"].default_value = (*rgb, 1)
        shader.inputs["Emission Strength"].default_value = glow
        m.diffuse_color = (*rgb, 1)
        palette.append(m)
    return palette

WOOD = material("Oiled oak", [(0.20,.102,.051),(.27,.145,.073),(.32,.177,.092),(.39,.23,.13)])
TRIM = material("Oak end grain", [(.30,.165,.09),(.39,.234,.127)])
PLASTER = material("Warm limewash", [(.73,.61,.44),(.68,.555,.394),(.77,.66,.49)])
STONE = material("Warm slate", [(.35,.31,.26),(.42,.385,.32),(.47,.425,.35),(.29,.275,.243)])
TILE = material("Fired clay", [(.29,.115,.077),(.37,.156,.091),(.43,.195,.114),(.33,.143,.105),(.49,.235,.133)])
TEAL = material("Weathered sage paint", [(.105,.219,.175),(.141,.272,.211),(.168,.301,.235)])
GLASS = material("Honey glass", [(.72,.375,.115),(.89,.58,.25)], .30, .25)
IRON = material("Blackened iron", [(.095,.077,.058)], .55)
LEAF = material("Garden leaves", [(.13,.25,.085),(.19,.34,.10),(.27,.39,.115),(.09,.195,.097)])
FLOWER = material("Garden petals", [(.64,.33,.48),(.45,.27,.49),(.86,.64,.43),(.79,.50,.40)])
EARTH = material("Garden earth", [(.22,.145,.086),(.295,.216,.133)])

def geo(name, vertices, faces, mat, bevel=0):
    mesh = bpy.data.meshes.new(name)
    mesh.from_pydata(vertices, [], faces)
    mesh.update()
    obj = bpy.data.objects.new(name, mesh)
    bpy.context.collection.objects.link(obj)
    obj.data.materials.append(mat)
    if bevel:
        mod = obj.modifiers.new("Cut edges", "BEVEL")
        mod.width = bevel
        mod.segments = 1
    return obj

def extrude(name, outline, y, depth, mat, bevel=.015):
    if sum(a*d-c*b for (a,b),(c,d) in zip(outline,outline[1:]+outline[:1])) < 0:
        outline = list(reversed(outline))
    n = len(outline)
    vertices = [(x, y-d, z) for d in (0, depth) for x,z in outline]
    return geo(name, vertices, [tuple(range(n-1,-1,-1)),tuple(range(n,n*2))] +
        [(i,(i+1)%n,(i+1)%n+n,i+n) for i in range(n)], mat, bevel)

def block(name, position, size, mat, bevel=.025):
    x,y,z = position
    w,d,h = (v*.5 for v in size)
    return extrude(name, [(x-w,z-h),(x+w,z-h),(x+w,z+h),(x-w,z+h)], y+d,d*2,mat,bevel)

def timber(name, a, b, w, depth, mat=None):
    a,b = Vector(a),Vector(b)
    mid = (a+b)*.5
    obj = block(name, (0,0,0), (w,depth,(b-a).length), mat or rng.choice(WOOD), .024)
    obj.location = mid
    obj.rotation_mode = "QUATERNION"
    obj.rotation_quaternion = (b-a).to_track_quat("Z","Y")
    return obj

def gable(name, x, width, y0, y1, base, eave, ridge, tip, mat):
    outline = [(x-width/2,base),(x+width/2,base),(x+width/2,eave),
               (x+tip,ridge),(x-width/2,eave)]
    return extrude(name, outline, y1, y1-y0, mat, .042)

def roof(name, x, width, y0, y1, eave, height, peak=0, surf=TILE):
    ridge = (x+peak,height)
    for sign in (-1,1):
        lip = (x+sign*(width/2+.30),eave)
        outline = [lip, ridge, (ridge[0],ridge[1]-.18), (lip[0],lip[1]-.17)]
        extrude(name+" lined deck",outline,y1,y1-y0,WOOD[0],.025)
        for y in [y0-.026,y1+.026]:
            timber(name+" carved bargeboard",(lip[0],y,lip[1]-.045),(ridge[0],y,ridge[1]+.027),.18,.17,TRIM[0])
        timber(name+" eave beam",(lip[0],y0,eave-.10),(lip[0],y1,eave-.10),.14,.17)
        span = math.dist(ridge,lip)
        n=math.ceil(span/.29)
        count=math.ceil((y1-y0)/.30)
        for j in range(n):
            for k in range(-1,count+1):
                u0 = max(y0, y0+(k-.50*(j%2))*(y1-y0)/count)
                u1 = min(y1, y0+(k+.96-.50*(j%2))*(y1-y0)/count)
                if u1-u0<.04:
                    continue
                start=j/n
                end=min((j+1.10)/n,1.025)
                hx = ridge[0]+(lip[0]-ridge[0])*start
                hz = ridge[1]+(lip[1]-ridge[1])*start+.047
                lx = ridge[0]+(lip[0]-ridge[0])*end
                lz = ridge[1]+(lip[1]-ridge[1])*end+.083
                seam = rng.uniform(.006,.022)
                extrude(name+" hand-split shingle", [(hx,hz),(lx,lz+seam),(lx,lz-.022),(hx,hz-.041)],
                        u1,u1-u0,rng.choice(surf),0)
    for i in range(math.ceil((y1-y0)/.34)):
        y=y0+(i+.5)*.34
        block(name+" ridge cap",(ridge[0],y,height+.065),(.29,.34,.13),surf[2],.045)

def stone_course(name, x0, x1, y, z, units, size):
    for i in range(units):
        x=x0+(x1-x0)*(i+.5)/units
        w=(x1-x0)/units-.026
        low=z-size*.5
        high=z+size*.5
        shape=[(x-w*.52,low+.052),(x-w*.34,low),(x+w*.43,low+.009),
               (x+w*.51,low+.084),(x+w*.42,high-.028),(x-w*.33,high)]
        extrude(name,shape,y,.23+rng.random()*.08,rng.choice(STONE),.014)

def pane(name,x,y,z,w=.73,h=.92,shutters=True):
    block(name+" recess",(x,y,z),(w+.18,.14,h+.18),WOOD[0],.035)
    for sx in (-1,1):
        for sz in (-1,1):
            block(name+" amber pane",(x+sx*w*.248,y-.079,z+sz*h*.244),
                  (w*.447,.045,h*.44),GLASS[(sx+sz)%2],.013)
    block(name+" mullion",(x,y-.116,z),(.056,.05,h),TRIM[1],.008)
    block(name+" transom",(x,y-.116,z),(w,.05,.061),TRIM[1],.008)
    block(name+" stone sill",(x,y-.136,z-h*.5-.086),(w+.26,.32,.13),STONE[2],.029)
    if shutters:
        for side in (-1,1):
            pos=x+side*(w*.5+.20)
            for j in range(3):
                block(name+" shutter board",(pos+(j-1)*.108,y-.142,z),
                      (.103,.081,h*.94),TEAL[j],.012)
            for dz in [-.27,.26]:
                block(name+" shutter cleat",(pos,y-.188,z+dz),(.34,.037,.07),TEAL[0],.008)

icospheres = {}

def faceted(name, position, size, mat, sub=1):
    key = (sub, mat.name)
    if key not in icospheres:
        mesh = bpy.data.meshes.new(f"Facets {sub} {mat.name}")
        sculpt = bmesh.new()
        bmesh.ops.create_icosphere(sculpt, subdivisions=sub, radius=1.0)
        sculpt.to_mesh(mesh)
        sculpt.free()
        mesh.materials.append(mat)
        icospheres[key] = mesh
    obj = bpy.data.objects.new(name, icospheres[key])
    bpy.context.collection.objects.link(obj)
    obj.location = position
    obj.scale = size
    return obj

def blossoms(x,y,base,count):
    for j in range(count):
        hx=x+rng.uniform(-.33,.33)
        hy=y+rng.uniform(-.16,.16)
        z=base+rng.uniform(.16,.40)
        timber("Flower stem",(hx,hy,base),(hx+.04,hy,z),.019,.025,LEAF[1])
        faceted("Leaf",(hx-.012,hy,base+.12),(.085,.035,.023),rng.choice(LEAF))
        for k in range(4):
            angle=k*math.tau/4
            faceted("Petal",(hx+.04+.047*math.cos(angle),hy+.047*math.sin(angle),z),
                (.050,.042,.029),rng.choice(FLOWER))
        faceted("Pollen",(hx+.04,hy,z+.02),(.033,.032,.020),FLOWER[2])

SAGE = material("Slate green shingles",[(.105,.145,.124),(.135,.178,.141),(.155,.198,.167),(.173,.22,.175)])
MASTERS=[]

def shell(width, depth, eave, ridge, shift, tiles, skin, door, cx=0, cy=0, door_visible=True):
    y=cy-depth*.5
    gable("Limewash envelope",cx,width,y,cy+depth*.5,.13,eave,ridge,shift,skin)
    roof("Clad roof",cx,width,y-.32,cy+depth*.5+.30,eave-.05,ridge+.037,shift,tiles)
    for z in [.13,.35]:
        stone_course("Foundation",cx-width*.5,cx+width*.5,y-.02,z,math.ceil(width/.51),.20)
    for x in [cx-width*.5+.09,cx+width*.5-.09]:
        timber("Wall upright",(x,y-.06,.48),(x,y-.06,eave),.18,.16)
    for z in [.48,eave-.14]:
        timber("Wall ledger",(cx-width*.5,y-.06,z),(cx+width*.5,y-.06,z),.17,.15)
    for sx in [-1,1]:
        x=cx+sx*(width*.5-.13)
        timber("Gable brace",(x,y-.065,eave-.17),(cx+shift,y-.065,ridge-.13),.15,.15)
        timber("Knee brace",(x,y-.07,eave-.19),(x-sx*.55,y-.07,eave-.70),.12,.13)
        wx=cx+sx*width*.33
        if abs(wx-door)>1.0 or not door_visible:
            pane("Street window",wx,y-.10,1.64,.71,.86)
    pane("Loft",cx+shift,y-.08,eave+(ridge-eave)*.32,.48,.59,False)
    if door_visible:
        arch=[(door-.55,.40),(door+.55,.40),(door+.55,1.91)]
        arch.extend((door+.55*math.cos(math.pi*i/6),1.91+.30*math.sin(math.pi*i/6)) for i in range(1,7))
        extrude("Oak door surround",arch,y-.07,.20,WOOD[0],.03)
        for i in range(7):
            h=1.50+.28*math.sqrt(1-((i-3)/3.5)**2)
            block("Door stave",(door+(i-3)*.14,y-.29,.40+h*.5),(.131,.05,h),WOOD[i%4],.012)
        block("Wrought handle",(door+.26,y-.325,1.14),(.09,.04,.10),IRON[0])
        for i in range(3):
            block("Stone threshold",(door,y-.49-i*.19,.26-i*.096),(1.68+i*.12,.44,.148),STONE[i],.032)
    for side in [-1,1]:
        x=cx+side*(width*.5+.03)
        for u in [-.36,.38]:
            timber("End-wall post",(x,cy+depth*u,.44),(x,cy+depth*u,eave-.15),.15,.16)
        timber("End-wall ledger",(x,cy-depth*.48,eave-.35),(x,cy+depth*.48,eave-.35),.16,.15)
        before=set(bpy.context.collection.objects)
        pane("Side window",0,0,1.78,.68,.83,True)
        for obj in set(bpy.context.collection.objects)-before:
            obj.rotation_euler.z=side*math.pi/2
            obj.location=(x,cy+.42,0)
    return y

def porch(x,y,w,z,mat):
    roof("Sheltered landing",x,w,y-1.52,y+.07,z,z+.56,-.16,mat)
    block("Landing deck",(x,y-.64,.27),(w,1.25,.18),WOOD[1],.029)
    for side in [-1,1]:
        u=x+side*(w*.5-.14)
        timber("Porch post",(u,y-1.24,.37),(u,y-1.24,z),.16,.17)
        timber("Porch knee brace",(u,y-1.24,z-.49),(u-side*.40,y-1.24,z),.11,.13)
    block("Warm entry lantern",(x+w*.33,y-.62,1.91),(.16,.16,.24),GLASS[1],.022)

def chimney(x,y,z):
    for i in range(8):
        block("Chimney masonry",(x,y,z+i*.17),(.66,.60,.164),STONE[i%3],.018)
    block("Chimney cap",(x,y,z+1.36),(.83,.77,.15),STONE[2],.033)

for kind in ["porch","gable","long","craft","hall","split","loft","shed","wing"]:
    before=set(bpy.context.scene.objects)
    if kind=="porch":
        y=shell(5.15,4.20,2.71,4.69,-.17,TILE,PLASTER[0],-.66)
        porch(-.66,y,2.24,2.31,TILE);chimney(1.41,.74,3.08)
    elif kind=="gable":
        y=shell(5.62,4.62,3.15,5.68,.28,SAGE,PLASTER[1],.82)
        shell(1.97,2.55,3.34,4.69,-.13,TILE,PLASTER[0],-1.35,-1.35,-1.32,False)
        porch(.82,y,2.22,2.44,SAGE);chimney(1.70,.69,4.17)
    elif kind=="long":
        y=shell(6.55,4.32,2.98,5.22,-.59,TILE,PLASTER[2],-1.16,-.47)
        shell(2.63,3.13,2.1,3.20,.33,SAGE,PLASTER[1],3.15,3.15,.53,False)
        porch(-1.16,y,3.13,2.40,TILE);chimney(1.02,1.05,3.50)
    elif kind=="craft":
        y=shell(6.01,4.41,2.94,4.92,-.12,SAGE,PLASTER[1],-1.01)
        porch(.17,y,5.41,2.49,SAGE);chimney(-1.31,1.16,3.52)
        for x in [1.11,2.14]:
            block("Outdoor workbench",(x,y-.94,.88),(.96,.42,.11),WOOD[1],.024)
            for dx in [-.33,.33]:
                block("Bench post",(x+dx,y-.94,.46),(.12,.27,.80),WOOD[0])
    elif kind=="split":
        y=shell(4.74,4.32,2.72,4.95,-.73,TILE,PLASTER[2],.46)
        shell(2.48,2.75,2.93,3.98,.61,SAGE,PLASTER[1],0,2.43,.59,False)
        porch(.46,y,3.25,2.22,TILE)
        chimney(-1.21,1.1,3.6)
    elif kind=="loft":
        y=shell(4.54,4.9,4.11,5.75,.16,TILE,PLASTER[1],-.85)
        for x in [-1.18,1.18]:
            pane("Upper floor shutter",x,y-.10,3.31,.73,.96)
        porch(.17,y,3.82,2.48,SAGE)
        chimney(1.63,1.26,4.3)
    elif kind=="shed":
        y=shell(3.74,3.22,2.17,3.42,.64,SAGE,PLASTER[2],-.59)
        for i in range(12):
            block("Clapboard",(1.885,.0,.48+i*.13),(.11,3.24,.11),WOOD[(i//3)%3],.011)
        porch(-.6,y,1.96,1.93,TILE)
    elif kind=="wing":
        y=shell(4.48,3.87,2.76,4.72,.38,SAGE,PLASTER[0],-.59)
        shell(2.60,4.15,2.62,3.96,-.21,TILE,PLASTER[2],0,2.08,.91,False)
        porch(-.6,y,2.71,2.30,SAGE)
        chimney(1.17,.64,3.18)
    else:
        y=shell(7.51,5.19,4.08,6.28,-.11,SAGE,PLASTER[0],0)
        shell(2.16,2.25,6.09,7.41,0,TILE,PLASTER[2],0,0,.31,False)
        porch(0,y,4.52,2.60,TILE)
        for x in [-2.25,2.25]:
            pane("High hall window",x,y-.084,3.31,.72,.92,False)
        chimney(2.3,.61,4.66)
    objects=[obj for obj in bpy.context.scene.objects if obj not in before]
    deps=bpy.context.evaluated_depsgraph_get()
    batches={}
    for obj in objects:
        ev=obj.evaluated_get(deps)
        mesh=ev.to_mesh()
        for polygon in mesh.polygons:
            mat=mesh.materials[polygon.material_index]
            verts,faces=batches.setdefault(mat,([],[]))
            begin=len(verts)
            verts.extend(tuple(obj.matrix_world@mesh.vertices[i].co) for i in polygon.vertices)
            faces.append(tuple(range(begin,len(verts))))
        ev.to_mesh_clear()
    bpy.ops.object.select_all(action="DESELECT")
    export=[]
    for mat,(verts,faces) in batches.items():
        obj=geo(kind+" "+mat.name,verts,faces,mat)
        if obj.type == "MESH":
            # Keep hard architectural edges but weld duplicates within each material batch.
            mesh = bmesh.new()
            mesh.from_mesh(obj.data)
            bmesh.ops.remove_doubles(mesh, verts=list(mesh.verts), dist=.00002)
            mesh.to_mesh(obj.data)
            mesh.free()
        obj.select_set(True)
        export.append(obj)
    bpy.ops.export_scene.gltf(filepath=str(DEST/(kind+".glb")),export_format="GLB",use_selection=True)
    for obj in export:
        bpy.data.objects.remove(obj,do_unlink=True)
    for obj in objects:
        obj.location.x += len(MASTERS)*13.0
    MASTERS.append(objects)
bpy.context.preferences.filepaths.save_version=0
bpy.ops.wm.save_as_mainfile(filepath=str(SOURCE/"village_a_exteriors.blend"))
