# V11 — Menu phong cảnh và các góc rừng sống động

Ngày 18/11/2026. Kế thừa bản người dùng `3351c01`; không merge main.

## Thay đổi

- Menu có ba postcard tự vẽ và chuyển động: Honey light, Forest rain, Firefly dusk. Chọn postcard chuyển giờ/mưa nhẹ trong hai giây thay vì chỉ bấm một nhãn dữ liệu.
- Bảng nghỉ có đồng hồ tròn tương tác và năm thẻ thời tiết minh họa; âm thanh/chất lượng nằm trong mục thu gọn. Camera title nhìn cao hơn để mở hậu cảnh; công thức camera gameplay không đổi. Avatar ẩn trong title và trở lại khi vào chơi.
- Hậu cảnh ba tầng đồi/núi rộng hơn, có sắc đỉnh đá và haze riêng. Tắt global fog riêng trên ridge vì shader đã xử lý haze, tránh toàn bộ núi bị fog xóa mất. Sườn núi rộng và normals mềm hơn; đây vẫn là geometry thủ tục đơn giản.
- Thêm ba thỏ màu khác nhau, nhảy theo vòng nhỏ ban ngày; tám bướm đêm quanh hai góc rừng; chúng trú mưa lớn. Thêm 12 dương xỉ từ asset hiện có và sáu cụm lá rộng tự dựng ở các điểm chọn trước. Không rải thêm cây/cỏ toàn map.
- Mưa lớn giảm ánh sáng mặt trời trực tiếp còn khoảng 6% và tắt bóng nắng cứng; giảm trọng số vệt bánh xe trong puddle mask để bớt hai sọc ướt liên tục.
- Sửa assertion giao diện cũ: mưa lúc 9 giờ phải là Rainy Morning.

## Phần giữ nguyên

Kiến trúc/GLB café, toàn bộ `environment/vegetation` đã duyệt, GLB nhân vật, terrain/path geometry, vị trí cây chính, vùng chơi 48×48 m, điều khiển và tương tác hòm thư. Compatibility vẫn là renderer; không chuyển Forward+, không thêm GI. Validator khóa tài nguyên V10 đã pass.

## Nguồn asset

Postcard, đồng hồ, thỏ, bướm đêm và lá rộng là hình/geometry thủ tục viết trong dự án; không tải model hoặc texture mới. Dương xỉ tái sử dụng `assets/vegetation/forest_floor/fern_rosette.glb`, không sửa bytes nguồn. Các giấy phép tài nguyên cũ tiếp tục giữ nguyên.

## Kiểm tra

Godot 4.6.3 Linux, Compatibility. Import editor, smoke, map01_scope, weather_cycle, lighting_presets, v10_visual_overhaul và v11_atmosphere đều kết thúc failures=0; validator V10 và git diff --check pass. Smoke kiểm tra WASD, giảm tốc, va chạm café, E/hòm thư, khóa di chuyển khi hội thoại và camera zoom. Năm assertion V11 kiểm tra đồng hồ, bóng/nắng mưa lớn và visibility ngày/đêm/mưa của sinh vật.

Ảnh được chụp trực tiếp bằng Godot trên Xorg/Mesa llvmpipe 1280×720, không phải ảnh AI. Script: `tools/capture_v11_slice.gd`. Không đo FPS Windows/GPU thật; kết quả headless không phải duyệt mỹ thuật. Godot vẫn báo hai texture chưa giải phóng lúc thoát (cũng xuất hiện ở baseline); không coi đây là renderer sạch hoàn toàn.

## Giới hạn hình ảnh

Đây là bước chỉnh V11 để review, chưa tuyên bố đạt chất lượng premium. Núi vẫn đơn giản và cần đánh giá silhouette ở nhiều góc; mây cũ còn khá lớn/phẳng. Thỏ có hình khối tối giản, chuyển động thủ tục và chưa có rig/AI né người. Bướm đêm nhỏ, phải nhìn gần; chưa phải hệ sinh thái đa dạng đầy đủ. Postcard minh họa khác nhau theo loại thời tiết nhưng vẫn dùng chung bố cục. Cần xem chuyển động trong game và benchmark GPU thật trước khi chốt.

Preview: https://github.com/VietCodeBug/forest-post-cafe/tree/preview/ver-11-atmosphere-habitats
PR: https://github.com/VietCodeBug/forest-post-cafe/pull/10
