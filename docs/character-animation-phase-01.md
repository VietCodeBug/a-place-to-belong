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
