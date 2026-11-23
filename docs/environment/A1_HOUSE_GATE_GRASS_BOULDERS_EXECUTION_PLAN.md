# A1 House Gate — Kế hoạch thực thi: cỏ rừng đồng bộ, nền sạch và đá tảng lớn

> **Loại:** execution plan / art review gate. **Trạng thái:** PENDING_CREATOR_APPROVAL. [Ảnh, số đo và biên bản P0–P4](review-a1-house-yard/README.md).  
> **Đầu vào đã xác nhận:** phản hồi của người sáng tạo ngày 20/11/2026 — *nhà đã đẹp hơn; giữ nhà; đưa cỏ đã ưng ý ở khu nhà trong rừng sang cảnh House Gate; nền đừng xanh bẩn; thêm những tảng đá lớn vì sân quá trống*.  
> **Baseline không thay đổi:** commit [`cc8280f`](https://github.com/VietCodeBug/a-place-to-belong/commit/cc8280fc3cd7454f2370ca2f13f483a7c40855f4) trên nhánh `feature/character-emotional-animation-v1`; [gallery A1](review-a1-house-gate/README.md), [báo cáo trạng thái](A1_ART_REBUILD_STATUS.md), [chuẩn mỹ thuật](A1_ASSET_QUALITY_BIBLE.md).  
> **Issue thực hiện:** [#12 — Cỏ, nền và đá tảng](https://github.com/VietCodeBug/a-place-to-belong/issues/12).  
> **Phạm vi:** chỉ *A1 House Gate preview* và các tài nguyên hỗ trợ dùng lại, **chưa chỉnh/merge gameplay map chính khi chưa được duyệt**. Không viết lại nhà, NPC hay kịch bản.

## 0. Mục tiêu và chuẩn không được phá

**Mục tiêu hình ảnh:** căn nhà nằm trong một khoảng rừng có cỏ 3D thật, tươi, nhiều lớp; ánh sáng và đất là nền hỗ trợ chứ không phải mảng xanh loang; các cụm đá tảng lớn giúp cảnh có trọng lượng và chiều sâu. Vẫn để người chơi đọc rõ mái, cửa, bậc, khoảng sân và lối từ rừng đến hiên.

**Giữ nguyên:** mesh và tỷ lệ `hewn_eaves_cottage.glb`, mái/hiên, cửa, bậc, góc chụp cũ, chế độ Godot Compatibility. Đừng thêm đạo cụ cản cửa. Người sáng tạo khen *nhà* chứ **chưa duyệt toàn bộ Vegetation gate**.

**Tách ba vấn đề:**
1. **Cỏ thiếu hình khối:** A1 chỉ có các cụm `grass_leafs` bé rải ở 6 vị trí; phải tái dùng hệ cỏ thực từ rừng.
2. **Nền xanh bẩn:** `a1_house_yard.gdshader` tự trộn xanh lá tối/đất với noise trên một mặt nền 92 × 88 m; không giải quyết bằng tăng saturation hoặc thêm noise.
3. **Bố cục quá trống:** phải có vài *boulder* lớn tạo silhouette gần mép rừng, không phải thêm hàng trăm viên sỏi.

## 1. Nguồn có sẵn — ưu tiên tái sử dụng, không tải trùng

| Mục đích | File trong repo tại baseline | Hành động |
|---|---|---|
| Cỏ dày đã dùng tại Forest/Map 01 | `environment/vegetation/scripts/dense_meadow.gd` | Dùng lại **5 lớp**: carpet/main/accent + hoa thưa; shader gió/LOD đang có |
| Cách thảm cỏ được đưa vào rừng | `scripts/world/ground_cover.gd` | Đối chiếu cách tạo `DenseMeadow`, giữ hình dạng/cảm giác thống nhất |
| Mesh/shader/preset | `environment/vegetation/scripts/meadow_meshes.gd`, `environment/vegetation/shaders/dense_meadow.gdshader`, `environment/vegetation/presets/high.tres` | Dùng làm baseline; tinh chỉnh thông số **cục bộ** A1, không phá Map 01 |
| Cảnh A1 cần sửa | `scripts/environment/a1_house_gate.gd` | Thêm lớp thực vật và đá vào **scene preview riêng** |
| Shader mặt sân hiện tại | `shaders/a1_house_yard.gdshader` | Giảm vùng xanh rêu bẩn, giữ đất/lối mòn có chủ đích |
| Đá lớn đã có giấy phép trong repo | `assets/vendor/kenney/nature/rock_largeA.glb`, `rock_largeB.glb` | Dùng thử trước; tạo cụm đá chính |
| Đá rêu bổ trợ | `assets/vendor/quaternius/Rock_Moss_1.glb` | Đi kèm đá lớn, không làm toàn bộ cảnh xanh rêu |
| Bố cục đá trong rừng đã có | `scripts/world/woodland.gd` | Tham khảo cách scale/đặt/biến thể, không sao chép tọa độ Map 01 |

**Cảnh báo quan trọng khi dùng cỏ:** `dense_meadow.gd` mặc định lấy chiều cao từ `ForestLandscape.height_at`, dùng `ForestFloorDesign.reserved` và diện tích/mask riêng Map 01. **A1 House Gate hiện là sàn preview phẳng**, nên **không instantiate nguyên mặc định**. Cần cung cấp sampler độ cao đúng nền A1, mask tránh nhà/đường/bậc và vùng sinh cỏ đúng, nếu không cỏ sẽ xuyên sàn hoặc xuất hiện trong nhà. Dùng cùng **hệ** cỏ không có nghĩa bê nguyên các mask/tọa độ từ map cũ.

## 2. Thứ tự thực hiện và cổng kiểm tra

### P0 — Khóa baseline và chuẩn bị so sánh

- [ ] Checkout nhánh baseline ở trên; xác nhận scene `scenes/environment/a1_house_gate.tscn` chạy và 4 ảnh cũ khớp gallery.
- [ ] **Không sửa** GLB nhà hay source Blender của nhà trong vòng này.
- [ ] Lưu bốn camera và thiết lập ánh sáng hiện tại để ảnh trước/sau **so được thật**, không đổi góc hoặc sáng hơn để che lỗi.
- [ ] Lưu chỉ số baseline: số draw calls, FPS/frame time tại cùng góc nhìn, số mesh cỏ/đá ban đầu, thời gian import.
- [ ] Rà các lối đi/collision từ nhà ra rừng và khoảng trống phải chừa để không đặt đá chắn.
**Gate P0:** có baseline kiểm thử có thể tái lập; không bắt đầu tô vẽ khi chưa giữ được góc chụp và hiệu năng gốc.

### P1 — Cỏ 3D đồng nhất với khu rừng (ưu tiên số 1)

- [ ] Tạo adapter/preset A1 cho `DenseMeadow` (hoặc reuse class qua cấu hình), lấy cùng mesh/shader/wind/LOD với hệ rừng; **tránh sửa preset chung** nếu sẽ làm thay Map 01.
- [ ] Gắn đúng `height_sampler` theo sân preview (không dùng địa hình Map 01). Định nghĩa `valid_area`, vùng loại trừ theo footprint nhà, hiên, bậc, đường chính, đá lớn, nơi cần đất lộ.
- [ ] Lớp **carpet** phủ phần lớn khoảng xanh có thể trồng. Lớp **main/tuft** dày thành cụm; lớp **accent** cao hơn nhưng tiết chế. Hoa/dương xỉ thưa, gắn theo cụm chứ không rải lẻ đều.
- [ ] Cỏ **thấp ở gần bậc và lối đi**, cao dần ra mép rừng, phân khối bằng patches tự nhiên. Không cỏ xuyên bậc hoặc áp sát chân tường.
- [ ] Test đủ ba tầm nhìn: cận chân người, từ bậc nhà nhìn ra, từ mép rừng nhìn về nhà.
**Gate P1:** cảnh từ eye-level có **thảm cỏ 3D đủ dày**, không còn cảm giác sân là một mặt xanh phẳng; nhà/lối đi vẫn đọc rõ. **Nếu P1 fail, không chuyển sang trang trí đá.**

### P2 — Sửa màu nền và đường đi (chỉ sau khi có cỏ)

- [ ] Trong `a1_house_yard.gdshader`, giảm dải xanh rêu tối và độ tương phản noise gây loang; đưa về palette **xanh ấm, sạch** bên dưới cỏ, đất nâu ấm nơi có dấu đi lại và gốc cây.
- [ ] Không phủ mọi nơi bằng màu đất; **đất phải có lý do xuất hiện**: lối mòn, chân tảng đá, dưới tán cây, chỗ đặt dụng cụ.
- [ ] Làm chuyển tiếp mép đường bằng cỏ ngắn và mảnh đất loang ít; tránh đường như dải sơn nâu cắt trên nền xanh.
- [ ] So màu nền tại cùng ánh sáng/same camera để bảo đảm cải thiện đến từ vật liệu + mật độ cỏ, không phải chỉnh exposure.
**Gate P2:** nền không xanh đen/đốm bẩn; đường vào cửa sạch, có độ sâu và chuyển tiếp tự nhiên.

### P3 — Bố trí đá tảng lớn có chủ đích

- [ ] Thử **asset đá lớn đã có**: `rock_largeA`, `rock_largeB` và `Rock_Moss_1`. Chỉ tải bên ngoài nếu test thấy không đủ silhouette khác nhau.
- [ ] Xếp **ít nhất ba cụm không đối xứng**:
  - **Cụm A — mép rừng bên trái khi nhìn từ lối vào:** 1 tảng chính gợi cao khoảng 2–3 m + 1–2 tảng thấp hơn. Tạo tiền cảnh, không che mái/chân nhà.
  - **Cụm B — mép rừng bên phải, cách xa cửa:** 1 tảng chủ đạo khác dáng khoảng 1.5–2.5 m + 2–3 đá phụ. Tạo đối trọng và khoảng trống giữa hai cụm.
  - **Cụm C — sâu hơn cạnh hàng cây/ngoài rìa sân:** 1 tảng lớn 2–3.5 m, chỉ lộ một phần từ góc eye-level để tăng chiều sâu.
- [ ] Kích thước trên là **gợi ý bố cục tại tầm mắt người chơi**, không ép mọi model cao chính xác; chỉnh theo tỷ lệ nhà và camera. Chôn một phần đá vào đất, xoay lệch, chèn 1–2 bụi cỏ/dương xỉ chân đá. Không lặp đá theo hàng và không tạo bức tường đá.
- [ ] Dùng màu **xám đá ấm/xám rêu nhẹ**, phân biệt khỏi nền xanh. Đá lớn có collision proxy vừa hình; không dựng collision phức tạp tốn kém hoặc gây kẹt nhân vật.
- [ ] **Nếu cần tải thêm**: chỉ asset phù hợp Classic Low Poly từ nguồn tác giả như Kenney Nature Kit hoặc Quaternius Nature Pack; ghi lại URL tải, giấy phép, phiên bản và file nguồn. Kiểm tra license tại lúc tải, không dùng asset nguồn mơ hồ.
**Gate P3:** từ ít nhất hai góc review thấy rõ **tảng đá thật sự to**, có silhouette và chiều sâu; lối qua sân/đường cửa không bị chặn.

### P4 — Kiểm thử, ảnh duyệt và quyết định ghép

- [ ] Import Godot sạch và chạy scene A1 House Gate; đi bộ thật qua bậc, lối vào, quanh ba cụm đá, dọc rìa cỏ. Không xuyên mesh/collision, không mắc kẹt.
- [ ] Kiểm performance với cùng preset/same machine/same camera đã ghi P0: FPS/frame time, draw calls, số instances, LOD và tầm culling. Nếu giảm mạnh, tối ưu chunks/LOD/masks **trước** khi giảm mật độ cỏ chủ đạo.
- [ ] Render lại **front, side, three-quarter, gameplay eye-level** cùng góc, 1280 × 720, cùng điều kiện sáng.
- [ ] Làm **cặp trước–sau** cho eye-level và three-quarter; thêm ảnh cận: cỏ–mép đường, chân đá, bậc hiên. Ghi số lượng/cụm đá, nguồn asset và thay đổi cỏ trong báo cáo review.
- [ ] Ghi trạng thái `PENDING_CREATOR_APPROVAL`. **Chờ duyệt riêng**: (a) chất lượng cỏ/nền, (b) độ lớn và vị trí đá, (c) va chạm/perf. Nếu fail, sửa đúng giai đoạn tương ứng, không làm lại nhà.
- [ ] **Chỉ sau khi người sáng tạo nói đạt**, mới lập đầu việc chuyển hệ cỏ/đá đã duyệt sang A1 trong tuyến game chính. Không tự merge hoặc bật trong world chính trước đó.
**Gate P4:** có đủ ảnh so sánh, cảnh chạy được, số liệu kiểm thử và nhận xét duyệt thực tế; không tự ghi `PASS` khi chỉ xong code.

## 3. Thứ tự ưu tiên (đừng đảo)

**Bắt buộc:** P0 → **P1 cỏ** → **P2 nền** → **P3 đá tảng** → **P4 kiểm tra + duyệt**.

Nếu thiếu thời gian nguồn lực, **làm cỏ cho đúng trước**. Đừng bù nền cỏ xấu bằng thêm hoa, sỏi nhỏ, vật trang trí, hay thêm nhà mới. Cụm đá chỉ được điều chỉnh sau khi cỏ và nền đạt mắt nhìn người.

## 4. Definition of Done

- [ ] **Nhà:** mái/hiên/cửa không bị chỉnh hoặc che mất; phối cảnh nhà vẫn đọc đẹp.
- [ ] **Cỏ:** dùng hệ cỏ 3D đã có từ rừng (không phải chỉ `grass_leafs` rải lẻ), tạo độ dày và lớp gần–xa; không xuyên nhà/đường.
- [ ] **Nền:** giảm nền loang xanh bẩn, đất và lối đi hợp lý; trông sạch sáng trong ảnh cùng ánh sáng.
- [ ] **Đá:** ít nhất 3 cụm đá tảng lớn, 2 cụm thấy rõ trong ảnh review; đá có collision đơn giản và không chắn lối đi.
- [ ] **Chạy được:** Godot import và chạy scene, camera preview và va chạm hoạt động, hiệu năng đo được/so với P0.
- [ ] **Review:** ảnh trước–sau cùng góc, báo cáo asset và hiệu năng; **creator duyệt trực tiếp**.

## 5. Các điều không làm trong đợt này

- Không dựng lại nhà, nội thất, làng, Thomas, ngày–đêm, hệ mây, mùa hoặc nhiệm vụ.
- Không tải asset mới khi repo đã có đá đạt hình dáng tương đương.
- Không dùng shader tối/noise để giả vờ có cỏ.
- Không đưa A1 preview vào cảnh chơi chính trước khi được duyệt.
- Không tuyên bố Vegetation gate đã pass; người sáng tạo mới đánh giá mẫu cỏ vùng rừng là hướng nên dùng lại.

## 6. Deliverables bên dựng phải gửi lại

1. PR/commit chỉ rõ source file thay đổi và tài nguyên tái sử dụng.
2. Gallery review bản mới + ảnh đối chiếu trước/sau đúng góc máy.
3. Biên bản kiểm thử đường đi, collision, cỏ không xuyên, perf trước/sau.
4. Ghi chú nguồn giấy phép nếu có asset tải bổ sung.
5. Trạng thái từng gate P0–P4 và phần nào còn pending duyệt.

**Ghi chú phân vai:** tài liệu này là **plan/brief review** cho AI dựng môi trường; người viết biên kịch không tự coi các asset đã được chỉnh sửa. Các mốc P0–P4 là cổng chất lượng, không phải khẳng định đã hoàn thành.
