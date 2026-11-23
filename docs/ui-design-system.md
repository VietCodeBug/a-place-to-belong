# Forest Post — Illustrated Storybook UI

## Palette and typography

Forest #253D32 covers body ink, primary menu buttons and overlays. Sage #496B59 marks secondary text and active tabs. Cream #F6E8D0 is the paper and light text. Oak #B88254 accents stationery and letters. Coral #C85E55 marks seals, selected postcards and keyboard focus.

`storybook_theme.gd` supplies the shared theme. Caveat (SIL OFL) is used for the game title and English menu lettering. DejaVu Sans is used for Vietnamese menu text, body copy and tabs. DejaVu Sans is copied unmodified from the host; Caveat is copied unmodified from the official Google Fonts repository under SIL OFL (assets/ui/fonts/Caveat-OFL.txt). Caveat falls back to bundled DejaVu Sans for Vietnamese glyphs that it lacks; handwriting is not claimed to cover every Vietnamese character by itself. No external reference screenshot is used as an in-game asset. Final postcard sketches are AI-generated in a simplified hand-drawn visual style; prompts, source paths and SHA-256 are in assets/ui/postcards/provenance.json. They are not claimed to be drawn by a human illustrator. Earlier detailed fantasy paintings were rejected and are not integrated.

Body/control text: 16 px; descriptions: 13–15 px; small postal captions: 11 px; paper-page headings: 29–44 px; title: 82 px. Spacing: 12–14 px between controls, 28/22 px paper padding, minimum main button height 46 px. Canvas logical design size: 1280×720, stretched with Godot canvas_items at 1920×1080.

## Components and states

- PostalMark: original vector envelope/steam cancellation mark; reused as coral wax seal.
- Paper style: cream surface, restrained oak border/shadow. Tab pages use a slightly darker paper inset, sage active tab.
- Primary actions use forest green fill and cream text. Title secondary actions use transparent backgrounds. Keyboard focus has a coral edge; hover uses sage.
- Debug-only postcards (absent from the official title/pause): three distinct ImageGen-generated pen-and-gouache style illustrations (cottage/mailbox; rain through a café window; lit woodland hut), cream margins and captions. Selected state persists with coral border/check stamp; keyboard focus remains distinguishable. Hover/focus tilt uses 7 units/sec interpolation, max 0.025 radians.
- Envelope reveal: 0.32 s flap opening, 0.20 s fade; actual modal content stays intact beneath. Letter scale reveal: 0.25 s; text reveal: 0.8 s. Existing NPC messages use the same typography/text reveal; no fabricated dialogue choices/portraits.
- Notifications report actual correspondence-close events; no invented quest/reward.
- Short UI ticks are synthesized locally. Quiet UI disables those ticks, postcard movement, envelope and text reveal. It does not freeze the 3D world or remove keyboard focus.

## Navigation and scope

The main menu frames the live forest clearing with cream paper and ink borders. The first button starts Map 01 (Office). The second opens Map 02 (Forest) directly. Leaving the office after reading the email opens the rented apartment for PRO-003.

Each map uses the same pause layout with its map name, Continue, Settings, Controls, Main menu and Quit. Atmosphere Studio is available in Forest with `--atmosphere-debug`. Weather runs automatically.

The settings tabs are Audio, Display, Controls and Accessibility. Master volume, fullscreen and quiet UI apply to both maps for the session. Grass detail applies to the forest. The control reference reflects the current map.

Opening a page raises it above title/pause, transfers focus, and consumes pointer input. Esc returns to the underlying menu before resuming play. Exiting the title restores the original gameplay camera/controller. Letter close cancels its envelope transition, restores walking, and preserves the existing interaction API.

No new save, inventory, quest, journal database, NPC portrait or localization system is included. Typography supports Vietnamese; this pass does not translate the whole game. Contrast is chosen for legibility but has not undergone a formal accessibility audit.
