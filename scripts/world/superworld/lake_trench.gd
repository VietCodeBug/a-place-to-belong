extends "res://scripts/world/superworld/lake_masonry.gd"
## Irregular slate outcrops frame the trench carved by the terrain field.

const FIELD = preload("res://scripts/world/superworld/terrain_field.gd")

var current: MeshInstance3D

func setup(field: FIELD, channel: Array, index: int) -> void:
	var center: Vector2 = channel[0]
	var radii: Vector2 = channel[1]
	var turn: float = -channel[2]
	begin_site("WestTrench" if index==0 else "EastTrench",Vector3(center.x,0,center.y),91002+index*47)
	var rock := SphereMesh.new()
	rock.radial_segments = 6
	rock.rings = 2
	var rock_vertices := rock.create_convex_shape().points
	for side: float in [-1.0,1.0]:
		for i in 10:
			var z := lerpf(-.82,.82,float(i)/9.0)*radii.y
			var x := side*radii.x*(.82+.14*cos(z*.19))
			var ledge := Vector2(x,z).rotated(turn)
			var y := field.height(center+ledge)
			var size := Vector3(rng.randf_range(2.4,4.4),rng.randf_range(3.25,8.0),rng.randf_range(3.0,6.6))
			var basis := Basis(Vector3.UP,rng.randf()*TAU)
			basis = basis.rotated(Vector3.BACK,side*rng.randf_range(.17,.44)).scaled_local(size)
			var at := Vector3(ledge.x,y-size.y*.15,ledge.y)
			var tone := Color("293F50").lerp(Color("4D6774"),rng.randf()*.83)
			stamp(rock,Transform3D(basis,at),tone)
			# Convex hull vertices are scaled here so Godot can keep a uniform body transform.
			var hull := ConvexPolygonShape3D.new()
			var vertices := rock_vertices.duplicate()
			for vertex in vertices.size():
				vertices[vertex] = basis*vertices[vertex]
			hull.points = vertices
			collide(hull,at)
	stone_visual("SlateLedges")
	build_current(radii,turn)

func build_current(radii: Vector2, turn: float) -> void:
	var stream := SurfaceTool.new()
	stream.begin(Mesh.PRIMITIVE_TRIANGLES)
	var axis := Vector3.FORWARD.rotated(Vector3.UP,-turn)
	var side := axis.cross(Vector3.UP)
	for i in 96:
		var spot := Vector2(rng.randf_range(-.65,.65),rng.randf_range(-.84,.84))*radii
		spot = spot.rotated(turn)
		var at := Vector3(spot.x,FIELD.WATER-rng.randf_range(16.2,20.6),spot.y)
		var length := rng.randf_range(.12,.46)
		var cross := (Vector3.UP.lerp(side,.43) if i%2==0 else side)*rng.randf_range(.012,.041)
		var points := [at-axis*length-cross,at+axis*length-cross,at+axis*length+cross,at-axis*length+cross]
		var uv := [Vector2.ZERO,Vector2.RIGHT,Vector2.ONE,Vector2.DOWN]
		var phase := Color(rng.randf(),rng.randf(),rng.randf())
		for corner in [0,1,2,0,2,3]:
			stream.set_uv(uv[corner])
			stream.set_color(phase)
			stream.add_vertex(points[corner])
	var material := ShaderMaterial.new()
	material.shader = preload("res://shaders/a1_trench_current.gdshader")
	material.set_shader_parameter("flow_direction",axis)
	current = add_visual("SuspendedSediment",stream.commit(),material)
	current.visibility_range_end = 62.0
	current.extra_cull_margin = 9.0
	current.hide()
