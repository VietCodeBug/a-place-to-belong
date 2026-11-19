#!/usr/bin/env python3
"""V10 technical rules gate: verifies untouched hero cafe, character GLBs, vendor GLBs,
static lighting presets, audio WAV provenance, and locked V09 grass system."""
import hashlib
import json
import subprocess
from pathlib import Path

root = Path(__file__).resolve().parents[1]
base = "2313e7b"

locked_paths = [
    "scripts/world/cafe_kit.gd",
    "scripts/world/clearing_layout.gd",
    "scripts/player/postal_worker.gd",
    "scenes/player",
    "scenes/props",
    "scenes/npc",
    "assets/hero_cafe/forest_post_cafe_v05.glb",
    "assets/hero_cafe/manifest.json",
    "assets/characters/roster.json",
    "assets/characters/samatha/samatha.glb",
    "assets/characters/samatha/manifest.json",
    "assets/characters/postal_worker/base.glb",
    "assets/characters/postal_worker/postal_worker_colored_v06.glb",
    "assets/characters/postal_worker/manifest.json",
    "assets/characters/joe/npc1.glb",
    "assets/characters/joe/manifest.json",
    "assets/lighting",
    "environment/vegetation",
    "project.godot",
]

for rel in locked_paths:
    files = subprocess.check_output(
        ["git", "ls-tree", "-r", "--name-only", base, "--", rel],
        cwd=root,
        text=True,
    ).splitlines()
    for f in files:
        if f.endswith(".import"):
            continue
        expected = subprocess.check_output(["git", "show", f"{base}:{f}"], cwd=root)
        actual = (root / f).read_bytes()
        assert actual == expected, f"Modified locked V10 asset/system: {f}"

audio_manifest = json.loads((root / "assets/audio/manifest.json").read_text())
assert (
    hashlib.sha256((root / "assets/audio/rain_loop.wav").read_bytes()).hexdigest()
    == audio_manifest["sha256"]
)

veg_prov = json.loads((root / "environment/vegetation/provenance.json").read_text())
for path, sha in veg_prov["files"].items():
    assert hashlib.sha256((root / path).read_bytes()).hexdigest() == sha, path

print("PASS: V10 locked assets verified (Cafe GLB/kit, Characters, Lighting presets, V09 Grass, Rain WAV, Renderer).")
