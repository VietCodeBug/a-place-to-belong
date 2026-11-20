# Danh mục cây A1 · Village A V3

20 dáng từ bốn nhóm model Quaternius. Tên nhóm dựa trên asset, như `NormalTree` là nhóm cây lá rộng chưa định loài. Mỗi số là một GLB có hình học riêng. Ảnh gallery theo hàng từ trước ra sau là bạch dương, phong, lá rộng tán lớn và thông.

| ID | Tên mẫu | Habitat | Chiều cao đặt mẫu | Tam giác | Vật liệu | Trạng thái |
| --- | --- | --- | --- | ---: | ---: | --- |
| BirchTree_1 | Bạch dương 1 | bìa rừng, sườn ẩm | 7–12 m | 6,508 | 2 | Adapted |
| BirchTree_2 | Bạch dương 2 | bìa rừng, sườn ẩm | 7–12 m | 9,856 | 2 | Adapted |
| BirchTree_3 | Bạch dương 3 | bìa rừng, sườn ẩm | 7–12 m | 10,956 | 2 | Adapted |
| BirchTree_4 | Bạch dương 4 | bìa rừng, sườn ẩm | 7–12 m | 4,660 | 2 | Adapted |
| BirchTree_5 | Bạch dương 5 | bìa rừng, sườn ẩm | 7–12 m | 5,984 | 2 | Adapted |
| MapleTree_1 | Phong 1 | ven đường, vườn | 7–10 m | 3,848 | 2 | Adapted |
| MapleTree_2 | Phong 2 | ven đường, vườn | 7–10 m | 4,800 | 2 | Adapted |
| MapleTree_3 | Phong 3 | ven đường, vườn | 7–10 m | 6,678 | 2 | Adapted |
| MapleTree_4 | Phong 4 | ven đường, vườn | 7–10 m | 1,256 | 2 | Adapted |
| MapleTree_5 | Phong 5 | ven đường, vườn | 7–10 m | 4,504 | 2 | Adapted |
| NormalTree_1 | Lá rộng tán lớn 1 | bóng mát trong làng, rìa rừng | 6–13 m | 12,248 | 2 | Adapted |
| NormalTree_2 | Lá rộng tán lớn 2 | bóng mát trong làng, rìa rừng | 6–13 m | 10,824 | 2 | Adapted |
| NormalTree_3 | Lá rộng tán lớn 3 | bóng mát trong làng, rìa rừng | 6–13 m | 9,264 | 2 | Adapted |
| NormalTree_4 | Lá rộng tán lớn 4 | bóng mát trong làng, rìa rừng | 6–13 m | 9,148 | 2 | Adapted |
| NormalTree_5 | Lá rộng tán lớn 5 | bóng mát trong làng, rìa rừng | 6–13 m | 3,004 | 2 | Adapted |
| PineTree_1 | Thông 1 | sườn đồi, hậu cảnh | 7–14 m | 2,760 | 2 | Adapted |
| PineTree_2 | Thông 2 | sườn đồi, hậu cảnh | 7–14 m | 3,832 | 2 | Adapted |
| PineTree_3 | Thông 3 | sườn đồi, hậu cảnh | 7–14 m | 2,500 | 2 | Adapted |
| PineTree_4 | Thông 4 | sườn đồi, hậu cảnh | 7–14 m | 3,708 | 2 | Adapted |
| PineTree_5 | Thông 5 | sườn đồi, hậu cảnh | 7–14 m | 1,540 | 2 | Adapted |

Quaternius là tác giả các model, cấp phép CC0-1.0. Lấy FBX và texture từ một mirror commit cố định, kiểm Git blob cho từng file. Giấy phép MIT của repo mirror áp dụng cho mã của mirror. Danh mục lưu SHA-256 đầu vào, GLB và texture đã điều chỉnh. [Trang nguồn](https://quaternius.com/packs/ultimatestylizednature.html) · [Giấy phép CC0](../../art_source/vegetation/trees/CC0-1.0.txt) · [Danh sách hash và đường dẫn](../../art_source/vegetation/trees/provenance.json)

Đã đối chiếu [MegaKit](https://quaternius.com/packs/stylizednaturemegakit.html), [Stylized Tree Pack](https://quaternius.com/packs/stylizedtree.html), [Kenney Nature Kit](https://kenney.nl/assets/nature-kit) và [Poly Pizza Nature](https://poly.pizza/explore/Nature). Chọn một pack nhập mới để giữ thân, lá và vật liệu chung. Đá, bụi, cỏ và hoa nhập thêm gồm Rock_4, Bush_Large, Grass_Large_Extruded và Flower_4_Clump.

Blender chia thân và tán theo vật liệu, sửa trục đứng từng nhóm, xuất lại GLB, giữ UV và normals nhập. Godot chuẩn hóa mốc chân và chiều cao, texture dùng mipmaps và lọc anisotropic. Tán bạch dương, phong và cây lá rộng dùng texture alpha scissor, chung thân qua bốn mùa. Mùa đông ẩn tán cây rụng lá, thông đổi sắc lạnh. Giới hạn tầm nhìn cho cụm rừng là 108 m. Các model cây chưa có mesh LOD riêng hay đánh giá duyệt mỹ thuật.

[Gallery Godot](review-village-a-v3/cay-gallery.png) · [Cận tán](review-village-a-v3/cay-can.png) · [Nhìn ngang](review-village-a-v3/cay-ben.png) · [Thu](review-village-a-v3/cay-thu.png) · [Đông](review-village-a-v3/cay-dong.png).
