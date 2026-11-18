# Quy ước kịch bản hội thoại & khám phá (Story Dialogue Contract)

> **Dành cho AI lập trình đọc kịch bản.** Đây là quy ước gắn nhãn dữ liệu **biên kịch**, không phải mã đã tích hợp. Tên nhân vật dùng **English**, lời thoại và ghi chú kịch bản dùng **tiếng Việt**.

## Nguyên tắc viết
- **Người chơi khám phá thế giới bằng hành động, quan sát và tự hỏi**, không bị NPC thuyết giảng cốt truyện.
- Không đưa thông tin về lịch sử, quê quán, gia đình, địa điểm, quy luật giấc mơ vào dialogue trừ khi đã chốt.
- NPC **có nhịp sống riêng**, không đứng chờ để giao nhiệm vụ. Người chơi chủ động tiếp cận, có thể bỏ qua/đi tiếp mà không làm hỏng cốt truyện.
- **Nội dung hội thoại đã đồng ý** có thể dài trong tài liệu biên kịch nhưng gameplay nên **chia thành các nhóm tự chọn**. Không phát hết transcript một lượt.
- Mỗi câu thoại gắn mã ID ổn định, **speaker_id**, **text_vi**; không đổi tên English và không tự dịch sang English trước khi người sáng tạo yêu cầu.

## Nhãn chức năng được áp dụng trong JSON

| Nhãn `type` | Mục đích | Cách hiển thị |
|---|---|---|
| `intro_dialogue` | Giới thiệu người mới khi người chơi chủ động nói chuyện lần đầu | Một lần, ngắn, sau đó hiện lựa chọn hỏi |
| `optional_dialogue` | Người chơi hỏi điều tò mò (nhà, người sống quanh đó) | Chỉ khi chọn chủ đề, không bắt đọc |
| `player_guidance` | Gợi một hướng đi/chuyện đời thường; **không phải quest** | Chỉ khi hỏi đường/cần gợi ý, không mũi tên bắt buộc |
| `environmental_story` | Âm thanh/hành động/vết tích giúp người chơi tự nhận ra thế giới | Không tự bật cửa sổ thoại |
| `ambient_repeat` | Lời chào/ngẫu hứng sau khi đã gặp; tránh lặp giới thiệu | Tùy trạng thái/time và sau cooldown do code quyết định |
| `lore_gated` | Những câu có thể xác nhận sự thật nhạy lore | **Mặc định không dùng** cho tới khi canon được duyệt |

## Mẫu thuộc tính

- `condition`: điều kiện xuất hiện, vd. `thomas_intro_heard=false`.
- `topic_choice`: lựa chọn hội thoại của người chơi, không phải lựa chọn phân nhánh số phận.
- `lines`: danh sách `line_id` đã có trong transcript.
- `once`: có phát một lần rồi khóa hay không.
- `set_flags`: những điều người chơi thật sự đã nghe/nhìn/biết.
- `guidance_only`: gợi ý tự nhiên, **không tự tạo objective, waypoint, resource, quest completion**.
- `can_exit`: người chơi có thể kết thúc hội thoại và tiếp tục khám phá mà không bị phạt.
- `status`: `confirmed`, `accepted_dialogue_v1`, `draft`, `not_approved`; **không** suy ra tệp JSON là executable.

## Với Thomas ở CH01-003
- Tên, lần gặp và việc đốn củi: **đã xác nhận**.
- Transcript đủ 29 dòng: **được đồng ý lưu** ở tài liệu; nhóm chia trình diễn còn là đề xuất.
- `THOMAS_INTRO`: nhóm mở một lần.
- `THOMAS_ABOUT_HOUSE`, `THOMAS_ABOUT_PEOPLE`, `THOMAS_DIRECTIONS`: tùy chọn.
- `THOMAS_REPEAT`: cần xây về sau, tuyệt đối không phát lại intro mỗi lần gặp.
- Câu “ở đây đôi khi người ta cũng phải mất một lúc mới nhớ ra vài thứ” được gắn **`character_opinion`**, không được viết thành rule giấc mơ.

**Lưu ý:** các cờ trạng thái là ngôn ngữ biên kịch cho AI lập trình triển khai; chưa có sự kiện nào được nối vào Godot.
