# Làng A — Hazel: Kịch bản tương tác đầy đủ cho ba nhiệm vụ (v1, nháp)
> **Đây là biên kịch gameplay, chưa duyệt và chưa code.** Giữ nguyên ba nhiệm vụ được phác trong [24 tuyến quest](village-a-relationship-arcs-v0.md). **Tên, tuổi, ngoại hình Hazel đều vẫn là đề xuất từ roster**. Không đổi CH01-007 hoặc các câu thoại nhiệm vụ `O1/A1/C1/D1` đã soạn; file này chỉ **tham chiếu đúng ID** và bổ sung lời thoại/tình huống chi tiết. Khác với cutscene: mọi hoạt động đều phải do người chơi chủ động làm.

## Hazel trong thế giới mở
**Không gian:** góc vườn chung Làng A, những luống non, bình tưới, kệ dụng cụ và một khoảng đất để sau này có thể dùng chung. Các vật thể mới hoặc cách bố trí chi tiết là đề xuất bối cảnh, **không bắt bên 3D phải dựng ngay**.
**Công việc thường ngày:** kiểm độ ẩm đất, chăm rau, xếp lại bình, đôi khi chỉ ngồi nghỉ. Nếu A đi ngang không bắt chuyện, Hazel tiếp tục việc; không bật dấu nhiệm vụ. Không biến Hazel thành người đứng canh luống suốt ngày.
**Cấp mở nháp:** Q1 khi đã quen + cùng làm việc + gặp lại (min friendship 20 dự thảo); Q2 khi thân hơn, Q1 được A làm hoặc Hazel tự giải quyết + ít nhất 1 lần gặp không quest (min 50 dự thảo); QF khi Q2 được giải quyết, ≥2 lần gặp thường và sự kiện gắn bó đã nghe (min 80 dự thảo). **Điểm một mình không mở quest; người chơi phải tự chọn nhận.**
**Từ chối:** Không trừ tình bạn nặng. Hazel có thể tự làm và xuất hiện lời chào phản ánh đúng. Nếu cô đã tự làm, chặng tiếp có thể tiếp tục khi người chơi đã thực sự thân, **không ghi A là người giúp**.

## VLA01-Q1 — Luống rau cần để mắt

**Vị trí:** Góc vườn chung, hai luống non; một luống đất sáng màu hơn, một luống vừa đủ ẩm
**Khi người chơi đến:** Hazel đang quỳ bên hai luống, chạm nhẹ vào đất rồi đứng dậy. Không gọi A từ xa.
**Điều kiện mở:** `npc.met` · `npc.shared_activity_completed_at_least_once` · `npc.return_visit_count>=1` · `npc_available` · `player_chooses_listen_or_offer`; mức thân `20/100` **dự thảo**, thời điểm Hazel đang làm việc phù hợp. Không tự mở khi A vừa hoàn thành quest trước.

### Bắt đầu — lời thoại gốc, không sửa
- **Hazel đề nghị:** `VLA01-Q1-O1` trong [arc gốc](village-a-relationship-arcs-v0.md).
- **A đồng ý:** `VLA01-Q1-A1`. Nếu từ chối: `VLA01-Q1-D1`. Không nhận quest nếu chưa chọn đồng ý.

### Các thao tác và hội thoại

**LOOK:** Tự quan sát hai mảnh đất; chạm đất/so màu, chọn luống thấy khô
*Phản hồi môi trường:* Luống A đất khô mịn, luống B vẫn ẩm và bám tay. Không đặt mũi tên khổng lồ lên luống.
- `VLA01-Q1-LOOK-X01` **Hazel:** “Đất ở luống bên trái đổi màu từ hôm trước rồi.”
- `VLA01-Q1-LOOK-X02` **A:** “Nhìn mặt đất đã đủ biết chưa?”
- `VLA01-Q1-LOOK-X03` **Hazel:** “Chưa hẳn. Thử xem dưới lớp trên một chút.”

**CHOOSE:** Chọn tưới phần khô, hoặc đề nghị Hazel xác nhận trước khi tưới. Nếu lỡ chọn phần ướt, Hazel nhắc kiểm lại và cho sửa.
*Phản hồi môi trường:* Tưới luống khô: đất đổi sắc nhẹ; luống ẩm được giữ nguyên. Lỗi chỉ tạo phản hồi và thử lại, không phá cây.
- `VLA01-Q1-CHOOSE-X01` **Hazel:** “Chỗ ấy còn ẩm đấy. Cậu thử xem luống kia trước được không?”
- `VLA01-Q1-CHOOSE-X02` **A:** “Ừ, tôi nhìn vội quá.”
- `VLA01-Q1-CHOOSE-X03` **Hazel:** “Không sao. Chăm cây có lúc phải dừng tay một chút.”

**REPORT:** Quay lại báo Hazel đã xem cả hai luống và chỉ tưới nơi cần
*Phản hồi môi trường:* Hazel kiểm lại, ghi nhớ A biết quan sát; phát câu kết gốc chỉ ở nhánh đã kiểm đất và hoàn thành.
- `VLA01-Q1-REPORT-X01` **A:** “Tôi để luống kia như cũ. Đất vẫn đủ ẩm.”
- `VLA01-Q1-REPORT-X02` **Hazel:** “Tốt. Vậy tôi yên tâm hơn rồi.”

### Lựa chọn của A
- **Kiểm đất trước:** Đạt bước quan sát cẩn thận, không cộng điểm lặp.
- **Hỏi Hazel cách nhận biết:** Hazel hướng dẫn ngắn, cùng kết quả gameplay.
- **Tưới luôn:** Hazel nhắc sửa, chưa hoàn tất quest cho tới khi kiểm lại; không phạt thân thiết.

**Hoàn thành:** Chỉ sau khi A đã làm thật và báo Hazel mới phát `VLA01-Q1-C1`. Hai luống ghi nhận đã kiểm; luống khô được tưới vừa đủ, luống ẩm giữ nguyên.
**Nếu từ chối / đi luôn:** Hazel tự kiểm và chăm sau khi A rời đi. Không gán A công lao; lần gặp sau Hazel nói: “Tôi tự xem hai luống hôm trước rồi. Cũng may phát hiện chỗ đất khô kịp.”
**Gặp lại nếu A giúp:** Hazel nói: “Tôi vừa nhìn luống hôm trước. Không thấy phần nào bị tưới quá tay.”
**Sau nhiệm vụ:** Sắp tới phải xem đất thêm một lần. Chẳng cần làm gì lớn cả, chỉ cần nhớ nó đang thay đổi.

## VLA01-Q2 — Không thể tưới hết mọi nơi

**Vị trí:** Cùng góc vườn, có bảng nhắc việc/giấy ghi chú tạm và đồ tưới đang dùng
**Khi người chơi đến:** Hazel đứng giữa luống non và kệ dụng cụ, tay cầm hai ghi chú; trông bận nhưng vẫn tự làm việc.
**Điều kiện mở:** `Q1.status in [completed,resolved_without_player]` · `npc.nonquest_meetups_after_Q1>=1` · `npc.available_context_Q2` · `player_chooses_accept`; mức thân `50/100` **dự thảo**, thời điểm Hazel đang làm việc phù hợp. Không tự mở khi A vừa hoàn thành quest trước.

### Bắt đầu — lời thoại gốc, không sửa
- **Hazel đề nghị:** `VLA01-Q2-O1` trong [arc gốc](village-a-relationship-arcs-v0.md).
- **A đồng ý:** `VLA01-Q2-A1`. Nếu từ chối: `VLA01-Q2-D1`. Không nhận quest nếu chưa chọn đồng ý.

### Các thao tác và hội thoại

**COMPARE:** Đọc hai công việc: xem đất ở chỗ nắng gắt và xếp lại đồ tưới đã dùng; A tự chọn thứ nên ưu tiên
*Phản hồi môi trường:* Không có đồng hồ đếm ngược ép lựa chọn. Hazel nói rõ điều gì quan trọng lúc này.
- `VLA01-Q2-COMPARE-X01` **Hazel:** “Một chỗ đất đang khô, còn đống dụng cụ kia thì chưa kịp cất.”
- `VLA01-Q2-COMPARE-X02` **A:** “Luống có cây phải xem trước nhỉ?”
- `VLA01-Q2-COMPARE-X03` **Hazel:** “Ừ. Đồ còn có thể đợi một lát.”

**DIVIDE:** Chọn A kiểm luống, Hazel xếp dụng cụ; hoặc đề nghị Hazel tự xử lý luống và A xếp dụng cụ; nếu muốn nhờ cư dân khác thì phải có người thật sẵn sàng và đồng ý.
*Phản hồi môi trường:* Hai phần việc có người tự nguyện đảm nhận; không tự gán nhiệm vụ cho NPC đang bận.
- `VLA01-Q2-DIVIDE-X01` **A:** “Tôi làm một phần. Phần kia cô chọn đi.”
- `VLA01-Q2-DIVIDE-X02` **Hazel:** “Tôi cứ tưởng tự mình phải làm hết trước khi nhờ ai.”
- `VLA01-Q2-DIVIDE-X03` **A:** “Không cần lúc nào cũng vậy.”

**DO:** Thực hiện phần việc vừa chọn (xem và tưới đúng luống hoặc đặt bình/dụng cụ vào kệ), rồi quay lại xác nhận
*Phản hồi môi trường:* Kệ gọn và luống được xem. Hazel nói lời kết gốc sau khi việc thật sự hoàn tất.
- `VLA01-Q2-DO-X01` **Hazel:** “Xong phần của cậu rồi à?”
- `VLA01-Q2-DO-X02` **A:** “Ừ. Còn phần của cô?”
- `VLA01-Q2-DO-X03` **Hazel:** “Cũng vừa đủ. Được thế này là tốt rồi.”

### Lựa chọn của A
- **Chia việc giữa hai người:** Hazel chủ động giao một việc vừa sức; nhớ A giúp cô tập nhờ người khác.
- **Để tôi làm hết:** Hazel nhắc không cần ôm toàn bộ; người chơi vẫn làm một việc trước rồi cô làm phần còn lại.
- **Hỏi người đang rảnh:** Chỉ có nếu đúng NPC tình nguyện có mặt; không tự sinh người mới hoặc đổi gia đình.

**Hoàn thành:** Chỉ sau khi A đã làm thật và báo Hazel mới phát `VLA01-Q2-C1`. Lịch công việc được phân chia và kệ tưới/luống cây cập nhật ở mức nhỏ.
**Nếu từ chối / đi luôn:** Hazel hoãn một việc không khẩn cấp và tự sắp xếp lại. Không gán A công lao; lần gặp sau Hazel nói: “Tôi đã hoãn bớt một việc hôm ấy, xong đâu vào đấy.”
**Gặp lại nếu A giúp:** Hazel nói: “Tôi đã để lại một khoảng trống trong lịch việc. Hóa ra không có gì đáng sợ.”
**Sau nhiệm vụ:** Dạo này cô hay để một vài việc sang hôm sau hơn trước.

## VLA01-QF — Một góc vườn cho mọi người

**Vị trí:** Rìa vườn chung, hai góc đất có thể trồng cây non mà không chắn lối đi
**Khi người chơi đến:** Hazel đang xem một góc đất trống. Không dựng cổng khu vườn mới, không biến thành lễ hội.
**Điều kiện mở:** `Q2.status in [completed,resolved_without_player]` · `npc.nonquest_meetups_after_Q2>=2` · `npc.personal_bond_event_seen==true` · `npc.available_context_QF` · `player_chooses_accept`; mức thân `80/100` **dự thảo**, thời điểm Hazel đang làm việc phù hợp. Không tự mở khi A vừa hoàn thành quest trước.

### Bắt đầu — lời thoại gốc, không sửa
- **Hazel đề nghị:** `VLA01-QF-O1` trong [arc gốc](village-a-relationship-arcs-v0.md).
- **A đồng ý:** `VLA01-QF-A1`. Nếu từ chối: `VLA01-QF-D1`. Không nhận quest nếu chưa chọn đồng ý.

### Các thao tác và hội thoại

**VISIT_SPOTS:** Quan sát hai góc đất: một dễ tiếp cận và dễ tưới; một nhiều nắng nhưng xa nguồn nước hơn
*Phản hồi môi trường:* Hai vị trí đều khả thi. Không chốt vị trí vườn chung trước khi A chọn.
- `VLA01-QF-VISIT_SPOTS-X01` **Hazel:** “Chỗ này ai đi qua cũng thấy. Góc kia nắng hơn, nhưng tưới xa hơn một chút.”
- `VLA01-QF-VISIT_SPOTS-X02` **A:** “Cô thích góc nào?”
- `VLA01-QF-VISIT_SPOTS-X03` **Hazel:** “Tôi muốn chọn nơi người khác cũng có thể chăm được.”

**DECIDE:** Chọn một góc, thảo luận ưu nhược điểm với Hazel; thử đặt hai cây non theo khoảng cách hợp lý
*Phản hồi môi trường:* Cây không chắn lối; người chơi thấy góc mới đang hình thành.
- `VLA01-QF-DECIDE-X01` **A:** “Chọn góc này nhé. Mọi người có thể ghé mà không dẫm lên luống.”
- `VLA01-QF-DECIDE-X02` **Hazel:** “Ừ. Để thử đặt cách nhau một chút.”
- `VLA01-QF-DECIDE-X03` **A:** “Vậy còn việc chăm?”

**PLANT:** Cùng Hazel đặt cây/kiểm đất lần cuối, để lại nhãn việc chăm tự nguyện (nháp), không ràng buộc người chơi phải tưới mỗi ngày
*Phản hồi môi trường:* Góc cây chung tồn tại, Hazel có công việc mới và không chờ A mãi.
- `VLA01-QF-PLANT-X01` **Hazel:** “Tôi sẽ chăm khi có mặt. Ai muốn góp tay thì cứ hỏi.”
- `VLA01-QF-PLANT-X02` **A:** “Không cần giao hết cho một người.”
- `VLA01-QF-PLANT-X03` **Hazel:** “Ừ. Tôi đang tập quen với điều đó.”

### Lựa chọn của A
- **Gần lối sinh hoạt:** Góc vườn dễ ghé, ít nắng hơn; Hazel chú ý lượng nước phù hợp.
- **Nơi nhiều nắng:** Góc đất thoáng hơn, cần kiểm độ khô nhiều hơn; không phải sai.

**Hoàn thành:** Chỉ sau khi A đã làm thật và báo Hazel mới phát `VLA01-QF-C1`. Một góc vườn nhỏ được A và Hazel cùng chọn, vẫn phát triển khi A vắng; không tự tạo quest thường trực.
**Nếu từ chối / đi luôn:** Hazel vẫn trồng với những cư dân sẵn lòng; A có thể tới xem sau. Không gán A công lao; lần gặp sau Hazel nói: “Tôi bắt đầu góc vườn chung với người rảnh khác. Nếu thích, cậu vẫn có thể ghé.”
**Gặp lại nếu A giúp:** Hazel nói: “Góc vườn cậu cùng chọn đang lớn dần. Hôm nay không cần cậu ở đây suốt đâu.”
**Sau nhiệm vụ:** Có người khác vừa xem luống cây. Hazel để họ tự làm rồi chỉ kiểm lại khi cần.

## Những lần gặp KHÔNG có nhiệm vụ (phải có để thân dần)

### VLA01-IL1 — Q1->Q2
**Điều kiện:** `first_nonquest_revisit_after_Q1_resolution`. Hazel đang checking soil as usual. Đây là tương tác bình thường, **không phải quest mới**. Chỉ tính lần gặp riêng sau khi đã rời cuộc trò chuyện cũ.
- `VLA01-IL1-X01` **Hazel:** “Chỗ đất hôm trước giờ đều hơn rồi.”
- `VLA01-IL1-X02` **A:** “Cô còn phải tưới nhiều chứ?”
- `VLA01-IL1-X03` **Hazel:** “Hôm nào đất cần thì tưới. Không cần sáng nào cũng làm đủ một lượt.”
**Ghi nhận:** `VLA01.nonquest_meetups_after_Q1`; counts_one_distinct_visit.

### VLA01-IL2 — Q2->QF
**Điều kiện:** `first_nonquest_revisit_after_Q2_resolution`. Hazel đang sorting small tools. Đây là tương tác bình thường, **không phải quest mới**. Chỉ tính lần gặp riêng sau khi đã rời cuộc trò chuyện cũ.
- `VLA01-IL2-X01` **Hazel:** “Tôi vừa cất bớt mấy cái bình không dùng tới.”
- `VLA01-IL2-X02` **A:** “Thế là cô đỡ đi lại rồi.”
- `VLA01-IL2-X03` **Hazel:** “Ừ. Tại cứ để ngay trước mắt thì lại muốn làm thêm.”
**Ghi nhận:** `VLA01.nonquest_meetups_after_Q2`; counts_one_distinct_visit.

### VLA01-IL3 — Q2->QF
**Điều kiện:** `second_nonquest_revisit_after_Q2_resolution`. Hazel đang sitting near garden after work. Đây là tương tác bình thường, **không phải quest mới**. Chỉ tính lần gặp riêng sau khi đã rời cuộc trò chuyện cũ.
- `VLA01-IL3-X01` **A:** “Hôm nay cô ngồi nghỉ à?”
- `VLA01-IL3-X02` **Hazel:** “Ừ. Cây đâu có mọc nhanh hơn chỉ vì tôi đứng nhìn.”
- `VLA01-IL3-X03` **A:** “Nghe cũng có lý.”
**Ghi nhận:** `VLA01.nonquest_meetups_after_Q2`; counts_one_other_distinct_visit.

### VLA01-BOND — Q2->QF
**Điều kiện:** `after_Q2_resolution_and_player_selects_personal_talk`. Hazel đang not busy. Đây là tương tác bình thường, **không phải quest mới**. Chỉ tính lần gặp riêng sau khi đã rời cuộc trò chuyện cũ.
- `VLA01-BOND-X01` **Hazel:** “Cậu biết không, tôi ghét phải nói 'giúp tôi một tay'.”
- `VLA01-BOND-X02` **A:** “Vì cô sợ phiền người khác?”
- `VLA01-BOND-X03` **Hazel:** “Không hẳn. Tôi quen tự lo đến mức quên mất mình có thể hỏi.”
- `VLA01-BOND-X04` **A:** “Giúp nhau đôi khi cũng bình thường mà.”
- `VLA01-BOND-X05` **Hazel:** “Ừ. Tôi đang thử nghĩ như vậy.”
**Ghi nhận:** `VLA01.personal_bond_event_seen`; one_time_personal_talk_not_a_quest.

### VLA01-POST — after_QF
**Điều kiện:** `normal_revisit_after_QF_completed_or_alternate`. Hazel đang normal gardening. Đây là tương tác bình thường, **không phải quest mới**. Chỉ tính lần gặp riêng sau khi đã rời cuộc trò chuyện cũ.
- `VLA01-POST-X01` **Hazel:** “À, lại là cậu. Ghé xem luống nào à?”
- `VLA01-POST-X02` **A:** “Chỉ đi ngang qua thôi.”
- `VLA01-POST-X03` **Hazel:** “Ừ. Cứ đi thong thả.”
**Ghi nhận:** `none`; repeat_rotation_not_story_end.

## Kịch bản nhớ người chơi / không bị kẹt tiến trình
- Nếu từng giúp, Hazel nói rõ **A đã làm gì**. Nếu cô tự làm, chỉ nhận mình đã tự làm — hai nhánh không dùng chung lời cảm ơn.
- Q2 không mở ngay khi Q1 kết thúc; phải có cuộc gặp không nhiệm vụ ở lần khác. QF đòi hai cuộc gặp khác nhau và chuyện riêng (BOND).
- Khi đạt đủ điểm nhưng Hazel bận, chỉ phát lời `busy` từ ngân hàng thoại; không lôi người chơi vào quest.
- Nếu chọn sai luống ở Q1, cho quan sát/sửa trong chính nhiệm vụ; không hủy quan hệ vì lỗi thao tác thông thường.
- Sau nhiệm vụ cuối, Hazel vẫn có sinh hoạt vườn, lời hỏi thăm và hoạt động tưới cây tự chọn; **không đóng nhân vật**.
- Không tự tạo làng mới, gia đình Hazel, nông trại quy mô lớn, vật phẩm thưởng hoặc luật thời tiết/mùa chưa chốt.

**Dữ liệu:** [JSON](village-a-hazel-playable-v1.json) · [Hồ sơ ngoại hình đợt 1](../characters/first-wave-npc-visual-identities-v0.md) · [Hội thoại Làng A](../dialogue/village-a-dialogues-guide-v0.md).
