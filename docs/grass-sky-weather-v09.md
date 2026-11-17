# V09 — Thảm cỏ dày, gió, bầu trời và thời tiết

Bản làm việc tiếp tục trên PR #10 / `feature/map01-lighting-presets`. Không merge.
Preview: https://github.com/VietCodeBug/forest-post-cafe/tree/preview/ver-09-grass-sky-weather

Đã thay cách rải cỏ lưa thưa bằng carpet thấp 24 lá/cụm, main tufts 16 lá và accent
12 lá. Nền đồng cỏ đổi sang xanh vàng gần màu chân cỏ; bỏ giảm mật độ .3 trên cả
hình chữ nhật trước quán. Hoa trắng/tím, vài cụm nấm màu nâu cam/vàng nhạt và đá
Kenney nhỏ bổ sung ở rìa cỏ/gốc cây, không chắn đường. Lần sinh High hiện tại có 21.845 carpet, 1.871 main, 12 accent,
60 hoa trắng + 27 hoa tím; thêm 24 nấm và 12 viên đá nhỏ. Không dùng bộ Blender thử
trước đó vì silhouette chưa đạt; geometry hiện tại là procedural mesh gấp cong,
không texture photoreal/alpha card, có scene mẫu 5×5 m riêng.

Dự án thực tế chưa có Terrain3D: giữ `ForestLandscape`, lấy đúng height/normal và
chia MultiMesh 8 m. Không bịa Terrain3D API hoặc nhận đã kiểm thử plugin. Có mask
RGBA vẽ tay, vòng tròn loại trừ, giới hạn độ dốc, Generate/Clear trong Inspector và
bốn preset. Xem [hướng dẫn hệ cỏ](../environment/vegetation/README.md) để dùng.

Quán GLB, cafe_kit, nguồn material quán, nhân vật, controller/camera/UI, terrain,
đường/collision, vị trí cây và giới hạn 48×48 m giữ nguyên byte so với `68c21d6`.
Riêng điều chỉnh đèn/kính phát sáng của quán diễn ra trên bản sao material runtime
theo ngày–đêm, đúng yêu cầu đồng bộ cửa sổ; không sửa file asset được chấp nhận.

## Ngày–đêm và thời tiết

Mặc định bắt đầu 16:30, một ngày dài 1200 giây. Trời sáng/hoàng hôn/đêm chuyển
mượt, mặt trời đổi hướng liên tục, đêm có DirectionalLight mặt trăng. Shader sky
có hai lớp mây noise mềm, trôi chậm, đổi màu/coverage. Giữ Compatibility; không
volumetric fog, GI mới hoặc đổi Forward+. SSAO .55/.65/1.1 giữ nguyên.

```
godot --path . -- --time=12 --pause-time --weather=partly_cloudy
godot --path . -- --time=22 --pause-time --weather=clear
godot --path . -- --weather=heavy_rain --day-seconds=1200 --wind=1.2
godot --path . -- --lighting=golden_hour
godot --path . -- --lighting=blue_hour
```

API thử nghiệm: `ForestWeather.set_time(hours)`, `.paused`, `.day_seconds`,
`.set_weather(name)`. Weather đổi dần khoảng 12 giây, đất ướt/khô chậm hơn.
Không thêm gameplay hoặc UI thời gian. Các preset tĩnh giữ sky/đèn tham chiếu;
không chạy clock/sync cửa sổ khi chọn `--lighting=`.

| Trạng thái | Cloud cover | Rain | Wind cơ sở | Độ che nắng |
| --- | ---: | ---: | ---: | ---: |
| clear | .12 | 0 | .055 | 0 |
| partly_cloudy | .43 | 0 | .08 | .08 |
| overcast | .86 | 0 | .12 | .42 |
| light_rain | .90 | .32 | .15 | .52 |
| heavy_rain | .98 | 1 | .24 | .68 |

Góc mặt trời: X = -60 sin((hours−6)/24 × 2π), Y = -52+(hours−16.5)×15 độ.
Năng lượng ban ngày = max(sin(phase),0)^.35 × 1.3 × (1−cloud_occlusion×.78).
Đèn quán: .60× ban ngày / 1.65× ban đêm so với năng lượng gốc. Kính/đèn lồng:
emission multiplier .65 / 3.0. Màu sky/ambient được nội suy keyframe trong
`scripts/environment/forest_weather.gd`; preset tĩnh vẫn có thông số gốc riêng.

Mưa dùng CPU particles tương thích renderer hiện tại, tối đa 1000 vệt, theo vùng
camera; đất/cỏ tối và giảm roughness khi ướt. Có vùng che mưa đơn giản theo footprint
quán, không phải mô phỏng va chạm hạt lên mọi vật. Âm nền là filtered-noise WAV gốc
8 giây loop CC0, không phải bản thu mưa tự nhiên. Khi chạy Dummy/headless không
phát âm; bản video mưa ghép cùng WAV từ runtime, không phải thu mixer trực tiếp.

## Bằng chứng và giới hạn

Ảnh/video trong preview đều từ Godot; không dùng ảnh AI để đại diện gameplay.
Ảnh before là V08 cùng camera. `matched-golden` dùng đúng ánh sáng Golden Hour để
so sánh thay đổi cỏ; ảnh dynamic thể hiện clock/weather mới. Clip hoàng hôn là tua
nhanh 16:30→19:30, các clip khác chạy animation thời gian thường ở 12 frame/s. Clip cận cỏ 4 giây,
các clip khác 2 giây; đây là export offline, không phải bằng chứng FPS realtime.

Cỏ đã đọc thành thảm kín hơn ở camera gameplay, nhưng nhìn sát vẫn nhận ra mesh
low-poly; hoa nhỏ chưa có đa dạng mỹ thuật như ảnh tham khảo. Mây là các lớp shader
2D trên sky, không phải khối volumetric; góc máy thấp vẫn lộ phần rìa cảnh cũ.
LOD chuyển theo cụm, có thể nhận ra khi zoom chậm. Chưa có Windows GPU benchmark,
chưa thể xác nhận 60 FPS/1080p, không gọi bản này production-ready/premium chỉ vì
test qua. Chưa kiểm thử Terrain3D vì plugin không có trong repo.

## Kiểm thử phiên này

- Import/editor: Godot 4.6.3 parse thành công.
- Dense meadow: 17 kiểm tra qua trên display OpenGL, gồm đọc transform MultiMesh thật.
- Smoke 13, Map scope 11, imported-assets integration 18, lighting presets 16 kiểm tra qua.
- Ground scope 15 và weather-cycle 20 kiểm tra qua; tổng cộng **110 assertion** qua. Log đầy đủ trong preview.
- Guard so sánh byte quán/gameplay/terrain/cây/renderer và manifest Kenney/Quaternius,
  nhân vật đều qua. Không thêm collider cho hoa/nấm/đá trang trí.

Một số lần thoát Godot trên llvmpipe báo hai texture GL chưa giải phóng
(349.524 byte mỗi texture). Đây vẫn là hạn chế kỹ thuật chưa xử lý dứt điểm;
assertion qua không đồng nghĩa log renderer hoàn toàn sạch. Trong quá trình render
không có script/shader runtime error ở lần kiểm tra cuối. Cần kiểm tra lifecycle
bầu trời/GLES và theo dõi bộ nhớ trên GPU thật trước khi coi đủ chuẩn production.

Ảnh PNG dùng High. Clip cận cỏ dùng High, các clip sau dùng Medium để xuất trên
host phần mềm; đọc capture.json từng clip. Không dùng tốc độ xuất video làm benchmark.
