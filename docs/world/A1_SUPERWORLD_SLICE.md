# A1 Superworld · Nền tảng prototype trong game

## Phương án tích hợp

- Giữ hệ trục game 1 đơn vị = 1 m. Nhà A (16, −338), cầu (0, 74), sân chung Làng A (5,2; 128), toàn bộ 21 lô và tuyến Chapter 01 lấy trực tiếp từ game tại `9cf0f45`. Tọa độ standalone phục vụ thử nghiệm riêng.
- Chế độ review `--a1-superworld` nối vòng terrain mới vào khối địa hình cũ từ X −64 đến +64, Z −384 đến +192. Hiệu chỉnh mẫu sát mép ngoài khối để lưới 2 m cũ khớp lưới 8 m của các chunk. Giữ mẫu cao độ trong vùng có nội dung đã dựng.
- Terrain A1 rộng 4.096 × 4.096 m, chia chunk 64 m. Lưới panorama phủ tầm nhìn. Mesh và collider chi tiết được tạo khi người chơi đến gần, có giới hạn tạo mỗi frame và giải phóng collider khi rời xa. Các vùng B–I nằm trong registry ở trạng thái dự trữ.
- Hồ thử nghiệm đặt phía đông rừng, tâm (650, −455) với bán trục 430 × 310 m. Hai lối mòn nối vùng bờ hồ với rừng và làng. Có bến, dốc vào/ra nước, gờ cạn, lòng hồ trũng và một cụm đá để lặn tới. Vị trí và tên hiển thị là dữ liệu review.
- Tái sử dụng nhân vật, camera góc ba, điều khiển trên cạn và M-map đang có. Bơi theo WASD, Space nổi, Ctrl lặn. Map M dùng cùng hàm terrain, thể hiện vị trí, vùng đã đi và lớp chunk runtime.
