# A1 Superworld Phase 2

Bản review tiếp tục trên PR nháp #14. Vùng A1 vẫn là **4.096 × 4.096 m**. Nhà A, cầu, 21 công trình Làng A, tuyến Chapter 01, camera và hành vi gameplay ở chế độ mặc định giữ nguyên. Các thay đổi ngoại cảnh dưới đây chạy trong chế độ Superworld.

## Đã thực hiện

| Hạng mục | Thay đổi |
| --- | --- |
| Phủ sinh cảnh toàn vùng | Phân sinh cảnh theo địa hình, độ cao, độ ẩm gần hồ và mật độ rừng. Rừng sâu, sườn lá kim, thung lũng lá rộng, đồng hoa, khoảng thoáng, bờ nước và cao nguyên có tông màu và mật độ riêng. Sáu mẫu cây thuộc bốn họ dùng từ thư viện A1, với tán chi tiết gần, proxy theo chunk ở trung cảnh và cụm rừng proxy toàn vùng ở xa. |
| Đồng cỏ hoa | Đồi thấp nối tiếp, cỏ lá cong, bốn mẫu hoa có chiều cao và mật độ khác nhau, cây lẻ và cụm cây. Mặt cỏ gợn theo dải hoa. Lối mòn giữ khoảng hở. |
| Cao nguyên | Các khối núi không đối xứng, vân đá theo mặt dốc, cụm đá và bụi trên sườn, mở một khoảng nhìn từ điểm dừng cao nguyên hướng về bờ phía xa của hồ. |
| Hồ | Bờ có mũi đất, vịnh nông và lối xuống phía tây. Bến ván có đường ghép, dầm đỡ và cọc. Mặt hồ mô phỏng phản xạ bầu trời theo góc nhìn và có sóng nhỏ. Nước nông thấy đáy cát và caustics mảnh. Giữa hồ sâu hơn với nền đáy gợn. Rong chuyển động, có đá, rễ chìm và ba nhóm cá cảnh ở các tầng khác nhau. Vòm gồ ghề có collider và giữ lối bơi xuyên. |
| Tuyến khám phá | Thêm đường vòng qua sườn đồng cỏ và một đường vòng trong rừng phía tây hồ, có bốn điểm dừng nghỉ giữa các tuyến và trên cao nguyên. Các tuyến hiện trên M, điểm dừng hiện khi phóng to. |
| Rừng và sông | Thêm tán già, rễ nổi và đá ở khoảng rừng cũ. Bờ sông có đá và cỏ, ánh nước dùng bảng màu riêng của Superworld. Cây cầu giữ nguyên. |

Cảnh được xây bằng terrain, mesh và shader chạy trong Godot 4.6.3 Compatibility. Các cây, hoa, bụi và đá tái sử dụng asset trong repository. Cỏ, nước, thực vật thủy sinh và hình học vòm dùng source thủ tục trong PR.

## Kiểm thử

- `tests/a1_superworld_test.gd` kiểm collider ngay hai phía seam, dưới giữa hồ và vòm đá, vị trí Nhà A và từng lô làng, vào nước–lặn–nổi–lên bờ, hai đường vòng, đường hồ–làng, leo cao nguyên, mùa đông, thời tiết mưa và thao tác M, F7, Tab.
- `tests/village_a_test.gd -- --a1-superworld` kiểm tuyến cũ từ Nhà A tới cuối làng, chiều về và bốn đường nhánh.
- `tests/smoke_test.gd` kiểm chế độ mặc định.
- Chụp sáu khu trong Godot. Các cặp đồng hoa, cao nguyên, bờ hồ và lòng hồ dùng cùng tọa độ X/Z, điểm ngắm trên mặt bằng, FOV 59° và giờ 14:39. Camera đặt theo tầm mắt tính từ bề mặt terrain từng bản. Phần thay đổi khí quyển là một phần của bản dựng.

## Đang ở mức thử nghiệm

- Cá hiện là đàn cảnh dùng quỹ đạo theo nhóm. Vòng đời, AI hệ sinh thái và loài câu được để sau. Mặt nước mô phỏng màu bầu trời và ánh lóe theo góc nhìn. Phản xạ trực tiếp cây và vật thể trên bờ còn thiếu.
- Rừng xa sử dụng ít silhouette hơn rừng gần. Mùa đông áp dụng tông tuyết ở xa và bỏ tán lá rộng ở lớp chi tiết gần. Độ dày tuyết, biến đổi nước đóng băng và chi tiết sinh cảnh mùa đông còn để duyệt.
- Chất lượng nghệ thuật các bờ xa, rừng già, đồng hoa và dưới hồ còn cần duyệt trong game. Va chạm được kiểm ở terrain, cầu, bến và vòm theo tuyến. Cây, cỏ và đá trang trí nhỏ chủ yếu là lớp cảnh quan.
- Phần câu cá, nội dung khám phá mới, thiết kế quest và benchmark GPU đích Windows chưa nằm trong bản dựng đã kiểm.

## Chạy và xem ảnh

`godot --path . -- --a1-superworld --no-title`

`godot --path . --script tools/capture_a1_phase2.gd -- /tmp/a1-phase2-review --six`

[Ảnh trước–sau và sáu khu Godot](https://github.com/VietCodeBug/a-place-to-belong/blob/preview/a1-superworld-phase2/docs/world/review-a1-superworld-phase2/README.md) · [PR nháp #14](https://github.com/VietCodeBug/a-place-to-belong/pull/14)

## Hiệu năng

Kết quả benchmark bờ tây dùng cùng script, tầm nhìn, Godot 4.6.3 Compatibility, Mesa llvmpipe và độ phân giải 960 × 540. Lấy 32 frame sau 28 frame làm nóng.

| Bản | Frame P50 | Frame P95 | Draw calls trung vị | Bộ nhớ render Godot |
| --- | ---: | ---: | ---: | ---: |
| Phase 1 | 235,7 ms | 264,4 ms | 300 | 346,7 MiB |
| Phase 2 trước gộp đá | 336,4 ms | 362,6 ms | 775 | 349,4 MiB |
| Phase 2 bàn giao | 354,3 ms | 407,8 ms | 519 | 350,8 MiB |

Batch các đá tĩnh cùng vật liệu theo ô 28 m giảm draw calls trong cảnh Phase 2. Chi phí dựng hình trên llvmpipe của bản bàn giao vẫn cao hơn Phase 1. Phép đo phần mềm không dự báo FPS GPU đích. Hai cảnh báo texture khi thoát Compatibility xuất hiện cả ở ảnh baseline lẫn ảnh Phase 2.

Terrain/collider được xử lý trước phần cây cỏ. Mỗi lượt trang trí cỏ, hoa chạy theo một phần tư chunk và nạp dần một việc mỗi frame. Hai loại việc được đo riêng trong bài kiểm thử di chuyển.

| Việc trong lượt QA cuối | Mẫu | CPU P50 | CPU P95 | Đỉnh |
| --- | ---: | ---: | ---: | ---: |
| Terrain và collider | 125 frame | 2,93 ms | 3,96 ms | 5,86 ms |
| Công việc trang trí sinh cảnh | 1.173 lượt | 0,55 ms | 3,71 ms | 6,90 ms |

Lượt QA đi bộ Phase 2 gồm cả hai đường vòng mới, nên tập frame khác số mẫu ở Phase 1. Kết quả hồi quy tuyến cũ và chế độ mặc định đạt. Bài kiểm gần bờ hồ, giữa hồ, đường xuyên vòm, hành lang làng và cao nguyên đạt. Toàn bộ 16,78 km² còn cần kiểm theo vùng khi phát triển nội dung.
