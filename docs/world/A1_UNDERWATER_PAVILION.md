# Lòng hồ A1 và đình đá chìm

Chạy A1 với `godot --path . -- --a1-superworld --no-title`. Mở bản đồ bằng `M`, tới bến ở bờ tây rồi bơi về phía đông qua vòm đá cũ. Điểm **Đình đá chìm** hiện trên bản đồ khi phóng gần khu vực hồ, ở `x=336, z=-456`. Dùng `WASD` để bơi, `Ctrl` để lặn và `Space` để nổi.

Đình có mái vòm vỡ, cột đá, sân lát và lối bơi rộng ở phía tây. Đáy nông dùng cát nhạt và phản quang gợn nước. Màu xanh ngọc chuyển dần sang xanh lam theo độ sâu, ánh sáng và mưa. Camera trên mặt hồ dùng bầu trời bình thường, còn camera dưới nước thấy mặt nước từ phía dưới. Mái đình, cột và sân có collision.

Bốn đàn gồm 65 con dùng ba mẫu cá Quaternius CC0. Các đàn có vóc dáng, độ cao, kích thước và nhịp bơi riêng, trải từ gờ nông đến quanh đình và rìa lòng hồ sâu. Mỗi đàn là một MultiMesh và cập nhật vị trí 24 lần/giây trong phạm vi 88 m quanh camera. [Giấy phép, FBX và GLB](../../assets/vendor/quaternius/fish/README.md)

Ảnh duyệt chụp trong Godot 4.6.3 Compatibility trên Linux/Mesa llvmpipe. Bộ ảnh có góc tiếp cận khớp với bản gốc `gemini-ultra`. Chưa có số đo FPS trên GPU Windows. [Album lòng hồ và ảnh cận cả ba mẫu cá](https://github.com/VietCodeBug/a-place-to-belong/blob/preview/ver-15-gpt-a1-underwater/docs/world/review-gpt-a1-underwater/README.md)
