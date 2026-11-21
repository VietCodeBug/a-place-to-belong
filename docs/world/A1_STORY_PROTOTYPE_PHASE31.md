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
- Thomas làm củi, củi lăn ra và có thể nhặt để xếp. Hazel cho lấy bình, tưới hai luống và trả bình. Owen cho giữ đầu gỗ hoặc lấy nêm để sửa theo cách khác. Mâm nhỏ của Clara/Grace có bát có thể mang đặt lên bàn. Các tình huống lưu kết quả A làm hoặc NPC tự xử lý riêng. Không có điểm quan hệ tự tăng do thoại.
- Foley bước chân, cửa, gió cửa sổ, gõ gỗ và nước phát theo hành động. Bản ghi hình kết xuất không kèm âm thanh.

## Căn nhà lân cận

Trong source và cảnh gameplay của PR #15, tại cụm rừng `(16, −338)` chỉ có node `ForestHouseA`, dùng `hewn_eaves_cottage.glb`. Vùng sát cạnh trong `build_house_grove()` có cây và đá. Café tại `(0, 0)` cách khoảng **338 m**. Công trình làng gần nhất còn xa hơn. Ảnh khảo sát từ trên cao đánh dấu đúng địa điểm. Interior của căn nhà thứ hai đang chờ xác định đúng công trình từ bản map của người sáng tạo.

## So sánh ở Làng A

Godot 4.6.3 Compatibility, Mesa llvmpipe, 960 × 540, camera đo cố định ngang mắt tại `(5,8; 128,6)`, cùng góc nhìn và thời gian 10:18. Lấy 32 mẫu sau 28 khung làm nóng. Phase 3 lấy từ bản archive `a04741f`, thêm bộ đếm thời gian NPC trong bản archive tạm. Số thời gian qua cửa đo phần xử lý đồng bộ khi hai world đã nạp, ngoài hoạt ảnh mở cửa 0,32 giây.

| Chỉ số | Phase 3 | Phase 3.1 |
| --- | ---: | ---: |
| Frame time P50 | 877,8 ms | 846,2 ms |
| Frame time P95 | 1.306,8 ms | 913,4 ms |
| Draw calls trung vị | 1.386 | 1.395 |
| NPC đang hoạt động gần A | 28 | 28 |
| Tick NPC P50 / P95 | 0,015 / 0,127 ms | 0,206 / 0,312 ms |
| Qua cửa vào / ra | 97 / 488 µs | 58 / 202 µs |
| Bộ nhớ engine | 156,2 MiB | 159,1 MiB |
| Bộ nhớ dựng hình Godot báo | 357,58 MiB | 357,64 MiB |

Đây là phép đo phần mềm tại một góc camera. Hiệu năng trên GPU Windows chưa được đo.

## Ảnh và gameplay

[Album Godot, ảnh mặt bằng, ảnh khảo sát và video](https://github.com/VietCodeBug/a-place-to-belong/blob/preview/a1-story-prototype-phase31/docs/world/review-a1-story-prototype-phase31/README.md)

## Kiểm thử và giới hạn bàn giao

- Godot đã chạy tuyến Nhà A → Thomas → Làng A → Nhà A bằng controller và tia nhìn. Test thêm nhánh giữ đầu gỗ, kết quả bát trên bàn, gặp lại Thomas, thích nghi mưa trong nhà, mở M, giờ về nhà và bơi/lặn first-person. Đối chiếu 30 ID, 642 đoạn đường NPC và quan sát 15 lượt thu/mang/đặt đạo cụ trong lượt kiểm. Tuỳ chọn debug giờ phục vụ kiểm thử, nằm ngoài vòng chơi chính.
- Chạy lại `a1_superworld_test`, `village_a_test` với `--a1-superworld`, `smoke_test` và `office_first_person_test`. Các lượt đều qua. Test Làng A tính phím theo yaw first-person khi chạy với cờ A1, nên vẫn dùng controller thực tế.
- Video ghi ba tình huống Thomas, Hazel, Owen; mẫu dọn bàn có kiểm tra trạng thái riêng. Một số động tác của dân làng vẫn dùng chung bộ cử động hình khối. Ngoài trời, cửa sổ trong phòng cho nhìn một cụm cây minh họa dùng cây A1 và theo mùa.
- Ngoài việc xác định công trình thứ hai, chất lượng diễn xuất và bố cục mới vẫn cần người sáng tạo duyệt. Dữ liệu hội thoại DRAFT không đổi canon của Chapter 01.
