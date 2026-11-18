# Storybook UI runtime assets

`fonts/StorySerif.ttf` and `fonts/ReadingSans.ttf` are unmodified DejaVu Serif / DejaVu Sans from the host's `/usr/share/fonts/truetype/dejavu`. Original licensing/attribution is included in `fonts/LICENSE.txt` (Bitstream Vera / public-domain DejaVu changes). The project filenames are aliases, not a claim to have designed the fonts.

`postcards/*-sketch.png` are **AI-generated sources in a hand-drawn visual style**, made with the host ImageGen tool for this project. They are not described as human drawings or CC0 stock. See `postcards/provenance.json` for exact prompts, source paths, date and SHA-256. PNG bytes are copied intact. Rejected detailed fantasy paintings and botanical crest trials are not integrated.

Postal emblem, seal, envelope animation and stationery edging are original Godot drawing code under `scripts/ui`.

The game-dev CLI is absent on this environment. Host-native ImageGen was used as allowed by the asset-production workflow; PNG decoding/dimensions/hash checks, Godot import and actual renderer captures were performed locally. No CLI package-verification or Windows performance result is claimed.
