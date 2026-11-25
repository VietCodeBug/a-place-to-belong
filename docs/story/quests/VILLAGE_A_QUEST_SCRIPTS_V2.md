# Làng A — Viết lại 24 nhiệm vụ quan hệ V2 (QUEST ONLY)

**DRAFT_STORY — bản thay thế nội dung đề xuất, chưa duyệt từng nhiệm vụ, chưa tích hợp engine.** Giữ nguyên quest ID, nhân vật, gate quan hệ Q1/Q2/QF và bond cũ; thay tình huống và hoạt động. Không xóa nguồn V0/V1, không dùng thoại cũ cho tình huống mới. Event tự vận hành; quest chỉ được A chủ động nhận. Các event liên quan là bối cảnh có thể dùng, không ép mở hoặc chờ hội vô hạn: chỉ dùng bản thử riêng khi ghi rõ và được duyệt. Nếu thiếu cơ chế thì giữ quest chưa khả dụng. Địa điểm cụ thể, đạo cụ, lịch, thi đấu, phần thưởng, vật phẩm, weather và signal cần TO_BIND. Hồ đã duyệt, Làng B chưa viết. Không đổi Thomas hoặc phần mở đầu.

## Hazel — Từ bảo vệ vụ rau đến tạo ra thứ cả làng muốn tranh tài.

### VLA01-Q1 — Vụ trộm rau lúc chạng vạng

- TÌNH HUỐNG: Lá bị cắn ở ba luống, dấu trên đất hướng ra rìa rừng. Hazel không biết khách đêm là con gì; Felix đoán bừa.
- ĐỊA ĐIỂM: Vườn tây, mép rừng. EVENT REF: EV-A1-WLD-004 (tùy context).
- ĐIỀU KIỆN: thân thiết đề xuất 20; npc.met; npc.shared_activity_completed_at_least_once; npc.return_visit_count>=1; npc_available; player_chooses_listen_or_offer. Giữ khoảng gặp thường, chủ động nhận.

**VLA01-Q1-V2-S1:** Kiểm ba luống, phân biệt vết bị cắn và vết gió làm gãy.

PROOF: `damage_clues_checked` (TO_BIND). Kết quả: Ba dấu được ghi, không tự xác định loài.

**VLA01-Q1-V2-S2:** Chọn một trong hai điểm quan sát an toàn ở vườn; đợi lượt động vật xuất hiện hoặc cửa sổ quan sát kết thúc.

PROOF: `watch_window_resolved` (TO_BIND). Kết quả: Có kết quả nhìn thấy hoặc không nhìn thấy thú.

**VLA01-Q1-V2-S3:** Đối chiếu dấu với kết quả, giúp bảo vệ một luống bằng đạo cụ đã duyệt.

PROOF: `crop_protection_verified` (TO_BIND). Kết quả: Một luống được bảo vệ; nguyên nhân chỉ ghi nếu đủ bằng chứng.

**Nhánh gameplay (chỉ ghi nhánh có bằng chứng):**
- Quan sát được vị khách — `animal_observation_verified`: Ghi nguyên nhân đã xác minh.
- Không thấy thú, ưu tiên giữ luống — `watch_ended_without_sighting`: Giữ rau nhưng chưa biết thủ phạm.

**Không tham gia:** Hazel và Felix tự che luống; dấu mới vẫn có thể xuất hiện.

**Thất bại/hoãn:** Chọn sai vị trí khiến không thấy thú, không khóa việc bảo vệ vườn.

**Hoàn thành:** đã nhận, đủ 3 proof, có proof nhánh đúng và kết quả xác nhận; hoàn thành lượt không đồng nghĩa thắng. **Thoại:** `DLG-VLA01-Q1-V2` trong ngân hàng riêng.

### VLA01-Q2 — Cuộc đua giành giỏ rau

- TÌNH HUỐNG: Một đợt thu hoạch nhỏ cần chọn rau cho cuộc thi ở chợ. Hazel và Felix muốn chọn theo hai tiêu chí khác nhau: ngon và đẹp.
- ĐỊA ĐIỂM: Vườn tây, sân chung. EVENT REF: EV-A1-FES-003 (tùy context).
- ĐIỀU KIỆN: thân thiết đề xuất 50; Q1.status in [completed,resolved_without_player]; npc.nonquest_meetups_after_Q1>=1; npc.available_context_Q2; player_chooses_accept. Giữ khoảng gặp thường, chủ động nhận.

**VLA01-Q2-V2-S1:** Quan sát các mẫu được phép hái, chọn giỏ theo tiêu chí đã công bố.

PROOF: `harvest_selection_verified` (TO_BIND). Kết quả: Giỏ có thành phần thực, không nhân bản đồ.

**VLA01-Q2-V2-S2:** Đưa giỏ tới điểm cân/chấm trong sân chung; nếu hội chưa mở, dùng buổi thử riêng không tính giải hội.

PROOF: `entry_delivered` (TO_BIND). Kết quả: Giỏ được ghi nhận đúng lượt.

**VLA01-Q2-V2-S3:** Tham gia chấm thử hoặc thi thật nếu có; hệ chấm xác nhận kết quả.

PROOF: `judging_result_verified` (TO_BIND). Kết quả: Có điểm thực tế; không bảo đảm giải.

**Nhánh gameplay (chỉ ghi nhánh có bằng chứng):**
- Ưu tiên vị và độ tươi — `quality_entry_verified`: Giỏ mộc mạc, phản ứng chú trọng chất lượng.
- Ưu tiên màu sắc và bố cục — `presentation_entry_verified`: Giỏ bắt mắt, phản ứng khác dù không thắng.

**Không tham gia:** Hazel tự chọn rau; nếu chợ diễn ra, kết quả của NPC vẫn được lưu.

**Thất bại/hoãn:** Giỏ có thể không được giải; vẫn hoàn thành việc dự thi.

**Hoàn thành:** đã nhận, đủ 3 proof, có proof nhánh đúng và kết quả xác nhận; hoàn thành lượt không đồng nghĩa thắng. **Thoại:** `DLG-VLA01-Q2-V2` trong ngân hàng riêng.

### VLA01-QF — Khu vườn của những người tranh tài

- TÌNH HUỐNG: Hazel thử dành một góc vườn chung cho các nhóm chăm cây theo cách khác nhau. Cô lo người khác phá kế hoạch, nhưng muốn xem kết quả thật.
- ĐỊA ĐIỂM: Vườn tây. EVENT REF: EV-A1-WRD-002 (tùy context).
- ĐIỀU KIỆN: thân thiết đề xuất 80; Q2.status in [completed,resolved_without_player]; npc.nonquest_meetups_after_Q2>=2; npc.personal_bond_event_seen==true; npc.available_context_QF; player_chooses_accept. Giữ khoảng gặp thường, chủ động nhận.

**VLA01-QF-V2-S1:** Chọn một lô nhỏ không chắn lối, phân bổ mẫu cây và giới hạn nước theo luật thử.

PROOF: `plot_plan_verified` (TO_BIND). Kết quả: Lô thử được xác định, không thay cả vườn.

**VLA01-QF-V2-S2:** Chăm hoặc quan sát một vòng sinh trưởng có thật; cư dân tự quản phần họ nhận.

PROOF: `trial_cycle_verified` (TO_BIND). Kết quả: Kết quả dựa vào trạng thái cây, không nhảy thời gian qua thoại.

**VLA01-QF-V2-S3:** So sánh kết quả và chọn cách giữ lô chung; Hazel xác nhận quyền dùng chung.

PROOF: `shared_plot_decision_verified` (TO_BIND). Kết quả: Lô chung có quy tắc và kết quả nhìn thấy.

**Nhánh gameplay (chỉ ghi nhánh có bằng chứng):**
- Thử chăm cùng người tự nguyện — `shared_care_verified`: Giữ cách hợp tác nếu thử nghiệm phù hợp.
- Hai lô nhỏ để so cách chăm — `comparison_verified`: Giữ bảng kết quả; không tự gán người thắng.

**Không tham gia:** Hazel thử một lô nhỏ cùng cư dân tự nguyện, hoặc hoãn nếu chưa đủ điều kiện.

**Thất bại/hoãn:** Cây thử có thể phát triển không tốt; kết quả xấu vẫn là thông tin.

**Hoàn thành:** đã nhận, đủ 3 proof, có proof nhánh đúng và kết quả xác nhận; hoàn thành lượt không đồng nghĩa thắng. **Thoại:** `DLG-VLA01-QF-V2` trong ngân hàng riêng.

## Owen — Kỹ năng, quyết định sửa chữa dưới áp lực và một thành quả dùng thật.

### VLA04-Q1 — Chiếc xe không chịu chạy thẳng

- TÌNH HUỐNG: Hugo cần thử một xe đẩy trước khi mang đồ ra chợ; bánh xe đi lệch dù khung còn nguyên. Owen muốn xác định lỗi thay vì sửa mò.
- ĐỊA ĐIỂM: Sân thủ công, đường thử trong làng. EVENT REF: EV-A1-FES-003 (tùy context).
- ĐIỀU KIỆN: thân thiết đề xuất 20; npc.met; npc.shared_activity_completed_at_least_once; npc.return_visit_count>=1; npc_available; player_chooses_listen_or_offer. Giữ khoảng gặp thường, chủ động nhận.

**VLA04-Q1-V2-S1:** Đẩy xe mẫu trên đoạn thử bằng phẳng đã kiểm; quan sát bánh, khung và độ lệch.

PROOF: `cart_test_verified` (TO_BIND). Kết quả: Xác định triệu chứng thật.

**VLA04-Q1-V2-S2:** Chọn vị trí kiểm trước, giữ dụng cụ nhẹ cho Owen; ông làm phần sửa chuyên môn.

PROOF: `cart_adjustment_verified` (TO_BIND). Kết quả: Điều chỉnh được xác nhận, không thao tác nguy hiểm.

**VLA04-Q1-V2-S3:** Thử lại với tải mẫu an toàn và so độ lệch.

PROOF: `cart_retest_verified` (TO_BIND). Kết quả: Xe đạt hoặc chưa đạt; nếu chưa đạt phải chỉnh lại hoặc ngừng.

**Nhánh gameplay (chỉ ghi nhánh có bằng chứng):**
- Ưu tiên kiểm bánh — `wheel_check_verified`: Owen nhớ cách chẩn đoán.
- Kiểm khung và tải trước — `frame_check_verified`: So được nguyên nhân tải lệch.

**Không tham gia:** Owen và Hugo tự kiểm rồi mới dùng xe.

**Thất bại/hoãn:** Xe vẫn lệch: không ghi đã sửa, có thể thử lại hoặc giao Owen.

**Hoàn thành:** đã nhận, đủ 3 proof, có proof nhánh đúng và kết quả xác nhận; hoàn thành lượt không đồng nghĩa thắng. **Thoại:** `DLG-VLA04-Q1-V2` trong ngân hàng riêng.

### VLA04-Q2 — Cây cầu kêu trong mưa

- TÌNH HUỐNG: Sau mưa hoặc buổi kiểm định riêng, một tấm ván có dấu bất thường. Owen phải quyết định sửa hay hạn chế sử dụng, không được đánh cược với an toàn.
- ĐỊA ĐIỂM: Cầu gỗ nối nhà A – làng. EVENT REF: EV-A1-DRM-001 (tùy context).
- ĐIỀU KIỆN: thân thiết đề xuất 50; Q1.status in [completed,resolved_without_player]; npc.nonquest_meetups_after_Q1>=1; npc.available_context_Q2; player_chooses_accept. Giữ khoảng gặp thường, chủ động nhận.

**VLA04-Q2-V2-S1:** Quan sát chỗ cảnh báo từ phần đường an toàn, xác nhận vị trí lỗi với Owen.

PROOF: `bridge_inspection_verified` (TO_BIND). Kết quả: Không cho A thử trên phần hỏng.

**VLA04-Q2-V2-S2:** Chọn góp vận chuyển vật liệu nhẹ hoặc hỗ trợ kiểm tuyến an toàn; người có tay nghề tự sửa.

PROOF: `bridge_support_verified` (TO_BIND). Kết quả: Ghi công đúng phần A làm.

**VLA04-Q2-V2-S3:** Chờ xác nhận kiểm định; chỉ đi qua phần mở sau khi có kết quả.

PROOF: `bridge_safety_result_verified` (TO_BIND). Kết quả: Cầu đạt hoặc chờ sửa tiếp; tuyến thiết yếu vẫn thông.

**Nhánh gameplay (chỉ ghi nhánh có bằng chứng):**
- Mang vật liệu tới điểm nhận — `material_delivered_verified`: Ghi đóng góp vật liệu.
- Kiểm tuyến an toàn đã chỉ định — `safe_route_check_verified`: Ghi đóng góp điều hướng.

**Không tham gia:** Owen và nhóm cư dân tự xử lý, duy trì lối đi an toàn.

**Thất bại/hoãn:** Nếu chưa đạt kiểm định, hoãn hoàn thành; A có thể rời đi.

**Hoàn thành:** đã nhận, đủ 3 proof, có proof nhánh đúng và kết quả xác nhận; hoàn thành lượt không đồng nghĩa thắng. **Thoại:** `DLG-VLA04-Q2-V2` trong ngân hàng riêng.

### VLA04-QF — Thử thách xe đẩy của Owen

- TÌNH HUỐNG: Owen muốn làm một thử thách xe đẩy nhẹ cho người lớn: mang tải mẫu qua đoạn đã kiểm, cân bằng và quay về. Ông muốn xem thiết kế nào dễ dùng hơn, không phải ai nhanh nhất bằng mọi giá.
- ĐỊA ĐIỂM: Sân thủ công và đường thử bằng phẳng. EVENT REF: EV-A1-FES-002 (tùy context).
- ĐIỀU KIỆN: thân thiết đề xuất 80; Q2.status in [completed,resolved_without_player]; npc.nonquest_meetups_after_Q2>=2; npc.personal_bond_event_seen==true; npc.available_context_QF; player_chooses_accept. Giữ khoảng gặp thường, chủ động nhận.

**VLA04-QF-V2-S1:** Chọn cấu hình ổn định hoặc nhẹ, thử trong khu an toàn.

PROOF: `cart_configuration_tested` (TO_BIND). Kết quả: Xe được duyệt trước lượt chơi.

**VLA04-QF-V2-S2:** Đi qua các mốc, giữ tải mẫu; có thể quay lại hoặc giảm tốc nếu mất ổn định.

PROOF: `cart_course_attempt_verified` (TO_BIND). Kết quả: Kết quả lượt chơi ghi theo mốc/tải.

**VLA04-QF-V2-S3:** So bảng thử với Owen; chỉ lưu thiết kế qua kiểm an toàn.

PROOF: `cart_design_review_verified` (TO_BIND). Kết quả: Có mẫu được giữ hoặc cần chỉnh.

**Nhánh gameplay (chỉ ghi nhánh có bằng chứng):**
- Chọn cấu hình ổn định — `stable_run_verified`: Giữ ưu tiên tải không xô lệch.
- Chọn cấu hình nhẹ đã qua kiểm — `light_run_verified`: Giữ ưu tiên dễ điều khiển.

**Không tham gia:** Owen tổ chức buổi thử nhỏ với người lớn tự nguyện hoặc cất xe để thử sau.

**Thất bại/hoãn:** Thua thử thách hoặc mất tải mẫu không khiến NPC trách; xe chưa đạt không được đưa vào dùng.

**Hoàn thành:** đã nhận, đủ 3 proof, có proof nhánh đúng và kết quả xác nhận; hoàn thành lượt không đồng nghĩa thắng. **Thoại:** `DLG-VLA04-QF-V2` trong ngân hàng riêng.

## Clara — Sáng tạo, thi đấu, phản ứng trước thất bại; không lặp câu chuyện Grace.

### VLA06-Q1 — Đoán món của Felix

- TÌNH HUỐNG: Felix tự nhận có thể đoán nguyên liệu mà không cần nhìn. Clara thách A thử một lượt nếm với nguyên liệu được xác nhận phù hợp.
- ĐỊA ĐIỂM: Sân chung, góc chuẩn bị món. EVENT REF: EV-A1-FES-003 (tùy context).
- ĐIỀU KIỆN: thân thiết đề xuất 20; npc.met; npc.shared_activity_completed_at_least_once; npc.return_visit_count>=1; npc_available; player_chooses_listen_or_offer. Giữ khoảng gặp thường, chủ động nhận.

**VLA06-Q1-V2-S1:** Chọn một trong ba mẫu an toàn đã công bố thành phần dị ứng nếu áp dụng.

PROOF: `tasting_sample_selected` (TO_BIND). Kết quả: Mẫu được ghi đúng.

**VLA06-Q1-V2-S2:** Chọn đáp án dựa vào gợi ý mùi/vị trong game; không bắt người chơi tự biết công thức ngoài đời.

PROOF: `tasting_guess_submitted` (TO_BIND). Kết quả: Đáp án được khóa cho lượt.

**VLA06-Q1-V2-S3:** Xem kết quả rồi thử một cách bày món hoặc ghi góp ý.

PROOF: `tasting_result_verified` (TO_BIND). Kết quả: Đúng/sai có phản hồi riêng.

**Nhánh gameplay (chỉ ghi nhánh có bằng chứng):**
- Đoán đúng — `guess_correct_verified`: Clara nhớ kết quả đúng.
- Đoán sai — `guess_wrong_verified`: Felix có cớ trêu, không phạt.

**Không tham gia:** Clara thử với người tự nguyện khác hoặc tự nếm.

**Thất bại/hoãn:** Sai đáp án vẫn kết thúc thử thách.

**Hoàn thành:** đã nhận, đủ 3 proof, có proof nhánh đúng và kết quả xác nhận; hoàn thành lượt không đồng nghĩa thắng. **Thoại:** `DLG-VLA06-Q1-V2` trong ngân hàng riêng.

### VLA06-Q2 — Món dự thi biến mất

- TÌNH HUỐNG: Món Clara chuẩn bị được chuyển nhầm trước khi chấm. Không có kẻ phá hoại được định sẵn; chứng cứ xác định ai đã dời.
- ĐỊA ĐIỂM: Sân chung, các gian chợ. EVENT REF: EV-A1-FES-003, EV-A1-SOC-003 (tùy context).
- ĐIỀU KIỆN: thân thiết đề xuất 50; Q1.status in [completed,resolved_without_player]; npc.nonquest_meetups_after_Q1>=1; npc.available_context_Q2; player_chooses_accept. Giữ khoảng gặp thường, chủ động nhận.

**VLA06-Q2-V2-S1:** Kiểm vị trí trống, nhãn gian và dấu chuyển đồ.

PROOF: `entry_evidence_checked` (TO_BIND). Kết quả: Có manh mối, không tự đổ tội.

**VLA06-Q2-V2-S2:** Đối chiếu với nơi giữ đồ có căn cứ; nếu không tìm được, chọn mẫu dự phòng đã có hoặc rút lượt.

PROOF: `entry_or_fallback_verified` (TO_BIND). Kết quả: Món tìm lại, món dự phòng hoặc rút.

**VLA06-Q2-V2-S3:** Xác nhận bàn giao với người phụ trách; chấm nếu còn lượt, nếu không ghi bỏ lỡ.

PROOF: `entry_disposition_verified` (TO_BIND). Kết quả: Kết quả đúng tình trạng hội.

**Nhánh gameplay (chỉ ghi nhánh có bằng chứng):**
- Tìm lại món — `entry_found_verified`: Món trở lại nếu còn lượt.
- Dùng món dự phòng hợp lệ — `fallback_entry_verified`: Thi bằng món khác.
- Rút lượt chấm — `entry_withdrawn_verified`: Không tự tính thắng.

**Không tham gia:** Ban tổ chức tự tìm hoặc Clara rút lượt thi.

**Thất bại/hoãn:** Không tìm kịp: có thể mất lượt thi, không khóa tuyến quan hệ.

**Hoàn thành:** đã nhận, đủ 3 proof, có proof nhánh đúng và kết quả xác nhận; hoàn thành lượt không đồng nghĩa thắng. **Thoại:** `DLG-VLA06-Q2-V2` trong ngân hàng riêng.

### VLA06-QF — Đối thủ trong gian bếp

- TÌNH HUỐNG: Clara muốn tự dự thi bằng biến thể táo bạo, đối diện nguy cơ không được thích. A là người thử cùng, không phải người phục vụ.
- ĐỊA ĐIỂM: Sân chung. EVENT REF: EV-A1-FES-003 (tùy context).
- ĐIỀU KIỆN: thân thiết đề xuất 80; Q2.status in [completed,resolved_without_player]; npc.nonquest_meetups_after_Q2>=2; npc.personal_bond_event_seen==true; npc.available_context_QF; player_chooses_accept. Giữ khoảng gặp thường, chủ động nhận.

**VLA06-QF-V2-S1:** Chọn mẫu quen hoặc biến thể trong bộ nguyên liệu đã duyệt.

PROOF: `recipe_variant_selected` (TO_BIND). Kết quả: Khóa mẫu thi.

**VLA06-QF-V2-S2:** Thực hiện minigame chuẩn bị phần an toàn và hoàn thành mẫu; Clara xử lý bếp nóng.

PROOF: `entry_prepared_verified` (TO_BIND). Kết quả: Có món thật đủ điều kiện.

**VLA06-QF-V2-S3:** Nộp món và nhận điểm thử từ người chấm; nếu không có hội, buổi thử nhỏ có kết quả riêng.

PROOF: `entry_score_verified` (TO_BIND). Kết quả: Kết quả thắng/thua hoặc điểm thử, không gộp hai loại.

**Nhánh gameplay (chỉ ghi nhánh có bằng chứng):**
- Mẫu quen, hoàn thiện tốt — `familiar_entry_verified`: Clara nhớ A tin vào món quen.
- Thử biến thể mới — `bold_entry_verified`: Clara nhớ A dám thử.

**Không tham gia:** Clara tự làm mẫu và chấm thử khi có người, không tự nhận giải.

**Thất bại/hoãn:** Điểm thấp vẫn kết thúc lượt; có thể thử lại vào dịp khác.

**Hoàn thành:** đã nhận, đủ 3 proof, có proof nhánh đúng và kết quả xác nhận; hoàn thành lượt không đồng nghĩa thắng. **Thoại:** `DLG-VLA06-QF-V2` trong ngân hàng riêng.

## Rowan — Đọc rừng, chọn đường, tham gia tìm kiếm; không mặc định là thợ săn.

### VLA09-Q1 — Ba dấu trên đường rừng

- TÌNH HUỐNG: Rowan thấy nhiều dấu khác nhau sau một lượt thú đi qua. Ông muốn kiểm xem A phân biệt dấu cũ và mới ra sao.
- ĐỊA ĐIỂM: Lối rừng đã mở. EVENT REF: EV-A1-WLD-001, EV-A1-WLD-002 (tùy context).
- ĐIỀU KIỆN: thân thiết đề xuất 20; npc.met; npc.shared_activity_completed_at_least_once; npc.return_visit_count>=1; npc_available; player_chooses_listen_or_offer. Giữ khoảng gặp thường, chủ động nhận.

**VLA09-Q1-V2-S1:** Quan sát ba dấu trên tuyến an toàn; xem bằng chứng đã hiện diện.

PROOF: `three_traces_checked` (TO_BIND). Kết quả: Ghi dấu nhìn thấy, không sinh thú.

**VLA09-Q1-V2-S2:** Chọn hướng suy luận và kiểm điểm thứ hai.

PROOF: `trail_direction_checked` (TO_BIND). Kết quả: Có xác nhận hoặc dấu không khớp.

**VLA09-Q1-V2-S3:** Quay về mốc ban đầu và báo kết quả thực tế.

PROOF: `safe_return_report_verified` (TO_BIND). Kết quả: Không nhận công tìm thấy thú khi chỉ thấy dấu.

**Nhánh gameplay (chỉ ghi nhánh có bằng chứng):**
- Tìm được hướng khớp — `trail_match_verified`: Ghi tuyến đã xác minh.
- Không đủ dấu, quay lại — `trail_uncertain_verified`: Ghi chưa xác định.

**Không tham gia:** Rowan tự kiểm tuyến trong lượt đi thường.

**Thất bại/hoãn:** Mất dấu là kết quả hợp lệ; không đuổi vào vùng chưa mở.

**Hoàn thành:** đã nhận, đủ 3 proof, có proof nhánh đúng và kết quả xác nhận; hoàn thành lượt không đồng nghĩa thắng. **Thoại:** `DLG-VLA09-Q1-V2` trong ngân hàng riêng.

### VLA09-Q2 — Một người chưa trở về

- TÌNH HUỐNG: Khi một cư dân trưởng thành thực sự đi lạc, Rowan muốn A tham gia tìm; nếu không có biến cố, thay bằng diễn tập tìm mốc với vật đánh dấu đã đặt, tuyệt đối không nói có người mất tích.
- ĐỊA ĐIỂM: Lối rừng – cầu – làng. EVENT REF: EV-A1-EXP-003, EV-A1-SOC-002 (tùy context).
- ĐIỀU KIỆN: thân thiết đề xuất 50; Q1.status in [completed,resolved_without_player]; npc.nonquest_meetups_after_Q1>=1; npc.available_context_Q2; player_chooses_accept. Giữ khoảng gặp thường, chủ động nhận.

**VLA09-Q2-V2-S1:** Kiểm thông tin được xác nhận tại điểm tập hợp; chọn tìm thật hoặc diễn tập đúng context.

PROOF: `search_context_verified` (TO_BIND). Kết quả: Mode real_search hoặc drill được khóa.

**VLA09-Q2-V2-S2:** Tìm hai điểm dựa trên dấu, báo nhóm hỗ trợ; không vào vùng nguy hiểm.

PROOF: `search_points_verified` (TO_BIND). Kết quả: Ghi điểm đã kiểm.

**VLA09-Q2-V2-S3:** Xác nhận người trở về an toàn hoặc kết quả diễn tập; NPC có thể tìm trước A.

PROOF: `search_resolution_verified` (TO_BIND). Kết quả: Ghi ai thực sự tìm thấy.

**Nhánh gameplay (chỉ ghi nhánh có bằng chứng):**
- Tìm thấy người hoặc mốc mục tiêu — `target_located_by_player`: Ghi công tìm trong đúng mode.
- Hỗ trợ nhóm tìm — `search_support_verified`: Ghi hỗ trợ, không ghi A tìm thấy.
- Nhóm khác đã tìm, kết thúc lượt — `search_resolved_by_others`: Không nhận công thay NPC.

**Không tham gia:** Nhóm người lớn tự tìm hoặc Rowan kết thúc diễn tập.

**Thất bại/hoãn:** Nếu không tìm được, nhóm tiếp tục; không bắt A liều.

**Hoàn thành:** đã nhận, đủ 3 proof, có proof nhánh đúng và kết quả xác nhận; hoàn thành lượt không đồng nghĩa thắng. **Thoại:** `DLG-VLA09-Q2-V2` trong ngân hàng riêng.

### VLA09-QF — Hội tìm dấu: đường về

- TÌNH HUỐNG: Rowan tổ chức hoặc thử riêng một tuyến ba mốc, muốn người chơi chứng minh có thể quan sát tốt mà không phá sinh cảnh.
- ĐỊA ĐIỂM: Lối rừng đã kiểm, gần cầu. EVENT REF: EV-A1-FES-002, EV-A1-EXP-004 (tùy context).
- ĐIỀU KIỆN: thân thiết đề xuất 80; Q2.status in [completed,resolved_without_player]; npc.nonquest_meetups_after_Q2>=2; npc.personal_bond_event_seen==true; npc.available_context_QF; player_chooses_accept. Giữ khoảng gặp thường, chủ động nhận.

**VLA09-QF-V2-S1:** Chọn tuyến đã kiểm và nhận ba gợi ý mốc, không bật waypoint chỉ thẳng.

PROOF: `tracking_route_selected` (TO_BIND). Kết quả: Lưu tuyến và mốc.

**VLA09-QF-V2-S2:** Xác minh từng dấu, có thể bỏ mốc cuối để quay về an toàn.

PROOF: `tracking_challenge_attempt_verified` (TO_BIND). Kết quả: Ghi số mốc thật.

**VLA09-QF-V2-S3:** Về trạm, hệ thử xác nhận kết quả và tác động khu vực.

PROOF: `tracking_challenge_returned` (TO_BIND). Kết quả: Có kết quả đủ/thiếu; không tự thắng.

**Nhánh gameplay (chỉ ghi nhánh có bằng chứng):**
- Về đủ mốc — `all_markers_verified`: Kết quả trọn vẹn.
- Quay về khi còn thiếu — `partial_return_verified`: Giữ an toàn, không nhận điểm mốc thiếu.

**Không tham gia:** Rowan tự hướng dẫn nhóm khác, hoặc để dịp sau.

**Thất bại/hoãn:** Không đủ mốc vẫn kết thúc cuộc thử nếu đã về an toàn.

**Hoàn thành:** đã nhận, đủ 3 proof, có proof nhánh đúng và kết quả xác nhận; hoàn thành lượt không đồng nghĩa thắng. **Thoại:** `DLG-VLA09-QF-V2` trong ngân hàng riêng.

## Maeve — Thiết kế, điều tra hiểu lầm, sáng tạo tập thể.

### VLA13-Q1 — Hai lá cờ, một cơn gió

- TÌNH HUỐNG: Maeve thử hai mẫu cờ trang trí cho dịp hội. Một mẫu nhìn đẹp nhưng dễ rối khi thử trong gió mô phỏng đã kiểm.
- ĐỊA ĐIỂM: Sân thủ công. EVENT REF: EV-A1-FES-001, EV-A1-DRM-002 (tùy context).
- ĐIỀU KIỆN: thân thiết đề xuất 20; npc.met; npc.shared_activity_completed_at_least_once; npc.return_visit_count>=1; npc_available; player_chooses_listen_or_offer. Giữ khoảng gặp thường, chủ động nhận.

**VLA13-Q1-V2-S1:** Chọn màu/hình từ mẫu hiện có và kiểm cách lắp.

PROOF: `flag_design_selected` (TO_BIND). Kết quả: Mẫu có ID riêng.

**VLA13-Q1-V2-S2:** Thử trên giá thấp an toàn; xem kết quả bền/nhìn rõ, không tự giả thời tiết.

PROOF: `flag_trial_verified` (TO_BIND). Kết quả: Mẫu đạt hoặc cần chỉnh.

**VLA13-Q1-V2-S3:** Điều chỉnh hoặc chọn mẫu khác, xác nhận phiên bản được trưng bày thử.

PROOF: `flag_display_verified` (TO_BIND). Kết quả: Có sản phẩm mẫu nhìn thấy.

**Nhánh gameplay (chỉ ghi nhánh có bằng chứng):**
- Mẫu nổi bật — `bold_flag_verified`: Giữ hình dễ nhận ra.
- Mẫu tối giản — `simple_flag_verified`: Giữ cách lắp gọn.

**Không tham gia:** Maeve tự thử và chọn mẫu phù hợp.

**Thất bại/hoãn:** Mẫu hỏng có thể sửa hoặc bỏ; không giả là đã treo.

**Hoàn thành:** đã nhận, đủ 3 proof, có proof nhánh đúng và kết quả xác nhận; hoàn thành lượt không đồng nghĩa thắng. **Thoại:** `DLG-VLA13-Q1-V2` trong ngân hàng riêng.

### VLA13-Q2 — Ai đổi chỗ món dự thi?

- TÌNH HUỐNG: Một món thủ công được chuyển nhầm. Tessa lo bị nghi vì từng vội vàng. Maeve phải nghe chứng cứ thay vì suy đoán.
- ĐỊA ĐIỂM: Sân thủ công và sân chung. EVENT REF: EV-A1-SOC-003 (tùy context).
- ĐIỀU KIỆN: thân thiết đề xuất 50; Q1.status in [completed,resolved_without_player]; npc.nonquest_meetups_after_Q1>=1; npc.available_context_Q2; player_chooses_accept. Giữ khoảng gặp thường, chủ động nhận.

**VLA13-Q2-V2-S1:** Kiểm vị trí, nhãn và dấu chuyển của đồ được phép xem.

PROOF: `craft_evidence_checked` (TO_BIND). Kết quả: Không tự tạo lời buộc tội.

**VLA13-Q2-V2-S2:** Chọn kiểm gian có bằng chứng, xác nhận món đúng hoặc ghi chưa tìm được.

PROOF: `craft_search_resolved` (TO_BIND). Kết quả: Món tìm thấy hoặc chưa rõ.

**VLA13-Q2-V2-S3:** Báo kết quả thật, cho Maeve và người liên quan tự xử lý hiểu lầm.

PROOF: `craft_disposition_verified` (TO_BIND). Kết quả: Có sửa hiểu lầm nếu đủ bằng chứng.

**Nhánh gameplay (chỉ ghi nhánh có bằng chứng):**
- Tìm thấy món — `craft_found_verified`: Người bị nghi được giải thích đúng.
- Chưa đủ bằng chứng — `craft_unresolved_verified`: Không kết tội; NPC tìm tiếp.

**Không tham gia:** Người tổ chức tự tìm hoặc để món ngoài cuộc thi; Maeve không được khẳng định Tessa có lỗi.

**Thất bại/hoãn:** Chưa tìm được không khóa quan hệ.

**Hoàn thành:** đã nhận, đủ 3 proof, có proof nhánh đúng và kết quả xác nhận; hoàn thành lượt không đồng nghĩa thắng. **Thoại:** `DLG-VLA13-Q2-V2` trong ngân hàng riêng.

### VLA13-QF — Dải cờ không ai làm giống ai

- TÌNH HUỐNG: Maeve muốn làm dải cờ ghép từ mẫu của người tự nguyện; một số mẫu lệch nhau rõ rệt. Thử thách là tìm cách ghép thành bố cục chung, không sửa hộ tất cả.
- ĐỊA ĐIỂM: Sân thủ công / sân chung. EVENT REF: EV-A1-FES-001 (tùy context).
- ĐIỀU KIỆN: thân thiết đề xuất 80; Q2.status in [completed,resolved_without_player]; npc.nonquest_meetups_after_Q2>=2; npc.personal_bond_event_seen==true; npc.available_context_QF; player_chooses_accept. Giữ khoảng gặp thường, chủ động nhận.

**VLA13-QF-V2-S1:** Chọn các mẫu có chủ đồng ý, bố trí theo màu/hình.

PROOF: `flag_set_layout_verified` (TO_BIND). Kết quả: Mỗi mẫu giữ tác giả.

**VLA13-QF-V2-S2:** Thử hai cách ghép trên giá thấp, kiểm độ rõ và an toàn.

PROOF: `combined_display_trial_verified` (TO_BIND). Kết quả: Kết quả thử thật.

**VLA13-QF-V2-S3:** Đặt phiên bản được đồng ý ở khu trưng bày phù hợp hoặc lưu mẫu riêng nếu chưa có hội.

PROOF: `shared_display_accepted` (TO_BIND). Kết quả: Có dấu vết trưng bày hoặc bản mẫu.

**Nhánh gameplay (chỉ ghi nhánh có bằng chứng):**
- Giữ sự khác nhau — `mixed_display_verified`: Các mẫu vẫn nhận ra được.
- Ghép theo nhóm màu — `pattern_display_verified`: Bố cục thống nhất nhưng không xóa tác giả.

**Không tham gia:** Maeve tự ghép cùng người tự nguyện hoặc hoãn.

**Thất bại/hoãn:** Bố cục không đạt thử thì chỉnh lại, không nói đã dựng hội.

**Hoàn thành:** đã nhận, đủ 3 proof, có proof nhánh đúng và kết quả xác nhận; hoàn thành lượt không đồng nghĩa thắng. **Thoại:** `DLG-VLA13-QF-V2` trong ngân hàng riêng.

## Evelyn — Tò mò, kiểm chứng, khám phá thiên nhiên và truyền tri thức.

### VLA15-Q1 — Chiếc hũ không khớp nhãn

- TÌNH HUỐNG: Một mẫu hạt không khớp bản ghi cũ. Evelyn đưa ba dấu hiệu đối chiếu; A phải tìm đúng mẫu hoặc thừa nhận chưa biết.
- ĐỊA ĐIỂM: Vườn tây. EVENT REF: NONE (tùy context).
- ĐIỀU KIỆN: thân thiết đề xuất 20; npc.met; npc.shared_activity_completed_at_least_once; npc.return_visit_count>=1; npc_available; player_chooses_listen_or_offer. Giữ khoảng gặp thường, chủ động nhận.

**VLA15-Q1-V2-S1:** Kiểm nhãn, kích thước mẫu và bản ghi tham chiếu.

PROOF: `seed_evidence_checked` (TO_BIND). Kết quả: Ba dữ kiện được ghi riêng.

**VLA15-Q1-V2-S2:** Chọn giả thuyết trong các mẫu đã xác nhận, hoặc để chưa xác định.

PROOF: `seed_hypothesis_submitted` (TO_BIND). Kết quả: Không ghi đoán thành sự thật.

**VLA15-Q1-V2-S3:** Đối chiếu kết quả và cất hũ đúng nhóm.

PROOF: `seed_disposition_verified` (TO_BIND). Kết quả: Hũ được xác minh hoặc cách ly.

**Nhánh gameplay (chỉ ghi nhánh có bằng chứng):**
- Xác định được mẫu — `seed_identity_verified`: Cập nhật nhãn.
- Chưa đủ căn cứ — `seed_unknown_verified`: Để hũ riêng.

**Không tham gia:** Evelyn tự đối chiếu hoặc giữ hũ chưa xác định.

**Thất bại/hoãn:** Đoán sai được sửa, không trộn hạt.

**Hoàn thành:** đã nhận, đủ 3 proof, có proof nhánh đúng và kết quả xác nhận; hoàn thành lượt không đồng nghĩa thắng. **Thoại:** `DLG-VLA15-Q1-V2` trong ngân hàng riêng.

### VLA15-Q2 — Bình minh ở hai nơi

- TÌNH HUỐNG: Evelyn muốn so sánh hai môi trường: vườn vào một thời điểm và lần quay lại; hồ là tuyến mở rộng nếu A muốn. Không khẳng định loài chưa biết.
- ĐỊA ĐIỂM: Vườn tây / bờ hồ A1. EVENT REF: EV-A1-EXP-005, EV-A1-WRD-001 (tùy context).
- ĐIỀU KIỆN: thân thiết đề xuất 50; Q1.status in [completed,resolved_without_player]; npc.nonquest_meetups_after_Q1>=1; npc.available_context_Q2; player_chooses_accept. Giữ khoảng gặp thường, chủ động nhận.

**VLA15-Q2-V2-S1:** Quan sát một điểm vườn và ghi dữ kiện thật.

PROOF: `garden_snapshot_verified` (TO_BIND). Kết quả: Có bản ghi đầu.

**VLA15-Q2-V2-S2:** Chọn quay lại vườn ở thời điểm khác hoặc đi hồ qua tuyến an toàn.

PROOF: `second_observation_verified` (TO_BIND). Kết quả: Ghi vị trí và môi trường thực.

**VLA15-Q2-V2-S3:** So sánh hai bản ghi với Evelyn; tách sự kiện nhìn thấy khỏi suy đoán.

PROOF: `observation_comparison_verified` (TO_BIND). Kết quả: Có kết luận đúng dữ kiện.

**Nhánh gameplay (chỉ ghi nhánh có bằng chứng):**
- Hai lần quan sát vườn — `garden_second_snapshot_verified`: Không có lời kể về hồ.
- Quan sát thêm bờ hồ — `lake_snapshot_verified`: Có ghi chép bờ hồ thật.

**Không tham gia:** Evelyn tự ghi vườn; không mặc định bà đã tới hồ.

**Thất bại/hoãn:** Nếu thời điểm thay đổi không phù hợp, chọn dịp khác; không cần bơi/lặn.

**Hoàn thành:** đã nhận, đủ 3 proof, có proof nhánh đúng và kết quả xác nhận; hoàn thành lượt không đồng nghĩa thắng. **Thoại:** `DLG-VLA15-Q2-V2` trong ngân hàng riêng.

### VLA15-QF — Cuộc thi nhận ra điều đã đổi

- TÌNH HUỐNG: Evelyn chuẩn bị trò quan sát ba chi tiết khác nhau giữa hai mẫu cảnh đã ghi, để người mới học bằng cách kiểm chứng thay vì học thuộc lời bà.
- ĐỊA ĐIỂM: Vườn tây / sân chung. EVENT REF: EV-A1-FES-002 (tùy context).
- ĐIỀU KIỆN: thân thiết đề xuất 80; Q2.status in [completed,resolved_without_player]; npc.nonquest_meetups_after_Q2>=2; npc.personal_bond_event_seen==true; npc.available_context_QF; player_chooses_accept. Giữ khoảng gặp thường, chủ động nhận.

**VLA15-QF-V2-S1:** Chọn ba chi tiết có dữ kiện thật từ sổ/mẫu đã duyệt.

PROOF: `observation_puzzle_prepared` (TO_BIND). Kết quả: Đáp án được xác minh.

**VLA15-QF-V2-S2:** Thực hiện lượt thử; nếu có người khác tự nguyện thì dùng lượt độc lập, không ép xuất hiện.

PROOF: `observation_puzzle_attempt_verified` (TO_BIND). Kết quả: Ghi đáp án thật.

**VLA15-QF-V2-S3:** Xem đáp án, chỉnh gợi ý khó hiểu và lưu bản ngắn dùng lại.

PROOF: `observation_puzzle_review_verified` (TO_BIND). Kết quả: Trò thử có phiên bản cuối.

**Nhánh gameplay (chỉ ghi nhánh có bằng chứng):**
- Gợi ý ngắn — `short_clues_tested`: Dễ vào chơi, giữ khó ở quan sát.
- Gợi ý nhiều bước — `layered_clues_tested`: Cho người thích suy luận sâu.

**Không tham gia:** Evelyn tự làm bản thử và kiểm đáp án.

**Thất bại/hoãn:** Đáp án sai là phần trò chơi, không tự sửa điểm.

**Hoàn thành:** đã nhận, đủ 3 proof, có proof nhánh đúng và kết quả xác nhận; hoàn thành lượt không đồng nghĩa thắng. **Thoại:** `DLG-VLA15-QF-V2` trong ngân hàng riêng.

## Ada — Thi đường, vận chuyển thử và hành trình về nơi quen.

### VLA18-Q1 — Đường tắt của Ada

- TÌNH HUỐNG: Ada và Hugo bất đồng tuyến nào thuận hơn. Họ muốn thử hai đường đã kiểm, không bịa đường mới.
- ĐỊA ĐIỂM: Rừng gần làng và cầu. EVENT REF: EV-A1-EXP-004 (tùy context).
- ĐIỀU KIỆN: thân thiết đề xuất 20; npc.met; npc.shared_activity_completed_at_least_once; npc.return_visit_count>=1; npc_available; player_chooses_listen_or_offer. Giữ khoảng gặp thường, chủ động nhận.

**VLA18-Q1-V2-S1:** Chọn tuyến và nhận hai mốc bắt buộc.

PROOF: `route_choice_verified` (TO_BIND). Kết quả: Tuyến được khóa cho lượt.

**VLA18-Q1-V2-S2:** Đi qua mốc và quay về điểm xuất phát, không teleport.

PROOF: `route_markers_verified` (TO_BIND). Kết quả: Ghi số mốc thực.

**VLA18-Q1-V2-S3:** So thời gian/độ thuận nếu hệ đo có; nếu không, so số mốc và đường về.

PROOF: `route_trial_result_verified` (TO_BIND). Kết quả: Có kết quả thực tế.

**Nhánh gameplay (chỉ ghi nhánh có bằng chứng):**
- Thử tuyến ngắn đã kiểm — `short_route_verified`: Ghi kết quả tuyến ngắn.
- Thử tuyến dễ nhận mốc — `steady_route_verified`: Ghi kết quả tuyến ổn định.

**Không tham gia:** Ada và Hugo tự thử tuyến, không ghi A tham dự.

**Thất bại/hoãn:** Đi sai hoặc thiếu mốc có thể quay về và thử lại.

**Hoàn thành:** đã nhận, đủ 3 proof, có proof nhánh đúng và kết quả xác nhận; hoàn thành lượt không đồng nghĩa thắng. **Thoại:** `DLG-VLA18-Q1-V2` trong ngân hàng riêng.

### VLA18-Q2 — Kiện hàng qua ba trạm

- TÌNH HUỐNG: Ada và Hugo thử một chuyến hàng mẫu nội vùng trước khi tính đường xa. Tải mẫu có ràng buộc, không có làng đích ngoài A1.
- ĐỊA ĐIỂM: Sân chuẩn bị, sân chung, tuyến bộ nội vùng. EVENT REF: EV-A1-DRM-001 (tùy context).
- ĐIỀU KIỆN: thân thiết đề xuất 50; Q1.status in [completed,resolved_without_player]; npc.nonquest_meetups_after_Q1>=1; npc.available_context_Q2; player_chooses_accept. Giữ khoảng gặp thường, chủ động nhận.

**VLA18-Q2-V2-S1:** Kiểm tải và chọn cách bố trí được Hugo xác nhận.

PROOF: `trial_load_verified` (TO_BIND). Kết quả: Tải đủ điều kiện đi.

**VLA18-Q2-V2-S2:** Mang/đẩy tải mẫu qua ba điểm giao nhận nội vùng đã kiểm.

PROOF: `trial_checkpoints_verified` (TO_BIND). Kết quả: Ghi mốc và tình trạng tải.

**VLA18-Q2-V2-S3:** Kiểm tải ở trạm cuối, ghi nguyên vẹn hoặc lỗi.

PROOF: `trial_delivery_result_verified` (TO_BIND). Kết quả: Không có đơn hàng thật ngoài vùng.

**Nhánh gameplay (chỉ ghi nhánh có bằng chứng):**
- Ưu tiên nguyên vẹn — `intact_trial_verified`: Ghi tải nguyên vẹn.
- Tải xô lệch, kết thúc thử hoặc thử lại — `damaged_trial_verified`: Ghi lỗi, không tự giao thành công.

**Không tham gia:** Ada và Hugo tự thử hoặc hoãn nếu chưa có xe/đường.

**Thất bại/hoãn:** Tải không đạt thì thử lại, không mất hàng thật.

**Hoàn thành:** đã nhận, đủ 3 proof, có proof nhánh đúng và kết quả xác nhận; hoàn thành lượt không đồng nghĩa thắng. **Thoại:** `DLG-VLA18-Q2-V2` trong ngân hàng riêng.

### VLA18-QF — Chuyến đi không có người dẫn

- TÌNH HUỐNG: Ada muốn thử để A tự dẫn một hành trình nội vùng, chọn tuyến đã khám phá và quay về bằng trí nhớ. Hồ là lựa chọn, không bắt buộc.
- ĐỊA ĐIỂM: Làng A – rừng – bờ hồ. EVENT REF: EV-A1-EXP-001, EV-A1-EXP-005 (tùy context).
- ĐIỀU KIỆN: thân thiết đề xuất 80; Q2.status in [completed,resolved_without_player]; npc.nonquest_meetups_after_Q2>=2; npc.personal_bond_event_seen==true; npc.available_context_QF; player_chooses_accept. Giữ khoảng gặp thường, chủ động nhận.

**VLA18-QF-V2-S1:** Chọn tuyến rừng hoặc hồ đã khám phá, ghi điểm về.

PROOF: `independent_route_selected` (TO_BIND). Kết quả: Không chọn địa điểm chưa mở.

**VLA18-QF-V2-S2:** Đi qua các điểm mốc và kiểm đường quay lại, Ada chỉ đi cùng nếu lịch/pathing phù hợp.

PROOF: `independent_route_verified` (TO_BIND). Kết quả: Ghi đường đã đi; không tự cho Ada đồng hành.

**VLA18-QF-V2-S3:** Trở về, đặt chỉ dẫn ngắn từ tuyến thực đã đi.

PROOF: `return_guide_verified` (TO_BIND). Kết quả: Hướng dẫn phản ánh đúng địa điểm.

**Nhánh gameplay (chỉ ghi nhánh có bằng chứng):**
- Tuyến rừng — `forest_route_verified`: Không phát câu đã đi hồ.
- Tuyến bờ hồ đã khám phá — `lake_route_verified`: Thêm chỉ dẫn ven hồ.

**Không tham gia:** Ada tự viết chỉ dẫn tuyến quen; không chặn người chơi đi hồ.

**Thất bại/hoãn:** Không về đúng mốc thì hoãn báo cáo; không mất quyền khám phá.

**Hoàn thành:** đã nhận, đủ 3 proof, có proof nhánh đúng và kết quả xác nhận; hoàn thành lượt không đồng nghĩa thắng. **Thoại:** `DLG-VLA18-QF-V2` trong ngân hàng riêng.

## Grace — Tổ chức cộng đồng, xử lý biến cố, lễ hội và tự lựa chọn tham gia.

### VLA23-Q1 — Bữa ăn chạy mưa

- TÌNH HUỐNG: Một bữa ngoài trời cần chuyển chỗ khi mưa; nếu weather chưa bind, tổ chức buổi thử chuyển đồ đã duyệt, không giả mưa.
- ĐỊA ĐIỂM: Sân chung. EVENT REF: EV-A1-DRM-004 (tùy context).
- ĐIỀU KIỆN: thân thiết đề xuất 20; npc.met; npc.shared_activity_completed_at_least_once; npc.return_visit_count>=1; npc_available; player_chooses_listen_or_offer. Giữ khoảng gặp thường, chủ động nhận.

**VLA23-Q1-V2-S1:** Xác nhận bữa đang diễn ra và nơi trú thực sự có chỗ.

PROOF: `meal_relocation_context_verified` (TO_BIND). Kết quả: Mode thật hoặc thử được lưu.

**VLA23-Q1-V2-S2:** Chọn chuyển khay nhẹ hoặc báo nhóm ở vị trí gần; Grace quyết định giảm quy mô nếu thiếu chỗ.

PROOF: `meal_relocation_action_verified` (TO_BIND). Kết quả: Ghi đúng đóng góp.

**VLA23-Q1-V2-S3:** Kiểm đồ đã an toàn và bữa có tiếp tục hay hoãn.

PROOF: `meal_relocation_outcome_verified` (TO_BIND). Kết quả: Lưu kết quả thật.

**Nhánh gameplay (chỉ ghi nhánh có bằng chứng):**
- Chuyển sang nơi phù hợp — `meal_continued_verified`: Bữa tiếp tục.
- Hoãn vì thiếu chỗ — `meal_postponed_verified`: Không giả bữa đã ăn.

**Không tham gia:** Grace và cư dân tự chuyển/hoãn.

**Thất bại/hoãn:** Không kịp không biến thành mất thực phẩm nếu chưa mô phỏng.

**Hoàn thành:** đã nhận, đủ 3 proof, có proof nhánh đúng và kết quả xác nhận; hoàn thành lượt không đồng nghĩa thắng. **Thoại:** `DLG-VLA23-Q1-V2` trong ngân hàng riêng.

### VLA23-Q2 — Đội nào chuẩn bị nhanh hơn?

- TÌNH HUỐNG: Grace tổ chức thử thách hai nhóm bày bữa mẫu trong thời gian quy định, chấm đủ đồ và lối đi hơn tốc độ. Không có thi dùng bếp nóng.
- ĐỊA ĐIỂM: Sân chung. EVENT REF: EV-A1-FES-003 (tùy context).
- ĐIỀU KIỆN: thân thiết đề xuất 50; Q1.status in [completed,resolved_without_player]; npc.nonquest_meetups_after_Q1>=1; npc.available_context_Q2; player_chooses_accept. Giữ khoảng gặp thường, chủ động nhận.

**VLA23-Q2-V2-S1:** Chọn nhiệm vụ trong nhóm hoặc lượt thử một mình, xem tiêu chí công bố.

PROOF: `meal_team_role_selected` (TO_BIND). Kết quả: Khóa vai và tiêu chí.

**VLA23-Q2-V2-S2:** Thực hiện đặt đồ nhẹ đúng vị trí, kiểm lối trống.

PROOF: `meal_layout_attempt_verified` (TO_BIND). Kết quả: Ghi đồ đúng/sai.

**VLA23-Q2-V2-S3:** Nhận điểm theo tiêu chí, không ép NPC khác tham gia nếu vắng.

PROOF: `meal_layout_result_verified` (TO_BIND). Kết quả: Có điểm và kết quả thật.

**Nhánh gameplay (chỉ ghi nhánh có bằng chứng):**
- Ưu tiên đúng chỗ — `accurate_layout_verified`: Điểm theo độ đúng.
- Thử nhanh trong giới hạn an toàn — `timed_layout_verified`: Điểm tốc độ chỉ khi đủ điều kiện.

**Không tham gia:** Grace tự tổ chức với người tự nguyện hoặc buổi thử nhỏ.

**Thất bại/hoãn:** Điểm thấp vẫn hoàn thành lượt thi.

**Hoàn thành:** đã nhận, đủ 3 proof, có proof nhánh đúng và kết quả xác nhận; hoàn thành lượt không đồng nghĩa thắng. **Thoại:** `DLG-VLA23-Q2-V2` trong ngân hàng riêng.

### VLA23-QF — Đêm hội không cần một người lo hết

- TÌNH HUỐNG: Grace muốn tham dự một buổi hội với vai khách, không chỉ làm hậu cần. Người chơi có thể góp một khâu và sau đó tự chọn chơi. Hội do event độc lập vận hành; nếu chưa tới lịch, làm buổi gặp nhỏ không tính dự hội.
- ĐỊA ĐIỂM: Sân chung hoặc bờ hồ đã duyệt. EVENT REF: EV-A1-FES-001, EV-A1-DRM-002, EV-A1-WRD-003 (tùy context).
- ĐIỀU KIỆN: thân thiết đề xuất 80; Q2.status in [completed,resolved_without_player]; npc.nonquest_meetups_after_Q2>=2; npc.personal_bond_event_seen==true; npc.available_context_QF; player_chooses_accept. Giữ khoảng gặp thường, chủ động nhận.

**VLA23-QF-V2-S1:** Xác nhận mode lễ hội đang mở hoặc buổi sinh hoạt nhỏ; chọn khâu tự nguyện phù hợp.

PROOF: `community_context_verified` (TO_BIND). Kết quả: Không tự mở lễ hội.

**VLA23-QF-V2-S2:** Thực hiện một việc thật để bàn giao phần chuẩn bị; Grace tự xác nhận phần mình đã xong.

PROOF: `community_contribution_verified` (TO_BIND). Kết quả: A và Grace không bị ép ở hậu cần.

**VLA23-QF-V2-S3:** Chọn tham gia một hoạt động đang mở hoặc rời đi; ghi Grace tự tham dự nếu có.

PROOF: `community_free_choice_verified` (TO_BIND). Kết quả: Ghi lựa chọn A và Grace riêng.

**Nhánh gameplay (chỉ ghi nhánh có bằng chứng):**
- Ở lại chơi/ngồi cùng — `shared_activity_verified`: Chỉ nhớ trải nghiệm chung đã xảy ra.
- Giúp xong rồi đi — `contribution_only_verified`: Chỉ nhớ đã góp công, không nhớ dự hội.

**Không tham gia:** Grace và cư dân tự chia việc; Grace có thể tham gia nếu lịch phù hợp.

**Thất bại/hoãn:** Nếu hội hoãn, giữ việc đã làm và quay lại dịp khác hoặc kết thúc buổi nhỏ.

**Hoàn thành:** đã nhận, đủ 3 proof, có proof nhánh đúng và kết quả xác nhận; hoàn thành lượt không đồng nghĩa thắng. **Thoại:** `DLG-VLA23-QF-V2` trong ngân hàng riêng.

[JSON nhiệm vụ](VILLAGE_A_QUEST_SCRIPTS_V2.json) · [Thoại nhiệm vụ riêng](../dialogue/VILLAGE_A_QUEST_DIALOGUE_V2.md). Mọi tên mới và tình tiết vẫn chờ duyệt; không sửa nguồn cũ.
