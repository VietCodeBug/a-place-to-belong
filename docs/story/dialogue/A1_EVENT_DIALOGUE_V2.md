# A1 — Hội thoại theo sự kiện V2 (DIALOGUE ONLY)

**DRAFT_STORY.** Không chứa bước event, quest hay chỉ dẫn diễn xuất. Đây là các câu riêng để người chơi chủ động hỏi NPC về sự kiện đã/đang diễn ra. Chọn **một câu phù hợp điều kiện**, không phát toàn bộ. NPC phải có mặt và biết sự việc qua lịch tham gia hoặc thông tin đã xác minh. `TO_BIND` nghĩa là dev chưa có ánh xạ guard thật; không tự phát nếu chưa kiểm được. Sự kiện vẫn tiến triển dù toàn bộ thoại này không được mở.

## EV-A1-FES-001 — Đêm đèn trên mặt hồ

- `DLG-A1-FES-001-V2-L01` **Ada:** “Cậu chọn đường nào? Tôi cá là Hugo sẽ đi đường dài rồi bảo mình đang ngắm cảnh.”
  - CONDITION: `festival_occurrence_active_and_speaker_at_registration` (cộng điều kiện chung: NPC hiện diện, biết sự kiện, đúng occurrence).
- `DLG-A1-FES-001-V2-L02` **Hugo:** “Đừng nghe Ada. Đường ngắn của cô ấy thường có một đoạn gọi là 'chắc qua được'.”
  - CONDITION: `festival_occurrence_active_and_speaker_at_registration` (cộng điều kiện chung: NPC hiện diện, biết sự kiện, đúng occurrence).
- `DLG-A1-FES-001-V2-L03` **Ada:** “Khoan, cậu về trước tôi thật à? Lần tới tôi muốn xem cậu chọn đường nào.”
  - CONDITION: `player_contest_result_verified_win` (cộng điều kiện chung: NPC hiện diện, biết sự kiện, đúng occurrence).
- `DLG-A1-FES-001-V2-L04` **Hugo:** “Thua cũng có cái lợi. Lần tới chẳng ai bắt cậu bảo vệ ngôi vô địch.”
  - CONDITION: `player_contest_result_verified_not_win` (cộng điều kiện chung: NPC hiện diện, biết sự kiện, đúng occurrence).
- `DLG-A1-FES-001-V2-L05` **Sophie:** “Tôi thích lúc mặt nước phản chiếu đèn hơn cả lúc thắp chúng. Cậu có nhìn thấy không?”
  - CONDITION: `player_attendance_verified_and_actual_location_lake` (cộng điều kiện chung: NPC hiện diện, biết sự kiện, đúng occurrence).
- `DLG-A1-FES-001-V2-L06` **Sophie:** “Tiếc là cậu không tới. Lần sau tôi sẽ thử xếp đèn khác đi.”
  - CONDITION: `player_not_attended_and_festival_finished` (cộng điều kiện chung: NPC hiện diện, biết sự kiện, đúng occurrence).

## EV-A1-FES-002 — Hội tìm dấu rừng

- `DLG-A1-FES-002-V2-L01` **Rowan:** “Đội nào về trước chưa chắc đã thấy nhiều nhất. Để xem bảng kết quả nói gì.”
  - CONDITION: `contest_active_and_speaker_at_start` (cộng điều kiện chung: NPC hiện diện, biết sự kiện, đúng occurrence).
- `DLG-A1-FES-002-V2-L02` **Ada:** “Cậu tìm được đủ dấu à? Tôi đã suýt đi nhầm ở đoạn thứ hai.”
  - CONDITION: `player_verified_correct_tracks_all` (cộng điều kiện chung: NPC hiện diện, biết sự kiện, đúng occurrence).
- `DLG-A1-FES-002-V2-L03` **Rowan:** “Một dấu cũ dễ đánh lừa lắm. Lần sau xem lại chỗ đất đổi màu.”
  - CONDITION: `player_contest_finished_with_missed_clues` (cộng điều kiện chung: NPC hiện diện, biết sự kiện, đúng occurrence).

## EV-A1-FES-003 — Hội bếp và chợ chiều

- `DLG-A1-FES-003-V2-L01` **Felix:** “Tôi đăng ký nếm món, không đăng ký nấu. Hai việc ấy khác nhau nhiều đấy.”
  - CONDITION: `market_active_and_speaker_at_food_stall` (cộng điều kiện chung: NPC hiện diện, biết sự kiện, đúng occurrence).
- `DLG-A1-FES-003-V2-L02` **Clara:** “Đúng rồi! Tôi tưởng lần này giấu mùi nguyên liệu kỹ lắm.”
  - CONDITION: `player_tasting_answer_verified_correct` (cộng điều kiện chung: NPC hiện diện, biết sự kiện, đúng occurrence).
- `DLG-A1-FES-003-V2-L03` **Clara:** “Không phải đâu. Nhưng cậu đoán giống Felix, nên tôi bắt đầu nghi công thức của mình.”
  - CONDITION: `player_tasting_answer_verified_wrong` (cộng điều kiện chung: NPC hiện diện, biết sự kiện, đúng occurrence).
- `DLG-A1-FES-003-V2-L04` **Grace:** “Có vài món hết trước khi chấm xong. Đấy mới là chuyện buồn cười.”
  - CONDITION: `judging_finished_and_player_not_entered` (cộng điều kiện chung: NPC hiện diện, biết sự kiện, đúng occurrence).

## EV-A1-FES-004 — Đêm lửa đầu mùa lạnh

- `DLG-A1-FES-004-V2-L01` **Arthur:** “Ai đoán tiếng này là cái cửa nhà tôi kêu thì cũng có lý. Tôi chưa sửa nó.”
  - CONDITION: `gathering_active_and_speaker_in_circle` (cộng điều kiện chung: NPC hiện diện, biết sự kiện, đúng occurrence).
- `DLG-A1-FES-004-V2-L02` **Will:** “Cháu biết tiếng đó! Chờ đã, cho cháu nghe lần nữa được không?”
  - CONDITION: `gathering_sound_game_active_and_child_in_safe_public_area` (cộng điều kiện chung: NPC hiện diện, biết sự kiện, đúng occurrence).
- `DLG-A1-FES-004-V2-L03` **Edmund:** “Tôi thích đoạn mọi người thôi tranh nhau nói. Lửa kêu cũng đủ nghe.”
  - CONDITION: `player_attended_gathering_and_speaker_present_after` (cộng điều kiện chung: NPC hiện diện, biết sự kiện, đúng occurrence).

## EV-A1-WLD-001 — Đàn thú cắt ngang đường

- `DLG-A1-WLD-001-V2-L01` **Rowan:** “Cậu thấy đàn thú qua lối cũ rồi à? Hôm nay chúng đi sớm hơn tôi tưởng.”
  - CONDITION: `wildlife_crossing_verified_and_player_observed` (cộng điều kiện chung: NPC hiện diện, biết sự kiện, đúng occurrence).
- `DLG-A1-WLD-001-V2-L02` **Evelyn:** “Có dấu mới trên đường rừng. Tôi chưa biết chúng đi xa tới đâu.”
  - CONDITION: `wildlife_crossing_verified_and_player_not_observed` (cộng điều kiện chung: NPC hiện diện, biết sự kiện, đúng occurrence).

## EV-A1-WLD-002 — Mất dấu trên nền đá

- `DLG-A1-WLD-002-V2-L01` **Rowan:** “Tìm lại được dấu à? Thế là cậu đã để ý cả những chỗ không có dấu chân.”
  - CONDITION: `player_tracking_attempted_and_animal_relocated` (cộng điều kiện chung: NPC hiện diện, biết sự kiện, đúng occurrence).
- `DLG-A1-WLD-002-V2-L02` **Rowan:** “Mất dấu là chuyện thường. Đừng vì thế mà cố đuổi vào chỗ mình chưa biết.”
  - CONDITION: `player_tracking_attempted_and_animal_escaped` (cộng điều kiện chung: NPC hiện diện, biết sự kiện, đúng occurrence).

## EV-A1-WLD-003 — Cái bẫy bỏ quên

- `DLG-A1-WLD-003-V2-L01` **Theo:** “Cậu chỉ đúng chỗ là được. Phần còn lại để người có dụng cụ lo.”
  - CONDITION: `hazard_marked_by_player_and_adult_notified` (cộng điều kiện chung: NPC hiện diện, biết sự kiện, đúng occurrence).
- `DLG-A1-WLD-003-V2-L02` **Theo:** “Cái bẫy ở lối phụ đã được xử lý. Giờ qua đó dễ hơn rồi.”
  - CONDITION: `hazard_removed_verified_and_player_not_involved` (cộng điều kiện chung: NPC hiện diện, biết sự kiện, đúng occurrence).

## EV-A1-WLD-004 — Đêm có khách ngoài vườn

- `DLG-A1-WLD-004-V2-L01` **Hazel:** “Tôi không nhớ mình mời vị khách nào vào ăn rau tối qua cả.”
  - CONDITION: `crop_disturbance_detected_and_player_at_garden` (cộng điều kiện chung: NPC hiện diện, biết sự kiện, đúng occurrence).
- `DLG-A1-WLD-004-V2-L02` **Hazel:** “Đêm nay chắc luống này đỡ bị ghé thăm. Cảm ơn cậu đã phụ.”
  - CONDITION: `protection_applied_verified_and_player_contributed` (cộng điều kiện chung: NPC hiện diện, biết sự kiện, đúng occurrence).
- `DLG-A1-WLD-004-V2-L03` **Felix:** “Có thứ đã ăn trước cả tôi. Hazel không thấy chuyện ấy buồn cười lắm.”
  - CONDITION: `crop_disturbance_resolved_by_npcs_and_player_not_involved` (cộng điều kiện chung: NPC hiện diện, biết sự kiện, đúng occurrence).

## EV-A1-WLD-005 — Cuộc săn không chắc thành công

- `DLG-A1-WLD-005-V2-L01` **Rowan:** “Cậu đã trở về rồi. Nhớ xem khu vực ấy còn ổn không trước khi quay lại.”
  - CONDITION: `player_hunt_attempted_and_hunt_result_verified_success` (cộng điều kiện chung: NPC hiện diện, biết sự kiện, đúng occurrence).
- `DLG-A1-WLD-005-V2-L02` **Ada:** “Hụt à? Thế thì hôm nay cậu có một câu chuyện dài hơn dự tính rồi.”
  - CONDITION: `player_hunt_attempted_and_hunt_result_verified_escape` (cộng điều kiện chung: NPC hiện diện, biết sự kiện, đúng occurrence).
- `DLG-A1-WLD-005-V2-L03` **Evelyn:** “Chỉ nhìn thấy nó cũng đáng nhớ rồi. Cậu thấy điều gì khác trên đường về?”
  - CONDITION: `player_observed_wildlife_and_player_hunt_not_attempted` (cộng điều kiện chung: NPC hiện diện, biết sự kiện, đúng occurrence).

## EV-A1-EXP-001 — Lối đi hiện ra sau mưa

- `DLG-A1-EXP-001-V2-L01` **Ada:** “Cậu tìm được đường vòng? Hay đấy. Nhìn từ chiều về có khó nhận ra không?”
  - CONDITION: `player_return_path_verified` (cộng điều kiện chung: NPC hiện diện, biết sự kiện, đúng occurrence).
- `DLG-A1-EXP-001-V2-L02` **Rowan:** “Sau mưa có vài dấu lộ rõ hơn. Đường cũ thôi, chưa chắc hôm nào cũng nhìn ra.”
  - CONDITION: `wet_path_trace_visible_and_player_not_yet_followed` (cộng điều kiện chung: NPC hiện diện, biết sự kiện, đúng occurrence).

## EV-A1-EXP-002 — Vật sáng dưới bờ đá

- `DLG-A1-EXP-002-V2-L01` **Arthur:** “Đừng đoán giá trị chỉ vì nó sáng. Có khi là đồ ai đánh rơi.”
  - CONDITION: `object_identified_and_speaker_present` (cộng điều kiện chung: NPC hiện diện, biết sự kiện, đúng occurrence).
- `DLG-A1-EXP-002-V2-L02` **Arthur:** “Cậu tìm được đúng người rồi à? Tốt. Đồ đạc cũng cần về đúng chỗ.”
  - CONDITION: `ownership_verified_and_player_returned_item` (cộng điều kiện chung: NPC hiện diện, biết sự kiện, đúng occurrence).

## EV-A1-EXP-003 — Tiếng gọi sau màn sương

- `DLG-A1-EXP-003-V2-L01` **Peter:** “Tôi sẽ kiểm lối gần làng. Nếu cậu đi rừng, nhớ quay lại báo khi tìm được người.”
  - CONDITION: `search_active_and_speaker_in_search_group` (cộng điều kiện chung: NPC hiện diện, biết sự kiện, đúng occurrence).
- `DLG-A1-EXP-003-V2-L02` **Ada:** “Về được là tốt rồi. Lần tới gặp sương dày, chắc người ấy sẽ chọn đường quen.”
  - CONDITION: `safe_return_verified_and_player_found_adult` (cộng điều kiện chung: NPC hiện diện, biết sự kiện, đúng occurrence).
- `DLG-A1-EXP-003-V2-L03` **Theo:** “Tìm được người rồi. Họ đang nghỉ, đường qua cầu vẫn đi được.”
  - CONDITION: `safe_return_verified_and_npcs_found_adult_and_player_not_involved` (cộng điều kiện chung: NPC hiện diện, biết sự kiện, đúng occurrence).

## EV-A1-EXP-004 — Trước khi đèn tắt

- `DLG-A1-EXP-004-V2-L01` **Ada:** “Ba mốc thôi. Đừng biến nó thành chuyến thám hiểm tới tận sáng mai.”
  - CONDITION: `route_challenge_active_and_speaker_at_start` (cộng điều kiện chung: NPC hiện diện, biết sự kiện, đúng occurrence).
- `DLG-A1-EXP-004-V2-L02` **Hugo:** “Về đúng chỗ còn hơn cố tìm nốt rồi lạc luôn. Ada sẽ không thừa nhận đâu.”
  - CONDITION: `player_finish_verified_with_missing_markers` (cộng điều kiện chung: NPC hiện diện, biết sự kiện, đúng occurrence).
- `DLG-A1-EXP-004-V2-L03` **Ada:** “Đủ cả ba? Được, lần sau tôi phải chọn tuyến khác rồi.”
  - CONDITION: `player_finish_verified_all_markers` (cộng điều kiện chung: NPC hiện diện, biết sự kiện, đúng occurrence).

## EV-A1-EXP-005 — Bình minh có đàn chim

- `DLG-A1-EXP-005-V2-L01` **Evelyn:** “Cậu thấy chim lúc trời vừa sáng à? Tôi thích lúc chúng đến trước cả tiếng người.”
  - CONDITION: `player_lake_wildlife_observed_and_speaker_present` (cộng điều kiện chung: NPC hiện diện, biết sự kiện, đúng occurrence).
- `DLG-A1-EXP-005-V2-L02` **Edmund:** “Sáng nay hồ đẹp. Nhưng thôi, còn nhiều buổi sáng khác.”
  - CONDITION: `dawn_window_finished_and_player_not_observed` (cộng điều kiện chung: NPC hiện diện, biết sự kiện, đúng occurrence).

## EV-A1-DRM-001 — Cầu gỗ sau trận mưa

- `DLG-A1-DRM-001-V2-L01` **Owen:** “Ván lỏng. Đừng thử bằng cách nhảy lên nó. Tôi đã biết nó lỏng rồi.”
  - CONDITION: `bridge_damage_verified_and_speaker_at_safe_work_area` (cộng điều kiện chung: NPC hiện diện, biết sự kiện, đúng occurrence).
- `DLG-A1-DRM-001-V2-L02` **Theo:** “Lối an toàn ở phía này. Đi chậm một chút là được.”
  - CONDITION: `bridge_repair_in_progress_and_speaker_at_safe_route` (cộng điều kiện chung: NPC hiện diện, biết sự kiện, đúng occurrence).
- `DLG-A1-DRM-001-V2-L03` **Owen:** “Cái cầu qua được rồi. Phần cậu mang tới dùng vừa đủ.”
  - CONDITION: `bridge_repaired_verified_and_player_contributed` (cộng điều kiện chung: NPC hiện diện, biết sự kiện, đúng occurrence).
- `DLG-A1-DRM-001-V2-L04` **Owen:** “Xong rồi. Lần này chúng tôi phải thay một đoạn gỗ.”
  - CONDITION: `bridge_repaired_verified_and_player_not_involved` (cộng điều kiện chung: NPC hiện diện, biết sự kiện, đúng occurrence).

## EV-A1-DRM-002 — Gió nổi trước giờ khai hội

- `DLG-A1-DRM-002-V2-L01` **Sophie:** “Tôi vừa xếp xong, gió lại có ý kiến khác. Chắc phải đổi chỗ đèn thôi.”
  - CONDITION: `festival_wind_unsafe_and_speaker_at_preparation_area` (cộng điều kiện chung: NPC hiện diện, biết sự kiện, đúng occurrence).
- `DLG-A1-DRM-002-V2-L02` **Grace:** “Về sân làng nhé. Không ai cần một lễ hội đẹp mà phải lo đồ bay xuống hồ.”
  - CONDITION: `safe_layout_verified_and_actual_location_village_square` (cộng điều kiện chung: NPC hiện diện, biết sự kiện, đúng occurrence).
- `DLG-A1-DRM-002-V2-L03` **Ada:** “Hoãn một buổi không có nghĩa là hết hội. Tôi vẫn còn muốn thử trò tìm mốc.”
  - CONDITION: `festival_postponed_verified` (cộng điều kiện chung: NPC hiện diện, biết sự kiện, đúng occurrence).

## EV-A1-DRM-003 — Cây chắn lối phụ

- `DLG-A1-DRM-003-V2-L01` **Rowan:** “Lối phụ hôm nay không qua được. Đường chính vẫn thông.”
  - CONDITION: `fallen_tree_detected_and_speaker_at_safe_path` (cộng điều kiện chung: NPC hiện diện, biết sự kiện, đúng occurrence).
- `DLG-A1-DRM-003-V2-L02` **Rowan:** “Cậu tìm được lối vòng rồi à? Nhớ xem nó có dẫn về chỗ quen không.”
  - CONDITION: `detour_verified_by_player` (cộng điều kiện chung: NPC hiện diện, biết sự kiện, đúng occurrence).
- `DLG-A1-DRM-003-V2-L03` **Theo:** “Đoạn cây đổ đã được dọn. Không cần vòng nữa đâu.”
  - CONDITION: `clearance_verified_by_npcs_and_player_not_involved` (cộng điều kiện chung: NPC hiện diện, biết sự kiện, đúng occurrence).

## EV-A1-DRM-004 — Bữa ăn chạy mưa

- `DLG-A1-DRM-004-V2-L01` **Grace:** “Ai còn bát thì giữ bát. Ai không có bát thì tìm chỗ khô ngồi.”
  - CONDITION: `outdoor_meal_and_rain_and_speaker_present` (cộng điều kiện chung: NPC hiện diện, biết sự kiện, đúng occurrence).
- `DLG-A1-DRM-004-V2-L02` **Clara:** “Món ăn vẫn ổn. Có lẽ lần sau tôi phải xem trời trước khi bày bàn.”
  - CONDITION: `meal_relocated_verified_and_player_contributed` (cộng điều kiện chung: NPC hiện diện, biết sự kiện, đúng occurrence).

## EV-A1-SOC-001 — Hai cách giữ đường rừng

- `DLG-A1-SOC-001-V2-L01` **Rowan:** “Tôi nói để lại vạt hoa, chứ có bảo mọi người bước vào bụi đâu.”
  - CONDITION: `rowan_silas_disagreement_active_and_both_present` (cộng điều kiện chung: NPC hiện diện, biết sự kiện, đúng occurrence).
- `DLG-A1-SOC-001-V2-L02` **Silas:** “Thì ông thử đi qua lúc đang ôm hai cái giỏ xem. Tôi có lý do của tôi chứ.”
  - CONDITION: `rowan_silas_disagreement_active_and_both_present` (cộng điều kiện chung: NPC hiện diện, biết sự kiện, đúng occurrence).
- `DLG-A1-SOC-001-V2-L03` **Silas:** “Được rồi, chừa hoa bên ấy. Miễn là tôi không phải đi ngang như con cua.”
  - CONDITION: `agreement_verified_and_speaker_present` (cộng điều kiện chung: NPC hiện diện, biết sự kiện, đúng occurrence).

## EV-A1-SOC-002 — Chiếc ghế trống ở lễ hội

- `DLG-A1-SOC-002-V2-L01` **Grace:** “Tôi chưa thấy người ấy tới. Chắc nên hỏi xem có chuyện gì, đừng đoán vội.”
  - CONDITION: `expected_adult_attendee_absent_and_reason_unknown` (cộng điều kiện chung: NPC hiện diện, biết sự kiện, đúng occurrence).
- `DLG-A1-SOC-002-V2-L02` **Grace:** “Hóa ra chỉ muốn yên tĩnh một chút. Cứ để người ta nghỉ đi.”
  - CONDITION: `absence_reason_verified_wants_privacy` (cộng điều kiện chung: NPC hiện diện, biết sự kiện, đúng occurrence).
- `DLG-A1-SOC-002-V2-L03` **Grace:** “Về rồi là yên tâm. Buổi hội còn hay không cũng không quan trọng bằng chuyện ấy.”
  - CONDITION: `absence_reason_verified_lost_and_safe_return_verified` (cộng điều kiện chung: NPC hiện diện, biết sự kiện, đúng occurrence).

## EV-A1-SOC-003 — Gian thi thiếu món

- `DLG-A1-SOC-003-V2-L01` **Tessa:** “Tôi đặt nó ở đây thật mà. Đừng ai bảo tôi lại làm hỏng việc.”
  - CONDITION: `contest_entry_missing_and_speaker_is_affected_learner` (cộng điều kiện chung: NPC hiện diện, biết sự kiện, đúng occurrence).
- `DLG-A1-SOC-003-V2-L02` **Maeve:** “Tìm thấy rồi. Tôi đã kết luận vội, xin lỗi.”
  - CONDITION: `entry_found_verified_and_wrongly_suspected_learner_cleared` (cộng điều kiện chung: NPC hiện diện, biết sự kiện, đúng occurrence).
- `DLG-A1-SOC-003-V2-L03` **Tessa:** “Cảm ơn. Tôi chỉ muốn người ta biết lần này không phải tôi làm mất.”
  - CONDITION: `entry_found_verified_and_player_helped` (cộng điều kiện chung: NPC hiện diện, biết sự kiện, đúng occurrence).

## EV-A1-WRD-001 — Bờ hồ thay đổi

- `DLG-A1-WRD-001-V2-L01` **Evelyn:** “Vậy chỗ cậu thường đứng hôm nay đã khác. Cứ ghi thêm một dòng, không cần sửa dòng cũ.”
  - CONDITION: `shore_observation_verified_by_player` (cộng điều kiện chung: NPC hiện diện, biết sự kiện, đúng occurrence).
- `DLG-A1-WRD-001-V2-L02` **Rowan:** “Bờ hồ hôm nay khác hôm trước. Đi sát lối khô nếu cậu ghé qua.”
  - CONDITION: `shore_weather_state_changed_and_player_not_observed` (cộng điều kiện chung: NPC hiện diện, biết sự kiện, đúng occurrence).

## EV-A1-WRD-002 — Dấu sửa trên con đường

- `DLG-A1-WRD-002-V2-L01` **Liam:** “Cậu làm phần đó rồi, phần này để tôi. Không cần đứng đây hết buổi.”
  - CONDITION: `repair_contribution_verified_by_player` (cộng điều kiện chung: NPC hiện diện, biết sự kiện, đúng occurrence).
- `DLG-A1-WRD-002-V2-L02` **Theo:** “Đường dùng được rồi. Chỗ cậu góp sức hôm trước vẫn còn đấy.”
  - CONDITION: `repair_finished_verified_and_player_contributed` (cộng điều kiện chung: NPC hiện diện, biết sự kiện, đúng occurrence).
- `DLG-A1-WRD-002-V2-L03` **Theo:** “Mọi người làm xong đoạn ấy rồi. Cậu thử đi qua lúc rảnh nhé.”
  - CONDITION: `repair_finished_verified_and_player_not_involved` (cộng điều kiện chung: NPC hiện diện, biết sự kiện, đúng occurrence).

## EV-A1-WRD-003 — Sáng sau đêm hội

- `DLG-A1-WRD-003-V2-L01` **Hugo:** “Hôm qua vui thật. Hôm nay cái xe của tôi chính thức được nghỉ.”
  - CONDITION: `festival_ended_and_player_attendance_verified` (cộng điều kiện chung: NPC hiện diện, biết sự kiện, đúng occurrence).
- `DLG-A1-WRD-003-V2-L02` **Ada:** “Hôm qua đông người lắm. Cậu không tới à? Thế hôm nay cậu định đi đâu?”
  - CONDITION: `festival_ended_and_player_not_attended` (cộng điều kiện chung: NPC hiện diện, biết sự kiện, đúng occurrence).
- `DLG-A1-WRD-003-V2-L03` **Sophie:** “Nhìn mặt hồ ban ngày thấy lạ thật. Tối qua chỗ này sáng rực.”
  - CONDITION: `festival_ended_and_actual_location_lake_and_player_attended` (cộng điều kiện chung: NPC hiện diện, biết sự kiện, đúng occurrence).
- `DLG-A1-WRD-003-V2-L04` **Sophie:** “Sân hôm nay trống hẳn. Tối qua tôi cứ phải né người đi qua.”
  - CONDITION: `festival_ended_and_actual_location_village_square_and_player_attended` (cộng điều kiện chung: NPC hiện diện, biết sự kiện, đúng occurrence).

**JSON:** [A1_EVENT_DIALOGUE_V2.json](A1_EVENT_DIALOGUE_V2.json). **Event độc lập:** [A1_EVENT_SCRIPTS_V2.md](../events/A1_EVENT_SCRIPTS_V2.md). Không dùng câu của event khác vì có tên NPC giống nhau.
