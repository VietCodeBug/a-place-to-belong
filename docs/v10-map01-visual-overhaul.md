# V10 — Nâng cấp toàn diện Map 01: Môi trường, UI/UX, Ánh sáng, Thời tiết & Sinh thái

Tiếp tục trên nhánh `feature/map01-lighting-presets` (PR #10). Không auto-merge.
Preview ảnh runtime: `preview/ver-10-map01-visual-overhaul` (giữ nguyên `preview/ver-09-grass-sky-weather` và toàn bộ tag preview cũ).

## 1. Mười điểm yếu thị giác của V09 đã khắc phục
1. **Lộ rìa địa hình tròn 110 m & hậu cảnh đồi trọc**: Mở rộng chân đồi phi vật lý tới 164 m kết hợp 3 vòng núi/thung lũng low-poly đa lớp (`ForestBackdrop` + `distant_ridge.gdshader`) hòa sương theo giờ và thời tiết.
2. **Tán thông tối đặc, đồng màu**: Nâng cấp `canopy_wind.gdshader` + `woodland.gd` tách sáng–tối theo chiều cao tán, ánh nắng viền tán, sương xa và phối 5 sắc thông/tuyết tùng cùng điểm nhấn bạch dương/sồi thu vàng cam.
3. **HUD kiểu debug & nhãn `"A quiet morning"` cứng**: Thay bằng huy hiệu thời gian–thời tiết nhỏ gọn góc trái trên (icon vector động + giờ thực + trạng thái thời tiết thực).
4. **Thiếu Main Menu & Pause Menu**: Bổ sung **Scenic Main Menu 3D trực tiếp** trên nền quán sống động (chọn nhanh khung giờ/thời tiết, chỉnh chất lượng cỏ V09 Low–Ultra, âm lượng, fullscreen) và **Cozy Pause & Atmosphere Studio** (`[Esc]`).
5. **Hộp thư & nhắc tương tác đơn điệu**: Thiết kế lại thẻ thư giấy kem viền gỗ sồi, dấu sáp đỏ coral, pill tương tác `[E]` giữa dưới màn hình.
6. **Lối đất phẳng, thiếu chuyển tiếp hiên/hòm thư & vũng nước mưa**: Mở rộng đầu đường khớp chân dốc hiên, lát đá bước chân trang trí, thêm vệt bánh xe và **vũng nước mưa phản chiếu bầu trời** (`forest_path.gdshader`).
7. **Tiểu cảnh rời rạc & NPC `eggeght` đứng cứng dạng tay**: Dựng 3 cụm kể chuyện có chủ đích (cột đèn + biển chỉ đường đầu lối, góc bưu kiện & xe gỗ/củi bên hông, góc ghế đọc sách dưới tán bạch dương); hạ tay tự nhiên + nhịp thở idle + hội thoại cho `Eggeght`.
8. **Mây noise 2D mờ**: Viết lại `forest_sky.gdshader` tạo mây cumulus stylized nhiều lớp có đỉnh bắt nắng, bụng mây xanh tím, viền bạc gần mặt trời và sao đêm lấp lánh.
9. **Ban đêm tối bệt**: Tăng ánh trăng bạc dịu, nâng ambient đêm vừa đủ đọc rõ lối đi, mở rộng vùng sáng ấm của đèn quán và 3 cột đèn lối đi/hiên.
10. **Thiếu sự sống & âm thanh rừng**: Thêm `ForestLife` (khói ống khói đúng miệng ống `(-5.35, 7.28, -8.15)`, bướm ven hoa ban ngày, chim lượn trên tán cây, lá thu rơi chậm, đom đóm lập lòe ban đêm) và `ForestAmbience` (gió rừng, chim hót ngày, dế đêm procedural CC0 hòa cùng tiếng mưa).

## 2. Bảo toàn tài nguyên & quy tắc kỹ thuật
- Giữ nguyên 100% byte: `forest_post_cafe_v05.glb`, `cafe_kit.gd`, toàn bộ nhân vật (`samatha.glb`, `postal_worker_colored_v06.glb`, `base.glb`, `npc1.glb`), 58 GLB Kenney/Quaternius, hệ cỏ V09 (`environment/vegetation/*`), preset ánh sáng tĩnh và renderer `gl_compatibility` (SSAO `.55/.65/1.1`).
- Không mở rộng ranh giới di chuyển `-24..24` m; toàn bộ núi xa, cây hậu cảnh và hiệu ứng sinh thái không tạo collider thừa.

## 3. Kiểm thử & Benchmark GPU Windows thực tế
- **8 bộ test Godot (130 assertion)**: `smoke_test` (13), `map01_scope_test` (11), `ground_environment_scope_test` (15), `lighting_presets_test` (16), `weather_cycle_test` (20), `dense_meadow_test` (17), `imported_assets_test` (18), `v10_visual_overhaul_test` (20) — **0 lỗi**.
- **4 trình kiểm tra Python**: `verify_vendor_assets.py`, `validate_hero_asset.py`, `validate_characters.py`, `validate_v10_overhaul.py` — **PASS**.
- **Hiệu năng 1920×1080 (VSync Off, Grass High)** trên **NVIDIA GeForce RTX 3050 Laptop GPU** (Windows, OpenGL 3.3 Compatibility):
  - Gameplay chiều nắng (`golden_gameplay`): **~101.1 FPS** trung bình (9.88 ms/frame)
  - Đêm đèn quán + đom đóm (`night_lanterns_fireflies`): **~113.5 FPS** trung bình (8.80 ms/frame)
  - Mưa lớn + vũng nước (`heavy_rain_puddles`): **~93.8 FPS** trung bình (10.66 ms/frame)
- Lưu ý kỹ thuật còn lại: khi thoát tiến trình OpenGL Compatibility trên driver NVIDIA vẫn còn cảnh báo 2 texture GL nội bộ 349.524 byte tương tự V09; không phát sinh lỗi script/shader lúc chạy.
