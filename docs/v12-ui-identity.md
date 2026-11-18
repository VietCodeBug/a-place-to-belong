# V12 — Forest Post UI Identity

18/11/2026. Baseline: V11 bfae2f9; PR #10, chưa merge.

## Đã đổi

Main menu bỏ bảng xanh lớn; tên game Serif, dấu bưu điện cà phê/phong thư và nút bắt đầu nằm trực tiếp trên lớp chuyển sắc nền 3D. Settings/Leave là nút phụ gọn. Ba bưu thiếp chuyển xuống góc dưới, mỗi thẻ có cảnh riêng, trạng thái chọn lưu rõ bằng dấu coral, hover/focus nghiêng nhẹ. Không có Continue vì game chưa có save.

Pause chỉ còn hành động chính; đồng hồ và thời tiết nằm ở Atmosphere Studio riêng. Settings chia Audio, Graphics, Controls, Accessibility, có phản hồi thay đổi và chế độ Quiet UI. Cài đặt áp dụng trong phiên, chưa lưu ra đĩa. Studio điều khiển hệ thời tiết hiện có, không bổ sung mô phỏng khí hậu.

Hòm thư mở bằng phong bì có dấu coral/hoạt cảnh nắp, sau đó là giấy viền airmail và dấu hủy tem. Nội dung thật giữ nguyên, chữ hiện dần. Hội thoại NPC dùng cùng font/giấy; chưa có portrait hoặc cây lựa chọn vì gameplay hiện tại chưa cung cấp. Khi đóng có thông báo ngắn. Nút/hover có âm UI tổng hợp nhẹ, Quiet UI tắt được.

Theme, typography và các thành phần đã tách khỏi interaction_controller thành storybook_theme, storybook_screens, postal_motif, letter_stationery và envelope_reveal. Xem ui-design-system.md. Dấu bưu điện/phong bì được vẽ bằng Godot; ba tranh postcard cuối dùng ImageGen theo phong cách nét mực + gouache phẳng, sau khi người dùng loại hướng tranh fantasy chi tiết vì quá AI. Không nhận là họa sĩ vẽ tay thật; prompt/nguồn/SHA-256 nằm ở assets/ui/postcards/provenance.json. Các thử nghiệm tranh chi tiết và crest cũ không được đưa vào game. Hai font DejaVu có license kèm theo trong assets/ui/fonts.

## Giữ nguyên

Không sửa nhà café, cỏ đã duyệt, terrain, cây/động vật, road/collision, player, thông số camera và renderer Compatibility. Không mở map hoặc thêm save/inventory/quest. Validator tài nguyên V10 kiểm tra các tài nguyên khóa, cùng git diff để kiểm tra phạm vi.

## Kiểm chứng

Editor import và sáu bộ test (89 assertion pass): smoke, map01_scope, weather_cycle, v10_visual_overhaul, v11_atmosphere, v12_ui. Test UI đưa sự kiện Tab/Enter vào GUI thật, kiểm tra focus, postcard selection, thứ tự lớp Settings trên Title, Esc trở về menu, Studio chỉnh giờ, khóa/mở player khi đọc thư và bố cục nút ở 1280×720/1920×1080. Headless GUI tests không thay thế việc xem ảnh.

`tools/capture_v12_ui.gd` chụp ảnh Godot Compatibility thật ở 720p và 1080p: main, focus/hover, selected postcard, settings, accessibility, pause, Studio, controls, envelope, thư, hội thoại, notification. Clock được giữ cố định; ở ảnh đọc thư hoàn tất, script tiến tween UI thật đến cuối để chụp đủ chữ, không thay nội dung. Ảnh dùng renderer Mesa llvmpipe Linux; không là ảnh AI và không là benchmark Windows GPU.

## Còn hạn chế

Bối cảnh 3D núi/mây V11 không thay đổi trong lượt UI này. Minh họa postcard còn đơn giản; logo hiện là typography + vector postal mark, chưa phải bộ nhận diện minh họa hoàn chỉnh. Hội thoại chưa có chân dung hoặc lựa chọn mới; chưa có journal/load/quest vì chưa có dữ liệu gameplay. Quiet UI chỉ tác động UI. Hai texture leak lúc thoát Godot vẫn còn từ baseline; không tuyên bố renderer sạch hoặc đạt 60 FPS. Cần người dùng duyệt hình ảnh, không suy ra chất lượng mỹ thuật từ test pass.

Preview: https://github.com/VietCodeBug/forest-post-cafe/tree/preview/ver-12-storybook-ui
