# V07 — Samatha làm người chơi, sửa tay idle

Yêu cầu cuối cùng thay thế các hướng trước: chỉ dùng model có màu, dùng Samatha làm nhân vật chính tạm; nhân vật cũ là NPC `eggeght`. Joe chưa có màu nên không xuất hiện trong hub. Nhà V05, cỏ V06, terrain, S path, hòm thư và camera gameplay giữ nguyên.

| Nhân vật | Vai trò hiện tại | Nguồn / màu |
| --- | --- | --- |
| Samatha | Người chơi tạm | File người dùng, texture PBR màu gốc, 66 xương, 3 clip |
| eggeght | NPC đứng cạnh lối vào | Model màu V06 trước đó, 52 xương; giữ nguyên, không sửa mặt tiếp |
| Lão Joe | Lưu nguồn, chưa dùng | File `npc1.glb` chỉ có material xám, 52 xương, 1 clip |

## Samatha có màu thật

GLB chứa ba PNG 4096²: base color, normal và metallic/roughness. Kiểm tra texture màu và ảnh render Godot, không chỉ dựa vào tên file. Giữ GLB nguyên byte; controller giữ material và UV nguồn. Không thêm mắt/mũi bằng mảng tô thủ công. Các thử nghiệm mặt trước đó đã được bỏ khỏi thay đổi này theo yêu cầu dừng của người dùng.

## Tay đứng nghỉ và đi/chạy

Lỗi T-pose do tính bone pose sai: Godot dùng pose local, nhân thêm inverse rest đã triệt tiêu phần xoay cần thiết. Đã sửa cách tính, hạ hai tay xuống cạnh thân. File không có clip idle nên đây là pose nghỉ tĩnh. Walking/Running gốc được nối với WASD/Shift; nhả phím hoặc UI khóa di chuyển thì về pose nghỉ. Không thay tốc độ, input mapping, capsule hay follow camera.

Integration test kiểm tra hướng vai→khuỷu tay hướng xuống cả khi khởi tạo và sau khi dừng đi/chạy; xác nhận Walking/Running được chọn đúng, không chỉ kiểm tra tên asset. NPC eggeght là StaticBody3D riêng, không nhận input người chơi, đặt ở mép clearing bên trái tại x=-5,4/z=6,8. Không thêm dialogue, quest hay hệ thống NPC mới.

## Nguồn và kiểm thử

`assets/characters/roster.json` ghi vai trò. Hai upload mới có manifest SHA-256 và tên nguồn; file base và màu V06 trước không bị ghi đè. `tools/validate_characters.py` kiểm tra GLB, texture PNG nhúng, rig/clip và hash. Joe được xác nhận xám và không được load trong hub. Samatha giữ nguyên texture nguồn.

Godot 4.6.3 Compatibility trên Linux/Mesa llvmpipe: editor import, boot, smoke controller/UI/mailbox, Map 01 bounds/porch, integration display và source integrity. Không tương đương kiểm thử hiệu năng Windows. Không tự merge PR.

## Ảnh review

[preview/ver-07-samatha-player](https://github.com/VietCodeBug/a-place-to-belong/tree/preview/ver-07-samatha-player): gameplay Samatha, toàn thân với hai tay hạ xuống, cận mặt texture gốc, NPC eggeght và clip Walking. Chụp trực tiếp Godot bằng `tools/capture_characters.gd`; không thay lighting hay dùng ảnh minh họa. Giữ ver-01–06. Chờ người dùng review hình ảnh, không tự tuyên bố hoàn thiện mỹ thuật.
