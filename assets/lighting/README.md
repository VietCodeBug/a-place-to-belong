# Map 01 — static lighting presets

- `golden_hour.tres`: preferred default, low warm sun, cool fill, blue sky / warm horizon.
- `blue_hour.tres`: independent cool evening preset; original café lights stay unchanged.
- `pr09_baseline.tres`: exact PR #9 lighting settings for matched comparison.

Run the game with a fixed preset:

```sh
godot --path . -- --lighting=golden_hour
godot --path . -- --lighting=blue_hour
godot --path . -- --lighting=baseline
```

No clock, day/night cycle, menu or live transition. `ForestLightingPreset` is data, `lighting_rig.gd` applies only its tagged WorldEnvironment and DirectionalLight3D. It leaves all local café lights, geometry, materials, actors and camera alone. Golden sky uses the actual directional light for its sun disc/glow; Blue Hour disables that light's sky contribution rather than drawing a second sun. The angular distance setting is not a claim of PCSS area shadows on Compatibility.

See docs/sky-sun-atmosphere-review.md and docs/lighting-presets-parameters.json for exact values, captures, tests and limitations. New resources are project-authored data; no external assets or generated textures.

Baseline sky curve / glow angle = -1 means keep the engine default; the parameter dump records their effective values (0.15 / 30 degrees).
