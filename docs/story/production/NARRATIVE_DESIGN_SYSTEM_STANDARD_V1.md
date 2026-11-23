# A Place to Belong — QUY CHUẨN HỆ THỐNG BIÊN KỊCH THẾ GIỚI MỞ (V1)

> **Mục đích:** Đây là tài liệu quy chuẩn để **tất cả AI biên kịch, người viết, AI lập trình và người kiểm thử** thống nhất cách tạo nội dung *A Place to Belong* trong tương lai.
>
> **Trạng thái:** Quy chuẩn tác nghiệp V1 — dùng làm chuẩn soạn/bàn giao nội dung mới. **Không phải tuyên bố engine đã hỗ trợ các schema dưới đây**; ví dụ YAML là hợp đồng đề xuất để đội dev chốt rồi triển khai.
>
> **Phạm vi:** Biên kịch, phân cảnh, đối thoại, NPC, sự kiện, nhiệm vụ, trạng thái thế giới và tác động dài hạn. **Không chỉnh gameplay/code, mesh, UI, môi trường hay asset.**
>
> **Đọc cùng:** [Nền tảng canon](../00-foundation.md) · [Thế giới mở](open-world-narrative-v0.md) · [Quy chuẩn chống đọc nhầm lời dẫn](narrative-dialogue-handoff-contract-v1.md) · [24 nhiệm vụ Làng A](../quests/village-a-relationship-arcs-v0.md) · [Bản đồ và hồ A1 được duyệt](../locations/a1-approved-exploration-v0.md).

---

## 1. Tư tưởng thiết kế: thế giới sống, không phải danh sách quest

Một thế giới sống cần có **chuyện xảy ra ngay cả khi A không đến**. NPC tự làm việc, gặp nhau, nghỉ ngơi, thay đổi suy nghĩ; người chơi có thể chứng kiến một phần, can thiệp, đến muộn hoặc hoàn toàn bỏ qua. Mỗi sự kiện có thể để lại dấu vết cho lần ghé sau: một lối đi bớt vướng, một cái bàn trống hơn, một lời chào đã khác.

**Công thức bắt buộc khi viết một EVENT:** **Điều kiện kích hoạt → Diễn biến → Lựa chọn (nếu có) → Hậu quả trước mắt → Ký ức/ảnh hưởng lâu dài**. Cần thêm **nhánh người chơi không tham gia** và **cách tiếp tục sau khi bỏ lỡ**.

- **Event KHÔNG đồng nghĩa Quest.** Trời mưa, NPC nghỉ một ngày, chiếc giỏ rơi trên đường, hai người trò chuyện là sự kiện; chưa chắc ai giao nhiệm vụ. Chỉ tạo quest khi có một mục tiêu rõ và người chơi **chủ động nhận** (trừ nội dung mở đầu đã được chốt riêng).
- **Story KHÔNG đồng nghĩa lịch quest tuyến tính.** Prologue có trình tự, nhưng Chapter 01 và Làng A là các mảnh đời có thể gặp theo nhiều thứ tự.
- **Một cảnh phải có quyền từ chối.** Không dùng thất bại đạo đức, trừ điểm thân thiết nặng hoặc khóa bản đồ vì A không nhận việc.
- **Không phải chuyện nào cũng cần bí mật lớn.** Game thiên về đời sống, khám phá, sự ấm áp và cảm giác thuộc về. Mâu thuẫn có thể là điều thường ngày; đừng tự biến mọi NPC thành người đang che giấu bí mật đen tối.
- **Có hậu quả thì phải nhìn/thấy lại được.** Hậu quả có thể rất nhỏ (một vật đã được sửa, NPC nói lời khác, người khác tự hoàn tất việc); không phải lúc nào cũng là tăng điểm hay mở map.

## 2. Canon, bản đồ và giới hạn không được vượt

### Đã thống nhất hoặc được người sáng tạo xác nhận

- Tên game là **A Place to Belong**; nhân vật chính dùng ký hiệu **A**. Mở đầu trong đời thực: áp lực thời AI, bị chấm dứt công việc **tại văn phòng**, thu mình trong căn hộ rồi thiếp ngủ.
- Thế giới XXX là **giấc mơ**, không được khẳng định là vũ trụ song song có thật. A tỉnh tại **căn nhà cũ vẫn sống được trong rừng**, ký ức đời thực mơ hồ.
- Khám phá rừng ngập nắng và lối mòn; **Thomas** là NPC đầu tiên ở bìa rừng đang bổ củi. **Giữ nguyên 29 mục thoại CH01-003 đã đồng ý**; trong số đó có một dòng chỉ dẫn diễn xuất, không phải lời nói.
- Làng A hướng tới **khoảng 30 cư dân**; 8 nhân vật cốt lõi đã có **24 nhiệm vụ biên kịch nháp** (mỗi người Q1, Q2, QF), không giao liên tục.
- **Hồ A1 đã được duyệt là địa điểm khám phá**; có thể viết sinh hoạt/quan sát hợp lý ở bờ hồ. Việc NPC thực sự đi hồ, object tương tác cụ thể và những hành vi runtime **chưa được khẳng định đã triển khai**.
- Hệ vận chuyển hàng **sang làng khác** và săn bắn tùy chọn là định hướng gameplay; **chưa xây nội dung Làng B**, không tự có nơi nhận, tuyến đường hay NPC ở đó.

### Chưa được tự chốt

Tên chính thức của nhiều NPC/quan hệ gia đình và hộ cư trú; quá khứ chủ căn nhà A; quy luật giấc mơ lặp lại; bí mật thế giới; main plot bốn chương; ending; nghề café/bưu điện; minigame, lịch mùa/giờ và hệ thống weather đã kết nối vào event runtime. **Các đề xuất “người mất tích”, “lá thư bí mật”, “làng che giấu quá khứ”, “bốn chương lớn, ba ending” trong tài liệu tham khảo chỉ là ý tưởng, KHÔNG tự nhập canon.**

**Phân loại bắt buộc ở đầu mọi file mới:** **CANON_APPROVED / CREATOR_APPROVED_LOCATION / DRAFT_STORY / PROPOSED_GAMEPLAY / READY_FOR_IMPLEMENTATION / IMPLEMENTED_VERIFIED**. Một tài liệu chỉ được gán cấp cao hơn khi có căn cứ. Địa điểm được duyệt không có nghĩa toàn bộ kịch bản tại đó đã duyệt.

## 3. Phân biệt bảy thành phần (và World State)

| Thành phần | ID nên dùng cho nội dung mới | Trách nhiệm | KHÔNG được nhầm với |
|---|---|---|---|
| **STORY / CHAPTER** | CH01, CH02… | Gom chủ đề, tiến triển câu chuyện ở mức lớn; không chứa toàn bộ thoại | Danh sách nhiệm vụ phải hoàn thành |
| **SCENE** | SCN-A1-…; giữ ID CH01-001 cũ | Một tình huống cụ thể ở địa điểm/thời điểm phù hợp, có thể chỉ là khám phá | Bắt buộc chạy như phim/cutscene |
| **QUEST** | Giữ VLA01-Q1…; mới dùng Q-… | Mục tiêu A tự nhận, các bước có thao tác thực, kết quả | Mọi sự kiện hằng ngày |
| **DIALOGUE** | DLG-A1-…; giữ line ID cũ | Câu NPC/A, lựa chọn và điều kiện được phép nói | Mô tả bối cảnh hoặc lời biên kịch |
| **CHOICE** | CHO-A1-… | Người chơi quyết định một nhánh; biết điều kiện, tác dụng và câu thoại | Câu đã tự động nói |
| **EVENT** | EV-A1-… | Điều xảy ra khi thỏa điều kiện, có hoặc không có A; có thể kích hoạt một *lời mời* quest | Quest tự khởi động |
| **NPC** | Giữ VLA-01…VLA-30, Thomas | Hồ sơ, tính cách, lịch sinh hoạt, ký ức, hành vi | Nhân vật đứng yên chờ nhiệm vụ |
| **WORLD STATE** | Dùng namespace rõ: world.*, npc.*, quest.*, event.* | Ghi nhận thế giới và quyết định sau sự kiện, trong cùng save | Lời thoại hay điều kiện bằng văn xuôi |

**Giữ nguyên toàn bộ ID đang tồn tại.** ID mới không đè VLA/CH01/PRO cũ; không tự đổi tên Thomas, NPC hoặc file. **Một ID chỉ được định nghĩa một lần**, các chỗ khác chỉ tham chiếu.

**Quan hệ giữa chúng (không ép một chiều):**

~~~text
CHAPTER (nhóm nội dung, không khóa thứ tự)
   ├─ SCENE ─→ DIALOGUE ─→ CHOICE ─→ WORLD STATE
   ├─ EVENT ─→ (có thể tạo SCENE hoặc phát hiện dấu vết)
   │             └─ (có thể ĐỀ NGHỊ QUEST, không tự nhận)
   ├─ QUEST ─→ WORLD_ACTION (người chơi thật sự làm) ─→ WORLD STATE
   └─ NPC (có lịch & ký ức riêng) ←→ EVENT / DIALOGUE / WORLD STATE
~~~

## 4. Sáu nhóm sự kiện của *A Place to Belong*

| Nhóm | Nội dung phù hợp | Khi A vắng mặt | Đặc biệt tránh |
|---|---|---|---|
| **DAILY_LIFE** | Hazel xem luống, Owen sửa đồ, Maeve nghỉ tay, Grace ngồi ăn | Có thể diễn ra thường xuyên; nhớ nhịp sinh hoạt | Mọi hoạt động thành quest |
| **DYNAMIC** | Mưa khiến mép lối mòn ẩm, một nhánh cây rơi, con thú đi ngang | Sự kiện nhỏ tự giải quyết hoặc để lại dấu vết | Thiên tai liên tục, event spam, khóa đường duy nhất |
| **EXPLORATION** | Đến bờ hồ, tìm đường vòng, thấy chỗ nghỉ | Có thể chờ người chơi khám phá; không cần NPC giải thích | Tự sinh hang bí mật/kho báu/lore |
| **SOCIAL** | Hai cư dân nhờ nhau, hiểu lầm nhỏ, chia việc, cùng nấu ăn | Quan hệ giữa NPC thay đổi độc lập với A | Bắt mọi NPC yêu/ghét nhau theo lịch cố định |
| **STORY** | Biến cố có trọng lượng với A và một NPC, tâm sự sâu khi đủ tin cậy | Giữ cửa sổ quan sát hoặc nhánh tường thuật sau; không bỏ lỡ toàn bộ nội dung quan trọng | Ép người chơi phải có mặt đúng một giờ |
| **WORLD** | Thay đổi mùa, buổi sinh hoạt chung, cư dân cùng chăm đường | Có dấu vết lâu dài theo thời gian | Tự công bố mở vùng mới/đại lễ hội khi chưa duyệt |

**Độ ưu tiên đề xuất:** critical story (chỉ khi được duyệt) > relationship beat đang chín muồi > sự kiện đời thường nổi bật > ambient. Không cho hai sự kiện tranh cùng một NPC ở cùng thời điểm. Event Director là **ý tưởng điều phối**, chưa có bằng chứng engine đã hỗ trợ.

## 5. Khung thời gian và điều phối sự kiện (đề xuất)

Mỗi sự kiện cần khai báo:

1. **Trigger:** player enters/interacts, NPC schedule, time/weather change, hoặc world-state change.
2. **Guards:** địa điểm có thật, NPC có mặt và rảnh (nếu nói chuyện), quan hệ/tiến độ phù hợp, trạng thái sự kiện cũ.
3. **Frequency:** once_per_save, once_per_season, repeat_with_cooldown, ambient_repeat; khai báo đơn vị thời gian **chỉ khi runtime đã có**.
4. **Player window:** có cần A chứng kiến đúng lúc không, hay có thể tìm thấy dấu vết/hỏi lại?
5. **Competition/priority:** hai sự kiện có chiếm cùng NPC/đạo cụ không; nếu có phải hoãn được.
6. **Outcome:** A can thiệp, A từ chối, A đi xa, NPC tự làm; mọi đường đều phải có kết quả hợp lệ.
7. **Persistence:** cờ nào được ghi vào save; có reset theo mùa/lần ngủ không? **Chưa chốt thì ghi TO_DECIDE, không tự giả lập lịch giấc mơ**.
8. **Recovery:** nếu weather clock/NPC movement/object chưa hỗ trợ thì có fallback hợp lý, không phát thoại sai và không khóa khám phá.

### Quy tắc bảo vệ người chơi

- **Sự kiện nhỏ** có thể trôi qua. Nếu bỏ lỡ, A vẫn thấy biến đổi hoặc nghe chuyện khi gặp lại.
- **Sự kiện quan hệ quan trọng** nên có nhiều dịp xuất hiện; không mất cả tuyến nhân vật chỉ vì một lần vắng mặt.
- **Sự kiện cốt truyện lớn** chỉ triển khai sau khi duyệt, có cơ chế tự kiểm điều kiện bảo vệ và lối khôi phục.
- Không sử dụng trời mưa/ban đêm như “điều kiện bắt buộc” cho nhiệm vụ đã tồn tại nếu weather/day-night chưa được xác minh là chạy được.

## 6. Một sự kiện = năm lớp biên kịch, thêm các nhánh ngoài dự kiến

**Lớp 1 — SETUP / bối cảnh:** nơi xảy ra, NPC đang làm gì, điều gì thay đổi tự nhiên trong thế giới. **Không phát thành lời nói.**

**Lớp 2 — TRIGGER & CONDITIONS:** điều kiện có thể kiểm, ví dụ A tới ven hồ, đã gặp Rowan, đoạn đất ẩm có mặt; **không tự thay bằng văn kể “khi thấy thích hợp”**.

**Lớp 3 — PLAYER OPTIONS:** nhìn qua, hỏi, tham gia, từ chối, rời đi; **lựa chọn phải có điều kiện rõ**, không tự cho A nói tất cả.

**Lớp 4 — WORLD ACTION / PROOF:** nếu chọn tham gia, A cần **thực sự quan sát/đặt/dời/thử** vật hoặc bước tới đúng nơi. Bấm hết thoại KHÔNG hoàn thành hành động.

**Lớp 5 — OUTCOMES & MEMORY:** sau sự kiện NPC nói và ứng xử khác theo trạng thái, vật thể/đường đi thay đổi nếu đã làm, lời thoại về sau phản ánh đúng ai đã giúp.

**Nhánh bắt buộc phải xét:** SUCCESS_BY_PLAYER, DECLINED, WALKED_AWAY, RESOLVED_WITHOUT_PLAYER, NPC_ABSENT, PRECONDITION_NOT_MET. Có thể gộp nhánh không làm gì khi hai nhánh có hậu quả thực sự giống nhau, nhưng phải ghi lý do.

## 7. RANH GIỚI TUYỆT ĐỐI: LỜI DẪN KHÔNG PHẢI THOẠI

| Nhãn loại nội dung | Ví dụ | Hiển thị thành thoại NPC? |
|---|---|---|
| **SCENE_CONTEXT** | “Rowan đang nhìn vệt đất ẩm cạnh lối đi.” | **KHÔNG** |
| **WORLD_ACTION** | “A quan sát hai lối, thử bước qua vùng khô.” | **KHÔNG** |
| **STATE_TRANSITION** | “Ghi lake_path_observed = true.” | **KHÔNG** |
| **NPC_DIALOGUE** | Rowan: “Lối này vừa khô hơn một chút.” | **CÓ nếu trigger đúng** |
| **PLAYER_CHOICE** | “Tôi muốn xem thêm con đường.” | **Hiện lựa chọn; KHÔNG tự đọc** |
| **PLAYER_LINE** | A: “Tôi đi qua được rồi.” | **Chỉ nói nếu đã chọn/đã làm và được duyệt** |

Mỗi câu phát ra **phải có line_id, speaker_id, text_vi hoặc tham chiếu text, event_trigger, guards và vị trí trong luồng**. **Không chỉ dựa vào dấu ngoặc kép trong Markdown** để xác định đó là thoại. Các dòng **MỤC ĐÍCH**, **TÌNH HUỐNG**, **TRẢI NGHIỆM**, **HÀNH ĐỘNG**, **KẾT QUẢ**, **NẾU...** phải được giữ ở kênh mô tả biên kịch, không đưa vào ô thoại hay voice over.

**Tuyệt đối:** không lặp cả 29 mục Thomas thành một đoạn đọc liên tục, không đọc dòng chỉ dẫn diễn xuất CH01-003 như lời Thomas; không phát A tự kể đã tới hồ khi A chưa đi; không nói A giúp nếu NPC tự làm. Xem [Evelyn Q2 — flow kiểm nhánh](../quests/village-a-evelyn-q2-flow-v1.md).

## 8. Tổ chức thư mục: hai tầng nhưng KHÔNG phá repo hiện tại

**Thực tế đã có:** docs/story chứa **chapters/**, **scenes/**, **quests/**, **dialogue/**, **characters/**, **locations/**, **activities/**, **production/** và file JSON nháp. Chúng vẫn là **nguồn biên kịch**, chưa phải game_data runtime đã được xác minh.

**Mô hình tương lai (ĐỀ XUẤT, chưa tạo thư mục bằng file này):**

~~~text
docs/story/
  00-foundation.md
  README.md
  production/
    NARRATIVE_DESIGN_SYSTEM_STANDARD_V1.md  <-- file này
    narrative-dialogue-handoff-contract-v1.md
  chapters/    scenes/    quests/    dialogue/    characters/
  locations/   activities/
  narrative_data/                           <-- CHƯA TẠO / chưa runtime
    chapters/ scenes/ quests/ dialogues/
    choices/ events/ npcs/ world_state/
    localization/ schemas/
~~~

**Quy trình:** Người viết soạn narrative Markdown có liên kết → reviewer duyệt tính nhất quán → AI/dev chuyển thành dữ liệu có cấu trúc → validator kiểm tra → engine parser tích hợp/kiểm thử → đánh dấu IMPLEMENTED_VERIFIED. **Không duy trì hai bản logic độc lập**. Khi có mismatch, bản được duyệt ở nguồn biên kịch là chuẩn ý nghĩa; runtime phải được kiểm lại, không tự sửa canon theo data cũ.

**YAML hay JSON:** có thể dùng YAML để người viết đọc và JSON cho parser, nhưng chỉ khi dev thống nhất schema. Các mẫu dưới đây **KHÔNG phải format engine đã chạy được**.

## 9. Quy ước ID, file, liên kết tham chiếu

- **Không đổi** ID đã viết: PRO-001, CH01-003, VLA-01, VLA01-Q1, VLA15-Q2, các line ID CH01003-L… và toàn bộ tham chiếu hiện hành.
- **Nội dung mới:** dùng tiền tố có phạm vi: EV-A1-LAKE-001, SCN-A1-LAKE-001, DLG-A1-LAKE-001, CHO-A1-LAKE-001. Nếu thêm quest mới khi đã duyệt: Q-SIDE-A1-001 (chỉ là quy ước; không tự phát sinh quest).
- Một file **một thực thể chính** hoặc một flow con có ID gốc; metadata luôn có: id, type, title_vi, status, story_owner, location_ref, depends_on, related_ids, revision, source_refs, designer_notes.
- **Mọi tham chiếu tới ID phải tồn tại**, trừ giá trị rõ ràng là TO_BIND/TO_DECIDE. ID đã được cấp mà chưa có đối tượng thì phải gắn trạng thái UNRESOLVED, không cho vào READY_FOR_IMPLEMENTATION.
- Lời thoại phải có source_ref đến dòng gốc nếu dùng lại; không sao chép thành hai bản text dễ lệch nhau. Hạn chế viết nguyên văn thoại trong file quest nếu đã có line ID ở dialogue bank.
- File và đường dẫn GitHub phải trỏ tới **đúng nhánh/commit** khi dùng làm baseline; không diễn giải object thử nghiệm thành gameplay đã có.

## 10. Template bắt buộc cho MỖI nội dung mới (Markdown dành cho người viết)

**Sao chép khối dưới để viết một cảnh/event/quest.** Nếu trường không áp dụng, ghi NOT_APPLICABLE thay vì âm thầm bỏ, nhất là phần A vắng mặt và hậu quả.

~~~markdown
# [ID] — [TÊN SỰ KIỆN / CẢNH / NHIỆM VỤ]

- STATUS: DRAFT_STORY
- TYPE: STORY | SCENE | EVENT | QUEST | DIALOGUE | SOCIAL
- CATEGORY: DAILY_LIFE | DYNAMIC | EXPLORATION | SOCIAL | STORY | WORLD
- CHAPTER_REF: CH01 / NONE
- LOCATION_REF: [ID vùng đã xác nhận / TO_BIND]
- NPC_REFS: [VLA-xx… / NONE]
- SOURCE_REFS: [file/commit liên quan]
- EXISTING_CANON: [đã duyệt là gì; tách rõ vị trí và tình tiết]
- NEW_PROPOSALS: [chưa duyệt là gì]
- REVISION: 0.1

## A. Ý đồ truyện (KHÔNG PHẢI THOẠI)
[Nhân vật đang đối diện điều gì; người chơi nên cảm thấy gì?]

## B. Tình huống sống thường ngày (KHÔNG PHẢI THOẠI)
[NPC làm gì TRƯỚC và SAU khi A ghé? Nếu A không ghé?]

## C. Điều kiện xuất hiện
TRIGGER: [event cụ thể]
GUARDS_ALL: [các điều kiện phải đủ]
GUARDS_ANY: [nếu có]
TIME_WEATHER: [điều kiện có thật / NOT_REQUIRED / TO_DECIDE]
PRIORITY: [nếu đồng thời có event khác]
COOLDOWN: [đề xuất hoặc TO_DECIDE]
REPEAT_POLICY: [once_per_save / repeat_with_cooldown / ...]
MISSING_RUNTIME_BINDING: [TO_BIND / NONE]

## D. Nhịp sự kiện (bối cảnh → lựa chọn → việc thật)
1. SCENE_CONTEXT: [thế giới đang xảy ra]
2. NPC_DIALOGUE: [line_id, speaker, trigger, guards — nếu có]
3. PLAYER_CHOICE: [choice_id, label, guards]
4. WORLD_ACTION: [object/area, event_required, bằng chứng hoàn thành]
5. STATE_TRANSITION: [flag nào đổi, điều kiện đổi]

## E. Hội thoại (KHÔNG viết thoại lẫn với stage direction)
- DLG_ID:
- LINE_ID:
- SPEAKER_ID:
- TEXT_VI:
- EVENT_TRIGGER:
- GUARDS:
- NEXT_NODE:
- DISPLAY_AS: NPC_DIALOGUE | PLAYER_LINE | PLAYER_CHOICE

## F. Nhánh và hậu quả
- PLAYER_HELPED: [việc thực, cờ trạng thái, lời gặp lại]
- DECLINED: [NPC có tiếp tục việc không, lời nói]
- WALKED_AWAY: [tiến trình còn dở, có thể quay lại không]
- NPC_SELF_RESOLVED: [ai thực sự hoàn thành, cập nhật vật và lời nhớ]
- PLAYER_ARRIVED_LATE: [dấu vết/đoạn kể thay thế]
- LONG_TERM: [tác động ở lần gặp sau; không chỉ thưởng điểm]
- NO_QUEST_BRANCH: [vẫn có thể khám phá hoặc trò chuyện]

## G. Ảnh hưởng tới thế giới
WORLD_FLAGS: [flag scope/type/default và người được phép đổi]
NPC_MEMORY_FLAGS: [nhớ hành động nào]
RELATION_CHANGES: [friendliness/trust, nếu có và được duyệt]
WORLD_VISUAL_CHANGE: [dấu vết; không tự tạo asset]
SAVE_PERSISTENCE: [lưu thế nào / TO_DECIDE]

## H. Tích hợp và test (KHÔNG PHẢI CODE)
EVENTS_TO_BIND: [sự kiện runtime dev phải phát]
NPC_PRESENCE_REQUIREMENTS: [ai phải có mặt để nói]
QUEST_OFFER_REQUIREMENTS: [nếu đây là quest, người chơi phải chủ động nhận]
FALLBACKS: [thiếu weather/NPC/object vẫn không kẹt]
TEST_CASES:
  - A chỉ quan sát
  - A giúp thật
  - A từ chối
  - A bỏ dở
  - NPC tự giải quyết
  - A đến muộn
  - NPC vắng mặt
  - Tới sai thứ tự / chưa đủ thân
APPROVAL_NOTES: [chưa chốt những gì]
~~~

### Riêng QUEST cần bổ sung

- **Quest có tên và mục tiêu cụ thể**; yêu cầu A chủ động ACCEPT. Có trạng thái AVAILABLE → ACCEPTED/IN_PROGRESS → COMPLETED, hoặc DECLINED / RESOLVED_WITHOUT_PLAYER.
- Mỗi stage có **action_required + engine_event_to_verify + NPC/report step nếu thật sự cần**. Không chỉ có câu thoại “xong rồi”.
- Bảo đảm **nhánh Q1/Q2/QF** mở bằng quan hệ (friendliness khác trust), hoạt động chung, ít nhất các lượt gặp đời thường đã định và context NPC phù hợp. Mốc 20/50/80 là **DRAFT**, chưa cài chết vào máy.
- **Không tự chain Q2 sau Q1** trong cùng một lần gặp; QF cần tâm sự/bond event.
- Phần thưởng có thể chỉ là vật dụng được sửa, sự tin cậy, câu chuyện và cảnh sinh hoạt mới. **Không tự thêm XP, vàng, vật phẩm** nếu chưa chốt cơ chế.

### Riêng NPC cần bổ sung

- Hồ sơ nhận dạng, tính cách, việc thường ngày, địa điểm đã đối chiếu, giờ giấc **đề xuất**.
- Sở thích, nguyên tắc riêng, các quan hệ khác trong roster **chỉ khi đã được duyệt**, câu họ biết và không biết (nhất là không được biết bí mật giấc mơ).
- **NPC daily loop**: đang làm gì khi A không nhìn; khi nghỉ; khi vắng; sau khi nhiệm vụ kết thúc; điểm/điều kiện để có cuộc gặp xã hội.
- Bộ nhớ **đã gặp / từng làm cùng / đã giúp / đã từ chối / đã hoàn thành hộ / đã tâm sự**, chứ không chỉ một điểm số.

## 11. Ví dụ xuyên suốt: “Con đường ẩm sau mưa” — DRAFT MINH HỌA

**Tình huống được sử dụng:** **Rowan (VLA-09)** chăm đường rừng, **bờ hồ A1** đã được duyệt làm địa điểm, có thể ẩm sau mưa khi hệ thời tiết hỗ trợ. **Đây là ví dụ phương pháp viết, KHÔNG tuyên bố có event này trong game, không tạo nhiệm vụ mới.**

**Diễn tiến sống động:**

1. Nếu thời tiết thực tế phù hợp, một đoạn mép đường ven hồ có đất ẩm. Rowan đi xem vì đó là việc thường ngày, **không chờ A**.
2. Nếu A đi qua, A có thể **nhìn** vết đi vòng, hỏi Rowan (nếu ông thực sự có mặt), hoặc bỏ qua.
3. Nếu A đã đạt điều kiện **VLA09-Q2** và chủ động nhận việc đã viết, tình trạng này có thể dùng làm một **bối cảnh** cho nhiệm vụ tìm lối an toàn, **không thay thế ID nhiệm vụ hoặc tự hoàn thành nó**.
4. Nếu A không can thiệp, Rowan tự dời nhánh/chỉ hướng đi khô hơn sau một khoảng thời gian được thiết kế. Khi A đến muộn, chỉ thấy con đường đã dễ đi hơn hoặc được Rowan nhắc lại; **không gán công cho A**.
5. Lần tới, nếu đã hỗ trợ, Rowan nhận ra A; nếu Rowan tự làm, lời thoại phản ánh điều đó. Lối rừng và hồ **không bị khóa** dù A không làm.

~~~yaml
# DEMO data contract — KHÔNG phải file runtime
id: EV-A1-LAKE-001
type: EVENT
category: DYNAMIC
status: DRAFT_STORY
location_ref: A1_LAKE_SHORE        # cần map binding
npc_refs: [VLA-09]
trigger:
  kind: world_condition
  signal: terrain_wet_near_lake   # TO_BIND; không mặc định đã có
conditions:
  all:
    - flag: event.EV_A1_LAKE_001_done
      equals: false
conflicts_with: [npc_busy_in_other_scene]
priority: ambient
repeat_policy: once_per_save
start_without_player: true
player_can_ignore: true
quest_auto_start: false
outcomes:
  player_observed:
    set: [event.EV_A1_LAKE_001_seen]
  player_helped:
    require: [player_action_verified, VLA09_Q2_accepted]
    set: [npc.VLA09_player_helped_path]
  npc_self_resolved:
    require: [npc_resolution_verified]
    set: [npc.VLA09_self_cleared_path]
  player_arrived_late:
    show: physical_trace_or_npc_revisit_line
dialogue:
  only_if_npc_present: true
  line_ref: TO_BIND_NEW_LINE_ID
fallback:
  if_weather_not_supported: do_not_auto_start_event
  if_npc_not_present: no_npc_dialogue
  if_player_never_arrives: npc_may_resolve_with_trace
~~~

**Đọc ví dụ thế nào:** Đây **không** phải một quest “sửa đường quanh hồ” mới. Event này có thể không xảy ra, hoặc kết thúc khi A vắng mặt. Nếu được biên kịch/dev duyệt, nó có thể **cung cấp ngữ cảnh** cho Q2 của Rowan, không tự thay đổi nội dung đã duyệt của Q2.

**Tách thêm lớp thoại khi có lời mới (chỉ minh họa, chưa duyệt):**

~~~yaml
id: DLG-A1-LAKE-001
type: NPC_DIALOGUE
speaker_id: VLA-09
text_vi: "Đất ven đường còn ẩm. Cứ đi phía khô là được."
trigger: player_selects_topic_ask_about_path
guards:
  - npc_present
  - event.EV_A1_LAKE_001_seen
  - event.EV_A1_LAKE_001_done == false
next_node: END
~~~

Không đưa “Rowan đi kiểm đoạn đường ẩm” vào text_vi. Nếu Rowan không ở đó thì **không phát câu nào**.

## 12. World State: mọi hậu quả phải có chủ và quy tắc lưu

**Mỗi flag mới cần khai báo:** name, scope (world/npc/quest/event/player), type (boolean/enum/int), default, allowed_writer, meaning, persistence, reset_policy, save_version, consumers.

~~~yaml
# DEMO — chưa được engine công nhận
name: npc.VLA09_path_outcome
scope: npc
type: enum
values: [unknown, player_helped, self_resolved]
default: unknown
allowed_writers: [EV-A1-LAKE-001]   # chỉ khi event được duyệt
persistence: per_save
reset_policy: TO_DECIDE_ACROSS_DREAM_SESSIONS
consumers: [VLA09_REVISIT_DIALOGUE]
~~~

**Không đồng nhất:** MET với FRIEND, FRIENDLINESS với TRUST, OFFERED với ACCEPTED, ACCEPTED với DONE, NPC_SELF_RESOLVED với PLAYER_COMPLETED. Không tăng quan hệ vô hạn bằng chào lặp; tính một lượt gặp khi A thực sự rời hội thoại/đổi lượt theo quy ước runtime đã chốt.

**Ảnh hưởng phải có điều kiện loại trừ:** lựa chọn “A giúp” và “NPC tự làm” không cùng là kết quả của một việc; nếu cả hai có thể tác động lên cùng đối tượng, chỉ một kết quả cuối được ghi nhận theo trình tự thực tế.

## 13. Event Director và các manager: hợp đồng dành cho dev, KHÔNG bắt dev viết lại engine

Các lớp trách nhiệm đề xuất: Story (chương), Quest (stage), Dialogue (lời/choice), Event (điều kiện), NPC Schedule/Relationship (sinh hoạt/quan hệ), World State (flags), Condition Evaluator (guards), Action Executor (effects).

**Dev phải rà hệ thống hiện có trước** rồi mới quyết định tái sử dụng hay bổ sung. Không tự tạo tám Manager mới nếu chức năng đã nằm trong hệ thống hiện hữu. AI biên kịch chỉ giao **dữ liệu và giao kèo**, không gán tên class Godot, node path hoặc signal như thể đã có.

Khi triển khai thật cần đảm bảo: **một tác dụng chỉ áp dụng một lần**; không phát lại phần thưởng/cờ hoàn tất khi người chơi nói lại; save/load giữ đúng quest dở và ký ức; event cùng NPC không chạy chồng; điều kiện khó xảy ra có fallback; không spawn NPC trái lịch hoặc phát giọng từ xa.

## 14. Pipeline và Definition of Done (bắt buộc)

**Bước 1 — Writer:** tạo MD theo template, tra canon và map đã duyệt, viết rõ điều kiện/nhánh, phân loại từng dòng, đánh dấu đề xuất.

**Bước 2 — Narrative review:** kiểm continuity (Thomas, giấc mơ, NPC, 30 cư dân, Làng A, hồ), tính cách, quyền lựa chọn, hậu quả nhìn thấy, nhánh vắng mặt.

**Bước 3 — Data handoff:** chuyển thành JSON/YAML theo schema **đã được dev thống nhất**. Từng line_id tham chiếu duy nhất; không đọc Markdown vào dialogue UI.

**Bước 4 — Validation:** ID tồn tại, graph không có dead-end bất ngờ, nhánh choice có đích, event có điều kiện kích hoạt, quest có thể hoàn tất, chống lặp tác dụng.

**Bước 5 — Test nhiều trạng thái:** lần gặp đầu, chưa đủ thân, từ chối, nhận rồi đi, NPC tự giải quyết, tới trễ, đi hồ/chưa đi hồ, NPC vắng mặt, save/load (khi đã có).

**Bước 6 — Creator gate:** chỉ khi người sáng tạo duyệt nội dung mới đổi sang **CANON_APPROVED**; chỉ khi chạy trong game và được kiểm thử mới đổi sang **IMPLEMENTED_VERIFIED**. Hai cấp duyệt khác nhau.

### Checklist duyệt một file kịch bản mới

- [ ] Đã tra 00-foundation và các tuyến/ID gốc
- [ ] Đã đối chiếu map/NPC/địa điểm được duyệt; không khẳng định asset chưa dựng
- [ ] Có mục đích cảm xúc + bối cảnh **không phát thoại**
- [ ] Có rõ EVENT hay QUEST (không đánh đồng)
- [ ] Có trigger/guards/frequency/nhánh A không đến
- [ ] NPC vẫn sống khi A vắng mặt; nếu NPC không ở đó, không phát lời NPC
- [ ] Có hành động thật và event xác nhận trước khi quest COMPLETED
- [ ] Có từ chối, hoãn, bỏ dở, NPC tự giải quyết và gặp lại đúng trạng thái
- [ ] Lời thoại chỉ phát với line_id/speaker/trigger; lời lựa chọn không tự đọc
- [ ] Không tăng độ thân và phát quest bằng spam chào
- [ ] Không ép người chơi làm ba quest trong ba lần gặp liên tiếp
- [ ] Không mở Làng B, bí mật giấc mơ hoặc ending chưa duyệt
- [ ] Thay đổi thế giới có flag và nguồn writer xác định
- [ ] Mọi ID/link tồn tại hoặc đánh dấu TO_BIND/TO_DECIDE
- [ ] Thử nhánh success/declined/late/self-resolved, không kẹt tiến trình
- [ ] Có trạng thái duyệt và chủ trách nhiệm của lần thay đổi
- [ ] Không tự gắn nhãn “đã chạy trong Godot” nếu mới có MD/JSON

## 15. Áp dụng cho 24 nhiệm vụ đã viết và cách làm về sau

**Tài sản hiện có:** 8 tuyến core × 3 quest = **24 nhiệm vụ đã viết ở mức biên kịch**; ngân hàng thoại Làng A cho 30 NPC; một số tình huống đời thường; **Ada/Grace đã có typed dialogue v2**, **Evelyn Q2 có pilot flow**. **Không đồng nghĩa 24 quest đã chạy trong Godot.**

- **Không xóa/đổi tên bản cũ.** Giữ chúng làm nguồn ý tưởng, tính cách, lời thoại, hậu quả.
- **Chuyển từng tuyến sang chuẩn mới:** ưu tiên các tuyến dễ gặp đầu tiên (Hazel, Owen), tiếp theo Clara/Rowan/Maeve/Evelyn; rà Ada/Grace theo cùng schema cuối do dev thống nhất.
- Mỗi hoạt động cũ cần bổ sung: ID sự kiện, điều kiện xuất hiện, người nói thực, khả năng A bỏ qua, hành động chứng minh hoàn thành, dấu vết sau vài lần quay lại, fallback NPC tự làm.
- **Thêm Event Catalog trước khi viết hàng trăm quest mới**: xây một khu nhỏ Làng A → rừng → bờ hồ với vài chuỗi sự kiện liên kết để xem AI lập trình có đọc đúng.
- Có thể viết **bản văn xuôi RAW để người sáng tạo duyệt cảm xúc**, nhưng bản RAW **KHÔNG BAO GIỜ** là file dữ liệu đưa vào hội thoại/runtime. Khi nội dung đã duyệt, chuyển về file theo template và các node typed.

### Thứ tự tạo nội dung mới từ nay

**Đầu tiên: ý đồ truyện + Event Catalog → sau đó: phân cảnh/đối thoại/choice → nếu cần mới thành Quest → World State và test → cuối cùng JSON/YAML để dev tích hợp.** Không bắt đầu bằng việc sáng tác hàng trăm lời thoại rời rồi yêu cầu AI khác đoán lúc phát.

---

**Kết luận:** Chỉ khi **đúng người, đúng lúc, đúng việc, đúng ký ức** mới phát sinh câu chuyện. Bản đồ có thể lớn, nhưng phần khiến người chơi muốn quay lại chính là những việc tiếp tục xảy ra dù A không đứng đó nhìn.
