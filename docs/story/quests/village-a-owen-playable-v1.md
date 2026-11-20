# Làng A — Owen: Kịch bản tương tác đầy đủ cho ba nhiệm vụ (v1, nháp)
> **DRAFT biên kịch, chưa duyệt, chưa code.** Dựa trên ba nhiệm vụ của Owen trong [24 tuyến nhiệm vụ](village-a-relationship-arcs-v0.md); giữ nguyên bốn lời thoại cơ bản mỗi nhiệm vụ theo ID, bổ sung các đoạn hội thoại và hoạt động cụ thể. Owen là `VLA-04`, tên English còn đang đề xuất. **Không chốt vị trí nhà riêng của Owen** — cánh cửa Q2 thuộc **góc làm việc**, không tự xác nhận quan hệ/hộ cư trú.

## Owen khi A không trò chuyện
Ông bận sửa ghế, cửa, mối nối hoặc dụng cụ gỗ; đôi lúc chủ động nghỉ tay. Vào khu sửa đồ không tự mở lời đề nghị. Cuộc trò chuyện đầu tiên sử dụng CH01-007, các câu gặp lại tùy việc đã làm. Đạo cụ chỉ xuất hiện khi làm nghề, không cần mang búa ở mọi góc nhìn.
**Điều kiện:** Q1 đã quen + một hoạt động thực sự + gặp lại (≥20/100 *đề xuất*); Q2 sau Q1 A hoàn thành hoặc Owen tự xử lý + một lần gặp đời thường (≥50); QF sau Q2 + hai lần gặp bình thường + đã chủ động nghe tâm sự (≥80). Điểm số không tự bật quest và NPC không giao liên tiếp trong một cuộc gặp.
**Nếu từ chối:** Owen làm việc của mình khi có thể; lần sau dùng câu nhớ trạng thái khác, không tự nói A đã giúp. Người chơi vẫn được quay lại, đi rừng hoặc tham gia việc khác.

## VLA04-Q1 — Chiếc ghế không chịu đứng yên

**Bối cảnh:** Góc sửa đồ chung của làng, một chiếc ghế gỗ được kê sang bên vì chân lỏng
**Khi tới gần:** Owen cúi gõ nhẹ vào chân ghế, đặt nó nằm nghiêng thay vì để ai đó ngồi thử.
**Mở khi:** `npc.met` · `npc.shared_activity_completed_at_least_once` · `npc.return_visit_count>=1` · `npc_available` · `player_chooses_listen_or_offer`, độ thân thiết `20/100` *đề xuất*, đúng hoạt động và người chơi chủ động hỏi.

### Hội thoại mở — dùng nguồn đã viết, không ghi đè
- **Owen đề nghị:** `VLA04-Q1-O1` · **A nhận:** `VLA04-Q1-A1` · **A không nhận:** `VLA04-Q1-D1`.

### Ba nhịp gameplay và thoại chi tiết

**CHECK:** Quan sát chỗ chân ghế lỏng, chọn xem mối nối hoặc thử lắc nhẹ khi ghế đang được kê chắc, không ngồi thử khi chưa sửa
*Phản hồi:* A phát hiện mối nối cần cố định. Không có lời khuyên phi thực tế phải dùng búa thật mạnh.
- `VLA04-Q1-CHECK-X01` **Owen:** “Đừng ngồi lên vội. Chỗ nối chưa chắc.”
- `VLA04-Q1-CHECK-X02` **A:** “Chân này lung lay hơn mấy chân kia.”
- `VLA04-Q1-CHECK-X03` **Owen:** “Ừ. Thế là nhìn đúng chỗ rồi.”

**HOLD:** Giữ ghế ở thế ổn định cho Owen chỉnh mối nối, không tự thao tác dụng cụ nguy hiểm
*Phản hồi:* Chân ghế được chỉnh; vẫn cần thử độ vững.
- `VLA04-Q1-HOLD-X01` **Owen:** “Giữ thế một chút.”
- `VLA04-Q1-HOLD-X02` **A:** “Như này được chưa?”
- `VLA04-Q1-HOLD-X03` **Owen:** “Được. Đừng nhấc lúc tôi chưa ra hiệu.”

**TEST:** Chọn thử độ vững khi đã được Owen cho phép, kiểm cả bốn chân rồi đặt ghế lại vào khu dùng chung
*Phản hồi:* Ghế vững và không còn phải kê sang bên; Owen phát câu kết gốc khi việc hoàn tất.
- `VLA04-Q1-TEST-X01` **A:** “Giờ thử lại nhé?”
- `VLA04-Q1-TEST-X02` **Owen:** “Ừ. Lắc nhẹ thôi.”
- `VLA04-Q1-TEST-X03` **A:** “Không còn kêu nữa.”
- `VLA04-Q1-TEST-X04` **Owen:** “Vậy thì dùng được rồi.”

### Các lựa chọn
- **Kiểm mối nối trước:** Được Owen đánh giá cẩn thận; thao tác thuận.
- **Nhờ Owen chỉ điểm cần giữ:** Owen giải thích ngắn; không cộng thưởng chỉ vì hỏi.
- **Thử ngồi ngay:** Owen ngăn lại, mời kiểm chân ghế trước; không có animation nguy hiểm hoặc phạt nặng.

**Hoàn thành:** Sau thao tác thật và Owen xác nhận, phát câu kết gốc `VLA04-Q1-C1`. Ghế dùng chung vững hơn, Owen nhớ cách A giúp.
**Nếu A bỏ qua hoặc từ chối:** Owen kê chiếc ghế sang một bên và sửa lúc rảnh. Gặp lại sau khi Owen tự giải quyết: “Tôi kê chiếc ghế sang bên rồi tự chỉnh xong. Giờ dùng được.”
**Nếu A giúp:** Khi quay lại Owen nói: “Chiếc ghế hôm trước vẫn đứng chắc. Tôi đã xem lại rồi.”
**Sau khi kết:** Owen trở lại sửa những món nhỏ; chiếc ghế vẫn ở góc sinh hoạt, không biến thành đồ thưởng.

## VLA04-Q2 — Cánh cửa để sau

**Bối cảnh:** Góc làm việc quen thuộc của Owen, cánh cửa của chính khu làm việc ấy hơi kẹt
**Khi tới gần:** Owen dùng vai đẩy nhẹ cánh cửa rồi bỏ sang xem món đồ khách mang tới. Không có thoại rên rỉ hay cảnh bi kịch.
**Mở khi:** `Q1.status in [completed,resolved_without_player]` · `npc.nonquest_meetups_after_Q1>=1` · `npc.available_context_Q2` · `player_chooses_accept`, độ thân thiết `50/100` *đề xuất*, đúng hoạt động và người chơi chủ động hỏi.

### Hội thoại mở — dùng nguồn đã viết, không ghi đè
- **Owen đề nghị:** `VLA04-Q2-O1` · **A nhận:** `VLA04-Q2-A1` · **A không nhận:** `VLA04-Q2-D1`.

### Ba nhịp gameplay và thoại chi tiết

**ASK:** A tự hỏi Owen có muốn xem cánh cửa bị kẹt không; nếu ông chưa muốn thì người chơi rời đi được
*Phản hồi:* Owen đồng ý xem khi đang rảnh, không cho A tự tiện sửa đồ riêng.
- `VLA04-Q2-ASK-X01` **A:** “Cánh cửa này vẫn kẹt à?”
- `VLA04-Q2-ASK-X02` **Owen:** “Ừ. Tôi biết. Mỗi lần tính sửa lại có việc khác.”
- `VLA04-Q2-ASK-X03` **A:** “Giờ ông có muốn xem nó không?”
- `VLA04-Q2-ASK-X04` **Owen:** “... Ừ. Một lúc thôi.”

**INSPECT:** Quan sát phía bản lề và chỗ cửa cạ khung, Owen quyết định cách chỉnh; A chỉ giữ cánh cửa theo hướng dẫn
*Phản hồi:* Khi A chọn sai chỗ, Owen chỉ lại và cho quan sát thêm. Không cần sinh vật phẩm bản lề mới hay đi tìm vật liệu.
- `VLA04-Q2-INSPECT-X01` **Owen:** “Giữ nhẹ mép này. Đừng nâng quá cao.”
- `VLA04-Q2-INSPECT-X02` **A:** “Nó cạ vào khung phía dưới.”
- `VLA04-Q2-INSPECT-X03` **Owen:** “Đúng chỗ tôi cứ bỏ qua mãi.”

**TRY:** Cùng Owen thử đóng mở hai lần, đứng tránh lối đi, kết thúc khi cửa không còn bị kẹt
*Phản hồi:* Cánh cửa được sử dụng bình thường; phát lời kết gốc, không tự xác nhận đây là cửa nhà ở Owen.
- `VLA04-Q2-TRY-X01` **A:** “Giờ mở được rồi.”
- `VLA04-Q2-TRY-X02` **Owen:** “Ừ. Không cần lấy vai đẩy nữa.”
- `VLA04-Q2-TRY-X03` **A:** “Vậy một việc của ông cũng xong rồi.”
- `VLA04-Q2-TRY-X04` **Owen:** “Chắc thế.”

### Các lựa chọn
- **Mình xem cửa lúc ông rảnh nhé:** Owen đồng ý khi hoàn cảnh phù hợp, không ép làm ngay.
- **Ông nghỉ trước cũng được:** Owen hoãn hợp lý, không tính là từ chối nhiệm vụ hoặc trừ thân.
- **Để tôi tự sửa hết:** Owen đề nghị cùng kiểm thay vì giao toàn bộ cho A.

**Hoàn thành:** Sau thao tác thật và Owen xác nhận, phát câu kết gốc `VLA04-Q2-C1`. Cửa hoạt động tốt hơn; Owen bắt đầu chú ý việc của chính mình.
**Nếu A bỏ qua hoặc từ chối:** Owen để cửa trong trạng thái sử dụng tạm và tự sửa khi có thời gian. Gặp lại sau khi Owen tự giải quyết: “Tôi tự sửa cánh cửa vào lúc rảnh. Hóa ra không mất lâu đến thế.”
**Nếu A giúp:** Khi quay lại Owen nói: “Cánh cửa chỗ tôi giờ nhẹ tay hơn. Lẽ ra tôi nên sửa sớm.”
**Sau khi kết:** Owen thỉnh thoảng đóng mở cửa bình thường; ông vẫn chăm đồ cho dân làng, nhưng không bỏ bê việc của mình.

## VLA04-QF — Một buổi sửa đồ vừa đủ

**Bối cảnh:** Góc sửa đồ chung và một bàn đặt vài món đồ đã được người gửi cho phép kiểm
**Khi tới gần:** Owen sắp các món theo thứ tự. Ông nhìn số lượng rồi tự tách một món sang ngăn 'hôm khác' (ký hiệu chỉ là đề xuất).
**Mở khi:** `Q2.status in [completed,resolved_without_player]` · `npc.nonquest_meetups_after_Q2>=2` · `npc.personal_bond_event_seen==true` · `npc.available_context_QF` · `player_chooses_accept`, độ thân thiết `80/100` *đề xuất*, đúng hoạt động và người chơi chủ động hỏi.

### Hội thoại mở — dùng nguồn đã viết, không ghi đè
- **Owen đề nghị:** `VLA04-QF-O1` · **A nhận:** `VLA04-QF-A1` · **A không nhận:** `VLA04-QF-D1`.

### Ba nhịp gameplay và thoại chi tiết

**SORT:** Xem ba món được đề xuất: một món cần sửa để dùng an toàn, một món nhỏ sửa nhanh, một món có thể hẹn sau; chọn thứ tự ưu tiên
*Phản hồi:* Không phải nhận hết đồ từ làng; đồ chưa sửa được đặt riêng, người mang có thể nhận lại hoặc hẹn sau.
- `VLA04-QF-SORT-X01` **Owen:** “Ba món. Tôi mà nhận cả ba rồi ngồi đến tối thì lại thế.”
- `VLA04-QF-SORT-X02` **A:** “Món nào người ta cần dùng ngay?”
- `VLA04-QF-SORT-X03` **Owen:** “Cái chốt này. Còn món kia có thể đợi.”

**AGREE:** Cùng Owen chọn chỉ làm phần có thể xong trong buổi, thông báo rõ món để sau qua ghi chú đơn giản
*Phản hồi:* Nội dung hẹn được giữ ở góc bàn; không tự gán lời đồng ý cho cư dân vắng mặt.
- `VLA04-QF-AGREE-X01` **A:** “Vậy mình chỉ nhận món thật cần trước.”
- `VLA04-QF-AGREE-X02` **Owen:** “Ừ. Còn lại để tôi hẹn rõ.”
- `VLA04-QF-AGREE-X03` **A:** “Ông không phải làm hết hôm nay.”
- `VLA04-QF-AGREE-X04` **Owen:** “Tôi đang học nói câu đó.”

**HELP:** Giữ chi tiết cho Owen chỉnh một món đơn giản rồi thử lại; sau đó Owen tự đóng sổ việc
*Phản hồi:* Một món đã sửa, món khác được xếp chờ rõ ràng, góc làm việc có trạng thái kết thúc buổi.
- `VLA04-QF-HELP-X01` **Owen:** “Giữ chốt giúp tôi một lúc.”
- `VLA04-QF-HELP-X02` **A:** “Xong phần này rồi.”
- `VLA04-QF-HELP-X03` **Owen:** “Ừ. Thế là đủ cho hôm nay.”

### Các lựa chọn
- **Chỉ nhận việc làm được hôm nay:** Owen thực sự nghỉ đúng lúc; nội dung nhiệm vụ cuối kết thúc tự nhiên.
- **Tôi giúp làm thêm hết những món kia:** Owen giải thích cần hẹn lại, không mở vòng nhiệm vụ vô hạn.
- **Hỏi món nào cần dùng ngay:** Làm rõ ưu tiên rồi cùng sửa một món; không tự tạo NPC thứ 31.

**Hoàn thành:** Sau thao tác thật và Owen xác nhận, phát câu kết gốc `VLA04-QF-C1`. Góc sửa đồ có cách nhận việc rõ ràng; Owen dám nói 'hôm khác' và có thời gian cho mình.
**Nếu A bỏ qua hoặc từ chối:** Owen tự giới hạn số đồ nhận và buổi sửa vẫn diễn ra. Gặp lại sau khi Owen tự giải quyết: “Tôi tự hẹn bớt mấy món. Buổi sửa đồ vẫn vui, lại không mệt quá.”
**Nếu A giúp:** Khi quay lại Owen nói: “Tôi đã viết rõ món nào nhận, món nào hẹn. Lần này không phải sửa quá giờ.”
**Sau khi kết:** Owen tiếp tục nhận sửa đồ vào những buổi phù hợp, thỉnh thoảng nghỉ đúng lúc; người chơi vẫn có thể tới trao đổi hoặc hỗ trợ các hoạt động nhỏ.

## Những cuộc gặp giữa nhiệm vụ — KHÔNG tự tạo quest

### VLA04-IL1 — Q1->Q2
**Điều kiện:** `first_nonquest_revisit_after_Q1_resolution`. Bối cảnh đời thường: `sorting_tools`. Tính một lượt gặp chỉ nếu A đã rời lượt trò chuyện trước.
- `VLA04-IL1-X01` **Owen:** “Chiếc ghế vẫn vững.”
- `VLA04-IL1-X02` **A:** “Vậy hôm nay sửa gì?”
- `VLA04-IL1-X03` **Owen:** “Có vài món nhỏ. Chưa cái nào vội.”
**Flag:** `VLA04.nonquest_meetups_after_Q1`. Không tạo lời đề nghị nhiệm vụ ngay khi đoạn này hết.

### VLA04-IL2 — Q2->QF
**Điều kiện:** `first_nonquest_revisit_after_Q2_resolution`. Bối cảnh đời thường: `resting_hand_between_repairs`. Tính một lượt gặp chỉ nếu A đã rời lượt trò chuyện trước.
- `VLA04-IL2-X01` **A:** “Hôm nay ông không sửa đồ à?”
- `VLA04-IL2-X02` **Owen:** “Có. Nhưng tôi đang nghỉ tay.”
- `VLA04-IL2-X03` **A:** “Thế cũng cần mà.”
- `VLA04-IL2-X04` **Owen:** “Ừ.”
**Flag:** `VLA04.nonquest_meetups_after_Q2`. Không tạo lời đề nghị nhiệm vụ ngay khi đoạn này hết.

### VLA04-IL3 — Q2->QF
**Điều kiện:** `second_nonquest_revisit_after_Q2_resolution`. Bối cảnh đời thường: `checking_workbench`. Tính một lượt gặp chỉ nếu A đã rời lượt trò chuyện trước.
- `VLA04-IL3-X01` **Owen:** “Tôi vừa từ chối nhận thêm một món hôm nay.”
- `VLA04-IL3-X02` **A:** “Ông thấy sao?”
- `VLA04-IL3-X03` **Owen:** “Hơi lạ. Nhưng cái bàn trông đỡ chật.”
**Flag:** `VLA04.nonquest_meetups_after_Q2`. Không tạo lời đề nghị nhiệm vụ ngay khi đoạn này hết.

### VLA04-BOND — Q2->QF
**Điều kiện:** `after_Q2_resolution_and_player_selects_personal_talk`. Bối cảnh đời thường: `not_busy`. Tính một lượt gặp chỉ nếu A đã rời lượt trò chuyện trước.
- `VLA04-BOND-X01` **Owen:** “Tôi cứ sửa cho nhà khác trước. Đồ ở chỗ mình thì để đấy.”
- `VLA04-BOND-X02` **A:** “Ông không muốn nhờ ai à?”
- `VLA04-BOND-X03` **Owen:** “Không quen. Tôi nghĩ tự mình làm sẽ nhanh hơn.”
- `VLA04-BOND-X04` **A:** “Nhưng đôi khi mất cả một buổi mới nhớ tới nó.”
- `VLA04-BOND-X05` **Owen:** “Ừ. Tôi biết rồi.”
**Flag:** `VLA04.personal_bond_event_seen`. Không tạo lời đề nghị nhiệm vụ ngay khi đoạn này hết.

### VLA04-POST — after_QF
**Điều kiện:** `normal_revisit_after_QF_completed_or_alternate`. Bối cảnh đời thường: `repairing_small_item`. Tính một lượt gặp chỉ nếu A đã rời lượt trò chuyện trước.
- `VLA04-POST-X01` **Owen:** “Chào. Hôm nay không có món nào cần gấp.”
- `VLA04-POST-X02` **A:** “Vậy ông có chút thời gian rảnh rồi.”
- `VLA04-POST-X03` **Owen:** “Ừ. Không tệ.”
**Flag:** `none`. Không tạo lời đề nghị nhiệm vụ ngay khi đoạn này hết.

## Quy tắc nhớ quan hệ và tiếp diễn
- Nếu Q1/Q2 được Owen tự làm, Q2/QF vẫn có thể xuất hiện sau khi A quen thân bằng các hoạt động khác. Không để trạng thái `declined` khóa nhân vật vô thời hạn.
- NPC chỉ nhớ A **đã thực sự giữ ghế, cùng chỉnh cửa hoặc phụ xếp việc** nếu tương tác đó xảy ra. Nếu không, dùng lời thoại tự giải quyết.
- Đừng phát Q2 trong cùng lần nói chuyện vừa kết thúc Q1; đừng phát nhiệm vụ cuối trong lần vừa hoàn thành Q2.
- QF không biến Owen thành ông chủ xưởng hoặc người chuyên phát quest sửa đồ; ông vẫn làm công việc và biết nghỉ, ngay cả khi A không xuất hiện.
- Không tự xác nhận quyền sở hữu nhà, gia đình Owen, số NPC khách mang đồ, gỗ/tài nguyên hoặc hệ vật phẩm.

**Dữ liệu:** [JSON](village-a-owen-playable-v1.json) · [Nhận dạng nhân vật](../characters/first-wave-npc-visual-identities-v0.md) · [Hội thoại nền](../dialogue/village-a-dialogues-guide-v0.md).
