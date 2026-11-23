# A1 — Visual Biome Preview Brief V1 (for Codex)

> ART REFERENCE ONLY. Six scene concepts were rendered in the ChatGPT handoff conversation; the images are **not Godot screenshots** and **are not committed as PNG files in this branch**. Attach/export the 2×3 concept-board image from that conversation to Codex alongside this document. Exact scene coordinates outside authored A1 core must be proposed/approved, not inferred from concept art.
>
> The playable target for **Region A1 only** is 4096 × 4096 m. Other regions B–I are future reservations, NOT complete locations.
>
> First-person **art reference camera** at human eye height; preserve the game's existing third-person gameplay camera unless explicitly approved.

## Preview board index (left-to-right, top-to-bottom)

| Panel | Area | Status / reference | Construction requirements |
| --- | --- | --- | --- |
| 1 TOP LEFT | **Ancient woodland trail** | New biome visual direction; existing House A / Chapter 01 forest gameplay is canon | Tall varied oaks/birches/pines, layered canopy, fern and moss understory, exposed roots, irregular walking path, soft shafts of light, clear gameplay silhouette and paths, no obvious repeating trees |
| 2 TOP RIGHT | **Alpine wildflower meadow / rolling hills** | New A1 expansion art target, not yet a canonical story scene | Traversable gentle hills, meadow clearings, patches of flower species grouped by habitat, isolated trees, distant mountains, small trails linking to forest, use native terrain collision instead of decorative backdrop |
| 3 MIDDLE LEFT | **River, bank and timber bridge** | Existing A1 core already has a bridge and river—preserve existing exact landmark | Clean readable turquoise shallows, stony banks, bankside plants, authored timber bridge, transitioning woodland, stream bends; no new bridge duplicate unless road topology requires it |
| 4 MIDDLE RIGHT | **Village A streets and small farms** | Existing 21 building exteriors in latest Village A source; preserve structures, village story and coordinates | Distinct building silhouettes, stone/earth path, flower planters, tended vegetable beds, low wooden fences, gathering spaces, trees at meaningful positions; no wholesale village replacement, no new lore |
| 5 BOTTOM LEFT | **Highland panoramic overlook** | Planned explorable expanded A1 zone; one existing smaller overlook must be preserved | Actually walkable ridge/plateau, layered foothills, sweeping view of forest and lake, scenic rocks, safety against falling/glitching, distant LOD/haze, path back to A1 main route |
| 6 BOTTOM RIGHT | **Explorable underwater lake zone** | Experimental standalone lake has water, bathymetric terrain and swim/dive code; runtime unverified | Clear shallow-to-deep transition, underwater terrain/collision, stones, algae/aquatic plants, light shafts and blue atmospheric attenuation, schools of fish as visual prototypes, accessible water entry/exit, optional deeper cave/rock arch exploratory space—not a canon quest, fishing gameplay FUTURE |

## Shared art system

- **Refined classic low-poly / premium stylized 3D**: authored silhouette and material quality over primitive stacking, cohesive nature palette, crisp scene readability, daytime baseline.
- Geometry and material budgets must be **feasible in Godot 4.6.3 Compatibility**. These concept images are painterly aspiration, not a pixel-perfect 1:1 shader/render target.
- Use approved Quaternius/Kenney and existing locally authored GLB assets; preserve CC0 source provenance. New assets must be reviewed for licensing and consistent materials.
- The **same region season/weather clock** must govern all six areas: spring flowers, lush summer, colorful autumn, winter without summer crops/flowers, snow where climatic design supports it. Do not just recolor the sky.
- World coordinates, camera, collisions, chunk boundaries, lake shoreline, water volume, map M and exploration discovery must agree.
- Do not invent extra story locations, lore, NPCs or quests simply to match scenery.
- **Avoid duplicate landmarks**: keep original House A, Village A and bridge; expand outward using a coordinate adapter.

## Recommended implementation order

1. **World topology / biome zoning:** lay out paths and terrain connectivity before placing decorative plants. Preserve existing core. Make full A1 bounds accessible in progressive sections using chunk streaming.
2. **Lake / river / shoreline geometry:** robust traversable surfaces and diveable bottom; make underwater distinct from aerial props.
3. **Terrain composition:** forest valleys, gentle hills, mountains and real overlooks, authored silhouette rather than random hills/noise only.
4. **Visual vertical slices:** build one `~100 m` playable composition in each of the six biomes, with real in-game screenshots.
5. **Expand biomes to chunk populations** with vegetation catalogs, LOD and culling only after slices are approved.
6. **Test** in real Godot; video gameplay normal speed with walking between areas and diving, collision checks, perf on GPU and seasonal transitions.

## Visual acceptance by zone

| Zone | Demonstration |
| --- | --- |
| Forest | Walking from House A onto varied woodland path, no tree repetition/clipping |
| Meadow | Moving across raised terrain; varied flower patches and view toward ridges |
| River | Cross bridge; can approach shallow banks; no floating shore meshes |
| Village | Walk full length across 21 preserved buildings, with real gardens and paths |
| Lookout | Walk onto cliff-safe scenic route, see integrated lake, forests and ridges |
| Lake bottom | Enter at shallow shore, swim, dive to bottom, return to surface and pier |

Capture paired **concept reference vs real Godot render** at similar eye height/FOV for each zone. Keep a measurable gameplay-performance budget. Do not pretend the generated concept board is current gameplay.

## Developer handoff

Read `docs/world/A1_SUPERWORLD_AI_HANDOFF.md`, `docs/world/A1_SUPERWORLD_INTEGRATION_PLAN.md`, and `docs/world/SUPERWORLD_REGIONS_DRAFT.json` before implementing. Use `prototype/a1-superworld-4km` as an integration branch, not production release. Create draft PR; no self-merging.
