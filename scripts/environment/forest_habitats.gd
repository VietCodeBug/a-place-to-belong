extends Node3D
## Small authored habitats; no physics, quests or per-grass processing.
var weather: Node
var rabbits: Array[Node3D]=[]
var insects: Array[Node3D]=[]
const ANCHORS: Array[Vector2]=[Vector2(-11,8),Vector2(12,12),Vector2(-15,12)]
func material(color: String) -> StandardMaterial3D:
	var m:=StandardMaterial3D.new();m.albedo_color=Color(color);m.roughness=1.;m.cull_mode=BaseMaterial3D.CULL_DISABLED;return m
func ellipsoid(parent: Node3D,p: Vector3,size: Vector3,color: String) -> void:
	var node:=MeshInstance3D.new();var mesh:=SphereMesh.new();mesh.radius=.5;mesh.height=1.;mesh.radial_segments=8;mesh.rings=3;node.mesh=mesh;node.scale=size;node.position=p;node.material_override=material(color);parent.add_child(node)
func _ready() -> void:
	for i in range(3):
		var rabbit:=Node3D.new();rabbit.name="WoodlandRabbit"+str(i);add_child(rabbit)
		var color: String=["BDA98A","8F8171","C8C4AA"][i]
		ellipsoid(rabbit,Vector3(0,.15,0),Vector3(.24,.27,.36),color)
		ellipsoid(rabbit,Vector3(0,.26,-.16),Vector3(.18,.18,.18),color)
		for side in [-1,1]:
			ellipsoid(rabbit,Vector3(side*.045,.40,-.15),Vector3(.043,.23,.065),color)
			ellipsoid(rabbit,Vector3(side*.052,.40,-.175),Vector3(.018,.16,.018),"C4A492")
			ellipsoid(rabbit,Vector3(side*.077,.28,-.20),Vector3(.015,.018,.014),"302F28")
			ellipsoid(rabbit,Vector3(side*.09,.055,.065),Vector3(.10,.10,.18),color)
		ellipsoid(rabbit,Vector3(0,.16,.20),Vector3(.10,.10,.10),"DDD6BD");rabbits.append(rabbit)
	for i in range(6):
		var p: Vector2=[Vector2(-12,5),Vector2(-15,11),Vector2(12,-13),Vector2(17,-6),Vector2(-10,12),Vector2(12,10)][i]
		for offset in [Vector2(-.45,.2),Vector2(.35,-.15)]:
			var fern=load("res://assets/vegetation/forest_floor/fern_rosette.glb").instantiate();add_child(fern)
			var q: Vector2=p+offset;fern.position=Vector3(q.x,ForestLandscape.height_at(q.x,q.y),q.y);fern.rotation.y=i*1.3;fern.scale=Vector3.ONE*(.85+(i%3)*.17)
			preload("res://scripts/world/field_assets.gd").recolor(fern,"657D58")
		var broad:=MeshInstance3D.new();broad.mesh=rosette();broad.material_override=material("59785B");broad.position=Vector3(p.x,ForestLandscape.height_at(p.x,p.y),p.y);broad.rotation.y=i*1.7;add_child(broad)
	for i in range(8):
		var insect:=Node3D.new();insect.name="DuskMoth"+str(i);add_child(insect)
		for side in [-1,1]:
			var wing:=MeshInstance3D.new();wing.mesh=QuadMesh.new();wing.mesh.size=Vector2(.055,.075);wing.position.x=side*.025;wing.rotation.x=-PI/2;var m:=material("D2BF8E");m.cull_mode=BaseMaterial3D.CULL_DISABLED;wing.material_override=m;insect.add_child(wing)
		insects.append(insect)
func rosette() -> ArrayMesh:
	var st:=SurfaceTool.new();st.begin(Mesh.PRIMITIVE_TRIANGLES)
	for i in range(7):
		var a: float=i*TAU/7.;var f:=Vector3(cos(a),0,sin(a));var s:=Vector3(-sin(a),0,cos(a))
		var base:=Vector3(0,.02,0);var mid:=f*.23+Vector3.UP*.22;var tip:=f*.46+Vector3.UP*.13
		for p in [base,mid-s*.085,mid+Vector3.UP*.025,base,mid+Vector3.UP*.025,mid+s*.085,mid-s*.085,tip,mid+Vector3.UP*.025,mid+s*.085,mid+Vector3.UP*.025,tip]:st.add_vertex(p)
	st.generate_normals();return st.commit()
func _process(_delta: float) -> void:
	if weather==null:return
	var t: float=weather.clock;var rain: float=weather.weather_value.y
	var night: bool=weather.hours<6. or weather.hours>19.5
	for i in range(rabbits.size()):
		var phase:=fposmod(t*.12+i*.31,1.)
		# Out-and-back arc avoids teleporting when the deterministic cycle repeats.
		var p: Vector2=ANCHORS[i]+Vector2(sin(phase*TAU)*.85,(1.-cos(phase*TAU))*.45)
		var hop:=maxf(0.,sin(t*4.5+i))*maxf(0.,sin(phase*PI))*.10
		rabbits[i].position=Vector3(p.x,ForestLandscape.height_at(p.x,p.y)+hop,p.y);rabbits[i].rotation.y=phase*TAU+i;rabbits[i].visible=rain<.6 and not night
	for i in range(insects.size()):
		var anchor: Vector2=Vector2(6,7.5) if i%2==0 else Vector2(-9,11)
		insects[i].position=Vector3(anchor.x+sin(t*.7+i)*.55,1.1+sin(t*.9+i)*.3,anchor.y+cos(t*.8+i)*.55)
		insects[i].visible=night and rain<.4
		for side in range(2):insects[i].get_child(side).rotation.z=sin(t*16.+i)*.6*(1. if side==0 else -1.)
