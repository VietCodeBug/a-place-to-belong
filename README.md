# A Place to Belong

**A second life, somewhere between dreams and reality.**

An open-world, slice-of-life game focused on healing and exploration, currently in early development. This is the new brand for the project previously called **Forest Post Café**.

## Direction and narrative status

The protagonist is an office worker laid off in the AI era. During a difficult period, they dream of a world provisionally called **XXX**, where they become **A** and begin a second life in a home in the forest.

The story is still being developed. XXX and A remain placeholders; this introduction does not establish additional lore, quests or story outcomes. The new direction describes the intended game, not a claim that an open world or complete narrative has already been implemented.

The creator's narrative documents remain on the preserved [story/forest-post-cafe-narrative branch](https://github.com/VietCodeBug/a-place-to-belong/tree/story/forest-post-cafe-narrative/docs/story). This rename does not edit or replace them. Older concept/art documents retain their historical names and are not automatically the current narrative canon.

## Current prototype

The playable work is on [feature/map01-lighting-presets / PR #10](https://github.com/VietCodeBug/a-place-to-belong/pull/10), which remains unmerged. The default branch still contains the earlier concept baseline until changes are reviewed.

- Godot **4.6.3**, GDScript, 3D, Compatibility renderer; target: Windows PC.
- **Map 01 · Office** opens in first person. Open and reread the HR email at your workstation, then use the exit to enter the rented apartment in PRO-003.
- **Map 02 · Forest** is the existing 48 × 48 m clearing with the café, mailbox and woodland paths. It can also be opened directly from the main menu.
- The apartment plays three moments in the same rented room. It is part of the real-world prologue.
- Both maps share handwritten-style pause menus and session settings. The main menu looks out over the forest clearing.
- The current prototype does not yet implement a complete open world, delivery quest loop, inventory or save system.

The café and postal assets remain part of the prototype. Renaming the game does not redesign the location or alter gameplay.

## Run the development prototype

```bash
git clone --branch feature/map01-lighting-presets https://github.com/VietCodeBug/a-place-to-belong.git
cd a-place-to-belong
godot --editor --path .
```

Install Godot 4.6.3 or use `tools/setup_godot.sh`. Press F5 in the editor or run `godot --path .`. Both maps use WASD to move, Shift to jog, E to interact and Esc to pause. In the office, move the mouse to look around, press F to sit or stand, or Q to check the phone. Office Settings → Controls includes mouse sensitivity and a head bob toggle. In the forest, scroll to change the camera distance. The forest weather test controls require `--atmosphere-debug`.

## Development references

- [Prototype status and controls](https://github.com/VietCodeBug/a-place-to-belong/blob/feature/map01-lighting-presets/docs/phase-01.md)
- [Circular postal UI report](https://github.com/VietCodeBug/a-place-to-belong/blob/feature/map01-lighting-presets/docs/circular-postal-ui.md)
- [UI design system](https://github.com/VietCodeBug/a-place-to-belong/blob/feature/map01-lighting-presets/docs/ui-design-system.md)
- [Versioned previews](https://github.com/VietCodeBug/a-place-to-belong/blob/feature/map01-lighting-presets/docs/previews.md)
- [Rename record and preservation checks](https://github.com/VietCodeBug/a-place-to-belong/blob/feature/map01-lighting-presets/docs/project-rename.md)
- [Asset sources and licensing](https://github.com/VietCodeBug/a-place-to-belong/blob/feature/map01-lighting-presets/assets/vendor/kenney/README.md)

Only three branch heads remain: main, feature/map01-lighting-presets (development), and story/forest-post-cafe-narrative. Historical previews and retired branches are preserved as same-name tags; source assets and Git history remain intact. No existing PR is merged as part of this branding change. Linux cloud checks are not a Windows GPU benchmark.
