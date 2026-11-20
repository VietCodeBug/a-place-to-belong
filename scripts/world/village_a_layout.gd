extends RefCounted

# ID, exterior family, X, Z, yaw. IDs have no household assignment.
const BUILDINGS := [
	["A01","porch",-6.9,107.4,1.45],["A02","gable",11.2,108.4,-1.08],
	["A03","long",-14.0,116.5,1.19],["A04","hewn",16.2,118.6,-1.54],
	["A05","craft",21.8,128.1,-1.51],["A06","hall",-3.6,133.2,2.72],
	["A07","gable",16.9,139.6,-1.49],["A08","porch",-13.0,141.2,1.64],
	["A09","long",-8.4,153.4,1.74],["A10","hewn",13.5,153.6,-1.90],
	["A11","porch",18.0,162.4,-1.58],
]
const GARDEN := Vector2(-7.8,120)
const COMMON := Vector2(5.2,128)
const CRAFT := Vector2(16.1,128.1)
const EXIT := Vector2(6.6,180.0)
const HOUSE_A := Vector2(13.1,13.7)
const HOUSE_APPROACH := [Vector2(9.5,14.2), Vector2(6.9,14.9), Vector2(3.1,16.7), Vector2(-2.55,17.6)]
const LANES := [
	[Vector2(3.1,110),Vector2(-3.2,111),Vector2(-9.2,113.3),Vector2(-10.4,117.8),Vector2(-9,123),Vector2(4.8,124)],
	[Vector2(5.1,117),Vector2(10.3,117.2),Vector2(12.6,121.3),Vector2(14.2,126.4),Vector2(17.3,130.8),Vector2(14.2,137.8),Vector2(6,141)],
	[Vector2(5.4,131.3),Vector2(0,128.3),Vector2(-9.5,129.5),Vector2(-9.7,136.5),Vector2(-9.3,139.1),Vector2(-8.8,146.3),Vector2(-5.9,150),Vector2(5.1,153.2)],
	[Vector2(5.1,149.3),Vector2(9,148.2),Vector2(10.8,151.4),Vector2(13.8,158.6),Vector2(6.4,163)],
]
