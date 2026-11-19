extends Node3D
## V05 imports a metre-authored Blender hero asset. No runtime architectural assembly.
const HERO := "res://assets/hero_cafe/forest_post_cafe_v05.glb"
var hero: Node3D

func _ready() -> void:
	hero = load(HERO).instantiate()
	hero.name = "HeroBuilding"
	add_child(hero)
	# Same Map 01 collision envelope and walk-on porch as V04.
	collision(Vector3(-3,1.95,-5.5),Vector3(9,3.2,11))
	collision(Vector3(4.5,1.85,-4),Vector3(6,3.0,8))
	collision(Vector3(0,0.18,2),Vector3(15.6,0.36,4))
	var ramp := StaticBody3D.new()
	var c := CollisionShape3D.new()
	var shape := BoxShape3D.new()
	shape.size = Vector3(2.8,0.18,1.6)
	c.shape = shape
	ramp.add_child(c)
	add_child(ramp)
	ramp.position = Vector3(0,0.11,4.6)
	ramp.rotation.x = 0.22
	# Authored furnishings/posts retain separate, simple physical blockers.
	for x in [-7.3,-3.9,3.9,7.3]:
		collision(Vector3(x,1.78,3.3),Vector3(0.24,2.84,0.24))
	for x in [-5.8,-3.6]:
		collision(Vector3(x,0.78,2.1),Vector3(1.04,0.76,1.04))
		for z in [1.15,3.12]:
			collision(Vector3(x,0.92,z),Vector3(0.5,1.04,0.5))
	for x in [-4.65,4.65]:
		collision(Vector3(x,0.91,3.78),Vector3(5.3,0.7,0.14))
	# Authored emissive glass is in the GLB; these lights illuminate nearby geometry.
	for x in [-6.3,-1.65,1.65,6.3]:
		warm_light(Vector3(x,2.65,0.8),0.65,3.0)
	for x in [-4.5,4.5]:
		warm_light(Vector3(x,2.25,-0.75),1.0,3.4)

func warm_light(at: Vector3, energy: float, radius: float) -> void:
	var light := OmniLight3D.new()
	light.position = at
	light.light_color = Color("FFD298")
	light.light_energy = energy
	light.omni_range = radius
	add_child(light)

func collision(at: Vector3, size: Vector3) -> void:
	var body := StaticBody3D.new()
	var c := CollisionShape3D.new()
	var shape := BoxShape3D.new()
	shape.size = size
	c.shape = shape
	body.add_child(c)
	add_child(body)
	body.position = at
