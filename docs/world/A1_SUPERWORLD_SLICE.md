# A1 Superworld · Nền tảng prototype trong game

## Phương án tích hợp

- Giữ hệ trục game 1 đơn vị = 1 m. Nhà A (16, −338), cầu (0, 74), sân chung Làng A (5,2; 128), toàn bộ 21 lô và tuyến Chapter 01 lấy trực tiếp từ game tại `9cf0f45`. Tọa độ standalone phục vụ thử nghiệm riêng.
- Chế độ review `--a1-superworld` nối vòng terrain mới vào khối địa hình cũ từ X −64 đến +64, Z −384 đến +192. Hiệu chỉnh mẫu sát mép ngoài khối để lưới 2 m cũ khớp lưới 8 m của các chunk. Giữ mẫu cao độ trong vùng có nội dung đã dựng.
- Terrain A1 rộng 4.096 × 4.096 m, chia chunk 64 m. Lưới panorama phủ tầm nhìn. Mesh và collider chi tiết được tạo khi người chơi đến gần, có giới hạn tạo mỗi frame và giải phóng collider khi rời xa. Các vùng B–I nằm trong registry ở trạng thái dự trữ.
- Hồ thử nghiệm đặt phía đông rừng, tâm (650, −455) với bán trục 430 × 310 m. Hai lối mòn nối vùng bờ hồ với rừng và làng. Có bến, dốc vào/ra nước, gờ cạn, lòng hồ trũng và một cụm đá để lặn tới. Vị trí và tên hiển thị là dữ liệu review.
- Tái sử dụng nhân vật, camera góc ba, điều khiển trên cạn và M-map đang có. Bơi theo WASD, Space nổi, Ctrl lặn. Map M dùng cùng hàm terrain, thể hiện vị trí, vùng đã đi và lớp chunk runtime.

## Sáu khu để duyệt

| Khu | Mốc game X / Z | Lát cắt đang chơi được |
| --- | --- | --- |
| Rừng cổ thụ | 5 / −320 | Đoạn đường quanh Nhà A và rừng sâu. Dùng cụm cây, đá, cỏ, hoa và động vật hiện có |
| Đồng cỏ hoa | 330 / 138 | Đồi thoải, nhánh đi vòng và các mảng hoa nhỏ theo mùa. Cây tản ở rìa đồng |
| Sông và cầu | 0 / 74 | Tuyến qua cầu gỗ hiện có. Lòng sông, nước nông và bờ thuộc terrain gốc |
| Làng A | 5,2 / 128 | Cả 21 công trình, sân, vườn rau, đường làng và lối ra kết nối nhánh hồ |
| Cao nguyên | 270 / −825 | Đường lên cao độ khoảng 61 m và góc nhìn về hồ |
| Dưới lòng hồ | 305 / −471 | Gờ đá, vòm có collider, rong, ánh nước động và đàn cá minh họa. Giữa hồ sâu khoảng 30 m |

Các mốc mới dùng cho bố cục thử nghiệm. Hình tham chiếu sáu khu định hướng mỹ thuật. Ảnh review lấy từ cảnh 3D Godot. [Tài liệu tham chiếu](A1_VISUAL_BIOME_PREVIEWS_V1.md)

## Chạy thử

Ở thư mục gốc của game chạy `godot --path . -- --a1-superworld --no-title`. Bấm **M** mở bản đồ, kéo chuột và cuộn để khảo sát, **Home** định tâm, **F7** hiện ô terrain và collider, **Tab** mở registry. Dùng WASD để đi hoặc bơi, giữ **Ctrl** để lặn, **Space** để nổi. Bản đồ ghi vùng đã đi trong phiên.

Project độc lập chạy bằng `godot --path prototypes/a1_superworld/standalone`. Hai project có chế độ khởi chạy riêng.

## Kiểm thử

- `godot --headless --path . --disable-render-loop --fixed-fps 60 --script tests/a1_superworld_test.gd` kiểm tọa độ Nhà A và từng lô, mẫu độ cao tại hai phía ranh giới, collider đáy hồ và vòm đá, quãng bơi/lặn/nổi, đường về làng, đường đồng hoa và cao nguyên, mùa đông, khám phá M và registry.
- `godot --headless --path . --disable-render-loop --fixed-fps 60 --script tests/village_a_test.gd -- --a1-superworld` đi–về tuyến Nhà A, cầu, làng và bốn đường nhánh gốc.
- `godot --headless --path . --disable-render-loop --fixed-fps 60 --script tests/smoke_test.gd` kiểm game ở chế độ mặc định.

## Phạm vi địa hình

Lưới toàn cảnh 32 m tạo phủ 16,78 km². Địa hình chi tiết 8 m được nạp theo vị trí trên lưới chunk 64 m. Tối đa 25 chunk ngoài hành lang có collision gần người chơi cùng lúc, bên cạnh collider liền của hành lang gốc. Một tuyến đi–về giữa làng và hồ đi qua 11 chunk mốc. Các phép thử bổ sung kiểm biên A1, điểm cao nguyên, đồng cỏ và hai khu dưới nước. Phần diện tích còn lại chưa được đi rà soát từng mét.

## Công việc còn thiếu

- Polish đồ họa theo sáu concept. Ưu tiên rễ, rêu, dương xỉ và ánh xuyên tán trong rừng, mật độ hoa ở đồng, nền núi và chiều sâu cảnh quan, vật liệu nước và rong gần bờ.
- Animation bơi riêng cho nhân vật hiện có. Prototype hiện dùng tư thế tạm và chuyển động qua vật lý.
- Save khám phá qua nhiều phiên và tính năng câu cá, hệ sinh thái cá, oxy hay nhiệm vụ dưới nước. B–I tiếp tục ở trạng thái dự trữ.
- Chạy benchmark và kiểm tra bằng GPU đích trên Windows trước khi tích hợp vào bản phát hành.

## File chính

- [Registry](../../assets/world/superworld_regions.json) và [terrain, streaming, hồ](../../scripts/world/superworld/)
- [Bản đồ M](../../scripts/ui/a1_superworld_map.gd), [ghép hành lang cũ](../../scripts/world/landscape.gd), [camera](../../scripts/player/follow_camera.gd)
- [Test](../../tests/a1_superworld_test.gd), [công cụ quay](../../tools/capture_a1_superworld.gd), [benchmark](../../tools/benchmark_a1_superworld.gd)

## Kết quả hiệu năng

Godot 4.6.3 Compatibility trên Linux với Mesa llvmpipe, cảnh 960 × 540, thời tiết quang, giờ cố định 13:48. Mỗi lượt bỏ 28 frame đầu và lấy 32 frame liên tiếp. Các lượt Nhà A dùng cùng camera. Đây là phép đo dựng hình bằng phần mềm và bao gồm chi phí chờ của frame.

| Điểm đo | P50 frame | P95 frame | Draw calls trung vị | RAM tĩnh Godot | Bộ nhớ render Godot |
| --- | ---: | ---: | ---: | ---: | ---: |
| Nhà A, hành lang cũ | 1.996,6 ms | 2.201,5 ms | 687 | 125,2 MiB | 344,2 MiB |
| Nhà A, bật Superworld | 1.793,5 ms | 2.015,4 ms | 741 | 135,2 MiB | 346,7 MiB |
| Bờ tây hồ, bật Superworld | 235,7 ms | 264,4 ms | 300 | 135,3 MiB | 346,7 MiB |

Lượt đo riêng trong test đi bộ thu được 93 frame thực hiện tạo hoặc nâng cấp chunk. Chi phí CPU của lượt streaming có trung vị 2,87 ms, P95 5,40 ms và đỉnh 25,84 ms. Khi dừng ở cao nguyên, có 99 mesh gần tính cả vùng giữ đệm, 25 collider chunk và 64 mesh toàn cảnh. Hành lang cũ giữ collider riêng. Khác biệt view và LOD giữa các địa điểm ảnh hưởng mạnh tới các số đo. Cấu hình llvmpipe không đủ cho tốc độ chơi thường và chưa xác nhận hiệu năng trên Windows.

Log đồ họa có hai cảnh báo texture lúc tắt Godot ở cả lượt hành lang cũ và Superworld. Các phép thử cảnh, physics và UI kết thúc thành công.

## Ảnh và video

[Xem sáu khu, bản đồ M trước–sau, lớp collider F7 và video đi bộ, bơi, lặn](https://github.com/VietCodeBug/a-place-to-belong/blob/preview/a1-superworld-slice/docs/world/review-a1-superworld/README.md)
