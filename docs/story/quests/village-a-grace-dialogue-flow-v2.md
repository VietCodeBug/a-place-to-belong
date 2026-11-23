# Grace (VLA-23) — Kịch bản ba nhiệm vụ và đời sống cộng đồng, bản 2

> **DRAFT biên kịch, chưa code.** Dùng [quy chuẩn bàn giao cho AI](../production/narrative-dialogue-handoff-contract-v1.md): chỉ những dòng **THOẠI** có trigger được phát; **TÌNH HUỐNG/HÀNH ĐỘNG/KẾT QUẢ** là hướng dẫn triển khai, không phải chữ NPC đọc. Không ép Clara hoặc cả làng xuất hiện; khu bữa ăn cụ thể cần bên game xác nhận điểm đặt.

**Khác với Clara:** Clara tìm niềm vui trong bữa ăn không hoàn hảo; Grace học cách dành chỗ cho chính mình và chia sẻ việc chăm sóc người khác. Không cho cả hai cùng một nhiệm vụ chỉ đổi tên.

## VLA23-Q1 — Một chỗ ngồi còn trống

**TÌNH HUỐNG (không đọc):** Grace đang đặt bát lên bàn sinh hoạt chung; còn một chiếc ghế chưa có ai ngồi. Bữa ăn vẫn diễn ra khi A bỏ qua.

**ĐIỀU KIỆN:** thân thiết đề xuất ≥20, đã sinh hoạt cùng Grace và gặp lại, người chơi chủ động hỏi, Grace có mặt.

**THOẠI MỞ (Grace, `VLA23-Q1-O1`):** “Tôi định bày thêm một chỗ cho người đến muộn. Nhưng có lẽ cái ghế trống ấy là cho tôi. Cậu giúp tôi xếp lại nhé?”

**MENU A:** Đồng ý giúp / Hôm nay không giúp được / Để lần khác. Chỉ sau khi chọn mới phát `VLA23-Q1-A1` hoặc `VLA23-Q1-D1`.

### VLA23-Q1-COUNT_SEATS

**HÀNH ĐỘNG (không đọc):** Người chơi tự nhìn bát, ghế và lối đi quanh bàn, nhận ra Grace chưa có chỗ ngồi thuận tiện.

**EVENT XÁC NHẬN:** `grace_table_places_checked`; **PHẢN HỒI:** Hiện số chỗ ngồi cần chuẩn bị, không tự gọi NPC đang ở xa.

**THOẠI (chỉ sau khi có event và người nói hiện diện):**

- `VLA23-Q1-COUNT_SEATS-L1` **Grace:** “Bát thì đủ rồi. Cứ đến lúc ăn tôi lại thấy thiếu một chỗ.”
- `VLA23-Q1-COUNT_SEATS-L2` **A:** “Bà đã để bát cho mình chưa?”
- `VLA23-Q1-COUNT_SEATS-L3` **Grace:** “Tôi vẫn nghĩ sẽ ngồi sau.”

### VLA23-Q1-SET_PLACE

**HÀNH ĐỘNG (không đọc):** A lấy một chiếc bát/khăn từ nơi có sẵn, chọn một chỗ thật sự còn trống và đặt cho Grace, không chắn đường.

**EVENT XÁC NHẬN:** `grace_seat_prepared`; **PHẢN HỒI:** Bàn có phần cho Grace; không cần thêm bàn/nhà mới.

**THOẠI (chỉ sau khi có event và người nói hiện diện):**

- `VLA23-Q1-SET_PLACE-L1` **Grace:** “Không cần sắp cầu kỳ đâu.”
- `VLA23-Q1-SET_PLACE-L2` **A:** “Vừa đủ để bà cũng ngồi cùng mọi người.”
- `VLA23-Q1-SET_PLACE-L3` **Grace:** “Nghe đơn giản mà tôi quên mãi.”

### VLA23-Q1-CONFIRM_SEAT

**HÀNH ĐỘNG (không đọc):** Grace tự kiểm và ngồi xuống khi sẵn sàng, A xác nhận bàn vẫn có lối đi và đồ dùng đủ.

**EVENT XÁC NHẬN:** `grace_seat_tested`; **PHẢN HỒI:** Grace ngồi sớm hơn; NPC không bị ép ngồi nếu chưa sẵn sàng.

**THOẠI (chỉ sau khi có event và người nói hiện diện):**

- `VLA23-Q1-CONFIRM_SEAT-L1` **Grace:** “Được. Lần này tôi thử ngồi trước khi mọi người ăn xong.”
- `VLA23-Q1-CONFIRM_SEAT-L2` **A:** “Món ăn đâu cần người canh mãi.”
- `VLA23-Q1-CONFIRM_SEAT-L3` **Grace:** “Ừ. Tôi cũng muốn ăn lúc còn nóng.”

**LỰA CHỌN:** Mời Grace ngồi khi bà sẵn sàng (Grace nhớ A quan tâm cả người chuẩn bị bữa) · Giúp bà xếp nốt chỗ ngồi trước (Tôn trọng nhịp làm việc của Grace).

**THOẠI HOÀN THÀNH:** `VLA23-Q1-C1` “Ừ. Tôi cứ quên để phần cho chính mình.” — chỉ khi hoàn tất các tương tác và Grace xác nhận.

**SAU KHI A GIÚP:** “Bữa trước tôi có ghế sẵn từ đầu. Hôm nay tôi cũng chừa một chỗ cho mình.”

**NẾU GRACE TỰ GIẢI QUYẾT:** “Tôi tự xếp thêm một chiếc ghế. Có vẻ mình nên làm thế từ lâu.” — không ghi A đã giúp.

**NHỊP SỐNG SAU:** Grace tiếp tục chuẩn bị bữa ăn và ngồi nghỉ, không giao nhiệm vụ ngay lần gặp kế.

## VLA23-Q2 — Bữa ăn không cần một người lo hết

**TÌNH HUỐNG (không đọc):** Grace muốn một bữa nhỏ mà không phải tự ôm hết. Không có hạn chót hoặc sự kiện cả làng bắt buộc.

**ĐIỀU KIỆN:** thân thiết đề xuất ≥50, Q1 đã giải quyết, gặp lại một lượt không quest, người chơi chủ động hỏi, Grace có mặt.

**THOẠI MỞ (Grace, `VLA23-Q2-O1`):** “Tôi biết mọi người sẽ giúp nếu được hỏi. Chỉ là tôi hay quên hỏi. Cậu bắt đầu với tôi một chút nhé?”

**MENU A:** Đồng ý giúp / Hôm nay không giúp được / Để lần khác. Chỉ sau khi chọn mới phát `VLA23-Q2-A1` hoặc `VLA23-Q2-D1`.

### VLA23-Q2-CHECK_WORK

**HÀNH ĐỘNG (không đọc):** A quan sát ba phần việc: bày bát, đặt đồ ăn có sẵn và cất khăn/bàn dùng xong. Grace tự quyết phần liên quan bếp nóng.

**EVENT XÁC NHẬN:** `grace_meal_tasks_viewed`; **PHẢN HỒI:** Hiển thị phần việc vừa sức, không bịa nguyên liệu/nấu nướng.

**THOẠI (chỉ sau khi có event và người nói hiện diện):**

- `VLA23-Q2-CHECK_WORK-L1` **Grace:** “Tôi cứ làm phần này rồi lại nhớ ra phần kia.”
- `VLA23-Q2-CHECK_WORK-L2` **A:** “Có vài việc người khác có thể phụ mà.”
- `VLA23-Q2-CHECK_WORK-L3` **Grace:** “Ừ. Tôi đang tập hỏi thôi.”

### VLA23-Q2-ASK_OR_SIMPLIFY

**HÀNH ĐỘNG (không đọc):** A chọn giúp một việc; có thể hỏi một cư dân thực sự ở gần có muốn phụ không. Nếu không ai rảnh, Grace chủ động giảm bớt món thay vì làm quá sức.

**EVENT XÁC NHẬN:** `grace_task_share_decided`; **PHẢN HỒI:** Không tự dịch chuyển Clara hay dân làng đến bàn; nhánh không có người hỗ trợ vẫn hợp lệ.

**THOẠI (chỉ sau khi có event và người nói hiện diện):**

- `VLA23-Q2-ASK_OR_SIMPLIFY-L1` **Grace:** “Nếu mọi người đang bận thì cứ để ít món hơn.”
- `VLA23-Q2-ASK_OR_SIMPLIFY-L2` **A:** “Một bữa giản dị cũng đủ để ngồi với nhau.”
- `VLA23-Q2-ASK_OR_SIMPLIFY-L3` **Grace:** “Đúng. Tôi không muốn ai phải vội.”

### VLA23-Q2-DO_SHARE

**HÀNH ĐỘNG (không đọc):** A thực hiện một phần việc đã chọn, xác nhận đồ dùng sẵn cho bữa ăn và để Grace tự hoàn tất phần còn lại.

**EVENT XÁC NHẬN:** `grace_one_task_fulfilled`; **PHẢN HỒI:** Bữa ăn bắt đầu bình thường; Grace có thời gian nghỉ, không tính xong chỉ vì bấm Đồng ý.

**THOẠI (chỉ sau khi có event và người nói hiện diện):**

- `VLA23-Q2-DO_SHARE-L1` **Grace:** “Thế là vừa đủ. Tôi đỡ phải quay đi quay lại rồi.”
- `VLA23-Q2-DO_SHARE-L2` **A:** “Bà có thể nghỉ một lát trước khi mọi người đến.”
- `VLA23-Q2-DO_SHARE-L3` **Grace:** “Được, tôi thử xem sao.”

**LỰA CHỌN:** Tự làm một việc vừa sức (Grace nhớ A làm cùng chứ không làm hộ tất cả) · Hỏi người rảnh có muốn phụ (Chỉ thực hiện khi NPC có mặt và đồng ý) · Ít món hơn nhưng đủ bữa (Grace nhớ lời nhắc không cần ôm hết).

**THOẠI HOÀN THÀNH:** `VLA23-Q2-C1` “Bữa ăn không ít đi. Chỉ có tôi đỡ tất bật hơn.” — chỉ khi hoàn tất các tương tác và Grace xác nhận.

**SAU KHI A GIÚP:** “Buổi trước, mỗi người làm một chút mà cũng xong. Tôi có lúc được ngồi nghỉ.”

**NẾU GRACE TỰ GIẢI QUYẾT:** “Tôi bớt đi một món và tự làm vừa sức. Bữa ăn vẫn diễn ra vui vẻ.” — không ghi A đã giúp.

**NHỊP SỐNG SAU:** Grace có thể hỏi xem người khác có muốn phụ, nhưng không mặc định họ đồng ý.

## VLA23-QF — Bữa cơm có Grace ở đó

**TÌNH HUỐNG (không đọc):** Grace chuẩn bị bữa chung vừa đủ và muốn tự ngồi trò chuyện từ đầu; không biến thành đại tiệc hay cutscene dài.

**ĐIỀU KIỆN:** thân thiết đề xuất ≥80, Q2 đã giải quyết, hai lượt gặp thường + tâm sự, người chơi chủ động hỏi, Grace có mặt.

**THOẠI MỞ (Grace, `VLA23-QF-O1`):** “Lần này tôi sẽ ngồi xuống cùng mọi người ngay từ đầu. Cậu muốn ăn cùng không?”

**MENU A:** Đồng ý giúp / Hôm nay không giúp được / Để lần khác. Chỉ sau khi chọn mới phát `VLA23-QF-A1` hoặc `VLA23-QF-D1`.

### VLA23-QF-SET_FOR_EVERYONE

**HÀNH ĐỘNG (không đọc):** A sắp bát, khăn và chỗ ngồi hiện có, bảo đảm Grace cũng có một chỗ. Nếu không có người khác, bữa ăn quy mô nhỏ vẫn hợp lệ.

**EVENT XÁC NHẬN:** `grace_final_meal_set`; **PHẢN HỒI:** Không yêu cầu toàn bộ 30 cư dân Làng A tập trung hay dựng nhà ăn mới.

**THOẠI (chỉ sau khi có event và người nói hiện diện):**

- `VLA23-QF-SET_FOR_EVERYONE-L1` **Grace:** “Tôi định tự bày nốt cho xong, rồi mới nhớ đã hứa với mình sẽ ngồi.”
- `VLA23-QF-SET_FOR_EVERYONE-L2` **A:** “Mình chỉ cần chuẩn bị vừa đủ thôi.”
- `VLA23-QF-SET_FOR_EVERYONE-L3` **Grace:** “Ừ. Phần còn lại để lát cũng được.”

### VLA23-QF-INVITE_TO_SERVE

**HÀNH ĐỘNG (không đọc):** A mang một khay nhẹ theo yêu cầu và tự lựa chọn mời những người đang ở gần, hoặc chỉ cùng Grace dùng bữa; không tự gán lời chấp nhận cho NPC vắng mặt.

**EVENT XÁC NHẬN:** `grace_meal_served`; **PHẢN HỒI:** Bữa ăn diễn ra bằng đồ dùng sẵn có; ai không tham gia vẫn có sinh hoạt riêng.

**THOẠI (chỉ sau khi có event và người nói hiện diện):**

- `VLA23-QF-INVITE_TO_SERVE-L1` **Grace:** “Ai muốn ăn cùng cứ đến, không cần đông mới vui.”
- `VLA23-QF-INVITE_TO_SERVE-L2` **A:** “Bà có chỗ ngồi rồi, đừng quên đấy.”
- `VLA23-QF-INVITE_TO_SERVE-L3` **Grace:** “Tôi nhớ mà.”

### VLA23-QF-SIT_OR_LEAVE

**HÀNH ĐỘNG (không đọc):** Grace chủ động ngồi vào bàn; A chọn ở lại dùng bữa hoặc rời đi sau khi đã giúp. Nếu A rời đi, không nói A đã ăn cùng.

**EVENT XÁC NHẬN:** `grace_sits_for_meal`; **PHẢN HỒI:** Ghi chính xác lựa chọn của A; cả hai nhánh đều hoàn thành việc chuẩn bị nếu các bước đã làm thật.

**THOẠI theo lựa chọn thực tế (không phát cả hai nhánh):**

**Nếu A chọn Ở LẠI ĂN:**
- `VLA23-QF-SIT-STAY-L1` **Grace:** “Tôi cứ tưởng phải làm xong hết mới được ngồi. Ngồi cùng cậu thế này thật dễ chịu.”
- `VLA23-QF-SIT-STAY-L2` **A:** “Vậy cứ ăn thôi. Những việc khác có thể đợi.”

**Nếu A chọn GIÚP RỒI ĐI:**
- `VLA23-QF-SIT-LEAVE-L1` **Grace:** “Cảm ơn cậu đã bày giúp. Cứ đi chơi đi, tôi sẽ ngồi ăn ở đây.”

Mỗi nhánh chỉ phát sau event `grace_sits_for_meal` và lựa chọn tương ứng; không được nói A đã dùng bữa nếu A rời đi.

**LỰA CHỌN:** Ở lại ăn cùng Grace (Grace nhớ A đã ngồi lại chia sẻ bữa) · Giúp xong rồi đi dạo (Grace chỉ nhớ A đã giúp bày, không nhớ A đã ăn cùng).

**THOẠI HOÀN THÀNH theo điều kiện:** `VLA23-QF-C1` “Ăn cùng nhau thế này mới thấy bữa ăn thật sự trọn vẹn.” **chỉ khi A ở lại ăn hoặc có khách khác hiện diện**. Nếu A đã đi và không có khách khác, Grace nói `VLA23-QF-C-LEAVE`: “Cảm ơn cậu đã chuẩn bị. Tôi cũng muốn ngồi ăn một bữa cho mình.”

**GẶP LẠI nếu A đã ở lại:** “Bữa trước tôi ngồi ăn cùng cậu từ đầu. Tôi vẫn nhớ buổi đó.” **Nếu A chỉ giúp rồi đi:** “Cậu đã giúp bày bàn hôm trước. Sau khi cậu đi, tôi cũng ngồi ăn sớm hơn mọi khi.”

**NẾU GRACE TỰ GIẢI QUYẾT:** “Tôi đã tự ngồi xuống sớm hơn. Không có gì thiếu cả.” — không ghi A đã giúp.

**NHỊP SỐNG SAU:** Grace vẫn chuẩn bị các bữa nhỏ, nhớ ai muốn ăn cùng và biết dành thời gian cho mình.

## Cuộc gặp đời thường, không có nhiệm vụ

**VLA23-IL1 — Chỗ ngồi còn đó**

- `VLA23-IL1-CHAT-L1` **Grace:** “Chiếc ghế hôm trước vẫn ở đó.”
- `VLA23-IL1-CHAT-L2` **A:** “Bà có dùng không?”
- `VLA23-IL1-CHAT-L3` **Grace:** “Có. Hôm nay tôi lại nhớ để phần mình.”

**VLA23-IL2 — Đi qua sân chung**

- `VLA23-IL2-CHAT-L1` **Grace:** “Hôm nay tôi không vội về bếp.”
- `VLA23-IL2-CHAT-L2` **A:** “Không có gì cần chuẩn bị à?”
- `VLA23-IL2-CHAT-L3` **Grace:** “Có chứ. Nhưng đi một vòng cũng không sao.”

**VLA23-IL3 — Một bữa ăn ít món**

- `VLA23-IL3-CHAT-L1` **A:** “Hôm nay ít món hơn mọi hôm à?”
- `VLA23-IL3-CHAT-L2` **Grace:** “Ừ. Và tôi lại có thời gian hỏi thăm người ngồi cạnh.”
- `VLA23-IL3-CHAT-L3` **A:** “Thế thì cũng đủ đầy rồi.”

**VLA23-BOND — Grace và cảm giác được chăm sóc**

- `VLA23-BOND-CHAT-L1` **Grace:** “Tôi nhớ mọi người thích món gì, nhưng lâu rồi không nghĩ mình muốn ăn gì.”
- `VLA23-BOND-CHAT-L2` **A:** “Bà cứ lo cho người khác trước.”
- `VLA23-BOND-CHAT-L3` **Grace:** “Ừ. Có lúc tôi tưởng nếu ngồi nghỉ thì mình bỏ sót điều gì.”
- `VLA23-BOND-CHAT-L4` **A:** “Bà cũng là một người ngồi quanh bàn mà.”
- `VLA23-BOND-CHAT-L5` **Grace:** “Cậu nói đúng. Tôi muốn được ngồi đó, không chỉ đứng phía sau.”

**VLA23-POST — Mời dùng bữa**

- `VLA23-POST-CHAT-L1` **Grace:** “Nếu có đói, cứ ghé ăn một chút. Không cần giúp gì cả.”
- `VLA23-POST-CHAT-L2` **A:** “Bà định ngồi ăn chứ?”
- `VLA23-POST-CHAT-L3` **Grace:** “Có. Tôi đang chờ món nguội bớt.”

## Kiểm thử AI triển khai

- **no_first_meeting_quest:** Grace only offers ordinary dialogue
- **no_quest_without_relationship:** Threshold and distinct meetups required
- **Q2_no_other_npc:** Choose to simplify meal; no spawn forced
- **QF_leave_after_help:** Grace remembers A helped, NOT that A ate with group
- **QF_stay_and_eat:** Grace can remember A actually shared the meal
- **npc_self_resolution:** No credit for player and next stages may still be accessible after distinct visits
- **no_auto_scene_narration:** Never show descriptions/actions as NPC speech

**Đây là kịch bản nguồn, không phải mã Godot.** [JSON kịch bản tách vai trò](village-a-grace-dialogue-flow-v2.json).
