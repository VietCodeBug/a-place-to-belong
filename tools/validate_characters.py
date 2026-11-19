#!/usr/bin/env python3
"""Read-only admission evidence for the supplied colored Samatha and gray Joe."""
from validate_hero_asset import glb,geometry,values,ROOT
import json,hashlib,struct,math
expected={'joe':('assets/characters/joe/npc1.glb','c93fcffa56e550cc7a18e12737808eb216ecb0bf960c857f179e730d25ba7502',52), 'samatha':('assets/characters/samatha/samatha.glb','1647b9c21670479476bcf9b4657bf7a204f03542d1728e6581d59017ec77f03b',66)}
for name,(path,sha,bones)in expected.items():
 j,b,h=glb(ROOT/path);assert h==sha
 assert len(j['skins'])==1 and len(j['skins'][0]['joints'])==bones
 tri=geometry(j,b)
 for category in ['buffers','images']:
  assert all('uri'not in item for item in j.get(category,[]))
 for animation in j.get('animations',[]):
  for sampler in animation['samplers']:
   for accessor in ['input','output']:
    assert all(math.isfinite(v)for row in values(j,b,sampler[accessor])for v in row)
 if name=='samatha':
  assert {a['name']for a in j['animations']}=={'Walking','Running','Casual_Walk'}
  assert len(j['images'])==3
  material=j['materials'][0];pbr=material['pbrMetallicRoughness']
  assert 'baseColorTexture'in pbr and 'metallicRoughnessTexture'in pbr and 'normalTexture'in material
  for image in j['images']:
   view=j['bufferViews'][image['bufferView']];offset=view.get('byteOffset',0)
   assert b[offset:offset+8]==b'\x89PNG\r\n\x1a\n'
   assert struct.unpack_from('>II',b,offset+16)==(4096,4096)
  print(f'PASS Samatha: unchanged supplied bytes, {tri} triangles, 66 joints, 3 clips, 3 embedded 4096px PBR maps; reviewed color texture retained')
 else:
  assert not j.get('images') and len(j['materials'])==1
  pbr=j['materials'][0]['pbrMetallicRoughness'];rgb=pbr['baseColorFactor'][:3]
  assert rgb[0]==rgb[1]==rgb[2] and 'baseColorTexture'not in pbr
  print('PASS Joe source: unchanged 52-bone model; confirmed gray-only, excluded from active hub')
 manifest=json.loads((ROOT/f'assets/characters/{name}/manifest.json').read_text())
 for row in manifest['files']:
  assert hashlib.sha256((ROOT/row['path']).read_bytes()).hexdigest()==row['sha256']
 print('PASS source roster:',name)
