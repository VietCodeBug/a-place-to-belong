# Vertical slice — kitbash bằng asset ngoài

## Nguồn và giấy phép

Chuyển phần nhìn chính sang **Kenney Nature Kit, Fantasy Town Kit và Furniture
Kit**, cùng phong cách low-poly. Không dùng thêm Quaternius/Poly Pizza trong scene
cuối để tránh pha style không cần thiết. Cả ba trang pack chính thức xác nhận
**CC0-1.0**; không bắt buộc attribution, vẫn giữ tên tác giả/nguồn tự nguyện.

Nguồn bytes: mirror `shorepine/kenney` trên GitHub, pin theo commit trong
`assets/vendor/kenney/manifest.json`. Đây không phải download trực tiếp archive
của Kenney. Lưu bản chụp text của trang license chính thức, legal text CC0, hash,
nguồn và hướng dẫn xác minh trong thư mục vendor. Không dùng file LICENSE ở root
mirror làm bằng chứng riêng vì file đó ghi Castle Kit.

Đã kiểm tra 50 file nguồn, gồm **49 GLB + 1 atlas**, tổng 6.175 triangle của toàn
bộ model nguồn (không phải triangle của scene khi nhân bản). GLB header/chunk,
finite vertex positions, đường dẫn texture và SHA-256 đều đạt. Các blob ban đầu
cũng đối chiếu Git tree của commit pin. Bundle dưới 1 MB, có vài module dự phòng.

Máy không có `game-dev`; người dùng đã cho phép dùng workflow thủ công thay thế.
Manifest này không phải canonical package/receipt của CLI đó.

## Những gì đã thay

| Nhóm | Model/pack sử dụng |
| --- | --- |
| Cây thông | Nature: pineTallA/B/C/D_detailed, pineRoundC; 3 dải kích thước |
| Điểm mùa thu | Nature: tree_oak_fall, dùng tiết chế cạnh khoảng trống |
| Bụi/cỏ/hoa | Nature: plant_bushDetailed/Large, grass_large/leafs, flower_yellowA/redC |
| Đá/củi/gốc cây | Nature: rock_largeA/B, log_stack, stump_roundDetailed |
| Hàng rào/biển | Nature: fence_planksDouble, sign |
| Nhà/quán | Fantasy Town: wall-wood, window-glass, door, roof-gable, roof, pillar-wood, fence, chimney, lantern |
| Nội thất ngoài trời | Furniture: tableRound, chair, bench, pottedPlant |
| Khu nhận hàng | Furniture: cardboardBoxClosed, bookcaseOpenLow |

File GLB gốc giữ nguyên. `FieldAssets` chuẩn hóa pivot/kích thước khi instantiate;
material override bỏ metallic vô lý trong bản nguồn, giữ roughness matte và palette
ấm. Shader mái phân biệt mặt dốc xanh rêu với mặt hồi gỗ qua normal. Vegetation
được chia surface/material và batch bằng MultiMesh, không dựng lại cây bằng cone.

`cafe_kit.gd` ráp quán bằng module ngoài. `woodland.gd` thay hệ cây/cỏ/đá procedural
cũ bằng imported mesh. `forest_hub.gd` ghép scene, ánh sáng, terrain và prop clusters.

## Tỷ lệ đã đo bằng engine

- Cửa GLB: **1,20 m rộng × 2,25 m cao**.
- Đỉnh mái GLB: **5,25 m**; ống khói cao hơn một chút.
- Hiên: **9 × 3 m**, lối vào giữa rộng 2,4 m.
- Nhân vật hiện tại xấp xỉ **1,8 m**; giữ nguyên controller.
- Cây hero tới khoảng **15,27 m**, gần 3 lần đỉnh mái; cây nhỏ khoảng 7 m,
  cây vừa khoảng 10,5 m. Có tán/trunk model khác nhau, không chỉ scale một cone.

Quán đóng ngoại thất trong phase này. Collider đơn giản tách khỏi model; không
cho nhân vật đi xuyên nhà. Hiên có ramp đi được. Bàn ghế, hàng rào và thân cây có
collider phù hợp; cỏ/hoa là decoration. Mailbox vẫn ở vị trí cũ để giữ flow.

## Phần còn placeholder / giới hạn

- **Nhân vật, xe đạp và vỏ mailbox** vẫn là placeholder tự dựng của prototype;
  không tuyên bố đã thay bằng production models. Tương tác mailbox được giữ nguyên.
- Terrain, ribbon path, nền/sàn hiên, kính cửa sổ, biển tên và collider là geometry
  đơn giản do dự án tạo. Cấu trúc/khung nhà và phần lớn cảnh quan dùng asset ngoài.
- Chưa có nội thất café chơi được, animation nhân vật production, riding hay season
  system. Palette/layout vẫn mở rộng được cho mùa sau.
- Chưa kiểm thử native Windows hoặc đo FPS trên PC. Asset footprint nhỏ và instancing
  không thay thế benchmark. Đây là bản kitbash để review, chưa phải art final.

## Kiểm chứng

```sh
python tools/verify_vendor_assets.py
godot --headless --editor --path . --quit
godot --headless --path . --quit-after 120
godot --headless --path . --script tests/smoke_test.gd
```

Với display có OpenGL:

```sh
godot --path . --audio-driver Dummy --script tests/imported_assets_test.gd
godot --path . --audio-driver Dummy --script tools/capture.gd -- --output=/tmp/asset-captures
```

- 13 kiểm tra gameplay: đạt.
- 7 kiểm tra integration/scale/import trên renderer thật: đạt, gồm 49 GLB,
  cửa, mái, hiên, mốc nhân vật và chiều cao cây qua MultiMesh readback.
- Test integration yêu cầu display; null renderer của headless không trả transform
  MultiMesh GPU đúng để đo cây. Không bỏ assertion chiều cao; đã chạy bằng OpenGL.
- Renderer kiểm thử: Godot 4.6.3, Compatibility, Mesa llvmpipe/Xorg dummy. V-Sync
  unsupported là cảnh báo của display này. Không có lỗi parse/missing resource.

## Ảnh trong engine

![Góc chơi thật](https://raw.githubusercontent.com/VietCodeBug/forest-post-cafe/refs/heads/preview/ver-03-kenney-kitbash/01-playable-view.png)

![Toàn cảnh kitbash](https://raw.githubusercontent.com/VietCodeBug/forest-post-cafe/refs/heads/preview/ver-03-kenney-kitbash/02-woodland-clearing.png)

![Tỷ lệ quán và props](https://raw.githubusercontent.com/VietCodeBug/forest-post-cafe/refs/heads/preview/ver-03-kenney-kitbash/03-cafe-porch.png)

Bộ preview riêng: [preview/ver-03-kenney-kitbash](https://github.com/VietCodeBug/a-place-to-belong/tree/preview/ver-03-kenney-kitbash).
