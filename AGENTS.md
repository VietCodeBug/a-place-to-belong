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
