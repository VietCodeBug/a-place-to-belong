# Làng A · Quy hoạch thử trong Map 2

Đối chiếu nhánh story tại 8ce4d96 với village-a, village-a-roster, CH01-006/007 và environment-scenes-v0. Khoảng 30 là quy mô cộng đồng dự kiến. 11 nhóm cư trú là bản nháp. Mô hình này bố trí ngoại thất và không xác lập hộ, nghề, NPC hay chức năng kịch bản mới.

| Dải tọa độ z | Bố cục |
| --- | --- |
| 10–19 | Nhà A trong khoảng rừng khởi đầu, tách khỏi khu dân cư. |
| 24–83 | Tuyến rừng và cầu qua sông. |
| 86–103 | Đường tới làng có cụm cây và gò che bớt các sân phía sau. Một vài mái lộ qua tán trước khi tới làng. |
| 104–119 | Hai cụm cửa làng và vườn chung phía tây. |
| 120–143 | Sân chung giữa làng, gian thủ công ở phía đông, nhà quây theo các nhánh. |
| 144–183 | Hai cụm nhà sau làng và lối mòn nối rừng. |

Tọa độ dùng trực tiếp trong Godot nằm trong village_a_layout.gd. Mã công trình là mã dựng thử. Bố cục có đường hai chiều giữa Nhà A, cầu, làng và rừng sau làng.

## Công trình dựng trong Godot

| Lô | Nhóm kiến trúc | X, Z (m) |
| --- | --- | --- |
| A01 | Nhà có hiên sâu, cửa làng phía tây | −6.9, 107.4 |
| A02 | Nhà đầu hồi dốc, cửa làng phía đông | 11.2, 108.4 |
| A03 | Nhà dài, sát khu vườn | −14, 116.5 |
| A04 | Cottage mái gỗ, mé đông | 16.2, 118.6 |
| A05 | Gian thủ công có mái che, sân để xe gỗ và vật liệu | 21.8, 128.1 |
| A06 | Nhà sinh hoạt chung, tầm nhìn từ đường dốc | −3.6, 133.2 |
| A07 | Nhà đầu hồi dốc, ngõ đông | 16.9, 139.6 |
| A08 | Nhà có hiên sâu, ngõ tây | −13, 141.2 |
| A09 | Nhà dài, cụm sau | −8.4, 153.4 |
| A10 | Cottage mái gỗ, cụm sau | 13.5, 153.6 |
| A11 | Nhà có hiên sâu, sát đường ra rừng | 18, 162.4 |

Nhà A đặt riêng tại (13.1, 13.7), có đường nối hiên vào trục khám phá. Vườn chung ở (−7.8, 120), sân sinh hoạt ở (5.2, 128) và sân thủ công ở (16.1, 128.1). Bốn ngõ nối trở lại trục chính. Rặng cây và gò trước z=100 che bớt nhà phía sau. [Quy hoạch nhìn từ trên cao trong Godot](review-village-a/quy-hoach.png)

## Nguồn kiến trúc

- Năm model mới do dự án dựng và dùng trong Godot gồm [porch.glb](../../assets/village_a/porch.glb), [gable.glb](../../assets/village_a/gable.glb), [long.glb](../../assets/village_a/long.glb), [craft.glb](../../assets/village_a/craft.glb) và [hall.glb](../../assets/village_a/hall.glb). Mỗi thiết kế có khối nhà, dáng mái, chi tiết cửa và hiên riêng, dùng chung ván, ngói, đá, khung cửa và vật liệu.
- [Source Blender chung](../../art_source/village_a/village_a_exteriors.blend) và [script tạo lại 5 GLB](../../art_source/village_a/build_village.py). Dựng lại bằng `blender -b --python-exit-code 1 --python art_source/village_a/build_village.py`.
- [Cottage hewn có sẵn](../../assets/a1_house_gate/hewn_eaves_cottage.glb) đóng vai Nhà A và hai lô phụ trong làng, dùng lại nguyên GLB và [source Blender cũ](../../art_source/a1_house_gate/hewn_eaves_cottage.blend). Cây, đèn và đạo cụ phụ lấy từ các gói [vendor sẵn trong dự án](../../assets/vendor). Cây theo mùa, nền, đường, hàng rào sân và thảm ven đường được lắp trong Godot.

[Ảnh, video, kiểm thử và thông số hiệu năng](review-village-a/README.md)
