# Lòng hồ A1 và đình đá chìm

Tuyến khám phá mới nối từ bến qua đồng cỏ nước và đình đến vườn ánh sáng. [Bố cục sáu khu và các tương tác](../environment/UNDERLAKE_WORLD_V1.md)

Chạy A1 với `godot --path . -- --a1-superworld --no-title`. Mở bản đồ bằng `M`, tới bến ở bờ tây rồi bơi về phía đông qua vòm đá cũ. Điểm **Đình đá chìm** hiện trên bản đồ khi phóng gần khu vực hồ, ở `x=336, z=-456`. Dùng `WASD` để bơi, `Ctrl` để lặn và `Space` để nổi.

Đình có mái vòm vỡ, cột đá, sân lát và lối bơi rộng ở phía tây. Đáy nông dùng cát nhạt và phản quang gợn nước. Màu xanh ngọc chuyển dần sang xanh lam theo độ sâu, ánh sáng và mưa. Camera trên mặt hồ dùng bầu trời bình thường, còn camera dưới nước thấy mặt nước từ phía dưới. Mái đình, cột và sân có collision.

## Tuyến di tích mở rộng

| Điểm khám phá | Tọa độ X, Z | Khi tới nơi |
| --- | --- | --- |
| Cổng bậc đá | `380, -416` | Bơi lên qua dãy bậc phía tây rồi xuyên dưới vòm. |
| Hành lang cột | `418, -474` | Men theo nền lát đá giữa hai hàng cột gãy. |
| Tháp vỡ | `478, -402` | Men theo gờ nông phía nam rồi vào lòng tháp qua tường vỡ. |

Hai khe vực nằm ở `456, -447` và `524, -478`. Đáy sâu khoảng 42–50 m ở tâm, được khoét trong cùng địa hình dùng cho collision. Dòng chảy giới hạn độ sâu lặn ở khoảng 18 m ngay trên hai khe. Tới giới hạn, HUD hiện **Dòng chảy mạnh phía dưới**. Bấm `Space` để nổi hoặc bơi ngang ra khỏi vùng dòng chảy. Bản đồ đánh dấu mép hai khe và các di tích khi phóng gần hồ.

Rong lá dải, rong thân cao và bụi lá quạt tạo thành 1.380 cụm ở gờ nông, quanh chân di tích và trên mép dốc. Cây được gom theo ô 32 m để loại các cụm xa khỏi tầm vẽ và chừa trống lối bơi.

Bốn đàn gồm 65 con dùng ba mẫu cá Quaternius CC0. Các đàn có vóc dáng, độ cao, kích thước và nhịp bơi riêng, trải từ gờ nông đến quanh đình và rìa lòng hồ sâu. Mỗi đàn là một MultiMesh và cập nhật vị trí 24 lần/giây trong phạm vi 88 m quanh camera. [Giấy phép, FBX và GLB](../../assets/vendor/quaternius/fish/README.md)

Ảnh duyệt chụp trong Godot 4.6.3 Compatibility trên Linux/Mesa llvmpipe. Chưa có số đo FPS trên GPU Windows. [Di tích mới, khe vực và bản đồ](https://github.com/VietCodeBug/a-place-to-belong/blob/preview/ver-16-gpt-a1-lake-ruins/docs/world/review-gpt-a1-lake-ruins/README.md) · [Ảnh cận cả ba mẫu cá và bộ ảnh phiên bản đầu](https://github.com/VietCodeBug/a-place-to-belong/blob/preview/ver-15-gpt-a1-underwater/docs/world/review-gpt-a1-underwater/README.md)
