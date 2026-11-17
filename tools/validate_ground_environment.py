#!/usr/bin/env python3
"""Read-only evidence: protected café/gameplay bytes, unchanged terrain functions, small assets."""
from pathlib import Path
import hashlib,json,re,struct,math,subprocess
ROOT=Path(__file__).resolve().parents[1]
BASE='e5900df3f9a5df304df845521c3903e94b779649'
def baseline(path):return subprocess.check_output(['git','show',f'{BASE}:{path}'],cwd=ROOT)
protected=['scripts/world/cafe_kit.gd','assets/hero_cafe/forest_post_cafe_v05.glb','scripts/world/clearing_layout.gd','scripts/player/postal_worker.gd','scripts/player/follow_camera.gd','scenes/player/postal_worker.tscn','scenes/props/mailbox.tscn','scripts/interactions/interaction_controller.gd','project.godot']
for path in protected:assert (ROOT/path).read_bytes()==baseline(path),path
print('PASS protected café asset/loader, player/controller/camera/mailbox/path layout and renderer configuration are byte-identical to baseline')
def function(text,name):
 match=re.search(r'^(?:static )?func '+re.escape(name)+r'\(.*?(?=^(?:static )?func |\Z)',text,re.S|re.M)
 assert match,name
 return match.group(0).strip()
for path,names in [('scripts/world/landscape.gd',['sculpt','height_at','road_point','on_road','_ready']),('scripts/world/woodland.gd',['_ready','trunk_collision'])]:
 old=baseline(path).decode();new=(ROOT/path).read_text()
 for name in names:assert function(old,name)==function(new,name),(path,name)
print('PASS shared terrain height/collision limits, S centerline/core width and tree placements/colliders unchanged')
old=baseline('scripts/world/forest_hub.gd').decode();new=(ROOT/'scripts/world/forest_hub.gd').read_text()
new=new.replace('\tvar floor_cover := preload("res://scripts/world/ground_cover.gd").new()\n\tfloor_cover.name = "CuratedGroundCover"\n\tadd_child(floor_cover)\n','')
assert old.replace(function(old,'lighting'),'')==new.replace(function(new,'lighting'),'')
print('PASS hub changes only add the visual floor node and adjust environmental lighting')
report=json.loads((ROOT/'art_source/forest_floor/build_report.json').read_text())
for item in report:
 p=ROOT/f'assets/vegetation/forest_floor/{item["name"]}.glb';raw=p.read_bytes()
 magic,version,length=struct.unpack_from('<III',raw);assert magic==0x46546c67 and version==2 and length==len(raw)
 size,kind=struct.unpack_from('<II',raw,12);j=json.loads(raw[20:20+size]);offset=20+size
 size,kind=struct.unpack_from('<II',raw,offset);b=raw[offset+8:offset+8+size]
 assert not j.get('images') and not j.get('skins')
 tri=0
 for mesh in j['meshes']:
  for prim in mesh['primitives']:
   assert 'COLOR_0'in prim['attributes']
   a=j['accessors'][prim['attributes']['POSITION']];v=j['bufferViews'][a['bufferView']]
   start=v.get('byteOffset',0)+a.get('byteOffset',0)
   for n in range(a['count']):assert all(math.isfinite(x)for x in struct.unpack_from('<fff',b,start+n*v.get('byteStride',12)))
   tri+=j['accessors'][prim['indices']]['count']//3
 assert tri==item['triangles'] and tri<=256,(p,tri)
 print(f'PASS {item["name"]}: {tri} triangles, vertex root/tip colors, no texture dependencies')
manifest=ROOT/'assets/vegetation/forest_floor/manifest.json'
for row in json.loads(manifest.read_text())['files']:
 assert hashlib.sha256((ROOT/row['path']).read_bytes()).hexdigest()==row['sha256'],row['path']
print('PASS authored source/export SHA-256 roster')
