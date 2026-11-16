# Forest Post Café development

Godot 4.6.3 stable, GDScript, Windows PC, Compatibility renderer. Start with
README.md and docs/game-concept.md, art-direction.md, and art-prompts.md.
Existing concept documents remain historical design references; implementation
status and play instructions are in docs/phase-01.md.

Use the existing isolated checkout; do not create worktrees unless requested.
Architecture: scenes/world/forest_hub.tscn composes the hub; reusable player and
mailbox scenes live in scenes/player and scenes/props. ForestShapes builds matte
primitive geometry; player movement, camera and interactions have separate scripts.
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
