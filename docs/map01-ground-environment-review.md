# Map 01 — V05 ground/environment review

Lượt này chỉ thay diện mạo nền đất, cỏ, đường và tầng thực vật/ánh sáng môi trường. **Không sửa `cafe_kit.gd` hoặc GLB của quán.** Quán, controller Samatha, camera, collider, UI, hòm thư, vị trí NPC và đường S được giữ từ baseline `e5900df3f9a5df304df845521c3903e94b779649`. Không thêm map, tăng bounds hoặc gameplay.

## Đã thay gì

- Nền đất thay material phẳng bằng shader world-space: các vùng xanh ở nhiều cỡ, rêu, đất nâu/soil exposure, thảm lá dưới tán và vùng chuyển tiếp ven đường. Không dùng texture photoreal, texture tile lặp hay ảnh AI. Các vùng trồng và màu nền dùng chung bố cục rừng/clearing.
- Thảm cỏ ngắn liên tục, cỏ quạt và cụm cỏ trung bình ở các bãi; cỏ cao quanh cụm bụi/đá; dương xỉ ở gốc cây. Mật độ giảm ở mép, có vùng đi bộ trống. Cao/rotation/tint thay đổi; gió rất nhẹ chỉ ở đầu lá. MultiMesh chia 8 m để cull theo vùng.
- Cụm bụi/đá không còn cặp giống nhau đặt đều; giữ cây Quaternius và toàn bộ vị trí/collider cây. Thêm hoa Kenney vàng/tím thưa, lá rơi nâu vàng và cành nhỏ tụ thành túi tự nhiên. Không tăng số cây để lấp cảnh.
- Đường giữ nguyên hàm centerline và core width. Mesh visual có thêm dải chuyển tiếp, chia nhỏ ngang để áp sát cùng height function; cách mặt đất 2,5 cm thay vì 7,5 cm. Mép alpha irregular, đất đổi sắc nhẹ, đá nhỏ chôn thấp và lá ở biên; không thêm collider đường hay vật cản.
- Nắng ấm nhẹ, ambient dịu hơn, haze xa bắt đầu 38 m. Giữ nguyên đèn hiên/quán. Điều chỉnh shadow bias và tắt terrain tự đổ bóng để bỏ vệt shadow acne; terrain vẫn nhận bóng cây/nhà, toàn bộ caster của quán/cây được giữ. Rễ có vùng màu tiếp xúc; đồng thời SSAO nhẹ đã được thử A/B và bật trong Compatibility 4.6, radius 0,55 / intensity 0,65 / power 1,1. Không dùng AO để đổi material quán.

## Asset và nguồn

| Nhóm | Nguồn |
| --- | --- |
| 4 silhouette cỏ, dương xỉ 5 frond, lá, cành | Geometry Blender tự tạo: `art_source/forest_floor`; 7 GLB, tổng 420 tam giác nguồn, mỗi module 3–220 tam giác, không texture ngoài |
| Cây và bụi/đá rêu | Quaternius CC0 đã được admit trước: PineTree, BirchTree_Autumn, Bush_1, Rock_Moss_1; byte nguồn không đổi |
| Hoa, đá nhỏ, gỗ | Kenney CC0 đã có: flower_yellowA, flower_purpleB, rock_smallC, log_stack, stump_roundDetailed |
| Nền/cỏ/đường | Shader tự viết trong `shaders/forest_floor*`, `forest_grass`, `forest_path`; không đổi material quán |

`assets/vegetation/forest_floor/manifest.json` ghi hash nguồn Blender, script, report và GLB. Bố cục CPU trong `forest_floor_design.gd`, instancing trong `ground_cover.gd`. CLI game-dev không có; dùng quy trình Blender thủ công đã được người dùng cho phép trước đó. Không tải thêm pack hay dùng dịch vụ trả tiền.

Population khoảng 11 nghìn instance mới, giới hạn kiểm tra 25 nghìn. Cỏ ngắn không đổ bóng riêng; gió chạy trong shader, không cập nhật từng instance trên CPU mỗi frame. Đây là số liệu cấu trúc scene, **không phải benchmark FPS trên Windows**.

## Bảo toàn phạm vi

`tools/validate_ground_environment.py` so byte/hash với baseline: loader/GLB quán, player/controller/camera, scene hòm thư, path layout và project renderer. So nguyên các hàm height/interpolation, bounds, centerline và tree placement/collider. Hub chỉ thêm node visual floor và chỉnh hàm lighting. Quán GLB SHA-256 vẫn `13d03ae08343f6052258b008f187602c47b9b2c7f115878e930fe9b2560f5ec3`.

Các module floor không thêm PhysicsBody. Playable bounds vẫn -24..24 cả X/Z. Shader của terrain không displacement. Model, UV, màu và animation Samatha không bị sửa.

## Renderer, AO và indirect lighting

Giữ Godot 4.6.3 Compatibility. Đã chạy riêng `--rendering-method forward_plus`; Vulkan thất bại với `Required extension VK_KHR_surface not found`, sau đó engine tự fallback OpenGL 4.5 Mesa llvmpipe. Log fallback không phải kiểm thử Forward+ thành công.

| Lựa chọn | Đánh giá lượt này |
| --- | --- |
| SSAO trong Compatibility 4.6 | Có hỗ trợ; A/B cùng camera, khóa player và gió, đã thấy tác dụng tiếp xúc nhẹ và giữ bật ở mức vừa |
| Ambient/sky, đèn local và shadow hiện tại | Dùng trong Compatibility, được nhìn trực tiếp trong các capture |
| SSIL | Không có trong Compatibility; không bật rồi nhận là hoạt động |
| LightmapGI | Compatibility render được lightmap đã bake; bake mặc định cần Forward+/Mobile và geometry/UV2 tĩnh, chưa bake trong lượt này |
| SDFGI / VoxelGI / AO ở Forward+ | Chưa thể đánh giá trực quan hoặc đo FPS do Vulkan không khởi tạo được trên host này |

Không chuyển renderer mặc định. Forward+ có thể tăng chi phí GPU/VRAM khi dùng AO/GI và cần kiểm tra card/driver Windows thực; chưa có dữ liệu ở đây để khẳng định lợi ích hoặc phần trăm hiệu năng. Không dùng bloom hay fog dày để che thiếu chi tiết.

## Kiểm thử và ảnh

Kết quả: editor import và boot qua; 13 smoke gameplay/UI/mailbox/collision, 11 Map 01 terrain/bounds/porch, 18 integration có display và 12 floor scope đều qua (0 lỗi). Kiểm tra source/vendor/hash không thay thế duyệt mỹ thuật.

[preview/ver-05-ground-environment](https://github.com/VietCodeBug/a-place-to-belong/tree/preview/ver-05-ground-environment) chứa 5 ảnh Godot thật: gameplay mặc định, nền/cỏ cận, mép đường, nền rừng dưới tán và toàn cảnh Map 01. Ảnh codebase V04 `aa5f718` và baseline hiện tại `e5900df` được render lại bằng cùng năm camera để đối chiếu.

**V04 trong Git có quán phiên bản cũ hơn baseline hiện tại.** Vì vậy có cả cột “trước lượt này” cùng quán hiện tại để kiểm tra việc quán không bị sửa; không dùng chênh lệch kiến trúc V04→V07 làm thành tích của lượt ground pass. Bộ before được tạo từ `git archive` vào thư mục tạm, không sửa hoặc checkout đè repo đang làm việc.

## Điểm còn yếu / chờ review

Cỏ xa vẫn giản lược và có thể alias ở góc thấp; dương xỉ dùng module lặp; mép đường còn khá mềm ở góc cận. Một số bụi/đá dùng cùng silhouette nguồn. Chưa có indirect GI bake hoặc đo hiệu năng GPU Windows. SSAO mức nhẹ đã bật, không thay thế GI. Hình ảnh đã có tầng nền và undergrowth rõ hơn, nhưng chưa tuyên bố đạt premium; người dùng duyệt dựa trên bộ ảnh thật. Không auto-merge hoặc mở rộng scope.

### Bằng chứng AO / GI bổ sung

Godot 4.6 đã hỗ trợ SSAO ở Compatibility: [bảng renderer 4.6](https://docs.godotengine.org/en/4.6/tutorials/rendering/renderers.html). Đã thử cùng camera, cùng trạng thái actor, tắt gió để so A/B bằng `tools/evaluate_ground_ssao.gd`; ảnh off/on và log được lưu trong preview. Tác dụng nhỏ ở tiếp xúc cỏ/đá/đồ vật, không làm cả nền tối mạnh. Chênh ảnh không được coi là thước đo premium.

LightmapGI có thể render lightmap bake trong Compatibility, nhưng bake mặc định cần thiết bị hỗ trợ Forward+/Mobile; scene hiện sinh mesh runtime và chưa có bộ UV2/lightmap tĩnh. Vì vậy chưa đưa GI bake vào lượt này. SSIL/VoxelGI/SDFGI không có ở Compatibility. [LightmapGI 4.6.3 source docs](https://github.com/godotengine/godot/blob/4.6.3-stable/doc/classes/LightmapGI.xml) nêu cả giới hạn bake/editor và procedural scenes. Ambient/sky và đèn quán hiện tại không được gọi là indirect GI đã bake.
