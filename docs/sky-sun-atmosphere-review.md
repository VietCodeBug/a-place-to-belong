# Map 01 — sky, sunlight và atmosphere

Baseline PR #9: `82cfd4ed68627bcfdb428e10947c20f1b692b15b`. Nhánh mới chỉ thay hàm `lighting()` và thêm dữ liệu/preset ánh sáng, công cụ review, kiểm tra/tài liệu. Không sửa quán, đèn riêng của quán, grass/shader/vegetation, terrain, đường, nhân vật, camera, mailbox hoặc gameplay. Không mở rộng Map 01.

## Năm vấn đề được ưu tiên

1. Sky xám xanh và fog ảnh hưởng mạnh lên sky làm góc thấp bị đục.
2. Ambient 0,85 cao làm mặt tiền và bãi cỏ được chiếu khá đều.
3. Thiếu mảng nắng–bóng rõ trên mái/hiên và khoảng rừng phía trước.
4. Bóng dưới cây cần giữ sắc lạnh/chi tiết, tránh chỉ hạ ambient rồi tạo mảng đen.
5. Hậu cảnh cần tách màu và đèn quán cần bối cảnh tối/lạnh hơn để đọc rõ.

## Các thử nghiệm bằng Godot

Đã thử ba hướng đầu, cùng camera/geometry, freeze wind/actor trong capture:

| Trial | Sun rotation | Sun energy | Ambient energy | Quan sát |
| --- | --- | --- | --- | --- |
| Side | (-22, -62, 0) | 1,10 | 0,58 | Có mảng sáng/bóng nhưng trái hiên khá tối |
| Low | (-16, -72, 0) | 1,20 | 0,60 | Bóng dài che cả lối vào và nhân vật; không chọn làm mặc định |
| Front | (-26, -32, 0) | 1,00 | 0,52 | Quán rõ nhưng ánh sáng lại khá đều, ít mảng nhấn ở forecourt |
| Golden được chọn | (-20, -52, 0) | 1,08 | 0,62 | Góc trung gian, mái/hiên có sáng tối, nhân vật đứng ngoài vùng shadow lớn |

Ba trial đầu dùng ambient #A7BDD5, sky #6E9DC2 / energy 0,8. Bản Golden cuối nâng màu fill lạnh lên #B7C8DF để giữ chi tiết vùng bóng; sky #6099C7 / energy 1,0 để có sắc xanh rõ hơn. Không tăng cường màu bằng texture/post-process mới.

## Hai preset độc lập

Golden Hour là mặc định: mặt trời thấp hơn, nắng mật ong, bóng kéo qua khoảng trống từ cây hiện có, bầu trời xanh và horizon ấm. Giảm ảnh hưởng fog lên sky để không phủ sky bằng màu xám. Không thêm mây/mesh hoặc god-ray giả; ưu tiên ánh sáng thật trên scene.

Blue Hour là preset chụp cinematic riêng: nắng/fill yếu và lạnh, rừng xanh trầm, horizon twilight; đèn hiên/cửa sổ hiện rõ nhờ tương phản. Không thay công suất, radius hay material/emission của hệ đèn riêng quán. Không có time simulation hoặc UI chọn giờ.

Chạy `godot --path . -- --lighting=blue_hour` để mở trực tiếp Blue Hour; không truyền flag thì dùng Golden Hour. `--lighting=baseline` phục vụ đối chiếu.

## Thông số chính xác

| Thông số | PR #9 | Golden Hour | Blue Hour |
| --- | --- | --- | --- |
| Sun rotation (độ) | (-32,-44,0) | (-20,-52,0) | (-12,-62,0) |
| Sun color | #FFD0A1 | #FFE0B2 | #B6CCF0 |
| Sun energy | 0,82 | 1,08 | 0,20 |
| Ambient color | #A8B5AC | #B7C8DF | #9BAED1 |
| Ambient energy | 0,85 | 0,62 | 0,50 |
| Sky top | #789794 | #6099C7 | #243D67 |
| Sky horizon | #DDCCAD | #F2D6AF | #8FA2C1 |
| Sky energy | 0,65 | 1,00 | 0,70 |
| Sky curve | 0,15 (engine default) | 0,22 | 0,24 |
| Fog color | #B3BFAF | #ADC0CC | #7897B1 |
| Fog begin–end (m) | 38–155 | 55–180 | 50–170 |
| Fog light energy | 0,45 | 0,35 | 0,35 |
| Fog sky affect | 1,00 | 0,12 | 0,22 |
| Sun angular distance (độ) | 0 | 0,6 | 0 |
| Sun glow angle (độ) | 30 (engine default) | 8 | 0 |
| Sun affects sky | Có | Có | Không — chỉ fill scene |
| Shadow blur | 2,0 | 2,5 | 2,5 |
| Shadow max distance (m) | 100 | 85 | 85 |
| Blend cascade splits | Tắt | Bật | Bật |

Chung: exposure 1,0 / tonemap mặc định; 4 shadow cascades; atlas **4096** và filter quality **2** sẵn có, không nâng resolution; bias **0,09**, normal bias **1,1**. SSAO giữ nguyên **enabled / radius 0,55 / intensity 0,65 / power 1,1**. Tăng blur/blend không phải tuyên bố PCSS/area shadows. Full dump từ resource/effective sky defaults ở [lighting-presets-parameters.json](lighting-presets-parameters.json).

Mặt trời trên sky Golden do ProceduralSkyMaterial lấy hướng/size từ chính DirectionalLight3D. Không có đĩa trời độc lập để lệch hướng shadow. Blue Hour không vẽ sun disc.

## Renderer và hiệu năng

Giữ Compatibility / OpenGL 4.5 Mesa llvmpipe trên host cloud. Không thử nâng renderer; Vulkan probe ở lượt trước đã thất bại. Không thêm GI/volumetric fog, bloom hay raytracing; không nhận là đã kiểm thử Forward+.

Scene assets, số instance, số light và atlas/SSAO resolution không tăng. Shadow draw calls có thể đổi vì hướng nắng, cascade blend và shadow range khác nhau; chúng bao gồm render pass, không phải số geometry mới. Capture JSON ghi draw calls/primitive theo cùng camera. `tools/measure_lighting_cost.gd` có phép đo wall-frame cùng một scene frozen trên llvmpipe; không phải GPU timer hay benchmark Windows. Không bảo đảm FPS phần cứng Windows từ số liệu host này.

## Kiểm thử / bằng chứng giữ phạm vi

`tools/validate_lighting_scope.py` so với đúng commit PR #9: toàn bộ quán/café lights, asset/scene/shader/collider/vegetation/characters/player/camera và renderer config không đổi. Trong forest_hub.gd chỉ `lighting()` được thay. Không có mesh, animation hay clock trong preset.

Chạy editor import/boot, gameplay smoke, Map 01 scope, floor scope, display integration và lighting preset tests. Preset tests kiểm tra PR09 values, giữ SSAO, apply nhiều lần không nhân đôi ánh sáng và không đụng đèn quán. Kết quả kiểm thử và log được lưu cùng preview; pass kỹ thuật không thay cho duyệt mỹ thuật.

## Ảnh trước / Golden / Blue

Đã kiểm tra remote preview branches: số lớn nhất trước lượt này là 07, nên dùng [preview/ver-08-lighting-presets](https://github.com/VietCodeBug/a-place-to-belong/tree/preview/ver-08-lighting-presets), giữ nguyên các nhánh cũ.

Mỗi preset có 5 ảnh Godot thật, 1280 × 720, cùng camera: gameplay mặc định, café exterior, forest clearing, low-angle sky/horizon, wide composition. Baseline PR #9 được dựng lại bằng preset tái hiện chính xác. Freeze wind và actor chỉ trong công cụ capture để A/B ít nhiễu; scene game không bị freeze. Không restage quán, nhân vật hay cây. Không dùng ảnh AI hoặc chỉnh màu PNG để làm đẹp review.

## Còn yếu / chờ review

Bóng tán cây low-poly vẫn tạo mảng lớn, chưa có ánh sáng xuyên thể tích. Blue Hour có vài tán cây/đoạn nền tối; đèn quán chỉ được nổi lên bằng tương phản vì giữ nguyên hệ đèn và emission đã duyệt. Không có mây mới hoặc GI bake, sky là gradient và sun glow native. Chưa benchmark card Windows. Chưa tự gán điểm cinematic/premium; người dùng duyệt dựa trên ảnh thật. Không merge PR.

### Kết quả kiểm tra và chi phí đo tại host

- 13 gameplay smoke, 11 Map 01 scope, 12 floor scope, 18 display integration và 16 lighting preset checks qua, 0 lỗi. Preset tests áp dụng cả baseline/Golden/Blue và kiểm tra không đụng đèn quán.
- Wall-frame median 12 mẫu trên cùng view frozen, **software llvmpipe**: baseline 1010,37 ms; Golden 1022,98 ms (~+1,25%); Blue 983,15 ms. Có outlier khoảng 2 s, nên đây chỉ là kiểm tra thô trên host, không phải GPU timing hoặc FPS Windows.
- Toàn bộ view/capture và thống kê draw calls/primitive được lưu riêng trên preview. Số instance/asset và shader hiện có không đổi; các số primitive gồm cả shadow passes.
