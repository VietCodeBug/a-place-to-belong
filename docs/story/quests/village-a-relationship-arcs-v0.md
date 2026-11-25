# Làng A — Tuyến nhiệm vụ theo độ thân thiết (8 cư dân chính, v0)

> **CẬP NHẬT V2:** Bản này giữ nguyên ID, gate và nội dung V0 làm nguồn lịch sử. Bản viết lại đề xuất hiện nằm ở [Quest V2](VILLAGE_A_QUEST_SCRIPTS_V2.md) và [thoại riêng](../dialogue/VILLAGE_A_QUEST_DIALOGUE_V2.md). Không chạy cả hai bản cùng lúc hoặc trộn câu thoại cũ với tình huống V2. Chưa duyệt từng nhiệm vụ, chưa code.

> **Hướng mới đã thống nhất:** Không phải gặp lần đầu là giao việc; mỗi nhân vật tuyến sâu có **nhiệm vụ 1 → giai đoạn sinh hoạt bình thường → nhiệm vụ 2 → giai đoạn quen thân → nhiệm vụ cuối**, mở theo **độ thân thiết + sự kiện đã trải qua**. Nhân vật tiếp tục hoạt động sau nhiệm vụ cuối. **Nội dung 24 nhiệm vụ và điểm số bên dưới là nháp biên kịch**, chưa phải canon hoặc code chạy trong game. Chỉ viết Làng A, không thêm Làng B.

## Mở nhiệm vụ thế nào?

| Giai đoạn | Điều kiện tối thiểu đề xuất | Những gì có thể diễn ra khi chưa có nhiệm vụ |
|---|---|---|
| Chưa quen / gặp lần đầu | Chưa có nhiệm vụ | Chào ngắn, hỏi việc, tự chọn giúp việc rất nhỏ (không phải quest) |
| **Nhiệm vụ 1** | Quen mặt (ví dụ thân thiết ≥20/100), đã có một hoạt động chung **và đã quay lại** | NPC chỉ nhờ nếu đúng tình huống, A được nhận hoặc từ chối |
| **Giữa Q1 và Q2** | Q1 xong nhưng chưa đủ thân / chưa có lần gặp thường | NPC trò chuyện, làm việc, nói về kết quả, không tự giao Q2 |
| **Nhiệm vụ 2** | Thân quen (ví dụ ≥50/100), Q1 xong, có ≥1 lần gặp thường sau Q1 | Việc gắn sâu hơn với khó khăn hoặc ước muốn thật của NPC |
| **Giữa Q2 và cuối** | Q2 xong, cần ≥2 lần gặp thường và một câu chuyện quan hệ riêng | Đời sống, gặp lại, tâm sự; có thể không xuất hiện quest dù điểm đã đủ |
| **Nhiệm vụ cuối** | Tin cậy (ví dụ ≥80/100), Q2 xong, đã có sự kiện gắn bó và NPC đúng hoàn cảnh | Lựa chọn của A để lại dấu thay đổi, **không làm NPC biến mất** |

**20 / 50 / 80 là số đề xuất để minh họa**, có thể cân bằng sau. **Điểm chưa đủ** để tự tạo quest: cần trạng thái nhân vật, chuyện đã xảy ra, NPC đang rảnh và người chơi chủ động nhận. Không bắt làm đủ cả ba để mở toàn bộ Làng A.

## Kịch bản gameplay chi tiết đã viết tiếp

Cả tám tuyến Hazel, Owen, Clara, Rowan, Maeve, Evelyn, Ada và Grace đã có **bản biên kịch nhiệm vụ chi tiết** riêng để người thực hiện gameplay hiểu các thao tác và lựa chọn, thay vì coi bản 24 nhiệm vụ này như các cutscene tuần tự:

- **Hazel:** [kịch bản đầy đủ 3 nhiệm vụ](village-a-hazel-playable-v1.md) · [JSON](village-a-hazel-playable-v1.json) — quan sát đất, chia việc chăm vườn, hình thành góc vườn chung. Có **5 tình huống gặp thường và tâm sự** xen giữa, không bắt gặp một lần xong truyện.
- **Owen:** [kịch bản đầy đủ 3 nhiệm vụ](village-a-owen-playable-v1.md) · [JSON](village-a-owen-playable-v1.json) — kiểm ghế, sửa cánh cửa khu làm việc, học đặt giới hạn khi nhận việc. Có **5 tình huống gặp thường và tâm sự** xen giữa.
- **Clara:** [kịch bản đầy đủ 3 nhiệm vụ](village-a-clara-playable-v1.md) · [JSON](village-a-clara-playable-v1.json) — bữa ăn đủ ngon, thử cách làm món quen, ngồi ăn cùng mọi người. Có **5 cuộc gặp/tâm sự** giữa chặng và lựa chọn ăn cùng hoặc rời đi.
- **Rowan:** [kịch bản đầy đủ 3 nhiệm vụ](village-a-rowan-playable-v1.md) · [JSON](village-a-rowan-playable-v1.json) — dọn tối thiểu lối đi, tìm đường vòng giữ hoa, hướng dẫn chung để mọi người chăm đường. Có **5 cuộc gặp/tâm sự** giữa chặng, không khóa đường rừng.
- **Maeve:** [kịch bản đầy đủ 3 nhiệm vụ](village-a-maeve-playable-v1.md) · [JSON](village-a-maeve-playable-v1.json) — ở sân thủ công A05, sửa vải, học giới hạn việc, chia sẻ kỹ năng. Có cuộc gặp nghỉ ngơi **ven hồ đã duyệt** tùy chọn sau tuyến cuối.
- **Evelyn:** [kịch bản đầy đủ 3 nhiệm vụ](village-a-evelyn-playable-v1.md) · [JSON](village-a-evelyn-playable-v1.json) — ở vườn phía tây, ghi nhãn hạt và học quan sát; Q2 có nhánh **đi bộ tới bờ hồ** (tùy chọn), QF hướng dẫn người mới.
- **Ada:** [3 nhiệm vụ có trigger rõ ràng](village-a-ada-dialogue-flow-v2.md) · [JSON](village-a-ada-dialogue-flow-v2.json) — hai mốc đường quen, kiểm kiện với Hugo, ghi hướng về. Có đoạn gặp tùy chọn ở hồ; **không tự đưa hàng sang Làng B**.
- **Grace:** [3 nhiệm vụ có trigger rõ ràng](village-a-grace-dialogue-flow-v2.md) · [JSON](village-a-grace-dialogue-flow-v2.json) — dành chỗ ngồi cho mình, chia việc bữa ăn, ngồi dùng bữa từ đầu. A ở lại hay rời đi có câu thoại và lời nhớ khác nhau.

**Tiến độ viết sâu: 8 tuyến × 3 nhiệm vụ = 24/24 nhiệm vụ khung có bản biên kịch gameplay.** Ada/Grace bổ sung 6 nhiệm vụ chi tiết với 18 bước hành động, 11 cuộc gặp/tâm sự và ID thoại mới; giữ nguyên các line gốc O1/A1/C1/D1. **Cảnh báo bàn giao:** Ada và Grace dùng schema typed v2, Evelyn Q2 đã có pilot; 18 nhiệm vụ còn lại ở định dạng v1 nên **không được đưa trực tiếp vào game như thoại chạy tuần tự**. Các mốc thân thiết 20/50/80 vẫn chỉ là đề xuất cân bằng.

## Luật giãn cách nhiệm vụ

- Sau **mọi nhiệm vụ**, đặt cờ `arc_stage_completed`; NPC trở về công việc hằng ngày và có lời chào/đối thoại trạng thái mới.
- `nonquest_meetups_after_Q1` phải là một cuộc gặp thật sau Q1, khi A chỉ trò chuyện hay làm việc thường, không phải mở lại hội thoại nhiều lần trong cùng lượt.
- `nonquest_meetups_after_Q2` phải có ít nhất hai lần gặp riêng biệt; chưa ấn định số ngày vì chu kỳ giấc mơ/ngày chưa chốt.
- Mỗi NPC chỉ có **tối đa một lời mời quest mới đang chờ**. NPC bận, vắng, hoặc A không muốn nói thì không phát đề nghị.
- Từ chối nghĩa là **không nhận**; việc NPC vẫn tiếp tục, có thể có dịp hỏi lại sau. Nếu NPC tự xong trước, lưu `resolved_without_player`; **chặng sau có thể mở nếu đủ thân thiết và các lần gặp thường**, không khóa vĩnh viễn. NPC **không được cảm ơn A vì việc A chưa làm**: đoạn kể khi gặp lại phải phân biệt `completed` và `resolved_without_player`.
- Nhận lời chưa xong: lưu `accepted/in_progress`; chỉ hoàn thành sau **hành động thực** và phản hồi NPC, không phải nghe câu chuyện.
- Nhiệm vụ cuối kết thúc **tuyến ba chặng**, không phải cuộc đời nhân vật. Sau đó các hoạt động chung, sinh hoạt mùa và câu chuyện nhẹ vẫn tiếp tục.
- Mỗi nhiệm vụ có cách hoàn thành, từ chối hoặc NPC tự làm; các lựa chọn thay đổi chi tiết và câu gặp lại, không tạo kịch tính nhân tạo hoặc phần thưởng tiền bắt buộc.

## 8 tuyến nhiệm vụ ba chặng — đề xuất

### VLA-01 — Hazel: Học cách chia sẻ việc chăm sóc khu vườn

*Tính cách gốc:* thẳng thắn, kiên nhẫn. *Hạt giống tuyến truyện:* Ngại nhờ người khác vì quen tự xoay xở; tuyến học cách chia việc với hàng xóm.

**Nhiệm vụ 1 — Luống rau cần để mắt** (`VLA01-Q1`)

**Tình huống:** Sau những lần A tự hỏi và tham gia chăm luống mới, Hazel thấy một góc đất có cây mọc yếu hơn.

**Việc người chơi làm thật:** Cùng Hazel kiểm hai luống, so đất khô/ẩm, chỉ tưới vùng cần nước và báo lại quan sát.

**Lựa chọn:** Tưới theo thói quen hoặc hỏi Hazel xem đất đã cần nước chưa; chỉ cách quan sát cẩn thận mới được tính là hỗ trợ tốt.

**Hệ quả nếu giúp:** Hai luống được theo dõi; Hazel nhớ A biết quan sát trước khi hành động.

**Nếu không giúp:** Hazel tự kiểm và chăm sau khi A rời đi.

**Thoại ngắn (đều DRAFT):**
- `VLA01-Q1-O1` **Hazel:** “Có một luống tôi chưa yên tâm. Cậu có muốn xem đất cùng tôi không?”
- `VLA01-Q1-A1` **A (đồng ý):** “Để tôi xem chỗ nào thật sự cần tưới.”
- `VLA01-Q1-C1` **Hazel (sau thao tác hoàn thành):** “Được rồi. Cậu không vội tưới ngay... tôi thích thế.”
- `VLA01-Q1-D1` **Hazel (từ chối):** “Không sao, lát nữa tôi tự xem lại.”

**Nhiệm vụ 2 — Không thể tưới hết mọi nơi** (`VLA01-Q2`)

**Tình huống:** Sau một khoảng sinh hoạt bình thường, Hazel có hai công việc chăm vườn trùng lúc.

**Việc người chơi làm thật:** Cùng Hazel ghi hai việc cần làm; chọn giúp một việc và để Hazel tự sắp lại việc còn lại hoặc chủ động hỏi một người đang rảnh nếu họ đồng ý.

**Lựa chọn:** Khuyến khích Hazel chia sẻ công việc hay âm thầm làm hết thay cô; cả hai đưa đến cách cô nhìn A khác nhau.

**Hệ quả nếu giúp:** Lịch việc vườn bớt chồng chéo; Hazel thử nói rõ mình cần giúp gì.

**Nếu không giúp:** Hazel hoãn một việc không khẩn cấp và tự sắp xếp lại.

**Thoại ngắn (đều DRAFT):**
- `VLA01-Q2-O1` **Hazel:** “Hôm nay việc dồn vào một lúc. Tôi định cứ tự làm, nhưng... cậu nghĩ nên bắt đầu từ đâu?”
- `VLA01-Q2-A1` **A (đồng ý):** “Mình chia ra xem việc nào cần làm trước nhé.”
- `VLA01-Q2-C1` **Hazel (sau thao tác hoàn thành):** “Hóa ra nói ra một câu nhờ giúp cũng không khó như tôi tưởng.”
- `VLA01-Q2-D1` **Hazel (từ chối):** “Ừ, tôi sẽ chọn việc quan trọng trước.”

**Nhiệm vụ cuối — Một góc vườn cho mọi người** (`VLA01-QF`)

**Tình huống:** Sau khi tin A, Hazel muốn dành một góc luống làm nơi những người thích chăm cây có thể cùng tham gia.

**Việc người chơi làm thật:** Chọn góc trồng không cản lối chung, đặt hai cây non theo vị trí phù hợp và thống nhất cách chăm cùng Hazel.

**Lựa chọn:** Chọn góc dễ chăm hoặc góc nhiều nắng hơn; Hazel phản hồi theo điều kiện cây, không có lựa chọn đạo đức đúng/sai.

**Hệ quả nếu giúp:** Góc vườn chung trở thành dấu vết lâu dài; Hazel vẫn tự chăm khi A vắng, và bắt đầu chủ động xin giúp khi cần.

**Nếu không giúp:** Hazel vẫn trồng với những cư dân sẵn lòng; A có thể tới xem sau.

**Thoại ngắn (đều DRAFT):**
- `VLA01-QF-O1` **Hazel:** “Tôi muốn dành một góc nhỏ cho ai thích chăm cây đều có thể ghé. Cậu cùng chọn chỗ nhé?”
- `VLA01-QF-A1` **A (đồng ý):** “Chọn nơi mà ai cũng có thể chăm được.”
- `VLA01-QF-C1` **Hazel (sau thao tác hoàn thành):** “Lần đầu tôi không thấy lo khi để người khác cùng chăm một luống cây.”
- `VLA01-QF-D1` **Hazel (từ chối):** “Được thôi. Khi nào rảnh, cậu vẫn có thể đến xem.”

**Khoảng lắng trước nhiệm vụ cuối — sự kiện quan hệ (không phải quest):** Hazel thú nhận cô khó mở lời nhờ người khác, dù đôi khi cần một bàn tay phụ. Cờ `VLA01.personal_bond_event_seen` chỉ bật khi A tự chọn nói chuyện, không tự phát chỉ vì điểm thân thiết cao.

**Sau QF:** Hazel tiếp tục lịch sinh hoạt, có lời chào và hoạt động thường; không bị coi là đã hoàn thành toàn bộ nội dung của NPC.

### VLA-04 — Owen: Người sửa đồ học cách nhận sự giúp đỡ

*Tính cách gốc:* ít lời, cẩn thận. *Hạt giống tuyến truyện:* Quen giúp nhà khác trước, còn chiếc cửa nhà mình thì cứ để hỏng.

**Nhiệm vụ 1 — Chiếc ghế không chịu đứng yên** (`VLA04-Q1`)

**Tình huống:** A đã phụ chỉnh chốt lần trước; Owen đang xem một chiếc ghế dùng chung bị lỏng.

**Việc người chơi làm thật:** Chọn chân ghế cần kê, giữ ghế cho Owen chỉnh mối nối và thử độ vững trước khi để người khác dùng.

**Lựa chọn:** Thử ghế trước hay kiểm kỹ chỗ nối; Owen khen sự cẩn trọng chứ không tặng vật phẩm.

**Hệ quả nếu giúp:** Ghế dùng chung vững hơn, Owen nhớ cách A giúp.

**Nếu không giúp:** Owen kê chiếc ghế sang một bên và sửa lúc rảnh.

**Thoại ngắn (đều DRAFT):**
- `VLA04-Q1-O1` **Owen:** “Chiếc ghế này cần thêm một đôi tay giữ cho chắc. Cậu giúp tôi thử không?”
- `VLA04-Q1-A1` **A (đồng ý):** “Kiểm chỗ nối trước đã.”
- `VLA04-Q1-C1` **Owen (sau thao tác hoàn thành):** “Giờ thì ngồi được. Không phải món nào cũng nên sửa vội.”
- `VLA04-Q1-D1` **Owen (từ chối):** “Ừ. Để tôi kê nó sang bên đã.”

**Nhiệm vụ 2 — Cánh cửa để sau** (`VLA04-Q2`)

**Tình huống:** Khi quen hơn, A thấy cánh cửa ở góc làm việc của Owen vẫn bị kẹt vì ông cứ sửa đồ người khác trước.

**Việc người chơi làm thật:** Hỏi Owen có muốn sửa không, kiểm chỗ kẹt, cùng thử chỉnh bản lề và đóng mở lại.

**Lựa chọn:** A có thể nhắc Owen nghỉ tay hoặc đề nghị xử lý ngay; ông quyết định thời điểm phù hợp.

**Hệ quả nếu giúp:** Cửa hoạt động tốt hơn; Owen bắt đầu chú ý việc của chính mình.

**Nếu không giúp:** Owen để cửa trong trạng thái sử dụng tạm và tự sửa khi có thời gian.

**Thoại ngắn (đều DRAFT):**
- `VLA04-Q2-O1` **Owen:** “Cái cửa ở chỗ tôi vẫn kẹt. Cậu không cần làm hộ, nhưng... giữ giúp một lúc được không?”
- `VLA04-Q2-A1` **A (đồng ý):** “Để ông chỉ chỗ cần giữ.”
- `VLA04-Q2-C1` **Owen (sau thao tác hoàn thành):** “Lạ thật. Hóa ra việc của mình cũng có thể nhờ người khác.”
- `VLA04-Q2-D1` **Owen (từ chối):** “Được. Tôi sẽ bớt nhận thêm việc và tự sửa nó.”

**Nhiệm vụ cuối — Một buổi sửa đồ vừa đủ** (`VLA04-QF`)

**Tình huống:** Owen muốn dành một buổi sửa đồ chung nhưng sợ lại nhận quá nhiều món.

**Việc người chơi làm thật:** Cùng ông kiểm vài món được mang tới, chọn món sửa ngay và món hẹn sau, hỗ trợ chỉnh một món đơn giản.

**Lựa chọn:** Khuyến khích sửa hết một lượt hay ưu tiên món cần thiết và nghỉ đúng lúc; Owen thể hiện sự trưởng thành khác nhau.

**Hệ quả nếu giúp:** Góc sửa đồ có cách nhận việc rõ ràng; Owen dám nói 'hôm khác' và có thời gian cho mình.

**Nếu không giúp:** Owen tự giới hạn số đồ nhận và buổi sửa vẫn diễn ra.

**Thoại ngắn (đều DRAFT):**
- `VLA04-QF-O1` **Owen:** “Tôi muốn mở một buổi mọi người mang đồ cần sửa tới. Nhưng lần này phải biết dừng đúng lúc. Cậu giúp tôi sắp thứ tự nhé?”
- `VLA04-QF-A1` **A (đồng ý):** “Mình chọn việc quan trọng trước.”
- `VLA04-QF-C1` **Owen (sau thao tác hoàn thành):** “Cảm ơn. Hôm nay tôi đóng cửa góc sửa đồ đúng lúc.”
- `VLA04-QF-D1` **Owen (từ chối):** “Không sao. Tôi sẽ tự đặt giới hạn cho mình.”

**Khoảng lắng trước nhiệm vụ cuối — sự kiện quan hệ (không phải quest):** Owen kể rằng ông luôn ưu tiên sửa đồ của người khác và thấy ngại thừa nhận mình cũng cần giúp. Cờ `VLA04.personal_bond_event_seen` chỉ bật khi A tự chọn nói chuyện, không tự phát chỉ vì điểm thân thiết cao.

**Sau QF:** Owen tiếp tục lịch sinh hoạt, có lời chào và hoạt động thường; không bị coi là đã hoàn thành toàn bộ nội dung của NPC.

### VLA-06 — Clara: Niềm vui của những bữa ăn chưa hoàn hảo

*Tính cách gốc:* ấm áp, cầu toàn. *Hạt giống tuyến truyện:* Khó chấp nhận món ăn không hoàn hảo, dần học vui với bữa ăn có người cùng làm.

**Nhiệm vụ 1 — Bữa ăn đủ ngon** (`VLA06-Q1`)

**Tình huống:** Clara đang chuẩn bị một bữa nhỏ nhưng thiếu thời gian bày biện như mong muốn.

**Việc người chơi làm thật:** Chọn cách bày đơn giản, xếp bát và cùng Clara mang món ra khi còn nóng.

**Lựa chọn:** Đặt món ra đúng lúc hay mất thêm thời gian chỉnh từng chi tiết; người ăn có thể đánh giá món khác nhau nhưng không hủy bữa.

**Hệ quả nếu giúp:** Một bữa ăn diễn ra tự nhiên; Clara nhớ A đã ưu tiên người ngồi ăn.

**Nếu không giúp:** Clara tự bày nhanh và bữa ăn vẫn diễn ra.

**Thoại ngắn (đều DRAFT):**
- `VLA06-Q1-O1` **Clara:** “Tôi cứ sửa cái đĩa này mãi. Cậu giúp tôi bày phần còn lại trước nhé?”
- `VLA06-Q1-A1` **A (đồng ý):** “Món còn nóng thì mang ra trước đã.”
- `VLA06-Q1-C1` **Clara (sau thao tác hoàn thành):** “Mọi người ăn ngon thật. Có lẽ tôi lo quá.”
- `VLA06-Q1-D1` **Clara (từ chối):** “Ừ, để tôi bày nhanh hơn vậy.”

**Nhiệm vụ 2 — Thử một cách khác** (`VLA06-Q2`)

**Tình huống:** Sau vài lần trò chuyện, Clara muốn thử một cách chuẩn bị món quen với nguyên liệu đang có.

**Việc người chơi làm thật:** Cùng cô xem nguyên liệu, chọn cách chế biến/bày phù hợp, làm một phần công việc bếp đơn giản rồi nếm thử.

**Lựa chọn:** Thử biến thể mới hoặc giữ cách cũ; cả hai đều được phản ánh trong câu gặp lại.

**Hệ quả nếu giúp:** Clara dám thử lựa chọn không hoàn hảo mà không vứt món.

**Nếu không giúp:** Clara thử một mẻ nhỏ vào lúc khác.

**Thoại ngắn (đều DRAFT):**
- `VLA06-Q2-O1` **Clara:** “Tôi định làm khác một chút, nhưng sợ hỏng. Cậu thử cùng tôi một phần nhé?”
- `VLA06-Q2-A1` **A (đồng ý):** “Thử ít thôi, hợp thì lần sau làm tiếp.”
- `VLA06-Q2-C1` **Clara (sau thao tác hoàn thành):** “Không giống tôi định ban đầu... mà cũng ngon.”
- `VLA06-Q2-D1` **Clara (từ chối):** “Tôi sẽ thử một ít trước.”

**Nhiệm vụ cuối — Ngồi xuống ăn cùng nhau** (`VLA06-QF`)

**Tình huống:** Clara quen đứng phục vụ đến khi người khác ăn xong; cô muốn thay đổi.

**Việc người chơi làm thật:** Giúp chuẩn bị bàn với những ai tự nguyện, phân phần đơn giản, và mời Clara cùng ngồi ăn thay vì chạy đi chỉnh món.

**Lựa chọn:** A có thể tự bày một phần hay đề nghị người đang rảnh giúp; không ép người chơi điều khiển dân làng.

**Hệ quả nếu giúp:** Clara tham gia bữa ăn từ đầu; các lần gặp sau cô có thể rủ A ngồi ăn thay vì chỉ nhờ bày bàn.

**Nếu không giúp:** Clara chủ động mang món ra rồi ngồi với mọi người, dù A không tham gia.

**Thoại ngắn (đều DRAFT):**
- `VLA06-QF-O1` **Clara:** “Bữa này tôi muốn ngồi ăn từ đầu. Cậu giúp tôi để mọi thứ vừa đủ thôi được không?”
- `VLA06-QF-A1` **A (đồng ý):** “Ngồi xuống cùng mọi người mới là phần quan trọng.”
- `VLA06-QF-C1` **Clara (sau thao tác hoàn thành):** “Tôi không phải đứng lên sửa đĩa nào cả. Thật dễ chịu.”
- `VLA06-QF-D1` **Clara (từ chối):** “Ừ, tôi cũng phải học cách để mọi thứ đơn giản hơn.”

**Khoảng lắng trước nhiệm vụ cuối — sự kiện quan hệ (không phải quest):** Clara thú nhận cô thường sợ người khác thất vọng nếu món ăn không đẹp đúng ý. Cờ `VLA06.personal_bond_event_seen` chỉ bật khi A tự chọn nói chuyện, không tự phát chỉ vì điểm thân thiết cao.

**Sau QF:** Clara tiếp tục lịch sinh hoạt, có lời chào và hoạt động thường; không bị coi là đã hoàn thành toàn bộ nội dung của NPC.

### VLA-09 — Rowan: Giữ đường thông mà không mất sự sống của rừng

*Tính cách gốc:* điềm đạm, nguyên tắc. *Hạt giống tuyến truyện:* Muốn người đi lại thuận tiện mà không phá những thứ đang sống.

**Nhiệm vụ 1 — Lối đi sau vạt cỏ** (`VLA09-Q1`)

**Tình huống:** Sau khi đã cùng dọn nhánh cây, Rowan muốn A quan sát một đoạn đường khác khó nhìn mép lối.

**Việc người chơi làm thật:** Đi dọc đoạn đường cùng Rowan, nhận ra nơi cỏ dày và chỗ người đi bị vướng, chọn vị trí cần dọn tối thiểu.

**Lựa chọn:** Dọn rộng ngay hay chỉ dọn phần cản bước; Rowan phản hồi về hoa/cỏ còn lại.

**Hệ quả nếu giúp:** Một đoạn lối đi rõ hơn nhưng không trơ đất.

**Nếu không giúp:** Rowan tự dọn phần vướng nhỏ nhất.

**Thoại ngắn (đều DRAFT):**
- `VLA09-Q1-O1` **Rowan:** “Cậu đi cùng tôi xem đoạn này được không? Tôi muốn biết người mới sẽ bước qua chỗ nào.”
- `VLA09-Q1-A1` **A (đồng ý):** “Để xem đường tự nhiên đang dẫn đi đâu.”
- `VLA09-Q1-C1` **Rowan (sau thao tác hoàn thành):** “Đủ chỗ đi rồi. Phần còn lại cứ để cây mọc.”
- `VLA09-Q1-D1` **Rowan (từ chối):** “Được. Tôi xem sau một vòng nữa.”

**Nhiệm vụ 2 — Một đường vòng nhỏ** (`VLA09-Q2`)

**Tình huống:** Người đi thường tránh một góc ẩm, làm đất cạnh vạt hoa dại bị giẫm.

**Việc người chơi làm thật:** Quan sát hai đoạn đường ở rìa làng, chọn vị trí đi vòng an toàn hoặc đặt dấu hướng đi nhẹ nếu có vật sẵn được cho phép.

**Lựa chọn:** Ưu tiên đoạn ngắn hơn hay đoạn ít tác động lên hoa; đều hợp lý nếu bảo đảm người đi an toàn.

**Hệ quả nếu giúp:** Dấu lối đi tự nhiên thay đổi nhẹ, không cần phá cây hàng loạt.

**Nếu không giúp:** Rowan tự hướng người qua đoạn khô và chờ đất hồi phục.

**Thoại ngắn (đều DRAFT):**
- `VLA09-Q2-O1` **Rowan:** “Đường tắt làm vạt hoa bị dẫm nhiều quá. Cậu nhìn giúp xem nên đổi lối ở đâu?”
- `VLA09-Q2-A1` **A (đồng ý):** “Chọn một lối mọi người đi được mà cây cũng sống được.”
- `VLA09-Q2-C1` **Rowan (sau thao tác hoàn thành):** “Một đường vòng nhỏ đôi khi tiết kiệm được nhiều thứ.”
- `VLA09-Q2-D1` **Rowan (từ chối):** “Ừ, tôi sẽ xem lúc không đông người.”

**Nhiệm vụ cuối — Con đường mọi người cùng giữ** (`VLA09-QF`)

**Tình huống:** Rowan muốn để người dân tự chăm con đường thay vì cứ đợi một mình ông.

**Việc người chơi làm thật:** Cùng Rowan xem ba điểm cần chăm, ghi ý định ngắn cho khu chung và tự làm một điểm nhỏ không ảnh hưởng hoa.

**Lựa chọn:** Đánh dấu rõ chỗ cần dọn hoặc để hướng dẫn tối giản; Rowan nhớ cách A cân bằng an toàn và thiên nhiên.

**Hệ quả nếu giúp:** Đường rừng có dấu chăm sóc nhỏ từ cộng đồng; Rowan không còn thấy mình phải làm mọi việc.

**Nếu không giúp:** Rowan ghi lại các điểm cần chăm, nhờ ai rảnh tự nguyện tham gia.

**Thoại ngắn (đều DRAFT):**
- `VLA09-QF-O1` **Rowan:** “Tôi muốn mọi người biết đoạn nào cần chăm mà không phải lúc nào cũng hỏi tôi. Cậu giúp thử một cách đơn giản nhé?”
- `VLA09-QF-A1` **A (đồng ý):** “Mình ghi đúng thứ cần làm, đừng dọn cả khu rừng.”
- `VLA09-QF-C1` **Rowan (sau thao tác hoàn thành):** “Được. Con đường này không phải việc của riêng tôi.”
- `VLA09-QF-D1` **Rowan (từ chối):** “Không sao. Tôi sẽ bắt đầu từ một chỗ dễ thấy.”

**Khoảng lắng trước nhiệm vụ cuối — sự kiện quan hệ (không phải quest):** Rowan cho biết ông từng quen phát quang quá gọn, đến khi nhận ra những bụi hoa dại cũng là một phần con đường. Cờ `VLA09.personal_bond_event_seen` chỉ bật khi A tự chọn nói chuyện, không tự phát chỉ vì điểm thân thiết cao.

**Sau QF:** Rowan tiếp tục lịch sinh hoạt, có lời chào và hoạt động thường; không bị coi là đã hoàn thành toàn bộ nội dung của NPC.

### VLA-13 — Maeve: Người vá đồ biết cách nhờ người khác

*Tính cách gốc:* tỉ mỉ, kín đáo. *Hạt giống tuyến truyện:* Giỏi giúp người khác nhưng ngại nói mình cũng cần giúp.

**Nhiệm vụ 1 — Miếng vá vừa tay** (`VLA13-Q1`)

**Tình huống:** Sau lần chọn màu chỉ, Maeve đang cân nhắc hai đường vá cho một món đồ dùng chung được chủ cho phép sửa.

**Việc người chơi làm thật:** Xem chỗ rách, chọn cách khâu chắc hay giấu đường chỉ, giúp chuẩn bị chỉ rồi Maeve tự vá.

**Lựa chọn:** Ưu tiên bền hoặc ít lộ; Maeve phản hồi theo công dụng món đồ, không có đáp án đạo đức.

**Hệ quả nếu giúp:** Món đồ được sửa theo lựa chọn; Maeve nhớ ý kiến của A.

**Nếu không giúp:** Maeve chọn cách vá phù hợp nhất với mục đích dùng.

**Thoại ngắn (đều DRAFT):**
- `VLA13-Q1-O1` **Maeve:** “Chỗ rách này có hai cách vá. Cậu xem giúp tôi cách nào hợp hơn nhé?”
- `VLA13-Q1-A1` **A (đồng ý):** “Mình xem món đồ cần bền tới mức nào đã.”
- `VLA13-Q1-C1` **Maeve (sau thao tác hoàn thành):** “Cậu không chọn chỉ vì nó đẹp. Tôi thích cách cậu nghĩ.”
- `VLA13-Q1-D1` **Maeve (từ chối):** “Ừ, tôi sẽ cân nhắc thêm trước khi khâu.”

**Nhiệm vụ 2 — Một chồng đồ đang đợi** (`VLA13-Q2`)

**Tình huống:** Maeve ngại nhờ nên đồ sửa dồn lại ở góc làm việc.

**Việc người chơi làm thật:** Cùng cô phân loại việc gấp và không gấp, chuẩn bị những món được phép sửa, thỏa thuận chừa việc nào sang lần sau.

**Lựa chọn:** Làm ngay hết hay sắp thứ tự và dừng đúng lúc; Maeve không bị ép nhận mọi đồ.

**Hệ quả nếu giúp:** Góc sửa đồ bớt chồng chất; Maeve thử nói rõ việc nào cần được giúp.

**Nếu không giúp:** Maeve chủ động hẹn lại một số món và tự sắp kệ.

**Thoại ngắn (đều DRAFT):**
- `VLA13-Q2-O1` **Maeve:** “Tôi định làm hết hôm nay, nhưng nhìn đống này lại thấy ngợp. Cậu giúp tôi xếp lại thứ tự được không?”
- `VLA13-Q2-A1` **A (đồng ý):** “Không cần xong hết trong một ngày.”
- `VLA13-Q2-C1` **Maeve (sau thao tác hoàn thành):** “Nói 'để lần sau' cũng không khó như tôi tưởng.”
- `VLA13-Q2-D1` **Maeve (từ chối):** “Không sao. Tôi sẽ tự bắt đầu từ món cần nhất.”

**Nhiệm vụ cuối — Mũi chỉ có nhiều bàn tay** (`VLA13-QF`)

**Tình huống:** Maeve muốn chia một vài cách vá đơn giản với người thích học, nhưng sợ mình dạy không khéo.

**Việc người chơi làm thật:** Giúp sắp chỗ để vải mẫu, hướng dẫn một bước an toàn cùng Maeve, để người học tự chọn mẫu.

**Lựa chọn:** Cho người học thử tự làm hoặc làm mẫu thật chậm; Maeve nhớ cách A tạo không gian để người khác không ngại sai.

**Hệ quả nếu giúp:** Một góc thử vá trở thành hoạt động tự chọn; Maeve dám đề nghị được hỗ trợ lần sau.

**Nếu không giúp:** Maeve mở góc thử nhỏ khi rảnh, không phải sự kiện bắt buộc.

**Thoại ngắn (đều DRAFT):**
- `VLA13-QF-O1` **Maeve:** “Tôi muốn cho ai thích thì thử vá một đường. Nhưng sợ mình chỉ không rõ. Cậu ở cạnh giúp tôi nhé?”
- `VLA13-QF-A1` **A (đồng ý):** “Ai cũng có thể thử, hỏng một mũi thì tháo ra làm lại.”
- `VLA13-QF-C1` **Maeve (sau thao tác hoàn thành):** “Họ làm được rồi. Hóa ra không phải việc gì cũng cần đến tay tôi.”
- `VLA13-QF-D1` **Maeve (từ chối):** “Ừ, để tôi bắt đầu với một mẫu dễ thôi.”

**Khoảng lắng trước nhiệm vụ cuối — sự kiện quan hệ (không phải quest):** Maeve nói cô khuyên mọi người sửa đồ thay vì bỏ đi, nhưng lại rất ngại nhờ người khác góp một ý cho việc của mình. Cờ `VLA13.personal_bond_event_seen` chỉ bật khi A tự chọn nói chuyện, không tự phát chỉ vì điểm thân thiết cao.

**Sau QF:** Maeve tiếp tục lịch sinh hoạt, có lời chào và hoạt động thường; không bị coi là đã hoàn thành toàn bộ nội dung của NPC.

### VLA-15 — Evelyn: Truyền kiến thức đời thường bằng sự quan sát

*Tính cách gốc:* chậm rãi, quan sát giỏi. *Hạt giống tuyến truyện:* Muốn truyền kỹ năng thực tế cho người trẻ, không đóng vai người giữ bí mật giấc mơ.

**Nhiệm vụ 1 — Nhãn hạt còn thiếu** (`VLA15-Q1`)

**Tình huống:** A từng học đọc nhãn; một vài hũ được để riêng vì chưa ghi đủ thông tin.

**Việc người chơi làm thật:** Quan sát mẫu hạt, đối chiếu nhãn đã có, điền đủ một nhãn mới dưới sự kiểm tra của Evelyn.

**Lựa chọn:** Đoán bừa hoặc hỏi lại khi không chắc; hỏi lại là lựa chọn có trách nhiệm.

**Hệ quả nếu giúp:** Hũ có nhãn rõ; Evelyn đánh giá A biết không phỏng đoán.

**Nếu không giúp:** Evelyn ghi lại sau khi tự kiểm.

**Thoại ngắn (đều DRAFT):**
- `VLA15-Q1-O1` **Evelyn:** “Hũ này thiếu một dòng. Cậu muốn thử xem cần ghi gì không?”
- `VLA15-Q1-A1` **A (đồng ý):** “Nếu không chắc tôi sẽ hỏi lại.”
- `VLA15-Q1-C1` **Evelyn (sau thao tác hoàn thành):** “Được rồi. Ghi một điều biết chắc còn hơn mười điều đoán.”
- `VLA15-Q1-D1` **Evelyn (từ chối):** “Không sao. Tôi kiểm lại hũ này sau.”

**Nhiệm vụ 2 — Trang ghi chép từ vườn** (`VLA15-Q2`)

**Tình huống:** Evelyn muốn có một quan sát thực tế mới để đối chiếu với ghi chú mùa vụ thường ngày.

**Việc người chơi làm thật:** Tới một luống cây công cộng được phép quan sát, ghi tình trạng đất/cây rồi mang ghi chép về cho Evelyn.

**Lựa chọn:** Ghi những gì mắt thấy hay suy đoán vì sao cây đổi; bà chỉ giữ dữ kiện đã quan sát.

**Hệ quả nếu giúp:** Sổ có một dòng quan sát mới, không xác định quy luật siêu nhiên hay lịch sử làng.

**Nếu không giúp:** Evelyn tự đi kiểm một luống khi có thời gian.

**Thoại ngắn (đều DRAFT):**
- `VLA15-Q2-O1` **Evelyn:** “Cuốn sổ của tôi thiếu một ghi chú từ ngoài vườn. Cậu muốn thử quan sát rồi kể lại không?”
- `VLA15-Q2-A1` **A (đồng ý):** “Tôi sẽ ghi điều nhìn thấy, không đoán thêm.”
- `VLA15-Q2-C1` **Evelyn (sau thao tác hoàn thành):** “Rất tốt. Người sau đọc sẽ biết cậu đã thấy gì.”
- `VLA15-Q2-D1` **Evelyn (từ chối):** “Ừ. Lần khác tôi tự ra vườn xem.”

**Nhiệm vụ cuối — Một trang ai cũng có thể học** (`VLA15-QF`)

**Tình huống:** Evelyn muốn người mới tới làng cũng có thể hiểu cách giữ và ghi nhãn hạt giống mà không cần lúc nào cũng hỏi bà.

**Việc người chơi làm thật:** Chọn ba lưu ý thực tế đã được quan sát, đặt một tờ hướng dẫn tại kệ hạt chung và cùng Evelyn thử xem người mới có hiểu được không (không cần NPC mới).

**Lựa chọn:** Viết quá chi tiết hay hướng dẫn ngắn theo từng bước; bà thích câu rõ ràng.

**Hệ quả nếu giúp:** Kệ hạt có trang hướng dẫn dễ đọc, Evelyn tự tin trao lại kỹ năng chứ không giữ riêng.

**Nếu không giúp:** Evelyn vẫn viết bản đơn giản để ở kệ.

**Thoại ngắn (đều DRAFT):**
- `VLA15-QF-O1` **Evelyn:** “Tôi muốn ai mới tới cũng tự xem được. Cậu giúp tôi viết một trang thật dễ hiểu nhé?”
- `VLA15-QF-A1` **A (đồng ý):** “Chỉ ghi những điều có thể làm thử.”
- `VLA15-QF-C1` **Evelyn (sau thao tác hoàn thành):** “Giờ ai cần cũng học được. Thế là cuốn sổ có ích rồi.”
- `VLA15-QF-D1` **Evelyn (từ chối):** “Được. Tôi sẽ viết trước một bản ngắn.”

**Khoảng lắng trước nhiệm vụ cuối — sự kiện quan hệ (không phải quest):** Evelyn chia sẻ rằng những ghi chép của bà có ích nhất khi người khác thực hành rồi tự sửa điều chưa đúng. Cờ `VLA15.personal_bond_event_seen` chỉ bật khi A tự chọn nói chuyện, không tự phát chỉ vì điểm thân thiết cao.

**Sau QF:** Evelyn tiếp tục lịch sinh hoạt, có lời chào và hoạt động thường; không bị coi là đã hoàn thành toàn bộ nội dung của NPC.

### VLA-18 — Ada: Đi xa mà không bỏ quên những người ở lại

*Tính cách gốc:* năng động, tò mò. *Hạt giống tuyến truyện:* Mong kết nối các vùng bằng những chuyến đi, nhưng cũng sợ bỏ lỡ điều đáng quý gần nhà.

**Nhiệm vụ 1 — Những mốc đường đã biết** (`VLA18-Q1`)

**Tình huống:** Sau khi A đã giúp kiểm kiện, Ada muốn cùng xem một đoạn lối quen ở rìa Làng A trước những chuyến xa trong tương lai.

**Việc người chơi làm thật:** Cùng Ada đi một đoạn rừng đã biết, xác nhận hai mốc dễ nhận ra và quay lại theo đường cũ.

**Lựa chọn:** Chọn mốc dễ thấy hoặc mốc dễ nhớ dù khuất; Ada phản hồi và ghi chép, không mở địa điểm mới.

**Hệ quả nếu giúp:** A hiểu một đoạn đường quanh Làng A; Ada nhớ cậu quan sát cẩn thận.

**Nếu không giúp:** Ada tự kiểm mốc đường và về làng.

**Thoại ngắn (đều DRAFT):**
- `VLA18-Q1-O1` **Ada:** “Có một đoạn đường tôi muốn kiểm lại trước khi đi xa. Cậu đi cùng một quãng được không?”
- `VLA18-Q1-A1` **A (đồng ý):** “Đi rồi nhớ đường về nữa nhé.”
- `VLA18-Q1-C1` **Ada (sau thao tác hoàn thành):** “Tốt. Biết đường quay lại quan trọng không kém đường đi.”
- `VLA18-Q1-D1` **Ada (từ chối):** “Ừ, tôi tự đi một vòng vậy.”

**Nhiệm vụ 2 — Kiện hàng chuẩn bị lâu hơn dự định** (`VLA18-Q2`)

**Tình huống:** Ada và Hugo sắp kiện cho một chuyến đi xa chưa định tuyến chính thức; vài món cần được phân loại và kiểm dây.

**Việc người chơi làm thật:** Cùng Ada và Hugo kiểm hai kiện mẫu, chọn cách để đồ dễ vỡ/đồ thường, ghi một danh sách ngắn đồ cần chuẩn bị.

**Lựa chọn:** Đặt an toàn lên trước hoặc mang gọn trước; hai cách cần tuân thủ điều kiện bảo quản.

**Hệ quả nếu giúp:** Góc chuẩn bị gọn hơn; Ada tin A biết việc đi xa có trách nhiệm.

**Nếu không giúp:** Ada và Hugo tự kiểm kiện khi rảnh; không có đơn hàng thật tới Làng B.

**Thoại ngắn (đều DRAFT):**
- `VLA18-Q2-O1` **Ada:** “Tôi cứ muốn lên đường ngay. Nhưng Hugo bảo còn phải kiểm kiện. Cậu giúp chúng tôi chọn cách sắp không?”
- `VLA18-Q2-A1` **A (đồng ý):** “Mang đi được đã, rồi mới nghĩ đi nhanh.”
- `VLA18-Q2-C1` **Ada (sau thao tác hoàn thành):** “Ừ. Tôi hay nhìn đường phía trước mà quên việc cần chuẩn bị.”
- `VLA18-Q2-D1` **Ada (từ chối):** “Không sao. Tôi sẽ nghe Hugo thêm một lúc.”

**Nhiệm vụ cuối — Một tấm ghi chú đường về** (`VLA18-QF`)

**Tình huống:** Trước khi có tuyến liên làng chính thức, Ada muốn để lại những ghi chú mốc đường quanh Làng A cho người khác khi cần đi rừng.

**Việc người chơi làm thật:** Cùng Ada xem lại các mốc quanh làng đã khám phá, chọn hai chỉ dẫn dễ hiểu và đặt ghi chú tại góc chuẩn bị hành trang.

**Lựa chọn:** Dùng lời chỉ dẫn cụ thể thay vì vẽ tuyến chưa biết; Ada chọn cách đáng tin nhất.

**Hệ quả nếu giúp:** Góc chuẩn bị có bản ghi mốc quanh Làng A; Ada sẵn sàng nhận giúp đỡ và còn tuyến giao liên làng sẽ mở riêng về sau.

**Nếu không giúp:** Ada tự ghi mấy lối quen, không tạo đường hay làng mới.

**Thoại ngắn (đều DRAFT):**
- `VLA18-QF-O1` **Ada:** “Tôi muốn ai đi đường này cũng biết cách trở về. Cậu giúp tôi ghi vài mốc quen nhé?”
- `VLA18-QF-A1` **A (đồng ý):** “Chỉ ghi đoạn mình thật sự biết.”
- `VLA18-QF-C1` **Ada (sau thao tác hoàn thành):** “Hay đấy. Đi xa mà vẫn nhớ lối về.”
- `VLA18-QF-D1` **Ada (từ chối):** “Được thôi. Tôi sẽ ghi những gì mình chắc chắn trước.”

**Khoảng lắng trước nhiệm vụ cuối — sự kiện quan hệ (không phải quest):** Ada thừa nhận cô thích đi xa, nhưng lúc chuẩn bị rời một nơi vẫn muốn biết người ở đó còn ổn không. Cờ `VLA18.personal_bond_event_seen` chỉ bật khi A tự chọn nói chuyện, không tự phát chỉ vì điểm thân thiết cao.

**Sau QF:** Ada tiếp tục lịch sinh hoạt, có lời chào và hoạt động thường; không bị coi là đã hoàn thành toàn bộ nội dung của NPC.

### VLA-23 — Grace: Người chăm sóc cũng có quyền nghỉ ngơi

*Tính cách gốc:* hiền hậu, có chính kiến. *Hạt giống tuyến truyện:* Quen chăm bữa ăn cho người khác nhưng ít tự cho mình thời gian ngồi ăn.

**Nhiệm vụ 1 — Một chỗ ngồi còn trống** (`VLA23-Q1`)

**Tình huống:** Sau khi A từng giúp bày bàn, Grace tiếp tục đứng xem mọi người cần gì dù chỗ ngồi đã sẵn.

**Việc người chơi làm thật:** Chuẩn bị thêm chỗ ngồi cho Grace và cùng kiểm bát/khăn sao cho cô có thể ăn cùng những người khác.

**Lựa chọn:** Mời Grace ngồi ngay hoặc đợi bà hoàn tất nốt việc cần thiết; tôn trọng quyết định của bà.

**Hệ quả nếu giúp:** Grace lần đầu ngồi vào bàn sớm hơn, không để A thay hết công việc.

**Nếu không giúp:** Grace tự sắp bàn và ăn sau khi xong.

**Thoại ngắn (đều DRAFT):**
- `VLA23-Q1-O1` **Grace:** “Tôi định bày thêm một chỗ cho người đến muộn. Nhưng có lẽ cái ghế trống ấy là cho tôi. Cậu giúp tôi xếp lại nhé?”
- `VLA23-Q1-A1` **A (đồng ý):** “Có chỗ cho bà nữa mới là đủ bàn.”
- `VLA23-Q1-C1` **Grace (sau thao tác hoàn thành):** “Ừ. Tôi cứ quên để phần cho chính mình.”
- `VLA23-Q1-D1` **Grace (từ chối):** “Không sao. Tôi sẽ nhớ tự dành chỗ.”

**Nhiệm vụ 2 — Bữa ăn không cần một người lo hết** (`VLA23-Q2`)

**Tình huống:** Grace muốn một bữa nhỏ ai rảnh giúp một tay, chứ không để mình bà chuẩn bị.

**Việc người chơi làm thật:** Chọn một phần việc vừa sức, sắp vị trí thức ăn/đồ dùng cho người tự nguyện phụ và để Grace quyết định việc còn lại.

**Lựa chọn:** Cố làm hộ hết hay để mọi người cùng chọn phần họ muốn làm; Grace thích có người cùng chia trách nhiệm.

**Hệ quả nếu giúp:** Việc bếp chia đều hơn theo tự nguyện; Grace có thời gian nghỉ giữa buổi.

**Nếu không giúp:** Grace làm ít món hơn nhưng bữa ăn vẫn diễn ra.

**Thoại ngắn (đều DRAFT):**
- `VLA23-Q2-O1` **Grace:** “Tôi biết mọi người sẽ giúp nếu được hỏi. Chỉ là tôi hay quên hỏi. Cậu bắt đầu với tôi một chút nhé?”
- `VLA23-Q2-A1` **A (đồng ý):** “Chia vài việc thôi, ai rảnh thì làm.”
- `VLA23-Q2-C1` **Grace (sau thao tác hoàn thành):** “Bữa ăn không ít đi. Chỉ có tôi đỡ tất bật hơn.”
- `VLA23-Q2-D1` **Grace (từ chối):** “Ừ, tôi sẽ giảm bớt một món vậy.”

**Nhiệm vụ cuối — Bữa cơm có Grace ở đó** (`VLA23-QF`)

**Tình huống:** Grace muốn tổ chức một bữa ăn nhỏ mà bản thân cũng ngồi trò chuyện từ đầu, thay vì phục vụ xong mới ăn.

**Việc người chơi làm thật:** Cùng Grace chuẩn bị phần cần thiết, mời mọi người có mặt tự lấy phần, đặt chỗ ngồi cho bà và chính A nếu muốn; cho phép A rời đi trước khi bữa ăn kết thúc.

**Lựa chọn:** Ngồi ăn cùng hoặc chỉ góp tay rồi về, đều được Grace ghi nhận.

**Hệ quả nếu giúp:** Grace thay đổi thói quen: từ nay chủ động cùng ăn và nhờ giúp khi cần; bữa ăn vẫn diễn ra nếu A không tham gia.

**Nếu không giúp:** Grace tự quyết ngồi sớm, không biến tâm trạng bà phụ thuộc vào A.

**Thoại ngắn (đều DRAFT):**
- `VLA23-QF-O1` **Grace:** “Lần này tôi sẽ ngồi xuống cùng mọi người ngay từ đầu. Cậu muốn ăn cùng không?”
- `VLA23-QF-A1` **A (đồng ý):** “Tôi ở lại một lát.”
- `VLA23-QF-C1` **Grace (sau thao tác hoàn thành):** “Ăn cùng nhau thế này mới thấy bữa ăn thật sự trọn vẹn.”
- `VLA23-QF-D1` **Grace (từ chối):** “Cứ về nghỉ nếu cậu muốn. Tôi sẽ ngồi ăn cùng mọi người.”

**Khoảng lắng trước nhiệm vụ cuối — sự kiện quan hệ (không phải quest):** Grace nhận ra cô hay hỏi mọi người có ăn đủ không, nhưng ít khi ngồi hỏi mình có đang mệt không. Cờ `VLA23.personal_bond_event_seen` chỉ bật khi A tự chọn nói chuyện, không tự phát chỉ vì điểm thân thiết cao.

**Sau QF:** Grace tiếp tục lịch sinh hoạt, có lời chào và hoạt động thường; không bị coi là đã hoàn thành toàn bộ nội dung của NPC.

## Các cư dân còn lại

Trong roster Làng A, **10 tuyến phụ và 12 tuyến đời sống** vẫn có hoạt động và hội thoại bình thường, nhưng **chưa tự gán ba quest lớn cho cả 22 người**, vì điều đó sẽ biến mọi NPC thành máy giao việc. Những ai được duyệt có tuyến riêng dài cũng phải dùng cùng mô hình Q1 → Q2 → QF và ngắt bởi các lần gặp đời thường. Chưa viết thêm NPC mới.

## Trạng thái sản xuất

- **Tập trung biên kịch:** 8 tuyến sâu, **24 nhiệm vụ dự thảo** (3/người), 8 cuộc chuyện riêng trước nhiệm vụ cuối. Mọi tình tiết mới là **đề xuất** để m duyệt.
- **Đã có nhưng không ghi đè:** [hội thoại 30 cư dân](../dialogue/village-a-dialogues-guide-v0.md) và [CH01-007](../scenes/CH01-007.md). Các hoạt động lần đầu không phải nhiệm vụ 1; có thể bắt đầu Q1 chỉ sau khi đã quen.
- **Chưa quyết:** cách tính điểm tình bạn, lịch ngày giờ, vật phẩm/phần thưởng, nhịp mùa, tên chính thức của cư dân. File JSON là **contract biên kịch**, không phải code Godot.

**Dữ liệu:** [JSON](village-a-relationship-arcs-v0.json).
