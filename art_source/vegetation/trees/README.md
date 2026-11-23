# Nguồn cây Làng A

FBX do Quaternius phát hành dưới CC0-1.0 trong Ultimate Stylized Nature. Mirror, commit, hash đầu vào và đầu ra nằm trong [provenance.json](provenance.json). Giữ nguyên các FBX nguồn. Godot dùng GLB xuất từ Blender và texture đã chỉnh nằm trong `assets/vegetation/trees`.

```sh
blender -b --python-exit-code 1 --python art_source/vegetation/trees/export.py
python art_source/vegetation/trees/prepare_textures.py /duong-dan/Textures
```

Script texture dùng Pillow và NumPy. Thư mục đầu vào chứa ảnh gốc từ đúng commit trong manifest. Ảnh vỏ cây thu tối đa 1024 px. Ảnh lá giữ alpha và độ sáng, cho phép đổi bảng màu mùa trong Godot.
