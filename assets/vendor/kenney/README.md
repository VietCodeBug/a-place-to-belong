# Kenney CC0 — selected 3D models

Author: **Kenney** — https://www.kenney.nl/

- [Nature Kit](https://www.kenney.nl/assets/nature-kit/)
- [Fantasy Town Kit](https://www.kenney.nl/assets/fantasy-town-kit/)
- [Furniture Kit](https://www.kenney.nl/assets/furniture-kit/)

License: **CC0-1.0**, personal and commercial use and modification permitted.
Attribution is not required; retained here voluntarily. CC0 legal text is in
CC0-1.0.txt. No paid assets, generator jobs, API credentials or attribution-only
models are involved.

The bytes were obtained from the third-party **shorepine/kenney** GitHub mirror,
not downloaded directly from the pack author's archives. Exact repository commit,
paths, byte counts and SHA-256 hashes are in manifest.json. Each download was also
matched to the pinned repository's Git blob hash before admission. Official pack
pages independently state CC0; dated text snapshots and hashes are in
license-evidence/. The mirror's root LICENSE.txt is labelled Castle Kit, so it is
not presented as pack-specific proof for these three kits.

Source GLBs and the referenced atlas are unmodified. Godot .import sidecars are
engine configuration; source-byte verification uses the manifest. Runtime code
normalizes metre scale, sets matte materials, applies a restrained palette, and
combines repeated vegetation into MultiMeshes. This creates derived appearances
without losing the original source files.

The user authorized manual import, manifest/hash checks and Godot integration in
chat because the game-dev CLI is absent. This directory is **not** a game-dev
canonical package and manifest.json is not a receipt from that tool.

Validate without network or writes:

```sh
python tools/verify_vendor_assets.py
```

The selected bundle includes spare compatible modules not all instantiated in the
current scene. See docs/asset-kitbash-slice.md for actual use and placeholders.
