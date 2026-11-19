# Forest floor — editable source

`forest_floor.blend` contains seven original separate meshes. `build_assets.py` reproduces them and writes `build_report.json` plus runtime GLBs to `assets/vegetation/forest_floor`.

```sh
blender --background --python-exit-code 1 --python art_source/forest_floor/build_assets.py
python tools/validate_ground_environment.py
godot --headless --editor --path . --quit
```

After rebuilding, update manifest hashes. Each module is at most 256 triangles and has a RootToTip vertex-color attribute; no texture dependencies. Godot applies forest_grass.gdshader and per-instance tint by habitat role, including brown leaf/twig overrides. Geometry is project-authored, not a newly downloaded external asset. The existing art_source/.gdignore prevents automatic Blender import.
