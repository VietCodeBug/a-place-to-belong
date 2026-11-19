# ENV-REAL-01 office colleagues

Original models authored for A Place to Belong. The Blender Python source defines the silhouettes, clothes, facial details and posed hands. The seated colleague wears a rust cardigan. The standing colleague wears a sage cardigan and carries a folder. The exported GLBs contain flat and smooth shaded meshes with dedicated head pivots. Godot drives subtle gaze motion on those pivots.

Run `blender -b -t 2 -P art_source/real_office/build_colleagues.py` from the repository root to regenerate the two GLBs in `assets/story/office_models`. No third-party geometry or model textures are embedded. Godot imports the files directly.

## Colleague NPC 1

The seated coworker beside A uses the supplied `base_basic_pbr-f64e0635.fbx`
(SHA-256 `e576a65730cad713d78992648fd78ec9634bdcd5ade544e1610b97c0ba3a1243`).
Run `blender -b -P art_source/real_office/convert_colleague_one.py -- /path/to/base_basic_pbr-f64e0635.fbx`
from the repository root to rebuild the 45,600-triangle runtime GLB with embedded
2K PBR maps and the 55-bone rig. The office pose controller aligns the index
fingertips to two keycaps and uses the finger joints during typing.

## Colleague NPC 2

The male coworker in the blue shirt uses the supplied PBR GLB directly as
`assets/story/office_models/colleague_npc_02.glb` (SHA-256
`f4f0e366529389e0a7911a126e8d92cf3c6fd00ca9b5f734d1c4599780bf8cdb`). His 57-bone
rig holds the seated pose and positions both hands over the visible keys.

The office crowd uses these two rigs. Thirteen coworkers type at workstations,
two sit at the meeting table, and three stand by the copier and meeting area.

## Office boss

The supervisor uses the updated PBR GLB directly as
`assets/story/office_models/office_boss.glb` (SHA-256
`153489c1dcd3dbf364d9c8b2dfd61a6d7da57a6e6b027a5c5a32098e44687c0c`).
Godot samples its embedded `human_000089` walk on the 57-bone rig. Distance
travelled by the collision body drives the animation phase. The controller
cancels the clip's forward translation so the patrol route controls position.
The patrol body moves on the office floor plane. The boss pose checks heel and
toe clearance and limits exaggerated knee flexion on the supplied walk.

## Paperwork and office foley

`office_paperwork.gd` builds the paper stacks, letter trays and wastebaskets in
the scene using shared meshes. The form shader draws abstract print marks and
revisions. `office_workday.gd` layers keyboard sounds and times the printer's
paper feed to its motor. Rebuild the original foley with
`python art_source/real_office/build_workday_audio.py`.
