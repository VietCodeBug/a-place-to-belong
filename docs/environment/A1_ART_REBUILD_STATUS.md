# A1 · Trạng thái dựng lại mỹ thuật

**House Art Gate — gửi duyệt.** Quyết định duyệt mỹ thuật thuộc người sáng tạo.

| Hạng mục | Nguồn và import | Trạng thái |
| --- | --- | --- |
| Hewn Eaves | [Blender](../../art_source/a1_house_gate/hewn_eaves_cottage.blend), [script dựng](../../art_source/a1_house_gate/build_house.py), [GLB](../../assets/a1_house_gate/hewn_eaves_cottage.glb) | Mái xếp ngói theo hàng, mái phụ và hiên riêng; cửa vòm, khung gỗ, đá móng, vườn và bậc. Vật liệu glTF PBR tự chứa. |
| Art gate | [Cảnh Godot](../../scenes/environment/a1_house_gate.tscn), [logic preview](../../scripts/environment/a1_house_gate.gd), [tool capture](../../tools/capture_a1_house_gate.gd) | Cảnh độc lập trong Godot Compatibility, first-person. Click giữ chuột, WASD đi, Esc nhả chuột. Collision giản lược cho vỏ nhà, hiên và sân. |
| Ảnh | [Gallery](review-a1-house-gate/README.md) | Front, side, three-quarter và gameplay eye-level, render 1280 × 720. |
| Bản V2 từng bị trả lại | [Snapshot source môi trường](review-a1-v2/source-environment.patch) | Đối chiếu commit ảnh 17ee41f. Patch ghi lại các file môi trường A1 của cây làm việc. Phiên chơi V2 đầy đủ phụ thuộc thêm các thay đổi cục bộ từ lượt trước, gồm Thomas. |
| Phần thử nghiệm | Cây nền và tầng thấp lấy GLB Kenney/Quaternius đã có trong repo. | Sân review giữ vai trò trung tính. Chưa duyệt Vegetation, Village Street, Landscape hay Seasons. Chưa có biến thể nhà thứ hai, nội thất, LOD sản xuất hoặc mesh tuyết của căn mẫu. |

## Kiểm tra và tái tạo

- Từ repo root chạy **blender -b --python-exit-code 1 --python art_source/a1_house_gate/build_house.py**.
- Import bằng **godot --headless --editor --path . --quit**. Mở cảnh A1 House Gate để đi bộ.
- Render bằng **godot --path . --script tools/capture_a1_house_gate.gd** trên máy có display.
- Đã kiểm tra build/export GLB, khởi chạy scene và render thật trong Godot 4.6.3 Compatibility trên Mesa llvmpipe.
- Phạm vi GitHub gồm source Blender, GLB, scene/capture Godot, ảnh và tài liệu audit. Cảnh review nằm riêng chờ quyết định duyệt trước khi thay nhà ở tuyến chơi chính.
