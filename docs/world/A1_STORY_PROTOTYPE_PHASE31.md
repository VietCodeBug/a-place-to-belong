# Phase 3.1 · Nhà A và sinh hoạt A1

Bản chơi thử tiếp tục trên PR #15 từ `a04741f`.

```bash
godot --path . -- --story-prototype
```

Dùng WASD theo hướng nhìn, chuột để quan sát, E khi dấu ngắm đặt đúng đồ vật hoặc NPC, Shift để chạy, Esc để thoát thoại hoặc mở menu. Trong Điều khiển có độ nhạy, FOV và nhún đầu. Bản đồ M dùng ngoài trời. Thêm `--npc-debug` rồi dùng F8/F9 để đổi một giờ và xem trạng thái làm việc. Debug không cần để chơi.

## Phần đã triển khai

- Một trạng thái mắt dùng chung cho camera trong nhà, ngoài A1 và dưới hồ. Tia tương tác giới hạn tầm và kiểm vật cản. Office và Apartment giữ camera riêng. Camera toàn cảnh chỉ dùng trong công cụ khảo sát và tiêu đề có sẵn.
- Nhà A khoảng **69,4 m² mặt bằng thô**. Có phòng ngủ tách vách, phòng chung với lò, khu bếp ăn, và góc tủ/kệ chứa đồ. Giữ asset cottage và mái cũ, tăng diện tích ngoại thất tương ứng quanh điểm neo bậc cửa. Vào và ra dùng lại cùng nhân vật và đồng hồ thế giới. Cửa sổ, đèn, ngăn bếp, chăn và cửa có kết quả trực tiếp.
- 30 cư dân giữ nguyên ID và hình dáng placeholder. 18 core/supporting dùng waypoint chung để đi lấy đạo cụ, mang tới điểm làm và đặt xuống. 12 ambient tiếp tục theo lịch tới nơi sinh hoạt hoặc về nghỉ. Các hoạt động gần có vật thể đặt ở hai đầu tuyến, động tác và âm thanh ở nhịp sử dụng. Cư dân xa giữ đường và vị trí logic. NPC đang đi dừng nhường A khi cần.
- Hội thoại đặt ở góc dưới, hiện một đến hai câu và lựa chọn. Các câu đã duyệt vẫn nằm trong snapshot. Giao diện thư dùng riêng cho thư/tài liệu.
- Thomas làm củi, củi lăn ra và có thể nhặt để xếp. Hazel cho lấy bình, tưới hai luống và trả bình. Owen cho giữ đầu gỗ hoặc lấy nêm để sửa theo cách khác. Mâm nhỏ của Clara/Grace có bát có thể mang đặt lên bàn. Khi A rời hẳn chỗ làm, NPC có thể làm nốt. Luống đã tưới vẫn ẩm, kết quả NPC tự làm lưu riêng và Owen nhắc đến đúng cách sửa khi gặp lại.
- Foley bước chân, cửa, gió cửa sổ, gõ gỗ và nước phát theo hành động. Bản ghi hình kết xuất không kèm âm thanh.

## Căn nhà lân cận

Trong source và cảnh gameplay của PR #15, tại cụm rừng `(16, −338)` chỉ có node `ForestHouseA`, dùng `hewn_eaves_cottage.glb`. Vùng sát cạnh trong `build_house_grove()` có cây và đá. Café tại `(0, 0)` cách khoảng **338 m**. Công trình làng gần nhất còn xa hơn. Ảnh khảo sát từ trên cao đánh dấu đúng địa điểm. Interior của căn nhà thứ hai đang chờ xác định đúng công trình từ bản map của người sáng tạo.

## So sánh ở Làng A

Godot 4.6.3 Compatibility, Mesa llvmpipe, 960 × 540. Cả hai bản dùng cùng camera ngang mắt tại X 5,8 và Z 128,6, cùng hướng nhìn và giờ 10:18, ẩn avatar local. Lấy 32 mẫu sau 28 khung làm nóng. Phase 3 lấy từ bản archive `a04741f`, có thêm bộ đếm thời gian NPC trong bản archive tạm. Lượt Phase 3.1 đo code `b322545`. Thời gian qua cửa đo phần xử lý đồng bộ khi hai world đã nạp. Hoạt ảnh mở cửa riêng dài 0,32 giây.

| Chỉ số | Phase 3 | Phase 3.1 |
| --- | ---: | ---: |
| Frame time P50 | 997,6 ms | 1.109,9 ms |
| Frame time P95 | 1.229,0 ms | 1.154,6 ms |
| Draw calls trung vị | 1.384 | 1.395 |
| NPC đang hoạt động gần A | 28 | 28 |
| Tick NPC P50 / P95 | 0,022 / 0,156 ms | 0,214 / 0,366 ms |
| Qua cửa vào / ra | 60 / 426 µs | 66 / 233 µs |
| Bộ nhớ engine | 156,1 MiB | 159,0 MiB |
| Bộ nhớ dựng hình Godot báo | 357,59 MiB | 357,57 MiB |

Frame time tăng 11,3% ở P50 và giảm 6,1% ở P95 trong lượt đo phần mềm tại góc này. Chi phí cập nhật NPC tăng 0,210 ms ở P95. Cả hai bản báo hai texture GL còn tồn tại lúc tắt Godot. Hiệu năng trên GPU Windows chưa được đo.

## Ảnh và gameplay

[Album Godot, ảnh mặt bằng, ảnh khảo sát và video](https://github.com/VietCodeBug/a-place-to-belong/blob/preview/a1-story-prototype-phase31/docs/world/review-a1-story-prototype-phase31/README.md)

Bản quay first-person dài khoảng 1 phút 4 giây. Các quãng chạy dài được cắt từ cùng một lượt chơi. Bản debug ca sáng của Hazel dài khoảng 18 giây và dùng công cụ đổi giờ. Clip debug thứ hai ghi Clara và Grace gặp nhau trong giờ nghỉ, tự quay về phía nhau và trao đổi hai lượt thoại khi A đứng bên lề. Các clip kết xuất 640 × 360 ở 8 FPS, không kèm âm thanh. Hai ảnh khảo sát bố cục Nhà A và cụm rừng có độ phân giải 1280 × 720. [Bản ghi giờ nghỉ của Clara và Grace và log benchmark lượt đầu](https://github.com/VietCodeBug/a-place-to-belong/blob/preview/a1-story-prototype-phase31-npc-exchange/docs/world/review-a1-story-prototype-phase31/README.md)

## Kiểm thử và giới hạn bàn giao

- Godot đã chạy tuyến Nhà A → Thomas → Làng A → Nhà A bằng controller và tia nhìn. Lượt kiểm còn có nhánh giữ đầu gỗ, lời gặp lại Thomas, Hazel và Owen, kết quả bát trên bàn, bỏ dở việc đã nhận, thích nghi mưa trong nhà, mở M, giờ về nhà và bơi/lặn first-person. Đối chiếu 30 ID, 642 đoạn đường NPC và ghi nhận 32 lượt thu/mang/đặt đạo cụ trong lượt kiểm cuối. Tuỳ chọn debug giờ phục vụ kiểm thử, nằm ngoài vòng chơi chính.
- Chạy lại `a1_superworld_test`, `village_a_test` với `--a1-superworld`, `smoke_test` và `office_first_person_test`. Các lượt đều qua. Test Làng A tính phím theo yaw first-person khi chạy với cờ A1, nên vẫn dùng controller thực tế.
- Video ghi ba tình huống Thomas, Hazel và Owen. Mẫu dọn bàn có kiểm tra trạng thái riêng. Một số động tác của dân làng vẫn dùng chung bộ cử động hình khối. Nhìn qua cửa sổ trong phòng thấy một cụm cây dùng asset A1 và đổi theo mùa.
- Ngoài việc xác định công trình thứ hai, chất lượng diễn xuất và bố cục mới vẫn cần người sáng tạo duyệt. Dữ liệu hội thoại DRAFT không đổi canon của Chapter 01.
