# A Place to Belong · Office V2

Tư liệu cho [PR #10](https://github.com/VietCodeBug/a-place-to-belong/pull/10), [mã nguồn đang duyệt](https://github.com/VietCodeBug/a-place-to-belong/tree/bb74e3862b7714d18372f216407b914ccd25b42b) và [báo cáo Office V2](https://github.com/VietCodeBug/a-place-to-belong/blob/bb74e3862b7714d18372f216407b914ccd25b42b/docs/office-v2-review.md).

- [Video góc nhìn thứ nhất có âm thanh](./office-v2-gameplay.mp4)
- [Sáu cặp ảnh trước và sau](./so-sanh-truoc-sau.jpg)
- [Cúi nhìn sau khi đi và dừng](./candidate/07-nhin-xuong.png) · [Ngồi gõ phím](./candidate/13-ngoi-tai-ban.png) · [Căn hộ PRO-003](./candidate/11-can-ho-toan-canh.png)

Ảnh trước lấy từ bản làm việc dựa trên `edcdb14`, cùng các chỉnh sửa văn phòng đã có trong workspace. Ảnh đối chiếu Office V2 chụp ở 1280 × 720. Bộ ảnh chụp lại tư thế ở 960 × 540 và video dùng bản sửa `bb74e38`. Mọi ảnh đều lấy trực tiếp từ Godot 4.6.3 Compatibility. Góc toàn thân dùng camera kiểm tra riêng.

Video dùng viewport 640 × 360, giới hạn shadow atlas ở 1024 và tắt MSAA trong cấu hình quay tạm. Số đo dưới đây thuộc Linux llvmpipe.

Godot Movie Maker ghi 348 khung hình trong 102 giây. Video dài 23,2 giây ở 15 fps. Bộ ghi báo thời gian render trung bình 268,23 ms CPU và 200,58 ms phía renderer phần mềm mỗi khung. Các số này là chi phí xuất video trên máy Linux, không dùng để ước tính FPS Windows.

Kiểm thử Office First Person, Storybook UI, smoke test rừng và lộ trình từ mở cảnh đến căn hộ đã chạy. Kiểm tra tư thế bao gồm đi rồi dừng, ngồi vào bàn và đổi vị trí khi rig còn bước trụ.
