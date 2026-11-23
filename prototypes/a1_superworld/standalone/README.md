# A PLACE TO BELONG — A1 SUPERWORLD (PLAYABLE PROTOTYPE)

**A1 là một vùng trong thế giới lớn hơn, không phải toàn bộ game.** Đây là một **prototype độc lập cho Godot 4.6.x** để thử quy mô, bản đồ, terrain streaming, hồ và khám phá dưới nước. Không ghi đè project GitHub chính.

## Có gì thật trong bản demo?

- **Region A1 4,096 × 4,096 m = 16.78 km²**: heightmap deterministic, terrain render theo chunk 128 m, collision được tạo khi player tới gần (cùng mesh địa hình).
- **Hồ Ánh Sao ~860 × 620 m**, đáy thấp hơn mặt nước tới khoảng 30 m, bến câu cá, những vùng đá và cây thủy sinh ở dưới nước.
- Bơi nổi/lặn dưới hồ; bến có nút `E` đánh dấu tương tác câu cá **placeholder** (chưa có minigame hay cá hoạt động).
- Nhà A, tuyến cầu, Làng A với các mẫu nhà blockout, các điểm khám phá xa (đồng cỏ hoa, thung lũng, cao nguyên).
- Cây lá kim, cây lá rộng, cỏ, đá bằng `MultiMesh` cho những chunk đang được load.
- **Bản đồ M** được tạo theo cùng hàm địa hình với world 3D. Có player marker, POI, zoom và pan.
- **TAB khi mở M**: bản đồ thế giới tổng quan. B–I là các vùng **dự trữ chưa dựng**; chỉ A1 có terrain/gameplay.
- Đổi 4 màu mùa nhanh bằng F1–F4; đây mới là **visual preview**, chưa có hệ sinh thái seasonal đầy đủ.

## Chạy

1. Cài Godot 4.6.x tại https://godotengine.org/download/ (Godot 4.3+ có thể chạy phần lớn script nhưng 4.6.x là mục tiêu).
2. Giải nén ZIP và mở thư mục `A1_Superworld_Prototype` bằng **Import** trong Godot Project Manager.
3. Bấm F6 nếu đang mở `scenes/world.tscn`, hoặc F5 để chạy project.
4. Khi bắt đầu, rê chuột để nhìn; đi bằng WASD. Có thể dùng phím 1–5 để nhảy giữa các vùng nhằm thử map.

| Phím | Hành động |
|---|---|
| WASD / Shift | Đi / chạy |
| Chuột | Nhìn |
| Space | Nhảy, hoặc bơi lên |
| Ctrl | Lặn xuống (ở dưới nước) |
| M | Mở / đóng bản đồ A1 |
| Tab trong bản đồ | Xem các region tương lai B, C, D, E... |
| Kéo chuột / cuộn trong M | Pan / zoom |
| C | Định tâm người chơi trên bản đồ |
| 1 | Nhà A |
| 2 | Làng A |
| 3 | Bến câu cá hồ lớn |
| 4 | Vườn đá dưới lòng hồ |
| 5 | Đỉnh ngắm cảnh |
| F1/F2/F3/F4 | Xuân/Hạ/Thu/Đông (palette thử) |
| F6 | Chuyển ánh sáng ngày / chiều muộn |
| V | Đổi camera 1st/3rd person |
| E tại bến | Điểm câu cá placeholder |
| Esc | Thả / khóa chuột |

## Những gì CHƯA có

- Đây **không phải sản phẩm hoàn thiện**, mesh nhà/tán cây là blockout Low Poly, không phải asset V4 từ repo gốc.
- Hồ có thể lặn và di chuyển nhưng **chưa có minigame câu cá, đàn cá, hệ thống oxy, hang động có gameplay hoặc câu chuyện dưới hồ**.
- Bản đồ B–I **chỉ là quy hoạch**, chưa có world data, không có travel sang khu khác.
- Chưa có save game, cảnh nhiệm vụ, NPC, nội thất, weather thực, nhiều loại động vật và khả năng streaming quy mô production-grade.
- Chưa tích hợp scene này vào `forest_hub.tscn` hiện tại. Mọi thứ độc lập để tránh rủi ro phá A1 hiện có.

## Cấu trúc dự kiến cho siêu thế giới

```
Superworld
├─ A1   — Prototype 4 × 4 km, forest + village + large explorable lake
├─ B    — RESERVED, chưa có nội dung
├─ C    — RESERVED, chưa có nội dung
├─ D    — RESERVED, chưa có nội dung
├─ E    — RESERVED, chưa có nội dung
└─ ...  — Region registry, world streaming, portals / seamless borders sau này
```

## Lưu ý kiểm thử

Đã kiểm tra khởi chạy project độc lập bằng Godot 4.6.3 Compatibility sau khi sửa GDScript, vị trí spawn và vòng collider. Kiểm thử lộ trình, bơi và benchmark ở project game gốc được ghi trong [báo cáo prototype tích hợp](../../../docs/world/A1_SUPERWORLD_SLICE.md).
