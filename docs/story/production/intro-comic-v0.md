# Opening Comic v0 — Prototype truyện tranh cho Prologue

> **DRAFT / Production brief**, không thay thế các scene canon. Được tạo để AI lập trình/mỹ thuật dựng thử **mở đầu theo dạng truyện tranh nhiều khung**, không kết luận engine đã có cutscene.
>
> **Trình tự đã đồng ý:** PRO-001 giới thiệu AI/layoff/áp lực sống → PRO-002 email mất việc **tại văn phòng** → PRO-003 những ngày trong **căn hộ thuê** → PRO-004 giấc ngủ chuyển từ tiếng thành phố sang tiếng rừng → gameplay CH01-001 trong nhà A → CH01-002 rừng rộng **ngập nắng** → hook lối mòn mờ sau khi ngắm rừng.

## Đề xuất phong cách
- **Comic / motion comic 2D**: từng khung hình minh họa có nét mực/phác thảo mềm, mảng màu phẳng, giấy hơi có texture; không đòi dựng văn phòng và căn hộ 3D để tạo bản thử.
- Phù hợp UI V12 (storybook, giấy kem, nét bút), nhưng truyện đời thực nên thiên **màu lạnh, ánh đèn màn hình**; khi sang giấc mơ chuyển sang **ánh sáng ấm, xanh lá**. Đây là **đề xuất mỹ thuật**, chưa canon.
- Khung có thể **trượt nhẹ, phóng chậm hoặc đổi layer foreground/background**, nhưng nên hỗ trợ Reduce Motion: hiển thị tĩnh + fade; **không dùng slideshow flash**.
- Text trong speech/thought box ngắn, tránh che mặt nhân vật; bố cục 1280×720 gốc, responsive 1920×1080. Bấm/Space/Enter để qua panel; Esc skip cả sequence sau xác nhận (cơ chế skip là đề xuất).
- Giữ asset panel/lời thoại riêng, dùng định danh `panel_id`, `image_key`, `text_key`, `audio_cue`, `scene_ref`, `next` thay vì hardcode.
- **Không tạo bằng dữ liệu HTML**: build bằng Godot Control, TextureRect, AnimationPlayer/Tween hoặc logic tương đương; tránh sửa camera, thời tiết, cỏ và môi trường chính trong PR mỹ thuật.

## Storyboard tối thiểu 14 khung (bản thử, KHÔNG locked)

| Panel ID | Scene | Bố cục gợi ý | Nội dung |
|---|---|---|---|
| OPN-001 | PRO-001 | 3 ô nhỏ | Quảng bá công cụ AI, giao diện tự động hóa, tin sa thải lan rộng |
| OPN-002 | PRO-001 | 1 ô panorama | Văn phòng trống xen những khu vực vẫn sáng đèn |
| OPN-003 | PRO-001 | 2 ô | Tin tiền thuê, khoản trả tín dụng và cuộc đua xin việc |
| OPN-004 | PRO-001→002 | 1 ô lớn | Camera từ màn tin chuyển đến chiếc bàn thật trong văn phòng |
| OPN-005 | PRO-002 | 2 ô | Bàn làm việc, lịch họp, đồng nghiệp đi qua; email đến |
| OPN-006 | PRO-002 | 1 ô tương tác | Người chơi **tự mở** email thông báo chấm dứt công việc |
| OPN-007 | PRO-002 | 1 ô dài tĩnh | Trở lại cùng khung văn phòng: mọi người vẫn làm việc |
| OPN-008 | PRO-003 | 2 ô | Đồng hồ reo, áo công sở trên ghế; nhân vật không cần đi làm |
| OPN-009 | PRO-003 | 3 ô thời gian | Laptop ứng tuyển, email tự động, hóa đơn |
| OPN-010 | PRO-003 | 1 ô tĩnh | Chiếc đồng hồ không còn báo thức |
| OPN-011 | PRO-004 | 1 ô rộng | Nhân vật ngồi xuống giường, ánh sáng căn hộ mờ dần |
| OPN-012 | PRO-004 | Nền tối | Tiếng xe giảm; sau tĩnh lặng là tiếng chim và gió |
| OPN-013 | PRO-004→CH01-001 | Fade vào game | **Không vẽ trước toàn cảnh rừng**; chuyển vào căn nhà cũ, A thức dậy |
| OPN-014 | CH01-001→002 | Gameplay 3D, không phải panel bắt buộc | A đi tới cửa, mở ra lần đầu thấy rừng rộng ngập nắng; sau đó khám phá và tìm lối mòn nhỏ |

**Quan trọng:** OPN-014 chỉ là mốc **bàn giao**. Không ép người chơi xem trước rừng trong comic. Các scene CH01 phải là tương tác gameplay, khi có nội thất/map phù hợp.

## Prototype khả thi theo 2 giai đoạn

**V0 — Test comic trước:** bắt đầu từ title screen có sẵn, click `Begin your day` → trình chiếu panel OPN-001..012 (tranh placeholder rõ ghi nháp cũng được) → chuyển tới gameplay Map 01 hiện tại; gắn nhãn **preview** thay vì giả vờ map đó là nhà của A. Tránh thay đổi map/nhân vật gốc. Test nút Next/Back/Skip, không mất focus/khóa input, không phát trùng ambience.

**V1 — Test chuyển giao đúng truyện:** khi có house interior và chỗ spawn A được duyệt, nối OPN-012 sang CH01-001, sau đó CH01-002. Đây là công việc riêng; hiện source chưa có cảnh phòng ngủ A theo kịch bản.

## Những vấn đề cần kỹ thuật xác minh trước khi làm
- Code branch `feature/map01-lighting-presets` có title UI `scripts/ui/storybook_screens.gd`; nút **Begin your day** hiện gọi `ui.exit_title_menu(false)` (vào gameplay), chưa có comic runner.
- `project.godot` hiện `run/main_scene="res://scenes/world/forest_hub.tscn"` nên không có scene prologue mặc định.
- Narrative docs nằm trên nhánh **story**, code nằm trên nhánh **feature**; để làm prototype cần mang **bản được duyệt** của data từ story sang code branch một cách rõ ràng, không tự merge các PR.
- Sử dụng `res://assets/story/comic/` cho panel được duyệt, dự kiến `res://scripts/ui/comic_intro.gd` hoặc scene Control tương đương; tất cả **đường dẫn là đề xuất**, chưa được tạo.
- V0 chưa cần save/quest system. Với F5 khi chưa có save: luôn chơi mở đầu hoặc có cờ debug skip; **không giả vờ hỗ trợ tiếp tục ván chơi**.
- Không tự chỉnh weather, Map 01, cafe/house model, nhân vật, hệ thống ngày đêm, UI Settings hiện có. Godot 4.6.3 Compatibility.
- Chạy import/headless smoke/UI tests và playtest bằng GUI; screenshot 720p/1080p, check Vietnamese glyph, focus, click, Enter, Esc, skip/replay, reduce motion, không mất quyền điều khiển.

## Chưa chốt
- Ảnh thật của các panel, portrait nhân vật ngoài đời, địa điểm thành phố và nghề nghiệp cụ thể.
- Có voice-over PRO-001 hay chỉ chữ, font cuối cùng, thời lượng mỗi panel, nhạc nền.
- Có tách tương tác email ra layer riêng trong comic hay để nó là panel tương tác.
- Panel nào được duyệt chính thức; số lượng panel có thể thay đổi sau khi dựng thử.

**Nguồn nội dung:** [Prologue](../chapters/prologue.md) · [CH01-001](../scenes/CH01-001.md) · [CH01-002](../scenes/CH01-002.md).
