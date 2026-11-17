# Dense stylized meadow — Godot 4.6.3, Compatibility

This project does **not** contain Terrain3D or a Terrain3D version/native instancer.
The working implementation uses the existing `ForestLandscape` surface and 8 m
MultiMesh chunks. No terrain, tree placements, colliders or gameplay were migrated.
Terrain3D integration is not claimed or tested. A future adapter may supply
`height_sampler(Vector2)->float` and `normal_sampler(Vector2)->Vector3`; use the
installed plugin's documented API when one actually exists.

Run the isolated **5 × 5 metre** example:

```
godot --path . environment/vegetation/scenes/meadow_demo.tscn
```

Default map integration: `CuratedGroundCover/DenseMeadow`. The carpet, main tufts,
accents and two flower types are independent layers. Geometry is original procedural
folded low-poly ribbons, without image textures or alpha cards. Geometry may be
used under CC0-1.0. There is no downloaded marketplace/reference asset. Existing
Kenney stones remain under their original CC0 receipt. Mushroom geometry is also original.

## Inspector workflow

Open `presets/high.tres` to edit densities (candidate clusters per square metre),
render distance, LOD, chunk size, slope limit, normal alignment, seed and wind.
Open `scenes/meadow_demo.tscn`, select DenseMeadow and use **Generate / regenerate**
or **Clear generated grass**. The generator is @tool; button generation is visible
in the editor and replaces previous chunks. Generated nodes have no persistent
owner and are rebuilt at runtime rather than bloating the saved scene.

Change `area` to select a rectangular generation region. `valid_area` rejects
samples outside the current -24..24 terrain. Runtime generation happens once at
startup or when explicitly requested, never per movement/frame. Large arbitrary
maps have not been benchmarked; this is not an infinite terrain streaming system.

Road, porch/building, mailbox approach, NPC and known rock/stump areas are excluded.
Additional circles use Vector3(x, z, radius). Optional `density_mask` is a painted
RGBA texture over `mask_rect`: R carpet, G main, B accent, A flowers; zero RGBA
excludes all types. Height NaNs, out-of-region points and excessive slopes are
rejected; root bases are aligned partially to the sampled normal and sunk 4 mm.
No ground coverage should be expected on a deliberately excluded road/building.

## Presets and LOD

| Preset | Carpet candidates/m² | Main | Accent | Flowers | Range | LOD transition |
| --- | ---: | ---: | ---: | ---: | ---: | --- |
| Low | 10 | 1.5 | .25 | .30 | 38 m | 9–16 m |
| Medium | 14 | 3 | .4 | .45 | 48 m | 12–20 m |
| High (default) | 18 | 4.5 | .6 | .65 | 60 m | 14–24 m |
| Ultra | 22 | 6 | .8 | .9 | 70 m | 18–30 m |

Habitat masks reduce these candidate densities. Carpet has 24 blades / 240 triangles,
main 16 / 160, accent 12 / 120. Distance meshes have 4/4/3 blades (8/8/6 triangles).
Two variants per grass layer change deterministic curvature/shape. Whole-clump
stochastic LOD selection uses a stable seed, with chunk visibility guard bands;
there is no alpha-card fade. All grass shadows are disabled, terrain/cafe/tree
shadows remain. Distant density is represented by simplified geometry and matching
terrain color rather than preserving full blades everywhere. Low/Medium are the
first choices if a representative Windows benchmark misses the 60 FPS target.

```
godot --path . -- --grass-quality=medium
```

Wind uses GPU vertex motion, a shared world direction/time, travelling gusts and
per-clump flutter. Roots are anchored by vertex colors. Wind/sun/weather update a
small shared material pool; there are no per-blade nodes or CPU animation loops.
The map's weather controller drives material wetness and scales the configured wind.
The isolated scene animates independently.

## Validation and limits

Use `tests/dense_meadow_test.gd` with a rendering display: actual MultiMesh transform
readback is unavailable on Godot's dummy headless rendering backend. Headless
import/parser/gameplay tests are separate checks. The GPU test verifies nonflat
surface placement, repeat generation, population changes, steep-slope rejection,
painted/circle masks, LOD simplification and presets. Passing tests is not art approval.

Cloud screenshots use Linux llvmpipe OpenGL software rendering. This does not
validate 60 FPS at 1080p on Windows/mid-range hardware. Native Terrain3D painting,
region streaming and texture/control-map APIs are not implemented in this project.
