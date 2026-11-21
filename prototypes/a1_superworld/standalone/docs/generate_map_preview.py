#!/usr/bin/env python3
"""Generate deterministic DESIGN ATLAS (not an actual Godot render)."""
import math, random
from pathlib import Path
import numpy as np
from scipy.ndimage import gaussian_filter, zoom
from PIL import Image, ImageDraw, ImageFont, ImageFilter

HERE=Path(__file__).resolve().parents[1]
ASSET=HERE/'assets'
ASSET.mkdir(exist_ok=True)
FONT='/usr/share/fonts/truetype/dejavu/DejaVuSans.ttf'
BOLD='/usr/share/fonts/truetype/dejavu/DejaVuSans-Bold.ttf'
def font(px,bold=False):return ImageFont.truetype(BOLD if bold else FONT,px)
N=1120
r=np.random.default_rng(2468)
y,x=np.mgrid[0:N,0:N]
wx=(x/N-.5)*4096
wz=(y/N-.5)*4096

def smooth(n,s):
    a=r.normal(size=(n,n))
    a=zoom(a,(N/n,N/n),order=3)[:N,:N]
    a=gaussian_filter(a,s)
    return (a-np.mean(a))/(np.std(a)+1e-6)
large=smooth(17,5)
med=smooth(50,2)
fine=smooth(130,.8)
height=24+large*19+med*10+fine*1.5
mountain=np.maximum(np.maximum(np.abs(wx)-680,0)/1500,np.maximum(np.abs(wz)-900,0)/1200)
height+=(np.clip(mountain,0,1)**2)*np.maximum(0,110+large*35)
spine=np.exp(-((wx-23*np.sin(wz*.013))/140)**2)*np.exp(-((wz-190)/590)**4)
height=height*(1-spine*.67)+spine*12*.67
lake=np.sqrt(((wx-780)/430)**2+((wz+530)/310)**2)
lake_mask=lake<1.0
shore=(lake>=1)&(lake<1.15)
river_center=239-wx*.94+73*np.sin(wx*.0037)
river=np.abs(wz-river_center)<12
palette=np.zeros((N,N,3),dtype=np.uint8)
palette[:]=[123,163,120]
palette+=np.clip((large[...,None]*8+fine[...,None]*4),-18,18).astype(np.int16).clip(-50,50).astype(np.uint8) if False else 0
# Regional greens and contour passes.
forest=(med+fine*.3)>.1
palette[forest]=[94,143,111]
palette[(wx<-680)&(wz<-500)]=[73,122,103]
palette[(wx<-450)&(wz>620)]=[145,172,112]
palette[(wx>900)&(wz>280)]=[173,179,115]
palette[(height>78)]=[118,143,125]
palette[(height>145)]=[170,176,158]
palette[shore]=[218,203,150]
palette[river]=[78,150,169]
palette[lake_mask]=[65,150,177]
# Terrain shadow + contour lines
shade=np.clip(.95-np.gradient(height,axis=1)*.11-np.gradient(height,axis=0)*.11,.69,1.11)
contour=(np.abs(np.mod(height,26)-13)<.70)&(height>55)
palette=np.clip(palette.astype(np.float32)*shade[...,None],0,255).astype(np.uint8)
palette[contour]=np.clip(palette[contour].astype(np.float32)*.86,0,255).astype(np.uint8)

W=1570; H=1680
base=Image.new('RGB',(W,H),'#F4EEDB')
d=ImageDraw.Draw(base)
d.rounded_rectangle((35,35,W-35,H-35),radius=23,fill='#F0E6CD',outline='#A58D66',width=3)
d.text((95,70),'A1  /  THE LIVING WILDS',font=font(47,True),fill='#263C35')
d.text((97,132),'4 × 4 km  ·  16.78 km²   ·   WORLD DESIGN PROTOTYPE',font=font(20),fill='#66756A')
map_side=1300
x0,y0=130,205
map_img=Image.fromarray(palette,'RGB').resize((map_side,map_side),Image.Resampling.BILINEAR)
base.paste(map_img,(x0,y0))
d=ImageDraw.Draw(base)
d.rectangle((x0,y0,x0+map_side,y0+map_side),outline='#486855',width=6)
# Map grid. coordinate 128m over 4096 => 32 chunk segments. thin grid 512m.
for j in range(9):
    px=x0+int(j*map_side/8)
    py=y0+int(j*map_side/8)
    d.line((px,y0,px,y0+map_side),fill=(240,238,206),width=1)
    d.line((x0,py,x0+map_side,py),fill=(240,238,206),width=1)

def loc(wx,wz): return (x0+int((wx+2048)/4096*map_side),y0+int((wz+2048)/4096*map_side))
# Trails using curves and smooth lines: core House->Bridge->Village, lake connection.
core=[(-115,15),(-65,100),(-20,158),(0,240),(22,328),(50,455),(25,560)]
branch=[(-115,15),(40,-170),(185,-300),(285,-410),(360,-530)]
for route,col,w in [(core,'#E6C18A',10),(branch,'#D2A974',7)]:
    pts=[loc(*p) for p in route]
    d.line(pts,fill='#6C6650',width=w+3,joint='curve')
    d.line(pts,fill=col,width=w,joint='curve')
# Fishing pier drawn as a bridge into the lake.
d.line([loc(350,-530),loc(530,-530)],fill='#997A58',width=12)
# Forest stamps, never overwrite lake or building area.
rng=random.Random(17)
for _ in range(820):
    px=rng.randrange(x0+10,x0+map_side-10)
    py=rng.randrange(y0+10,y0+map_side-10)
    ix=int((px-x0)/map_side*N)
    iz=int((py-y0)/map_side*N)
    if lake_mask[iz,ix] or river[iz,ix] or height[iz,ix]>170:continue
    wxp=(px-x0)/map_side*4096-2048
    wzp=(py-y0)/map_side*4096-2048
    if abs(wxp)<220 and 330<wzp<720:continue
    if rng.random()<(.30 if height[iz,ix]<55 else .46):continue
    radius=rng.randint(2,4)
    col=rng.choice(['#315E49','#416D55','#5B7A52','#578068'])
    d.ellipse((px-radius,py-radius,px+radius,py+radius),fill=col)
# POIs
points=[
    ('NHÀ A',-115,15,-10,21),('LÀNG A',50,455,16,18),('CẦU GỖ',0,240,-84,-18),
    ('BẾN CÂU CÁ',360,-530,-168,-31),('HỒ ÁNH SAO',780,-530,-50,40),
    ('VƯỜN ĐÁ DƯỚI HỒ',795,-535,35,95),
    ('ĐỒNG CỎ HOA',-600,950,-130,18),('RỪNG CỔ THỤ',-1000,-1050,-155,25),
    ('ĐỈNH NGẮM CẢNH',-1200,710,-15,22),('THUNG LŨNG ĐÔNG',1380,660,-165,-18)
]
for name,xx,zz,ox,oy in points:
    px,py=loc(xx,zz)
    d.ellipse((px-8,py-8,px+8,py+8),fill='#F7E9C2',outline='#263D36',width=2)
    d.text((px+ox,py+oy),name,font=font(15,True),fill='#172F28',stroke_width=3,stroke_fill='#E6E8D5')
# water ripples
for i in range(38):
    ang=rng.random()*math.tau
    rr=math.sqrt(rng.random())
    xx=780+math.cos(ang)*rr*370
    zz=-530+math.sin(ang)*rr*250
    px,py=loc(xx,zz)
    d.arc((px-13,py-4,px+13,py+4),0,150,fill='#E1F0DF',width=2)
# compass
cx,cy=x0+map_side-55,y0+70
d.polygon([(cx,cy-28),(cx-10,cy+13),(cx,cy+7),(cx+10,cy+13)],fill='#E7EAD6',outline='#284438')
d.text((cx-7,cy-53),'N',font=font(23,True),fill='#E9E7CE',stroke_width=2,stroke_fill='#2F483C')
# Footer and legend
d.rectangle((130,1528,1430,1620),fill='#E9DFC8')
for i,(c,txt) in enumerate([('#4E96A9','Hồ & sông'),('#5A916E','Rừng'),('#A6B07C','Thảo nguyên'),('#AAB09E','Dãy núi'),('#E6C18A','Đường khám phá')]):
    sx=147+i*245
    d.rounded_rectangle((sx,1551,sx+20,1574),radius=4,fill=c)
    d.text((sx+28,1550),txt,font=font(18),fill='#364940')
d.text((x0,1628),'Mô phỏng bố cục A1. Khu vực B–I sẽ phát triển sau; chưa có địa hình/gameplay.',font=font(15),fill='#726E61')
base.save(ASSET/'A1_world_design_map.png',optimize=True)

# Superworld region atlas schematic
W2,H2=1550,980
atlas=Image.new('RGB',(W2,H2),'#122525')
a=ImageDraw.Draw(atlas)
a.text((88,66),'SUPERWORLD   /   THE WORLD BEYOND A1',font=font(45,True),fill='#F7E7C1')
a.text((90,125),'Mỗi vùng có bản đồ và streaming riêng · chỉ A1 được dựng trong prototype',font=font(21),fill='#B2C6BB')
labels=[['B','C','D'],['E','A1','F'],['G','H','I']]
for row in range(3):
    for col in range(3):
        x=315+col*314
        y=195+row*230
        active=(row==1 and col==1)
        color='#476F5D' if active else '#213C3B'
        a.rounded_rectangle((x,y,x+292,y+204),radius=12,fill=color,outline='#F0E5C6' if active else '#547775',width=3)
        lab=labels[row][col]
        a.text((x+20,y+29),lab,font=font(48,True),fill='#F1E7CC')
        a.text((x+20,y+104),'4 × 4 km' if active else 'QUY HOẠCH',font=font(21,True),fill='#D6E1D0' if active else '#92ADA7')
        a.text((x+20,y+150),'Rừng · Làng · Hồ 3D' if active else 'Chưa dựng world',font=font(16),fill='#E0E8CE' if active else '#92ADA7')
a.text((87,915),'A1 đã được chuẩn bị dưới dạng Godot project độc lập. Các vùng còn lại là placeholder trong atlas.',font=font(17),fill='#9EB5AC')
atlas.save(ASSET/'SUPERWORLD_regions.png',optimize=True)
print(ASSET/'A1_world_design_map.png')
print(ASSET/'SUPERWORLD_regions.png')
