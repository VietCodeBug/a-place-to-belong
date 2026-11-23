# A1 · Từ Nhà A qua rừng đến làng

Nhà A nằm ở (16, −338). Lối đi từ hiên tới cửa làng dài khoảng 510 m, mất khoảng ba phút ở tốc độ đi bộ 2,8 m/s. Rừng sâu chiếm hơn 400 m đầu tiên. Đường đổi hướng qua các sườn đồi và cụm rừng, nhập lại tuyến cũ gần nhánh Thomas rồi qua cầu và bìa rừng trước khi mở ra làng. Bản đồ M đã bao quát toàn bộ tuyến. [Ảnh Godot theo tuyến](https://github.com/VietCodeBug/a-place-to-belong/blob/preview/a1-forest-journey/docs/environment/review-a1-forest-journey/README.md)

Cỏ quanh nhà và dọc tuyến chính được trồng trên lưới có độ xê dịch, thành lớp cỏ dày sát lề và lớp thưa dần ở xa hơn. Các cụm hoa bám theo hai bên khúc cua và tập trung nhiều quanh hiên. Cỏ và hoa dùng MultiMesh chia theo đoạn, với hình học đơn giản hơn ở phần ngoài lề. Xuân và hè có nhiều hoa, thu còn các cụm thưa hơn, đông phủ tuyết.

Hai GLB cáo và hươu từ bộ Ultimate Animated Animal Pack của Quaternius, giấy phép CC0, tổng dung lượng khoảng 1,25 MB. Mỗi loài có animation đi, đứng nghỉ và cúi ăn. Cáo xuất hiện gần Nhà A và trong rừng phía thung lũng. Hai con hươu xuất hiện cùng một khoảng rừng giữa đường. [Nguồn và SHA-256](../../assets/vendor/quaternius/a1_wildlife/provenance.json)

Chạy ảnh review bằng `godot --path . --audio-driver Dummy --script tools/capture_a1_deep_woods.gd`. Chạy kiểm tra đi–về và bốn đường nhánh bằng `godot --headless --path . --disable-render-loop --fixed-fps 60 --script tests/village_a_test.gd`. Ảnh từ Godot Compatibility trên Linux với Mesa llvmpipe. Hiệu năng trên GPU đích chưa được đo.
