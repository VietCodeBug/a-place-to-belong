# Làng A — Hội thoại phân nhánh và NPC tự trò chuyện V2

**DRAFT_STORY — không chứa event hoặc nhiệm vụ.** Các lựa chọn A là menu, không tự nói. Mỗi nhánh chỉ phát câu trả lời tương ứng. Các đoạn NPC–NPC vẫn diễn ra nếu A không có mặt, chỉ nghe được khi ở gần và cả hai NPC có mặt đúng lịch. Không tự chuyển thành quest, không tăng điểm bằng lặp hội thoại. Mọi tình tiết cá nhân mới và lịch còn chờ duyệt.

## DLG-VLA01-V2-TOPIC — Cây hay người khó chiều hơn?

AREA: west_garden; TRIGGER: player_initiates_optional_topic; GUARDS: npc.met, npc_available_and_near_garden.

- `DLG-VLA01-V2-TOPIC-OPEN` **VLA-01:** “Cậu nhìn cái luống này xem. Chăm cây có một điểm dễ hơn chăm người: chúng không giả vờ là mình không cần nước.”

- **PLAYER_CHOICE:** Vậy cô dễ hiểu hơn cái cây chứ?
  - `DLG-VLA01-V2-TOPIC-JOKE` **VLA-01:** “Tùy ngày. Hôm nay hỏi lại sau khi tôi uống nước đã.”
- **PLAYER_CHOICE:** Cô có thích trồng gì ngoài rau không?
  - `DLG-VLA01-V2-TOPIC-CURIOUS` **VLA-01:** “Có chứ. Có hôm tôi chỉ muốn trồng một thứ chẳng cần thu hoạch.”
- **PLAYER_CHOICE:** Tôi đi dạo tiếp đây.
  - END — không thêm thoại.

## DLG-VLA04-V2-TOPIC — Một ngày không sửa gì

AREA: craft_yard; TRIGGER: player_initiates_optional_topic; GUARDS: npc.met, npc_available_and_not_using_tools.

- `DLG-VLA04-V2-TOPIC-OPEN` **VLA-04:** “Cậu nghe thấy gì không? Không có tiếng cưa. Tôi đang thử xem một ngày như vậy sẽ thế nào.”

- **PLAYER_CHOICE:** Chắc cái ghế cũng được nghỉ.
  - `DLG-VLA04-V2-TOPIC-JOKE` **VLA-04:** “Ừ. Nó không phải làm việc với tôi nữa.”
- **PLAYER_CHOICE:** Ông thường làm gì vào ngày nghỉ?
  - `DLG-VLA04-V2-TOPIC-CURIOUS` **VLA-04:** “Đi bộ. Đôi lúc nhìn những món đồ mình chẳng có ý định sửa.”
- **PLAYER_CHOICE:** Tôi đi dạo tiếp đây.
  - END — không thêm thoại.

## DLG-VLA06-V2-TOPIC — Món bánh đáng ngờ

AREA: central_square; TRIGGER: player_initiates_optional_topic; GUARDS: npc.met, npc_available_and_has_time_to_chat.

- `DLG-VLA06-V2-TOPIC-OPEN` **VLA-06:** “Felix bảo bánh của tôi có hình dạng rất sáng tạo. Cậu nghe có giống lời khen không?”

- **PLAYER_CHOICE:** Nghe giống cách nói lịch sự của người sợ bị mời ăn thêm.
  - `DLG-VLA06-V2-TOPIC-JOKE` **VLA-06:** “Đấy! Tôi cũng nghĩ vậy. Lần sau tôi sẽ hỏi thẳng.”
- **PLAYER_CHOICE:** Cô thích thử món mới hay món quen hơn?
  - `DLG-VLA06-V2-TOPIC-CURIOUS` **VLA-06:** “Món mới, nếu không có người đứng sau lưng đếm từng phút.”
- **PLAYER_CHOICE:** Tôi đi dạo tiếp đây.
  - END — không thêm thoại.

## DLG-VLA09-V2-TOPIC — Đi mà không có đích

AREA: forest_path; TRIGGER: player_initiates_optional_topic; GUARDS: npc.met, npc_available_and_safe_path.

- `DLG-VLA09-V2-TOPIC-OPEN` **VLA-09:** “Hôm nay tôi đã đi hết một đoạn đường rồi lại quay về. Không có cành nào cần dọn cả.”

- **PLAYER_CHOICE:** Vậy là một buổi làm việc thất bại?
  - `DLG-VLA09-V2-TOPIC-JOKE` **VLA-09:** “Không. Một buổi đi dạo thành công.”
- **PLAYER_CHOICE:** Ông thích đoạn đường nào nhất?
  - `DLG-VLA09-V2-TOPIC-CURIOUS` **VLA-09:** “Đoạn mà cây che hết tiếng ở làng. Không phải vì tôi ghét làng đâu.”
- **PLAYER_CHOICE:** Tôi đi dạo tiếp đây.
  - END — không thêm thoại.

## DLG-VLA13-V2-TOPIC — Mũi chỉ lệch

AREA: craft_yard; TRIGGER: player_initiates_optional_topic; GUARDS: npc.met, npc_available_and_not_using_tools.

- `DLG-VLA13-V2-TOPIC-OPEN` **VLA-13:** “Có một thứ tôi đang thử làm cho vui. Tôi còn chưa biết nó sẽ thành gì.”

- **PLAYER_CHOICE:** Hay đặt tên trước rồi tính sau?
  - `DLG-VLA13-V2-TOPIC-JOKE` **VLA-13:** “Thế thì chắc nó sẽ mang một cái tên rất hay và chẳng có hình dạng gì.”
- **PLAYER_CHOICE:** Không có mẫu sẵn à?
  - `DLG-VLA13-V2-TOPIC-CURIOUS` **VLA-13:** “Không. Lần này tôi muốn thử xem mình chọn gì nếu không phải làm cho người khác.”
- **PLAYER_CHOICE:** Tôi đi dạo tiếp đây.
  - END — không thêm thoại.

## DLG-VLA15-V2-TOPIC — Cuốn sổ không ghi hết

AREA: west_garden; TRIGGER: player_initiates_optional_topic; GUARDS: npc.met, npc_available_and_can_chat.

- `DLG-VLA15-V2-TOPIC-OPEN` **VLA-15:** “Tôi từng ghi một trang dài về một buổi sáng. Đọc lại thì chẳng nhớ hôm đó có đẹp hay không.”

- **PLAYER_CHOICE:** Bà nên chừa một ô đánh dấu 'đẹp'.
  - `DLG-VLA15-V2-TOPIC-JOKE` **VLA-15:** “Một ô thôi à? Có lẽ tôi cần thêm ô 'đáng ngồi lại'.”
- **PLAYER_CHOICE:** Bà thích nhớ điều gì nhất?
  - `DLG-VLA15-V2-TOPIC-CURIOUS` **VLA-15:** “Những thứ không nhất thiết phải ghi. Tiếng người đến gần, chẳng hạn.”
- **PLAYER_CHOICE:** Tôi đi dạo tiếp đây.
  - END — không thêm thoại.

## DLG-VLA18-V2-TOPIC — Cuộc tranh luận về lối tắt

AREA: village_square; TRIGGER: player_initiates_optional_topic; GUARDS: npc.met, npc_available_and_can_chat.

- `DLG-VLA18-V2-TOPIC-OPEN` **VLA-18:** “Hugo nói một lối tắt của tôi dài hơn đường chính. Tôi đang cố tìm cách phản bác.”

- **PLAYER_CHOICE:** Có lẽ cậu đang đo khoảng cách bằng số câu chuyện.
  - `DLG-VLA18-V2-TOPIC-JOKE` **VLA-18:** “Thế thì tôi thắng chắc. Đường ấy có nhiều chuyện hơn hẳn.”
- **PLAYER_CHOICE:** Cậu thích đi một mình hay đi cùng ai đó?
  - `DLG-VLA18-V2-TOPIC-CURIOUS` **VLA-18:** “Cả hai. Đi một mình dễ đổi hướng. Đi cùng người khác thì có người nhắc mình về đúng giờ.”
- **PLAYER_CHOICE:** Tôi đi dạo tiếp đây.
  - END — không thêm thoại.

## DLG-VLA23-V2-TOPIC — Một buổi chiều không có việc

AREA: central_square; TRIGGER: player_initiates_optional_topic; GUARDS: npc.met, npc_available_and_currently_resting.

- `DLG-VLA23-V2-TOPIC-OPEN` **VLA-23:** “Hôm nay tôi đã định ngồi chơi. Rồi tôi mất một lúc nghĩ xem ngồi chơi thì nên làm gì.”

- **PLAYER_CHOICE:** Bà đang làm rất tốt việc ngồi chơi đấy.
  - `DLG-VLA23-V2-TOPIC-JOKE` **VLA-23:** “Cảm ơn. Hiếm có việc nào tôi làm mà được khen ngay như thế.”
- **PLAYER_CHOICE:** Bà muốn đi đâu nếu có cả buổi chiều rảnh?
  - `DLG-VLA23-V2-TOPIC-CURIOUS` **VLA-23:** “Ra chỗ nào nghe thấy người qua lại, nhưng không có ai gọi tôi vào bếp.”
- **PLAYER_CHOICE:** Tôi đi dạo tiếp đây.
  - END — không thêm thoại.

## DLG-A1-V2-CHAT-01

AREA: central_square; TRIGGER: npc_pair_conversation_occurs; GUARDS: both_present_and_idle_and_preparing_no_active_event, no_conflicting_event.

- `DLG-A1-V2-CHAT-01-L1` **VLA-18:** “Tôi nghĩ cái túi này vẫn còn chỗ.”
- `DLG-A1-V2-CHAT-01-L2` **VLA-19:** “Chỗ trống không phải lời mời nhét thêm đồ.”
- `DLG-A1-V2-CHAT-01-L3` **VLA-18:** “Cậu nói y như cái túi có ý kiến riêng ấy.”
- `DLG-A1-V2-CHAT-01-L4` **VLA-19:** “Nó có. Lần trước nó đã đứt quai.”

## DLG-A1-V2-CHAT-02

AREA: central_square; TRIGGER: npc_pair_conversation_occurs; GUARDS: both_present_and_idle, no_conflicting_event.

- `DLG-A1-V2-CHAT-02-L1` **VLA-06:** “Anh nếm chưa mà đã gật đầu?”
- `DLG-A1-V2-CHAT-02-L2` **VLA-07:** “Tôi đang ủng hộ tinh thần.”
- `DLG-A1-V2-CHAT-02-L3` **VLA-06:** “Thế thì ủng hộ thêm bằng cách nếm đi.”
- `DLG-A1-V2-CHAT-02-L4` **VLA-07:** “Đấy là chỗ tôi hơi lo.”

## DLG-A1-V2-CHAT-03

AREA: village_forest_edge; TRIGGER: npc_pair_conversation_occurs; GUARDS: both_present_and_idle, no_conflicting_event.

- `DLG-A1-V2-CHAT-03-L1` **VLA-10:** “Ông đi cả buổi mà không mang gì về à?”
- `DLG-A1-V2-CHAT-03-L2` **VLA-09:** “Mang đôi giày đầy đất về.”
- `DLG-A1-V2-CHAT-03-L3` **VLA-10:** “Thế cũng được. Tôi có thể đan cho ông cái giỏ đựng đất.”
- `DLG-A1-V2-CHAT-03-L4` **VLA-09:** “Để đất ở chỗ của nó đi.”

## DLG-A1-V2-CHAT-04

AREA: safe_public_square; TRIGGER: npc_pair_conversation_occurs; GUARDS: both_children_present_and_safe_public_area, no_conflicting_event.

- `DLG-A1-V2-CHAT-04-L1` **VLA-08:** “Đấy là con gì vậy?”
- `DLG-A1-V2-CHAT-04-L2` **VLA-28:** “Con ngựa.”
- `DLG-A1-V2-CHAT-04-L3` **VLA-08:** “Sao nó có bánh xe?”
- `DLG-A1-V2-CHAT-04-L4` **VLA-28:** “Để chạy nhanh hơn ngựa thường.”

[JSON dữ liệu](VILLAGE_A_BRANCHING_DIALOGUE_V2.json).
