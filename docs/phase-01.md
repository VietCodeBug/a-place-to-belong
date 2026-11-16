# Phase 01 — playable foundation

Godot **4.6.3 stable**, GDScript, 3D, Compatibility renderer. Original concept and
art documents are preserved. This prototype implements a bounded outdoor hub,
not the full game or a café interior.

## Play on Windows
1. Install the standard (non-.NET) Godot 4.6.3 editor from godotengine.org.
2. Clone the repository and select feature/phase-01-godot-foundation (or main once
   the PR is reviewed and merged).
3. Import the repository-root project.godot and press F6 on forest_hub.tscn or F5.
4. WASD walks relative to camera; Shift jogs; mouse wheel zooms. Approach the wooden
   mailbox to the right of the porch, press E, then Esc or click Close letter.

The building exterior is solid. The porch has a shallow approach ramp. The player
is a replaceable low-poly placeholder with idle/walk leg motion and a satchel.
The parked bicycle is scenery. No assets or paid services are needed.

## Architecture
- scenes/world/forest_hub.tscn and scripts/world/forest_hub.gd: deterministic hub,
  cottage, forest, props, ground, morning lighting and scene composition.
- scripts/world/shapes.gd: shared matte materials and geometric primitives.
- scenes/player/postal_worker.tscn: reusable CharacterBody3D; movement and animated
  placeholder in scripts/player/postal_worker.gd; camera in follow_camera.gd.
- scenes/props/mailbox.tscn and scripts/interactions/interactable.gd: reusable
  proximity interaction contract with configurable name, radius and message.
- scripts/interactions/interaction_controller.gd: nearest interaction, controls,
  welcome panel, focus and modal movement lock.

## Cloud setup and validation
The cloud machine is Linux; Windows remains the target platform. Run from
/workspace/forest-post-cafe. `bash tools/setup_godot.sh` installs a pinned,
SHA-512-verified official engine under /workspace/.tools/godot-4.6.3. Use its binary
if `godot` is absent. No server process or secret is required.

```sh
godot --headless --editor --path . --quit
godot --headless --path . --quit-after 120
godot --headless --path . --script tests/smoke_test.gd
```

The functional suite checks ground contact, movement, stopping/idle, building
collision, nearby/far mailbox selection, E opening the exact welcome message,
modal movement lock, Esc dismissal, zoom minimum, and smooth follow convergence.
`tools/capture.gd` captures an actual rendered frame to /tmp/forest-captures/
when run with a working display; headless mode is not a graphics test.

Validated in cloud: editor import, 120-frame startup, 13 functional assertions,
and an OpenGL Compatibility render using Mesa llvmpipe on a temporary Xorg dummy
display. A V-Sync unsupported warning is expected on that software display.

## Limits and next phase
No native Windows execution or export has been validated. To package Windows,
install matching Godot export templates and configure a Windows Desktop export
preset; code signing and installer work are separate. There are no external
textures, audio, production characters or generated concept images.

Before expanding Phase 02, playtest controls and camera on Windows, tune input and
accessibility, profile representative hardware, replace the character asset, then
prototype one short delivery route. Bicycle riding, café management, NPC stories,
quests, inventory, multiplayer, save/load, and time-of-day systems are out of scope.

The current Early Autumn art pass and three rendered review angles are documented
in [early-autumn-art-pass.md](early-autumn-art-pass.md).
