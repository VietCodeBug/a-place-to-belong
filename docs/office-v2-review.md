# Office V2 · Bản duyệt góc nhìn thứ nhất

Map 01 mở tại bàn làm việc của A. Sau khi đọc và đóng email Nhân sự, người chơi tự đi tới lối ra để vào căn hộ thuê của PRO-003. Map 02 vẫn là khu rừng có nhà và bãi cỏ, mở trực tiếp từ menu. Chế độ thử phần tranh PRO-001 dùng `--comic-preview`.

## P0

- **Camera và cơ thể.** Góc nhìn từ mắt có nới vị trí về trước khi cúi để tránh thấy mặt trong cổ áo. Góc cúi giảm nếu cơ thể đang sát vật cản. Khi đổi vị trí đột ngột, rig đặt lại điểm trụ chân và tay nghỉ thấp bên hông khi đứng. Tùy chọn độ nhạy chuột và nhún đầu nằm trong Cài đặt → Điều khiển. Camera dùng một hình cầu để giới hạn phần dịch chuyển khi gặp vật cản. A dùng model và rig hiện có, với tiếp xúc bàn phím và chuột dựa trên vị trí đạo cụ.
- **Email.** Màn hình bàn làm việc dùng một SubViewport dựng hộp thư và trạng thái thư mới. Khi người chơi nhấn E, camera hướng nhẹ về màn hình và mở bản đọc dễ nhìn. Esc, E và nút đóng trả quyền điều khiển. Có thể mở lại. Nội dung lấy nguyên từ `assets/story/office.json`.
- **Không gian.** Giữ hai dãy bàn, lối đi, góc in và bàn họp. Cân lại đèn bàn, ánh sáng lạnh ngoài cửa sổ, vân và sắc độ vật liệu, thêm biến thể sổ tay và dây màn hình. Nhóm cửa sổ thành phố thành các MultiMesh theo từng tòa. Những hộp cùng hình và vật liệu dùng chung mesh runtime.
- **Đồng nghiệp.** Giữ hai rig nhân viên và rig sếp đã có trong bản nháp. Gõ phím, dùng chuột, đọc giấy, uống nước và đứng lên chạy theo các nhịp lệch nhau. Sếp tiếp tục đi tuần. Công việc xung quanh vẫn diễn ra trong lúc người chơi đọc email.

## P1

- **Mở cảnh.** Khoảng tám giây góc nhìn thứ nhất, từ gõ phím đến liếc ra cửa sổ, xem điện thoại, nhận thư rồi đứng dậy. Esc bỏ qua đoạn dẫn và thư vẫn chưa được đọc.
- **Thời tiết và âm thanh.** Mưa nằm ngoài kính. Kính có vệt nước và thành phố có các lớp sương. Sấm chớp giãn nhịp và dời thời điểm khi người chơi đang đọc. Âm nền có máy in, điều hòa, ghế, bàn phím, chuột và tiếng trò chuyện không lời. Âm báo thư phát một lần.
- **Khuôn mặt.** Dùng các xương hàm, môi và phần mắt có trên từng rig. Các giá trị môi đóng, mở, tròn và kéo ngang lấy nhịp từ cử chỉ cho bản thử. Chưa đối chiếu với thoại thu âm. Các rig đồng nghiệp có ít điều khiển mặt hơn rig A.
- **Căn hộ.** Dùng một căn phòng qua ba nhịp tắt báo thức, tìm việc và báo thức hết hẹn. Bàn, giường, đồng hồ và cửa sổ ở cùng chỗ. Tương tác tùy chọn bằng E, Enter đi tiếp. Bản thử kết khi nhân vật ngồi xuống giường, ngay trước PRO-004. Bố cục căn hộ thuộc bản thử mỹ thuật.

## Kiểm thử và tư liệu

Chạy Godot 4.6.3 Compatibility trong Linux. Kiểm thử console bao gồm va chạm kính, nhìn và độ cao camera, tiếp xúc tay với bàn phím và chuột, nhịp mưa sấm, mở và đọc lại thư, phím Esc, lối đi từ bàn tới cửa và các trạng thái của căn hộ. Bộ kiểm thử menu và gameplay rừng kiểm tra hồi quy.

```bash
godot --headless --editor --path . --quit
godot --headless --path . --fixed-fps 60 --script tests/office_first_person_test.gd
godot --headless --path . --script tests/v12_ui_test.gd
godot --headless --path . --script tests/smoke_test.gd
godot --path . --write-movie /tmp/office.avi --fixed-fps 15 --script tools/capture_office_v2.gd
```

Ảnh trước là bản nháp đang mở lúc bắt đầu, dựa trên `edcdb14` cùng các chỉnh sửa local có sẵn. Đối chiếu các góc bàn làm việc, văn phòng, phòng họp, thành phố và đồ nội thất ở cùng tọa độ. Ảnh và video lấy từ renderer Godot. Góc toàn thân của A dùng camera kiểm tra riêng và hiện đầu để xem rig.

Các file GLB đã chuyển đổi từ bản người dùng gửi đi kèm source code. Chi tiết vật liệu và cảnh quay mới dùng tài nguyên Godot, nên bản này không có file Blender mới. Chưa kiểm thử trên Windows hoặc đánh giá hiệu năng trên GPU phần cứng. Bản chơi cần một lượt duyệt chuyển động và mỹ thuật của người dùng.
