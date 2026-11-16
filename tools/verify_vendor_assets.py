#!/usr/bin/env python3
"""Verify the manually admitted source-byte lock; no downloads or modifications."""
from pathlib import Path
import hashlib,json,struct,math
root=Path(__file__).resolve().parents[1]/'assets/vendor/kenney'
manifest=json.loads((root/'manifest.json').read_text())
for evidence in manifest.get('license_evidence',[]):
 b=(root/evidence['path']).read_bytes()
 assert hashlib.sha256(b).hexdigest()==evidence['sha256']
 assert b'Creative Commons CC0' in b
seen=set();models=0;triangles=0
for item in manifest['files']:
 p=Path(item['path']);assert not p.is_absolute() and '..' not in p.parts
 assert item['path'] not in seen;seen.add(item['path'])
 b=(root/p).read_bytes();assert len(b)==item['bytes'],str(p)
 assert hashlib.sha256(b).hexdigest()==item['sha256'],str(p)+' SHA-256 mismatch'
 if p.suffix!='.glb':continue
 models+=1
 magic,version,length=struct.unpack_from('<III',b);assert magic==0x46546c67 and version==2 and length==len(b)
 chunks={};offset=12
 while offset<len(b):
  size,kind=struct.unpack_from('<II',b,offset);offset+=8
  assert offset+size<=len(b)
  chunks[kind]=b[offset:offset+size];offset+=size
 j=json.loads(chunks[0x4e4f534a]);binary=chunks[0x004e4942]
 assert not j.get('extensionsRequired') and not j.get('skins')
 for view in j.get('bufferViews',[]):assert view.get('byteOffset',0)+view['byteLength']<=len(binary)
 for image in j.get('images',[]):
  if 'uri' in image:
   uri=Path(image['uri']);assert not uri.is_absolute() and '..' not in uri.parts
   assert (root/p.parent/uri).is_file(),str(p)+' missing texture'
 for mesh in j.get('meshes',[]):
  for prim in mesh['primitives']:
   assert prim.get('mode',4)==4
   a=j['accessors'][prim['attributes']['POSITION']];view=j['bufferViews'][a['bufferView']]
   assert a['componentType']==5126 and a['type']=='VEC3'
   start=view.get('byteOffset',0)+a.get('byteOffset',0);stride=view.get('byteStride',12)
   for i in range(a['count']):assert all(math.isfinite(v) for v in struct.unpack_from('<3f',binary,start+i*stride))
   triangles+=(j['accessors'][prim['indices']]['count'] if 'indices' in prim else a['count'])//3
print(f'PASS: {len(seen)} source files, {models} GLBs, {triangles} source triangles; SHA-256, GLB structure, finite positions and texture paths verified.')
