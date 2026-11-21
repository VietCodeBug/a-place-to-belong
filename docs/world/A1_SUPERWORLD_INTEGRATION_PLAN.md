# A1 Superworld — Proposed Integration Milestones

**This file is a plan, not an implementation report.** All feature status must be validated in real Godot builds.

| Gate | Work | Evidence |
| --- | --- | --- |
| 0 — Reproduce standalone | Import `prototypes/a1_superworld/standalone/project.godot` in Godot 4.6.3 Compatibility; fix syntax/runtime errors | Working boot log, player/camera screenshot |
| 1 — Region coordinates | Document existing A1 landmarks, plan mapping, no teleport/scale regression | Coordinate adapter document and test |
| 2 — Streaming | Integrate deterministic tile generator, LOD, collision activation and cleanup with root world | Walking across 10+ chunk seams, memory/frametime |
| 3 — Large landmass | Build terrain for 4,096 m square target in progressive rings, collision around exploration routes | Playable extent debug screenshot; NOT merely distant backdrop |
| 4 — Big lake | Terrain carved beneath water, shore gradient, real underwater region and player entry/exit | Normal-speed gameplay walking to pier, diving and returning |
| 5 — Fishing hooks | Future interactable anchor and data contract, not a completed minigame | `fish_spot` marker, explicit placeholder UI |
| 6 — A1 map | Align camera, player world coordinates, terrain, POIs, lake and chunk discovery | Full map and zoom/pan test |
| 7 — B–I architecture | Region registry, future transitions, future coordinate handling | Registry with nonplayable placeholders |
| 8 — Vegetation/performance | Apply existing approved tree library with biome placement and adaptive render budget | CPU/GPU benchmark and vegetation snapshots |
| 9 — Story vertical slice | Only after world-scale technical gates pass, resume game features & Save | Gameplay walkthrough, checkpoints, regression tests |

## Explicit QA checks

- Must retain 21 existing Village A exterior placements; avoid accidental duplicate houses from prototype blockout.
- No false claim that all 16.78 km² are accessible without testing actual collision, camera and traversal.
- Report generated geometry, collision-ready tiles and tested routes **separately**.
- Lake is neither a decorative disc nor a swimming minigame claim; validate underwater floor and water entry/exit.
- Original A1 default camera remains third-person. Prototype first-person camera must not overwrite the game's gameplay mode.
- Four seasons and weather from existing game take precedence over the prototype's temporary palette flags.
- B–I are placeholders. No invented region lore or quest chains.
- Current prototype has **not been run by its author in Godot**. Gate 0 is mandatory.
- Do not merge PR #13 or the prototype branch without developer approval.
