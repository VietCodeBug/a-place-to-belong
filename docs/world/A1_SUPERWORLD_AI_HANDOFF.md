# A1 Superworld 4 km — AI coding handoff

> **STATUS: EXPERIMENTAL / NOT MERGE READY.** Dedicated work branch: `prototype/a1-superworld-4km`.
> This branch starts from `feature/village-a-world` at `9cf0f45397e8f25aad6cf626bb0f3bd4d41bb14d`. Existing A1 village, scene and V4 art remain the authoritative gameplay source until integration is tested.
>
> **Do not run `project.godot` from the standalone demo over the root project.** The demo has its own Godot project and coordinate space.

## User vision

The game **A Place to Belong** will eventually contain a **superworld of regions A1, B, C, D, E...**. **A1 is only ONE region**, not the entire game. A1 must feel vast and explorable before new vertical-slice features are built. It must contain a substantial **lake with fishing shores and an explorable underwater world**, not merely a flat surface texture. Fishing gameplay, fish schools, submerged quests and full underwater ecosystems are future milestones.

The desired art direction is **premium stylized / refined classic low poly**, scenic, lush, cozy, and not a cheaply assembled primitive world. Prioritize a functional large world foundation before fine asset polish.

## Existing game and reference demo are different

**Existing game:** `scenes/world/forest_hub.tscn`, `scripts/world/landscape.gd`, `scripts/world/a1_valley.gd`, `scripts/world/village_a.gd`, `scripts/world/village_a_layout.gd`, `scripts/world/a1_botany.gd`, `scripts/world/a1_planting.gd`, `scripts/ui/a1_map.gd`, etc. The existing route is House A → forest → bridge → Village A → forest exit, with 21 exterior buildings, seasonal vegetation and reviewed art.

**Standalone sample (created outside repository):** Godot 4.6.x project originally distributed as `A1_Superworld_Godot_Prototype.zip`. It contains:
- `scripts/world_gen.gd`: deterministic terrain generator and biome rules;
- `scripts/world_chunks.gd`: 128 m terrain chunks, bounded radius, collision near player, crude vegetation MultiMesh;
- `scripts/world_props.gd`: placeholder A1 house/village, river/bridge, lake water, pier/fishing placeholder, underwater rocks/plants;
- `scripts/player.gd`: basic exploratory first/third person movement, swimming/diving;
- `scripts/a1_map.gd`: generated A1 map (M), zoom/pan, provisional B–I atlas (TAB);
- `scripts/world.gd` and `scenes/world.tscn`: independent bootstrap.
- `docs/generate_map_preview.py`: concept-art map preview generation (Pillow).
The standalone is **not verified by a Godot runtime**; generated screenshots are conceptual maps, not gameplay proof. It uses blockout geometry and does not have production-grade streaming or fishing.

## Reference dimensions and coordinates (NOT game canon)

| Parameter | Experimental reference |
| --- | --- |
| Region A1 playable extent target | 4,096 × 4,096 m (16.777 km²), X/Z approximately -2048…+2048 |
| Terrain tile size | 128 m; near physics collision radius 2 chunks |
| Lake prototype | ellipse ~860 × 620 m centered at X 780 / Z -530, water Y 5, up to roughly 30 m below surface |
| Fishing pier anchor | X 360 / Z -530 |
| Underwater rock garden | X 795 / Z -535 |
| Standalone House A anchor | X -115 / Z 15 |
| Standalone Village A anchor | X 50 / Z 455 |
| Other regions | B–I reserved labels only; no terrain or traversal implemented |

**IMPORTANT:** the existing game currently places House A at X 13.1 / Z 13.7 and Village A around Z 100–180. These differ from sample positions. Never move built story locations or relocate 21 village buildings to match the demo by blind copy. Design a coordinate adapter/placement strategy before integrating. Preserve chapter ordering and existing narrative route.

## Work order for AI engineer

1. **Inspect GitHub HEAD and code in the actual game; review the standalone sample.** Keep the sample isolated from root runtime.
2. **Create a data-driven superworld registry:** region ID, bounds, seed, neighbors, feature flags. B–I must be reserved/disabled, not displayed as implemented.
3. **Port terrain/chunk streaming safely:** deterministic tiles, floating-origin study for 4 km range if needed, shared sampling, crack-free seams, view LOD, active collision and safe async/main-thread chunk budgeting.
4. **Integrate the existing A1 core instead of replacing it:** the current authored House A, bridge and Village A remain; establish terrain seam and walking continuity.
5. **Build the large lake as genuinely playable terrain:** bathymetric bottom, shorelines, pier, entry/exit slopes, water volume, camera underwater behavior and underwater collision. Mark fishing interactions as FUTURE until implemented.
6. **World map M:** correct coordinate bounds, terrain + lake shapes, POIs and discovery. Add regional atlas with B–I as locked future plans, not fake playable areas.
7. **Biome population in phases:** use current approved tree/vegetation assets, foliage culling and LOD. Avoid filling 16.8 km² with individual Nodes or uniform randomized vegetation.
8. **Prototype gameplay traversal / QA:** walk out of current A1 core to new chunks; reach lake, enter/exit and dive, cross chunk seams, return to Village A, change seasons safely, track GPU frametime/memory.
9. **Only after map size and playability pass**, resume vertical slice features (interaction, discovery, save, story). Avoid extended visual polishing of one house while the world is still tiny.

## Acceptance gates

- [ ] Chunk terrain visibly spans proposed A1 bounds; distinguish generated, collision-enabled and actually tested extents.
- [ ] Playable physical ground, no invisible scenery pretending to be terrain.
- [ ] Existing House A, village/21 exteriors, routes, seasons and story triggers remain intact.
- [ ] Lake shoreline accessible; visible underwater bottom and meaningful diving space; fishing action honestly marked placeholder.
- [ ] M map and world coordinates agree; region B–I remain disabled.
- [ ] Terrain traversal/teleport into distant chunks works; no cracks or falling through terrain.
- [ ] No big regression in memory, FPS, physics or load hitching on Windows GPU.
- [ ] Real Godot screenshots and normal-speed gameplay video, not conceptual art.
- [ ] Unit/smoke testing and deterministic-world checks; failed runtime build is not accepted.
- [ ] Source changes + docs + draft PR for review; **never auto-merge**.

## Boundaries

No NPC upgrades, character animation, new quests, Office/Apartment edits, canon rewrites or complete fishing minigame at this stage. Keep existing third-person forest gameplay camera unless explicitly approved to change. Design future hooks for fishing and underwater discovery, do not falsely report those features as complete.

## Current limitation

This branch is for **AI handoff and integration of an isolated prototype**, not a replacement shipped A1. Do not claim the standalone was tested in Godot: the environment that generated it did not contain a Godot binary. The original full ZIP and concept map files are available from the prior conversation artifacts and must be treated as reference material if not present under this Git branch.
