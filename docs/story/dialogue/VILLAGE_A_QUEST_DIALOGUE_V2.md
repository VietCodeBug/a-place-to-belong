# Làng A — Thoại 24 nhiệm vụ V2 (DIALOGUE ONLY)

**DRAFT_STORY.** Chỉ hiện câu đúng ID, người, trigger và dữ kiện đã xác minh. Menu của A không tự phát tiếng. Không đọc liên tục SUCCESS/SETBACK/SELF; không xem guard TO_BIND là true. Lời gặp lại hoàn thành và NPC tự xử lý tách riêng. Sự kiện và quest không tiến triển bằng việc đọc câu này.

## VLA01-Q1 — Vụ trộm rau lúc chạng vạng

- `DLG-VLA01-Q1-V2-OFFER` **VLA-01:** “Cậu nhìn mấy cái lá này xem. Có kẻ ăn rau mà không chịu trả tiền.”
  - TRIGGER: `player_selects_quest_topic`; GUARDS: npc_present, npc_available, quest_offer_gate_met, quest_context_verified.
- `DLG-VLA01-Q1-V2-DECLINE` **VLA-01:** “Thôi, tối nay tôi tự để mắt. Felix đoán là thỏ, nhưng anh ấy cũng đoán mọi thứ là thỏ.”
  - TRIGGER: `player_selects_decline`; GUARDS: npc_present, npc_available, offer_open.
- `DLG-VLA01-Q1-V2-SUCCESS` **VLA-01:** “Tôi đã biết ai ghé vườn rồi. Lần tới phải giữ luống này kỹ hơn.”
  - TRIGGER: `player_reports_verified_result`; GUARDS: npc_present, npc_available, current_quest_attempt_matches, verified_fact:animal_seen_and_cause_verified, all_required_proofs_verified, line_assertions_verified.
- `DLG-VLA01-Q1-V2-SETBACK` **VLA-01:** “Chưa thấy tận mắt thì chưa kết luận. Ít nhất rau có chỗ trú rồi.”
  - TRIGGER: `player_reports_verified_result_or_setback`; GUARDS: npc_present, npc_available, current_quest_attempt_matches, verified_fact:no_sighting_but_crop_protected, line_assertions_verified.
- `DLG-VLA01-Q1-V2-REVISIT` **VLA-01:** “Mấy dấu trên đất hôm trước vẫn khiến tôi tò mò.”
  - TRIGGER: `player_selects_revisit_topic`; GUARDS: npc_present, npc_available, quest_resolved, npc_knows_actual_result, distinct_return_visit, line_assertions_verified, quest.status==completed.
- `DLG-VLA01-Q1-V2-SELF` **VLA-01:** “Tôi với Felix đã che lại luống. Khách đêm có quay lại thì để xem lần sau.”
  - TRIGGER: `player_selects_revisit_topic`; GUARDS: npc_present, npc_available, quest.status==resolved_without_player, npc_resolution_verified, distinct_return_visit, line_assertions_verified.

MENU: Tôi tham gia / Lần này tôi không tham gia / Để lúc khác (không tự đọc).

## VLA01-Q2 — Cuộc đua giành giỏ rau

- `DLG-VLA01-Q2-V2-OFFER` **VLA-01:** “Felix muốn giỏ đẹp. Tôi muốn rau ngon. Cậu thử chọn xem ai phải nhường ai.”
  - TRIGGER: `player_selects_quest_topic`; GUARDS: npc_present, npc_available, quest_offer_gate_met, quest_context_verified.
- `DLG-VLA01-Q2-V2-DECLINE` **VLA-01:** “Được, tôi tự chọn. Nếu Felix lại đem lá xếp thành con công thì tôi chịu.”
  - TRIGGER: `player_selects_decline`; GUARDS: npc_present, npc_available, offer_open.
- `DLG-VLA01-Q2-V2-SUCCESS` **VLA-01:** “Giỏ mình được chấm rồi. Lần này tôi muốn nhớ cả cách mình chọn rau, không chỉ cái giải.”
  - TRIGGER: `player_reports_verified_result`; GUARDS: npc_present, npc_available, current_quest_attempt_matches, verified_fact:entry_judged_verified_and_win_or_trial_positive, all_required_proofs_verified, line_assertions_verified.
- `DLG-VLA01-Q2-V2-SETBACK` **VLA-01:** “Không được giải cũng chẳng sao. Rau vẫn ngon, và Felix vẫn nói giỏ của anh ấy đẹp hơn.”
  - TRIGGER: `player_reports_verified_result_or_setback`; GUARDS: npc_present, npc_available, current_quest_attempt_matches, verified_fact:entry_judged_verified_nonwinning, line_assertions_verified.
- `DLG-VLA01-Q2-V2-REVISIT` **VLA-01:** “Tôi vẫn còn muốn thử một kiểu chọn rau khác.”
  - TRIGGER: `player_selects_revisit_topic`; GUARDS: npc_present, npc_available, quest_resolved, npc_knows_actual_result, distinct_return_visit, line_assertions_verified, quest.status==completed.
- `DLG-VLA01-Q2-V2-SELF` **VLA-01:** “Tôi với Felix tự chọn giỏ rồi. Hai đứa vẫn không thống nhất màu nào đẹp hơn.”
  - TRIGGER: `player_selects_revisit_topic`; GUARDS: npc_present, npc_available, quest.status==resolved_without_player, npc_resolution_verified, distinct_return_visit, line_assertions_verified.

MENU: Tôi tham gia / Lần này tôi không tham gia / Để lúc khác (không tự đọc).

## VLA01-QF — Khu vườn của những người tranh tài

- `DLG-VLA01-QF-V2-OFFER` **VLA-01:** “Tôi muốn thử cho người khác chăm một góc. Nếu họ làm tốt hơn tôi thì... chắc cũng đáng xem.”
  - TRIGGER: `player_selects_quest_topic`; GUARDS: npc_present, npc_available, quest_offer_gate_met, quest_context_verified.
- `DLG-VLA01-QF-V2-DECLINE` **VLA-01:** “Ừ, tôi sẽ tìm ai muốn thử. Cậu cứ ghé xem lúc rảnh.”
  - TRIGGER: `player_selects_decline`; GUARDS: npc_present, npc_available, offer_open.
- `DLG-VLA01-QF-V2-SUCCESS` **VLA-01:** “Kết quả ở đây rồi. Tôi không phải người duy nhất biết làm cây mọc.”
  - TRIGGER: `player_reports_verified_result`; GUARDS: npc_present, npc_available, current_quest_attempt_matches, verified_fact:plot_trial_reviewed_and_shared_use_accepted, all_required_proofs_verified, line_assertions_verified, shared_plot_actual_result_available.
- `DLG-VLA01-QF-V2-SETBACK` **VLA-01:** “Lô này chưa tốt lắm. Ta biết được một cách không nên làm, cũng không phí công.”
  - TRIGGER: `player_reports_verified_result_or_setback`; GUARDS: npc_present, npc_available, current_quest_attempt_matches, verified_fact:plot_trial_reviewed_with_poor_growth, line_assertions_verified.
- `DLG-VLA01-QF-V2-REVISIT` **VLA-01:** “Góc vườn ấy khiến tôi có nhiều thứ để quan sát hơn.”
  - TRIGGER: `player_selects_revisit_topic`; GUARDS: npc_present, npc_available, quest_resolved, npc_knows_actual_result, distinct_return_visit, line_assertions_verified, quest.status==completed.
- `DLG-VLA01-QF-V2-SELF` **VLA-01:** “Tôi đang thử một góc nhỏ với người nào muốn ghé. Chưa vội kết luận gì.”
  - TRIGGER: `player_selects_revisit_topic`; GUARDS: npc_present, npc_available, quest.status==resolved_without_player, npc_resolution_verified, distinct_return_visit, line_assertions_verified.

MENU: Tôi tham gia / Lần này tôi không tham gia / Để lúc khác (không tự đọc).

## VLA04-Q1 — Chiếc xe không chịu chạy thẳng

- `DLG-VLA04-Q1-V2-OFFER` **VLA-04:** “Hugo bảo xe có tính cách. Tôi bảo nó có lỗi. Cậu muốn thử xem ai đúng không?”
  - TRIGGER: `player_selects_quest_topic`; GUARDS: npc_present, npc_available, quest_offer_gate_met, quest_context_verified.
- `DLG-VLA04-Q1-V2-DECLINE` **VLA-04:** “Ừ. Tôi sẽ xem cái xe, không xem tính cách của nó.”
  - TRIGGER: `player_selects_decline`; GUARDS: npc_present, npc_available, offer_open.
- `DLG-VLA04-Q1-V2-SUCCESS` **VLA-04:** “Chạy thẳng rồi. Hugo phải tìm lý do khác để đi chậm.”
  - TRIGGER: `player_reports_verified_result`; GUARDS: npc_present, npc_available, current_quest_attempt_matches, verified_fact:cart_safety_test_passed, all_required_proofs_verified, line_assertions_verified.
- `DLG-VLA04-Q1-V2-SETBACK` **VLA-04:** “Vẫn lệch. Cứ để tôi chỉnh tiếp, đừng mang hàng lên lúc này.”
  - TRIGGER: `player_reports_verified_result_or_setback`; GUARDS: npc_present, npc_available, current_quest_attempt_matches, verified_fact:cart_safety_test_failed, line_assertions_verified.
- `DLG-VLA04-Q1-V2-REVISIT` **VLA-04:** “Hugo lại ghé hỏi về cái xe. Anh ấy không chịu ngồi yên được lâu.”
  - TRIGGER: `player_selects_revisit_topic`; GUARDS: npc_present, npc_available, quest_resolved, npc_knows_actual_result, distinct_return_visit, line_assertions_verified, quest.status==completed.
- `DLG-VLA04-Q1-V2-SELF` **VLA-04:** “Hugo với tôi tự kiểm cái xe. Xe chưa đạt thì cứ để ở đây.”
  - TRIGGER: `player_selects_revisit_topic`; GUARDS: npc_present, npc_available, quest.status==resolved_without_player, npc_resolution_verified, distinct_return_visit, line_assertions_verified.

MENU: Tôi tham gia / Lần này tôi không tham gia / Để lúc khác (không tự đọc).

## VLA04-Q2 — Cây cầu kêu trong mưa

- `DLG-VLA04-Q2-V2-OFFER` **VLA-04:** “Nghe tiếng gỗ ấy không? Tôi không thích nó. Đứng phía này đã.”
  - TRIGGER: `player_selects_quest_topic`; GUARDS: npc_present, npc_available, quest_offer_gate_met, quest_context_verified.
- `DLG-VLA04-Q2-V2-DECLINE` **VLA-04:** “Được. Cứ đi lối an toàn, đừng thử sức cây cầu hộ tôi.”
  - TRIGGER: `player_selects_decline`; GUARDS: npc_present, npc_available, offer_open.
- `DLG-VLA04-Q2-V2-SUCCESS` **VLA-04:** “Xong kiểm định rồi. Cầu lại làm đúng việc của một cây cầu.”
  - TRIGGER: `player_reports_verified_result`; GUARDS: npc_present, npc_available, current_quest_attempt_matches, verified_fact:bridge_safety_inspection_passed, all_required_proofs_verified, line_assertions_verified.
- `DLG-VLA04-Q2-V2-SETBACK` **VLA-04:** “Chưa được. Còn một chỗ phải xem lại. Không ai cần vội qua phần đó.”
  - TRIGGER: `player_reports_verified_result_or_setback`; GUARDS: npc_present, npc_available, current_quest_attempt_matches, verified_fact:bridge_safety_inspection_failed, line_assertions_verified.
- `DLG-VLA04-Q2-V2-REVISIT` **VLA-04:** “Tiếng gỗ ở cây cầu ấy làm tôi nhớ đợt kiểm vừa rồi.”
  - TRIGGER: `player_selects_revisit_topic`; GUARDS: npc_present, npc_available, quest_resolved, npc_knows_actual_result, distinct_return_visit, line_assertions_verified, quest.status==completed.
- `DLG-VLA04-Q2-V2-SELF` **VLA-04:** “Nhóm sửa cầu tự lo phần việc. Cứ theo lối đang mở, đừng thử chỗ còn cảnh báo.”
  - TRIGGER: `player_selects_revisit_topic`; GUARDS: npc_present, npc_available, quest.status==resolved_without_player, npc_resolution_verified, distinct_return_visit, line_assertions_verified.

MENU: Tôi tham gia / Lần này tôi không tham gia / Để lúc khác (không tự đọc).

## VLA04-QF — Thử thách xe đẩy của Owen

- `DLG-VLA04-QF-V2-OFFER` **VLA-04:** “Tôi muốn thử cái xe trên đường thật. Hugo muốn thi xem ai về trước. Cậu có muốn góp một lượt không?”
  - TRIGGER: `player_selects_quest_topic`; GUARDS: npc_present, npc_available, quest_offer_gate_met, quest_context_verified.
- `DLG-VLA04-QF-V2-DECLINE` **VLA-04:** “Ừ. Tôi vẫn phải thử cái xe, dù có người thi hay không.”
  - TRIGGER: `player_selects_decline`; GUARDS: npc_present, npc_available, offer_open.
- `DLG-VLA04-QF-V2-SUCCESS` **VLA-04:** “Có kết quả rồi. Thứ tốt nhất là cái người khác dùng được, chứ không chỉ cái tôi làm đẹp.”
  - TRIGGER: `player_reports_verified_result`; GUARDS: npc_present, npc_available, current_quest_attempt_matches, verified_fact:cart_course_verified_and_design_safety_passed, all_required_proofs_verified, line_assertions_verified.
- `DLG-VLA04-QF-V2-SETBACK` **VLA-04:** “Lượt này chưa đạt. Đỡ hơn phát hiện lỗi khi đang chở đồ thật.”
  - TRIGGER: `player_reports_verified_result_or_setback`; GUARDS: npc_present, npc_available, current_quest_attempt_matches, verified_fact:cart_course_verified_and_design_failed, line_assertions_verified.
- `DLG-VLA04-QF-V2-REVISIT` **VLA-04:** “Hugo lại muốn thử xe. Lần này tôi bảo phải xem bánh trước.”
  - TRIGGER: `player_selects_revisit_topic`; GUARDS: npc_present, npc_available, quest_resolved, npc_knows_actual_result, distinct_return_visit, line_assertions_verified, quest.status==completed.
- `DLG-VLA04-QF-V2-SELF` **VLA-04:** “Tôi tự thử xe với Hugo, có vài chỗ vẫn cần xem lại.”
  - TRIGGER: `player_selects_revisit_topic`; GUARDS: npc_present, npc_available, quest.status==resolved_without_player, npc_resolution_verified, distinct_return_visit, line_assertions_verified.

MENU: Tôi tham gia / Lần này tôi không tham gia / Để lúc khác (không tự đọc).

## VLA06-Q1 — Đoán món của Felix

- `DLG-VLA06-Q1-V2-OFFER` **VLA-06:** “Felix bảo anh ấy nhận ra mọi nguyên liệu. Tôi muốn xem có thêm người tự tin như thế không.”
  - TRIGGER: `player_selects_quest_topic`; GUARDS: npc_present, npc_available, quest_offer_gate_met, quest_context_verified.
- `DLG-VLA06-Q1-V2-DECLINE` **VLA-06:** “Thế tôi để Felix tự làm mình bẽ mặt vậy.”
  - TRIGGER: `player_selects_decline`; GUARDS: npc_present, npc_available, offer_open.
- `DLG-VLA06-Q1-V2-SUCCESS` **VLA-06:** “Đúng rồi! Tôi tưởng lần này khó đoán hơn chứ.”
  - TRIGGER: `player_reports_verified_result`; GUARDS: npc_present, npc_available, current_quest_attempt_matches, verified_fact:tasting_guess_correct_verified, all_required_proofs_verified, line_assertions_verified.
- `DLG-VLA06-Q1-V2-SETBACK` **VLA-06:** “Sai mất rồi. Nhưng nếu Felix cũng sai thì tôi sẽ phải xem lại cách làm món.”
  - TRIGGER: `player_reports_verified_result_or_setback`; GUARDS: npc_present, npc_available, current_quest_attempt_matches, verified_fact:tasting_guess_wrong_verified, line_assertions_verified.
- `DLG-VLA06-Q1-V2-REVISIT` **VLA-06:** “Felix vẫn hay nhận xét món của tôi trước khi nếm.”
  - TRIGGER: `player_selects_revisit_topic`; GUARDS: npc_present, npc_available, quest_resolved, npc_knows_actual_result, distinct_return_visit, line_assertions_verified, quest.status==completed.
- `DLG-VLA06-Q1-V2-SELF` **VLA-06:** “Felix đã thử đoán rồi. Tôi không nghĩ anh ấy tự tin như trước nữa.”
  - TRIGGER: `player_selects_revisit_topic`; GUARDS: npc_present, npc_available, quest.status==resolved_without_player, npc_resolution_verified, distinct_return_visit, line_assertions_verified.

MENU: Tôi tham gia / Lần này tôi không tham gia / Để lúc khác (không tự đọc).

## VLA06-Q2 — Món dự thi biến mất

- `DLG-VLA06-Q2-V2-OFFER` **VLA-06:** “Cái đĩa vừa ở đây. Tôi quay đi đúng một lúc. Nếu Felix ăn mất thì tôi sẽ biết ngay.”
  - TRIGGER: `player_selects_quest_topic`; GUARDS: npc_present, npc_available, quest_offer_gate_met, quest_context_verified.
- `DLG-VLA06-Q2-V2-DECLINE` **VLA-06:** “Ừ, tôi hỏi ban tổ chức trước. Không thể đứng đây chờ mãi.”
  - TRIGGER: `player_selects_decline`; GUARDS: npc_present, npc_available, offer_open.
- `DLG-VLA06-Q2-V2-SUCCESS` **VLA-06:** “Tìm lại được rồi. May mà mình nhìn chứng cứ trước khi trách ai.”
  - TRIGGER: `player_reports_verified_result`; GUARDS: npc_present, npc_available, current_quest_attempt_matches, verified_fact:original_entry_found_verified, all_required_proofs_verified, line_assertions_verified.
- `DLG-VLA06-Q2-V2-SETBACK` **VLA-06:** “Không còn kịp lượt nữa. Thôi, ít nhất tôi biết chuyện gì xảy ra.”
  - TRIGGER: `player_reports_verified_result_or_setback`; GUARDS: npc_present, npc_available, current_quest_attempt_matches, verified_fact:original_entry_missed_judging_verified, line_assertions_verified.
- `DLG-VLA06-Q2-V2-REVISIT` **VLA-06:** “Từ hôm món ấy biến mất, tôi để ý nhãn gian hơn.”
  - TRIGGER: `player_selects_revisit_topic`; GUARDS: npc_present, npc_available, quest_resolved, npc_knows_actual_result, distinct_return_visit, line_assertions_verified, quest.status==completed.
- `DLG-VLA06-Q2-V2-SELF` **VLA-06:** “Ban tổ chức đã tự kiểm chuyện cái đĩa. Tôi sẽ hỏi họ kết quả, không đoán nữa.”
  - TRIGGER: `player_selects_revisit_topic`; GUARDS: npc_present, npc_available, quest.status==resolved_without_player, npc_resolution_verified, distinct_return_visit, line_assertions_verified.
- `DLG-VLA06-Q2-V2-FALLBACK` **VLA-06:** “Món dự phòng đã vào bàn chấm. Lần này không đúng kế hoạch, nhưng ít nhất mình vẫn có thứ để dự thi.”
  - TRIGGER: `player_reports_verified_result`; GUARDS: npc_present, npc_available, current_quest_attempt_matches, fallback_entry_verified, fallback_entry_submitted_for_judging_verified.

MENU: Tôi tham gia / Lần này tôi không tham gia / Để lúc khác (không tự đọc).

## VLA06-QF — Đối thủ trong gian bếp

- `DLG-VLA06-QF-V2-OFFER` **VLA-06:** “Lần này tôi muốn nộp một món mà tôi thật sự thích. Cậu dám thử cùng không?”
  - TRIGGER: `player_selects_quest_topic`; GUARDS: npc_present, npc_available, quest_offer_gate_met, quest_context_verified.
- `DLG-VLA06-QF-V2-DECLINE` **VLA-06:** “Được. Tôi tự thử. Nếu không ai thích thì ít nhất tôi cũng biết.”
  - TRIGGER: `player_selects_decline`; GUARDS: npc_present, npc_available, offer_open.
- `DLG-VLA06-QF-V2-SUCCESS` **VLA-06:** “Điểm này là của món mình chọn thật, không phải món tôi đoán người ta sẽ thích.”
  - TRIGGER: `player_reports_verified_result`; GUARDS: npc_present, npc_available, current_quest_attempt_matches, verified_fact:entry_score_verified_and_player_won_or_trial_accepted, all_required_proofs_verified, line_assertions_verified.
- `DLG-VLA06-QF-V2-SETBACK` **VLA-06:** “Không thắng à? Tôi vẫn muốn giữ cách làm này. Lần sau thử lại xem.”
  - TRIGGER: `player_reports_verified_result_or_setback`; GUARDS: npc_present, npc_available, current_quest_attempt_matches, verified_fact:entry_score_verified_and_player_did_not_win_or_trial_rejected, line_assertions_verified.
- `DLG-VLA06-QF-V2-REVISIT` **VLA-06:** “Tôi đang nghĩ tới một biến thể nữa. Chưa chắc Felix sẽ thích.”
  - TRIGGER: `player_selects_revisit_topic`; GUARDS: npc_present, npc_available, quest_resolved, npc_knows_actual_result, distinct_return_visit, line_assertions_verified, quest.status==completed.
- `DLG-VLA06-QF-V2-SELF` **VLA-06:** “Tôi tự thử một mẫu nhỏ. Lần này tôi muốn nếm trước khi hỏi người khác.”
  - TRIGGER: `player_selects_revisit_topic`; GUARDS: npc_present, npc_available, quest.status==resolved_without_player, npc_resolution_verified, distinct_return_visit, line_assertions_verified.

MENU: Tôi tham gia / Lần này tôi không tham gia / Để lúc khác (không tự đọc).

## VLA09-Q1 — Ba dấu trên đường rừng

- `DLG-VLA09-Q1-V2-OFFER` **VLA-09:** “Có ba dấu ở lối này. Không phải cả ba đều dẫn tới cùng một chỗ đâu.”
  - TRIGGER: `player_selects_quest_topic`; GUARDS: npc_present, npc_available, quest_offer_gate_met, quest_context_verified.
- `DLG-VLA09-Q1-V2-DECLINE` **VLA-09:** “Ừ. Tôi đi xem sau, cậu cứ theo lối quen.”
  - TRIGGER: `player_selects_decline`; GUARDS: npc_present, npc_available, offer_open.
- `DLG-VLA09-Q1-V2-SUCCESS` **VLA-09:** “Cậu đã tìm đúng hướng. Giờ nhớ cả đường về nhé.”
  - TRIGGER: `player_reports_verified_result`; GUARDS: npc_present, npc_available, current_quest_attempt_matches, verified_fact:trail_match_verified, all_required_proofs_verified, line_assertions_verified.
- `DLG-VLA09-Q1-V2-SETBACK` **VLA-09:** “Không đủ dấu thì nói không đủ. Đừng bắt rừng phải cho mình một câu trả lời.”
  - TRIGGER: `player_reports_verified_result_or_setback`; GUARDS: npc_present, npc_available, current_quest_attempt_matches, verified_fact:trail_uncertain_verified, line_assertions_verified.
- `DLG-VLA09-Q1-V2-REVISIT` **VLA-09:** “Dấu trên đất không ở mãi một chỗ đâu.”
  - TRIGGER: `player_selects_revisit_topic`; GUARDS: npc_present, npc_available, quest_resolved, npc_knows_actual_result, distinct_return_visit, line_assertions_verified, quest.status==completed.
- `DLG-VLA09-Q1-V2-SELF` **VLA-09:** “Tôi tự đi kiểm mấy dấu ở lối rừng. Chúng đã thay đổi rồi.”
  - TRIGGER: `player_selects_revisit_topic`; GUARDS: npc_present, npc_available, quest.status==resolved_without_player, npc_resolution_verified, distinct_return_visit, line_assertions_verified.

MENU: Tôi tham gia / Lần này tôi không tham gia / Để lúc khác (không tự đọc).

## VLA09-Q2 — Một người chưa trở về

- `DLG-VLA09-Q2-V2-OFFER` **VLA-09:** “Có việc cần kiểm trên đường rừng. Nếu đi cùng, ta sẽ xác nhận từng chỗ, không chạy theo tiếng gọi bừa.”
  - TRIGGER: `player_selects_quest_topic`; GUARDS: npc_present, npc_available, quest_offer_gate_met, quest_context_verified.
- `DLG-VLA09-Q2-V2-DECLINE` **VLA-09:** “Được. Tôi sẽ đi với nhóm phù hợp.”
  - TRIGGER: `player_selects_decline`; GUARDS: npc_present, npc_available, offer_open.
- `DLG-VLA09-Q2-V2-SUCCESS` **VLA-09:** “Cậu đã làm đúng phần mình. Tìm đường cũng cần biết lúc nào phải dừng.”
  - TRIGGER: `player_reports_verified_result`; GUARDS: npc_present, npc_available, current_quest_attempt_matches, verified_fact:search_resolved_and_player_contribution_verified, all_required_proofs_verified, line_assertions_verified.
- `DLG-VLA09-Q2-V2-SETBACK` **VLA-09:** “Nhóm kia đã xử lý rồi. Cậu không cần chạy thêm vào rừng.”
  - TRIGGER: `player_reports_verified_result_or_setback`; GUARDS: npc_present, npc_available, current_quest_attempt_matches, verified_fact:search_resolved_by_others_verified, line_assertions_verified.
- `DLG-VLA09-Q2-V2-REVISIT` **VLA-09:** “Lối về là thứ cần nhớ nhất trong những buổi đi như thế.”
  - TRIGGER: `player_selects_revisit_topic`; GUARDS: npc_present, npc_available, quest_resolved, npc_knows_actual_result, distinct_return_visit, line_assertions_verified, quest.status==completed.
- `DLG-VLA09-Q2-V2-SELF` **VLA-09:** “Nhóm đã tự kiểm tuyến và kết thúc việc tìm. Không cần chạy thêm vào rừng.”
  - TRIGGER: `player_selects_revisit_topic`; GUARDS: npc_present, npc_available, quest.status==resolved_without_player, npc_resolution_verified, distinct_return_visit, line_assertions_verified.

MENU: Tôi tham gia / Lần này tôi không tham gia / Để lúc khác (không tự đọc).

## VLA09-QF — Hội tìm dấu: đường về

- `DLG-VLA09-QF-V2-OFFER` **VLA-09:** “Ba dấu, một đường về. Cậu muốn thử xem hôm nay nhớ được bao nhiêu không?”
  - TRIGGER: `player_selects_quest_topic`; GUARDS: npc_present, npc_available, quest_offer_gate_met, quest_context_verified.
- `DLG-VLA09-QF-V2-DECLINE` **VLA-09:** “Ừ. Đường vẫn ở đó, lần khác thử cũng được.”
  - TRIGGER: `player_selects_decline`; GUARDS: npc_present, npc_available, offer_open.
- `DLG-VLA09-QF-V2-SUCCESS` **VLA-09:** “Đủ cả ba, lại không giẫm hỏng lối. Tốt.”
  - TRIGGER: `player_reports_verified_result`; GUARDS: npc_present, npc_available, current_quest_attempt_matches, verified_fact:all_markers_verified_and_safe_return, all_required_proofs_verified, line_assertions_verified.
- `DLG-VLA09-QF-V2-SETBACK` **VLA-09:** “Thiếu một mốc mà biết quay lại còn hơn tìm đủ rồi không biết đường về.”
  - TRIGGER: `player_reports_verified_result_or_setback`; GUARDS: npc_present, npc_available, current_quest_attempt_matches, verified_fact:partial_markers_verified_and_safe_return, line_assertions_verified.
- `DLG-VLA09-QF-V2-REVISIT` **VLA-09:** “Tôi thích tuyến có vài chỗ buộc người ta phải nhìn kỹ.”
  - TRIGGER: `player_selects_revisit_topic`; GUARDS: npc_present, npc_available, quest_resolved, npc_knows_actual_result, distinct_return_visit, line_assertions_verified, quest.status==completed.
- `DLG-VLA09-QF-V2-SELF` **VLA-09:** “Tôi tự kiểm lại tuyến thử. Ai muốn đi cứ ghé khi phù hợp.”
  - TRIGGER: `player_selects_revisit_topic`; GUARDS: npc_present, npc_available, quest.status==resolved_without_player, npc_resolution_verified, distinct_return_visit, line_assertions_verified.

MENU: Tôi tham gia / Lần này tôi không tham gia / Để lúc khác (không tự đọc).

## VLA13-Q1 — Hai lá cờ, một cơn gió

- `DLG-VLA13-Q1-V2-OFFER` **VLA-13:** “Tôi thích mẫu bên trái. Gió thì có vẻ thích xé nó hơn. Cậu muốn thử xem sao không?”
  - TRIGGER: `player_selects_quest_topic`; GUARDS: npc_present, npc_available, quest_offer_gate_met, quest_context_verified.
- `DLG-VLA13-Q1-V2-DECLINE` **VLA-13:** “Được, tôi tự thử. Chắc phải bớt một dải vải.”
  - TRIGGER: `player_selects_decline`; GUARDS: npc_present, npc_available, offer_open.
- `DLG-VLA13-Q1-V2-SUCCESS` **VLA-13:** “Mẫu này nhìn rõ mà không rối. Tôi sẽ giữ lại.”
  - TRIGGER: `player_reports_verified_result`; GUARDS: npc_present, npc_available, current_quest_attempt_matches, verified_fact:flag_trial_and_display_passed, all_required_proofs_verified, line_assertions_verified.
- `DLG-VLA13-Q1-V2-SETBACK` **VLA-13:** “Mẫu chưa qua thử. Thôi, ít nhất hỏng ở đây còn hơn giữa buổi hội.”
  - TRIGGER: `player_reports_verified_result_or_setback`; GUARDS: npc_present, npc_available, current_quest_attempt_matches, verified_fact:flag_trial_failed, line_assertions_verified.
- `DLG-VLA13-Q1-V2-REVISIT` **VLA-13:** “Tôi đang nghĩ thêm một cách ghép màu cho lá cờ ấy.”
  - TRIGGER: `player_selects_revisit_topic`; GUARDS: npc_present, npc_available, quest_resolved, npc_knows_actual_result, distinct_return_visit, line_assertions_verified, quest.status==completed.
- `DLG-VLA13-Q1-V2-SELF` **VLA-13:** “Tôi tự thử hai mẫu. Chưa cái nào đạt thì tôi vẫn để chúng ở bàn.”
  - TRIGGER: `player_selects_revisit_topic`; GUARDS: npc_present, npc_available, quest.status==resolved_without_player, npc_resolution_verified, distinct_return_visit, line_assertions_verified.

MENU: Tôi tham gia / Lần này tôi không tham gia / Để lúc khác (không tự đọc).

## VLA13-Q2 — Ai đổi chỗ món dự thi?

- `DLG-VLA13-Q2-V2-OFFER` **VLA-13:** “Tessa bảo đã đặt nó ở đây. Tôi không muốn hỏi cô ấy lần thứ ba như thể tôi chẳng tin lời nào.”
  - TRIGGER: `player_selects_quest_topic`; GUARDS: npc_present, npc_available, quest_offer_gate_met, quest_context_verified.
- `DLG-VLA13-Q2-V2-DECLINE` **VLA-13:** “Ừ. Tôi sẽ kiểm lại nơi người ta chuyển đồ tới.”
  - TRIGGER: `player_selects_decline`; GUARDS: npc_present, npc_available, offer_open.
- `DLG-VLA13-Q2-V2-SUCCESS` **VLA-13:** “Đúng món rồi. Tôi nợ Tessa một lời xin lỗi nếu đã vội nghi cô ấy.”
  - TRIGGER: `player_reports_verified_result`; GUARDS: npc_present, npc_available, current_quest_attempt_matches, verified_fact:craft_item_found_verified, all_required_proofs_verified, line_assertions_verified.
- `DLG-VLA13-Q2-V2-SETBACK` **VLA-13:** “Chưa thấy thì chưa biết. Tôi sẽ không đổ lỗi cho ai chỉ vì món đồ biến mất.”
  - TRIGGER: `player_reports_verified_result_or_setback`; GUARDS: npc_present, npc_available, current_quest_attempt_matches, verified_fact:craft_item_unresolved_verified, line_assertions_verified.
- `DLG-VLA13-Q2-V2-REVISIT` **VLA-13:** “Tessa lại thử một mẫu mới. Tôi muốn xem cô ấy chọn gì.”
  - TRIGGER: `player_selects_revisit_topic`; GUARDS: npc_present, npc_available, quest_resolved, npc_knows_actual_result, distinct_return_visit, line_assertions_verified, quest.status==completed.
- `DLG-VLA13-Q2-V2-SELF` **VLA-13:** “Tôi tự hỏi người tổ chức về món bị chuyển nhầm. Chưa có chứng cứ thì chưa kết luận.”
  - TRIGGER: `player_selects_revisit_topic`; GUARDS: npc_present, npc_available, quest.status==resolved_without_player, npc_resolution_verified, distinct_return_visit, line_assertions_verified.

MENU: Tôi tham gia / Lần này tôi không tham gia / Để lúc khác (không tự đọc).

## VLA13-QF — Dải cờ không ai làm giống ai

- `DLG-VLA13-QF-V2-OFFER` **VLA-13:** “Mỗi người làm một lá cờ theo ý mình. Tôi nhìn chúng rồi thấy... chẳng lá nào chịu giống lá nào.”
  - TRIGGER: `player_selects_quest_topic`; GUARDS: npc_present, npc_available, quest_offer_gate_met, quest_context_verified.
- `DLG-VLA13-QF-V2-DECLINE` **VLA-13:** “Ừ. Tôi sẽ thử ghép vài mẫu trước.”
  - TRIGGER: `player_selects_decline`; GUARDS: npc_present, npc_available, offer_open.
- `DLG-VLA13-QF-V2-SUCCESS` **VLA-13:** “Nhìn đi. Chẳng cái nào giống cái nào mà đứng cạnh nhau lại hợp.”
  - TRIGGER: `player_reports_verified_result`; GUARDS: npc_present, npc_available, current_quest_attempt_matches, verified_fact:shared_display_accepted, all_required_proofs_verified, line_assertions_verified.
- `DLG-VLA13-QF-V2-SETBACK` **VLA-13:** “Chưa hợp lắm. Tôi muốn thử cách khác, không bắt mọi người làm lại hết.”
  - TRIGGER: `player_reports_verified_result_or_setback`; GUARDS: npc_present, npc_available, current_quest_attempt_matches, verified_fact:combined_display_trial_rejected, line_assertions_verified.
- `DLG-VLA13-QF-V2-REVISIT` **VLA-13:** “Lần sau tôi muốn thử thêm màu lạ.”
  - TRIGGER: `player_selects_revisit_topic`; GUARDS: npc_present, npc_available, quest_resolved, npc_knows_actual_result, distinct_return_visit, line_assertions_verified, quest.status==completed.
- `DLG-VLA13-QF-V2-SELF` **VLA-13:** “Tôi tự ghép vài mẫu với những người muốn góp. Chưa xong thì thử tiếp.”
  - TRIGGER: `player_selects_revisit_topic`; GUARDS: npc_present, npc_available, quest.status==resolved_without_player, npc_resolution_verified, distinct_return_visit, line_assertions_verified.

MENU: Tôi tham gia / Lần này tôi không tham gia / Để lúc khác (không tự đọc).

## VLA15-Q1 — Chiếc hũ không khớp nhãn

- `DLG-VLA15-Q1-V2-OFFER` **VLA-15:** “Cái nhãn này ghi một đằng, mẫu bên trong lại khác. Cậu muốn thử làm người tìm lỗi không?”
  - TRIGGER: `player_selects_quest_topic`; GUARDS: npc_present, npc_available, quest_offer_gate_met, quest_context_verified.
- `DLG-VLA15-Q1-V2-DECLINE` **VLA-15:** “Không sao. Tôi sẽ để riêng hũ này.”
  - TRIGGER: `player_selects_decline`; GUARDS: npc_present, npc_available, offer_open.
- `DLG-VLA15-Q1-V2-SUCCESS` **VLA-15:** “Đúng mẫu rồi. Cái nhãn cũ suýt khiến tôi tin một điều sai.”
  - TRIGGER: `player_reports_verified_result`; GUARDS: npc_present, npc_available, current_quest_attempt_matches, verified_fact:seed_identity_verified, all_required_proofs_verified, line_assertions_verified.
- `DLG-VLA15-Q1-V2-SETBACK` **VLA-15:** “Chưa chắc thì cứ để trống. Đấy cũng là một kết quả tốt.”
  - TRIGGER: `player_reports_verified_result_or_setback`; GUARDS: npc_present, npc_available, current_quest_attempt_matches, verified_fact:seed_unknown_verified, line_assertions_verified.
- `DLG-VLA15-Q1-V2-REVISIT` **VLA-15:** “Cái nhãn ấy nhắc tôi đừng tin chữ viết hơn thứ trước mắt.”
  - TRIGGER: `player_selects_revisit_topic`; GUARDS: npc_present, npc_available, quest_resolved, npc_knows_actual_result, distinct_return_visit, line_assertions_verified, quest.status==completed.
- `DLG-VLA15-Q1-V2-SELF` **VLA-15:** “Tôi tự đối chiếu lại. Mẫu chưa xác định vẫn để riêng.”
  - TRIGGER: `player_selects_revisit_topic`; GUARDS: npc_present, npc_available, quest.status==resolved_without_player, npc_resolution_verified, distinct_return_visit, line_assertions_verified.

MENU: Tôi tham gia / Lần này tôi không tham gia / Để lúc khác (không tự đọc).

## VLA15-Q2 — Bình minh ở hai nơi

- `DLG-VLA15-Q2-V2-OFFER` **VLA-15:** “Tôi có một trang ghi vườn mà thiếu thứ để so sánh. Cậu thích thử xem nơi khác có gì khác không?”
  - TRIGGER: `player_selects_quest_topic`; GUARDS: npc_present, npc_available, quest_offer_gate_met, quest_context_verified.
- `DLG-VLA15-Q2-V2-DECLINE` **VLA-15:** “Ừ, tôi sẽ ghi thêm một lượt ở vườn.”
  - TRIGGER: `player_selects_decline`; GUARDS: npc_present, npc_available, offer_open.
- `DLG-VLA15-Q2-V2-SUCCESS` **VLA-15:** “Có hai bản ghi thật rồi. Tôi thích chỗ cậu không vội gọi khác nhau là bất thường.”
  - TRIGGER: `player_reports_verified_result`; GUARDS: npc_present, npc_available, current_quest_attempt_matches, verified_fact:comparison_verified_two_real_snapshots, all_required_proofs_verified, line_assertions_verified.
- `DLG-VLA15-Q2-V2-SETBACK` **VLA-15:** “Chưa đủ để so sánh. Cứ giữ bản đầu, lần sau bổ sung.”
  - TRIGGER: `player_reports_verified_result_or_setback`; GUARDS: npc_present, npc_available, current_quest_attempt_matches, verified_fact:comparison_incomplete_verified, line_assertions_verified.
- `DLG-VLA15-Q2-V2-REVISIT` **VLA-15:** “Cuốn sổ hôm ấy vẫn còn chỗ ghi thêm.”
  - TRIGGER: `player_selects_revisit_topic`; GUARDS: npc_present, npc_available, quest_resolved, npc_knows_actual_result, distinct_return_visit, line_assertions_verified, quest.status==completed.
- `DLG-VLA15-Q2-V2-SELF` **VLA-15:** “Tôi tự ghi thêm một lượt ở vườn. Còn những nơi chưa tới thì để trống.”
  - TRIGGER: `player_selects_revisit_topic`; GUARDS: npc_present, npc_available, quest.status==resolved_without_player, npc_resolution_verified, distinct_return_visit, line_assertions_verified.

MENU: Tôi tham gia / Lần này tôi không tham gia / Để lúc khác (không tự đọc).

## VLA15-QF — Cuộc thi nhận ra điều đã đổi

- `DLG-VLA15-QF-V2-OFFER` **VLA-15:** “Tôi muốn thử xem một người nhìn được bao nhiêu thứ mà không cần tôi đứng bên cạnh giảng. Cậu thử trước nhé?”
  - TRIGGER: `player_selects_quest_topic`; GUARDS: npc_present, npc_available, quest_offer_gate_met, quest_context_verified.
- `DLG-VLA15-QF-V2-DECLINE` **VLA-15:** “Được, tôi tự kiểm một lượt rồi để người khác thử.”
  - TRIGGER: `player_selects_decline`; GUARDS: npc_present, npc_available, offer_open.
- `DLG-VLA15-QF-V2-SUCCESS` **VLA-15:** “Bản gợi ý dùng được rồi. Người đọc không cần phải biết hết những gì tôi biết.”
  - TRIGGER: `player_reports_verified_result`; GUARDS: npc_present, npc_available, current_quest_attempt_matches, verified_fact:puzzle_review_accepted, all_required_proofs_verified, line_assertions_verified.
- `DLG-VLA15-QF-V2-SETBACK` **VLA-15:** “Có câu khó hiểu hơn tôi tưởng. Tôi sẽ sửa gợi ý, không sửa kết quả của cậu.”
  - TRIGGER: `player_reports_verified_result_or_setback`; GUARDS: npc_present, npc_available, current_quest_attempt_matches, verified_fact:puzzle_clue_review_rejected, line_assertions_verified.
- `DLG-VLA15-QF-V2-REVISIT` **VLA-15:** “Tôi muốn người đọc tự phát hiện đáp án thay vì chờ tôi giải thích.”
  - TRIGGER: `player_selects_revisit_topic`; GUARDS: npc_present, npc_available, quest_resolved, npc_knows_actual_result, distinct_return_visit, line_assertions_verified, quest.status==completed.
- `DLG-VLA15-QF-V2-SELF` **VLA-15:** “Tôi tự làm một bản thử rồi. Còn phải xem gợi ý có dễ hiểu không.”
  - TRIGGER: `player_selects_revisit_topic`; GUARDS: npc_present, npc_available, quest.status==resolved_without_player, npc_resolution_verified, distinct_return_visit, line_assertions_verified.

MENU: Tôi tham gia / Lần này tôi không tham gia / Để lúc khác (không tự đọc).

## VLA18-Q1 — Đường tắt của Ada

- `DLG-VLA18-Q1-V2-OFFER` **VLA-18:** “Hugo bảo đường tắt của tôi dài hơn. Cậu muốn giúp tôi chứng minh anh ấy sai không?”
  - TRIGGER: `player_selects_quest_topic`; GUARDS: npc_present, npc_available, quest_offer_gate_met, quest_context_verified.
- `DLG-VLA18-Q1-V2-DECLINE` **VLA-18:** “Thôi, tôi tự đi. Nếu Hugo đúng thì cậu chưa nghe chuyện này nhé.”
  - TRIGGER: `player_selects_decline`; GUARDS: npc_present, npc_available, offer_open.
- `DLG-VLA18-Q1-V2-SUCCESS` **VLA-18:** “Có kết quả rồi. Lần sau tôi sẽ không cãi bằng cảm giác nữa.”
  - TRIGGER: `player_reports_verified_result`; GUARDS: npc_present, npc_available, current_quest_attempt_matches, verified_fact:route_trial_result_valid, all_required_proofs_verified, line_assertions_verified.
- `DLG-VLA18-Q1-V2-SETBACK` **VLA-18:** “Thiếu mốc à? Được, lần này ta không tuyên bố thắng.”
  - TRIGGER: `player_reports_verified_result_or_setback`; GUARDS: npc_present, npc_available, current_quest_attempt_matches, verified_fact:route_trial_missing_markers_verified, line_assertions_verified.
- `DLG-VLA18-Q1-V2-REVISIT` **VLA-18:** “Hugo vẫn nhắc chuyện đường tắt. Tôi chưa định đầu hàng đâu.”
  - TRIGGER: `player_selects_revisit_topic`; GUARDS: npc_present, npc_available, quest_resolved, npc_knows_actual_result, distinct_return_visit, line_assertions_verified, quest.status==completed.
- `DLG-VLA18-Q1-V2-SELF` **VLA-18:** “Tôi với Hugo tự đi thử. Chúng tôi lại có thêm chuyện để tranh luận.”
  - TRIGGER: `player_selects_revisit_topic`; GUARDS: npc_present, npc_available, quest.status==resolved_without_player, npc_resolution_verified, distinct_return_visit, line_assertions_verified.

MENU: Tôi tham gia / Lần này tôi không tham gia / Để lúc khác (không tự đọc).

## VLA18-Q2 — Kiện hàng qua ba trạm

- `DLG-VLA18-Q2-V2-OFFER` **VLA-18:** “Hugo muốn thử kiện trước khi đi xa. Tôi muốn xem cậu có giữ được nó qua ba trạm không.”
  - TRIGGER: `player_selects_quest_topic`; GUARDS: npc_present, npc_available, quest_offer_gate_met, quest_context_verified.
- `DLG-VLA18-Q2-V2-DECLINE` **VLA-18:** “Ừ. Chúng tôi sẽ thử một vòng, chưa có chuyến đi xa đâu.”
  - TRIGGER: `player_selects_decline`; GUARDS: npc_present, npc_available, offer_open.
- `DLG-VLA18-Q2-V2-SUCCESS` **VLA-18:** “Kiện tới nơi rồi. Tôi sẽ nhớ cách mình chuẩn bị lần này.”
  - TRIGGER: `player_reports_verified_result`; GUARDS: npc_present, npc_available, current_quest_attempt_matches, verified_fact:trial_delivery_intact_verified, all_required_proofs_verified, line_assertions_verified.
- `DLG-VLA18-Q2-V2-SETBACK` **VLA-18:** “Tải chưa ổn. Tốt là ta thử ở gần nhà trước.”
  - TRIGGER: `player_reports_verified_result_or_setback`; GUARDS: npc_present, npc_available, current_quest_attempt_matches, verified_fact:trial_delivery_failed_verified, line_assertions_verified.
- `DLG-VLA18-Q2-V2-REVISIT` **VLA-18:** “Tôi vẫn muốn thử một lượt đường dài hơn trong vùng này.”
  - TRIGGER: `player_selects_revisit_topic`; GUARDS: npc_present, npc_available, quest_resolved, npc_knows_actual_result, distinct_return_visit, line_assertions_verified, quest.status==completed.
- `DLG-VLA18-Q2-V2-SELF` **VLA-18:** “Hugo với tôi đã tự kiểm kiện mẫu. Chưa có chuyến sang làng khác.”
  - TRIGGER: `player_selects_revisit_topic`; GUARDS: npc_present, npc_available, quest.status==resolved_without_player, npc_resolution_verified, distinct_return_visit, line_assertions_verified.

MENU: Tôi tham gia / Lần này tôi không tham gia / Để lúc khác (không tự đọc).

## VLA18-QF — Chuyến đi không có người dẫn

- `DLG-VLA18-QF-V2-OFFER` **VLA-18:** “Lần này cậu chọn đường. Tôi muốn xem mình có thể đi mà không phải người quyết định mọi ngã rẽ không.”
  - TRIGGER: `player_selects_quest_topic`; GUARDS: npc_present, npc_available, quest_offer_gate_met, quest_context_verified.
- `DLG-VLA18-QF-V2-DECLINE` **VLA-18:** “Được, tôi sẽ tự đi một vòng. Cậu vẫn có thể dùng đường ấy.”
  - TRIGGER: `player_selects_decline`; GUARDS: npc_present, npc_available, offer_open.
- `DLG-VLA18-QF-V2-SUCCESS` **VLA-18:** “Cậu về đúng chỗ rồi. Tôi thích cảm giác đi xa mà vẫn biết mình sẽ quay lại đâu.”
  - TRIGGER: `player_reports_verified_result`; GUARDS: npc_present, npc_available, current_quest_attempt_matches, verified_fact:return_guide_verified, all_required_proofs_verified, line_assertions_verified.
- `DLG-VLA18-QF-V2-SETBACK` **VLA-18:** “Còn thiếu đoạn về. Cứ quay lại mốc quen, không cần cố đi tiếp.”
  - TRIGGER: `player_reports_verified_result_or_setback`; GUARDS: npc_present, npc_available, current_quest_attempt_matches, verified_fact:return_route_incomplete_verified, line_assertions_verified.
- `DLG-VLA18-QF-V2-REVISIT` **VLA-18:** “Tôi cứ nghĩ thêm nơi muốn đi, rồi lại nghĩ đến lối về.”
  - TRIGGER: `player_selects_revisit_topic`; GUARDS: npc_present, npc_available, quest_resolved, npc_knows_actual_result, distinct_return_visit, line_assertions_verified, quest.status==completed.
- `DLG-VLA18-QF-V2-SELF` **VLA-18:** “Tôi tự ghi lại vài mốc trên tuyến quen. Cậu có thể xem lúc rảnh.”
  - TRIGGER: `player_selects_revisit_topic`; GUARDS: npc_present, npc_available, quest.status==resolved_without_player, npc_resolution_verified, distinct_return_visit, line_assertions_verified.

MENU: Tôi tham gia / Lần này tôi không tham gia / Để lúc khác (không tự đọc).

## VLA23-Q1 — Bữa ăn chạy mưa

- `DLG-VLA23-Q1-V2-OFFER` **VLA-23:** “Ai có bát thì giữ bát. Cậu rảnh không? Ta cần xem chỗ nào còn khô.”
  - TRIGGER: `player_selects_quest_topic`; GUARDS: npc_present, npc_available, quest_offer_gate_met, quest_context_verified.
- `DLG-VLA23-Q1-V2-DECLINE` **VLA-23:** “Được, tôi sẽ gọi người ở gần. Cậu tìm chỗ trú đi.”
  - TRIGGER: `player_selects_decline`; GUARDS: npc_present, npc_available, offer_open.
- `DLG-VLA23-Q1-V2-SUCCESS` **VLA-23:** “Đồ đã tới chỗ an toàn. Giờ mới tính chuyện ăn.”
  - TRIGGER: `player_reports_verified_result`; GUARDS: npc_present, npc_available, current_quest_attempt_matches, verified_fact:meal_relocation_safe_verified, all_required_proofs_verified, line_assertions_verified.
- `DLG-VLA23-Q1-V2-SETBACK` **VLA-23:** “Không đủ chỗ thì hoãn. Không ai cần cố ngồi ăn lúc này.”
  - TRIGGER: `player_reports_verified_result_or_setback`; GUARDS: npc_present, npc_available, current_quest_attempt_matches, verified_fact:meal_postponed_verified, line_assertions_verified.
- `DLG-VLA23-Q1-V2-REVISIT` **VLA-23:** “Tôi sẽ nhớ xem chỗ trú trước khi bày đồ ngoài trời.”
  - TRIGGER: `player_selects_revisit_topic`; GUARDS: npc_present, npc_available, quest_resolved, npc_knows_actual_result, distinct_return_visit, line_assertions_verified, quest.status==completed.
- `DLG-VLA23-Q1-V2-SELF` **VLA-23:** “Mọi người tự thu xếp đồ rồi. Bữa ăn tiếp tục hay hoãn thì còn tùy chỗ trú.”
  - TRIGGER: `player_selects_revisit_topic`; GUARDS: npc_present, npc_available, quest.status==resolved_without_player, npc_resolution_verified, distinct_return_visit, line_assertions_verified.

MENU: Tôi tham gia / Lần này tôi không tham gia / Để lúc khác (không tự đọc).

## VLA23-Q2 — Đội nào chuẩn bị nhanh hơn?

- `DLG-VLA23-Q2-V2-OFFER` **VLA-23:** “Clara bảo có thể bày cả bàn trong một lượt. Tôi muốn xem có ai nhanh mà vẫn chừa lối đi không.”
  - TRIGGER: `player_selects_quest_topic`; GUARDS: npc_present, npc_available, quest_offer_gate_met, quest_context_verified.
- `DLG-VLA23-Q2-V2-DECLINE` **VLA-23:** “Ừ, tôi sẽ hỏi người khác. Cậu vẫn được tới xem.”
  - TRIGGER: `player_selects_decline`; GUARDS: npc_present, npc_available, offer_open.
- `DLG-VLA23-Q2-V2-SUCCESS` **VLA-23:** “Đủ đồ, lối còn thông. Thế là đáng tính điểm rồi.”
  - TRIGGER: `player_reports_verified_result`; GUARDS: npc_present, npc_available, current_quest_attempt_matches, verified_fact:meal_layout_result_passed, all_required_proofs_verified, line_assertions_verified.
- `DLG-VLA23-Q2-V2-SETBACK` **VLA-23:** “Nhanh mà quên bát thì chưa thắng được đâu. Lần sau thử lại.”
  - TRIGGER: `player_reports_verified_result_or_setback`; GUARDS: npc_present, npc_available, current_quest_attempt_matches, verified_fact:meal_layout_result_below_target, line_assertions_verified.
- `DLG-VLA23-Q2-V2-REVISIT` **VLA-23:** “Hôm nay không thi gì đâu. Cứ ngồi chơi nếu muốn.”
  - TRIGGER: `player_selects_revisit_topic`; GUARDS: npc_present, npc_available, quest_resolved, npc_knows_actual_result, distinct_return_visit, line_assertions_verified, quest.status==completed.
- `DLG-VLA23-Q2-V2-SELF` **VLA-23:** “Tôi tổ chức một lượt thử với người rảnh, không cần cả làng đến.”
  - TRIGGER: `player_selects_revisit_topic`; GUARDS: npc_present, npc_available, quest.status==resolved_without_player, npc_resolution_verified, distinct_return_visit, line_assertions_verified.

MENU: Tôi tham gia / Lần này tôi không tham gia / Để lúc khác (không tự đọc).

## VLA23-QF — Đêm hội không cần một người lo hết

- `DLG-VLA23-QF-V2-OFFER` **VLA-23:** “Tôi muốn hôm nay được đứng bên kia bàn, chỗ người đến chơi. Cậu giúp tôi một khâu rồi mình tùy ý nhé?”
  - TRIGGER: `player_selects_quest_topic`; GUARDS: npc_present, npc_available, quest_offer_gate_met, quest_context_verified.
- `DLG-VLA23-QF-V2-DECLINE` **VLA-23:** “Được. Tôi vẫn định dành thời gian đi chơi, cậu không cần lo.”
  - TRIGGER: `player_selects_decline`; GUARDS: npc_present, npc_available, offer_open.
- `DLG-VLA23-QF-V2-SUCCESS` **VLA-23:** “Cậu ở lại với tôi thật à? Lâu rồi tôi mới được làm khách.”
  - TRIGGER: `player_reports_verified_result`; GUARDS: npc_present, npc_available, current_quest_attempt_matches, verified_fact:shared_activity_verified, all_required_proofs_verified, line_assertions_verified.
- `DLG-VLA23-QF-V2-SETBACK` **VLA-23:** “Cảm ơn cậu đã góp một tay. Cứ đi khám phá đi, tôi sẽ tự chọn phần mình muốn làm.”
  - TRIGGER: `player_reports_verified_result`; GUARDS: npc_present, npc_available, current_quest_attempt_matches, verified_fact:contribution_only_verified, line_assertions_verified.
- `DLG-VLA23-QF-V2-REVISIT` **VLA-23:** “Tôi thích ý nghĩ làm xong việc rồi được tự chọn đi đâu.”
  - TRIGGER: `player_selects_revisit_topic`; GUARDS: npc_present, npc_available, quest_resolved, npc_knows_actual_result, distinct_return_visit, line_assertions_verified, quest.status==completed.
- `DLG-VLA23-QF-V2-SELF` **VLA-23:** “Chúng tôi tự chia việc. Khi xong phần mình, tôi cũng muốn đi chơi một lát.”
  - TRIGGER: `player_selects_revisit_topic`; GUARDS: npc_present, npc_available, quest.status==resolved_without_player, npc_resolution_verified, distinct_return_visit, line_assertions_verified.

MENU: Tôi tham gia / Lần này tôi không tham gia / Để lúc khác (không tự đọc).

[JSON thoại](VILLAGE_A_QUEST_DIALOGUE_V2.json).
