# Forest Post Café development

Godot 4.6.3 stable, GDScript, Windows PC, Compatibility renderer. Start with
README.md and docs/game-concept.md, art-direction.md, and art-prompts.md.
Existing concept documents remain historical design references; implementation
status and play instructions are in docs/phase-01.md.

Use the existing isolated checkout; do not create worktrees unless requested.
Architecture: scenes/world/forest_hub.tscn composes the hub; reusable player and
mailbox scenes live in scenes/player and scenes/props. ForestShapes builds shared matte
primitive geometry; woodland.gd batches clustered vegetation, with seasonal art
data in ForestPalette / assets/palettes/early_autumn.tres; player movement, camera and interactions have separate scripts.
Interactables join the interactables group and expose interaction_radius,
interaction_name and an activated(title, message) signal. UI owns modal input lock.

Use typed GDScript where practical, tabs, snake_case functions/files, PascalCase
classes. Keep geometry deterministic, lightweight and collision shapes simple.
Use canonical palette and architecture from docs/art-direction.md. Generated
primitive assets are authored here; preserve assets/concept-art and original docs.
Do not introduce paid assets, addons, networking, inventory, quests, save systems,
or bicycle riding in Phase 01. Never commit .godot/ or exported builds.

Validation (from repository root):
- godot --headless --editor --path . --quit
- godot --headless --path . --quit-after 120
- godot --headless --path . --script tests/smoke_test.gd
- With a display: godot --path . (manually check visuals, WASD, Shift, wheel, E, Esc).
Headless checks do not establish Windows or graphical playtesting. Commit .uid
sidecars. Work on feature branches and submit a PR; never auto-merge.

Current visual target: Early Autumn Cozy Forest. See docs/early-autumn-art-pass.md
for composition, palette, capture commands and screenshots. Keep the clearing and
mailbox approach open; do not scatter large trees into the southeast camera corridor.

Latest composition guide: docs/composition-depth-pass.md. ClearingLayout owns the
path curve/width; use it for road edges and verge planting. Preserve the open roof
sightline, the southeast camera corridor, the left seating cluster and right postal
corner. Background trees must use the same elevation function as their terrain.

Current environment uses licensed external Kenney GLBs. Read docs/asset-kitbash-slice.md
and assets/vendor/kenney/README.md. FieldAssets owns runtime normalization/material
styling; cafe_kit.gd assembles imported architecture. Preserve source bytes and
manifest.json; verify with python tools/verify_vendor_assets.py. Do not restore
procedural cone trees or treat player/bicycle/mailbox placeholders as production.
Run tests/imported_assets_test.gd with a real rendering display (GPU MultiMesh
readback); keep tests/smoke_test.gd for headless gameplay regression.

Publish each session's review screenshots to a separate preview/ver-XX-name branch,
with its code SHA in a README. See docs/previews.md. Keep screenshot PNGs out of
code branches and preserve older preview versions. Runtime asset textures stay in
assets/vendor; this rule concerns review images.

## Current user priority — Map 01 V04
Only improve the existing Map 01. Preserve the -24..24 playable bounds, café clearing,
S path and mailbox x=3.6/z=3.5. No Map 02, regions, creek/bridge expansion, bicycle
systems or other gameplay features. The earlier V04 expansion brief was superseded.
Read docs/map01-v04-art-review.md. ForestLandscape owns the shared mesh/collider
height function. Quaternius CC0 assets supplement Kenney; verify both manifests.
User visual approval of Map 01 is required before starting any additional map or
gameplay system. Passing tests is not visual approval; current premium target is
not yet met. Publish this session to preview/ver-04-map01-art-pass, preserve ver-01/02/03.

## V05 architecture review takes priority
Read docs/v05-hero-building-review.md. Review only the hero café, preserve Map 01 and gameplay. Blender source lives under art_source/hero_cafe_v05, runtime GLB under assets/hero_cafe. Do not restore primitive building assembly. User avatar is user-owned, 52 bones, no clips; preserve original source bytes. Validate with tools/validate_hero_asset.py and display integration test. Publish V05 screenshots only to preview/ver-05-hero-building; preserve ver-01 through ver-04. User art approval is still pending; do not claim premium completion or start another map.

## V06 user feedback supersedes architecture-only review
The user likes the V05 house: preserve its GLB/materials/collision/lights. V06 changes grass and colors the user-owned avatar. Read docs/v06-grass-character-color.md. Runtime loads postal_worker_colored_v06.glb; preserve base.glb unchanged. Use tools/validate_v06_assets.py. Do not restore gray-only avatar or broad leaf meshes as grass. Preserve the 52-bone rig and existing movement. Save V06 review images on preview/ver-06-grass-character-color, retaining older versions. No new map or gameplay systems.

## V07 latest character instruction overrides prior face/role requests
Read docs/v07-character-roles.md and assets/characters/roster.json. Samatha is the temporary player, with original embedded color textures and 66-bone rig. WASD/Shift uses supplied Walking/Running; idle is a static lowered-arm pose, not a new clip. The old V06 actor is NPC `eggeght`; stop editing its face. Joe upload is gray-only: retain source but do not load it into active gameplay. Only colored models may be active. Preserve V05 house, V06 grass and Map 01 systems. Validate with tools/validate_characters.py plus display integration, including lowered arms before/after movement. Publish this session only to preview/ver-07-samatha-player, keeping V01–V06 intact.

## Current request: Map 01 ground/environment only
Read docs/map01-ground-environment-review.md. The café is accepted: do not modify cafe_kit.gd or hero building assets. Preserve current characters, player/camera/collision and S path/48 m bounds. Ground shaders, meadow/forest floor habitats and environmental lighting are the current scope. Original floor mesh source is art_source/forest_floor; validate with tools/validate_ground_environment.py and existing gameplay/integration tests plus ground_environment_scope_test.gd. User explicitly requests preview/ver-05-ground-environment for this session; preserve every existing preview branch, including V05 hero and V07 characters. Include matched V04 and current-baseline before captures; do not attribute pre-existing house changes to this pass. Visual approval remains pending; tests do not establish premium art quality.

Godot 4.6 Compatibility now supports SSAO. This pass tested a frozen camera/wind A/B and enables mild SSAO (.55 radius/.65 intensity/1.1 power). Do not repeat older claims that Compatibility lacks SSAO. Forward+ still failed Vulkan initialization on this cloud host. No baked indirect GI was added.

## Current priority: sky/sun/shadow/atmosphere only
Read docs/sky-sun-atmosphere-review.md. Preserve all PR09 assets, shaders, vegetation, geometry, placement, café local lights, actors, gameplay and renderer. Only forest_hub.lighting() delegates to a static preset rig. Golden Hour is default; Blue Hour is independent cinematic mode, no clock/day-night system. Use assets/lighting resources, --lighting=blue_hour, and capture_lighting.gd for the five matched views including PR09 baseline. Preserve SSAO .55/.65/1.1. Validate with validate_lighting_scope.py and existing tests. Next unused preview checked from remote is preview/ver-08-lighting-presets. Preserve earlier branches; do not merge or expand into ground/asset changes from the broader attachment.

## User-requested branch cleanup supersedes old branch retention rules
Read docs/branch-management.md and docs/branch-archive-2026-11-17.json. Keep main, 3D_model, current feature/map01-lighting-presets and latest preview/ver-08-lighting-presets as branch heads. Older code and preview snapshots are preserved as same-name tags at their original commits, so existing links work. Prefer the current code branch and consolidated PR #10 for follow-up edits unless the user asks for a new branch. Count both tags and branches when choosing preview versions; archive older heads only after verifying their tags remotely. Do not recreate the retired feature/preview branches by default. PR #1–9 are historical and closed without merge; PR #10 targets main. Main and the user 3D_model branch remain unchanged. No merge or visual approval is implied by cleanup.

## V09 grass, coherent wind and dynamic weather supersede static-only scope
Read docs/grass-sky-weather-v09.md. Current user requests dense layered grass with a 5x5 m test, Inspector density/masks,
Low-Ultra LOD presets, anchored directional gusts, continuous time/sky/clouds,
moon, rain/wetness/audio and runtime synchronization of existing cafe lights/glass
emission. Preserve original cafe/actor/vendor assets, cafe_kit, tree placements,
terrain/path geometry, gameplay/collision/camera and Compatibility. Static
--lighting=golden_hour/blue_hour/baseline remain reference modes; default now runs
a configurable 20-minute day beginning at 16:30. Terrain3D is absent; use the existing sampler and custom chunks, do not claim native
Terrain3D integration. Rejected Blender grass trials were removed; current geometry
is the original procedural fallback under environment/vegetation. Inspect meadow_demo before
mass replacement; do not claim art approval from tests. Validate with
validate_environment_rebuild.py, existing ground/gameplay/integration tests and
weather_cycle_test.gd. Capture actual PNGs and motion frames. Continue PR #10;
preview/ver-09-grass-sky-weather is next unused. Archive ver-08 head as its identical
same-name tag after verification; keep only latest preview as a branch. No merge.

Latest follow-up also authorizes small white/purple flower groups, mushrooms and
small stones around meadow edges. Keep path/porch/mailbox approaches clear.

## V11 latest menu/backdrop/biodiversity feedback
Read docs/v11-atmosphere-habitats.md. Continue the user's 3351c01 V10 on current feature/map01-lighting-presets. Preserve approved cafe/grass and gameplay. Current pass adds illustrated mood/weather cards, daylight dial, broader scenic ridges and small authored habitats; no new map/quests/renderer switch. Capture actual Godot images to preview/ver-11-atmosphere-habitats. Preserve earlier preview refs and do not merge. The earlier uncommitted cloud draft was preserved in stash; do not pop it over this code.

## V12 Storybook UI identity supersedes menu-only tweaks
Read docs/v12-ui-identity.md and docs/ui-design-system.md. Current pass rebuilds title/pause/settings/letter presentation, separates Atmosphere Studio, retains genuine interaction content and adds no fake Save/Quest. Shared theme and original drawn postal components live in scripts/ui. Preserve café, approved grass, world/weather simulation and gameplay. Run tests/v12_ui_test.gd plus regressions; capture tools/capture_v12_ui.gd at 720p and 1080p. Publish preview/ver-12-storybook-ui, preserve previous refs and do not merge.

Latest V12 correction: weather is AUTOMATIC. Remove public weather/time pickers; Atmosphere Studio is test-only behind --atmosphere-debug. Official title is an illustrated pen/gouache postcard with Caveat handwriting and irregular ink buttons, not a scenic 3D menu or a data dashboard. Preserve the real 3D world. See rewritten docs/v12-ui-identity.md; earlier V12 postcard-picker screenshots are superseded.
