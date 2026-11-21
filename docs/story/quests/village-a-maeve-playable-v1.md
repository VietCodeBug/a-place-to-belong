# Maeve — Kịch bản tương tác 3 nhiệm vụ và khám phá hồ (bản v1)

> **DRAFT biên kịch, chưa tích hợp code.** Khớp khu thủ công A05, sân chung và những ngõ của Làng A hiện có. **Hồ A1 được người sáng tạo duyệt làm địa điểm chính thức**; cuộc gặp Maeve ở đó vẫn là tình tiết đề xuất, không phải NPC đã có trên bản đồ. Giữ nguyên thoại và ID quest từ [arc gốc](village-a-relationship-arcs-v0.md).

**Nhiệm vụ mở theo độ thân thiết đề xuất 20/50/80**, phải có lần gặp thường xen giữa và chọn nhận. Đủ điểm không tự bật nhiệm vụ. Maeve không đứng chờ A; cô làm việc, nghỉ tay và đi lại khi A vắng.

## VLA13-Q1 — Miếng vá vừa tay

**Vị trí:** Sân thủ công A05 ở phía đông sân chung. **Dấu hiệu:** Maeve kiểm miếng lót giỏ đã sờn, cân nhắc một đường vá nhỏ.

**Thoại gốc:** `VLA13-Q1-O1`, `VLA13-Q1-A1`, `VLA13-Q1-C1`, `VLA13-Q1-D1` (không viết đè).

**LOOK:** Chủ động hỏi mục đích của tấm vải; kiểm mép bị kéo căng khi đặt vào chiếc giỏ dùng chung.
- `VLA13-Q1-LOOK-X1` **Maeve:** “Tôi có thể giấu vết rách, nhưng chưa chắc dùng được lâu.”
- `VLA13-Q1-LOOK-X2` **A:** “Tấm lót này chịu lực ở đâu?”
- `VLA13-Q1-LOOK-X3` **Maeve:** “Ở chỗ gấp mép. Cậu thử đặt vào giỏ xem.”

**PICK:** Chọn đường vá có thể nhìn thấy nhưng chắc, hoặc đường vá kín kèm gia cố; có thể thử lại trước khi quyết định.
- `VLA13-Q1-PICK-X1` **A:** “Thì ra gập mép lại mới thấy chỗ dễ bung.”
- `VLA13-Q1-PICK-X2` **Maeve:** “Ừ. Trước giờ tôi cứ nghĩ tới chuyện nhìn cho gọn.”
- `VLA13-Q1-PICK-X3` **A:** “Một đường chỉ thấy rõ cũng đâu có sao.”

**FIX:** Lấy chỉ, giữ mép vải, để Maeve tự khâu rồi cùng thử lại trên chiếc giỏ; chỉ sau thử mới hoàn thành.
- `VLA13-Q1-FIX-X1` **Maeve:** “Giữ góc đó thôi, tôi sẽ khâu.”
- `VLA13-Q1-FIX-X2` **A:** “Thử lại xem có căng quá không.”
- `VLA13-Q1-FIX-X3` **Maeve:** “Không, giờ chắc hơn rồi.”

**Lựa chọn:**
- Ưu tiên đường vá bền, lộ mũi: Maeve nhớ A coi trọng công dụng
- Vá kín và gia cố chỗ chịu lực: Maeve nhớ A cân bằng hình thức và độ bền

**Nếu giúp:** Tấm lót giỏ hôm trước vẫn chắc. Cậu chọn đúng kiểu cho nó.

**Nếu cô tự làm:** Tôi đã tự khâu lại tấm lót. Lần này tôi nhớ thử xem nó có chịu lực không.. Không ghi A đã giúp.

**Sau đó:** Maeve tiếp tục sửa đồ trong sân thủ công; không giao Q2 ngay sau đó.

## VLA13-Q2 — Một chồng đồ đang đợi

**Vị trí:** Sân thủ công A05 và lối đi ngắn ra sân chung. **Dấu hiệu:** Bên bàn có vài món vải do chủ sở hữu đã đồng ý để sửa; Maeve đang không biết nên bắt đầu từ đâu.

**Thoại gốc:** `VLA13-Q2-O1`, `VLA13-Q2-A1`, `VLA13-Q2-C1`, `VLA13-Q2-D1` (không viết đè).

**SORT:** Xem ba loại việc: món cần dùng ở sân chung, món có thể để sau, món chưa xác nhận người gửi; không lấy món thứ ba tự ý.
- `VLA13-Q2-SORT-X1` **Maeve:** “Tôi cứ nhận thêm việc. Lúc trải ra mới thấy nhiều thế này.”
- `VLA13-Q2-SORT-X2` **A:** “Cái nào đang có người cần dùng?”
- `VLA13-Q2-SORT-X3` **Maeve:** “Cái ở sân chung. Hai món kia không vội.”

**DECIDE:** Chọn món ưu tiên và thỏa thuận chỉ xử lý một phần vừa sức; cùng Maeve ghi chú món để hẹn.
- `VLA13-Q2-DECIDE-X1` **A:** “Mình có thể hẹn vài món sang buổi khác.”
- `VLA13-Q2-DECIDE-X2` **Maeve:** “Tôi ngại nói câu đó.”
- `VLA13-Q2-DECIDE-X3` **A:** “Nhưng nói rõ còn hơn hứa rồi không làm kịp.”
- `VLA13-Q2-DECIDE-X4` **Maeve:** “Ừ. Tôi thử nhé.”

**DO:** Giúp chuẩn bị phần vải cần sửa, cất đúng từng nhóm và để Maeve tự kết thúc buổi làm việc.
- `VLA13-Q2-DO-X1` **Maeve:** “Cái bàn bây giờ trống hơn rồi.”
- `VLA13-Q2-DO-X2` **A:** “Hôm nay làm thêm không?”
- `VLA13-Q2-DO-X3` **Maeve:** “Không. Để buổi sau.”

**Lựa chọn:**
- Làm món đang cần trước: Việc được hoàn tất rõ
- Để riêng món chưa rõ người gửi: Không xâm phạm đồ người khác
- Đòi làm hết trong buổi: Maeve tự giới hạn, không mở vòng nhiệm vụ vô hạn

**Nếu giúp:** Từ hôm mình chia việc, tôi đã dám nói món nào cần hẹn sau.

**Nếu cô tự làm:** Tôi tự hẹn bớt một số món. Hóa ra người ta cũng hiểu.. Không ghi A đã giúp.

**Sau đó:** Maeve đôi khi rời bàn sửa đồ để ngồi ở sân chung và không mặc định mang việc theo.

## VLA13-QF — Mũi chỉ có nhiều bàn tay

**Vị trí:** Mái che sân thủ công A05 (không cần nội thất mới). **Dấu hiệu:** Maeve xếp vải mẫu cho một buổi học ngắn với người tự nguyện tham gia.

**Thoại gốc:** `VLA13-QF-O1`, `VLA13-QF-A1`, `VLA13-QF-C1`, `VLA13-QF-D1` (không viết đè).

**PREP:** Sắp một bàn vải mẫu theo thứ tự dễ tới khó, để dụng cụ an toàn ở nơi phù hợp.
- `VLA13-QF-PREP-X1` **Maeve:** “Tôi muốn người thích may có thể tự thử một đường chỉ.”
- `VLA13-QF-PREP-X2` **A:** “Cứ bắt đầu bằng mẫu dễ nhất.”
- `VLA13-QF-PREP-X3` **Maeve:** “Nhỡ tôi giải thích không rõ thì sao?”

**SHOW:** Chỉ mở bước hướng dẫn khi một cư dân phù hợp trong roster tự nguyện có mặt (Tessa là ví dụ, chưa chốt lịch); nếu chưa có người, tạm hoãn.
- `VLA13-QF-SHOW-X1` **A:** “Cô làm mẫu chậm thôi rồi để họ thử.”
- `VLA13-QF-SHOW-X2` **Maeve:** “Ừ. Nếu làm sai thì tháo ra cũng được.”
- `VLA13-QF-SHOW-X3` **A:** “Đúng. Không cần nhanh.”

**HANDOFF:** Người học tự làm một đường chỉ an toàn; Maeve chỉ hướng dẫn, A có thể đứng cạnh giúp khi được hỏi.
- `VLA13-QF-HANDOFF-X1` **Maeve:** “Tôi cứ định đưa tay làm hộ.”
- `VLA13-QF-HANDOFF-X2` **A:** “Nhưng họ đang tự làm được mà.”
- `VLA13-QF-HANDOFF-X3` **Maeve:** “Ừ. Tôi phải tập để người khác thử.”

**Lựa chọn:**
- Làm mẫu trước rồi nhường lượt: Người học thử sau mẫu
- Để người học thử trước: Maeve hướng dẫn từng bước
- Không có ai muốn học thì hoãn: Không tự sinh NPC và không kết thúc sớm

**Nếu giúp:** Có người ghé hỏi tôi thêm một mũi khâu. Tôi thấy vui vì họ tự làm được.

**Nếu cô tự làm:** Tôi tự thử mở một buổi nhỏ. Đã có người muốn học rồi.. Không ghi A đã giúp.

**Sau đó:** Buổi thử may là sinh hoạt tùy chọn; Maeve vẫn sửa đồ, trò chuyện và có thể rời làng đi nghỉ.

## Những lần gặp không giao nhiệm vụ

### VLA13-IL1 · craft_yard

- `VLA13-IL1-X1` **Maeve:** “Tôi vừa thử lại miếng vá cậu từng xem.”
- `VLA13-IL1-X2` **A:** “Có bị tuột không?”
- `VLA13-IL1-X3` **Maeve:** “Không. Một đường chỉ thấy được đôi khi cũng đẹp.”

*Không tự mở quest tiếp theo.*

### VLA13-IL2 · central_square

- `VLA13-IL2-X1` **A:** “Hôm nay cô ngồi nghỉ à?”
- `VLA13-IL2-X2` **Maeve:** “Tôi vừa rời bàn sửa đồ một lát.”
- `VLA13-IL2-X3` **A:** “Cũng phải nghỉ chứ.”

*Không tự mở quest tiếp theo.*

### VLA13-IL3 · craft_yard

- `VLA13-IL3-X1` **Maeve:** “Có người hỏi món còn lại bao giờ xong.”
- `VLA13-IL3-X2` **A:** “Cô nói sao?”
- `VLA13-IL3-X3` **Maeve:** “Tôi bảo chưa chắc, nhưng sẽ báo khi làm được.”

*Không tự mở quest tiếp theo.*

### VLA13-BOND · craft_yard

- `VLA13-BOND-X1` **Maeve:** “Tôi luôn giúp người khác sửa đồ, còn nhờ một người giữ vải hộ thì ngại.”
- `VLA13-BOND-X2` **A:** “Cô sợ họ nghĩ mình không giỏi?”
- `VLA13-BOND-X3` **Maeve:** “Ừ. Tôi cứ nghĩ người sửa đồ thì phải tự làm hết.”
- `VLA13-BOND-X4` **A:** “Nhờ giúp cũng là một cách làm việc cùng nhau.”
- `VLA13-BOND-X5` **Maeve:** “Có lẽ tôi sẽ thử hỏi dễ dàng hơn.”

*Không tự mở quest tiếp theo.*

### VLA13-POST · central_square

- `VLA13-POST-X1` **Maeve:** “Hôm nay tôi chỉ nhận một món cần sửa.”
- `VLA13-POST-X2` **A:** “Vậy buổi chiều còn rảnh à?”
- `VLA13-POST-X3` **Maeve:** “Ừ. Tôi muốn đi dạo một chút.”

*Không tự mở quest tiếp theo.*

### VLA13-LAKE_OPTIONAL · approved_A1_lake_shore

- `VLA13-LAKE_OPTIONAL-X1` **A:** “Tôi không ngờ gặp cô ở bờ hồ.”
- `VLA13-LAKE_OPTIONAL-X2` **Maeve:** “Hôm nay tôi muốn ngồi nhìn mặt nước, không nghĩ về đường kim nào cả.”
- `VLA13-LAKE_OPTIONAL-X3` **A:** “Không mang đồ để sửa theo thật à?”
- `VLA13-LAKE_OPTIONAL-X4` **Maeve:** “Không. Tôi để chúng ở làng rồi.”

*Không tự mở quest tiếp theo.*

**Ghi chú hồ:** Hồ, lối xuống bến và vùng bờ đá/cỏ đã là không gian A1 được m duyệt; kịch bản Maeve nghỉ ngơi ở bờ chỉ xuất hiện *nếu có lịch đi dạo phù hợp*, không yêu cầu lặn, không bắt người chơi đi hồ mới xong tuyến nghề may. Các đồ vải mẫu chưa phải assets đã dựng.

[JSON chi tiết](village-a-maeve-playable-v1.json).
