# V06 editable source

Run from repository root:

```sh
blender --background --python art_source/postal_worker_v06/color_avatar.py
python tools/validate_v06_assets.py
```

Saved `.blend` is editable; script reproduces it. Update manifest hashes after rebuilding. `art_source/.gdignore` prevents automatic Godot source import. Runtime uses exported GLBs only. No paid generation or external textures.
