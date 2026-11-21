# Làng A — Clara: Kịch bản gameplay 3 nhiệm vụ theo độ thân thiết (v1 · nháp)
> **DRAFT — chỉ viết nội dung.** Dựa đúng tuyến [Clara trong 24 nhiệm vụ đã phác](village-a-relationship-arcs-v0.md), không đổi ID/thoại gốc `O1/A1/C1/D1`. Tên `Clara` và ngoại hình vẫn thuộc roster đề xuất. Các đồ vật và chỗ đặt bàn là mô tả biên kịch **chưa duyệt dựng**.

## Vai trò và nhịp sống
Clara ấm áp nhưng cầu toàn: cô luôn muốn món ăn đẹp trước khi mang ra, đôi khi quên rằng điều quan trọng là cùng ăn với người khác. A có thể chào hỏi, phụ bày bàn như hoạt động thường, hoặc bỏ đi. **Không có nhiệm vụ khi gặp lần đầu.** Clara không đứng bất động ở khu ăn, cũng không bắt A tham gia mọi bữa.

## Điều kiện quan hệ
- **Q1:** đã trò chuyện, từng tham gia một hoạt động thường với Clara và gặp lại ít nhất một lần; mức thân thiết 20/100 **chỉ là mốc đề xuất**.
- **Q2:** Q1 hoàn thành **hoặc Clara tự giải quyết** sau khi A từ chối, có một lần trở lại không nhiệm vụ, đạt mức quen (tham khảo 50/100) và Clara có tình huống cần giúp.
- **QF:** Q2 đã qua, **hai lần gặp bình thường riêng biệt**, A đã chủ động nghe tâm sự `VLA06-BOND`, đủ tin cậy (tham khảo 80/100), đúng bữa ăn và tự chọn nhận.
- **Không auto-quest:** khi đạt điểm chỉ mở *khả năng có lời nhờ*, không tự nhận hoặc bật mạch truyện liên tục. Từ chối không hủy quan hệ; Clara tự sống tiếp. Không đặt timer ngày-đêm, công thức chế biến, tiền thưởng hoặc đòi Làng B.

## VLA06-Q1 — Bữa ăn đủ ngon

**Khi xuất hiện:** Clara đứng chỉnh vị trí một chiếc đĩa, trong khi các bát còn chưa được đặt lên bàn. Người chơi được tự đi qua; cô không gọi A từ xa.
**Không gian:** Góc chuẩn bị bữa ăn và bàn sinh hoạt chung Làng A (bố trí cụ thể còn nháp)

**Thoại gốc dùng lại (không viết đè):** `VLA06-Q1-O1` → `VLA06-Q1-A1` nếu nhận; `VLA06-Q1-D1` khi từ chối; `VLA06-Q1-C1` chỉ sau thao tác.

### Người chơi thực sự làm
**SET_TABLE — Kiểm bàn, tự cầm từng bát từ kệ thấp rồi đặt đủ các vị trí đã chuẩn bị. Có thể chỉnh một chiếc bát bị đặt lệch.**
*Phản hồi môi trường:* Bát được đặt thực, bàn nhìn sẵn sàng hơn; không chấm điểm vì đẹp tuyệt đối.
- `VLA06-Q1-SET_TABLE-X01` **Clara:** “Tôi cứ thấy chiếc đĩa này lệch.”
- `VLA06-Q1-SET_TABLE-X02` **A:** “Còn mấy chiếc bát chưa được bày.”
- `VLA06-Q1-SET_TABLE-X03` **Clara:** “Ừ. Tôi nhìn mãi một chỗ nên quên mất phần còn lại.”

**CHOICE — Chọn bày đơn giản rồi đem món nóng ra, hoặc chỉnh thêm khăn/bát trước khi ra món. Cả hai là lựa chọn hợp lệ; nếu chỉnh quá lâu, Clara tự đề nghị mang món ra trước, không tạo timer thất bại.**
*Phản hồi môi trường:* Chọn đơn giản: bàn mộc mạc, món được ra sớm. Chọn chỉnh thêm: bàn gọn hơn, Clara thấy mình đang cố cầu toàn; món vẫn được phục vụ.
- `VLA06-Q1-CHOICE-X01` **A:** “Mang món ra trước nhé?”
- `VLA06-Q1-CHOICE-X02` **Clara:** “Nhưng tôi vẫn muốn chỉnh chỗ này một chút.”
- `VLA06-Q1-CHOICE-X03` **A:** “Người ngồi ăn chắc thích món còn nóng hơn.”
- `VLA06-Q1-CHOICE-X04` **Clara:** “... Ừ, cậu nói cũng phải.”

**SERVE — A cầm khay khi được Clara cho phép, mang tới bàn chung và đặt xuống vị trí trống; quay lại báo Clara cùng ngồi/ngắm phản ứng khách có mặt (không xác định danh tính mới).**
*Phản hồi môi trường:* Chỉ phát câu kết gốc sau khi bát và khay đã đặt đúng. Không cần hiển thị cả một đám đông mới.
- `VLA06-Q1-SERVE-X01` **Clara:** “Vậy là mọi thứ đã lên bàn.”
- `VLA06-Q1-SERVE-X02` **A:** “Chưa phải bàn đẹp nhất, nhưng ăn được rồi.”
- `VLA06-Q1-SERVE-X03` **Clara:** “Mà trông mọi người có vẻ vui.”

### Lựa chọn và hệ quả
- **Bày vừa đủ, mang ra khi còn nóng:** Clara nhớ A quan tâm trải nghiệm bữa ăn hơn hình thức.
- **Chỉnh thêm cho gọn rồi mang ra:** Clara nhớ A cũng chú ý chuyện bày bàn, nhưng việc sửa mãi chưa chắc cần thiết.

**Khi A giúp xong:** Một bữa ăn diễn ra tự nhiên; Clara nhớ A đã ưu tiên người ngồi ăn. Gặp lại: “Cảm ơn hôm đó. Cậu giúp tôi nhớ mang món ra trước khi nó nguội.”
**Khi A không nhận hoặc Clara tự làm:** Clara tự bày nhanh và bữa ăn vẫn diễn ra. Gặp lại: “Tôi tự bày nhanh bữa hôm trước. Hóa ra mọi người vẫn ăn ngon.”
**Sau đó:** Clara tiếp tục nấu, thử cách xếp bàn riêng, trò chuyện với người tới ăn; không phát quest mới ngay lần gặp sau.

## VLA06-Q2 — Thử một cách khác

**Khi xuất hiện:** Clara nhìn hai cách chuẩn bị cho cùng một món nhỏ; cô không gọi đó là sáng chế vĩ đại.
**Không gian:** Góc bếp quen thuộc, có sẵn vài nguyên liệu của món ăn thường ngày; tên món và công thức chưa chốt

**Thoại gốc dùng lại (không viết đè):** `VLA06-Q2-O1` → `VLA06-Q2-A1` nếu nhận; `VLA06-Q2-D1` khi từ chối; `VLA06-Q2-C1` chỉ sau thao tác.

### Người chơi thực sự làm
**INSPECT — A xem nguyên liệu đang có và chọn thử mẻ nhỏ thay vì mặc định phải mua hay thu thập vật liệu mới.**
*Phản hồi môi trường:* Hiện hai phương án hợp lý phù hợp nguyên liệu đã có; không tự thêm hệ nghề bếp/công thức mới.
- `VLA06-Q2-INSPECT-X01` **Clara:** “Tôi muốn đổi cách làm một chút, nhưng sợ phí nguyên liệu.”
- `VLA06-Q2-INSPECT-X02` **A:** “Hay thử một phần nhỏ trước?”
- `VLA06-Q2-INSPECT-X03` **Clara:** “Ừ. Hỏng thì cũng không mất cả bữa.”

**PREPARE — Chọn làm biến thể mới hoặc giữ cách quen, tự xếp nguyên liệu vào khay và giúp Clara thao tác chuẩn bị đơn giản, an toàn; Clara phụ trách phần bếp nóng.**
*Phản hồi môi trường:* Món thử có hình thức khác nhau tùy chọn; người chơi không bị ép chọn biến thể mới để thắng.
- `VLA06-Q2-PREPARE-X01` **A:** “Cách này nhìn khác hẳn mọi khi.”
- `VLA06-Q2-PREPARE-X02` **Clara:** “Tôi vẫn hơi lo. Để thử xem sao.”
- `VLA06-Q2-PREPARE-X03` **A:** “Có thể không giống tưởng tượng, nhưng cứ thử đã.”

**TASTE — Sau khi Clara hoàn tất phần chế biến, A và Clara nếm thử một khẩu phần; chọn nhận xét chân thành thay vì tự động khen.**
*Phản hồi môi trường:* Clara lắng nghe: nếu chọn làm mới cô nhớ A đã giúp thử; nếu giữ cách cũ cô thấy việc chủ động lựa chọn cũng đáng quý.
- `VLA06-Q2-TASTE-X01` **Clara:** “Không giống tôi định lúc đầu.”
- `VLA06-Q2-TASTE-X02` **A:** “Nhưng mình biết được điều gì hợp rồi.”
- `VLA06-Q2-TASTE-X03` **Clara:** “Đúng. Không cần bỏ cả phần thử chỉ vì nó khác mong đợi.”

### Lựa chọn và hệ quả
- **Thử biến thể mới với một phần nhỏ:** Clara nhớ A đã động viên thử điều mới, món thử có cách bày khác.
- **Giữ cách quen và thay đổi phần bày:** Clara nhớ A giúp cô tự tin chọn thứ phù hợp, không đánh đồng không đổi với thất bại.
- **Nói rõ điểm thích và điều chưa hợp:** Clara coi trọng nhận xét cụ thể, không tăng thân thiết chỉ vì khen lấy lòng.

**Khi A giúp xong:** Clara dám thử lựa chọn không hoàn hảo mà không vứt món. Gặp lại: “Tôi còn nghĩ về lần thử món đó. Cách mình chọn không phải hoàn hảo, nhưng có ích.”
**Khi A không nhận hoặc Clara tự làm:** Clara thử một mẻ nhỏ vào lúc khác. Gặp lại: “Tôi tự thử một phần nhỏ lúc rảnh. Không tệ như tôi lo.”
**Sau đó:** Clara vẫn nấu món thường ngày; món thử không tự trở thành đặc sản hay quán ăn.

## VLA06-QF — Ngồi xuống ăn cùng nhau

**Khi xuất hiện:** Clara đặt khay xuống, nhìn bàn rồi dừng lại; lần này cô chủ động chuẩn bị một chiếc ghế cho chính mình.
**Không gian:** Khoảng sinh hoạt dùng bữa chung trong Làng A; không mặc định đây là nhà hàng hay café

**Thoại gốc dùng lại (không viết đè):** `VLA06-QF-O1` → `VLA06-QF-A1` nếu nhận; `VLA06-QF-D1` khi từ chối; `VLA06-QF-C1` chỉ sau thao tác.

### Người chơi thực sự làm
**ARRANGE — A kiểm chỗ ngồi, đặt bát và khăn cho số chỗ đã có; chọn tự bày một phần hoặc đề nghị một người đang rảnh phụ, nếu người ấy đồng ý. Không tự triệu hồi NPC.**
*Phản hồi môi trường:* Bàn sẵn sàng và có chỗ thật cho Clara. Nếu không có người khác rảnh, A và Clara vẫn làm được.
- `VLA06-QF-ARRANGE-X01` **Clara:** “Lần này tôi muốn ngồi xuống ngay khi bữa ăn bắt đầu.”
- `VLA06-QF-ARRANGE-X02` **A:** “Vậy phải chừa chỗ cho cô trước.”
- `VLA06-QF-ARRANGE-X03` **Clara:** “Nghe đơn giản thật. Tôi cứ quên làm thế.”

**SHARE — Cùng Clara mang món ra; chọn tự lấy phần hoặc để người tham gia tự lấy theo lời mời. Không bắt A phục vụ tất cả hay buộc NPC khác tham gia.**
*Phản hồi môi trường:* Món ăn và bàn ăn tồn tại như sinh hoạt đời thường, không cần hoạt cảnh cả làng chúc mừng.
- `VLA06-QF-SHARE-X01` **A:** “Mọi thứ đủ rồi. Có cần chỉnh thêm không?”
- `VLA06-QF-SHARE-X02` **Clara:** “Không. Tôi muốn để nguyên như thế.”
- `VLA06-QF-SHARE-X03` **A:** “Vậy ngồi đi.”

**SIT — Chọn ngồi ăn cùng Clara hoặc chào rồi rời đi sau khi đã hỗ trợ. Nếu A ở lại, giao tiếp ngắn diễn ra khi Clara thực sự ngồi; nếu A đi, cô vẫn tự ngồi ăn.**
*Phản hồi môi trường:* Với nhánh A ở lại, quest được hoàn tất khi Clara đã ngồi và bữa ăn bắt đầu. Nhánh A rời sớm sau khi giúp được ghi nhận công sức, nhưng không ghi A đã ăn cùng.
- `VLA06-QF-SIT-X01` **Clara:** “Lạ thật, được ngồi từ đầu dễ chịu hơn hẳn.”
- `VLA06-QF-SIT-X02` **A:** “Bữa ăn ngon nhất có khi là bữa mình không phải chạy đi sửa gì.”
- `VLA06-QF-SIT-X03` **Clara:** “Ừ. Cứ ăn thôi.”

### Lựa chọn và hệ quả
- **Ngồi ăn cùng Clara:** Clara nhớ A đã ở lại chia sẻ bữa ăn.
- **Giúp bày xong rồi đi làm việc riêng:** Clara nhớ A đã giúp chuẩn bị nhưng không tự nhận A từng ngồi ăn cùng.
- **Hỏi một người đang rảnh có muốn phụ không:** Chỉ áp dụng khi NPC khác thật sự có mặt và đồng ý; không tự thêm quan hệ hay nhiệm vụ mới.

**Khi A giúp xong:** Clara tham gia bữa ăn từ đầu; các lần gặp sau cô có thể rủ A ngồi ăn thay vì chỉ nhờ bày bàn. Gặp lại: “Lần trước tôi đã ngồi ăn từ đầu. Hôm nay tôi cũng định làm vậy.”
**Khi A không nhận hoặc Clara tự làm:** Clara chủ động mang món ra rồi ngồi với mọi người, dù A không tham gia. Gặp lại: “Tôi tự bày đủ rồi ngồi ăn cùng mọi người. Đúng là nên thử sớm hơn.”
**Sau đó:** Clara vẫn nấu, bày bữa ăn nhỏ và thỉnh thoảng mời A ngồi; hoàn thành tuyến ba nhiệm vụ không làm nhân vật biến mất.

## Các lần gặp giữa nhiệm vụ — không có dấu nhiệm vụ

### VLA06-IL1 — Một bữa ăn không phải nhiệm vụ
**Mở khi:** `first_distinct_nonquest_return_after_Q1_resolution`. Không tự nhận quest trong lần gặp này.
- `VLA06-IL1-X01` **Clara:** “Hôm nay tôi bày bàn nhanh hơn chút.”
- `VLA06-IL1-X02` **A:** “Không cần chỉnh từng chiếc đĩa à?”
- `VLA06-IL1-X03` **Clara:** “Vẫn muốn, nhưng tôi đang tập thôi.”
**Trạng thái:** `VLA06.nonquest_meetups_after_Q1` (chỉ tính một lượt mới sau khi cuộc trò chuyện trước đã kết thúc).

### VLA06-IL2 — Món ăn thường ngày
**Mở khi:** `first_distinct_nonquest_return_after_Q2_resolution`. Không tự nhận quest trong lần gặp này.
- `VLA06-IL2-X01` **A:** “Hôm nay cô vẫn nấu món quen à?”
- `VLA06-IL2-X02` **Clara:** “Ừ. Không phải bữa nào cũng cần thử cái mới.”
- `VLA06-IL2-X03` **A:** “Nghe hợp lý.”
**Trạng thái:** `VLA06.nonquest_meetups_after_Q2` (chỉ tính một lượt mới sau khi cuộc trò chuyện trước đã kết thúc).

### VLA06-IL3 — Chiếc ghế còn trống
**Mở khi:** `second_distinct_nonquest_return_after_Q2_resolution`. Không tự nhận quest trong lần gặp này.
- `VLA06-IL3-X01` **Clara:** “Tôi đang tính bày thêm một chỗ ngồi.”
- `VLA06-IL3-X02` **A:** “Cho ai thế?”
- `VLA06-IL3-X03` **Clara:** “Tôi vẫn chưa chắc. Có lẽ cho chính mình.”
**Trạng thái:** `VLA06.nonquest_meetups_after_Q2` (chỉ tính một lượt mới sau khi cuộc trò chuyện trước đã kết thúc).

### VLA06-BOND — Chuyện Clara ít khi nói
**Mở khi:** `player_selects_personal_topic_after_Q2_resolved_on_nonquest_visit`. Không tự nhận quest trong lần gặp này.
- `VLA06-BOND-X01` **Clara:** “Có điều này hơi buồn cười. Tôi sợ mọi người thất vọng nếu món ăn không đẹp như tôi tính.”
- `VLA06-BOND-X02` **A:** “Nhưng người ta vẫn đến vì muốn ăn cùng nhau mà.”
- `VLA06-BOND-X03` **Clara:** “Tôi biết. Chỉ có tôi hay nghĩ mình phải làm mọi thứ đúng.”
- `VLA06-BOND-X04` **A:** “Không ai cần cô đứng chỉnh đĩa suốt bữa đâu.”
- `VLA06-BOND-X05` **Clara:** “Ừ. Có lẽ tôi nên ngồi xuống thử.”
**Trạng thái:** `VLA06.personal_bond_event_seen` (chỉ tính một lượt mới sau khi cuộc trò chuyện trước đã kết thúc).

### VLA06-POST — Bữa sau vẫn tiếp tục
**Mở khi:** `normal_return_after_final_quest_resolved`. Không tự nhận quest trong lần gặp này.
- `VLA06-POST-X01` **Clara:** “Chào cậu. Nếu muốn, hôm nay cứ ngồi ăn cùng mọi người.”
- `VLA06-POST-X02` **A:** “Cô không phải lo bày thêm à?”
- `VLA06-POST-X03` **Clara:** “Đủ rồi. Phần còn lại để tôi ăn trước đã.”
**Trạng thái:** `ambient_repeat_only` (chỉ tính một lượt mới sau khi cuộc trò chuyện trước đã kết thúc).

## Biến thể nhớ lựa chọn và tiếp tục cuộc sống
- Khi A **chỉ giúp bày rồi rời đi ở QF**, Clara nhớ A giúp bày nhưng **không** nói A từng ngồi ăn. Khi A ngồi lại, cô nhớ cả bữa ăn chung.
- Nếu Q1/Q2 do Clara tự làm, các lời gặp sau không được nhận A có công lao; tuyến quan hệ vẫn có thể tiến khi A thân thiết qua hoạt động khác.
- Khi A cố chỉnh bát quá lâu, nhân vật có phản hồi mềm; không có thất bại thời gian, không biến việc ăn uống thành minigame năng suất.
- Khi không có NPC phụ tự nguyện trong QF, A và Clara vẫn giải quyết được; không tự sinh người mới hoặc ép Grace xuất hiện.
- Sau QF, Clara vẫn làm việc, ăn uống, có lời chào và hoạt động tự chọn; không bị khóa tương tác.

**Nguồn:** [Clara/Owen/... — 24 nhiệm vụ khung](village-a-relationship-arcs-v0.md) · [ngân hàng thoại 30 cư dân](../dialogue/village-a-dialogues-guide-v0.md) · [JSON chi tiết](village-a-clara-playable-v1.json).
