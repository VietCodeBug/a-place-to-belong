@tool
extends Node3D
## Small, composed forest-floor clusters; visual-only, no gameplay collision.
const D=preload("res://scripts/world/forest_floor_design.gd")
const A=preload("res://scripts/world/field_assets.gd")
var mushroom_count:=0
var pebble_count:=0
func _ready() -> void:
	var rng:=RandomNumberGenerator.new();rng.seed=91377
	var clusters: Array[Vector2]=[Vector2(-10,13),Vector2(11,11),Vector2(-12,3),Vector2(16,-8),Vector2(-16,11),Vector2(13,-15)]
	var batches: Array=[[],[]]
	for k in range(clusters.size()):
		for i in range(3+k%3):
			var p: Vector2=clusters[k]+Vector2(rng.randf_range(-.55,.55),rng.randf_range(-.50,.50))
			if D.reserved(p,.4):continue
			var size:=rng.randf_range(.65,1.4)
			batches[k%2].append(Transform3D(Basis(Vector3.UP,rng.randf()*TAU).scaled(Vector3.ONE*size),Vector3(p.x,ForestLandscape.height_at(p.x,p.y)-.005,p.y)))
			mushroom_count+=1
		# A few partially buried stones anchor each group; use the existing licensed asset.
		for i in range(2):
			var p: Vector2=clusters[k]+Vector2(rng.randf_range(-1.1,1.1),rng.randf_range(-.8,.8))
			if D.reserved(p,.35):continue
			var rock:=A.model("nature","rock_smallC",rng.randf_range(.10,.20))
			A.recolor(rock,"89917B");add_child(rock)
			rock.position=Vector3(p.x,ForestLandscape.height_at(p.x,p.y)-.025,p.y)
			rock.rotation.y=rng.randf()*TAU;pebble_count+=1
	for variant in range(2):
		var mm:=MultiMesh.new();mm.transform_format=MultiMesh.TRANSFORM_3D;mm.mesh=mushroom(variant);mm.instance_count=batches[variant].size()
		for i in range(mm.instance_count):mm.set_instance_transform(i,batches[variant][i])
		var node:=MultiMeshInstance3D.new();node.multimesh=mm;add_child(node)
	print("Meadow details: mushrooms=",mushroom_count," pebbles=",pebble_count)
static func mushroom(variant: int) -> ArrayMesh:
	var st:=SurfaceTool.new();st.begin(Mesh.PRIMITIVE_TRIANGLES)
	var cap:=Color("B87948") if variant==0 else Color("C9AE73")
	for i in range(8):
		var a: float=i*TAU/8.;var b: float=(i+1)*TAU/8.
		var ra:=Vector3(cos(a),0,sin(a));var rb:=Vector3(cos(b),0,sin(b))
		var top:=Vector3(0,.25,0);var inner_a:=ra*.08+Vector3.UP*.225;var inner_b:=rb*.08+Vector3.UP*.225
		var edge_a:=ra*.13+Vector3.UP*.17;var edge_b:=rb*.13+Vector3.UP*.17
		for tri in [[top,inner_a,inner_b],[inner_a,edge_a,edge_b],[inner_a,edge_b,inner_b]]:
			for p in tri:st.set_color(cap.lightened(.06 if i%3==0 else 0.));st.add_vertex(p)
		for tri in [[Vector3(0,.165,0),edge_b,edge_a],[ra*.022,rb*.022,ra*.022+Vector3.UP*.18],[rb*.022,rb*.022+Vector3.UP*.18,ra*.022+Vector3.UP*.18]]:
			for p in tri:st.set_color(Color("D6C8A3"));st.add_vertex(p)
	st.generate_normals()
	var material:=StandardMaterial3D.new();material.vertex_color_use_as_albedo=true;material.roughness=1.;material.cull_mode=BaseMaterial3D.CULL_DISABLED;st.set_material(material)
	return st.commit()
