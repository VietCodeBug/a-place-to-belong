# Hero café V05

Nguồn chỉnh sửa: `art_source/hero_cafe_v05/hero_cafe_v05.blend` và `build_hero.py`.
GLB tự tạo cho Forest Post Café, không dùng model tòa nhà bên thứ ba. 160.760 tam giác, 20 mesh, 31 material PBR, không có texture ngoài. PBR ở đây là tham số roughness/metallic/emission, chưa phải bộ texture baking.

`manifest.json` ghi nguồn và hash. `cafe_kit.gd` chỉ load GLB, thêm collision đơn giản và đèn runtime. Chất lượng mỹ thuật còn chờ người dùng duyệt; chưa phải tài sản production đã tối ưu LOD.
