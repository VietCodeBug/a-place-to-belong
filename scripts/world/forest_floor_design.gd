class_name ForestFloorDesign
extends RefCounted
## Habitat masks shared by vegetation and the world-space ground shader's grove layout.
const VILLAGE = preload("res://scripts/world/village_a_layout.gd")
const GROVES := [Vector3(-14,-7,8),Vector3(-12,-19,9),Vector3(12,-16,9),Vector3(20,-4,8),Vector3(-17,10,7),Vector3(-20,17,7),Vector3(19,-19,8),Vector3(3,-24,8),Vector3(-12,4,4)]
const BEDS := [Vector3(-9,15,4.8),Vector3(10,12,5.0),Vector3(-12,5,3.7),Vector3(11,5,3.5),Vector3(-18,16,4.0),Vector3(17,-7,4.0)]
static func forest(p: Vector2) -> float:
	var result := 0.0
	for grove in GROVES:
		result = maxf(result,1.0-smoothstep(grove.z*0.35,grove.z,p.distance_to(Vector2(grove.x,grove.y))))
	return result
static func bed(p: Vector2) -> float:
	var result := 0.0
	for patch in BEDS:
		var distance := (p-Vector2(patch.x,patch.y))*Vector2(1.0,1.35)
		result = maxf(result,1.0-smoothstep(patch.z*0.4,patch.z,distance.length()))
	return result
static func reserved(p: Vector2, margin := 0.0) -> bool:
	if absf(p.x)<8.4+margin and p.y>-12.4-margin and p.y<5.25+margin: return true
	if ForestLandscape.on_road(p,margin): return true
	var house_space := (p-VILLAGE.HOUSE_A).rotated(-PI*.48)
	if absf(house_space.x)<2.65+margin and absf(house_space.y)<2.00+margin:
		return true
	for i in range(VILLAGE.HOUSE_APPROACH.size()-1):
		var nearest := Geometry2D.get_closest_point_to_segment(p,VILLAGE.HOUSE_APPROACH[i],VILLAGE.HOUSE_APPROACH[i+1])
		if p.distance_to(nearest)<1.24+margin:
			return true
	if p.distance_to(Vector2(-5.4,6.8))<0.9+margin: return true
	return false
