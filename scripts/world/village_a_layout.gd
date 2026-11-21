extends RefCounted

# ID, exterior family, X, Z, yaw. IDs have no household assignment.
const BUILDINGS := [
	["A01","porch",-6.9,107.4,1.45],["A02","gable",11.2,108.4,-1.08],
	["A03","long",-14.0,116.5,1.19],["A04","hewn",16.2,118.6,-1.54],
	["A05","craft",21.8,128.1,-1.51],["A06","chapel",-3.6,133.2,2.72],
	["A07","gable",16.9,139.6,-1.49],["A08","porch",-13.0,141.2,1.64],
	["A09","long",-8.4,153.4,1.74],["A10","hewn",13.5,153.6,-1.90],
	["A11","wing",18.0,162.4,-1.58],
	["A12","loft",-3.2,102.5,1.37],["A13","split",16.4,103,-1.1],
	["A14","barn",-17.0,109.3,1.36],["A15","shed",-15.9,124.3,1.34],
	["A16","stonehouse",22.6,117.7,-1.57],["A17","split",-15.8,132.5,1.64],
	["A18","shed",21.4,134.5,-1.57],["A19","wing",-16.0,151.2,1.48],
	["A20","gallery",17.7,147.0,-1.46],["A21","shed",-7.7,162.0,1.35],
]
const GARDEN := Vector2(-7.8,120)
const COMMON := Vector2(5.2,128)
const CRAFT := Vector2(16.1,128.1)
const EXIT := Vector2(6.6,180.0)
const HOUSE_A := Vector2(16,-338)
const THOMAS := Vector2(-6.85,17.8)
const THOMAS_APPROACH := [Vector2(-2.55,17.6),Vector2(-4.3,17.35),Vector2(-6.05,17.8)]
const HOUSE_APPROACH := [
	HOUSE_A + Vector2(-3.6,.5), Vector2(7,-335), Vector2(0,-325),
	Vector2(-7,-313), Vector2(-11,-299), Vector2(-6,-285), Vector2(4,-274),
	Vector2(13,-264), Vector2(16,-251), Vector2(9,-237), Vector2(-3,-227),
	Vector2(-14,-216), Vector2(-17,-202), Vector2(-13,-187), Vector2(-3,-176),
	Vector2(9,-165), Vector2(16,-153), Vector2(13,-139), Vector2(3,-128),
	Vector2(-7,-118), Vector2(-9,-105), Vector2(-3,-92), Vector2(8,-81), Vector2(6,-73), Vector2(11,-64),
	Vector2(17,-54), Vector2(16,-44), Vector2(12,-36), Vector2(13,-26),
	Vector2(15,-17), Vector2(14,-8), Vector2(12,2), Vector2(9,9),
	Vector2(6.9,14.9), Vector2(3.1,16.7), Vector2(-2.55,17.6),
]
const LANES := [
	[Vector2(3.1,110),Vector2(-3.2,111),Vector2(-9.2,113.3),Vector2(-10.4,117.8),Vector2(-9,123),Vector2(4.8,124)],
	[Vector2(5.1,117),Vector2(10.3,117.2),Vector2(12.6,121.3),Vector2(14.2,126.4),Vector2(17.3,130.8),Vector2(14.2,137.8),Vector2(6,141)],
	[Vector2(5.4,131.3),Vector2(0,128.3),Vector2(-9.5,129.5),Vector2(-9.7,136.5),Vector2(-9.3,139.1),Vector2(-8.8,146.3),Vector2(-5.9,150),Vector2(5.1,153.2)],
	[Vector2(5.1,149.3),Vector2(9,148.2),Vector2(10.8,151.4),Vector2(13.8,158.6),Vector2(6.4,163)],
]
