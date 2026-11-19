# V05 — review kiến trúc quán chính

Bản này thay riêng quán V04 bằng asset Blender có nguồn chỉnh sửa. Map 01 vẫn 48 × 48 m, không đổi terrain, S path, vị trí hòm thư, camera gameplay hoặc hệ thống tương tác. Chưa mở rộng map hay thêm gameplay. Chất lượng hình ảnh đang chờ người dùng duyệt, không tuyên bố đã đạt mức premium.

## Thay đổi nhìn thấy

- Mái xanh rêu có lớp ngói riêng, hàng nóc, viền mái, phần chồng lớp ở các khối nhà, khung tam giác và giằng gỗ.
- Vách có từng hàng ván, cột/dầm bevel, đế kim loại, chốt; hiên có từng tấm ván, lan can và lối lên thông thoáng.
- Cửa vòm, khung cửa, tay nắm, biển chữ nổi, cửa sổ lõm, quầy cà phê/cốc/kệ và ngăn bưu phẩm phía trong.
- Bàn ghế, đèn hiên, thùng hàng nằm trong bố cục kiến trúc. Xe đạp đỏ và hòm thư gameplay cũ vẫn giữ.
- Model nhân vật do người dùng cung cấp được dùng làm mốc 1,8 m. Giữ 52 xương; chưa có animation clip, pose tay tĩnh không phải walk animation.

## Nguồn và quy trình

`art_source/hero_cafe_v05/hero_cafe_v05.blend` giữ đối tượng rời để sửa tay; `build_hero.py` tái tạo nguồn và xuất GLB. `spec.json`, `build_report.json`, manifest SHA-256 cung cấp kiểm tra có thể lặp lại. Godot `scripts/world/cafe_kit.gd` load GLB thay vì dựng hình quán bằng primitive runtime. Collision đơn giản tách khỏi geometry; thêm collider cột, bàn ghế và lan can.

Output: 160.760 tam giác, 20 mesh, 31 material PBR, không texture ngoài. Ngân sách đặt 180.000 tam giác/48 material. Đây là một hero asset nhiều chi tiết; chưa có đo hiệu năng trên Windows hay LOD. PBR là các thông số material, chưa có bộ normal/roughness texture bake. Bộ cây và vendor CC0 cũ giữ nguyên, manifest cũ được xác minh lại.

Nhân vật: giữ nguyên SHA nguồn, ownership do người dùng xác nhận. Phát hiện 201 đỉnh có trọng số chưa chuẩn; chuẩn hóa ở runtime trên mesh copy và kiểm tra sau import, không ghi đè GLB gốc. Xem README và manifest trong `assets/characters/postal_worker`.

## Renderer và kiểm thử

Godot 4.6.3, Blender 4.3.2, OpenGL Compatibility trên Mesa llvmpipe. Thử Forward+ thực tế thất bại vì `VK_KHR_xlib_surface` không có; Godot tự fallback OpenGL. Vì vậy không chuyển cấu hình dự án, không tuyên bố SSAO/GI hay Forward+ đã hoạt động. Đèn hiên/window dùng ánh sáng ấm cục bộ; không thay toàn bộ lighting/forest trong lượt review kiến trúc.

Kiểm tra: import editor, boot headless, smoke controller/UI/mailbox/collision, Map 01 bounds/terrain/porch approach, integration dưới display (kích thước cửa/mái/hiên, rig, cây), verifier vendor và asset tự tạo. Không tương đương kiểm thử bản Windows hay duyệt mỹ thuật của người dùng.

## Ảnh review

Ảnh chụp trực tiếp Godot, không dùng ảnh minh họa AI: gameplay, cận gỗ/hiên, nhân vật cạnh cửa, ngoại thất ánh sáng ấm, kết cấu mái. Nhánh [preview/ver-05-hero-building](https://github.com/VietCodeBug/a-place-to-belong/tree/preview/ver-05-hero-building) giữ riêng 5 ảnh after và ảnh before V04, bảng so sánh và SHA code. Camera review riêng không thay camera gameplay.

Ảnh reference ban đêm không có byte ảnh trong workspace lượt này; thiết kế dựa mô tả chữ. Chưa khẳng định khớp reference ảnh. Rừng, nền đất và một số prop cũ vẫn cần vòng review sau khi quán được duyệt. Material mái/gỗ có thể đổi palette sau này; chưa triển khai hệ thống mùa mới.
