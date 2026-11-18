# Circular Postal UI — V12 follow-up

Triển khai kế hoạch đã được duyệt ngày 18/11/2026, kế thừa b9d63d4. Đây là lượt UI, không phải đợt môi trường V13 trong tài liệu đề xuất. Preview dùng số tiếp theo còn trống: ver-13-circular-postal-ui.

## Thay đổi

- HUD bỏ panel chữ nhật. Đồng hồ bỏ túi có vòng oak, mặt forest, kim 12 giờ và giờ số 24 giờ, badge thời tiết tròn gắn cạnh. Nhãn buổi/thời tiết bên phải lấy trực tiếp từ hệ hiện có; không có Day 01 giả hoặc nút chỉnh thời tiết. Icon được tăng tương phản trên nền kem. Không có slider/gesture đổi giờ trên HUD; bấm cụm HUD chỉ mở pause như trước.
- Nút cất thư trở thành dấu sáp coral tròn với hình phong thư và nhãn chữ rõ; Tab/Enter/Esc vẫn hoạt động. Giấy có góc gấp và mép lớp giấy thứ hai ngoài vùng đọc. Giữ nội dung thư/NPC thật.
- Đóng thư có nắp phong bì gấp lại 0.20 giây rồi mờ 0.12 giây. Modal và khóa di chuyển được giải phóng ngay, lớp hoạt cảnh không chặn chuột. Headless/Quiet UI bỏ hoạt cảnh đóng. Hoạt cảnh mở hiện có tiếp tục dùng chung phong bì.
- Badge phím E tròn hơn; notification có con dấu tròn và nằm dưới HUD, không đè đồng hồ. Controls hint tự mờ sau vài giây vào chơi, không cần chờ nhân vật đi bộ.
- Main menu ký họa, typography, dấu bưu điện hiện có được giữ; không làm lại nền. Không thêm portrait/Journal/quest UI giả khi chưa có dữ liệu.

## Phạm vi bảo vệ

Không đổi café, cỏ, môi trường, nhân vật, camera gameplay, collider, vùng chơi hoặc renderer. Không đưa công cụ thời tiết vào menu chính thức; --atmosphere-debug vẫn là cổng test. Không thêm scheduler thời tiết: HUD chỉ đọc state của hệ hiện tại. Việc tự chuyển trạng thái thời tiết trong review môi trường thuộc lượt riêng.

## Asset và kiểm tra

Các thành phần mới là hình vẽ Godot (postal_clock, wax_close_button), không tải/generate ảnh hay addon mới. Font và license có sẵn giữ nguyên.

Editor import, smoke, V10 integration và V12 UI tests pass; UI test bổ sung kiểm tra mặt đồng hồ không có panel nền và lấy giờ thật từ environment. Test trước đó về debug gate, bàn phím, modal và 720p/1080p vẫn giữ. Validator khóa tài nguyên V10 và diff checks pass. Kết quả test không được coi là duyệt mỹ thuật.

Ảnh Godot thật ở 720p/1080p: HUD sáng, HUD đêm, phong bì mở, thư/dấu sáp, phong bì đóng, title và pause. tools/capture_circular_ui.gd giữ giờ/weather chỉ trong capture để tái hiện góc chụp; ảnh thư hoàn tất tiến tween thật tới cuối để đọc đủ chữ. Linux Godot4.6.3 Compatibility/Mesa llvmpipe, không phải benchmark Windows GPU. Hai texture cleanup leak từ baseline vẫn xuất hiện khi thoát.

## Còn hạn chế

Kim/viền vẫn là vector thủ tục, chưa có artwork đồng hồ riêng; chuyển động tay kim theo game time, không mô phỏng cơ khí. Không thêm grain texture/blur hay âm giấy thu thật. Tranh main menu vẫn là asset minh họa V12; cảnh 3D không được nâng chất lượng trong lượt này. Cần duyệt trực tiếp về độ lớn HUD và độ rõ chữ trên các vùng rừng khác nhau.

Preview: https://github.com/VietCodeBug/a-place-to-belong/tree/preview/ver-13-circular-postal-ui
