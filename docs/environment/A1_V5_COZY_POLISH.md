# A1 V5 · Cân bằng lại cảnh quan

V4 `f6f2a26` là mốc so sánh. V5 chỉnh bảng màu và cách sắp đặt ngay trên cảnh hiện có. Mười cặp ảnh nắng hè chụp cùng camera, thời tiết và giờ 15:09. [Ảnh trước/sau, ảnh mưa và vòng đi bộ Godot](https://github.com/VietCodeBug/a-place-to-belong/blob/preview/a1-cozy-v5/docs/environment/review-a1-cozy-v5/README.md).

- Cỏ xanh dịu, đất rừng ấm, phù sa chuyển mềm. Hạ tần số và độ tương phản của noise, rêu tối và sỏi. Giữ vệt bánh, rãnh và các chỗ trũng với độ tương phản thấp khi khô.
- Dùng chung bộ cỏ lá cong. Giảm mật độ cỏ lề, gom hoa theo mẫu chủ đạo thành cụm nhỏ. Vườn giữ các stage rau, giãn cây theo hàng, đặt cọc cà chua theo khoảng hàng mới và cho lối giữa luống rõ hơn.
- Mức bạc màu phân theo công trình. Nhà dân dùng mức nhẹ, nhà thờ và nhà đá nhỉnh hơn, Nhà A có nhiều dấu thời gian hơn. Ánh sáng môi trường tăng nhẹ và bóng nắng mềm hơn.
- Thảm cỏ gốc từ `CuratedGroundCover/DenseMeadow` được tắt vào mùa đông cùng cỏ V4. Nền tuyết phủ thêm vùng Nhà A, đường giữ phần lòng lối mòn đọc được. Mưa và vệt bắn bám cao độ vùng chơi thay vì kẹt trong ô quán rừng.
- 17 gò/hõm dùng địa hình và va chạm V4. Bộ test kiểm cao độ tại gò, vòng đi về, bốn ngõ, mùa rau và việc ẩn cỏ gốc khi có tuyết.

```sh
godot --path . --audio-driver Dummy --script tools/capture_a1_v5.gd
godot --path . --audio-driver Dummy --fixed-fps 3 --script tools/capture_a1_v5_walk.gd
godot --headless --path . --disable-render-loop --fixed-fps 60 --script tests/village_a_test.gd
```

Nhánh đất từ tọa độ Thomas (−6,85 / 17,8) nối vào ngã Nhà A và đường rừng. Tuyến tiếp tục qua cầu, cửa làng và các lô phía sau. Camera tại mốc Thomas có một góc nhìn về Nhà A và một góc nhìn ra tuyến làng. Phần review dùng vị trí của Thomas và nhánh đi bộ; model NPC nằm trong bản cục bộ trước đó. Các cây rìa rừng còn dùng mesh cũ ở cự ly gần được đưa vào hệ chuyển mẫu theo khoảng cách.
