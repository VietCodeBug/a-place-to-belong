# Nhân vật người dùng cung cấp

`base.glb` được giữ nguyên byte từ tệp người dùng tải lên. Ngày 2026-11-16, người dùng xác nhận: “Model do tôi sở hữu/tự làm”. Nguồn được ghi nhận là người dùng tự sở hữu, không gán CC0 và không có giấy phép bên thứ ba được suy đoán.

52 xương, 1 skin, 0 animation clip. Runtime đặt cao 1,8 m, xoay đúng hướng di chuyển, tạo pose tay nghỉ tĩnh và dùng material matte cho review. Controller/va chạm không thay đổi. Chưa có walk/idle animation cho rig này.

201/12.824 đỉnh có tổng trọng số lệch khỏi 1 quá 0,02 (thấp nhất khoảng 0,881). Runtime chuẩn hóa trên bản mesh riêng, giữ cấu trúc 4/8 ảnh hưởng của Godot; file nguồn không bị sửa. Integration test kiểm tra 52 xương và tổng trọng số sau chuẩn hóa.

## V06 — bản có màu

Game hiện load `postal_worker_colored_v06.glb`. Chín material riêng: da ấm, tóc nâu, áo xanh rêu, áo trong kem, quần xanh sẫm, giày/đồ da nâu, đế tối và chi tiết đồng. Đây là phân vùng material theo mặt của geometry gốc, không phải texture AI hay đổi màu đồng loạt cả mesh. Nguồn Blender và script nằm trong `art_source/postal_worker_v06`.

Blender xuất lại tối đa bốn trọng số/đỉnh và chuẩn hóa; validator kiểm tra tổng trọng số, 52 tên xương và số tam giác không đổi. Không có animation mới. GLB gốc vẫn nguyên SHA trước đó.
