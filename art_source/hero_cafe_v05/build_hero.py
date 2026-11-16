"""Original Forest Post Café architectural asset. Blender 4.3+, metres.
Run: blender --background --python art_source/hero_cafe_v05/build_hero.py
Source coordinates follow Godot XYZ (Y up); convert into Blender Z up below.
Editable scene is saved BEFORE derived export objects are joined by semantic group.
"""
import bpy, bmesh, math, random, json
from pathlib import Path
from mathutils import Vector, Matrix
ROOT=Path(__file__).resolve().parents[2]
OUT=ROOT/'assets/hero_cafe'
SOURCE=Path(__file__).resolve().parent
rng=random.Random(52025)
bpy.ops.object.select_all(action='SELECT');bpy.ops.object.delete(use_global=False)
for block in list(bpy.data.materials):bpy.data.materials.remove(block)
scene=bpy.context.scene
scene.unit_settings.system='METRIC'
scene.unit_settings.scale_length=1
collections={};objects=[];mesh_cache={}

def P(p):return Vector((p[0],-p[2],p[1]))
def mat(name,color,rough=.75,metal=0,emission=0,alpha=1):
 m=bpy.data.materials.new(name);m.use_nodes=True
 bs=m.node_tree.nodes.get('Principled BSDF')
 bs.inputs['Base Color'].default_value=(*color,alpha)
 bs.inputs['Roughness'].default_value=rough;bs.inputs['Metallic'].default_value=metal
 if emission:
  bs.inputs['Emission Color'].default_value=(*color,1);bs.inputs['Emission Strength'].default_value=emission
 if alpha<1:
  bs.inputs['Alpha'].default_value=alpha;m.surface_render_method='DITHERED'
 m.diffuse_color=(*color,alpha)
 return m

def variants(name,color,count=5,rough=.75):
 out=[]
 for i in range(count):
  f=1+(i-(count-1)/2)*.035
  out.append(mat(f'{name}_{i+1:02}',tuple(min(1,c*f) for c in color),rough+(i%3-1)*.025))
 return out
wood=variants('WarmTimber',(.43,.255,.125),5,.73)
frame=variants('StructuralOak',(.20,.105,.048),3,.68)
roofmat=variants('MossRoof',(.16,.255,.145),7,.83)
stone=variants('FoundationStone',(.34,.36,.31),4,.93)
floor=variants('PorchBoards',(.48,.32,.175),4,.72)
cream=mat('WarmCreamPlaster',(.72,.64,.48),.92)
trim=mat('PaintedSageTeal',(.20,.34,.29),.67)
metal=mat('WeatheredIron',(.095,.11,.10),.53,.55)
brass=mat('AgedBrass',(.44,.31,.12),.43,.62)
glass=mat('WarmWindowGlass',(.72,.48,.19),.22,0,.25,.14)
lamp=mat('LanternGlass',(.98,.56,.18),.27,0,.7)
inside=mat('InteriorCream',(.55,.40,.24),.89)
ceramic=mat('CreamCeramic',(.78,.72,.58),.36)
coral=mat('PostalCoral',(.55,.18,.12),.76)
coffee=mat('Coffee',(.045,.02,.008),.45)


def collection(group):
 if group not in collections:
  c=bpy.data.collections.new(group);scene.collection.children.link(c);collections[group]=c
 return collections[group]
def link(mesh,name,at,material,group):
 obj=bpy.data.objects.new(name,mesh);collection(group).objects.link(obj)
 obj.location=P(at);objects.append(obj)
 if len(mesh.materials)==0:mesh.materials.append(material)
 obj.material_slots[0].link='OBJECT';obj.material_slots[0].material=material
 return obj

def beveled_mesh(size,bevel=.02,segments=2):
 # Physical bevel topology, not a shading-only effect. Meshes shared across repeated shingles.
 key=(tuple(round(v,5) for v in size),round(bevel,5),segments)
 if key in mesh_cache:return mesh_cache[key]
 bm=bmesh.new();bmesh.ops.create_cube(bm,size=1)
 for v in bm.verts:v.co.x*=size[0];v.co.y*=size[2];v.co.z*=size[1]
 if bevel>0:
  bmesh.ops.bevel(bm,geom=list(bm.edges),offset=min(bevel,min(size)*.24),segments=segments,affect='EDGES',profile=.5)
 bm.normal_update();mesh=bpy.data.meshes.new('ChamferedTimber');bm.to_mesh(mesh);bm.free()
 mesh_cache[key]=mesh;return mesh

def box(name,at,size,material,group,bevel=.02):
 return link(beveled_mesh(size,bevel,1 if name in ["LayeredShingle","PorchCanopy","BelowWindow","SideSiding","RearSiding"] else 2),name,at,material,group)
def beam(name,a,b,w,d,material,group):
 pa,pb=P(a),P(b);length=(pb-pa).length
 obj=box(name,(0,0,0),(w,length,d),material,group,min(w,d)*.12)
 # Mesh vertical axis is Blender Z, corresponding to source Y.
 obj.location=(pa+pb)/2;obj.rotation_mode='QUATERNION';obj.rotation_quaternion=(pb-pa).to_track_quat('Z','Y')
 return obj

def cylinder(name,at,r,depth,material,group,vertices=12):
 bm=bmesh.new();bmesh.ops.create_cone(bm,cap_ends=True,cap_tris=False,segments=vertices,radius1=r,radius2=r,depth=depth)
 mesh=bpy.data.meshes.new(name);bm.to_mesh(mesh);bm.free()
 return link(mesh,name,at,material,group)

def mesh_obj(name,verts,faces,material,group):
 mesh=bpy.data.meshes.new(name);mesh.from_pydata([P(v) for v in verts],[],faces);mesh.update()
 return link(mesh,name,(0,0,0),material,group)

def arch(name,cx,bottom,z,width,height,depth,material,group):
 r=width/2;shoulder=height-r
 outline=[(-r,0),(r,0),(r,shoulder)]
 for i in range(1,13):
  a=i*math.pi/12;outline.append((r*math.cos(a),shoulder+r*math.sin(a)))
 verts=[(cx+x,bottom+y,z+s*depth/2) for s in [-1,1] for x,y in outline]
 n=len(outline);faces=[tuple(range(n-1,-1,-1)),tuple(range(n,n*2))]
 faces += [(i,(i+1)%n,(i+1)%n+n,i+n) for i in range(n)]
 return mesh_obj(name,verts,faces,material,group)

def sign(name,at,text,width):
 box(name,at,(width,.52,.12),trim,'Signage',.045)
 for x in [-width/2+.12,width/2-.12]:
  box('SignCorner',(at[0]+x,at[1],at[2]+.075),(.045,.38,.04),brass,'Signage',.008)
 curve=bpy.data.curves.new(text,'FONT');curve.body=text;curve.align_x='CENTER';curve.align_y='CENTER';curve.size=.22;curve.extrude=.004;curve.bevel_depth=.0015
 obj=bpy.data.objects.new('Lettering',curve);collection('Signage').objects.link(obj)
 obj.location=P((at[0],at[1],at[2]+.075));obj.rotation_euler=(math.pi/2,0,0)
 curve.materials.append(cream);objects.append(obj)

def cup(x,y,z):
 cylinder('Cup',(x,y+.085,z),.07,.17,ceramic,'InteriorCafe')
 cylinder('CoffeeSurface',(x,y+.174,z),.056,.005,coffee,'InteriorCafe')
 # Small sculpted handle ring; source remains editable mesh.
 bpy.ops.mesh.primitive_torus_add(major_segments=12,minor_segments=6,location=P((x+.075,y+.09,z)),major_radius=.045,minor_radius=.012)
 o=bpy.context.object;o.name='CupHandle';o.rotation_euler=(math.pi/2,0,0)
 for c in list(o.users_collection):c.objects.unlink(o)
 collection('InteriorCafe').objects.link(o);o.data.materials.append(ceramic);objects.append(o)

def table(x,z):
 cylinder('CafeTableTop',(x,1.12,z),.52,.10,floor[2],'PorchFurniture',16)
 cylinder('TablePedestal',(x,.75,z),.075,.66,frame[1],'PorchFurniture')
 for dx,dz in [(-.32,0),(.32,0),(0,-.32),(0,.32)]:beam('TableFoot',(x,.43,z),(x+dx,.43,z+dz),.075,.075,frame[1],'PorchFurniture')
 cup(x-.15,1.18,z+.08);cup(x+.13,1.18,z-.08)

def chair(x,z,flip=1):
 box('ChairSeat',(x,.85,z),(.48,.10,.46),floor[1],'PorchFurniture',.025)
 for dx in [-.18,.18]:
  for dz in [-.17,.17]:beam('ChairLeg',(x+dx,.4,z+dz),(x+dx,.81,z+dz),.055,.055,frame[1],'PorchFurniture')
 for dx in [-.18,.18]:beam('ChairBackPost',(x+dx,.8,z+.20*flip),(x+dx,1.42,z+.20*flip),.055,.055,frame[1],'PorchFurniture')
 for y in [1.12,1.34]:box('ChairBackSlat',(x,y,z+.20*flip),(.43,.085,.055),wood[2],'PorchFurniture',.012)

def lantern(x,y,z):
 box('LanternBracket',(x,y+.29,z-.12),(.1,.1,.33),metal,'Hardware',.015)
 box('LanternGlow',(x,y,z),(.16,.24,.15),lamp,'LanternGlass',.015)
 for dx in [-.11,.11]:
  for dz in [-.10,.10]:box('LanternCage',(x+dx,y,z+dz),(.022,.30,.022),metal,'Hardware',.005)
 box('LanternBase',(x,y-.16,z),(.29,.055,.27),metal,'Hardware',.015)
 box('LanternCap',(x,y+.16,z),(.31,.06,.29),metal,'Hardware',.02)

# Foundation: distinct cut stones along the main hall / wing, not a single slab.
for x0,width,depth in [(-3,9,11),(4.5,6,8)]:
 for row in range(2):
  for i in range(int(width/.6)):
   x=x0-width/2+.3+i*.6
   box('CutStone',(x,.12+row*.16,.02),(.57,.18,.38),stone[(i+row)%4],'StoneFoundation',.035)
  for side in [-1,1]:
   for i in range(int(depth/.65)):
    box('CutStone',(x0+side*(width/2-.1),.12+row*.16,-.32-i*.65),(.38,.18,.61),stone[(i+row+1)%4],'StoneFoundation',.03)

# Wall siding with modeled board edges and restrained color variation.
for x0,width,depth,top in [(-3,9,11,3.6),(4.5,6,8,3.35)]:
 for row in range(17):
  y=.47+row*.178
  if y>top-.12:continue
  box('RearSiding',(x0,y,-depth),(width,.163,.13),wood[row%5],'WallSiding',.012)
  for side in [-1,1]:
   box('SideSiding',(x0+side*width/2,y,-depth/2),(.13,.163,depth),wood[(row+1)%5],'WallSiding',.012)
 # Front bays leave the real apertures open.
 for row in range(3):box('BelowWindow',(x0 if x0>0 else -4.5,.47+row*.15,0), (6,.135,.15),wood[row%5],'WallSiding',.014)
 for row in range(3):box('AboveWindow',(x0 if x0>0 else -4.5,3.10+row*.15,0),(6,.135,.15),wood[(row+2)%5],'WallSiding',.014)
 for side in [-1,1]:
  box('WindowSideBoard',((4.5 if x0>0 else -4.5)+side*2.6,1.95,0),(.8,2.16,.14),wood[2],'WallSiding',.018)
# Front central entrance surround and arched, paneled door.
for x in [-1.1,1.1]:box('DoorSideWall',(x,1.86,0),(.72,3.02,.17),wood[1],'WallSiding',.02)
box('DoorLintelWall',(0,3.24,0),(3,.28,.17),cream,'WallSiding',.018)
arch('door',0,.38,.10,1.20,2.25,.14,trim,'door')
for x in [-.39,-.13,.13,.39]:box('DoorPanel',(x,1.25,.195),(.235,1.38,.045),wood[2],'DoorDetails',.025)
arch('DoorFanlight',0,1.86,.18,.91,.66,.026,glass,'WindowGlass')
for x in [-.72,.72]:box('DoorJamb',(x,1.5,.17),(.14,2.34,.25),frame[1],'StructuralFrame',.025)
# Arch casing made of individual curved voussoir segments, with mortise-like blocks.
for i in range(14):
 a=(i+.5)*math.pi/14
 x=math.cos(a)*.70;y=2.03+math.sin(a)*.70
 o=box('ArchCasing',(x,y,.19),(.18,.16,.24),wood[2],'StructuralFrame',.02);o.rotation_euler[1]=0
 # In Godot front plane, local beam tangent follows the arc.
 o.rotation_euler=(0,-a-math.pi/2,0)
cylinder('DoorKnob',(.41,1.42,.26),.045,.05,brass,'Hardware').rotation_euler=(math.pi/2,0,0)
box('DoorKnobPlate',(.41,1.42,.21),(.12,.24,.025),metal,'Hardware',.025)

# Major timber frames and joints.
for x in [-7.5,-1.5,1.5,7.5]:
 box('CornerPost',(x,1.98,.04),(.23,3.26,.25),frame[1],'StructuralFrame',.03)
 for y in [.58,3.32]:box('JointCollar',(x,y,.07),(.29,.11,.29),metal,'Hardware',.015)
for x0,w in [(-3,9),(4.5,6)]:box('WallPlate',(x0,3.55 if x0<0 else 3.30,.03),(w+.28,.22,.30),frame[1],'StructuralFrame',.025)

# Recessed windows: reveal boards, interior furnishings, lattice and glass in depth.
for cx,cafe in [(-4.5,True),(4.5,False)]:
 group='InteriorCafe' if cafe else 'InteriorPost'
 box('RoomBack',(cx,1.93,-1.8),(4.15,2.18,.12),inside,group,.02)
 box('RoomFloor',(cx,.85,-.88),(4.24,.12,1.9),floor[1],group,.02)
 for side in [-1,1]:
  box('WindowReveal',(cx+side*2.15,1.94,-.62),(.14,2.24,1.5),wood[1],'WindowFrames',.02)
 for dx in [-2.18,-.72,.72,2.18]:box('WindowMullion',(cx+dx,1.95,.12),(.095,2.30,.16),trim,'WindowFrames',.018)
 for y in [.84,2.96]:box('WindowSill',(cx,y,.16),(4.55,.15,.37),trim,'WindowFrames',.025)
 for dx in [-1.45,0,1.45]:box('RecessedGlass',(cx+dx,1.95,-.12),(1.32,1.96,.018),glass,'WindowGlass',.002)
 if cafe:
  box('CoffeeCounter',(cx,1.25,-1.12),(3.45,.64,.60),wood[1],group,.035)
  box('CounterStone',(cx,1.61,-1.12),(3.62,.10,.70),stone[2],group,.03)
  box('CoffeeMachine',(cx-.75,1.94,-1.15),(.58,.53,.38),metal,group,.06)
  for dx in [-1.2,.65,1.1]:cup(cx+dx,1.67,-1.03)
  for yy in [2.15,2.57]:
   box('CupShelf',(cx+.65,yy,-1.55),(1.7,.075,.24),frame[1],group,.012)
   for dx in [0,.35,.7]:cup(cx+.15+dx,yy+.045,-1.5)
 else:
  for yy in [1.25,1.78,2.31]:box('SortingShelf',(cx,yy,-1.20),(3.5,.085,.72),frame[1],group,.012)
  for dx in [-1.7,-.56,.56,1.7]:box('SortingDivider',(cx+dx,1.83,-1.2),(.07,1.55,.72),wood[2],group,.012)
  for i in range(6):
   x=cx-1.25+(i%3)*1.12;y=1.48+(i//3)*.55
   box('Parcel',(x,y,-1.0),(.62,.35,.42),floor[i%4],group,.022)
   box('ParcelTie',(x,y+.18,-1.0),(.045,.016,.43),cream,group,.004)

# Porch deck, stair/ramp surface, balustrades and structural bracing.
box('PorchUnderside',(0,.19,2),(15.6,.34,4),frame[0],'StoneFoundation',.025)
for i in range(32):
 x=-7.55+i*.487
 box('PorchDeck',(x,.335,2),(.465,.055,4.02),floor[i%4],'PorchDeck',.015)
 for z in [.3,3.7]:cylinder('BoardPeg',(x,.367,z),.012,.006,metal,'Hardware',8)
for x in [-7.3,-3.9,3.9,7.3]:
 box('VerandaPost',(x,1.78,3.3),(.22,2.84,.22),frame[1],'StructuralFrame',.03)
 for side in [-1,1]:beam('KneeBrace',(x,2.45,3.3),(x+side*.6,3.1,3.3),.12,.13,wood[1],'StructuralFrame')
 box('PostShoe',(x,.51,3.3),(.29,.26,.29),metal,'Hardware',.02)
for left,right in [(-7.3,-2.0),(2.0,7.3)]:
 for y in [.63,1.20]:box('PorchRail',((left+right)/2,y,3.78),(right-left,.11,.12),wood[2],'PorchRails',.025)
 count=int((right-left)/.38)
 for i in range(count):
  x=left+.2+i*(right-left-.4)/max(1,count-1)
  box('Baluster',(x,.91,3.78),(.055,.58,.055),frame[1],'PorchRails',.012)
# Side railings are functional at walking height.
for side in [-1,1]:
 for y in [.63,1.2]:box('SideRail',(side*7.5,y,2),( .12,.11,3.5),wood[2],'PorchRails',.02)
 for i in range(9):box('SideBaluster',(side*7.5,.91,.5+i*.38),(.055,.58,.055),frame[1],'PorchRails',.01)
# Authored wooden access ramp, with physical collision retained separately in Godot.
mesh_obj('PorchRamp',[(-1.4,.36,3.8),(1.4,.36,3.8),(1.4,0,5.4),(-1.4,0,5.4),(-1.4,.18,3.8),(1.4,.18,3.8),(1.4,-.08,5.4),(-1.4,-.08,5.4)],[(0,3,2,1),(4,5,6,7),(0,1,5,4),(3,7,6,2),(0,4,7,3),(1,2,6,5)],floor[1],'PorchRamp')
# Broad stone approach flanks the separately preserved walkable ramp.
for side in [-1,1]:
 for i in range(3):box('StoneStep',(side*1.78,.07+i*.055,5.15-i*.35),(.65,.15,.42),stone[(i+1)%4],'StoneFoundation',.035)

# Layered roofing. Roof boards are oriented on the actual pitch; no giant single-color plane.
def pitched_roof(group,cx,cz,width,length,eave,ridge,axis='z',tile=.67):
 half=width/2;rise=ridge-eave;slope=math.hypot(half,rise)
 rows=math.ceil(slope/.48);cols=math.ceil(length/tile)
 def point(side,t,along,offset=0):
  # t=0 at ridge, t=1 at eaves. Small lift keeps individual shingle courses layered.
  across=side*half*t;y=ridge-rise*t+offset
  return (cx+across,y,cz+along) if axis=='z' else (cx+along,y,cz+across)
 for side in [-1,1]:
  # Thick underlying deck and layered shingle courses, including overhang.
  a=point(side,0,-length/2);b=point(side,1,-length/2);c=point(side,0,length/2);d=point(side,1,length/2)
  mesh_obj('RoofDeck',[a,b,d,c],[(0,1,2,3)],roofmat[0],group)
  for row in range(rows):
   t=(row+.5)/rows
   for col in range(cols):
    along=-length/2+(col+.5)*length/cols
    jitter=(rng.random()-.5)*.025
    center=point(side,t,along,.035+jitter)
    # A board's Y axis follows pitch; Z follows the ridge.
    obj=box('LayeredShingle',center,(slope/rows+.075,.065,length/cols-.025),roofmat[(row*3+col+rng.randrange(3))%7],group,.014)
    across=P((1,-side*rise/half,0) if axis=='z' else (0,-side*rise/half,1)).normalized()
    along_axis=P((0,0,-1) if axis=='z' else (1,0,0))
    normal=across.cross(along_axis).normalized()
    obj.rotation_mode='QUATERNION'
    obj.rotation_quaternion=Matrix((across,along_axis,normal)).transposed().to_quaternion()
  for along in [-length/2,length/2]:beam('RoofEdgeTrim',point(side,0,along,.04),point(side,1,along,.04),.13,.16,wood[1],group)
  beam('EaveFascia',point(side,1,-length/2),point(side,1,length/2),.16,.22,frame[1],group)
 # Ridge caps are individually overlapped, with visible thickness.
 for i in range(math.ceil(length/.65)):
  along=-length/2+(i+.5)*length/math.ceil(length/.65)
  at=(cx,ridge+.085,cz+along) if axis=='z' else (cx+along,ridge+.085,cz)
  box('RidgeCap',at,(.24,.16,.69) if axis=='z' else (.69,.16,.24),roofmat[3],group,.035)
 # Solid gable infill, its visible truss reads from the approach.
 for end in [-1,1]:
  along=end*(length/2-.12)
  verts=[point(-1,1,along),point(1,1,along),point(1,0,along)]
  mesh_obj('GableInfill',verts,[(0,1,2),(2,1,0)],cream,group)
  for side in [-1,1]:beam('GableTruss',point(side,1,along,.01),point(side,0,along,.01),.16,.18,frame[1],'StructuralFrame')
  p=point(1,0,along);bottom=(p[0],eave,p[2]);beam('KingPost',bottom,p,.14,.14,frame[1],'StructuralFrame')
  beam('CollarTie',point(-1,.56,along),point(1,.56,along),.12,.14,wood[1],'StructuralFrame')
  middle=(p[0],eave+(ridge-eave)*.58,p[2])
  for side in [-1,1]:beam('GableDiagonal',point(side,.92,along),middle,.105,.125,wood[1],'StructuralFrame')

pitched_roof('MainHallRoof',-3,-5.5,10.2,12.1,3.60,7.0)
pitched_roof('PostalWingRoof',4.5,-4,8.9,6.8,3.35,5.75,axis='x')
# Porch shed roof strips, a lighter construction than the main pitched volumes.
for i in range(25):
 x=-7.8+(i+.5)*15.6/25
 o=box('PorchCanopy',(x,3.03,1.02),(.605,.11,2.55),roofmat[i%7],'EntryRoof',.02)
 o.rotation_euler[0]=-.12
box('CanopyFascia',(0,2.90,2.32),(15.9,.17,.15),wood[2],'StructuralFrame',.02)
pitched_roof('EntryRoof',0,2.4,3.6,3.7,3.05,4.28)
# Dormer is a coherent little framed volume, not a float-on roof patch.
box('DormerFace',(.45,5.15,-5.5),(.16,1.55,2.15),cream,'WallSiding',.025)
for z in [-6.55,-4.45]:box('DormerPost',(.56,5.15,z),(.19,1.65,.13),frame[1],'StructuralFrame',.018)
pitched_roof('DormerRoof',-.25,-5.5,2.85,3.0,5.85,6.87,axis='x',tile=.55)
# Masonry chimney with brick courses, cap and interior opening.
for row in range(8):
 for i in range(3):box('ChimneyBrick',(-5.35+(i-1)*.22,5.55+row*.19,-8.15),(.21,.18,.70),stone[(row+i)%4],'StoneFoundation',.02)
box('ChimneyCap',(-5.35,7.12,-8.15),(.90,.18,.88),stone[0],'StoneFoundation',.035)
box('ChimneyFlue',(-5.35,7.22,-8.15),(.44,.04,.43),metal,'Hardware',.01)

# Operational details are arranged by use, not scattered as filler.
for x in [-5.8,-3.6]:
 table(x,2.1);chair(x,1.15,-1);chair(x,3.12,1)
for x in [-6.3,-1.65,1.65,6.3]:lantern(x,2.65,.65)
for x in [-1.45,1.45]:lantern(x,2.62,3.18)
sign('CafeSign',(-4.5,3.12,.26),'WOODLAND CAFE',3.7)
sign('PostSign',(4.5,3.12,.26),'FOREST POST',3.7)
sign('EntrySign',(0,3.48,4.36),'FOREST POST CAFE',2.55)
for x in [-.9,.9]:beam('SignHanger',(x,3.75,4.36),(x,4.02,4.10),.028,.028,metal,'Hardware')
for i in range(4):
 x=3.8+i*.65
 box('Parcel',(x,.62,1.75),(.57,.46+i%2*.12,.46),floor[i%4],'InteriorPost',.022)
 box('ParcelTape',(x,.86+i%2*.06,1.75),(.055,.02,.47),cream,'InteriorPost',.005)
# Wrought fittings anchor posts and roof corners, catching bevel highlights.
for x in [-7.3,-3.9,3.9,7.3]:
 for y in [.58,2.88]:
  box('IronStrap',(x,y,3.42),(.29,.10,.025),metal,'Hardware',.012)
  for dx in [-.09,.09]:cylinder('StrapBolt',(x+dx,y,3.45),.022,.025,brass,'Hardware',8).rotation_euler=(math.pi/2,0,0)

# Save the editable source before the export-only flattening stage.
scene['asset_spec']='spec.json';scene['source_axis']='Godot metres converted to Blender Z-up'
scene['authorship']='Original project-authored building; no third-party building meshes.'
# Source viewport / basic studio light are for editing, not claimed as Godot screenshots.
bpy.ops.object.camera_add(location=(22,-27,16));cam=bpy.context.object;cam.name='SourceReviewCamera';scene.camera=cam
cam.rotation_euler=(P((-1,3,-2))-cam.location).to_track_quat('-Z','Y').to_euler();cam.data.lens=50
bpy.ops.object.light_add(type='SUN',location=(5,-8,12));sun=bpy.context.object;sun.rotation_euler=(.6,-.4,-.5);sun.data.energy=2
bpy.context.preferences.filepaths.save_version=0
bpy.ops.wm.save_as_mainfile(filepath=str(SOURCE/'hero_cafe_v05.blend'),check_existing=False)
# Derived game export: duplicate and join by semantic group. Originals stay in the saved blend.
export=[]
for group,col in collections.items():
 for original in list(col.objects):
  if original.name==group:original.name='Editable_'+group
 copies=[]
 for original in list(col.objects):
  obj=original.copy();obj.data=original.data.copy();scene.collection.objects.link(obj)
  if obj.type=='FONT':
   bpy.ops.object.select_all(action='DESELECT');obj.select_set(True);bpy.context.view_layer.objects.active=obj
   bpy.ops.object.convert(target='MESH');obj=bpy.context.object
  copies.append(obj)
 bpy.ops.object.select_all(action='DESELECT')
 for o in copies:o.select_set(True)
 bpy.context.view_layer.objects.active=copies[0]
 bpy.ops.object.join();joined=bpy.context.object;joined.name=group
 # Export all semantic meshes at a common origin for straightforward engine measurements.
 bpy.context.scene.cursor.location=(0,0,0);bpy.ops.object.origin_set(type='ORIGIN_CURSOR')
 export.append(joined)
bpy.ops.object.select_all(action='DESELECT')
for o in export:o.select_set(True)
OUT.mkdir(exist_ok=True,parents=True)
bpy.ops.export_scene.gltf(filepath=str(OUT/'forest_post_cafe_v05.glb'),export_format='GLB',use_selection=True,export_yup=True,export_apply=True,export_extras=True,export_materials='EXPORT',export_cameras=False,export_lights=False)
triangles=sum(sum(len(p.vertices)-2 for p in o.data.polygons) for o in export)
report={'source_objects':len(objects),'export_meshes':len(export),'triangles':triangles,'materials':len(bpy.data.materials),'source':'art_source/hero_cafe_v05/hero_cafe_v05.blend','script':'art_source/hero_cafe_v05/build_hero.py','output':'assets/hero_cafe/forest_post_cafe_v05.glb','blender':bpy.app.version_string}
(SOURCE/'build_report.json').write_text(json.dumps(report,indent=2)+'\n')
print('HERO_BUILD_REPORT '+json.dumps(report))
