# V06 — cỏ mềm hơn, nhân vật có màu

Người dùng đã đánh giá căn nhà đẹp; V06 giữ nguyên GLB, geometry, material, collision và đèn của quán V05. Chỉ xử lý cỏ và màu nhân vật, không mở rộng Map 01 hay thêm gameplay.

## Nhân vật

Model gốc đúng là chỉ có một material xám. Tạo bản derivative riêng với chín vùng material: Skin, Hair, Jacket, Shirt, Trousers, Boots, Leather, Brass, Sole. Áo xanh rêu, kem ấm và quần xanh sẫm hợp palette quán; da/tóc và giày tách rõ. Không chỉ tint cả nhân vật một màu.

Nguồn: `art_source/postal_worker_v06/color_avatar.py` và `.blend`; runtime: `assets/characters/postal_worker/postal_worker_colored_v06.glb`. Giữ `base.glb` nguyên byte, ownership người dùng đã xác nhận. Không thay controller, kích thước 1,8 m hay pose tay nghỉ. Kiểm tra giữ 52 tên xương và số tam giác nguồn; trọng số normalized. Vẫn chưa có clip walk/idle.

## Cỏ

Bỏ hai mesh lá bản to `grass_large`/`grass_leafs` khỏi planting. Thay bằng ba cụm lá mảnh cong, tự tạo trong Blender: 35, 45, 30 tam giác/module. Palette xanh dịu và một lượng rơm nhỏ; cao 9–25 cm. Không texture ngoài.

Cụm nhỏ 3–4 tuft tạo thành các mảng không đều, mật độ giảm ở mép; ven đường có khoảng ngắt thay vì hàng lá rải đều. Giữ đường, lối lên hiên và khoảng đứng quanh quán thông thoáng. Hoa nhỏ hơn; bụi, đá và cây lớn giữ nguyên. MultiMesh chia sẻ mesh/material; tắt bóng của riêng cỏ để tránh những chấm đen nhiễu. Không thay terrain hoặc collider.

## Kiểm tra và review

Godot 4.6.3 Compatibility, Blender 4.3.2. Editor import, smoke controller/mailbox/UI, Map 01 terrain/bounds/porch, display integration rig/weights/kích thước/cây; validator GLB/material/rig/manifest và vendor integrity. Các kiểm tra tự động không phải số liệu hiệu năng Windows.

Ảnh trực tiếp Godot gồm gameplay, cận nhân vật có màu và cận cỏ. [Preview V06](https://github.com/VietCodeBug/forest-post-cafe/tree/preview/ver-06-grass-character-color) lưu riêng ảnh phiên này, ảnh before V05 và SHA code. Ver-01–05 giữ nguyên. Chưa merge PR; người dùng review phần cỏ và màu nhân vật từ ảnh thực tế.
