# Thế giới dưới hồ A1

Khu hồ phía tây là tuyến khám phá yên tĩnh với nước xanh ngọc ở gờ nông, chuyển sang xanh lam theo độ sâu. Đá tảng chia đường bơi thành từng đoạn. Rong, đàn cá và ánh sáng thay đổi dần khi từ bến xuống di tích và vườn.

## Bố cục sáu khu

| Khu | Tọa độ X, Z | Trải nghiệm |
| --- | --- | --- |
| Lối xuống hồ | `234, -455` | Vào nước từ bến tây, nhận ra lối bằng đá tảng hai bên và ít bọt nhỏ. |
| Đồng cỏ nước | `267, -457` | Gờ cát sáng có rong thấp và một đàn 20 cá nhỏ. |
| Đường đá chìm | `286, -470` | Đi theo những phiến đá mòn xuống vòm đá tự nhiên rồi tới đình. |
| Đình đá chìm | `336, -456` | Mái vòm vỡ, sân lát, tượng mòn và chuông chìm. |
| Vườn ánh sáng | `363, -428` | Hoa ngà xếp nhiều lớp, hoa chuông lam rủ và chùm nụ phớt hồng. Ở chân hoa là cụm lá thấp, nhụy và mép cánh phát sáng dịu. |
| Phòng kín | Gần vườn ánh sáng | Lối cửa đá dưới vách, mở khi rung chuông ở đình. Bên trong có mảnh gốm để nhặt bằng `E`. |

Tuyến chính nối bến, gờ rong, đường đá và đình với vườn. Hai đường nhánh đi từ đình tới **Hành lang cột**, và từ mép vườn qua **Cổng bậc đá** tới **Tháp vỡ**. Mở `M` rồi phóng gần hồ để thấy tuyến bơi nét đứt. Các khe vực vẫn có dòng chảy giới hạn lặn tại chỗ.

## Ánh sáng và chuyển động

- Bảng màu nước dùng `#8DE3E8` ở vùng sáng, `#42B8D1` tầng giữa, `#1E6F95` tầng sâu, `#144D68` vùng tối và `#D8FFF8` ở đầu cánh hoa.
- Fog màu lam thay đổi theo độ sâu và mưa. Tia sáng rõ nhất khi trời sáng và quang. Ánh gợn chuyển động trên đá và cát, giảm dần theo độ sâu. Bọt chỉ tập trung quanh gờ vào và vườn.
- Bốn đàn cá thường xuất hiện như trước. Từ **16:30 đến trước 18:30**, trời quang, vườn lên ánh và có thêm đàn bảy cá ánh ngọc. Mưa che đàn này.
- Có thể đọc mốc nước yên trên bến. Chuông và mảnh gốm dùng luồng tương tác `E` sẵn có. Trạng thái cửa và mảnh gốm theo phiên chơi. Câu cá và nội dung ký ức sâu hơn dành cho đợt tiếp theo.

## Asset và giấy phép

| Asset trong cảnh | Nguồn và cách dùng |
| --- | --- |
| Ba mesh cá | Quaternius Animated Fish Pack, CC0. Bản GLB dùng vertex color, nhóm cá ánh ngọc đổi màu trong shader. [Nguồn tác giả](https://quaternius.com/packs/animatedfish.html) · [File và giấy phép trong repo](../../assets/vendor/quaternius/fish/README.md) |
| Đá gờ, đá vườn, mái đá phòng kín | Dùng lại `split_boulder.glb` của dự án, thêm tạo dáng bằng cách ghép và xoay theo bờ. [Blender source](../../art_source/village_a/fieldstone.blend) |
| Hoa vườn, cửa, tượng, đường, bọt, âm chuông | Tạo trong Godot, vật liệu dùng chung và không cần texture tải ngoài. |

Nguồn để đối chiếu khi cần bổ sung asset gồm Quaternius Stylized Nature MegaKit và ambientCG theo CC0. Trang Underwater Pack của reodesuxz cho phép dùng thương mại. Ba nguồn này là lựa chọn cho các lượt bổ sung. [Quaternius](https://quaternius.com/packs/stylizednaturemegakit.html) · [ambientCG](https://docs.ambientcg.com/license/) · [reodesuxz](https://reodesuxz.itch.io/low-poly-underwater-pack)

## Kiểm tra trong Godot

- Chạy `godot --path . -- --a1-superworld --no-title`. `WASD` bơi, `Ctrl` lặn, `Space` nổi, `E` tương tác.
- `a1_superworld_test.gd` kiểm collider cửa trước khi rung chuông, thao tác mở cửa và nhặt gốm, bơi xuyên phòng kín, đàn cá chiều xuất hiện khi trời quang và biến mất khi mưa. Bài kiểm tuyến cũ vẫn bao gồm cả hai khe vực.
- Ảnh duyệt chụp bằng Godot 4.6.3 Compatibility trên Linux/Mesa llvmpipe. Kiểm FPS trên GPU Windows còn chờ. [Ảnh và bản đồ sáu khu](https://github.com/VietCodeBug/a-place-to-belong/blob/preview/ver-17-gpt-underlake-world/docs/environment/review-underlake-world/README.md)
- Ba dáng hoa và cụm lá thấp dùng bốn mesh chung với một vật liệu. Cánh cong bằng hình học, gân cánh và chuyển động dùng shader. Các cụm cao thấp nằm hai bên lối bơi. [Ảnh trước–sau và cận ba dáng hoa](https://github.com/VietCodeBug/a-place-to-belong/blob/preview/ver-19-gpt-light-garden-flora/docs/environment/review-light-garden-flora/README.md)
