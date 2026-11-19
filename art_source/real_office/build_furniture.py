"""Author office-specific furniture for ENV-REAL-01. Blender axes Z up, -Y forward."""
import math
import sys
from pathlib import Path

import bpy
from mathutils import Vector

sys.dont_write_bytecode = True
sys.path.insert(0, str(Path(__file__).parent))
from build_colleagues import loft, mesh, pigment, taper

OUT = Path("assets/story/office_models")


def clear():
    bpy.ops.object.select_all(action="SELECT")
    bpy.ops.object.delete(use_global=False)


def rounded(name, pos, dimensions, mat, bevel=.012, segments=2):
    bpy.ops.mesh.primitive_cube_add(size=1, location=pos)
    obj = bpy.context.object
    obj.name = name
    obj.dimensions = dimensions
    bpy.ops.object.transform_apply(location=False, rotation=False, scale=True)
    obj.data.materials.append(mat)
    edge = obj.modifiers.new("Eased edges", "BEVEL")
    edge.width = bevel
    edge.segments = segments
    edge.affect = "EDGES"
    normal = obj.modifiers.new("Broad planar normals", "WEIGHTED_NORMAL")
    normal.keep_sharp = True
    return obj


def export(name):
    bpy.ops.export_scene.gltf(filepath=str(OUT / (name + ".glb")), export_format="GLB",
                             export_animations=False, export_apply=True)


graphite = pigment("Graphite hardware", "384745")
dark = pigment("Dark textile", "344743")
teal = pigment("Woven sage fabric", "647E72")
trim = pigment("Rib and seam", "7D9587")
walnut = pigment("Quarter-sawn walnut", "946044")
edge_wood = pigment("Walnut edge", "714A39")
brass = pigment("Brushed brass", "B88C51")
enamel = pigment("Oxide red enamel", "AE5140")
ivory = pigment("Ivory shade lining", "FFF0CF")
milk = pigment("Ceramic cream", "ECDDBB")
coffee = pigment("Coffee", "4B2E22")
plant_pot = pigment("Matte terracotta", "9E6048")
plant_soil = pigment("Potting mix", "514031")
green = [pigment("Rubber plant " + str(i), rgb) for i, rgb in enumerate(
    ["527860", "375D50", "6D8868", "3D6C57"])]


def chair():
    clear()
    # Five radial struts tie into a pneumatic column. Upholstery silhouettes
    # are lofted, with a gentle waist and shoulder roll.
    for i in range(5):
        a = math.tau * i / 5
        d = Vector((math.cos(a), math.sin(a), 0))
        taper("Wheel strut", [(0, 0, .11), tuple(d * .21 + Vector((0, 0, .083))),
              tuple(d * .302 + Vector((0, 0, .049)))], [.024, .021, .016], graphite)
        wheel = rounded("Caster wheel", tuple(d * .301 + Vector((0, 0, .026))),
                        (.044, .047, .052), dark, .011)
        wheel.rotation_euler.z = a
    loft("Pneumatic column", [(.08,0,0,.047,.047),(.30,0,0,.039,.039),(.43,0,0,.023,.023)], graphite)
    seat = rounded("Seat cushion", (0,-.027,.457), (.495,.48,.095), teal,.047,3)
    rounded("Seat pan seam", (0,-.027,.428), (.48,.467,.028), dark,.014)
    for sign in (-1,1):
        taper("Backrest attachment", [(sign*.146,.135,.415),(sign*.158,.231,.545),
              (sign*.155,.235,.713)], [.017,.017,.014], graphite)
    loft("Sculpted backrest", [(.563,0,.217,.162,.038),(.612,0,.219,.192,.047),
        (.685,0,.235,.203,.046),(.794,0,.246,.232,.046),(.897,0,.247,.220,.041),
        (.947,0,.243,.168,.028)],teal,14,True)
    for side in (-1,1):
        taper("Upholstery piping",[(side*.143,.192,.589),(side*.180,.195,.652),
              (side*.198,.207,.768),(side*.200,.216,.855),(side*.171,.221,.911)],
              [.004,.004,.004,.004,.004],trim,6)
    export("work_chair")


def desk():
    clear()
    rounded("Solid walnut top", (0,0,.782), (2.25,.94,.068), walnut,.019,3)
    rounded("Aged edge below the top", (0,0,.752), (2.20,.907,.018), edge_wood,.008)
    for side in (-1,1):
        for fore in (-1,1):
            taper("Tapered metal leg",[(side*.973,fore*.375,.015),(side*.935,fore*.335,.16),
                  (side*.874,fore*.309,.737)],[.023,.027,.035],graphite,8)
        rounded("Trestle bar",(side*.89,0,.615),(.037,.66,.04),graphite,.007)
    rounded("Shallow drawer",(-.68,.035,.696),(.397,.55,.096),edge_wood,.012)
    rounded("Inset drawer pull",(-.68,-.249,.698),(.131,.014,.021),brass,.005)
    export("walnut_workstation")


def lamp():
    clear()
    loft("Weighted foot",[(.0,0,0,.105,.105),(.015,0,0,.108,.108),(.034,0,0,.094,.094)],enamel,16,True)
    taper("Lower brass arm",[(0,0,.019),(.028,.04,.263)], [.013,.013],brass,10)
    taper("Upper brass arm",[(.028,.04,.263),(-.050,-.127,.410)], [.013,.012],brass,10)
    for pos in [(0,0,.034),(.028,.04,.263),(-.050,-.127,.410)]:
        rounded("Pivot cap",pos,(.039,.038,.044),enamel,.012)
    loft("Spun metal shade",[(.337,-.048,-.15,.101,.101),(.350,-.048,-.15,.105,.105),
        (.385,-.048,-.147,.093,.093),(.426,-.048,-.140,.067,.067),(.446,-.048,-.129,.042,.042)],
        enamel,18,True)
    loft("Ivory diffuser",[(.335,-.048,-.15,.090,.090),(.341,-.048,-.15,.091,.091)],ivory,18,True)
    export("desk_lamp")


def mug():
    clear()
    count = 18
    rings = [(0,.034),(.012,.039),(.071,.046),(.084,.049),(.088,.047),(.084,.040),(.025,.032)]
    vertices = [(r*math.cos(i*math.tau/count), r*math.sin(i*math.tau/count), z)
                for z,r in rings for i in range(count)]
    faces = [tuple(reversed(range(count)))]
    for row in range(len(rings)-1):
        faces.extend((row*count+i, row*count+(i+1)%count, (row+1)*count+(i+1)%count, (row+1)*count+i)
                     for i in range(count))
    faces.append(tuple(range((len(rings)-1)*count,len(rings)*count)))
    mesh("Thrown ceramic cup",vertices,faces,milk,True)
    loft("Coffee",[(.047,0,0,.035,.035),(.049,0,0,.040,.040)],coffee,18)
    handle = [(.040+.033*math.sin(i*math.pi/8),0,.072-.057*i/8) for i in range(9)]
    taper("Porcelain handle",handle,[.006]*9,milk,8)
    export("personal_mug")


def plant():
    clear()
    loft("Rounded ceramic planter",[(0,0,0,.145,.145),(.025,0,0,.16,.16),
        (.16,0,0,.172,.172),(.195,0,0,.183,.183),(.207,0,0,.176,.176)],plant_pot,14)
    loft("Soil",[(.201,0,0,.155,.155),(.204,0,0,.16,.16)],plant_soil,14)
    for index in range(7):
        h = .31 + (index * .096)
        theta = index * 2.399
        d = Vector((math.cos(theta),math.sin(theta),0))
        across = d.cross(Vector((0,0,1)))
        a = d*.042 + Vector((0,0,.205))
        b = d*.088 + Vector((0,0,h))
        taper("Stem", [tuple(a),tuple((a+b)*.5),tuple(b)],[.009,.006,.004],green[1],6)
        for sign in (-1,1):
            base = b - Vector((0,0,.030*(sign+1)))
            direction = (d*.87 + across*sign*.41).normalized()
            span = .19 + .038*(index%4)
            tip = base + direction*span + Vector((0,0,.065 if sign==1 else -.065))
            cross = direction.cross(Vector((0, 0, 1)))
            blade = [base]
            for t, width in ((.19,.045),(.42,.077),(.65,.070),(.83,.042)):
                center = base.lerp(tip, t) + Vector((0, 0, .040 * math.sin(math.pi * t)))
                blade.extend((center-cross*width, center+Vector((0,0,width*.27)), center+cross*width))
            blade.append(tip)
            faces = [(0,1,2),(0,2,3)]
            for row in range(3):
                first = 1 + row * 3
                faces.extend(((first,first+3,first+4,first+1), (first+1,first+4,first+5,first+2)))
            faces.extend(((10,13,11),(11,13,12)))
            leaf = mesh("Curved leaf", blade, faces, green[(index+sign+4)%4], True)
            mod = leaf.modifiers.new("Leaf surfaces","SOLIDIFY")
            mod.thickness = .0025
            taper("Midrib", [tuple(blade[j]) for j in (0,2,5,8,11,13)],
                  [.004,.0034,.0025,.002,.0013,.0004], green[2], 5)
    export("rubber_plant")


def monitor():
    clear()
    bezel = pigment("Graphite bezel", "3B4744")
    footing = pigment("Powder coated stand", "56615A")
    rounded("Monitor shell", (0,.282,1.177), (.87,.062,.48), bezel,.021,4)
    rounded("Stand upright",(0,.284,.971),(.066,.045,.271),footing,.012,3)
    rounded("Stand foot",(0,.269,.829),(.325,.195,.026),footing,.011,3)
    export("desk_monitor")


def mouse():
    clear()
    body = pigment("Sage mouse shell", "6C776C")
    seam = pigment("Soft rubber", "434A44")
    loft("Mouse body",[(0,0,0,.038,.053),(.008,0,0,.041,.056),(.021,0,.007,.036,.047),
        (.032,0,.012,.025,.035),(.036,0,.013,.014,.023)],body,16,True)
    wheel = rounded("Scroll wheel",(0,-.018,.032),(.012,.016,.012),seam,.004,3)
    wheel.rotation_euler.x = -.31
    export("desk_mouse")


def rounded_portal(width, bottom, top, radius, trim_width):
    def outline(w, low, high, corner):
        return [
            (sx * (w / 2 - corner) + corner * math.cos(math.radians(angle)),
             (high - corner if sz > 0 else low + corner) + corner * math.sin(math.radians(angle)))
            for sx, sz, start in ((1, 1, 0), (-1, 1, 90), (-1, -1, 180), (1, -1, 270))
            for angle in range(start, start + 91, 15)
        ]

    outside = outline(width, bottom, top, radius)
    inside = outline(width - 2 * trim_width, bottom + trim_width,
                     top - trim_width, radius - trim_width)
    count = len(outside)
    vertices = [(x, y, z) for y in (-.19, .14) for points in (outside, inside) for x, z in points]
    faces = []
    for index in range(count):
        nxt = (index + 1) % count
        faces.extend((
            (index, nxt, count + nxt, count + index),
            (2*count + nxt, 2*count + index, 3*count + index, 3*count + nxt),
            (index, 2*count + index, 2*count + nxt, nxt),
            (count + nxt, 3*count + nxt, 3*count + index, count + index),
        ))
    return mesh("Rolled metal alcove surround", vertices, faces, pigment("Oxidised steel", "32494A"))


def copy_alcove():
    clear()
    rounded_portal(3.18, .72, 2.77, .49, .094)
    base = pigment("Petrol cabinet paint", "425755")
    door = pigment("Raised cabinet panels", "4D625D")
    printer = pigment("Warm grey printer", "B6ABA0")
    printer_trim = pigment("Printer chassis", "555D54")
    copy_paper = pigment("Copy paper", "E4D8BB")
    rounded("Recessed cabinet", (0,-.115,.417),(2.99,.65,.66),base,.033,4)
    rounded("Washable oak counter", (0,-.18,.78),(3.12,.76,.092),walnut,.028,4)
    for index in range(3):
        x = (index - 1) * .97
        rounded("Overlay door",(x,-.456,.415),(.925,.044,.59),door,.020,3)
        rounded("Recessed brass pull",(x,-.482,.641),(.18,.019,.026),brass,.006,3)
    rounded("Printer main body",(-.62,-.26,.98),(.60,.47,.315),printer,.036,4)
    rounded("Matte output tray",(-.63,-.506,.91),(.45,.12,.112),printer_trim,.018,3)
    rounded("Document feeder",(-.60,-.24,1.148),(.58,.37,.054),printer_trim,.017,3)
    rounded("Printer control panel",(-.35,-.455,1.077),(.075,.066,.017),graphite,.004,2)
    rounded("Copy in output tray",(-.68,-.54,.976),(.25,.15,.006),copy_paper,.001,2)
    rounded("Undershelf diffuser",(0,-.031,2.59),(2.32,.097,.039),ivory,.01,3)
    export("copy_alcove")


def office_pendant():
    clear()
    rounded("Brushed graphite reflector", (0,0,0), (2.02,.38,.145), graphite,.069,5)
    rounded("Recessed opal lens",(0,0,-.067),(1.94,.295,.051),ivory,.025,5)
    for x in (-.67,.67):
        taper("Pendant wire",[(x,0,.03),(x,0,.30)],[.007,.007],graphite,6)
    export("office_pendant")


def meeting_table():
    clear()
    rounded("Rounded ash conference top",(0,0,.785),(2.39,1.18,.090),walnut,.043,5)
    rounded("Recessed panel below the table",(0,0,.734),(2.22,1.02,.048),edge_wood,.023,3)
    for side in (-1,1):
        for fore in (-1,1):
            taper("Tapered table support",[(side*.98,fore*.42,.025),(side*.91,fore*.34,.38),
                  (side*.78,fore*.30,.734)],[.035,.035,.055],graphite,9)
    export("meeting_table")


builders = (chair, desk, lamp, mug, plant, monitor, mouse, copy_alcove, office_pendant, meeting_table)
selected = sys.argv[sys.argv.index("--") + 1:] if "--" in sys.argv else []
for builder in builders:
    if not selected or builder.__name__ in selected:
        builder()
