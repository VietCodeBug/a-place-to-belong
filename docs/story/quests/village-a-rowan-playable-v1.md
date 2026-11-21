# Làng A — Rowan: Kịch bản gameplay 3 nhiệm vụ theo độ thân thiết (v1 · nháp)
> **DRAFT — chỉ viết biên kịch.** Kế thừa đúng ba nhiệm vụ trong [24 tuyến cư dân chính](village-a-relationship-arcs-v0.md), **không sửa thoại gốc O1/A1/C1/D1**. Rowan là `VLA-09`, người chăm lối đi rừng; **không tự biến ông thành thợ săn, kiểm lâm chính thức hoặc trưởng làng**. Tình trạng đường, cành/hoa, ký hiệu là **đề xuất nội dung**, không phải yêu cầu dựng 3D ngay.

## Rowan khi người chơi không làm nhiệm vụ
Ông vẫn đi dọc những lối mòn quanh Làng A, nhìn tình trạng đất, dời nhánh khô chắn đường, quan sát vạt hoa hoặc ngồi nghỉ. Không có bảng nhiệm vụ trên đầu, không ngăn người chơi đi rừng; **mọi đường đang mở vẫn mở dù A từ chối nhiệm vụ**.

## Mốc quan hệ (đề xuất)
- **Q1:** đã gặp, cùng dọn một nhánh cây như hoạt động thường, gặp lại trong lượt khác, mức thân ≥20/100 tham khảo.
- **Q2:** Q1 được A làm hoặc Rowan tự giải quyết, có ít nhất một lần trò chuyện không quest sau đó, mức quen ≥50/100 tham khảo.
- **QF:** Q2 đã giải quyết, có hai lượt gặp bình thường khác nhau và nghe tâm sự `VLA09-BOND` khi chủ động hỏi; mức tin cậy ≥80/100 tham khảo.
- **Không ép:** điểm đạt ngưỡng không tự nhận quest, Rowan chỉ đề nghị nếu đúng việc đang cần và A chủ động trò chuyện; không giao nhiệm vụ tiếp theo trong cùng lần gặp.

## VLA09-Q1 — Lối đi sau vạt cỏ

**Khi xuất hiện:** Rowan nhìn một nhánh khô chắn nửa vệt đi qua, còn cỏ mọc ở mép. Ông đang tự xem cách đi, không đứng chờ A.
**Không gian:** Đoạn đường đất sẵn có ở rìa Làng A, sát một vạt cỏ và hoa dại; không mở đường hoặc địa điểm mới

**Thoại gốc dùng lại:** `VLA09-Q1-O1` lời nhờ → `VLA09-Q1-A1` nhận → `VLA09-Q1-C1` khi làm xong; `VLA09-Q1-D1` nếu từ chối.

### Các bước gameplay
**READ_PATH — A đi bộ quan sát hai mép lối mòn, tìm vệt chân người đi và nơi nhánh khô thực sự vướng; có thể thử lối vòng ở ngay cạnh.**
*Phản hồi môi trường:* Hiện hai dấu hiệu trực quan: vệt đi lại ở giữa và hoa ở mép; không hiện dấu X nhiệm vụ trên mọi bụi cây.
- `VLA09-Q1-READ_PATH-X01` **Rowan:** “Người đi qua đoạn này cứ né ra ngoài.”
- `VLA09-Q1-READ_PATH-X02` **A:** “Vì cành khô nằm ngang lối à?”
- `VLA09-Q1-READ_PATH-X03` **Rowan:** “Ừ. Để ý xem họ dẫm vào đâu khi tránh.”

**CLEAR_MINIMAL — Chọn dời nhánh khô duy nhất đang cản bước vào chỗ an toàn; nếu chọn dọn cả bụi cỏ, Rowan ngăn lại và hỏi liệu có thật cần không.**
*Phản hồi môi trường:* Nhánh được dời; vạt hoa giữ nguyên. Lựa chọn dọn quá rộng chỉ kích hoạt trao đổi rồi được điều chỉnh, không cho xóa sinh cảnh bằng một nút bấm.
- `VLA09-Q1-CLEAR_MINIMAL-X01` **A:** “Chỉ dời cành này là đủ chỗ đi.”
- `VLA09-Q1-CLEAR_MINIMAL-X02` **Rowan:** “Đúng. Cỏ bên kia không ngăn ai cả.”
- `VLA09-Q1-CLEAR_MINIMAL-X03` **A:** “Vậy cứ để nó mọc.”

**WALK_TEST — Đi thử qua lối vừa sửa từ hai đầu đường, kiểm có đủ chỗ tránh một vật cản nhỏ; quay lại trao đổi với Rowan.**
*Phản hồi môi trường:* Lối vẫn nối rừng và làng, người chơi có thể đi bình thường; hoàn thành chỉ sau khi đã thử đường.
- `VLA09-Q1-WALK_TEST-X01` **Rowan:** “Giờ đi thử đi.”
- `VLA09-Q1-WALK_TEST-X02` **A:** “Qua được rồi, không phải giẫm lên hoa.”
- `VLA09-Q1-WALK_TEST-X03` **Rowan:** “Vậy là đủ rồi.”

### Lựa chọn và hậu quả
- **Chỉ dọn thứ chắn lối:** Rowan nhận ra A cân nhắc sự sống quanh đường.
- **Đề nghị dọn rộng hơn:** Rowan giải thích vì sao chưa cần; A vẫn có thể chọn cách phù hợp và hoàn thành, không bị trừ điểm nặng.
- **Thử đi vòng trước khi dọn:** Nếu đoạn vòng không tiện, dời cành vẫn là cách tối thiểu.

**Nếu A tham gia đến cùng:** Một đoạn lối đi rõ hơn nhưng không trơ đất. Gặp lại Rowan nói: “Đoạn hôm trước cậu cùng xem vẫn dễ đi. Hoa cũng không bị giẫm thêm.”
**Nếu A không giúp / Rowan tự làm:** Rowan tự dọn phần vướng nhỏ nhất. Gặp lại: “Tôi tự dời cành hôm đó. Đường thông là được.”
**Sinh hoạt sau đó:** Rowan lại tuần đường, xem cây, nghỉ chân; không tự bật nhiệm vụ mới khi A vừa quay lại.

## VLA09-Q2 — Một đường vòng nhỏ

**Khi xuất hiện:** Rowan quan sát dấu chân đã đi lệch sang chỗ hoa vì tránh một vệt đất ẩm; ông chưa đặt biển cấm hay đóng lối.
**Không gian:** Khúc đường rìa Làng A có một góc đất ẩm và vạt hoa dại, đều nằm trong vùng đã được mở đi lại

**Thoại gốc dùng lại:** `VLA09-Q2-O1` lời nhờ → `VLA09-Q2-A1` nhận → `VLA09-Q2-C1` khi làm xong; `VLA09-Q2-D1` nếu từ chối.

### Các bước gameplay
**COMPARE — A đi thử/quan sát hai lựa chọn đã có: đường ngắn gần vệt ẩm và đường vòng khô hơn; kiểm xem hướng nào an toàn mà ít đụng hoa.**
*Phản hồi môi trường:* Thấy dấu giày trượt ở mép đất ẩm và vùng hoa dại dễ bị dẫm. Không đặt bẫy khiến A bắt buộc trượt ngã.
- `VLA09-Q2-COMPARE-X01` **Rowan:** “Chỗ đất này cứ mềm ra khi có người đi nhiều.”
- `VLA09-Q2-COMPARE-X02` **A:** “Nên họ tránh sang phía hoa.”
- `VLA09-Q2-COMPARE-X03` **Rowan:** “Ừ. Cần một lối dễ hiểu hơn, không phải chặn hết đường.”

**CHOOSE_ROUTE — Chọn dẫn người đi theo dải đất khô (dù vòng một chút) hoặc giữ lối ngắn khi điều kiện đủ an toàn và làm rõ phần mép cần tránh. Nếu chọn lối không an toàn, Rowan gợi ý xem lại.**
*Phản hồi môi trường:* Đường đi có dấu định hướng nhẹ, không mở khóa khu bản đồ hay tự sinh tuyến giao hàng.
- `VLA09-Q2-CHOOSE_ROUTE-X01` **A:** “Phía này khô hơn. Đi vòng một đoạn thôi.”
- `VLA09-Q2-CHOOSE_ROUTE-X02` **Rowan:** “Không hẳn ai cũng thích đường dài.”
- `VLA09-Q2-CHOOSE_ROUTE-X03` **A:** “Nhưng người ta sẽ nhìn ra nơi nên đặt chân.”
- `VLA09-Q2-CHOOSE_ROUTE-X04` **Rowan:** “Ừ, thế quan trọng hơn.”

**MARK — Cùng Rowan đặt một dấu chỉ hướng tạm bằng vật liệu đã có/được phép hoặc chỉ chỉnh lại nhánh cây báo mép, rồi thử đi từ hai đầu.**
*Phản hồi môi trường:* Giữ vạt hoa, lối dùng được. Không gọi đây là biển báo của cả làng nếu chưa được chốt vật liệu.
- `VLA09-Q2-MARK-X01` **Rowan:** “Đứng ở đầu kia nhìn xem có hiểu hướng đi không.”
- `VLA09-Q2-MARK-X02` **A:** “Thấy rồi. Không cần làm dấu to quá.”
- `VLA09-Q2-MARK-X03` **Rowan:** “Đúng. Chỉ cần người đi chú ý chút.”

### Lựa chọn và hậu quả
- **Chọn lối khô vòng nhẹ:** Vạt hoa được giữ, ít có nguy cơ đi lạc mép đất ẩm.
- **Giữ đường ngắn nhưng chỉ rõ mép an toàn:** Cần Rowan xác nhận mặt đất đủ vững; nếu không đủ thì chọn lại, không xem đó là lựa chọn sai đạo đức.
- **Hỏi vì sao nên giữ hoa:** Rowan chia sẻ suy nghĩ thực tế về sinh cảnh, không mở bí mật giấc mơ hay hệ săn bắn.

**Nếu A tham gia đến cùng:** Dấu lối đi tự nhiên thay đổi nhẹ, không cần phá cây hàng loạt. Gặp lại Rowan nói: “Dấu rẽ hôm trước vẫn đủ để mọi người chọn đường khô. Hoa không bị đạp thành lối mới nữa.”
**Nếu A không giúp / Rowan tự làm:** Rowan tự hướng người qua đoạn khô và chờ đất hồi phục. Gặp lại: “Tôi tự gợi một lối qua đoạn khô. Cứ để đất ẩm hồi lại đã.”
**Sinh hoạt sau đó:** Rowan đi kiểm lại con đường như thường. Không biến mọi lần mưa thành nhiệm vụ sửa đường; chưa quy định hệ thời tiết cho vùng.

## VLA09-QF — Con đường mọi người cùng giữ

**Khi xuất hiện:** Rowan xem ba dấu ghi chép: cành chắn lối, đất mềm và hoa mọc sát vệt đi. Ông muốn cách để mọi người tự chú ý mà không làm người khác phụ thuộc vào ông.
**Không gian:** Một góc quen cạnh lối đi chung với ba điểm nhỏ cần bảo dưỡng, không phải bảng nhiệm vụ vô tận

**Thoại gốc dùng lại:** `VLA09-QF-O1` lời nhờ → `VLA09-QF-A1` nhận → `VLA09-QF-C1` khi làm xong; `VLA09-QF-D1` nếu từ chối.

### Các bước gameplay
**SURVEY — A cùng Rowan đi xem ba điểm nằm trong vùng quen thuộc, xác định điểm cần can thiệp sớm và điểm chỉ cần quan sát.**
*Phản hồi môi trường:* Ba điểm được đánh dấu trạng thái tương ứng; không yêu cầu dọn sạch cả con đường.
- `VLA09-QF-SURVEY-X01` **Rowan:** “Tôi cứ đi một vòng rồi lại thấy mình phải làm hết.”
- `VLA09-QF-SURVEY-X02` **A:** “Mấy điểm này đâu có giống nhau.”
- `VLA09-QF-SURVEY-X03` **Rowan:** “Ừ. Có chỗ cần dọn, có chỗ chỉ cần để mắt.”

**DESCRIBE — Chọn cách ghi hướng dẫn thật ngắn theo tình huống: 'dời cành chắn lối', 'đi qua chỗ khô', 'chừa hoa dại'. Có thể chọn ký hiệu tối giản thay cho bảng to.**
*Phản hồi môi trường:* Ghi chú/ký hiệu xuất hiện ở góc chung nếu địa điểm được duyệt; không mọc bảng quest tự động trên đầu dân làng.
- `VLA09-QF-DESCRIBE-X01` **A:** “Không cần ghi ai phải làm cả. Chỉ ghi điều nên chú ý.”
- `VLA09-QF-DESCRIBE-X02` **Rowan:** “Cậu nghĩ người khác sẽ xem chứ?”
- `VLA09-QF-DESCRIBE-X03` **A:** “Nếu dễ hiểu và không bắt buộc thì có người sẽ xem.”
- `VLA09-QF-DESCRIBE-X04` **Rowan:** “Vậy thử như thế.”

**DO_ONE — A chủ động dời một nhánh nhỏ chắn bước hoặc chỉnh lại dấu lối ở một điểm; Rowan tự xử lý phần còn lại và không giao hàng loạt việc cho người chơi.**
*Phản hồi môi trường:* Một thay đổi thực ở đường và một hướng dẫn cộng đồng nhỏ. Rowan không cần lúc nào cũng đứng canh đường.
- `VLA09-QF-DO_ONE-X01` **Rowan:** “Cậu chọn làm một điểm thôi à?”
- `VLA09-QF-DO_ONE-X02` **A:** “Ừ. Còn lại để ai thấy cần thì góp tay.”
- `VLA09-QF-DO_ONE-X03` **Rowan:** “Tôi đã quen tự mình lo nhiều quá.”
- `VLA09-QF-DO_ONE-X04` **A:** “Nhưng đường này đâu phải của riêng ông.”

### Lựa chọn và hậu quả
- **Chỉ ghi những điều cần nhớ:** Rowan thấy hướng dẫn dễ hiểu, không biến đường rừng thành bảng quảng cáo.
- **Ưu tiên chỗ dễ vấp:** Một điểm được sửa, hai điểm còn lại chỉ ghi nhận; không khóa tiến trình.
- **Giữ nguyên nơi cây không chắn đường:** Rowan tin A phân biệt giữa cần chăm và cần để yên.

**Nếu A tham gia đến cùng:** Đường rừng có dấu chăm sóc nhỏ từ cộng đồng; Rowan không còn thấy mình phải làm mọi việc. Gặp lại Rowan nói: “Tôi thấy có người tự dời một nhánh vướng. Cái ghi chú nhỏ có ích đấy.”
**Nếu A không giúp / Rowan tự làm:** Rowan ghi lại các điểm cần chăm, nhờ ai rảnh tự nguyện tham gia. Gặp lại: “Tôi đã ghi lại vài chỗ cần chăm. Có người rảnh thì họ tự giúp, không phải chờ tôi.”
**Sinh hoạt sau đó:** Rowan tiếp tục giữ lối đi, quan sát thiên nhiên, thỉnh thoảng nghỉ; không trở thành người quản lý săn bắn hoặc lãnh đạo làng.

## Những lần gặp không nhiệm vụ (bắt buộc có khoảng cách giữa các chặng)

### VLA09-IL1 — Đi qua lối quen
**Mở khi:** `first_distinct_nonquest_return_after_Q1_resolution`, người chơi tự chọn hỏi.
- `VLA09-IL1-X01` **Rowan:** “Đi qua đoạn đường ấy rồi à?”
- `VLA09-IL1-X02` **A:** “Ừ, không còn phải bước vòng.”
- `VLA09-IL1-X03` **Rowan:** “Tốt. Để xem cây ở mép đường hồi lại thế nào.”
**Ghi nhận:** `VLA09.nonquest_meetups_after_Q1`; không mở quest tiếp trong lượt này.

### VLA09-IL2 — Sau một lượt kiểm đường
**Mở khi:** `first_distinct_nonquest_return_after_Q2_resolution`, người chơi tự chọn hỏi.
- `VLA09-IL2-X01` **A:** “Hôm nay ông đi xem đường à?”
- `VLA09-IL2-X02` **Rowan:** “Ừ. Có vài chỗ cứ để nguyên là tốt nhất.”
- `VLA09-IL2-X03` **A:** “Không phải cái gì cũng cần dọn nhỉ.”
**Ghi nhận:** `VLA09.nonquest_meetups_after_Q2`; không mở quest tiếp trong lượt này.

### VLA09-IL3 — Đứng ngắm hoa
**Mở khi:** `second_distinct_nonquest_return_after_Q2_resolution`, người chơi tự chọn hỏi.
- `VLA09-IL3-X01` **Rowan:** “Hoa ở mép này bắt đầu mở rồi.”
- `VLA09-IL3-X02` **A:** “Tôi suýt không để ý.”
- `VLA09-IL3-X03` **Rowan:** “Vì người ta hay chỉ nhìn nơi mình định bước. Tôi cũng từng thế.”
**Ghi nhận:** `VLA09.nonquest_meetups_after_Q2`; không mở quest tiếp trong lượt này.

### VLA09-BOND — Một chuyện Rowan từng làm
**Mở khi:** `player_selects_personal_topic_after_Q2_resolved_on_nonquest_visit`, người chơi tự chọn hỏi.
- `VLA09-BOND-X01` **Rowan:** “Hồi trước tôi cứ nghĩ đường càng sạch càng tốt.”
- `VLA09-BOND-X02` **A:** “Rồi ông đổi ý à?”
- `VLA09-BOND-X03` **Rowan:** “Tôi dọn cả những bụi hoa không chắn ai. Sau mới thấy đường vắng vẻ hẳn.”
- `VLA09-BOND-X04` **A:** “Bây giờ ông chỉ dọn phần cần thiết.”
- `VLA09-BOND-X05` **Rowan:** “Ừ. Phải đi chậm lại mới biết nên giữ thứ gì.”
**Ghi nhận:** `VLA09.personal_bond_event_seen`; không mở quest tiếp trong lượt này.

### VLA09-POST — Công việc vẫn tiếp tục
**Mở khi:** `normal_return_after_final_quest_resolved`, người chơi tự chọn hỏi.
- `VLA09-POST-X01` **Rowan:** “Cậu đi về phía rừng à?”
- `VLA09-POST-X02` **A:** “Ừ, tôi muốn nhìn thêm chút.”
- `VLA09-POST-X03` **Rowan:** “Đường vẫn thông. Cứ nhìn hai bên, có nhiều thứ đáng xem.”
**Ghi nhận:** `chỉ lời chào bình thường`; không mở quest tiếp trong lượt này.

## Nhánh dài hạn, không khóa khám phá
- Người chơi có quyền tới rừng trước, trong hoặc sau bất kỳ Q nào. Nhiệm vụ Rowan **không mở cổng bản đồ** và không cản đường.
- Nếu chọn dọn quá rộng, Rowan thảo luận rồi gợi cách ít tác động hơn. Đó là lựa chọn có phản hồi, **không khiến thế giới bị phá hoặc tuyến bị khóa vĩnh viễn**.
- Với Q2, phương án đường ngắn chỉ hợp lệ nếu mặt đất đủ an toàn; nếu không, Rowan giúp người chơi nhìn lại. Không coi lựa chọn là phán xét đạo đức.
- Nếu Rowan tự giải quyết Q1/Q2 trong lúc A không giúp, lần sau phải dùng lời ghi nhớ *Rowan tự làm*, không nói A từng hỗ trợ.
- Sau QF ông vẫn có công việc, chuyện hỏi thăm về cây cỏ, không trở thành cỗ máy giao 10 quest dọn đường. Hệ săn bắn là hoạt động tùy chọn riêng, chưa gán cho Rowan.

**Nguồn:** [24 tuyến nhiệm vụ](village-a-relationship-arcs-v0.md) · [hội thoại 30 cư dân](../dialogue/village-a-dialogues-guide-v0.md) · [JSON chi tiết](village-a-rowan-playable-v1.json).
