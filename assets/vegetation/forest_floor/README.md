# Forest floor modules

Original project-authored Blender geometry, seven GLBs, 420 source triangles total. No external textures or third-party models in this package. Runtime habitat styling is in scripts/world/ground_cover.gd and shaders/forest_grass.gdshader. Editable source and reproducible script live in art_source/forest_floor.

| Module | Triangles |
| --- | --- |
| short_blades | 18 |
| soft_fan | 24 |
| meadow_sweep | 21 |
| tall_sedge | 27 |
| fern_rosette | 220 |
| fallen_leaf | 7 |
| twig | 3 |

Source mesh colors encode root-to-tip shading; runtime shaders supply final grass/fern/leaf/twig palettes and slight wind. MultiMeshes are split into 8 m chunks, total population capped by test at 25,000. No collision shapes are added. Existing Quaternius/Kenney assets remain in their licensed vendor packages, unchanged. Hashes are recorded in manifest.json; validate with tools/validate_ground_environment.py.
