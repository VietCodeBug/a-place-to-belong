# A Place to Belong · Prototype Chapter 01

Phase 3 chạy trên A1 của `ab420bf`, diện tích 4.096 × 4.096 m. Tuyến thử bắt đầu ở Nhà A và tiếp tục qua rừng, Thomas, cầu và Làng A. Người chơi tự mở cửa và có thể đi qua Thomas hoặc bỏ qua dân làng. Hai hoạt động ở làng là lựa chọn.

```bash
godot --path . -- --story-prototype
```

Dùng **WASD** để đi, **Shift** để chạy nhẹ, **E** để dùng đồ hoặc nói chuyện, **M** để mở bản đồ ngoài trời và **Esc** để đóng thoại hoặc mở menu. Có thể bỏ qua đoạn thức dậy bằng **Esc**. Chế độ thử vào thẳng CH01-001. Office, Apartment, menu và lối vào A1 bình thường dùng các đường dẫn hiện có.

## Phần chơi được

| Hạng mục | Triển khai |
| --- | --- |
| Nhà A | Scene nội thất riêng trong `SubViewport` và `World3D` độc lập. Giường, bàn, cửa sổ và góc bếp có tương tác. Sàn, tường và đồ lớn có collider. Cửa đưa cùng một player sang hiên hoặc trở lại phòng. Đồng hồ và thời tiết ngoài trời tiếp tục chạy, ánh sáng và khung cảnh qua cửa sổ theo giờ, mưa và mùa. |
| Thomas | Giữ `VILLAGE.THOMAS` trên lối mòn. Thomas làm việc theo nhịp, ngừng quay sang chào khi A đến gần và trở lại công việc. Người chơi mở từng nhóm đã duyệt trong CH01-003. Các chủ đề đã nghe và vị trí đang đọc được lưu qua lần gặp. |
| Dân làng | 30 ID `VLA-01`–`VLA-30` theo roster, gồm 8 core, 10 supporting và 12 ambient. NPC có dữ liệu, phần hình khối thay được, tuyến đi, hoạt động và hội thoại riêng. Chỉ NPC gần A hoạt họa và nhận tương tác trực tiếp. NPC xa cập nhật vị trí logic theo tuyến đã tính, mỗi 0,24 giây. |
| Lịch ngày | Các trạng thái `IDLE`, `WALK`, `WORK`, `SOCIALIZE`, `REST`, `RETURN_HOME` và `TALK_TO_PLAYER`. Lưới waypoint 1 m được lọc qua collider, tránh dải hàng rào luống cây. NPC nhường bước nếu A đứng sát hướng đi. Một số cặp nói các câu chuyện đời thường từ dữ liệu DRAFT khi lịch và vị trí trùng nhau. |
| Hazel | Đề nghị giúp, lấy bình, tưới hai luống riêng, nhìn đất đổi màu rồi trả bình. Hazel phản hồi sau khi hoàn thành. |
| Owen | Đề nghị giúp, giữ miếng gỗ rồi chỉnh và thử chốt trên bàn. Chốt đổi tư thế và màu xác nhận. Owen phản hồi sau khi hoàn thành. |
| Trí nhớ theo phiên | Lưu cờ Chapter 01, ID nói chuyện, lần gặp lại, nhóm thoại đã nghe, tiến độ đọc, vật dụng và hai hoạt động. Việc chọn giúp hoặc lặp lại thoại không tự cộng tiến độ. Bản prototype chưa lưu qua lần thoát game. |

## Dữ liệu DRAFT

Runtime dùng `assets/story/chapter_01/runtime_snapshot.json` với ID và nội dung thoại sao từ [commit kịch bản e6fb16e](https://github.com/VietCodeBug/a-place-to-belong/commit/e6fb16e35984023ddce5fd751a372a99f7f9c5d9). Thoại giới thiệu Thomas và các chủ đề đã duyệt giữ nguyên. Câu gặp lại của Thomas là DRAFT bổ sung vì nguồn chưa có lời đã duyệt. Hazel và Owen tham chiếu các ID CH01-007 khi nhóm thoại chỉ tới lời cũ. Nội dung dân làng, lịch, hình khối NPC, các mô tả kiểm tra đồ gia dụng và ánh xạ nhà là mẫu để duyệt.

| Nhóm | Nhà DRAFT | Nhóm | Nhà DRAFT |
| --- | --- | --- | --- |
| H01 | A03 | H07 | A10 |
| H02 | A04 | H08 | A11 |
| H03 | A01 | H09 | A02 |
| H04 | A19 | H10 | A09 |
| H05 | A07 | H11 | A17 |
| H06 | A08 | | |

A05 là xưởng. A06 là nhà thờ. A12, A14, A15, A18, A21 là khu kho dự kiến. A20 dành cho sinh hoạt chung. A13 và A16 để trống công năng trong bản thử. Xem cả ánh xạ và điểm làm việc trong `assets/story/chapter_01/village_layout_draft.json`. Vị trí của 21 ngoại thất dùng nguyên layout A1.

## Phạm vi còn lại

Nội thất và diễn xuất dùng hình khối prototype. Các nhà dân chưa có interior. Lịch hiện ở mức công việc, nghỉ, đi lại và giao lưu. NPC chỉ có hoạt động tương tác thực ở Hazel và Owen. Nhánh này dựng các mốc CH01-001/002/003/006/007 để chơi thử. PRO-004, CH01-004/005 và các nhiệm vụ quan hệ Q1/Q2/QF nằm ngoài bản chơi này.

## File thay đổi

- `scenes/world/house_a_interior.tscn` và `scripts/story/prototype/house_a_interior.gd` dựng phòng và camera trong nhà.
- `scripts/story/prototype/chapter_01.gd`, `interaction.gd`, `session.gd` nối cửa, vị trí và trạng thái phiên.
- `scripts/story/prototype/npc_actor.gd`, `npc_visual.gd`, `village_population.gd` dựng người, lịch và đường đi.
- `scripts/story/prototype/conversation.gd`, `activities.gd` đọc thoại, làm việc và ghi nhớ.
- `scripts/world/forest_hub.gd`, `scripts/interactions/interaction_controller.gd` và `scripts/ui/wax_close_button.gd` thêm điểm vào Prototype, lựa chọn thoại và cách dùng chung UI.
- `tools/a1_story_walkthrough.gd`, `tools/benchmark_a1_story.gd`, `tests/chapter01_prototype_test.gd` quay tuyến thật, kiểm hồi quy và đối chiếu hiệu năng.

## Kiểm thử trong Godot

Năm bộ kiểm Godot đều đạt. Riêng lượt Chapter 01 đối chiếu thêm **642 đoạn đường** giữa các waypoint của dân làng với collider của A1.

| Lượt | Nội dung |
| --- | --- |
| `chapter01_prototype_test.gd` | Dùng controller đi hết vòng Nhà A → Thomas → Làng A → hai hoạt động → về nhà. Kiểm cả từ chối rồi nhận giúp, nói lại với Thomas, lời Hazel khi quay lại, đổi lịch về nhà, mở và đóng M, mưa trong nhà và ra/vào nhiều lần bằng cùng player. Kiểm đủ 30 người, 30 điểm làm việc khác nhau và các đường từ nhà đến chỗ làm hoặc giao lưu. |
| `a1_superworld_test.gd` | Kiểm hồi quy địa hình, collider, cầu nối chunk, hồ, lặn, mùa, mưa và M. |
| `village_a_test.gd -- --a1-superworld` | Kiểm tuyến Nhà A–Làng A, đường về và ngõ làng trên A1. |
| `smoke_test.gd` và `office_first_person_test.gd` | Kiểm đường chạy mặc định và phần điều khiển Office. |
| So khớp snapshot | 29 câu đã duyệt của Thomas, 30 hồ sơ, lời CH01-007 và ID thoại tham chiếu khớp nguồn. 11 nhóm cư trú trỏ đến 11 nhà ở DRAFT trong 21 công trình. |

### Hiệu năng ở Làng A

Godot 4.6.3 Compatibility, Mesa llvmpipe, 960 × 540. Cùng camera gameplay tại `(5,8; 128,6)` trên trục X/Z, trời quang lúc 10:18, 32 khung mẫu sau 40 khung chuẩn bị. FPS trong bảng quy đổi từ thời gian P50.

| Lượt | NPC gần A | Draw calls trung vị | P50 | P95 | FPS từ P50 |
| --- | ---: | ---: | ---: | ---: | ---: |
| Baseline `ab420bf` | 0 | 1.198 | 1.234,2 ms | 1.317,3 ms | 0,81 |
| Phase 3 trước gộp hình khối | 28 | 1.674 | 1.232,3 ms | 1.477,3 ms | 0,81 |
| Phase 3 sau gộp hình khối theo khớp | 28 | 1.419 | 1.252,6 ms | 1.474,2 ms | 0,80 |

Gộp các phần hình khối cùng khớp giảm **255 draw calls** trong lượt đo. P95 của bản sau vẫn cao hơn baseline **11,9%**. Máy thử dùng dựng hình phần mềm, chưa có benchmark GPU Windows.

## Ảnh và video

Video **1 phút 12,5 giây**, 640 × 360, 8 FPS, quay từ một lượt dùng controller và UI hiện có. Video giữ tốc độ chơi của những đoạn giữ lại và cắt bớt quãng chạy dài. Cảnh ngoài trời vẫn dùng camera gameplay. Cây hoặc mái có thể che camera ở một số góc, nhất là gần Thomas và bàn sửa. Hình khối, các lời DRAFT, bố cục nội thất, lịch sinh hoạt và ánh xạ hộ dân đang chờ người sáng tạo duyệt. [Ảnh trong Godot, video gameplay và mốc xem](https://github.com/VietCodeBug/a-place-to-belong/blob/preview/a1-story-prototype-phase3/docs/world/review-a1-story-prototype/README.md)
