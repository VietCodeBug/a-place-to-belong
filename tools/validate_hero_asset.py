#!/usr/bin/env python3
"""Read-only checks for the authored hero and the user's unchanged rig."""
from pathlib import Path
import json,struct,hashlib,math
ROOT=Path(__file__).resolve().parents[1]
def glb(path):
 b=path.read_bytes();magic,version,length=struct.unpack_from('<III',b)
 assert magic==0x46546c67 and version==2 and length==len(b),path
 chunks={};off=12
 while off<len(b):
  size,kind=struct.unpack_from('<II',b,off);off+=8
  assert off+size<=len(b)
  chunks[kind]=b[off:off+size];off+=size
 return json.loads(chunks[0x4e4f534a]),chunks.get(0x004e4942,b''),hashlib.sha256(b).hexdigest()
def values(j,b,index):
 a=j['accessors'][index];v=j['bufferViews'][a['bufferView']]
 components={'SCALAR':1,'VEC2':2,'VEC3':3,'VEC4':4,'MAT4':16}[a['type']]
 code,width={5121:('B',1),5123:('H',2),5125:('I',4),5126:('f',4)}[a['componentType']]
 start=v.get('byteOffset',0)+a.get('byteOffset',0);stride=v.get('byteStride',components*width)
 assert start+(a['count']-1)*stride+components*width<=len(b)
 return [struct.unpack_from('<'+code*components,b,start+i*stride) for i in range(a['count'])]
def geometry(j,b):
 triangles=0
 for mesh in j['meshes']:
  for p in mesh['primitives']:
   assert p.get('mode',4)==4
   positions=values(j,b,p['attributes']['POSITION'])
   assert all(math.isfinite(n) for row in positions for n in row)
   if 'indices' in p:
    ids=values(j,b,p['indices']);assert max(x[0] for x in ids)<len(positions)
    triangles+=len(ids)//3
   else:triangles+=len(positions)//3
 return triangles
hero=ROOT/'assets/hero_cafe/forest_post_cafe_v05.glb'
j,b,digest=glb(hero);triangles=geometry(j,b)
spec=json.loads((ROOT/'art_source/hero_cafe_v05/spec.json').read_text())
assert triangles<=spec['budgets']['triangles_max'],triangles
assert len(j['materials'])<=spec['budgets']['materials_max']
assert not j.get('skins') and not j.get('images')
assert {'door','MainHallRoof','PorchDeck'} <= {x.get('name') for x in j['nodes']}
for m in j['materials']:
 pbr=m.get('pbrMetallicRoughness',{})
 assert 0<=pbr.get('roughnessFactor',1)<=1 and 0<=pbr.get('metallicFactor',1)<=1
print(f'PASS hero: {triangles} triangles, {len(j["meshes"])} meshes, {len(j["materials"])} PBR materials, no external textures; stable semantic nodes; sha256={digest}')
avatar=ROOT/'assets/characters/postal_worker/base.glb'
a,buf,rig_hash=glb(avatar);geometry(a,buf)
assert rig_hash=='d2be0aa5d6c98eaed3541fc3a4f56bde0f291c9d3747e234884a4aa29dc76232'
assert len(a['skins'])==1 and len(a['skins'][0]['joints'])==52
assert len(a.get('animations',[]))==0
for mesh in a['meshes']:
 for p in mesh['primitives']:
  joints=values(a,buf,p['attributes']['JOINTS_0'])
  weights=values(a,buf,p['attributes']['WEIGHTS_0'])
  assert len(joints)==len(weights)
  assert all(0<=v<52 for row in joints for v in row)
  assert all(math.isfinite(v) and 0<=v<=1 for row in weights for v in row)
  assert all(sum(row)>0 for row in weights)
  non_unit=sum(abs(sum(row)-1)>=0.02 for row in weights)
  print(f"NOTE source rig: {non_unit}/{len(weights)} vertices have weight sums outside 1 ± 0.02; source retained unchanged")
print('PASS user avatar: original SHA-256 preserved, 52 skin joints, finite positive weights and valid joint indices, 0 animation clips')
for folder in ['assets/hero_cafe','assets/characters/postal_worker']:
 manifest=ROOT/folder/'manifest.json'
 if manifest.is_file():
  for record in json.loads(manifest.read_text())['files']:
   path=ROOT/record['path']
   assert hashlib.sha256(path.read_bytes()).hexdigest()==record['sha256'],path
  print('PASS provenance roster:',folder)
