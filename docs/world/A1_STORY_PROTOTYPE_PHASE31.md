# Phase 3.1 · Nhà A và sinh hoạt A1

Bản chơi thử tiếp tục trên PR #15 từ `a04741f`.

```bash
godot --path . -- --story-prototype
```

Dùng WASD theo hướng nhìn, chuột để quan sát, E khi dấu ngắm đặt đúng đồ vật hoặc NPC, Shift để chạy, Esc để thoát thoại hoặc mở menu. Trong Điều khiển có độ nhạy, FOV và nhún đầu. Bản đồ M dùng ngoài trời. Thêm `--npc-debug` rồi dùng F8/F9 để đổi một giờ và xem trạng thái làm việc. Debug không cần để chơi.

## Mẫu nhân vật tạm thời

A, Thomas, cư dân Làng A, Eggeght và dàn nhân vật văn phòng dùng chung mẫu VRM của Pixiv để thử hình trong cảnh. Chuyển động của người chơi và dàn văn phòng lấy từ rig cũ. Trong A1, các đạo cụ làm việc được gắn vào xương bàn tay. Thêm `--original-cast` để xem dàn model trước khi thử mẫu.

[Nguồn và giấy phép](../../assets/characters/pixiv_vrm_sample/README.md) · [Ảnh trong Godot](https://github.com/VietCodeBug/a-place-to-belong/blob/preview/a1-pixiv-sample-cast/docs/world/review-pixiv-cast/README.md)

## Nhà A lúc mới nhận

Sàn gỗ mòn ở lối đi, tủ bếp bạc sơn, chăn có mảnh vá và lò có vệt ám khói. Bên ngoài, sơn cửa chớp sờn lộ gỗ, tường vôi bong nhẹ và rêu tập trung gần bậc hiên, chân tường. Mức hao mòn ban đầu là `0.72`. `set_house_wear()` điều chỉnh đồng thời cả trong lẫn ngoài, để lần sửa nhà sau có thể chuyển về diện mạo sáng và sạch hơn.

[Ảnh trước và sau cùng góc trong Godot](https://github.com/VietCodeBug/a-place-to-belong/blob/preview/a1-house-a-weathered/docs/world/review-a1-house-wear/README.md)

## Sạp làng, sân bên và chó mèo

Đoạn đường lát qua sân chung dành cho lưu thông. Ba sạp nông sản, gốm và bánh nằm trên các khoảng lát hai bên và quay mặt ra đường. Bàn, kệ và ghế của khu dọn mâm ở sân bên cạnh. Bát của Clara và Grace xuất hiện trên kệ hoặc trên bàn theo công việc. A vẫn có thể dùng **E** để lấy bát và đặt lên bàn.

Chó Shiba chạy dọc đường chính, còn mèo mướp chạy nước kiệu quanh ngã rẽ rồi tạt qua đường. Hai con đi theo cao độ mặt đất, chậm hoặc dừng khi gặp người hay nhau và quay đầu nếu lối phía trước bị chặn. Đây là động vật sinh hoạt trong làng. Shiba dùng GLB gốc của Quaternius theo CC0. Mèo mướp được dựng và rig trong Blender cho dự án, với các clip đứng, đi và chạy nước kiệu. File Blender và source dựng nằm trong `art_source/village_a`.

Lượt kiểm kiểm tra bề rộng đoạn đường trong ảnh, chướng ngại dọc tuyến động vật, clip chạy của cả hai và thao tác E ở sân bên. [Ảnh trước và sau, ba sạp và video chó mèo](https://github.com/VietCodeBug/a-place-to-belong/blob/preview/a1-village-market-pets/docs/world/review-a1-village-market/README.md)

## Cảnh đường làng và minimap A1

- Đường chính, ngõ và sân chung có mặt đá mòn, mạch đất và rêu nhẹ. Lớp lát theo địa hình hiện có, mờ dần ở mép cỏ và giữ hốc đường cũ. Mặt đá thay đổi khi ướt và khi có tuyết.
- Thêm chín cụm vật dụng quanh quầy mái vải, sân chung, khu thủ công, vườn và các hiên. Đồ trang trí dùng ba lô MultiMesh thường và một lô tuyết. Quầy, giá củi và ghế có collider riêng.
- Trời A1 dùng bảng xanh sáng hơn vào ban ngày, với mây trắng hai lớp chuyển theo hướng gió. Hệ giờ tự động vẫn chuyển ánh sáng và mây khi mưa hoặc về tối.
- La bàn góc trái dưới lấy địa hình, đường, cây và vị trí công trình từ A1. Mũi tên theo hướng nhìn của A. Giờ và thời tiết đọc trực tiếp từ game. **M** mở bản đồ lớn quanh A ở lần đầu, sau đó nhớ góc xem. Cuộn để đổi tỉ lệ, kéo để xem xa và **Home** để định tâm lại.
- Đã kiểm tuyến Chapter 01, các lối Làng A, bản đồ và HUD A1, thời tiết và smoke test. Ảnh duyệt lấy trong Godot 4.6.3 Compatibility. [Ảnh sân chung, quầy, đường làng, trời mưa và bản đồ](https://github.com/VietCodeBug/a-place-to-belong/blob/preview/a1-village-street-compass/docs/world/review-a1-village-street/README.md)

## Bản cập nhật nội thất Nhà A

Nhìn vào cốc, bát, bình gốm, ấm đồng, sách hoặc giỏ rồi nhấn **E** để nhặt. Có thể đi trong nhà khi đang cầm một món. Nhìn vào vị trí trống vừa kích thước món đồ trên bàn, kệ, tủ hoặc mặt bếp rồi nhấn **E** để đặt. **R** trả món đang cầm về chỗ vừa nhặt. Những món đã đặt giữ vị trí khi A ra sân rồi quay vào trong cùng lượt chơi. Nếu A ra cửa với món đang cầm, món đó trở về chỗ vừa nhặt.

Nhà có thêm vải dệt, kệ gốm, khu rửa với bồn và vòi đồng, thức ăn trên bàn và lò xây gạch đá. Cửa sổ, ngăn bếp và đèn là chi tiết cố định. Cửa chính và thao tác vuốt chăn vẫn phục vụ tuyến Chapter 01. [Ảnh Godot và video nhặt, cầm, đặt đồ](https://github.com/VietCodeBug/a-place-to-belong/blob/preview/a1-house-a-interior-props/docs/world/review-a1-house-a-interior/README.md)

## Bản Phase 3.1 trước cập nhật nội thất

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
