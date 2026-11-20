"""Build the editable A1 house master and export the Godot art-gate asset."""
import math
import random
from pathlib import Path

import bpy
import bmesh
from mathutils import Vector

ROOT = Path(__file__).resolve().parents[2]
SOURCE = ROOT / "art_source/a1_house_gate"
DEST = ROOT / "assets/a1_house_gate"
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

# Main block and offset tall bay give the building three distinct roof silhouettes.
gable("Limewashed main envelope",-.48,5.16,-2.15,2.08,.39,3.24,5.27,-.38,PLASTER[0])
roof("Main clay roof",-.48,5.16,-2.55,2.44,3.17,5.34,-.38)
gable("Cross-gabled bay",1.78,2.48,-2.53,.20,.38,3.69,5.22,.14,PLASTER[1])
roof("Front cross gable",1.78,2.48,-2.83,.38,3.61,5.25,.14)
gable("Service wing",-3.05,1.37,-1.38,1.91,.29,2.04,2.85,-.26,PLASTER[2])
roof("Service wing",-3.05,1.37,-1.68,2.17,1.99,2.90,-.26)
for line,z in enumerate((.13,.35)):
    stone_course("Front plinth",-3.02,2.03,-2.10+.021*(line%2),z,10,.21)
    stone_course("Bay plinth",.57,2.98,-2.49,z,6,.20)
    stone_course("Garden wing plinth",-3.76,-2.37,-1.35,z,4,.20)
for x in [-2.95,-.80,.52,2.95]:
    y=-2.20 if x<.55 else -2.58
    timber("Load-bearing front post",(x,y,.41),(x+.024,y,3.2 if x<.55 else 3.68),.22,.18)
for a,b,y,z in [(-3.0,.63,-2.22,3.12),(.60,2.99,-2.59,3.60),(-3.0,.61,-2.22,.56),
                  (.61,2.99,-2.59,.57),(-3.0,.56,-2.22,2.42)]:
    timber("Front ledger",(a,y,z),(b,y,z+.02),.16,.17)
for a,b in [((.61,-2.575,3.63),(1.92,-2.575,5.12)),((2.98,-2.575,3.63),(1.92,-2.575,5.12)),
              ((1.92,-2.58,4.54),(1.92,-2.58,5.12)),((.70,-2.58,3.69),(1.18,-2.58,4.12)),
              ((2.93,-2.58,3.69),(2.49,-2.58,4.12)),
              ((-2.91,-2.23,3.06),(-2.41,-2.23,2.54)),((.49,-2.23,3.05),(.03,-2.23,2.58))]:
    timber("Pegged diagonal brace",a,b,.14,.154)
pane("Parlour",-1.99,-2.24,1.68,.84,1.03)
pane("Front bay",1.78,-2.60,1.73,1.01,1.18)
pane("Cross-gable loft",1.92,-2.59,4.14,.60,.69,False)
pane("West service",-3.22,-1.42,1.44,.46,.61,False)
pane("Upper main",-1.10,-2.21,3.57,.53,.62,False)

for side,x in [(-1,-3.06),(1,2.12)]:
    for row in range(2):
        for j in range(8):
            y=-1.91+j*.53+(row%2)*.07
            block("Return plinth stone",(x,y,.11+row*.21),(.23,.49,.20),STONE[(j+row)%4],.038)
    for y in [-1.38,.17,1.78]:
        timber("End-wall upright",(x,y,.42),(x,y,3.1 if side<0 else 3.28),.18,.19)
    for z in (.54,2.77):
        timber("End-wall sill",(x,-1.42,z),(x,1.89,z),.17,.17)
    for y in (.24,1.40):
        previous = set(bpy.context.collection.objects)
        pane("Garden side window",0,0,1.74,.61,.79,True)
        for obj in set(bpy.context.collection.objects)-previous:
            obj.rotation_euler.z=side*math.pi/2
            obj.location=(x,y,0)
        timber("Corner wind brace",(x,y-.45,2.69),(x,y-.78,2.29),.13,.14)

for y in [-2.42,-.06]:
    timber("Bay return post",(3.06,y,.40),(3.06,y,3.59),.19,.18)
for z in [.49,2.92,3.48]:
    timber("Bay return rail",(3.065,-2.49,z),(3.065,.07,z),.15,.17)
previous = set(bpy.context.collection.objects)
pane("Bay side lantern window",0,0,1.85,.66,1.01,True)
for obj in set(bpy.context.collection.objects)-previous:
    obj.rotation_euler.z=math.pi/2
    obj.location=(3.04,-1.17,0)
timber("Bay return wind brace",(3.07,-2.41,2.89),(3.07,-2.04,2.53),.13,.14)
for row in range(2):
    for j in range(5):
        block("Bay return stone",(3.05,-2.30+j*.50,.13+row*.21),(.23,.46,.20),STONE[(j+row)%4],.038)

# Arched door and porch construction.
door_x=-.49
arch=[(door_x-.57,.48),(door_x+.57,.48),(door_x+.57,1.91)]
arch += [(door_x+.57*math.cos(math.pi*i/6),1.91+.37*math.sin(math.pi*i/6)) for i in range(1,7)]
extrude("Swept door surround",arch,-2.22,.22,WOOD[0],.035)
for i in range(7):
    x=door_x+(i-3)*.132
    top=1.89+.31*math.sqrt(max(0,1-((x-door_x)/.51)**2))
    block("Tapered door stave",(x,-2.474,(top+.49)*.5),(.123,.047,top-.49),WOOD[i%4],.016)
for z in [.84,1.63]:
    block("Wrought strap",(door_x-.088,-2.51,z),(.70,.032,.061),IRON[0],.009)
faceted("Latch", (door_x+.28,-2.54,1.17),(.061,.039,.049),IRON[0],2)
for i,(z,d) in enumerate(((.10,.46),(.21,.69),(.31,.91))):
    block("Broad hewn step",(door_x,-3.48+i*.21,z),(1.72+i*.10,d,.155),STONE[i],.041)
block("Porch landing",(door_x,-2.78,.38),(2.06,1.07,.18),WOOD[1],.028)
for i in range(9):
    block("Porch floorboard",(door_x+(i-4)*.217,-2.78,.485),(.207,1.02,.043),WOOD[i%4],.01)
roof("Porch roof",door_x,2.15,-3.50,-2.07,2.39,2.95,-.13)
for x in [door_x-1.0,door_x+.98]:
    timber("Porch post",(x,-3.24,.47),(x+.016,-3.24,2.47),.16,.19)
    timber("Porch knee brace",(x,-3.24,1.94),(x+(.37 if x<door_x else -.39),-3.24,2.46),.11,.13)
    block("Porch shoe",(x,-3.24,.51),(.25,.25,.15),STONE[1],.026)

# Chimney masonry and handmade front garden pieces.
for course in range(11):
    z=3.74+course*.171
    stone_course("Chimney masonry",-.29,.42,.74,z,3 if course%2 else 2,.157)
    block("Chimney core",(.065,.58,z),(.62,.44,.168),STONE[3],.014)
block("Pitched chimney cap",(.065,.57,5.67),(.91,.80,.15),STONE[2],.047)
for x,y,z in [(-1.99,-2.43,1.07),(1.78,-2.83,1.08)]:
    block("Window flower trough",(x,y,z),(.96,.32,.21),WOOD[2],.042)
    blossoms(x,y,z+.09,6)
for x,y in [(2.67,-3.15),(-2.58,-3.05),(2.68,-3.55)]:
    faceted("Terracotta planter",(x,y,.20),(.30,.30,.235),TILE[2],2)
    blossoms(x,y,.34,7)
for idx in range(6):
    x=1.32+idx*.46
    y=-4.23+idx*.085
    timber("Hewn fence post",(x,y,.02),(x+.035,y,.81+rng.uniform(-.07,.06)),.112,.13)
    if idx<5:
        for h in (.30,.59):
            timber("Split fence rail",(x,y,h),(x+.48,y+.085,h+.028),.083,.092,TRIM[0])
for i in range(5):
    x=-1.17+rng.uniform(-.17,.17)
    y=-3.17
    z=.73+i*.095
    faceted("Cut log end",(x,y,z),(.092,.25,.075),TRIM[i%2],2)
for z in (1.85,2.06):
    block("Lantern collar",(.20,-3.26,z),(.19,.16,.05),IRON[0],.016)
block("Lantern warm core",(.20,-3.26,1.96),(.13,.114,.20),GLASS[1],.025)
for j in range(32):
    z=.21+j*.087
    x=2.75+.23*math.sin(j*.29)
    y=-2.66-.12*math.cos(j*.42)
    faceted("Climbing foliage",(x,y,z),(.14,.086,.072),rng.choice(LEAF),1)

# Buried stepping stones have an irregular plan and a deliberately flat tread.
for i in range(11):
    x=-.49+.07*i+math.sin(i*1.26)*.14
    y=-3.82-.49*i
    rim=[]
    for edge in range(7):
        angle=math.tau*edge/7+i*.39
        width=.33+rng.uniform(-.045,.09)
        depth=.22+rng.uniform(-.035,.04)
        rim.append((x+math.cos(angle)*width,y+math.sin(angle)*depth))
    vertices=[(px,py,z) for z in (-.045,.035+rng.random()*.014) for px,py in rim]
    faces=[tuple(range(7,14)),tuple(range(6,-1,-1))]+[(j,(j+1)%7,(j+1)%7+7,j+7) for j in range(7)]
    geo("Buried garden stepping stone",vertices,faces,STONE[i%3],.020)

# Save editable component objects, then batch a separate export by material.
bpy.context.preferences.filepaths.save_version = 0
bpy.ops.wm.save_as_mainfile(filepath=str(SOURCE / "hewn_eaves_cottage.blend"))
batches={}
deps=bpy.context.evaluated_depsgraph_get()
for obj in list(bpy.context.scene.objects):
    evaluated=obj.evaluated_get(deps)
    mesh=evaluated.to_mesh()
    for polygon in mesh.polygons:
        mat=mesh.materials[polygon.material_index]
        verts,faces=batches.setdefault(mat,([],[]))
        start=len(verts)
        verts.extend(tuple(obj.matrix_world@mesh.vertices[i].co) for i in polygon.vertices)
        faces.append(tuple(range(start,len(verts))))
    evaluated.to_mesh_clear()
bpy.ops.object.select_all(action="DESELECT")
for mat,(vertices,faces) in batches.items():
    geo(mat.name,vertices,faces,mat).select_set(True)
bpy.ops.export_scene.gltf(filepath=str(DEST / "hewn_eaves_cottage.glb"),
    export_format="GLB", use_selection=True, export_animations=False, export_yup=True)
