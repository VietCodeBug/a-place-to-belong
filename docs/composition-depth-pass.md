# Composition & depth — Early Autumn Cozy Forest

Lượt này tập trung dàn cảnh thay vì thêm số lượng asset. Giữ nguyên controller,
camera follow, mailbox và UI.

## Các thay đổi chính

- **Ba khoảng rừng:** cụm cây gần ở hai cánh, cụm trung cảnh trên đồi và dải cây xa
  tách hẳn phía sau. Cây trung/xa giảm còn hai tầng tán, giảm tương phản, dùng sắc
  xanh lạnh hơn; haze bắt đầu sau clearing. Đồi nền và cây dùng chung hàm độ cao
  để thân cây bám đất. Không xếp tất cả cây thành một hàng sau quán.
- **Khoảng thở cho mái:** chuyển cụm cây sát quán ra hai phía, dành vùng rỗng sau
  silhouette mái. Nắng ấm chiếu mặt tiền; đèn hướng ngược cường độ thấp, không có
  shadow map riêng, giúp tách viền mái khỏi cảnh nền.
- **Đường dẫn mắt:** chữ S nối trực tiếp bậc hiên, nửa chiều rộng từ 0.95 m ở cửa
  đến 2.7 m tiền cảnh. Cỏ và lá ven đường dùng chung `ClearingLayout` để bám theo
  hai mép đường; vài phiến stepping stone thấp nhấn đoạn vào cửa.
- **Foreground:** vạt cỏ cao hơn, bụi xanh đậm, đá, hoa kem và gốc cây cạnh đoạn rào
  gần camera. Giữ vùng đi lại thoáng, không thêm cây cao vào hành lang nhìn.
- **Cụm có công năng:** bên trái là chỗ uống café với bàn/cốc/ghế/menu cạnh xe đạp;
  bên phải là nơi nhận thư với mailbox, bàn phân thư và bao hàng. Các bụi hoa gom
  theo các góc này; bỏ nhịp đặt ghế và cây đều hai bên quán.
- Mảng cỏ nền chuyển từ hai dải đều sang các đảo gắn với từng cụm props. Giữ vật
  liệu matte, instancing và geometry đơn giản của art pass trước.

## Tệp thay đổi

- `scripts/world/clearing_layout.gd`: đường cong, độ rộng và vùng cần giữ thoáng.
- `scripts/world/woodland.gd`: bố cục ba lớp, thực vật, palette theo khoảng cách,
  đồi nền và vị trí gốc cây trên đồi.
- `scripts/world/forest_hub.gd`: đường, ánh sáng, props và foreground.

Palette mùa thu vẫn tách riêng. Chưa thêm chuyển mùa, thời tiết hay cơ chế mới.

## Ảnh render thực tế

Giữ ảnh art pass trước trong `screenshots/early-autumn/` để so sánh. Ảnh mới ở dưới
được chụp cùng ba góc bằng Godot 4.6.3 / OpenGL Compatibility / Mesa llvmpipe:

![Camera chơi thật, giữ UI](https://raw.githubusercontent.com/VietCodeBug/forest-post-cafe/refs/heads/preview/ver-02-composition-depth/01-playable-view.png)

![Bố cục gần–trung–xa](https://raw.githubusercontent.com/VietCodeBug/forest-post-cafe/refs/heads/preview/ver-02-composition-depth/02-woodland-clearing.png)

![Góc café và nhận thư](https://raw.githubusercontent.com/VietCodeBug/forest-post-cafe/refs/heads/preview/ver-02-composition-depth/03-cafe-porch.png)

Tái tạo với display thật/ảo có OpenGL:

```sh
godot --path . --audio-driver Dummy --script tools/capture.gd -- --output=/tmp/depth-captures
```

Góc 01 giữ nguyên camera gameplay; góc 02/03 là camera review cố định đã có từ
art pass trước. Không dùng ảnh headless để đánh giá hình ảnh.

## Xác nhận

- Editor import: đạt; startup 120 frame: đạt.
- Bộ kiểm thử gameplay: 13/13 đạt, gồm di chuyển/dừng, collision, hộp thư E/Esc,
  khóa di chuyển trong panel, camera follow và zoom.
- Đã render và xem cả ba ảnh 1280×720. Cảnh báo V-Sync trên Xorg dummy là giới hạn
  display kiểm thử; chưa chạy native Windows hay đo hiệu năng trên phần cứng PC.

Bộ preview riêng: [preview/ver-02-composition-depth](https://github.com/VietCodeBug/forest-post-cafe/tree/preview/ver-02-composition-depth).
