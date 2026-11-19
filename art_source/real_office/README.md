# ENV-REAL-01 office colleagues

Original models authored for A Place to Belong. The Blender Python source defines the silhouettes, clothes, facial details and posed hands. The seated colleague wears a rust cardigan. The standing colleague wears a sage cardigan and carries a folder. The exported GLBs contain flat and smooth shaded meshes with dedicated head pivots. Godot drives subtle gaze motion on those pivots.

Run `blender -b -t 2 -P art_source/real_office/build_colleagues.py` from the repository root to regenerate the two GLBs in `assets/story/office_models`. No third-party geometry or model textures are embedded. Godot imports the files directly.
