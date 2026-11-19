@tool
extends RefCounted
## Original solid low-poly curved ribbons; roots at zero; COLOR.r stores bend weight.
static func grass(layer: int,variant: int,low:=false) -> ArrayMesh:
	var rng:=RandomNumberGenerator.new();rng.seed=9100+layer*41+variant*79
	var vertices:=PackedVector3Array();var colors:=PackedColorArray()
	var count: int=(4 if low else (24 if layer==0 else 16)) if layer<2 else (3 if low else 12)
	var nominal: float=[.12,.26,.49][layer]
	for blade in range(count):
		var a:=rng.randf()*TAU
		var f:=Vector3(cos(a),0,sin(a));var s:=Vector3(-sin(a),0,cos(a))
		var base:=Vector3(rng.randf_range(-.13,.13),0,rng.randf_range(-.13,.13))
		var h:=nominal*rng.randf_range(.65,1.22)
		var w:=rng.randf_range(.010,.019)*(1.15 if layer>0 else 1.)
		var reach:=h*rng.randf_range(.25,.72)
		var rows: Array=[]
		for t in [0.,.48,.82]:
			var center: Vector3=base+f*reach*t*t+Vector3.UP*h*t
			var width: float=w*(1.-t*.75)
			rows.append([center-s*width,center+Vector3.UP*width*.22-f*width*.12,center+s*width])
		var tip:=base+f*reach+Vector3.UP*h*.98
		if low:
			triangle(vertices,colors,rows[0][0],rows[0][2],tip,0.,0.,1.)
			triangle(vertices,colors,rows[0][2],rows[0][0],tip,0.,0.,1.)
		else:
			for row in range(2):
				for edge in range(2):
					triangle(vertices,colors,rows[row][edge],rows[row][edge+1],rows[row+1][edge],row*.4,row*.4,(row+1)*.4)
					triangle(vertices,colors,rows[row][edge+1],rows[row+1][edge+1],rows[row+1][edge],row*.4,(row+1)*.4,(row+1)*.4)
			for edge in range(2): triangle(vertices,colors,rows[2][edge],rows[2][edge+1],tip,.8,.8,1.)
	return finish(vertices,colors)
static func flower(purple: bool) -> ArrayMesh:
	var v:=PackedVector3Array();var c:=PackedColorArray();var h:=.28 if purple else .34
	triangle(v,c,Vector3(-.006,0,0),Vector3(.006,0,0),Vector3(.005,h,0),0,0,.7)
	triangle(v,c,Vector3(-.006,0,0),Vector3(.005,h,0),Vector3(-.005,h,0),0,.7,.7)
	for i in range(7 if not purple else 5):
		var a: float=i*TAU/(7. if not purple else 5.)
		var f:=Vector3(cos(a),.1,sin(a));var s:=Vector3(-sin(a),0,cos(a))
		var center:=Vector3(0,h,0)
		triangle(v,c,center,center+f*.065-s*.020,center+f*.085,1,1,1)
		triangle(v,c,center,center+f*.085,center+f*.065+s*.020,1,1,1)
	return finish(v,c)
static func triangle(v: PackedVector3Array,c: PackedColorArray,a: Vector3,b: Vector3,d: Vector3,ta: float,tb: float,td: float) -> void:
	v.append_array([a,b,d]);c.append_array([Color(ta,ta,ta),Color(tb,tb,tb),Color(td,td,td)])
static func finish(v: PackedVector3Array,c: PackedColorArray) -> ArrayMesh:
	var st:=SurfaceTool.new();st.begin(Mesh.PRIMITIVE_TRIANGLES)
	for i in range(v.size()):st.set_color(c[i]);st.add_vertex(v[i])
	st.generate_normals();return st.commit()
