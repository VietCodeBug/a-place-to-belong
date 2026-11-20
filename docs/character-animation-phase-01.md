# Character & Emotional Animation Polish · Phase 01

## Audit trước khi sửa

Đối chiếu HEAD local và remote tại `bb74e3862b7714d18372f216407b914ccd25b42b`. Commit nền trên nhánh Phase 01 mang theo bản căn hộ đã duyệt từ workspace gốc. Các thay đổi Phase 01 bắt đầu sau commit nền.

| Rig | Skeleton và bind pose | Tay và mặt | Motion có sẵn và điểm cần chỉnh |
| --- | --- | --- | --- |
| Character A | 71 joint, gốc Rodin export transform có transform identity, thân và đầu chung skin nhưng tách mesh. Hông nghỉ 0,921 m, cẳng tay trái 0,209 m. | 30 xương ngón. Mắt, mí trên/dưới, mày, má, hàm và môi có weights. Không có blend shape. Đầu riêng hỗ trợ First-Person. | Không có clip. IK chân và bàn phím chạy trong code. Hướng giày trước đây đổi đồng thời với thân. Biểu cảm chọn trực tiếp và chớp mắt tuần hoàn. |
| NPC 01 | 55 joint, gốc ColleagueRig identity, một mesh skinned. Hông nghỉ 1,022 m, cẳng tay 0,194 m. Quaternion cổ tay khác A khoảng một phần tư vòng. | 30 xương ngón. Hàm, môi trên và môi dưới có weights. Mắt/mí/mày thiếu xương điều khiển, không blend shape. | Không có clip. Dùng IK điều chỉnh theo bind pose. Nhịp làm việc trước đây gắn với đồng hồ văn phòng và offset cố định. |
| NPC 02 | 57 joint, gốc mesh và Armature identity. Hông nghỉ 1,041 m, cẳng tay 0,214 m. | 30 xương ngón. Hàm, môi trung tâm và khóe miệng có weights. Mắt/mí/mày thiếu xương điều khiển, không blend shape. | Có clip `human_000089` 114 channel. Logic bàn làm việc dùng IK và pad hiệu chỉnh riêng cho mesh. |
| Boss | 57 joint, gốc mesh và Armature identity. Hông nghỉ 0,951 m, cẳng tay 0,226 m. | 30 xương ngón. Hàm, môi và khóe miệng có weights. Mắt/mí/mày thiếu xương điều khiển, không blend shape. | Có clip `human_000089` 114 channel. Patrol đồng bộ tốc độ với clip, dùng correction gối/đế giày và bước xoay riêng khi nghỉ. Giữ pipeline này. |

Tên chain thân theo dạng Hips, Spine2, LeftArm/LeftForeArm/LeftHand và các tên tương ứng bên phải. Mapping giữ phép tìm tên có và không có tiền tố. Audit GLB xác nhận cả bốn model có indices/weights skinned, mỗi xương mặt liệt kê có vertex trọng số trên 0,01. Một số tổng WEIGHTS_0 trước khi import nhỏ hơn 1, kiểm tra này không sửa dữ liệu gốc. Cốc trước đây dịch chuyển bằng nội suy từ vị trí bàn sang offset cổ tay, thiếu mốc nắm được khóa khi nhấc cốc. Căn hộ trước đây chỉ có capsule và camera.

## Phần triển khai

| Nguồn | Thay đổi |
| --- | --- |
| `scripts/story/opening_actor.gd`, `character_performance.gd` | Giữ planted feet và IK hai đoạn. Chỉ chân ở sau rời trụ, cập nhật dự đoán điểm đặt chân trong phần đầu của bước, khóa hướng giày đến khi nhấc chân và giới hạn gối trong pha vung. Thêm chuyển biểu cảm, biểu cảm ngắn theo sự kiện, gaze có giới hạn và API viseme bốn kênh. |
| `scripts/story/coworker_behavior.gd`, `real_office.gd` | Trạng thái gõ, đọc, suy nghĩ, nghỉ, dùng chuột và uống nước theo seed từng NPC. Cặp máy in đổi lượt cử chỉ với khoảng dừng khác nhau. Email dừng tay của A và giữ nhịp công việc của NPC. |
| `scripts/story/office_boss.gd`, `office_boss_actor.gd` | Tiếp tục dùng clip gốc và patrol hiện hữu. Chú ý mốc bàn, bước xoay khi dừng và liếc ngắn khi nhường lối. |
| `scripts/story/rented_apartment.gd`, `opening_view.gd` | Rig A ở góc nhìn thứ nhất. Chạm báo thức, thao tác laptop, nhìn đồng hồ im lặng và ngồi xuống giường. Marker gắn trực tiếp vào những vật thể hiện có. |
| `tests/character_animation_phase01_test.gd`, `tools/capture_character_phase01.gd` | Đo chân trụ, gối, chuyển biểu cảm, hướng nhìn, replay seed, quai cốc, báo thức và laptop. Sáu kịch bản quay Godot độc lập và một kịch bản đo thời gian. |

Locomotion điều khiển gốc và chân, tư thế điều khiển hông/vai, lớp tương tác giải xong bàn tay trước khi áp biểu cảm; attention điều khiển đầu và mắt. Marker tay dùng tham chiếu yếu. Vị trí đặt cốc lấy theo transform local của vật thể và được cập nhật theo parent.

## Kiểm thử và video

- `godot --headless --path . --editor --import --quit` và `git diff --check` thành công.
- `godot --headless --path . --script tests/office_first_person_test.gd`, `tests/character_animation_phase01_test.gd` và `tests/smoke_test.gd` đều báo 0 lỗi.
- Kịch bản 60 Hz ghi nhận gối tối đa 1,430 rad, khoảng cách chân tối thiểu 0,141 m, sai số anchor chân trụ dưới 1 mm. Pad ngón tay cách mốc đồng hồ 15 mm, hai pad laptop dưới 1 mm. Quai cốc ở pha giữ dưới 1 mm, frame dịch chuyển nhiều nhất 23 mm, cốc trở lại đúng transform đặt ban đầu.
- Godot 4.6.3 Compatibility render sáu MP4. Quay lại từng kịch bản qua `godot --path . --write-movie /tmp/review.avi --fixed-fps 20 --script tools/capture_character_phase01.gd -- locomotion`. Thay tham số cuối bằng `face`, `npc`, `interaction`, `apartment` hoặc `gameplay`. Video NPC bao phủ 96 giây mô phỏng. Một số góc theo Boss trong video bị nội thất che, bước đi và dừng thấy được ở giữa video.
- Dùng `--script tools/capture_character_phase01.gd -- profile` có display để lấy số liệu cục bộ. Một mẫu ở 704 × 396 Compatibility, Linux llvmpipe ghi 1,79 FPS và 558,04 ms/frame khi host chạy cả capture khác. Mẫu CPU tách riêng là 1,419 ms cho 19 lần cập nhật pose NPC, 0,020 ms cho mặt A kèm reset skeleton và 0,005 ms cho hai tay IK. Đây là số liệu cloud software renderer, chưa đo trên Windows.

## Trạng thái nghiệm thu

| Mã | Kết quả | Bằng chứng hoặc giới hạn |
| --- | --- | --- |
| ANIM-01, ANIM-02, ANIM-03 | PASS trong kịch bản thử | A quay, đi, chạy nhẹ và ngồi/đứng trong video A. Boss dùng clip và correction gối/đế cũ; test chân trụ và hướng giày chạy qua dừng và xoay. |
| FACE-01 | PASS trong kịch bản thử | Xác minh weights trên GLB, đổi pose hàm trong test, mắt/mày/miệng đổi pose trong video B. |
| FACE-02, FACE-03 | PARTIAL | Có đủ tám preset cho A, nhưng nét miệng rất nhẹ do miệng được vẽ trong texture. Ba NPC thiếu xương mắt/mí nên gaze thể hiện bằng hướng đầu. Viseme demo không có thoại đã thu. |
| NPC-01, NPC-02 | PASS trong kịch bản thử | Replay seed 96 giây, khác nhịp giữa profile; video C cho thấy bàn làm việc, khu máy in, bàn họp và Boss. |
| APT-01, APT-02 | PASS trong kịch bản thử | Video E và F dùng First-Person ở cả ba giai đoạn. Thay đổi chỉ thêm mốc tương tác, rig và camera diễn xuất; không đổi kích thước phòng, asset hoặc tọa độ đồ đạc so với commit nền. |
| IK-01 | PARTIAL | Đo được bàn phím, chuột, quai cốc, đồng hồ và laptop. Điện thoại dùng giao diện bên trái đã được duyệt, không có đạo cụ cầm tay. |
| IK-02 | PASS trong kịch bản thử | Cốc giữ mốc quai trong khi nâng và trở lại đúng vị trí trên bàn. |
| STORY-01, CAM-01, REG-01 | PASS trong kịch bản thử | Test hồi quy và video F đi từ Office tới PRO-003, dừng ở tư thế ngồi cuối ngày thứ ba. |
| TEST-01, TEST-02 | PASS | Test tự động và sáu clip render thực tế. |
