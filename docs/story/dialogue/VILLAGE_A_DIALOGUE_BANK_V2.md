# Làng A — Hội thoại đời thường V2 (DIALOGUE ONLY)

**DRAFT_STORY.** Tất cả 30 cư dân, không giao quest trong bất kỳ nhóm nào dưới đây. Đây là thoại bổ sung/thay thế vòng lặp đời thường sau khi duyệt; thoại gốc Thomas và CH01-007 giữ nguyên. Không chèn mô tả tình huống vào ô thoại. Mỗi lần gặp chỉ chọn một nhóm phù hợp; chủ đề riêng mở khi A chủ động chọn. Câu chào ở trạng thái đã gặp không được phát lúc lần đầu. Các sở thích/kỷ niệm mới chỉ là đề xuất, không tự nâng thành canon.

## Hazel (VLA-01) — thẳng thắn, kiên nhẫn

### DLG-VLA01-V2-GREETING

TRIGGER: player_initiates_talk; GUARDS: npc_available, npc.met.

- `DLG-VLA01-V2-GREETING-L1` **Hazel:** “Đừng đạp luống bên trái. Còn bên phải thì cứ đi, tôi chưa trồng gì cả.”

### DLG-VLA01-V2-SMALLTALK

TRIGGER: player_selects_topic:smalltalk; GUARDS: npc_available, npc.met.

- `DLG-VLA01-V2-SMALLTALK-L1` **Hazel:** “Cậu trồng cây bao giờ chưa? Tôi từng tưới chết một chậu vì thương nó quá.”

### DLG-VLA01-V2-REST

TRIGGER: player_initiates_talk; GUARDS: npc_available, npc_currently_resting.

- `DLG-VLA01-V2-REST-L1` **Hazel:** “Hôm nay tôi nghỉ sớm. Cây không biết xem đồng hồ, còn tôi thì có.”

### DLG-VLA01-V2-REVISIT

TRIGGER: player_initiates_talk; GUARDS: npc_available, distinct_return_visit.

- `DLG-VLA01-V2-REVISIT-L1` **Hazel:** “Mấy hôm rồi không thấy cậu. Đừng bảo lại lạc trong rừng nhé.”

### DLG-VLA01-V2-PERSONAL

TRIGGER: player_selects_choice:personal_topic; GUARDS: npc_available, relationship_familiar_or_above.

PLAYER_CHOICE: Cô thích mùa nào nhất? / Để khi khác nhé. (chỉ hiện menu).

- `DLG-VLA01-V2-PERSONAL-L1` **Hazel:** “Mùa cây vừa nhú. Còn mùa thu hoạch thì tôi thích lúc nhìn người khác ăn hơn là lúc đếm từng củ.”

## Nora (VLA-02) — nhẹ nhàng, tinh ý

### DLG-VLA02-V2-GREETING

TRIGGER: player_initiates_talk; GUARDS: npc_available, npc.met.

- `DLG-VLA02-V2-GREETING-L1` **Nora:** “Ngửi thấy mùi gì không? Tôi vừa vò một chiếc lá. Đừng ăn thử, chưa chắc là thứ cậu nghĩ đâu.”

### DLG-VLA02-V2-SMALLTALK

TRIGGER: player_selects_topic:smalltalk; GUARDS: npc_available, npc.met.

- `DLG-VLA02-V2-SMALLTALK-L1` **Nora:** “Tôi thích ngồi ngoài hiên khi trời vừa tạnh. Mỗi người đi qua mang theo một câu chuyện.”

### DLG-VLA02-V2-REST

TRIGGER: player_initiates_talk; GUARDS: npc_available, npc_currently_resting.

- `DLG-VLA02-V2-REST-L1` **Nora:** “Chậu này mãi không chịu lớn. Chắc nó có tính giống tôi.”

### DLG-VLA02-V2-REVISIT

TRIGGER: player_initiates_talk; GUARDS: npc_available, distinct_return_visit.

- `DLG-VLA02-V2-REVISIT-L1` **Nora:** “Cậu ngồi đây một lát được đấy. Tôi đang nghe chim, chẳng có gì quan trọng.”

## Finn (VLA-03) — tò mò, hay quên

### DLG-VLA03-V2-GREETING

TRIGGER: player_initiates_talk; GUARDS: npc_available, npc.met.

- `DLG-VLA03-V2-GREETING-L1` **Finn:** “Suỵt! Con bé tí kia chạy nhanh hơn cháu tưởng.”

### DLG-VLA03-V2-SMALLTALK

TRIGGER: player_selects_topic:smalltalk; GUARDS: npc_available, npc.met.

- `DLG-VLA03-V2-SMALLTALK-L1` **Finn:** “Cháu đặt tên cho một con bọ rồi. Nhưng nó có chịu đứng lại nghe tên đâu.”

### DLG-VLA03-V2-REST

TRIGGER: player_initiates_talk; GUARDS: npc_available, npc_currently_resting.

- `DLG-VLA03-V2-REST-L1` **Finn:** “Hôm nay cháu đếm được ba loại bọ. Có thể là hai, một con quay lại.”

### DLG-VLA03-V2-REVISIT

TRIGGER: player_initiates_talk; GUARDS: npc_available, distinct_return_visit.

- `DLG-VLA03-V2-REVISIT-L1` **Finn:** “Chú có biết con gì đi được trên lá mà không làm lá rung không? Cháu đang đoán.”

## Owen (VLA-04) — ít lời, cẩn thận

### DLG-VLA04-V2-GREETING

TRIGGER: player_initiates_talk; GUARDS: npc_available, npc.met.

- `DLG-VLA04-V2-GREETING-L1` **Owen:** “Chào. Cẩn thận cái ghế kia, nó đang chờ sửa.”

### DLG-VLA04-V2-SMALLTALK

TRIGGER: player_selects_topic:smalltalk; GUARDS: npc_available, npc.met.

- `DLG-VLA04-V2-SMALLTALK-L1` **Owen:** “Tôi thích cái bàn cũ. Ít nhất nó không nói dối về chỗ bị lung lay.”

### DLG-VLA04-V2-REST

TRIGGER: player_initiates_talk; GUARDS: npc_available, npc_currently_resting.

- `DLG-VLA04-V2-REST-L1` **Owen:** “Nghỉ tay một lát. Cưa gỗ lúc cáu thì chỉ phí gỗ.”

### DLG-VLA04-V2-REVISIT

TRIGGER: player_initiates_talk; GUARDS: npc_available, distinct_return_visit.

- `DLG-VLA04-V2-REVISIT-L1` **Owen:** “Cậu lại đây à. Ngồi được rồi, cái ghế hôm nay không phản đối nữa.”

### DLG-VLA04-V2-PERSONAL

TRIGGER: player_selects_choice:personal_topic; GUARDS: npc_available, relationship_familiar_or_above.

PLAYER_CHOICE: Ông có lúc làm hỏng đồ không? / Để khi khác nhé. (chỉ hiện menu).

- `DLG-VLA04-V2-PERSONAL-L1` **Owen:** “Có. Tôi không kể tên cái ghế. Nó đã chịu đủ rồi.”

## June (VLA-05) — nhanh nhẹn, thực tế

### DLG-VLA05-V2-GREETING

TRIGGER: player_initiates_talk; GUARDS: npc_available, npc.met.

- `DLG-VLA05-V2-GREETING-L1` **June:** “Nếu thấy một cái búa nằm sai chỗ thì đừng bảo Owen là tôi nói nhé.”

### DLG-VLA05-V2-SMALLTALK

TRIGGER: player_selects_topic:smalltalk; GUARDS: npc_available, npc.met.

- `DLG-VLA05-V2-SMALLTALK-L1` **June:** “Tôi ghi việc cần làm ra giấy. Đôi khi lại phải ghi thêm việc đi tìm tờ giấy.”

### DLG-VLA05-V2-REST

TRIGGER: player_initiates_talk; GUARDS: npc_available, npc_currently_resting.

- `DLG-VLA05-V2-REST-L1` **June:** “Hôm nay chẳng ai hỏi tôi để đồ ở đâu. Lạ thật.”

### DLG-VLA05-V2-REVISIT

TRIGGER: player_initiates_talk; GUARDS: npc_available, distinct_return_visit.

- `DLG-VLA05-V2-REVISIT-L1` **June:** “Cậu có vẻ biết đường trong làng rồi. Tốt, tôi đỡ phải vẽ bằng tay.”

## Clara (VLA-06) — ấm áp, cầu toàn

### DLG-VLA06-V2-GREETING

TRIGGER: player_initiates_talk; GUARDS: npc_available, npc.met.

- `DLG-VLA06-V2-GREETING-L1` **Clara:** “Khoan, đừng nếm vội. Tôi còn chưa quyết có nên thêm chút gì không.”

### DLG-VLA06-V2-SMALLTALK

TRIGGER: player_selects_topic:smalltalk; GUARDS: npc_available, npc.met.

- `DLG-VLA06-V2-SMALLTALK-L1` **Clara:** “Tôi làm một mẻ bánh nhìn xấu đến mức Felix bảo đó là đá trang trí.”

### DLG-VLA06-V2-REST

TRIGGER: player_initiates_talk; GUARDS: npc_available, npc_currently_resting.

- `DLG-VLA06-V2-REST-L1` **Clara:** “Món hôm nay cứ để vậy. Tôi đã nếm đến mức chẳng còn biết ngon hay dở.”

### DLG-VLA06-V2-REVISIT

TRIGGER: player_initiates_talk; GUARDS: npc_available, distinct_return_visit.

- `DLG-VLA06-V2-REVISIT-L1` **Clara:** “Cậu đến chơi hay đến ăn? Cả hai đều được, nhưng tôi muốn biết để lấy thêm bát.”

### DLG-VLA06-V2-PERSONAL

TRIGGER: player_selects_choice:personal_topic; GUARDS: npc_available, relationship_familiar_or_above.

PLAYER_CHOICE: Cô có món nào không bao giờ muốn nấu nữa không? / Để khi khác nhé. (chỉ hiện menu).

- `DLG-VLA06-V2-PERSONAL-L1` **Clara:** “Có một món Felix khen ngon đến ba lần. Tôi biết ngay anh ấy đang cố an ủi.”

## Felix (VLA-07) — hóm hỉnh, chu đáo

### DLG-VLA07-V2-GREETING

TRIGGER: player_initiates_talk; GUARDS: npc_available, npc.met.

- `DLG-VLA07-V2-GREETING-L1` **Felix:** “Tôi vừa thắng một cuộc tranh luận với bao ngũ cốc. Nó không nói lại.”

### DLG-VLA07-V2-SMALLTALK

TRIGGER: player_selects_topic:smalltalk; GUARDS: npc_available, npc.met.

- `DLG-VLA07-V2-SMALLTALK-L1` **Felix:** “Nếu Clara bảo tôi nếm thử, tôi thường bảo ngon trước rồi mới hỏi món gì.”

### DLG-VLA07-V2-REST

TRIGGER: player_initiates_talk; GUARDS: npc_available, npc_currently_resting.

- `DLG-VLA07-V2-REST-L1` **Felix:** “Có ngày tôi chỉ muốn nhìn cây mọc thay vì đếm từng bao.”

### DLG-VLA07-V2-REVISIT

TRIGGER: player_initiates_talk; GUARDS: npc_available, distinct_return_visit.

- `DLG-VLA07-V2-REVISIT-L1` **Felix:** “Cậu đừng cười, tôi đã từng nhầm hạt giống với đồ ăn. May mà hỏi trước.”

## Olive (VLA-08) — lém lỉnh, thích màu sắc

### DLG-VLA08-V2-GREETING

TRIGGER: player_initiates_talk; GUARDS: npc_available, npc.met.

- `DLG-VLA08-V2-GREETING-L1` **Olive:** “Chú đứng yên một chút! Cháu đang thử vẽ tóc người, khó quá.”

### DLG-VLA08-V2-SMALLTALK

TRIGGER: player_selects_topic:smalltalk; GUARDS: npc_available, npc.met.

- `DLG-VLA08-V2-SMALLTALK-L1` **Olive:** “Màu xanh của hồ chắc phải dùng cả hộp màu mới vẽ được.”

### DLG-VLA08-V2-REST

TRIGGER: player_initiates_talk; GUARDS: npc_available, npc_currently_resting.

- `DLG-VLA08-V2-REST-L1` **Olive:** “Cháu vẽ một con mèo có tám chân. Cháu bảo đó là hai con đang ôm nhau.”

### DLG-VLA08-V2-REVISIT

TRIGGER: player_initiates_talk; GUARDS: npc_available, distinct_return_visit.

- `DLG-VLA08-V2-REVISIT-L1` **Olive:** “Lần sau chú đi ngang, cho cháu vẽ cái bóng của chú nhé. Không cần đứng lâu đâu.”

## Rowan (VLA-09) — điềm đạm, nguyên tắc

### DLG-VLA09-V2-GREETING

TRIGGER: player_initiates_talk; GUARDS: npc_available, npc.met.

- `DLG-VLA09-V2-GREETING-L1` **Rowan:** “Đi được đấy. Đừng bước ra mép đường nếu chưa nhìn kỹ.”

### DLG-VLA09-V2-SMALLTALK

TRIGGER: player_selects_topic:smalltalk; GUARDS: npc_available, npc.met.

- `DLG-VLA09-V2-SMALLTALK-L1` **Rowan:** “Người ta cứ bảo đường ngắn là tốt. Tôi thích đường mà khi đi về vẫn nhận ra.”

### DLG-VLA09-V2-REST

TRIGGER: player_initiates_talk; GUARDS: npc_available, npc_currently_resting.

- `DLG-VLA09-V2-REST-L1` **Rowan:** “Tôi từng dọn hết hoa ở một lối nhỏ. Đường sạch thật, nhưng nhìn chẳng vui chút nào.”

### DLG-VLA09-V2-REVISIT

TRIGGER: player_initiates_talk; GUARDS: npc_available, distinct_return_visit.

- `DLG-VLA09-V2-REVISIT-L1` **Rowan:** “Hôm nay tôi chỉ đi một vòng. Rừng không cần lúc nào cũng có người sửa nó.”

### DLG-VLA09-V2-PERSONAL

TRIGGER: player_selects_choice:personal_topic; GUARDS: npc_available, relationship_familiar_or_above.

PLAYER_CHOICE: Ông đi rừng chỉ để làm việc thôi à? / Để khi khác nhé. (chỉ hiện menu).

- `DLG-VLA09-V2-PERSONAL-L1` **Rowan:** “Không. Có hôm tôi đi hết một đoạn rồi ngồi nhìn tán cây. Chẳng ai trả công cho việc đó, may thật.”

## Silas (VLA-10) — cởi mở, có phần hấp tấp

### DLG-VLA10-V2-GREETING

TRIGGER: player_initiates_talk; GUARDS: npc_available, npc.met.

- `DLG-VLA10-V2-GREETING-L1` **Silas:** “Cẩn thận cái giỏ. Tôi vừa làm xong, đừng thử xem nó chịu được sức nặng của cậu.”

### DLG-VLA10-V2-SMALLTALK

TRIGGER: player_selects_topic:smalltalk; GUARDS: npc_available, npc.met.

- `DLG-VLA10-V2-SMALLTALK-L1` **Silas:** “Có người bảo tôi nói nhanh. Tôi bảo thế thì làm giỏ nhanh luôn cho tiện.”

### DLG-VLA10-V2-REST

TRIGGER: player_initiates_talk; GUARDS: npc_available, npc_currently_resting.

- `DLG-VLA10-V2-REST-L1` **Silas:** “Tôi đan nhầm một vòng mà nhìn lại thấy đẹp hơn. Không kể ai nhé.”

### DLG-VLA10-V2-REVISIT

TRIGGER: player_initiates_talk; GUARDS: npc_available, distinct_return_visit.

- `DLG-VLA10-V2-REVISIT-L1` **Silas:** “Cậu có thấy Rowan đâu không? À thôi, tôi sẽ tự tìm ông ấy sau.”

## Tessa (VLA-11) — độc lập, dễ sốt ruột

### DLG-VLA11-V2-GREETING

TRIGGER: player_initiates_talk; GUARDS: npc_available, npc.met.

- `DLG-VLA11-V2-GREETING-L1` **Tessa:** “Đừng nhìn lâu quá, tôi đang học chứ chưa phải thợ giỏi.”

### DLG-VLA11-V2-SMALLTALK

TRIGGER: player_selects_topic:smalltalk; GUARDS: npc_available, npc.met.

- `DLG-VLA11-V2-SMALLTALK-L1` **Tessa:** “Maeve làm một mũi chỉ mất một nhịp, tôi mất ba nhịp rồi còn phải tháo.”

### DLG-VLA11-V2-REST

TRIGGER: player_initiates_talk; GUARDS: npc_available, npc_currently_resting.

- `DLG-VLA11-V2-REST-L1` **Tessa:** “Tôi muốn tự làm một thứ mà không có ai sửa hộ giữa chừng.”

### DLG-VLA11-V2-REVISIT

TRIGGER: player_initiates_talk; GUARDS: npc_available, distinct_return_visit.

- `DLG-VLA11-V2-REVISIT-L1` **Tessa:** “Hôm nay tôi làm hỏng ít hơn hôm qua. Đấy cũng tính là tiến bộ chứ?”

## Will (VLA-12) — lanh lợi, ít kiên nhẫn

### DLG-VLA12-V2-GREETING

TRIGGER: player_initiates_talk; GUARDS: npc_available, npc.met.

- `DLG-VLA12-V2-GREETING-L1` **Will:** “Nghe tiếng kia không? Cháu cược là chim, Finn bảo là cành cây.”

### DLG-VLA12-V2-SMALLTALK

TRIGGER: player_selects_topic:smalltalk; GUARDS: npc_available, npc.met.

- `DLG-VLA12-V2-SMALLTALK-L1` **Will:** “Cháu đang thi với chính mình xem ai nghe thấy chim trước. Cháu thắng suốt.”

### DLG-VLA12-V2-REST

TRIGGER: player_initiates_talk; GUARDS: npc_available, npc_currently_resting.

- `DLG-VLA12-V2-REST-L1` **Will:** “Nếu đứng yên lâu quá thì cháu lại quên mình đang đợi cái gì.”

### DLG-VLA12-V2-REVISIT

TRIGGER: player_initiates_talk; GUARDS: npc_available, distinct_return_visit.

- `DLG-VLA12-V2-REVISIT-L1` **Will:** “Chú đi dạo à? Cháu ở sân thôi, hôm nay cháu chưa muốn chạy đâu.”

## Maeve (VLA-13) — tỉ mỉ, kín đáo

### DLG-VLA13-V2-GREETING

TRIGGER: player_initiates_talk; GUARDS: npc_available, npc.met.

- `DLG-VLA13-V2-GREETING-L1` **Maeve:** “Chào cậu. Đừng ngại, tôi chỉ đang gỡ một đường chỉ.”

### DLG-VLA13-V2-SMALLTALK

TRIGGER: player_selects_topic:smalltalk; GUARDS: npc_available, npc.met.

- `DLG-VLA13-V2-SMALLTALK-L1` **Maeve:** “Có những vết vá nhìn khá đẹp. Tôi không hiểu sao mình cứ muốn giấu chúng.”

### DLG-VLA13-V2-REST

TRIGGER: player_initiates_talk; GUARDS: npc_available, npc_currently_resting.

- `DLG-VLA13-V2-REST-L1` **Maeve:** “Hôm nay tôi cất kim sớm. Ngồi không một lát cũng chẳng hỏng gì.”

### DLG-VLA13-V2-REVISIT

TRIGGER: player_initiates_talk; GUARDS: npc_available, distinct_return_visit.

- `DLG-VLA13-V2-REVISIT-L1` **Maeve:** “Cậu mặc áo này đi rừng à? Nhìn cái gấu áo là tôi đoán cậu có một ngày khá dài.”

### DLG-VLA13-V2-PERSONAL

TRIGGER: player_selects_choice:personal_topic; GUARDS: npc_available, relationship_familiar_or_above.

PLAYER_CHOICE: Cô thích làm thứ gì khi không phải sửa đồ? / Để khi khác nhé. (chỉ hiện menu).

- `DLG-VLA13-V2-PERSONAL-L1` **Maeve:** “Một thứ không cần vừa với ai cả. Tôi có thể tháo ra làm lại mà chẳng ai đợi.”

## Arthur (VLA-14) — kỹ tính, vui tính khô

### DLG-VLA14-V2-GREETING

TRIGGER: player_initiates_talk; GUARDS: npc_available, npc.met.

- `DLG-VLA14-V2-GREETING-L1` **Arthur:** “Đồ cũ không phải đồ bỏ. Có lúc chỉ cần tìm đúng chỗ của nó.”

### DLG-VLA14-V2-SMALLTALK

TRIGGER: player_selects_topic:smalltalk; GUARDS: npc_available, npc.met.

- `DLG-VLA14-V2-SMALLTALK-L1` **Arthur:** “Tôi có một cái hộp chưa biết đựng gì. Thế mà ai cũng muốn tôi vứt nó đi.”

### DLG-VLA14-V2-REST

TRIGGER: player_initiates_talk; GUARDS: npc_available, npc_currently_resting.

- `DLG-VLA14-V2-REST-L1` **Arthur:** “Thứ khó giữ nhất không phải cái ghế cũ, mà là nhớ mình đã cất chìa ở đâu.”

### DLG-VLA14-V2-REVISIT

TRIGGER: player_initiates_talk; GUARDS: npc_available, distinct_return_visit.

- `DLG-VLA14-V2-REVISIT-L1` **Arthur:** “Cậu đến đúng lúc. Tôi đang cố nhớ vì sao lại giữ cái nắp này.”

## Evelyn (VLA-15) — chậm rãi, quan sát giỏi

### DLG-VLA15-V2-GREETING

TRIGGER: player_initiates_talk; GUARDS: npc_available, npc.met.

- `DLG-VLA15-V2-GREETING-L1` **Evelyn:** “Cậu nhìn chiếc lá ấy kỹ chưa? Hôm qua nó còn khác hôm nay.”

### DLG-VLA15-V2-SMALLTALK

TRIGGER: player_selects_topic:smalltalk; GUARDS: npc_available, npc.met.

- `DLG-VLA15-V2-SMALLTALK-L1` **Evelyn:** “Tôi ghi chép nhiều đến mức đôi khi quên ngẩng đầu lên nhìn thật.”

### DLG-VLA15-V2-REST

TRIGGER: player_initiates_talk; GUARDS: npc_available, npc_currently_resting.

- `DLG-VLA15-V2-REST-L1` **Evelyn:** “Hôm nay tôi không mở sổ. Một buổi sáng đẹp cứ để nó đẹp thôi.”

### DLG-VLA15-V2-REVISIT

TRIGGER: player_initiates_talk; GUARDS: npc_available, distinct_return_visit.

- `DLG-VLA15-V2-REVISIT-L1` **Evelyn:** “Nếu cậu thấy điều gì lạ, cứ kể theo những gì đã thấy. Không cần thêm thắt cho hay.”

### DLG-VLA15-V2-PERSONAL

TRIGGER: player_selects_choice:personal_topic; GUARDS: npc_available, relationship_familiar_or_above.

PLAYER_CHOICE: Bà có nhớ hết những gì từng ghi không? / Để khi khác nhé. (chỉ hiện menu).

- `DLG-VLA15-V2-PERSONAL-L1` **Evelyn:** “Không. Tôi nhớ rõ hơn những lần mình chịu khó ngẩng đầu lên.”

## Edmund (VLA-16) — trầm tính, hay mỉm cười

### DLG-VLA16-V2-GREETING

TRIGGER: player_initiates_talk; GUARDS: npc_available, npc.met.

- `DLG-VLA16-V2-GREETING-L1` **Edmund:** “Chào cậu. Ngồi nếu muốn. Tôi không có chuyện gì gấp.”

### DLG-VLA16-V2-SMALLTALK

TRIGGER: player_selects_topic:smalltalk; GUARDS: npc_available, npc.met.

- `DLG-VLA16-V2-SMALLTALK-L1` **Edmund:** “Có chiếc ghế tôi sửa nhiều lần hơn cả số lần ngồi lên nó.”

### DLG-VLA16-V2-REST

TRIGGER: player_initiates_talk; GUARDS: npc_available, npc_currently_resting.

- `DLG-VLA16-V2-REST-L1` **Edmund:** “Nghe tiếng gỗ khi trời đổi ẩm cũng thú vị. Chỉ cần chịu nghe một lát.”

### DLG-VLA16-V2-REVISIT

TRIGGER: player_initiates_talk; GUARDS: npc_available, distinct_return_visit.

- `DLG-VLA16-V2-REVISIT-L1` **Edmund:** “Cậu lại đi xa à? Lúc nào về mệt thì cứ ngồi ở đây.”

## Peter (VLA-17) — đáng tin, hơi vội

### DLG-VLA17-V2-GREETING

TRIGGER: player_initiates_talk; GUARDS: npc_available, npc.met.

- `DLG-VLA17-V2-GREETING-L1` **Peter:** “Xin chào! Tôi đang đi đúng hướng chứ nhỉ? À, đúng rồi.”

### DLG-VLA17-V2-SMALLTALK

TRIGGER: player_selects_topic:smalltalk; GUARDS: npc_available, npc.met.

- `DLG-VLA17-V2-SMALLTALK-L1` **Peter:** “Một lần tôi đưa giỏ đến đúng nhà nhưng sai người. May mà họ quen nhau.”

### DLG-VLA17-V2-REST

TRIGGER: player_initiates_talk; GUARDS: npc_available, npc_currently_resting.

- `DLG-VLA17-V2-REST-L1` **Peter:** “Tôi không thích chạy, chỉ là chân tôi thường đi trước đầu.”

### DLG-VLA17-V2-REVISIT

TRIGGER: player_initiates_talk; GUARDS: npc_available, distinct_return_visit.

- `DLG-VLA17-V2-REVISIT-L1` **Peter:** “Cậu cứ từ từ. Lần này tôi không có gì phải giao gấp.”

## Ada (VLA-18) — năng động, tò mò

### DLG-VLA18-V2-GREETING

TRIGGER: player_initiates_talk; GUARDS: npc_available, npc.met.

- `DLG-VLA18-V2-GREETING-L1` **Ada:** “Cậu có vừa từ rừng về không? Đừng kể đường ngắn nhất, kể chỗ hay nhất đi.”

### DLG-VLA18-V2-SMALLTALK

TRIGGER: player_selects_topic:smalltalk; GUARDS: npc_available, npc.met.

- `DLG-VLA18-V2-SMALLTALK-L1` **Ada:** “Hugo bảo tôi chuẩn bị kỹ quá. Rồi lúc đi chính anh ấy lại hỏi tôi có mang dây dự phòng không.”

### DLG-VLA18-V2-REST

TRIGGER: player_initiates_talk; GUARDS: npc_available, npc_currently_resting.

- `DLG-VLA18-V2-REST-L1` **Ada:** “Hôm nay tôi chưa đi đâu. Cái túi cứ đứng ở đó, nó không tự xách mình đi được.”

### DLG-VLA18-V2-REVISIT

TRIGGER: player_initiates_talk; GUARDS: npc_available, distinct_return_visit.

- `DLG-VLA18-V2-REVISIT-L1` **Ada:** “Có khi tôi muốn đi chỉ để xem lúc quay lại, làng trông có khác không.”

### DLG-VLA18-V2-PERSONAL

TRIGGER: player_selects_choice:personal_topic; GUARDS: npc_available, relationship_familiar_or_above.

PLAYER_CHOICE: Cậu có sợ lạc không? / Để khi khác nhé. (chỉ hiện menu).

- `DLG-VLA18-V2-PERSONAL-L1` **Ada:** “Có. Tôi chỉ không thích gọi nó là sợ. Tôi gọi là chưa biết đường về.”

## Hugo (VLA-19) — điềm tĩnh, hay pha trò

### DLG-VLA19-V2-GREETING

TRIGGER: player_initiates_talk; GUARDS: npc_available, npc.met.

- `DLG-VLA19-V2-GREETING-L1` **Hugo:** “Đứng xa cái dây kia một chút. Nó từng thắng tôi trong một cuộc vật lộn.”

### DLG-VLA19-V2-SMALLTALK

TRIGGER: player_selects_topic:smalltalk; GUARDS: npc_available, npc.met.

- `DLG-VLA19-V2-SMALLTALK-L1` **Hugo:** “Ada nhớ đường, tôi nhớ những thứ hay bị quên. Hai việc khá hợp nhau.”

### DLG-VLA19-V2-REST

TRIGGER: player_initiates_talk; GUARDS: npc_available, npc_currently_resting.

- `DLG-VLA19-V2-REST-L1` **Hugo:** “Một cái xe không có hàng vẫn là một cái xe. Cứ để nó nghỉ hôm nay đi.”

### DLG-VLA19-V2-REVISIT

TRIGGER: player_initiates_talk; GUARDS: npc_available, distinct_return_visit.

- `DLG-VLA19-V2-REVISIT-L1` **Hugo:** “Cậu có nghe Ada kể chuyện đường xa chưa? Cô ấy kể nhanh hơn cả xe chạy.”

## Liam (VLA-20) — lặng lẽ, dễ giúp người

### DLG-VLA20-V2-GREETING

TRIGGER: player_initiates_talk; GUARDS: npc_available, npc.met.

- `DLG-VLA20-V2-GREETING-L1` **Liam:** “Chào. Lối này thông rồi, cứ đi.”

### DLG-VLA20-V2-SMALLTALK

TRIGGER: player_selects_topic:smalltalk; GUARDS: npc_available, npc.met.

- `DLG-VLA20-V2-SMALLTALK-L1` **Liam:** “Tôi thích những việc làm xong rồi không cần ai nhắc nữa.”

### DLG-VLA20-V2-REST

TRIGGER: player_initiates_talk; GUARDS: npc_available, npc_currently_resting.

- `DLG-VLA20-V2-REST-L1` **Liam:** “Có ngày tôi chẳng sửa gì. Tôi chỉ đi xem chỗ mình từng làm còn ổn không.”

### DLG-VLA20-V2-REVISIT

TRIGGER: player_initiates_talk; GUARDS: npc_available, distinct_return_visit.

- `DLG-VLA20-V2-REVISIT-L1` **Liam:** “Cậu muốn ngồi đây thì cứ ngồi. Không cần tìm việc để làm.”

## Nia (VLA-21) — dịu dàng, cương quyết

### DLG-VLA21-V2-GREETING

TRIGGER: player_initiates_talk; GUARDS: npc_available, npc.met.

- `DLG-VLA21-V2-GREETING-L1` **Nia:** “Giỏ này chưa xong, nhưng cái quai đã chắc. Tôi thử rồi.”

### DLG-VLA21-V2-SMALLTALK

TRIGGER: player_selects_topic:smalltalk; GUARDS: npc_available, npc.met.

- `DLG-VLA21-V2-SMALLTALK-L1` **Nia:** “Silas đan nhanh thật. Tôi thì không muốn giỏ của mình chạy nhanh hơn tay.”

### DLG-VLA21-V2-REST

TRIGGER: player_initiates_talk; GUARDS: npc_available, npc_currently_resting.

- `DLG-VLA21-V2-REST-L1` **Nia:** “Tôi thích làm đồ có thể dùng lâu, chứ không phải làm nhiều cho đẹp mắt.”

### DLG-VLA21-V2-REVISIT

TRIGGER: player_initiates_talk; GUARDS: npc_available, distinct_return_visit.

- `DLG-VLA21-V2-REVISIT-L1` **Nia:** “Cậu nhìn thấy loại giỏ nào lạ trên đường chưa? Kể tôi nghe nếu có.”

## Ben (VLA-22) — hiếu động, dễ bối rối

### DLG-VLA22-V2-GREETING

TRIGGER: player_initiates_talk; GUARDS: npc_available, npc.met.

- `DLG-VLA22-V2-GREETING-L1` **Ben:** “Này, nhìn tôi làm thử cái này không? Chờ đã, tôi làm lại cái đã.”

### DLG-VLA22-V2-SMALLTALK

TRIGGER: player_selects_topic:smalltalk; GUARDS: npc_available, npc.met.

- `DLG-VLA22-V2-SMALLTALK-L1` **Ben:** “Tôi biết làm nhiều việc. Chỉ chưa biết việc nào làm giỏi nhất.”

### DLG-VLA22-V2-REST

TRIGGER: player_initiates_talk; GUARDS: npc_available, npc_currently_resting.

- `DLG-VLA22-V2-REST-L1` **Ben:** “Hôm nay người ta bảo tôi bớt vội. Tôi đang bớt đây, thấy không?”

### DLG-VLA22-V2-REVISIT

TRIGGER: player_initiates_talk; GUARDS: npc_available, distinct_return_visit.

- `DLG-VLA22-V2-REVISIT-L1` **Ben:** “Lần trước tôi tưởng mình hiểu rồi. Lần này tôi hỏi trước cho chắc.”

## Grace (VLA-23) — hiền hậu, có chính kiến

### DLG-VLA23-V2-GREETING

TRIGGER: player_initiates_talk; GUARDS: npc_available, npc.met.

- `DLG-VLA23-V2-GREETING-L1` **Grace:** “Đến đúng lúc đấy. Ngồi chơi cũng được, đừng đứng như đang chờ nhận việc.”

### DLG-VLA23-V2-SMALLTALK

TRIGGER: player_selects_topic:smalltalk; GUARDS: npc_available, npc.met.

- `DLG-VLA23-V2-SMALLTALK-L1` **Grace:** “Tôi từng nấu quá nhiều chỉ vì sợ thiếu. Sau đó cả nhà ăn một món đến phát ngán.”

### DLG-VLA23-V2-REST

TRIGGER: player_initiates_talk; GUARDS: npc_available, npc_currently_resting.

- `DLG-VLA23-V2-REST-L1` **Grace:** “Hôm nay tôi định ăn món mình thích. Có gì kỳ lạ đâu nhỉ?”

### DLG-VLA23-V2-REVISIT

TRIGGER: player_initiates_talk; GUARDS: npc_available, distinct_return_visit.

- `DLG-VLA23-V2-REVISIT-L1` **Grace:** “Lâu rồi mới thấy cậu. Đói không? Không đói thì cứ ngồi nói chuyện.”

### DLG-VLA23-V2-PERSONAL

TRIGGER: player_selects_choice:personal_topic; GUARDS: npc_available, relationship_familiar_or_above.

PLAYER_CHOICE: Bà muốn một bữa ăn thế nào? / Để khi khác nhé. (chỉ hiện menu).

- `DLG-VLA23-V2-PERSONAL-L1` **Grace:** “Có người nói chuyện, có người im lặng. Và tôi được ăn trước khi món nguội.”

## Miles (VLA-24) — thật thà, hài hước nhẹ

### DLG-VLA24-V2-GREETING

TRIGGER: player_initiates_talk; GUARDS: npc_available, npc.met.

- `DLG-VLA24-V2-GREETING-L1` **Miles:** “Chào! Tôi vừa chuyển xong mấy giỏ. Lưng tôi đang viết đơn xin nghỉ.”

### DLG-VLA24-V2-SMALLTALK

TRIGGER: player_selects_topic:smalltalk; GUARDS: npc_available, npc.met.

- `DLG-VLA24-V2-SMALLTALK-L1` **Miles:** “Có lần tôi mang nhầm hai giỏ nhẹ, để lại đúng cái nặng nhất cho mình.”

### DLG-VLA24-V2-REST

TRIGGER: player_initiates_talk; GUARDS: npc_available, npc_currently_resting.

- `DLG-VLA24-V2-REST-L1` **Miles:** “Hôm nay tôi muốn ngồi ở chỗ có bóng mát. Không phải vì lười đâu.”

### DLG-VLA24-V2-REVISIT

TRIGGER: player_initiates_talk; GUARDS: npc_available, distinct_return_visit.

- `DLG-VLA24-V2-REVISIT-L1` **Miles:** “Cậu mà nghe tôi than nhiều quá thì cứ bảo tôi đổi chủ đề.”

## Sophie (VLA-25) — rụt rè, sáng tạo

### DLG-VLA25-V2-GREETING

TRIGGER: player_initiates_talk; GUARDS: npc_available, npc.met.

- `DLG-VLA25-V2-GREETING-L1` **Sophie:** “Chào cậu. Tôi đang thử xếp hoa, không biết màu này có hợp không.”

### DLG-VLA25-V2-SMALLTALK

TRIGGER: player_selects_topic:smalltalk; GUARDS: npc_available, npc.met.

- `DLG-VLA25-V2-SMALLTALK-L1` **Sophie:** “Tôi thích nhìn món ăn trước khi nếm. Nhưng Clara bảo đừng ngắm đến nguội.”

### DLG-VLA25-V2-REST

TRIGGER: player_initiates_talk; GUARDS: npc_available, npc_currently_resting.

- `DLG-VLA25-V2-REST-L1` **Sophie:** “Hôm nay tôi muốn thử một cách xếp hoa hơi kỳ. Xấu thì làm lại.”

### DLG-VLA25-V2-REVISIT

TRIGGER: player_initiates_talk; GUARDS: npc_available, distinct_return_visit.

- `DLG-VLA25-V2-REVISIT-L1` **Sophie:** “Cậu thích màu nào? Tôi đang tìm một màu mà mình ít dùng.”

## Theo (VLA-26) — điềm đạm, nghiêm túc

### DLG-VLA26-V2-GREETING

TRIGGER: player_initiates_talk; GUARDS: npc_available, npc.met.

- `DLG-VLA26-V2-GREETING-L1` **Theo:** “Lối đi được. Đừng chắn chỗ người khác qua là được.”

### DLG-VLA26-V2-SMALLTALK

TRIGGER: player_selects_topic:smalltalk; GUARDS: npc_available, npc.met.

- `DLG-VLA26-V2-SMALLTALK-L1` **Theo:** “Tôi có thói quen đếm những chỗ cần sửa. Hôm nay may là đếm ít.”

### DLG-VLA26-V2-REST

TRIGGER: player_initiates_talk; GUARDS: npc_available, npc_currently_resting.

- `DLG-VLA26-V2-REST-L1` **Theo:** “Đôi khi giữ nguyên một chỗ lại là quyết định tốt nhất.”

### DLG-VLA26-V2-REVISIT

TRIGGER: player_initiates_talk; GUARDS: npc_available, distinct_return_visit.

- `DLG-VLA26-V2-REVISIT-L1` **Theo:** “Cậu đã đi quanh làng rồi à? Nếu thấy chỗ nào khó qua thì nói tôi biết, không cần đi sửa hộ.”

## Lucy (VLA-27) — cởi mở, tinh tế

### DLG-VLA27-V2-GREETING

TRIGGER: player_initiates_talk; GUARDS: npc_available, npc.met.

- `DLG-VLA27-V2-GREETING-L1` **Lucy:** “Chào cậu! Cẩn thận mấy bông cạnh chân nhé, chúng không tự né được đâu.”

### DLG-VLA27-V2-SMALLTALK

TRIGGER: player_selects_topic:smalltalk; GUARDS: npc_available, npc.met.

- `DLG-VLA27-V2-SMALLTALK-L1` **Lucy:** “Tôi thích một bụi hoa không đều màu. Nhìn giống nhiều người đang đứng cạnh nhau.”

### DLG-VLA27-V2-REST

TRIGGER: player_initiates_talk; GUARDS: npc_available, npc_currently_resting.

- `DLG-VLA27-V2-REST-L1` **Lucy:** “Hôm nay tôi cứ để cây mọc theo cách của nó. Tôi nghỉ một buổi.”

### DLG-VLA27-V2-REVISIT

TRIGGER: player_initiates_talk; GUARDS: npc_available, distinct_return_visit.

- `DLG-VLA27-V2-REVISIT-L1` **Lucy:** “Cậu có muốn ngồi nhìn hoa một chút không? Chẳng cần hiểu tên chúng.”

## Kit (VLA-28) — nhiệt tình, hay hỏi

### DLG-VLA28-V2-GREETING

TRIGGER: player_initiates_talk; GUARDS: npc_available, npc.met.

- `DLG-VLA28-V2-GREETING-L1` **Kit:** “Chú xem cái này chạy được không? Cháu thử hoài mà nó cứ quay ngang.”

### DLG-VLA28-V2-SMALLTALK

TRIGGER: player_selects_topic:smalltalk; GUARDS: npc_available, npc.met.

- `DLG-VLA28-V2-SMALLTALK-L1` **Kit:** “Cháu định làm một con vật bằng gỗ. Nó hơi giống cái ghế.”

### DLG-VLA28-V2-REST

TRIGGER: player_initiates_talk; GUARDS: npc_available, npc_currently_resting.

- `DLG-VLA28-V2-REST-L1` **Kit:** “Hôm nay cháu chơi ở sân thôi. Chỗ này có đủ thứ để tưởng tượng rồi.”

### DLG-VLA28-V2-REVISIT

TRIGGER: player_initiates_talk; GUARDS: npc_available, distinct_return_visit.

- `DLG-VLA28-V2-REVISIT-L1` **Kit:** “Chú có thích chơi đoán đồ vật không? Cháu nghĩ ra một câu dễ lắm.”

## Iris (VLA-29) — kiên trì, ấm áp

### DLG-VLA29-V2-GREETING

TRIGGER: player_initiates_talk; GUARDS: npc_available, npc.met.

- `DLG-VLA29-V2-GREETING-L1` **Iris:** “Chào cậu. Hôm nay trời khá dễ chịu để đi một vòng.”

### DLG-VLA29-V2-SMALLTALK

TRIGGER: player_selects_topic:smalltalk; GUARDS: npc_available, npc.met.

- `DLG-VLA29-V2-SMALLTALK-L1` **Iris:** “Tôi hay đổi chỗ mấy món đồ nhỏ. Chẳng hiểu sao nhìn nhà lại mới hơn.”

### DLG-VLA29-V2-REST

TRIGGER: player_initiates_talk; GUARDS: npc_available, npc_currently_resting.

- `DLG-VLA29-V2-REST-L1` **Iris:** “Có những việc để mai làm cũng được. Tôi vừa học được điều đó.”

### DLG-VLA29-V2-REVISIT

TRIGGER: player_initiates_talk; GUARDS: npc_available, distinct_return_visit.

- `DLG-VLA29-V2-REVISIT-L1` **Iris:** “Cậu cứ ngồi, đừng ngại. Tôi chưa cần dọn chỗ này ngay.”

## Caleb (VLA-30) — chắc chắn, ít nói

### DLG-VLA30-V2-GREETING

TRIGGER: player_initiates_talk; GUARDS: npc_available, npc.met.

- `DLG-VLA30-V2-GREETING-L1` **Caleb:** “Chào. Cái hộp này còn dùng được, tôi đang xem nắp.”

### DLG-VLA30-V2-SMALLTALK

TRIGGER: player_selects_topic:smalltalk; GUARDS: npc_available, npc.met.

- `DLG-VLA30-V2-SMALLTALK-L1` **Caleb:** “Tôi thích đồ có nắp vừa khít. Đỡ phải hỏi thứ bên trong đi đâu.”

### DLG-VLA30-V2-REST

TRIGGER: player_initiates_talk; GUARDS: npc_available, npc_currently_resting.

- `DLG-VLA30-V2-REST-L1` **Caleb:** “Hôm nay không cần làm thêm cái nào. Mấy cái cũ còn tốt.”

### DLG-VLA30-V2-REVISIT

TRIGGER: player_initiates_talk; GUARDS: npc_available, distinct_return_visit.

- `DLG-VLA30-V2-REVISIT-L1` **Caleb:** “Cậu thấy cái hộp nào bị lệch nắp thì cứ chỉ. Tôi sẽ xem lúc rảnh.”

**JSON:** [VILLAGE_A_DIALOGUE_BANK_V2.json](VILLAGE_A_DIALOGUE_BANK_V2.json). Không lấy thoại từ file event hoặc quest mô tả. Nếu guard không thỏa, dùng nhóm khác hoặc kết thúc, không tự ghép câu.
