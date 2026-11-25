# Làng A — Thoại 24 nhiệm vụ V2 (DIALOGUE ONLY)

**DRAFT_STORY.** Chỉ hiện câu đúng ID, đúng người, đúng trigger và đúng sự kiện đã xác minh. Không đọc file quest như thoại. Menu của A không tự phát tiếng. Nhánh SUCCESS/SETBACK không tự phát liên tiếp. Lời kể về kết quả phải kiểm dữ kiện cụ thể; nếu chưa biết, không phát. Không dùng lời thoại cũ cho tình huống đã đổi. Sự kiện và quest không tiến triển bằng việc đọc câu này.

## VLA01-Q1 — Hazel

- `DLG-VLA01-Q1-V2-OFFER` **VLA-01:** “Cậu nhìn mấy cái lá này xem. Có kẻ ăn rau mà không chịu trả tiền.”
  - TRIGGER: `player_selects_quest_topic`; GUARDS: npc_present, npc_available, quest_offer_gate_met, quest_context_verified.
- `DLG-VLA01-Q1-V2-DECLINE` **VLA-01:** “Thôi, tối nay tôi tự để mắt. Felix đoán là thỏ, nhưng anh ấy cũng đoán mọi thứ là thỏ.”
  - TRIGGER: `player_selects_decline`; GUARDS: npc_present, npc_available, offer_open.
- `DLG-VLA01-Q1-V2-SUCCESS` **VLA-01:** “Tôi đã biết ai ghé vườn rồi. Lần tới phải giữ luống này kỹ hơn.”
  - TRIGGER: `player_reports_verified_result`; GUARDS: npc_present, npc_available, all_required_proofs_verified, outcome_matches:observed.
- `DLG-VLA01-Q1-V2-SETBACK` **VLA-01:** “Chưa thấy tận mắt thì chưa kết luận. Ít nhất rau có chỗ trú rồi.”
  - TRIGGER: `player_reports_verified_result_or_setback`; GUARDS: npc_present, npc_available, outcome_or_setback_verified, outcome_matches:unseen.
- `DLG-VLA01-Q1-V2-REVISIT` **VLA-01:** “Tôi vẫn để ý mấy luống đó. Hôm nay yên hơn hẳn.”
  - TRIGGER: `player_selects_revisit_topic`; GUARDS: npc_present, npc_available, quest_resolved, npc_knows_actual_result, revisit_line_facts_verified.

MENU: Tôi tham gia / Lần này tôi không tham gia / Để lúc khác (không tự đọc).

## VLA01-Q2 — Hazel

- `DLG-VLA01-Q2-V2-OFFER` **VLA-01:** “Felix muốn giỏ đẹp. Tôi muốn rau ngon. Cậu thử chọn xem ai phải nhường ai.”
  - TRIGGER: `player_selects_quest_topic`; GUARDS: npc_present, npc_available, quest_offer_gate_met, quest_context_verified.
- `DLG-VLA01-Q2-V2-DECLINE` **VLA-01:** “Được, tôi tự chọn. Nếu Felix lại đem lá xếp thành con công thì tôi chịu.”
  - TRIGGER: `player_selects_decline`; GUARDS: npc_present, npc_available, offer_open.
- `DLG-VLA01-Q2-V2-SUCCESS` **VLA-01:** “Giỏ mình được chấm rồi. Lần này tôi muốn nhớ cả cách mình chọn rau, không chỉ cái giải.”
  - TRIGGER: `player_reports_verified_result`; GUARDS: npc_present, npc_available, all_required_proofs_verified, outcome_matches:quality|presentation.
- `DLG-VLA01-Q2-V2-SETBACK` **VLA-01:** “Không được giải cũng chẳng sao. Rau vẫn ngon, và Felix vẫn nói giỏ của anh ấy đẹp hơn.”
  - TRIGGER: `player_reports_verified_result_or_setback`; GUARDS: npc_present, npc_available, outcome_or_setback_verified, verified_setback_or_nonwinning_result.
- `DLG-VLA01-Q2-V2-REVISIT` **VLA-01:** “Hôm nay tôi nhìn rau khác trước một chút. Chợ lần tới chắc lại có chuyện để cãi.”
  - TRIGGER: `player_selects_revisit_topic`; GUARDS: npc_present, npc_available, quest_resolved, npc_knows_actual_result, revisit_line_facts_verified.

MENU: Tôi tham gia / Lần này tôi không tham gia / Để lúc khác (không tự đọc).

## VLA01-QF — Hazel

- `DLG-VLA01-QF-V2-OFFER` **VLA-01:** “Tôi muốn thử cho người khác chăm một góc. Nếu họ làm tốt hơn tôi thì... chắc cũng đáng xem.”
  - TRIGGER: `player_selects_quest_topic`; GUARDS: npc_present, npc_available, quest_offer_gate_met, quest_context_verified.
- `DLG-VLA01-QF-V2-DECLINE` **VLA-01:** “Ừ, tôi sẽ tìm ai muốn thử. Cậu cứ ghé xem lúc rảnh.”
  - TRIGGER: `player_selects_decline`; GUARDS: npc_present, npc_available, offer_open.
- `DLG-VLA01-QF-V2-SUCCESS` **VLA-01:** “Kết quả ở đây rồi. Tôi không phải người duy nhất biết làm cây mọc.”
  - TRIGGER: `player_reports_verified_result`; GUARDS: npc_present, npc_available, all_required_proofs_verified, outcome_matches:team|compare.
- `DLG-VLA01-QF-V2-SETBACK` **VLA-01:** “Lô này chưa tốt lắm. Ta biết được một cách không nên làm, cũng không phí công.”
  - TRIGGER: `player_reports_verified_result_or_setback`; GUARDS: npc_present, npc_available, outcome_or_setback_verified, verified_setback_or_nonwinning_result.
- `DLG-VLA01-QF-V2-REVISIT` **VLA-01:** “Nhìn góc vườn kia đi. Giờ tôi không biết trước hôm nay ai sẽ ghé, thế mà lại vui.”
  - TRIGGER: `player_selects_revisit_topic`; GUARDS: npc_present, npc_available, quest_resolved, npc_knows_actual_result, revisit_line_facts_verified.

MENU: Tôi tham gia / Lần này tôi không tham gia / Để lúc khác (không tự đọc).

## VLA04-Q1 — Owen

- `DLG-VLA04-Q1-V2-OFFER` **VLA-04:** “Hugo bảo xe có tính cách. Tôi bảo nó có lỗi. Cậu muốn thử xem ai đúng không?”
  - TRIGGER: `player_selects_quest_topic`; GUARDS: npc_present, npc_available, quest_offer_gate_met, quest_context_verified.
- `DLG-VLA04-Q1-V2-DECLINE` **VLA-04:** “Ừ. Tôi sẽ xem cái xe, không xem tính cách của nó.”
  - TRIGGER: `player_selects_decline`; GUARDS: npc_present, npc_available, offer_open.
- `DLG-VLA04-Q1-V2-SUCCESS` **VLA-04:** “Chạy thẳng rồi. Hugo phải tìm lý do khác để đi chậm.”
  - TRIGGER: `player_reports_verified_result`; GUARDS: npc_present, npc_available, all_required_proofs_verified, outcome_matches:wheel|frame.
- `DLG-VLA04-Q1-V2-SETBACK` **VLA-04:** “Vẫn lệch. Cứ để tôi chỉnh tiếp, đừng mang hàng lên lúc này.”
  - TRIGGER: `player_reports_verified_result_or_setback`; GUARDS: npc_present, npc_available, outcome_or_setback_verified, verified_setback_or_nonwinning_result.
- `DLG-VLA04-Q1-V2-REVISIT` **VLA-04:** “Chiếc xe hôm trước vẫn dùng được nếu đã qua kiểm. Hugo đã thôi đổ lỗi cho nó chưa thì tôi không biết.”
  - TRIGGER: `player_selects_revisit_topic`; GUARDS: npc_present, npc_available, quest_resolved, npc_knows_actual_result, revisit_line_facts_verified.

MENU: Tôi tham gia / Lần này tôi không tham gia / Để lúc khác (không tự đọc).

## VLA04-Q2 — Owen

- `DLG-VLA04-Q2-V2-OFFER` **VLA-04:** “Nghe tiếng gỗ ấy không? Tôi không thích nó. Đứng phía này đã.”
  - TRIGGER: `player_selects_quest_topic`; GUARDS: npc_present, npc_available, quest_offer_gate_met, quest_context_verified.
- `DLG-VLA04-Q2-V2-DECLINE` **VLA-04:** “Được. Cứ đi lối an toàn, đừng thử sức cây cầu hộ tôi.”
  - TRIGGER: `player_selects_decline`; GUARDS: npc_present, npc_available, offer_open.
- `DLG-VLA04-Q2-V2-SUCCESS` **VLA-04:** “Xong kiểm định rồi. Cầu lại làm đúng việc của một cây cầu.”
  - TRIGGER: `player_reports_verified_result`; GUARDS: npc_present, npc_available, all_required_proofs_verified, outcome_matches:material|route.
- `DLG-VLA04-Q2-V2-SETBACK` **VLA-04:** “Chưa được. Còn một chỗ phải xem lại. Không ai cần vội qua phần đó.”
  - TRIGGER: `player_reports_verified_result_or_setback`; GUARDS: npc_present, npc_available, outcome_or_setback_verified, verified_setback_or_nonwinning_result.
- `DLG-VLA04-Q2-V2-REVISIT` **VLA-04:** “Đi qua cầu, cậu có thấy đoạn gỗ mới không? Nó sẽ sẫm màu dần.”
  - TRIGGER: `player_selects_revisit_topic`; GUARDS: npc_present, npc_available, quest_resolved, npc_knows_actual_result, revisit_line_facts_verified.

MENU: Tôi tham gia / Lần này tôi không tham gia / Để lúc khác (không tự đọc).

## VLA04-QF — Owen

- `DLG-VLA04-QF-V2-OFFER` **VLA-04:** “Tôi muốn thử cái xe trên đường thật. Hugo muốn thi xem ai về trước. Cậu có muốn góp một lượt không?”
  - TRIGGER: `player_selects_quest_topic`; GUARDS: npc_present, npc_available, quest_offer_gate_met, quest_context_verified.
- `DLG-VLA04-QF-V2-DECLINE` **VLA-04:** “Ừ. Tôi vẫn phải thử cái xe, dù có người thi hay không.”
  - TRIGGER: `player_selects_decline`; GUARDS: npc_present, npc_available, offer_open.
- `DLG-VLA04-QF-V2-SUCCESS` **VLA-04:** “Có kết quả rồi. Thứ tốt nhất là cái người khác dùng được, chứ không chỉ cái tôi làm đẹp.”
  - TRIGGER: `player_reports_verified_result`; GUARDS: npc_present, npc_available, all_required_proofs_verified, outcome_matches:stable|light.
- `DLG-VLA04-QF-V2-SETBACK` **VLA-04:** “Lượt này chưa đạt. Đỡ hơn phát hiện lỗi khi đang chở đồ thật.”
  - TRIGGER: `player_reports_verified_result_or_setback`; GUARDS: npc_present, npc_available, outcome_or_setback_verified, verified_setback_or_nonwinning_result.
- `DLG-VLA04-QF-V2-REVISIT` **VLA-04:** “Hugo cứ nhắc chuyện thử xe. Tôi nghĩ anh ấy thích cuộc thi hơn cái xe.”
  - TRIGGER: `player_selects_revisit_topic`; GUARDS: npc_present, npc_available, quest_resolved, npc_knows_actual_result, revisit_line_facts_verified.

MENU: Tôi tham gia / Lần này tôi không tham gia / Để lúc khác (không tự đọc).

## VLA06-Q1 — Clara

- `DLG-VLA06-Q1-V2-OFFER` **VLA-06:** “Felix bảo anh ấy nhận ra mọi nguyên liệu. Tôi muốn xem có thêm người tự tin như thế không.”
  - TRIGGER: `player_selects_quest_topic`; GUARDS: npc_present, npc_available, quest_offer_gate_met, quest_context_verified.
- `DLG-VLA06-Q1-V2-DECLINE` **VLA-06:** “Thế tôi để Felix tự làm mình bẽ mặt vậy.”
  - TRIGGER: `player_selects_decline`; GUARDS: npc_present, npc_available, offer_open.
- `DLG-VLA06-Q1-V2-SUCCESS` **VLA-06:** “Đúng rồi! Tôi tưởng lần này khó đoán hơn chứ.”
  - TRIGGER: `player_reports_verified_result`; GUARDS: npc_present, npc_available, all_required_proofs_verified, outcome_matches:correct.
- `DLG-VLA06-Q1-V2-SETBACK` **VLA-06:** “Sai mất rồi. Nhưng nếu Felix cũng sai thì tôi sẽ phải xem lại cách làm món.”
  - TRIGGER: `player_reports_verified_result_or_setback`; GUARDS: npc_present, npc_available, outcome_or_setback_verified, outcome_matches:wrong.
- `DLG-VLA06-Q1-V2-REVISIT` **VLA-06:** “Felix vẫn chưa chịu thôi kể về lượt nếm ấy.”
  - TRIGGER: `player_selects_revisit_topic`; GUARDS: npc_present, npc_available, quest_resolved, npc_knows_actual_result, revisit_line_facts_verified.

MENU: Tôi tham gia / Lần này tôi không tham gia / Để lúc khác (không tự đọc).

## VLA06-Q2 — Clara

- `DLG-VLA06-Q2-V2-OFFER` **VLA-06:** “Cái đĩa vừa ở đây. Tôi quay đi đúng một lúc. Nếu Felix ăn mất thì tôi sẽ biết ngay.”
  - TRIGGER: `player_selects_quest_topic`; GUARDS: npc_present, npc_available, quest_offer_gate_met, quest_context_verified.
- `DLG-VLA06-Q2-V2-DECLINE` **VLA-06:** “Ừ, tôi hỏi ban tổ chức trước. Không thể đứng đây chờ mãi.”
  - TRIGGER: `player_selects_decline`; GUARDS: npc_present, npc_available, offer_open.
- `DLG-VLA06-Q2-V2-SUCCESS` **VLA-06:** “Tìm lại được rồi. May mà mình nhìn chứng cứ trước khi trách ai.”
  - TRIGGER: `player_reports_verified_result`; GUARDS: npc_present, npc_available, all_required_proofs_verified, outcome_matches:recover.
- `DLG-VLA06-Q2-V2-SETBACK` **VLA-06:** “Không còn kịp lượt nữa. Thôi, ít nhất tôi biết chuyện gì xảy ra.”
  - TRIGGER: `player_reports_verified_result_or_setback`; GUARDS: npc_present, npc_available, outcome_or_setback_verified, outcome_matches:fallback|withdraw.
- `DLG-VLA06-Q2-V2-REVISIT` **VLA-06:** “Tôi vẫn nhớ lần món ăn biến mất. Từ hôm đó tôi ghi tên gian rõ hơn.”
  - TRIGGER: `player_selects_revisit_topic`; GUARDS: npc_present, npc_available, quest_resolved, npc_knows_actual_result, revisit_line_facts_verified.

MENU: Tôi tham gia / Lần này tôi không tham gia / Để lúc khác (không tự đọc).

## VLA06-QF — Clara

- `DLG-VLA06-QF-V2-OFFER` **VLA-06:** “Lần này tôi muốn nộp một món mà tôi thật sự thích. Cậu dám thử cùng không?”
  - TRIGGER: `player_selects_quest_topic`; GUARDS: npc_present, npc_available, quest_offer_gate_met, quest_context_verified.
- `DLG-VLA06-QF-V2-DECLINE` **VLA-06:** “Được. Tôi tự thử. Nếu không ai thích thì ít nhất tôi cũng biết.”
  - TRIGGER: `player_selects_decline`; GUARDS: npc_present, npc_available, offer_open.
- `DLG-VLA06-QF-V2-SUCCESS` **VLA-06:** “Điểm này là của món mình chọn thật, không phải món tôi đoán người ta sẽ thích.”
  - TRIGGER: `player_reports_verified_result`; GUARDS: npc_present, npc_available, all_required_proofs_verified, outcome_matches:familiar|bold.
- `DLG-VLA06-QF-V2-SETBACK` **VLA-06:** “Không thắng à? Tôi vẫn muốn giữ cách làm này. Lần sau thử lại xem.”
  - TRIGGER: `player_reports_verified_result_or_setback`; GUARDS: npc_present, npc_available, outcome_or_setback_verified, verified_setback_or_nonwinning_result.
- `DLG-VLA06-QF-V2-REVISIT` **VLA-06:** “Tôi đang nghĩ biến thể khác cho lần sau. Không phải vì thua đâu... có lẽ một chút.”
  - TRIGGER: `player_selects_revisit_topic`; GUARDS: npc_present, npc_available, quest_resolved, npc_knows_actual_result, revisit_line_facts_verified.

MENU: Tôi tham gia / Lần này tôi không tham gia / Để lúc khác (không tự đọc).

## VLA09-Q1 — Rowan

- `DLG-VLA09-Q1-V2-OFFER` **VLA-09:** “Có ba dấu ở lối này. Không phải cả ba đều dẫn tới cùng một chỗ đâu.”
  - TRIGGER: `player_selects_quest_topic`; GUARDS: npc_present, npc_available, quest_offer_gate_met, quest_context_verified.
- `DLG-VLA09-Q1-V2-DECLINE` **VLA-09:** “Ừ. Tôi đi xem sau, cậu cứ theo lối quen.”
  - TRIGGER: `player_selects_decline`; GUARDS: npc_present, npc_available, offer_open.
- `DLG-VLA09-Q1-V2-SUCCESS` **VLA-09:** “Cậu đã tìm đúng hướng. Giờ nhớ cả đường về nhé.”
  - TRIGGER: `player_reports_verified_result`; GUARDS: npc_present, npc_available, all_required_proofs_verified, outcome_matches:matched.
- `DLG-VLA09-Q1-V2-SETBACK` **VLA-09:** “Không đủ dấu thì nói không đủ. Đừng bắt rừng phải cho mình một câu trả lời.”
  - TRIGGER: `player_reports_verified_result_or_setback`; GUARDS: npc_present, npc_available, outcome_or_setback_verified, outcome_matches:uncertain.
- `DLG-VLA09-Q1-V2-REVISIT` **VLA-09:** “Dấu cũ hôm trước đã mờ rồi. Rừng chẳng giữ nguyên một bài kiểm tra cho ai.”
  - TRIGGER: `player_selects_revisit_topic`; GUARDS: npc_present, npc_available, quest_resolved, npc_knows_actual_result, revisit_line_facts_verified.

MENU: Tôi tham gia / Lần này tôi không tham gia / Để lúc khác (không tự đọc).

## VLA09-Q2 — Rowan

- `DLG-VLA09-Q2-V2-OFFER` **VLA-09:** “Có việc cần kiểm trên đường rừng. Nếu đi cùng, ta sẽ xác nhận từng chỗ, không chạy theo tiếng gọi bừa.”
  - TRIGGER: `player_selects_quest_topic`; GUARDS: npc_present, npc_available, quest_offer_gate_met, quest_context_verified.
- `DLG-VLA09-Q2-V2-DECLINE` **VLA-09:** “Được. Tôi sẽ đi với nhóm phù hợp.”
  - TRIGGER: `player_selects_decline`; GUARDS: npc_present, npc_available, offer_open.
- `DLG-VLA09-Q2-V2-SUCCESS` **VLA-09:** “Cậu đã làm đúng phần mình. Tìm đường cũng cần biết lúc nào phải dừng.”
  - TRIGGER: `player_reports_verified_result`; GUARDS: npc_present, npc_available, all_required_proofs_verified, outcome_matches:find|support.
- `DLG-VLA09-Q2-V2-SETBACK` **VLA-09:** “Nhóm kia đã xử lý rồi. Cậu không cần chạy thêm vào rừng.”
  - TRIGGER: `player_reports_verified_result_or_setback`; GUARDS: npc_present, npc_available, outcome_or_setback_verified, outcome_matches:standdown.
- `DLG-VLA09-Q2-V2-REVISIT` **VLA-09:** “Lối rừng vẫn mở. Lần tới cứ nhớ những điểm mình đã kiểm.”
  - TRIGGER: `player_selects_revisit_topic`; GUARDS: npc_present, npc_available, quest_resolved, npc_knows_actual_result, revisit_line_facts_verified.

MENU: Tôi tham gia / Lần này tôi không tham gia / Để lúc khác (không tự đọc).

## VLA09-QF — Rowan

- `DLG-VLA09-QF-V2-OFFER` **VLA-09:** “Ba dấu, một đường về. Cậu muốn thử xem hôm nay nhớ được bao nhiêu không?”
  - TRIGGER: `player_selects_quest_topic`; GUARDS: npc_present, npc_available, quest_offer_gate_met, quest_context_verified.
- `DLG-VLA09-QF-V2-DECLINE` **VLA-09:** “Ừ. Đường vẫn ở đó, lần khác thử cũng được.”
  - TRIGGER: `player_selects_decline`; GUARDS: npc_present, npc_available, offer_open.
- `DLG-VLA09-QF-V2-SUCCESS` **VLA-09:** “Đủ cả ba, lại không giẫm hỏng lối. Tốt.”
  - TRIGGER: `player_reports_verified_result`; GUARDS: npc_present, npc_available, all_required_proofs_verified, outcome_matches:all.
- `DLG-VLA09-QF-V2-SETBACK` **VLA-09:** “Thiếu một mốc mà biết quay lại còn hơn tìm đủ rồi không biết đường về.”
  - TRIGGER: `player_reports_verified_result_or_setback`; GUARDS: npc_present, npc_available, outcome_or_setback_verified, outcome_matches:partial.
- `DLG-VLA09-QF-V2-REVISIT` **VLA-09:** “Tôi vẫn giữ tuyến thử ấy cho ai thích đi rừng. Không phải lúc nào cũng cần tổ chức thi.”
  - TRIGGER: `player_selects_revisit_topic`; GUARDS: npc_present, npc_available, quest_resolved, npc_knows_actual_result, revisit_line_facts_verified.

MENU: Tôi tham gia / Lần này tôi không tham gia / Để lúc khác (không tự đọc).

## VLA13-Q1 — Maeve

- `DLG-VLA13-Q1-V2-OFFER` **VLA-13:** “Tôi thích mẫu bên trái. Gió thì có vẻ thích xé nó hơn. Cậu muốn thử xem sao không?”
  - TRIGGER: `player_selects_quest_topic`; GUARDS: npc_present, npc_available, quest_offer_gate_met, quest_context_verified.
- `DLG-VLA13-Q1-V2-DECLINE` **VLA-13:** “Được, tôi tự thử. Chắc phải bớt một dải vải.”
  - TRIGGER: `player_selects_decline`; GUARDS: npc_present, npc_available, offer_open.
- `DLG-VLA13-Q1-V2-SUCCESS` **VLA-13:** “Mẫu này nhìn rõ mà không rối. Tôi sẽ giữ lại.”
  - TRIGGER: `player_reports_verified_result`; GUARDS: npc_present, npc_available, all_required_proofs_verified, outcome_matches:bold|simple.
- `DLG-VLA13-Q1-V2-SETBACK` **VLA-13:** “Mẫu chưa qua thử. Thôi, ít nhất hỏng ở đây còn hơn giữa buổi hội.”
  - TRIGGER: `player_reports_verified_result_or_setback`; GUARDS: npc_present, npc_available, outcome_or_setback_verified, verified_setback_or_nonwinning_result.
- `DLG-VLA13-Q1-V2-REVISIT` **VLA-13:** “Cái cờ hôm trước vẫn nằm trong nhóm mẫu của tôi.”
  - TRIGGER: `player_selects_revisit_topic`; GUARDS: npc_present, npc_available, quest_resolved, npc_knows_actual_result, revisit_line_facts_verified.

MENU: Tôi tham gia / Lần này tôi không tham gia / Để lúc khác (không tự đọc).

## VLA13-Q2 — Maeve

- `DLG-VLA13-Q2-V2-OFFER` **VLA-13:** “Tessa bảo đã đặt nó ở đây. Tôi không muốn hỏi cô ấy lần thứ ba như thể tôi chẳng tin lời nào.”
  - TRIGGER: `player_selects_quest_topic`; GUARDS: npc_present, npc_available, quest_offer_gate_met, quest_context_verified.
- `DLG-VLA13-Q2-V2-DECLINE` **VLA-13:** “Ừ. Tôi sẽ kiểm lại nơi người ta chuyển đồ tới.”
  - TRIGGER: `player_selects_decline`; GUARDS: npc_present, npc_available, offer_open.
- `DLG-VLA13-Q2-V2-SUCCESS` **VLA-13:** “Đúng món rồi. Tôi nợ Tessa một lời xin lỗi nếu đã vội nghi cô ấy.”
  - TRIGGER: `player_reports_verified_result`; GUARDS: npc_present, npc_available, all_required_proofs_verified, outcome_matches:found.
- `DLG-VLA13-Q2-V2-SETBACK` **VLA-13:** “Chưa thấy thì chưa biết. Tôi sẽ không đổ lỗi cho ai chỉ vì món đồ biến mất.”
  - TRIGGER: `player_reports_verified_result_or_setback`; GUARDS: npc_present, npc_available, outcome_or_setback_verified, outcome_matches:unresolved.
- `DLG-VLA13-Q2-V2-REVISIT` **VLA-13:** “Tessa hôm nay lại làm một mẫu mới. Tôi nghĩ lần này nên để cô ấy tự chọn.”
  - TRIGGER: `player_selects_revisit_topic`; GUARDS: npc_present, npc_available, quest_resolved, npc_knows_actual_result, revisit_line_facts_verified.

MENU: Tôi tham gia / Lần này tôi không tham gia / Để lúc khác (không tự đọc).

## VLA13-QF — Maeve

- `DLG-VLA13-QF-V2-OFFER` **VLA-13:** “Mỗi người làm một lá cờ theo ý mình. Tôi nhìn chúng rồi thấy... chẳng lá nào chịu giống lá nào.”
  - TRIGGER: `player_selects_quest_topic`; GUARDS: npc_present, npc_available, quest_offer_gate_met, quest_context_verified.
- `DLG-VLA13-QF-V2-DECLINE` **VLA-13:** “Ừ. Tôi sẽ thử ghép vài mẫu trước.”
  - TRIGGER: `player_selects_decline`; GUARDS: npc_present, npc_available, offer_open.
- `DLG-VLA13-QF-V2-SUCCESS` **VLA-13:** “Nhìn đi. Chẳng cái nào giống cái nào mà đứng cạnh nhau lại hợp.”
  - TRIGGER: `player_reports_verified_result`; GUARDS: npc_present, npc_available, all_required_proofs_verified, outcome_matches:mixed|pattern.
- `DLG-VLA13-QF-V2-SETBACK` **VLA-13:** “Chưa hợp lắm. Tôi muốn thử cách khác, không bắt mọi người làm lại hết.”
  - TRIGGER: `player_reports_verified_result_or_setback`; GUARDS: npc_present, npc_available, outcome_or_setback_verified, verified_setback_or_nonwinning_result.
- `DLG-VLA13-QF-V2-REVISIT` **VLA-13:** “Lần sau tôi muốn có thêm màu lạ. Trước đây tôi sẽ không nói vậy đâu.”
  - TRIGGER: `player_selects_revisit_topic`; GUARDS: npc_present, npc_available, quest_resolved, npc_knows_actual_result, revisit_line_facts_verified.

MENU: Tôi tham gia / Lần này tôi không tham gia / Để lúc khác (không tự đọc).

## VLA15-Q1 — Evelyn

- `DLG-VLA15-Q1-V2-OFFER` **VLA-15:** “Cái nhãn này ghi một đằng, mẫu bên trong lại khác. Cậu muốn thử làm người tìm lỗi không?”
  - TRIGGER: `player_selects_quest_topic`; GUARDS: npc_present, npc_available, quest_offer_gate_met, quest_context_verified.
- `DLG-VLA15-Q1-V2-DECLINE` **VLA-15:** “Không sao. Tôi sẽ để riêng hũ này.”
  - TRIGGER: `player_selects_decline`; GUARDS: npc_present, npc_available, offer_open.
- `DLG-VLA15-Q1-V2-SUCCESS` **VLA-15:** “Đúng mẫu rồi. Cái nhãn cũ suýt khiến tôi tin một điều sai.”
  - TRIGGER: `player_reports_verified_result`; GUARDS: npc_present, npc_available, all_required_proofs_verified, outcome_matches:identified.
- `DLG-VLA15-Q1-V2-SETBACK` **VLA-15:** “Chưa chắc thì cứ để trống. Đấy cũng là một kết quả tốt.”
  - TRIGGER: `player_reports_verified_result_or_setback`; GUARDS: npc_present, npc_available, outcome_or_setback_verified, outcome_matches:unknown.
- `DLG-VLA15-Q1-V2-REVISIT` **VLA-15:** “Tôi đã để hũ ấy vào đúng nhóm nếu xác minh xong. Mấy hũ chưa rõ vẫn ở riêng.”
  - TRIGGER: `player_selects_revisit_topic`; GUARDS: npc_present, npc_available, quest_resolved, npc_knows_actual_result, revisit_line_facts_verified.

MENU: Tôi tham gia / Lần này tôi không tham gia / Để lúc khác (không tự đọc).

## VLA15-Q2 — Evelyn

- `DLG-VLA15-Q2-V2-OFFER` **VLA-15:** “Tôi có một trang ghi vườn mà thiếu thứ để so sánh. Cậu thích thử xem nơi khác có gì khác không?”
  - TRIGGER: `player_selects_quest_topic`; GUARDS: npc_present, npc_available, quest_offer_gate_met, quest_context_verified.
- `DLG-VLA15-Q2-V2-DECLINE` **VLA-15:** “Ừ, tôi sẽ ghi thêm một lượt ở vườn.”
  - TRIGGER: `player_selects_decline`; GUARDS: npc_present, npc_available, offer_open.
- `DLG-VLA15-Q2-V2-SUCCESS` **VLA-15:** “Có hai bản ghi thật rồi. Tôi thích chỗ cậu không vội gọi khác nhau là bất thường.”
  - TRIGGER: `player_reports_verified_result`; GUARDS: npc_present, npc_available, all_required_proofs_verified, outcome_matches:garden|lake.
- `DLG-VLA15-Q2-V2-SETBACK` **VLA-15:** “Chưa đủ để so sánh. Cứ giữ bản đầu, lần sau bổ sung.”
  - TRIGGER: `player_reports_verified_result_or_setback`; GUARDS: npc_present, npc_available, outcome_or_setback_verified, verified_setback_or_nonwinning_result.
- `DLG-VLA15-Q2-V2-REVISIT` **VLA-15:** “Tôi vẫn xem lại trang ghi chép ấy. Mỗi lần đọc lại thấy thêm một điều.”
  - TRIGGER: `player_selects_revisit_topic`; GUARDS: npc_present, npc_available, quest_resolved, npc_knows_actual_result, revisit_line_facts_verified.

MENU: Tôi tham gia / Lần này tôi không tham gia / Để lúc khác (không tự đọc).

## VLA15-QF — Evelyn

- `DLG-VLA15-QF-V2-OFFER` **VLA-15:** “Tôi muốn thử xem một người nhìn được bao nhiêu thứ mà không cần tôi đứng bên cạnh giảng. Cậu thử trước nhé?”
  - TRIGGER: `player_selects_quest_topic`; GUARDS: npc_present, npc_available, quest_offer_gate_met, quest_context_verified.
- `DLG-VLA15-QF-V2-DECLINE` **VLA-15:** “Được, tôi tự kiểm một lượt rồi để người khác thử.”
  - TRIGGER: `player_selects_decline`; GUARDS: npc_present, npc_available, offer_open.
- `DLG-VLA15-QF-V2-SUCCESS` **VLA-15:** “Bản gợi ý dùng được rồi. Người đọc không cần phải biết hết những gì tôi biết.”
  - TRIGGER: `player_reports_verified_result`; GUARDS: npc_present, npc_available, all_required_proofs_verified, outcome_matches:short|layered.
- `DLG-VLA15-QF-V2-SETBACK` **VLA-15:** “Có câu khó hiểu hơn tôi tưởng. Tôi sẽ sửa gợi ý, không sửa kết quả của cậu.”
  - TRIGGER: `player_reports_verified_result_or_setback`; GUARDS: npc_present, npc_available, outcome_or_setback_verified, verified_setback_or_nonwinning_result.
- `DLG-VLA15-QF-V2-REVISIT` **VLA-15:** “Tôi để bản thử ở chỗ ghi chép. Ai thích thì làm, không phải bài kiểm tra bắt buộc.”
  - TRIGGER: `player_selects_revisit_topic`; GUARDS: npc_present, npc_available, quest_resolved, npc_knows_actual_result, revisit_line_facts_verified.

MENU: Tôi tham gia / Lần này tôi không tham gia / Để lúc khác (không tự đọc).

## VLA18-Q1 — Ada

- `DLG-VLA18-Q1-V2-OFFER` **VLA-18:** “Hugo bảo đường tắt của tôi dài hơn. Cậu muốn giúp tôi chứng minh anh ấy sai không?”
  - TRIGGER: `player_selects_quest_topic`; GUARDS: npc_present, npc_available, quest_offer_gate_met, quest_context_verified.
- `DLG-VLA18-Q1-V2-DECLINE` **VLA-18:** “Thôi, tôi tự đi. Nếu Hugo đúng thì cậu chưa nghe chuyện này nhé.”
  - TRIGGER: `player_selects_decline`; GUARDS: npc_present, npc_available, offer_open.
- `DLG-VLA18-Q1-V2-SUCCESS` **VLA-18:** “Có kết quả rồi. Lần sau tôi sẽ không cãi bằng cảm giác nữa.”
  - TRIGGER: `player_reports_verified_result`; GUARDS: npc_present, npc_available, all_required_proofs_verified, outcome_matches:short|steady.
- `DLG-VLA18-Q1-V2-SETBACK` **VLA-18:** “Thiếu mốc à? Được, lần này ta không tuyên bố thắng.”
  - TRIGGER: `player_reports_verified_result_or_setback`; GUARDS: npc_present, npc_available, outcome_or_setback_verified, verified_setback_or_nonwinning_result.
- `DLG-VLA18-Q1-V2-REVISIT` **VLA-18:** “Hugo vẫn còn nhắc đường tắt. Tôi đang chờ dịp thử lại.”
  - TRIGGER: `player_selects_revisit_topic`; GUARDS: npc_present, npc_available, quest_resolved, npc_knows_actual_result, revisit_line_facts_verified.

MENU: Tôi tham gia / Lần này tôi không tham gia / Để lúc khác (không tự đọc).

## VLA18-Q2 — Ada

- `DLG-VLA18-Q2-V2-OFFER` **VLA-18:** “Hugo muốn thử kiện trước khi đi xa. Tôi muốn xem cậu có giữ được nó qua ba trạm không.”
  - TRIGGER: `player_selects_quest_topic`; GUARDS: npc_present, npc_available, quest_offer_gate_met, quest_context_verified.
- `DLG-VLA18-Q2-V2-DECLINE` **VLA-18:** “Ừ. Chúng tôi sẽ thử một vòng, chưa có chuyến đi xa đâu.”
  - TRIGGER: `player_selects_decline`; GUARDS: npc_present, npc_available, offer_open.
- `DLG-VLA18-Q2-V2-SUCCESS` **VLA-18:** “Kiện tới nơi rồi. Tôi sẽ nhớ cách mình chuẩn bị lần này.”
  - TRIGGER: `player_reports_verified_result`; GUARDS: npc_present, npc_available, all_required_proofs_verified, outcome_matches:careful.
- `DLG-VLA18-Q2-V2-SETBACK` **VLA-18:** “Tải chưa ổn. Tốt là ta thử ở gần nhà trước.”
  - TRIGGER: `player_reports_verified_result_or_setback`; GUARDS: npc_present, npc_available, outcome_or_setback_verified, outcome_matches:retry.
- `DLG-VLA18-Q2-V2-REVISIT` **VLA-18:** “Tôi còn để bản ghi chuyến thử ở góc chuẩn bị. Chưa có hàng đi làng khác đâu.”
  - TRIGGER: `player_selects_revisit_topic`; GUARDS: npc_present, npc_available, quest_resolved, npc_knows_actual_result, revisit_line_facts_verified.

MENU: Tôi tham gia / Lần này tôi không tham gia / Để lúc khác (không tự đọc).

## VLA18-QF — Ada

- `DLG-VLA18-QF-V2-OFFER` **VLA-18:** “Lần này cậu chọn đường. Tôi muốn xem mình có thể đi mà không phải người quyết định mọi ngã rẽ không.”
  - TRIGGER: `player_selects_quest_topic`; GUARDS: npc_present, npc_available, quest_offer_gate_met, quest_context_verified.
- `DLG-VLA18-QF-V2-DECLINE` **VLA-18:** “Được, tôi sẽ tự đi một vòng. Cậu vẫn có thể dùng đường ấy.”
  - TRIGGER: `player_selects_decline`; GUARDS: npc_present, npc_available, offer_open.
- `DLG-VLA18-QF-V2-SUCCESS` **VLA-18:** “Cậu về đúng chỗ rồi. Tôi thích cảm giác đi xa mà vẫn biết mình sẽ quay lại đâu.”
  - TRIGGER: `player_reports_verified_result`; GUARDS: npc_present, npc_available, all_required_proofs_verified, outcome_matches:forest|lake.
- `DLG-VLA18-QF-V2-SETBACK` **VLA-18:** “Còn thiếu đoạn về. Cứ quay lại mốc quen, không cần cố đi tiếp.”
  - TRIGGER: `player_reports_verified_result_or_setback`; GUARDS: npc_present, npc_available, outcome_or_setback_verified, verified_setback_or_nonwinning_result.
- `DLG-VLA18-QF-V2-REVISIT` **VLA-18:** “Tôi giữ bản chỉ dẫn tuyến đó ở góc chuẩn bị. Có đường về rồi, còn nhiều chỗ để khám phá.”
  - TRIGGER: `player_selects_revisit_topic`; GUARDS: npc_present, npc_available, quest_resolved, npc_knows_actual_result, revisit_line_facts_verified.

MENU: Tôi tham gia / Lần này tôi không tham gia / Để lúc khác (không tự đọc).

## VLA23-Q1 — Grace

- `DLG-VLA23-Q1-V2-OFFER` **VLA-23:** “Ai có bát thì giữ bát. Cậu rảnh không? Ta cần xem chỗ nào còn khô.”
  - TRIGGER: `player_selects_quest_topic`; GUARDS: npc_present, npc_available, quest_offer_gate_met, quest_context_verified.
- `DLG-VLA23-Q1-V2-DECLINE` **VLA-23:** “Được, tôi sẽ gọi người ở gần. Cậu tìm chỗ trú đi.”
  - TRIGGER: `player_selects_decline`; GUARDS: npc_present, npc_available, offer_open.
- `DLG-VLA23-Q1-V2-SUCCESS` **VLA-23:** “Đồ đã tới chỗ an toàn. Giờ mới tính chuyện ăn.”
  - TRIGGER: `player_reports_verified_result`; GUARDS: npc_present, npc_available, all_required_proofs_verified, outcome_matches:continue.
- `DLG-VLA23-Q1-V2-SETBACK` **VLA-23:** “Không đủ chỗ thì hoãn. Không ai cần cố ngồi ăn lúc này.”
  - TRIGGER: `player_reports_verified_result_or_setback`; GUARDS: npc_present, npc_available, outcome_or_setback_verified, outcome_matches:postpone.
- `DLG-VLA23-Q1-V2-REVISIT` **VLA-23:** “Lần sau tôi sẽ xem chỗ trú trước khi bày đồ ra.”
  - TRIGGER: `player_selects_revisit_topic`; GUARDS: npc_present, npc_available, quest_resolved, npc_knows_actual_result, revisit_line_facts_verified.

MENU: Tôi tham gia / Lần này tôi không tham gia / Để lúc khác (không tự đọc).

## VLA23-Q2 — Grace

- `DLG-VLA23-Q2-V2-OFFER` **VLA-23:** “Clara bảo có thể bày cả bàn trong một lượt. Tôi muốn xem có ai nhanh mà vẫn chừa lối đi không.”
  - TRIGGER: `player_selects_quest_topic`; GUARDS: npc_present, npc_available, quest_offer_gate_met, quest_context_verified.
- `DLG-VLA23-Q2-V2-DECLINE` **VLA-23:** “Ừ, tôi sẽ hỏi người khác. Cậu vẫn được tới xem.”
  - TRIGGER: `player_selects_decline`; GUARDS: npc_present, npc_available, offer_open.
- `DLG-VLA23-Q2-V2-SUCCESS` **VLA-23:** “Đủ đồ, lối còn thông. Thế là đáng tính điểm rồi.”
  - TRIGGER: `player_reports_verified_result`; GUARDS: npc_present, npc_available, all_required_proofs_verified, outcome_matches:accuracy|speed.
- `DLG-VLA23-Q2-V2-SETBACK` **VLA-23:** “Nhanh mà quên bát thì chưa thắng được đâu. Lần sau thử lại.”
  - TRIGGER: `player_reports_verified_result_or_setback`; GUARDS: npc_present, npc_available, outcome_or_setback_verified, verified_setback_or_nonwinning_result.
- `DLG-VLA23-Q2-V2-REVISIT` **VLA-23:** “Hôm nay không thi nữa. Tôi muốn mọi người ăn chậm một chút.”
  - TRIGGER: `player_selects_revisit_topic`; GUARDS: npc_present, npc_available, quest_resolved, npc_knows_actual_result, revisit_line_facts_verified.

MENU: Tôi tham gia / Lần này tôi không tham gia / Để lúc khác (không tự đọc).

## VLA23-QF — Grace

- `DLG-VLA23-QF-V2-OFFER` **VLA-23:** “Tôi muốn hôm nay được đứng bên kia bàn, chỗ người đến chơi. Cậu giúp tôi một khâu rồi mình tùy ý nhé?”
  - TRIGGER: `player_selects_quest_topic`; GUARDS: npc_present, npc_available, quest_offer_gate_met, quest_context_verified.
- `DLG-VLA23-QF-V2-DECLINE` **VLA-23:** “Được. Tôi vẫn định dành thời gian đi chơi, cậu không cần lo.”
  - TRIGGER: `player_selects_decline`; GUARDS: npc_present, npc_available, offer_open.
- `DLG-VLA23-QF-V2-SUCCESS` **VLA-23:** “Cậu ở lại với tôi thật à? Lâu rồi tôi mới được làm khách.”
  - TRIGGER: `player_reports_verified_result`; GUARDS: npc_present, npc_available, all_required_proofs_verified, outcome_matches:join.
- `DLG-VLA23-QF-V2-SETBACK` **VLA-23:** “Cảm ơn cậu đã góp một tay. Cứ đi khám phá đi, tôi sẽ tự chọn phần mình muốn làm.”
  - TRIGGER: `player_reports_verified_result_or_setback`; GUARDS: npc_present, npc_available, outcome_or_setback_verified, outcome_matches:leave.
- `DLG-VLA23-QF-V2-REVISIT` **VLA-23:** “Lần đó tôi đã tự chọn làm gì sau khi xong việc. Lần tới chắc cũng vậy.”
  - TRIGGER: `player_selects_revisit_topic`; GUARDS: npc_present, npc_available, quest_resolved, npc_knows_actual_result, revisit_line_facts_verified.

MENU: Tôi tham gia / Lần này tôi không tham gia / Để lúc khác (không tự đọc).

[JSON thoại](VILLAGE_A_QUEST_DIALOGUE_V2.json).
