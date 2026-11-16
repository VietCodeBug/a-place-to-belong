# Map 01 — V04 visual review (chưa được duyệt mỹ thuật)

## Phạm vi cuối cùng

Áp dụng yêu cầu **Map 01 Visual Quality Overhaul**, thay cho phần mở rộng trong
brief V04 trước đó. Giữ clearing và quán tại vị trí cũ, tuyến đường chữ S, mailbox
x=3.6/z=3.5, controls và gameplay. Không tạo Map 02, suối/cầu/outlook, vùng chơi hay
hệ thống mới. Phần thử nghiệm mở rộng đã được loại khỏi bản giao.

Phạm vi có collision vẫn **48 × 48 m, x/z = -24..24**. Mesh nền phía ngoài chỉ là
scenery, thay background plane cũ; không có floor collider/interaction hoặc đường
chơi ngoài phạm vi này. Mười một kiểm tra scope/collision xác nhận điều đó.

## Kiến trúc mới trong clearing hiện có

Quán được tổ chức lại, không nhân scale toàn bộ nhà cũ:

- Hall café 9 × 11 m và cánh bưu điện 6 × 8 m tạo tổng frontage khoảng 15 m,
  chiều sâu lớn nhất 11 m. Hai khối có chiều cao mái khác nhau.
- Đỉnh mái chính **7 m trên datum quán**, mái cánh bưu điện 5.75 m. Có dormer,
  mái vào cửa và overhang, truss, fascia, giằng dưới cột, rafter tails và course gỗ.
- Cửa nhập từ pack vẫn **1.20 × 2.25 m**; nhân vật khoảng 1.8 m làm mốc trong ảnh.
- Hiên 15.6 × 4 m, ramp giữa, khu café trái và nhận hàng phải. Mailbox nâng theo
  sàn hiên, giữ nguyên vị trí ngang và hành vi tương tác.
- Cửa sổ là aperture 4.2 × 2.1 m, có khoảng phòng sâu khoảng 1.3 m, bàn/kệ/kiện hàng
  và ánh sáng ấm phía sau. Đây là chiều sâu nhìn thấy, không phải interior gameplay.
- Giữ mái xanh rêu, timber, mảng cream, cửa mustard và xe đạp coral. Nền/phần
  joinery bổ sung là geometry dự án; không tuyên bố toàn bộ nhà là model premium.

## Rừng, đất và ánh sáng

- Thay tán thông và birch Kenney không phù hợp bằng 5 pine + 2 autumn birch của
  **Quaternius Ultimate Nature Pack**; thêm bush/moss rock cùng pack. Cây hero trong
  Map 01 khoảng 14–18 m; hậu cảnh có biến thể 13–19 m. Không lấy cao độ đồi làm
  chiều cao cây trong test.
- Nhóm cây theo hai cánh quán, chừa hành lang camera phía đông nam. Giữ số lượng
  cụm có chủ đích; không thêm một vành cây đồng đều hay tăng map để lấp trống.
- Terrain là bề mặt triangulated liên tục. Clearing dưới quán phẳng để nền/sàn
  bám đất; ngoài clearing chỉ có gợn cao độ nhỏ. Không có sphere hill rời.
- Road và cây/props lấy cùng nội suy tam giác với collider; sửa sọc do giao mặt đất.
  Mép đường có cỏ thưa và đoạn cuối hòa vào grass, giữ tuyến chữ S hiện có.
- Nắng chiều góc 27°, màu ấm; ambient lạnh hơn, sky/haze dịu, interior/porch lights
  và lantern emissive vừa phải. Không bloom hoặc fog nặng.

## Camera

Gameplay dùng FOV 42° gần quán, 46° ngoài vùng quán, chuyển mượt; distance 24 m,
  cộng 2 m khi gần kiến trúc. Zoom 10–40 m; hướng offset (0.62, 0.54, 0.57).
  Aim gần quán offset (-2, 2.3, -5), vị trí camera vẫn theo nhân vật; interpolation
  position 4.5/s, aim 5/s, FOV 3/s. Giữ WASD, wheel và độ bám trên nền thay đổi.

Cinematic presets riêng trong `review_cameras.gd`: lodge, detail, forest và wide.
Chỉ script capture áp preset; ảnh 01 luôn chụp camera gameplay thực, có UI.

## Asset, nguồn và license

- **Kenney Nature / Fantasy Town / Furniture, CC0-1.0:** giữ phần kiến trúc modular,
  props và một ít ground cover phù hợp. Original bytes/roster không thay đổi.
- **Quaternius Ultimate Nature, CC0-1.0:** 9 GLB chọn lọc, lấy từ mirror conversion
  `trebeljahr/quaternius-showcase`, pin commit và Git tree. Trang tác giả xác nhận
  CC0; giữ snapshot, legal code và bảng license của mirror. MIT của showcase code
  không được dùng làm license model; không đưa code của showcase vào dự án.
- Source GLBs giữ nguyên; material matte, pivot/metre normalization và instancing
  được áp lúc chạy. Tổng 58 GLB và 1 atlas trong hai roster, có module dự phòng.
- Xem README/manifest trong từng `assets/vendor/` và chạy verifier để đối chiếu.
  Tiếp tục workflow thủ công đã được người dùng cho phép khi `game-dev` không có.

## Kết quả kỹ thuật

- Source SHA-256, cấu trúc GLB, finite positions và texture references: đạt.
- Godot 4.6.3 editor import và startup 120 frame: đạt.
- **13/13** regression gameplay: đạt. Các fixture vị trí bám scene mới; giữ nguyên
  assertion hành vi movement/collision/E/Esc/modal/camera/zoom. Bài va chạm cũ dùng
  sai tổ hợp phím; đã sửa thành W+D đi thẳng vào tường và yêu cầu có tiến tới, rồi
  thực sự dừng tại mặt tường. Không giữ một phép kiểm có thể pass khi đi lệch hướng.
- **7/7** integration/scale/import trên OpenGL: đạt, gồm 58 GLB, cửa/mái/hiên/mốc
  nhân vật và tree height từ MultiMesh.
- **11/11** scope/conformance: đạt; cùng cao độ mesh/collider, không có playable floor
  ngoài bounds, giữ mailbox, không có creek crossing và tự đi từ đường lên hiên.
- Mesa llvmpipe/Xorg dummy báo V-Sync unsupported. Chưa đo FPS PC hoặc chạy native
  Windows. Các kiểm tra này không phải bằng chứng đạt mỹ thuật.

## Visual review và điểm chưa đạt

Đã xem đủ 5 PNG renderer thật và đối chiếu trước–sau. Bản V03 không được coi là
đã duyệt. V04 cải thiện silhouette, tỷ lệ cửa/hiên, chiều sâu window và tán cây;
nhưng **chưa đạt benchmark Premium Handcrafted Cinematic Diorama**:

1. Mái và side wall vẫn còn mảng phẳng lớn; gỗ/roof cần bề mặt và joinery tinh tế
   hơn, thay vì chỉ dựa màu và beam.
2. Một số đồ đạc và nhân vật/xe đạp/mailbox vẫn có chất placeholder đơn giản.
3. Khoảng meadow tiền cảnh còn khá trống; contact shading và ánh sáng gián tiếp
   chưa đạt chất lượng cinematic. Chưa có baked AO/GI được kiểm chứng.
4. Signage và vật liệu kính chưa tinh; background cần art review thêm ở các góc đi
   quanh quán. Không có ảnh benchmark thực được đính kèm để đối chiếu trực tiếp.

Không tuyên bố visual approval nhờ test pass. Cần người dùng duyệt Map 01 trước
bất kỳ Map 02, vùng mới hoặc hệ thống gameplay bổ sung nào.

## Preview V04 và trước–sau

[preview/ver-04-map01-art-pass](https://github.com/VietCodeBug/forest-post-cafe/tree/preview/ver-04-map01-art-pass)
chứa 5 ảnh mới trong `after/`, 3 ảnh trước của V03 trong `before/`, cùng README ghi
source commit và bảng so sánh. Các preview ver-01/02/03 giữ nguyên. Camera đã thay
đổi nên bảng này là so sánh art direction/framing, không phải pixel-diff cùng camera.

| View | Trước V03 | Sau V04 |
| --- | --- | --- |
| Gameplay thật | ![Before](https://raw.githubusercontent.com/VietCodeBug/forest-post-cafe/refs/heads/preview/ver-04-map01-art-pass/before/01-playable-view.png) | ![After](https://raw.githubusercontent.com/VietCodeBug/forest-post-cafe/refs/heads/preview/ver-04-map01-art-pass/after/01-map01-gameplay.png) |
| Quán và mốc người | ![Before](https://raw.githubusercontent.com/VietCodeBug/forest-post-cafe/refs/heads/preview/ver-04-map01-art-pass/before/03-cafe-porch.png) | ![After](https://raw.githubusercontent.com/VietCodeBug/forest-post-cafe/refs/heads/preview/ver-04-map01-art-pass/after/02-cafe-player-scale.png) |
| Wide | ![Before](https://raw.githubusercontent.com/VietCodeBug/forest-post-cafe/refs/heads/preview/ver-04-map01-art-pass/before/02-woodland-clearing.png) | ![After](https://raw.githubusercontent.com/VietCodeBug/forest-post-cafe/refs/heads/preview/ver-04-map01-art-pass/after/05-map01-wide.png) |

## Reproduce

```sh
python tools/verify_vendor_assets.py
godot --headless --editor --path . --quit
godot --headless --path . --quit-after 120
godot --headless --path . --script tests/smoke_test.gd
godot --headless --path . --script tests/map01_scope_test.gd
# With an actual OpenGL display:
godot --path . --audio-driver Dummy --script tests/imported_assets_test.gd
godot --path . --audio-driver Dummy --script tools/capture.gd -- --output=/tmp/map01-review
```
