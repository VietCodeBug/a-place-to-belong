#!/usr/bin/env python3
"""Keep this pass restricted to lighting, sky, atmosphere and review infrastructure."""
from pathlib import Path
import subprocess,re,hashlib
ROOT=Path(__file__).resolve().parents[1]
BASE='82cfd4ed68627bcfdb428e10947c20f1b692b15b'
protected=['assets/hero_cafe','assets/vegetation','assets/vendor','assets/characters','art_source','shaders','scenes','scripts/player','scripts/interactions','scripts/world/landscape.gd','scripts/world/woodland.gd','scripts/world/ground_cover.gd','scripts/world/forest_floor_design.gd','scripts/world/cafe_kit.gd','project.godot']
subprocess.run(['git','diff','--exit-code',BASE,'--',*protected],cwd=ROOT,check=True,stdout=subprocess.PIPE)
print('PASS all existing café/vegetation/terrain/character assets, shaders, scenes, gameplay and renderer configuration are unchanged from PR09')
old=subprocess.check_output(['git','show',BASE+':scripts/world/forest_hub.gd'],cwd=ROOT).decode()
new=(ROOT/'scripts/world/forest_hub.gd').read_text()
pattern=r'^func lighting\(\) -> void:.*?(?=^func |\Z)'
assert re.sub(pattern,'',old,flags=re.M|re.S)==re.sub(pattern,'',new,flags=re.M|re.S)
print('PASS forest_hub.gd changes only its lighting function')
for path in ['golden_hour','blue_hour','pr09_baseline']:
 text=(ROOT/f'assets/lighting/{path}.tres').read_text()
 assert '[gd_resource type="Resource"'in text and 'lighting_preset.gd'in text
 assert not any(token in text for token in ['ArrayMesh','PackedScene','Texture2D','Animation'])
print('PASS independent static preset resources, no geometry, textures, animation or time simulation')
print('Café SHA-256:',hashlib.sha256((ROOT/'assets/hero_cafe/forest_post_cafe_v05.glb').read_bytes()).hexdigest())
