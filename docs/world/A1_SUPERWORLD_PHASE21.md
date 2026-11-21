# A1 Superworld Phase 2.1 · Hồ, sinh cảnh và hiệu năng

Baseline của lượt review là `9396d41`. A1 vẫn rộng **4.096 × 4.096 m**. Hành lang Nhà A, cầu gỗ, 21 công trình Làng A, Chapter 01 và camera gameplay giữ nguyên. [PR #14 tiếp tục ở Draft.](https://github.com/VietCodeBug/a-place-to-belong/pull/14)

## Kết quả theo hạng mục

| Hạng mục | Kết quả |
| --- | --- |
| Bờ hồ | Chia bãi cát, bờ đá, bờ cỏ và lối cửa bến. Cây lá rộng, bạch dương, thông và bụi hoa bố trí theo cụm. Các mỏm đá bám cao độ terrain. Lối từ làng đi vòng đầu bến và giữ dốc xuống nước. |
| Mặt hồ | Dùng lưới nước đục ở phần sâu, dải trong ở vùng nông và mặt dưới mặt nước riêng cho camera lặn. Màu phản xạ bầu trời và sóng lấy theo góc nhìn và thời tiết. |
| Dưới hồ | Nét sáng đáy mảnh hơn, ít tương phản hơn, mờ theo khoảng cách và độ sâu. Vòm có các mặt gãy và vai đá nối xuống đáy. Cụm đá, rong và fog phân chia vùng nông, tầng giữa và lòng hồ sâu. |
| Rừng xa và cao nguyên | Dùng bốn hình học proxy, biến đổi tỷ lệ theo họ cây. Rừng xa mọc theo cụm, có khoảng thưa. Proxy ngoài tầm loại ở vertex trước raster. Terrain xa dùng vật liệu nhẹ hơn và vẫn nhận mưa, mùa. Thêm các lớp đá quanh điểm ngắm hiện có. |
| Đồng hoa | Giữ bốn mẫu hoa, tiết chế sắc xanh lam của cánh, xen các dải hoa với mảng cỏ thấp. Có thêm cây và đá tại lề và giữ khoảng hở đi bộ. |
| Trải nghiệm | Đi được Làng A → bờ tây → vùng nông → xuyên vòm → nổi lên → trở lại Làng A, dùng controller và camera gameplay. |
| Hiệu năng GPU Windows | Chưa đo. Máy hiện tại là Linux với Mesa llvmpipe và không có thiết bị GPU Windows đích. |

Đàn cá vẫn là cá cảnh theo nhóm. Mặt nước có phản xạ bầu trời theo mô hình thủ tục. Phản xạ trực tiếp hình cây, địa hình và công trình trên bờ còn thiếu. Vòm, terrain, cầu và bến có collider theo tuyến. Đá trang trí nhỏ, cây và rong chủ yếu phục vụ cảnh quan. Mỹ thuật vẫn chờ duyệt.

Trong lượt quay, một cạnh của vòm che người chơi thoáng qua khi camera bám sau lưng, khoảng 3:16. Collider vẫn cho người chơi bơi xuyên vòm và trở lại mặt nước. Tư thế nhân vật khi bơi là tư thế sẵn có của prototype.

## Hiệu năng ở bờ tây

Godot 4.6.3 Compatibility, Mesa 25.0.7 llvmpipe, 960 × 540, VSync tắt. Cùng camera gameplay tại X/Z `(214, −466)`, trời quang lúc 13:48. Lấy 32 khung mẫu sau 28 khung khởi động. FPS dưới đây quy đổi từ frame time P50.

| Lượt | P50 | P95 | FPS quy đổi tại P50 | Draw calls trung vị | Primitive gửi trung vị | Instance Superworld đăng ký | Vật liệu override Superworld |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| Baseline `9396d41`, đo lại | 329,1 ms | 373,2 ms | 3,04 | 519 | — | — | — |
| Phase 2.1 trước tối ưu rừng xa | 467,9 ms | 514,5 ms | 2,14 | 560 | 1.085.354 | 22.000 | 44 |
| Phase 2.1 sau tối ưu rừng xa | 443,8 ms | 470,6 ms | 2,25 | 556 | 893.680 | 16.605 | 45 |

P95 giảm **8,5%** sau khi thu vùng chồng giữa LOD trung và xa, giới hạn mật độ ở các cụm rừng dày và chuyển panorama sang một vật liệu dùng chung nhẹ hơn. Lượt cuối giảm khoảng 18% primitive gửi và 25% instance đăng ký so với lúc mới đưa vào. Số instance là tổng đã đăng ký ở Superworld, gồm cả nhóm nằm ngoài góc nhìn. P95 lượt cuối vẫn cao hơn baseline **26,1%**. Mốc hiệu năng trước khi duyệt còn thiếu.

Ở bản trước tối ưu, ẩn nước giảm 2 draw calls (560 → 558). P95 lượt ẩn nước dao động lên 540,2 ms, nên phép đo này chưa tách được chi phí vùng nước trong. Cắt raster của proxy qua shader cho P95 494,3 ms và giữ nguyên 560 draw calls. Các phép tắt là kiểm tra độ nhạy, chưa định lượng được riêng thời gian GPU của từng nhóm. Lượt cuối đổi từ một mặt hồ trong suốt thành vùng nước sâu đục và dải ven bờ trong. Caustics chỉ chạy dưới vùng nước nông đã giới hạn khoảng cách.

### Streaming và kiểm thử

Lượt cuối đi qua 11 chunk mốc giữa hồ và làng. Chi phí CPU của các khung có dựng terrain/collider là **P95 4,63 ms**, đỉnh **5,78 ms** với 133 mẫu. Công việc trang trí ghi **P95 3,79 ms**, đỉnh **4,53 ms** với 1.173 mẫu. Các số này đo riêng CPU khi chạy headless. Đỉnh trong một lượt chạy trước lần tối ưu cuối, có tác vụ quay ảnh cùng lúc, lên 24,32 ms và 28,52 ms. Vẫn cần đo khung hình và hitch khi chạy nhanh trên GPU đích.

| Điều kiện | Kết quả |
| --- | --- |
| Mép chunk, collider khớp terrain, collider vòm và đáy hồ | Đạt qua kiểm thử Godot |
| Bơi, lặn, nổi, xóa hiệu ứng dưới nước khi lên bờ | Đạt qua kiểm thử Godot |
| Tuyến Nhà A → Làng A, các ngõ làng, hai vòng khám phá và đường lên cao nguyên | Đạt qua kiểm thử Godot |
| Mùa đông, mưa, bản đồ M, lớp chunk F7 và atlas | Đạt qua kiểm thử Godot |
| Chế độ chơi mặc định | Đạt smoke test, 13 tình huống |
| Hiệu năng GPU mục tiêu và duyệt mỹ thuật | Đang chờ |

## Ảnh và video

- [Ảnh Godot Full HD và bốn cặp trước/sau](https://github.com/VietCodeBug/a-place-to-belong/blob/preview/a1-superworld-phase21/docs/world/review-a1-superworld-phase21/README.md)
- Video dài **6:42,5**, ghi liền mạch từ Làng A đến hồ, bơi, lặn qua vòm và trở lại. Bản ghi 576 × 324, 8 FPS, tốc độ chơi bình thường. [Mở video MP4](https://raw.githubusercontent.com/VietCodeBug/a-place-to-belong/refs/tags/preview/a1-superworld-phase21-video/docs/world/review-a1-superworld-phase21/lang-a-ho-va-quay-lai.mp4) · [Mốc xem và nhật ký Godot](https://github.com/VietCodeBug/a-place-to-belong/blob/preview/a1-superworld-phase21-video/docs/world/review-a1-superworld-phase21/README.md)

## Phương pháp kiểm

- Ảnh 1.920 × 1.080 chụp trực tiếp trong Godot 4.6.3 Compatibility. Bốn cặp dùng cùng điểm đặt và điểm ngắm của camera theo tọa độ X/Y/Z ở Phase 2, FOV 59° và cùng giờ 14:39.
- `tests/a1_superworld_test.gd` kiểm nối mép chunk, collider đáy và vòm, bơi/lặn/nổi, đường vòng, leo cao nguyên, mùa đông, mưa và bản đồ M. Các lượt chạy đi nhanh lấy mẫu thời gian CPU của dựng terrain/collider và công việc cây cỏ.
- `tests/village_a_test.gd -- --a1-superworld` kiểm đi–về qua hành lang cũ và bốn lối làng. `tests/smoke_test.gd` kiểm chế độ mặc định.
- `tests/imported_assets_test.gd` chạy với màn hình Linux và hoàn tất không lỗi. `tools/verify_vendor_assets.py` xác minh lại các GLB gốc Kenney và Quaternius.
- `tools/capture_a1_lake_roundtrip.gd` chạy cùng tuyến kiểm thực tế. Đặt người chơi ở lối ra làng một lần đầu, sau đó dùng input bình thường suốt đường đi, bơi và đường về. Godot Movie Maker ghi bước thời gian cố định. Bản ghi dùng giảm bóng và SSAO để ghi trên Mesa.
- Hai thông báo texture OpenGL 349.524 byte khi thoát đã xuất hiện trên baseline lẫn bản sau.

## Chạy lại

`godot --path . -- --a1-superworld --no-title`

Trên máy Windows dùng cùng GPU, driver, màn hình, cấu hình nguồn điện và Godot khi chạy baseline/candidate. So sánh cùng độ phân giải. Script có tùy chọn `--1080p` ở cả hai phiên bản nếu dùng bộ đo được bàn giao sang bản baseline.

`godot --path . --audio-driver Dummy --script tools/benchmark_a1_superworld.gd -- --lake`

Tùy chọn `--hide-water` bỏ mặt nước trong phép đo chẩn đoán. Tùy chọn `--hide-forest-proxy` đẩy proxy ra khỏi vùng raster qua shader trong phép đo. Lượt này vẫn giữ các lệnh vẽ proxy, nên nó đo mức nhạy với raster và shader, không tách toàn bộ chi phí cây.
