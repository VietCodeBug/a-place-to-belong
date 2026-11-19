#!/usr/bin/env python3
"""Verify the colored derivative, original rig retention and small meadow modules."""
from validate_hero_asset import glb,values,geometry,ROOT
import math,json,hashlib
source,srcbuf,source_hash=glb(ROOT/'assets/characters/postal_worker/base.glb')
model,buf,digest=glb(ROOT/'assets/characters/postal_worker/postal_worker_colored_v06.glb')
assert len(model['skins'])==1 and len(model['skins'][0]['joints'])==52
assert not model.get('animations') and not model.get('images')
source_bones={source['nodes'][i]['name'] for i in source['skins'][0]['joints']}
assert source_bones=={model['nodes'][i]['name']for i in model['skins'][0]['joints']}
assert geometry(model,buf)==geometry(source,srcbuf),'coloring must preserve triangle count'
roles={'Skin','Hair','Jacket','Shirt','Trousers','Boots','Leather','Brass','Sole'}
assert roles=={m['name']for m in model['materials']}
assert len({tuple(m['pbrMetallicRoughness']['baseColorFactor'])for m in model['materials']})==9
for mesh in model['meshes']:
 for p in mesh['primitives']:
  weights=values(model,buf,p['attributes']['WEIGHTS_0'])
  joints=values(model,buf,p['attributes']['JOINTS_0'])
  assert all(all(math.isfinite(v) and 0<=v<=1 for v in row) and abs(sum(row)-1)<.001 for row in weights)
  assert all(0<=v<52 for row in joints for v in row)
print('PASS V06 avatar: 9 distinct palette materials; 52 named skin joints retained; triangles unchanged; normalized weights; no added animation')
for i in range(3):
 asset=ROOT/f'assets/vegetation/meadow/tuft_{i}.glb'
 j,b,h=glb(asset);tri=geometry(j,b)
 assert tri<=45 and len(j['meshes'])==1 and not j.get('skins') and not j.get('images')
 assert j['materials'][0].get('doubleSided',False)
 print(f'PASS meadow tuft_{i}: {tri} triangles, double-sided blade material, no external dependencies')
for folder in ['assets/characters/postal_worker','assets/vegetation/meadow']:
 manifest=ROOT/folder/'manifest.json'
 for row in json.loads(manifest.read_text())['files']:
  assert hashlib.sha256((ROOT/row['path']).read_bytes()).hexdigest()==row['sha256']
 print('PASS source and derivative SHA-256 roster:',folder)
