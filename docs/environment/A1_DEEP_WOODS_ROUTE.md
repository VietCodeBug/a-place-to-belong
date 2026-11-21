# A1 · Nhà A trong rừng sâu

Nhà A ở (16, −84). Cửa làng gần z=101, cách khoảng 185 m theo đường chim bay, và khoảng 200 m theo lối đi trước khi rẽ sang nhánh Thomas. Từ hiên, đường uốn quanh hai vai đồi và nhiều cụm cây trước khi nhập lại tuyến cũ. Nhánh Thomas vẫn nối vào đường chính. Qua cầu, người chơi còn đi qua bìa rừng trước khi thấy rõ làng. [Ảnh Godot theo tuyến](https://github.com/VietCodeBug/a-place-to-belong/blob/preview/a1-deep-woods/docs/environment/review-a1-deep-woods/README.md)

Địa hình đi được kéo tới z=−94. Lối mòn và sân Nhà A dùng cao độ thoải riêng, cùng sampler với mesh và collider. Phần nhà, cầu và làng dùng lại asset sẵn có. Bản đồ M bao quát phần rừng mới, và camera mở đầu lấy mốc spawn mới.

Thảm cỏ lá thấp kéo dọc hai lề và phủ sân Nhà A. Mật độ dọc tuyến làng bớt ngắt đột ngột. Hoa thành cụm ở chân hiên, sau các khúc cua và ven rừng. Kiểm tra vẫn dùng các trạng thái mùa của A1.

Chạy ảnh review bằng `godot --path . --audio-driver Dummy --script tools/capture_a1_deep_woods.gd`. Chạy kiểm tra lộ trình với `godot --headless --path . --disable-render-loop --fixed-fps 60 --script tests/village_a_test.gd`.
