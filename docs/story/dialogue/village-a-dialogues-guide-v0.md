# Làng A — Bộ hội thoại 30 cư dân (v0, biên kịch)

> **Tình trạng:** 30 hồ sơ nhân vật đã có trong roster, nhưng tên/tuổi/cá tính cụ thể vẫn là **bản đề xuất**. Các câu thoại ở đây cũng là **DRAFT CHƯA DUYỆT**, không giả định đã triển khai. Chỉ Làng A; **chưa viết Làng B**. Thomas ở bìa rừng và **không nằm trong 30 cư dân**.

## Danh sách file

| Nhóm cư dân | Kịch bản đọc được | Dữ liệu nhóm |
|---|---|---|
| 01–10: Hazel → Silas | [Markdown](village-a-dialogues-01-10.md) | [JSON](village-a-dialogues-01-10.json) |
| 11–20: Tessa → Liam | [Markdown](village-a-dialogues-11-20.md) | [JSON](village-a-dialogues-11-20.json) |
| 21–30: Nia → Caleb | [Markdown](village-a-dialogues-21-30.md) | [JSON](village-a-dialogues-21-30.json) |

**[Dữ liệu thống nhất cho 30 người](village-a-dialogues-v0.json)** là nguồn kiểm tra điều kiện và mã thoại: **30 cư dân, 292 câu mới, 240 nhóm, 30 hoạt động người chơi có thể chọn**. Hazel/Owen dùng lại 12 lượt tham chiếu ID thoại từ CH01-007 thay vì lưu trùng câu.

Các tài liệu nguồn: [hồ sơ tính cách 30 cư dân](../characters/village-a-roster.md), [CH01-007](../scenes/CH01-007.md), [quy ước kể chuyện thế giới mở](../production/open-world-narrative-v0.md).

## Hướng dẫn AI lập trình đọc — không phát thành một bộ phim**Hội thoại NPC ↔ NPC:** [6 đoạn ngắn nghe thoáng qua](village-a-overheard-v0.md), [JSON](village-a-overheard-v0.json). Chỉ chạy khi đủ hai NPC, không chồng lên lời thoại với người chơi; không yêu cầu A có mặt.



**Một cuộc trò chuyện không phải phát toàn bộ 10 câu.** Nếu chưa gặp, người chơi chủ động nói thì phát `intro` một lần; sau đó hiển thị các **chủ đề có điều kiện** như “Hỏi công việc”, “Đề nghị giúp”, “Tạm biệt”. Câu NPC khi bận là riêng. Thoại `revisit` chỉ tới từ lần gặp lại; `familiar` cần đã **cùng làm hoạt động + gặp lại + quan hệ thực sự quen** và người chơi chọn hỏi chuyện riêng.

| Stage trong nhóm JSON | Khi nào phát | Điều cần ghi |
|---|---|---|
| `intro` | `!met` + người chơi chủ động bắt chuyện | `met` mới thành true |
| `ask_activity` | Đã gặp + chọn hỏi hoạt động | Không nhận quest |
| `offer_help` | Đã gặp + chủ động đề nghị + NPC đang có việc | Chỉ giới thiệu hoạt động, chưa tính hoàn thành |
| `after_help` | **Khi thực sự làm xong** hành động trên bản đồ | `activity_done`; có thay đổi môi trường/lời nhớ |
| `decline` | Người chơi chọn không làm khi được đề nghị | NPC vẫn tiếp tục việc; không phạt nặng |
| `revisit` | Một lần quay lại thực sự sau khi kết thúc cuộc nói chuyện trước | Không phát lại `intro` |
| `familiar` | Đã giúp, quay lại và đạt mức quen + chọn hỏi chuyện | Gợi tâm tính, không tự kể lore |
| `busy` | NPC đang bận và A chủ động hỏi | Một câu ngắn, không gây cutscene |

**Không có `trusted` ở bộ này.** Sự kiện tin cậy sâu và nội dung quest riêng cần được chốt theo từng nhân vật, **không mở chỉ bằng spam câu chào hoặc điểm**.

## Hợp đồng thoại kỹ thuật ở mức biên kịch

- Mỗi NPC dùng ID `VLA-01`…`VLA-30`, không dùng tên làm khóa lưu vì tên vẫn đề xuất.
- Mỗi line có ID cố định, `speaker_id` và `text_vi`; một nhóm chứa `own_line_ids` và có thể có `legacy_CH01_007_line_ids`. Nếu có legacy, **đọc đúng từ CH01-007.json**, không tạo thêm câu mới thay nó.
- Trong `VLA-01` (Hazel) và `VLA-04` (Owen), câu giới thiệu/đề nghị phụ/hoàn thành **đã có trong CH01-007**. Câu mới ở ngân hàng là **biến thể hoặc tiếp nối**; không phát hai bản chồng nhau. Hazel có hai lời gặp lại cũ G11/G12 tùy đã giúp hay chưa; câu mới R01 là một lựa chọn xoay vòng sau đó.
- `shared_activity` là **một công việc tự chọn có thao tác thật**; không đưa vào nhật ký như nhiệm vụ dài. `activity_done` không tự bật khi chỉ bấm “Tôi giúp”.
- Nếu người chơi bỏ qua hoặc rời đi, NPC **tự tiếp tục**. Không biến từ chối thành lỗi đạo đức, không khóa rừng/nhà.
- `familiar` cần **đã làm thật và gặp lại**; `trusted` cần một sự kiện riêng được viết/duyệt, chưa có trong bộ này.
- Nơi và thói quen của từng người giữ theo roster nháp, **không chốt khung giờ, mùa, quan hệ gia đình, phần thưởng, công thức điểm thân thiết** từ ngân hàng thoại.
- Trẻ em Finn/Olive/Will/Ben/Kit chỉ chơi, học việc nhẹ hoặc quan sát; không săn, vận chuyển nặng hay dùng dụng cụ nguy hiểm.
- Ada/Hugo chỉ kiểm kiện và nói về **đường liên làng**; **không mở giao hàng thực tế** khi chưa có làng đích/người nhận. Peter và Miles chỉ chuyển/sắp đồ trong Làng A. Rowan chăm lối đi, **không tự mặc định** ông là thợ săn.
- Không có câu thoại nào tự giải thích giấc mơ XXX, quá khứ A, căn nhà hoặc cốt truyện chính.

## Cách phát triển tiếp ở Làng A, sau khi duyệt bộ nền

Trước tiên viết thêm **hội thoại NPC với NPC** để cư dân tự nói chuyện; sau đó phát triển câu chuyện quan hệ 8 nhân vật tuyến sâu (Hazel, Owen, Clara, Rowan, Maeve, Evelyn, Ada, Grace) có **sự kiện phát sinh cụ thể, lựa chọn và hệ quả**. Các cư dân khác vẫn có hội thoại đời thường/lần gặp lại. Không cần chuyển sang xây Làng B.

**Trạng thái bàn giao:** Đây là *kịch bản có cấu trúc*, không phải code Godot hay nội dung đã chạy.
