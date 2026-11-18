# V12 — Menu ký họa, thời tiết tự động

18/11/2026. Kế thừa V11 bfae2f9 trên PR #10; chưa merge.

## Chốt theo góp ý mới nhất

Thời tiết vẫn tự động. Không có postcard đổi giờ/mưa trong main menu, không có Atmosphere Studio trong menu nghỉ thông thường. Công cụ test giờ/thời tiết chỉ mở qua cờ `--atmosphere-debug`; không phải tính năng menu chính thức. Không viết lại mô phỏng thời tiết.

Main menu là bưu thiếp ký họa toàn màn hình: nét mực, mảng gouache phẳng, giấy kem, chữ Caveat viết tay và nút viền mực hơi lệch. Background này là tranh UI, **không phải ảnh của Map 01 3D**. Vào chơi vẫn là map 3D hiện có. Không thay nhà café hoặc cỏ để làm đẹp menu.

Menu nghỉ chỉ có Resume, Settings, Controls, Return to title và Quit. Settings chia Audio, Graphics, Controls, Accessibility; cài đặt áp dụng trong phiên, không giả vờ có lưu file. Quiet UI tắt âm UI, rung/nhún prompt và các hoạt cảnh mở thư/chữ.

Thư có phong bì mở nắp, dấu coral, giấy viền airmail, dấu bưu điện và chữ hiện dần. Hội thoại giữ nội dung có sẵn và dùng cùng typography; không thêm portrait hay lựa chọn giả. Thông báo ngắn xuất hiện khi cất thư/đóng trao đổi. Nút dùng nét viền tự vẽ, font viết tay và phản hồi hover/focus.

## Thành phần và nguồn

Theme/components: storybook_theme, storybook_screens, sketch_button, postal_motif, letter_stationery, envelope_reveal. Xem ui-design-system.md.

Tranh sketch được tạo bằng ImageGen theo phong cách vẽ tay, không nhận là họa sĩ vẽ tay thật. Prompt, nguồn và SHA-256 nằm ở assets/ui/postcards/provenance.json. Hướng fantasy chi tiết bị người dùng loại bỏ, không được tích hợp. Dấu bưu điện/phong bì/viền/nút là code Godot. Caveat (SIL OFL) dùng cho chữ viết tay; DejaVu Sans có license kèm dùng cho phần đọc dài. CLI game-dev không có; PNG được kiểm tra decode/hash/import và xem trong Godot, không nhận có CLI package verification.

## Giữ nguyên

Café, cỏ đã duyệt, terrain, cây/động vật, đường, collision, nhân vật, camera gameplay, vùng chơi và Compatibility renderer. Không thêm save/inventory/quest. Hệ ngày–đêm/thời tiết tự động và âm rừng tiếp tục hoạt động trong game.

## Kiểm chứng và ảnh

Editor import, smoke, map01_scope, weather_cycle, v10_visual_overhaul, v11_atmosphere và v12_ui. UI test đưa Tab/Enter vào GUI thật; kiểm tra Esc/focus, không có điều khiển thời tiết trên title/pause chính thức, chặn truy cập Studio nếu thiếu cờ test, chỉnh giờ debug, khóa/mở di chuyển khi đọc thư và nút trong màn hình ở 720p/1080p. Validator khóa tài nguyên V10 và diff checks.

`tools/capture_v12_ui.gd`: main, hover/focus, Settings/Graphics/Accessibility, pause, Controls, phong bì, thư, hội thoại, notification ở 720p và 1080p. Ảnh chụp từ Godot thật; riêng tranh nền menu là asset minh họa nêu trên. Capture giữ clock đứng để so sánh; runtime bình thường không giữ. Tween đọc thư được tiến tới cuối để chụp đủ chữ. Nền map khi vào gameplay không đổi.

## Giới hạn

Cần duyệt mỹ thuật trực tiếp, không suy ra mức wow từ test pass. Tranh nền menu không khớp từng chi tiết với mô hình café; nó là bưu thiếp minh họa. Settings chưa lưu qua lần mở game, chưa có journal/portrait/dialogue tree. Chưa benchmark Windows GPU. Hai texture leak lúc thoát Godot vẫn có từ baseline.

Preview: https://github.com/VietCodeBug/a-place-to-belong/tree/preview/ver-12-storybook-ui
