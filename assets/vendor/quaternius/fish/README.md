# Cá hồ A1

Ba mẫu cá lấy từ **Animated Fish Pack** của Quaternius, giấy phép CC0 1.0. FBX gốc có rig và clip bơi. Bản chạy game gồm ba GLB, mỗi file có một surface dùng màu đỉnh. Bảng màu được chỉnh về bạc, xanh xám và vàng ô-liu để hợp với hồ A1. [Trang tác giả](https://quaternius.com/packs/animatedfish.html) · [Giấy phép](https://creativecommons.org/publicdomain/zero/1.0/)

Các FBX trong `art_source/lake_fish/source` đến từ bản sao của bộ cá. SHA-256 của từng FBX khớp với con trỏ Git LFS tại commit ghi trong `manifest.json`. Manifest cũng ghi checksum của từng GLB. [Bản sao đã kiểm tra](https://github.com/seoyxxn11/araatti_project/tree/b27b13c2bef9b7d90f6ffa9e0acccb064fe0a10a/unity/UnderTheSea/Assets/QuaterniusAnimatedFish)

Xuất lại GLB từ thư mục gốc của dự án với Blender 4.3.2

```sh
blender --background --python art_source/lake_fish/export.py -- \
  art_source/lake_fish/source assets/vendor/quaternius/fish
```

Shader Godot uốn đuôi theo pha riêng từng con. Vị trí và hướng bơi theo đàn cập nhật trên CPU, với một `MultiMesh` cho mỗi đàn. File FBX gốc vẫn có thể dùng để sửa rig hoặc clip trong Blender.
