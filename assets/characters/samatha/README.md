# Samatha — nhân vật chính tạm

Nguồn GLB người dùng cung cấp, tên gốc trong manifest; lưu nguyên byte thành `samatha.glb`. Có 66 xương, ba clip `Running`, `Walking`, `Casual_Walk` và ba PNG 4096 × 4096 nhúng: base color, normal, metallic/roughness. Texture màu đã được kiểm tra và render thực tế trong Godot. Không tô màu lại mặt hoặc thay material nguồn.

WASD dùng Walking, Shift dùng Running. Không có idle clip trong file: dùng pose nghỉ tĩnh với tay hạ tự nhiên, không gọi đó là idle animation. Chỉnh pose trên skeleton runtime, giữ nguyên bind/source GLB. Godot 4 bone pose là transform local; không nhân ngược rest rotation thêm lần nữa. Kiểm tra cả lúc bắt đầu và khi ngừng đi/chạy để tránh T-pose.

Controller/camera/collider người chơi tiếp tục dùng scene `scenes/player/postal_worker.tscn`; metadata nhận diện Samatha. Nguồn GLB chuẩn hóa trọng số trên bản mesh runtime, giữ UV/material/texture. Cao 1,7 m. Scene visual riêng `scenes/characters/samatha.tscn` dùng để tái sử dụng.

Nguồn do người dùng cung cấp cho prototype; không có paid generation và không tự gán CC0. SHA-256 và tên nguồn đầy đủ trong manifest. Chưa có đo hiệu năng phần cứng Windows.
