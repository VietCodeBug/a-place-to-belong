# V05 — nguồn quán chính

Geometry được tác giả hóa bằng Blender Python cho dự án: không dùng building pack bên ngoài, không lắp BoxMesh trong Godot. File `.blend` lưu các đối tượng rời để sửa tay; GLB xuất được gộp theo 20 nhóm ngữ nghĩa. Không phải asset qua pipeline game-dev canonical: CLI không có trong môi trường, dùng quy trình thủ công đã được người dùng cho phép.

Tái tạo từ thư mục repo:

```sh
blender --background --python art_source/hero_cafe_v05/build_hero.py
python tools/validate_hero_asset.py
```

`spec.json` là kích thước/ngân sách; `build_report.json` là số liệu build. Sau rebuild cần cập nhật SHA-256 trong manifest. `.gdignore` ngăn Godot tự import nguồn Blender; engine chỉ dùng GLB đã xuất. Không có texture ngoài, không cần tải font ngoài. Nguồn và output là tài sản tự tạo cho dự án; không tự gán CC0 cho tài sản của người dùng.
