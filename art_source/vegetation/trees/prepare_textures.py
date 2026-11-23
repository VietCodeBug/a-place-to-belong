"""Adapt the verified source textures. Usage: python prepare_textures.py /path/to/Textures."""
import json
import sys
from pathlib import Path

import numpy as np
from PIL import Image

tree_dir = Path(__file__).resolve().parent
output = tree_dir.parents[2] / "assets/vegetation/trees/textures"
manifest = json.loads((tree_dir / "provenance.json").read_text())
output.mkdir(parents=True, exist_ok=True)
for entry in manifest["source_files"]:
    path = Path(entry["mirror_path"])
    if path.suffix != ".png":
        continue
    image = Image.open(Path(sys.argv[1]) / path.name).convert("RGBA")
    image.thumbnail((1024, 1024))
    if path.name.endswith("Tree_Leaves.png"):
        pixels = np.array(image)
        luminance = pixels[:, :, :3] @ np.array([.30, .55, .15])
        visible = luminance[pixels[:, :, 3] > 127]
        neutral = np.clip((luminance - np.median(visible)) * .58 + 172, 95, 222).astype("uint8")
        pixels[:, :, :3] = neutral[:, :, None]
        image = Image.fromarray(pixels)
    image.save(output / path.name, optimize=True)
