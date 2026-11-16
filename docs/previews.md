# Versioned preview branches

Each visual review session publishes its images to its own `preview/ver-XX-name`
branch. These branches contain only PNGs and a README with source commit, capture
method, renderer and limitations. Keep screenshots out of gameplay branches; keep
runtime textures and licensed source assets in the game project.

| Version | Preview branch | Code reference |
| --- | --- | --- |
| ver-01 | [early-autumn](https://github.com/VietCodeBug/forest-post-cafe/tree/preview/ver-01-early-autumn) | 1950ce3 |
| ver-02 | [composition-depth](https://github.com/VietCodeBug/forest-post-cafe/tree/preview/ver-02-composition-depth) | 31c43cb |
| ver-03 | [kenney-kitbash](https://github.com/VietCodeBug/forest-post-cafe/tree/preview/ver-03-kenney-kitbash) | feature/licensed-asset-vertical-slice; full SHA in preview README |

The initial foundation session has no retained committed screenshot set; it is not
relabelled using later images. Prior images remain recoverable in Git history.

Future sessions increment the version, preserve old preview branches, and record
the exact code commit. The game PR links its preview branch instead of adding PNGs.

V04: [Map 01 art pass](https://github.com/VietCodeBug/forest-post-cafe/tree/preview/ver-04-map01-art-pass)
contains five actual-render after shots plus V03 before images, with full source
SHA. See [the visual review](map01-v04-art-review.md). The earlier environment
expansion direction was superseded; no new map is part of this version.

V05: [Hero building review](https://github.com/VietCodeBug/forest-post-cafe/tree/preview/ver-05-hero-building), five Godot after captures and V04 before references. Source and limitations: [review](v05-hero-building-review.md).

V06: [Grass and character colors](https://github.com/VietCodeBug/forest-post-cafe/tree/preview/ver-06-grass-character-color). [Vietnamese report](v06-grass-character-color.md). House V05 preserved.
