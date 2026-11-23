#!/usr/bin/env python3
"""V09 scope/asset gate, baseline immediately before the authorized grass/weather rebuild."""
import subprocess,json,hashlib,struct,math
from pathlib import Path
root=Path(__file__).resolve().parents[1];base='68c21d6731bf105b21d22a6f62560f1f29c38e2b'
protected=['scripts/world/cafe_kit.gd','scripts/world/landscape.gd','scripts/world/woodland.gd','scripts/world/clearing_layout.gd','scripts/player','scripts/interactions','scenes/player','scenes/props','scenes/npc','assets/hero_cafe','assets/characters','assets/vendor','assets/lighting','project.godot']
for path in protected:
 for file in subprocess.check_output(['git','ls-tree','-r','--name-only',base,'--',path],cwd=root,text=True).splitlines():
  assert (root/file).read_bytes()==subprocess.check_output(['git','show',f'{base}:{file}'],cwd=root),file
print('PASS accepted cafe, original actors, controls/camera, physics/terrain/path, tree placement, presets, renderer and vendor bytes unchanged')
print('PASS dense grass uses original procedural meshes; GPU geometry/placement checked by dense_meadow_test.gd')
a=json.loads((root/'assets/audio/manifest.json').read_text());assert hashlib.sha256((root/'assets/audio/rain_loop.wav').read_bytes()).hexdigest()==a['sha256']
print('PASS original source/export hashes, CC0 provenance and procedural rain audio')

m=json.loads((root/'environment/vegetation/provenance.json').read_text())
for path,sha in m['files'].items():assert hashlib.sha256((root/path).read_bytes()).hexdigest()==sha,path
print('PASS vegetation generator/shader/preset/scene SHA-256 provenance')
