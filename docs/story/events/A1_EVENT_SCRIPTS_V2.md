# A1 — Kịch bản sự kiện V2 (EVENT ONLY)

**DRAFT_STORY — phiên bản viết lại 24 sự kiện V1.** Không có lời thoại, menu hội thoại, văn dẫn hay câu nói NPC trong file. Đây là nguồn điều phối diễn biến; người chơi có thể gặp sự kiện mà không nói chuyện với ai. Lời thoại riêng ở `../dialogue/A1_EVENT_DIALOGUE_V2.md`. NPC chưa có lịch thực tế và event signals đều TO_BIND. Không sửa canon/Thomas, không mở Làng B. Hồ đã duyệt; các tình tiết mới chưa duyệt.

**Nguyên tắc:** mỗi event có trigger, tình huống, việc người chơi làm, bằng chứng, nhánh không tham gia, hậu quả. Lễ hội có kết quả thắng/thua; săn có khả năng thất bại; không biến việc xem event thành quest. Các mốc thời gian/đạo cụ/cơ chế chưa xác nhận là yêu cầu bàn giao, không phải hiện trạng engine.

## EV-A1-FES-001 — Đêm đèn trên mặt hồ

- CATEGORY: WORLD; LOCATION: bờ hồ / sân chung; STATUS: DRAFT_STORY.
- TRIGGER: `scheduled_festival_start` (TO_BIND); GUARDS: nội dung duyệt, vị trí/cơ chế đủ, không tranh NPC/đạo cụ.
- WORLD SETUP: Lễ hội mở theo lịch, đèn xuất hiện dọc lối xuống hồ; ba đội tự chuẩn bị trạm thi. Trời đổi gió giữa lúc khai hội.
- PLAYABLE ACTION: Đua tìm ba biểu tượng trên các trạm theo gợi ý; mỗi trạm có một biểu tượng giả. Đăng ký hoặc chỉ đi xem. Đội chơi phải tự về trạm chấm kết quả.
- PROOF: `festival_registration`, `checkpoint_verified`, `festival_result_verified`. Chỉ ghi nhánh tương ứng với thao tác thực; không đòi tất cả event ở mọi nhánh.
- BRANCHES: Chọn đường ngắn khó quan sát hoặc đường dài dễ nhớ; nếu gió mạnh, chuyển sang tuyến sân làng hoặc bỏ phần thi ngoài trời.
- ABSENT/LATE: Đội NPC vẫn thi; nếu chuyển nơi, kết quả chỉ tính các trạm hợp lệ ở nơi mới.
- PERSISTENT EFFECT: Lưu kết quả thật, nơi diễn ra, người tham gia; sáng sau bảng kết quả và đèn được tháo dần.
- LINKED EVENTS (không tự chain): EV-A1-DRM-002, EV-A1-WRD-003.
- DIALOGUE: tra ngân hàng riêng theo event ID, trạng thái, người có mặt; không chặn diễn biến nếu A không nói.

## EV-A1-FES-002 — Hội tìm dấu rừng

- CATEGORY: WORLD; LOCATION: lối rừng và nhánh gần cầu; STATUS: DRAFT_STORY.
- TRIGGER: `scheduled_tracking_contest` (TO_BIND); GUARDS: nội dung duyệt, vị trí/cơ chế đủ, không tranh NPC/đạo cụ.
- WORLD SETUP: Hai đội xuất phát từ mép rừng; các dấu dẫn tới những điểm quan sát khác nhau. Một dấu cũ đánh lạc hướng.
- PLAYABLE ACTION: Phân biệt dấu mới/cũ, kiểm ba điểm quan sát, trở về báo kết quả. Đi theo nhánh khác đội NPC; không tự sinh thú để đảm bảo thắng.
- PROOF: `contest_joined`, `track_evidence_verified`, `contest_returned`. Chỉ ghi nhánh tương ứng với thao tác thực; không đòi tất cả event ở mọi nhánh.
- BRANCHES: Đua lấy kết quả hoặc đi chậm xác minh; chọn dừng nếu thú bị quấy rối.
- ABSENT/LATE: NPC có kết quả riêng; bỏ cuộc vẫn được rời rừng.
- PERSISTENT EFFECT: Lưu số dấu đúng, thứ hạng đã xác nhận và tuyến đã khám phá.
- LINKED EVENTS (không tự chain): EV-A1-WLD-001, EV-A1-WLD-002.
- DIALOGUE: tra ngân hàng riêng theo event ID, trạng thái, người có mặt; không chặn diễn biến nếu A không nói.

## EV-A1-FES-003 — Hội bếp và chợ chiều

- CATEGORY: WORLD; LOCATION: sân chung; STATUS: DRAFT_STORY.
- TRIGGER: `market_day_started` (TO_BIND); GUARDS: nội dung duyệt, vị trí/cơ chế đủ, không tranh NPC/đạo cụ.
- WORLD SETUP: Các gian hàng mở; một món dự thi bị chuyển nhầm sang gian khác ngay trước khi chấm.
- PLAYABLE ACTION: Chơi thử đoán nguyên liệu qua các lựa chọn, tham gia chấm món theo luật công bố; nếu muốn, tìm món thất lạc bằng cách kiểm các gian.
- PROOF: `tasting_answer_selected`, `entry_location_verified`, `judging_finished`. Chỉ ghi nhánh tương ứng với thao tác thực; không đòi tất cả event ở mọi nhánh.
- BRANCHES: Thi hoặc làm khán giả; báo nhầm lẫn kín đáo hoặc hỏi công khai khiến gian hàng bị gián đoạn.
- ABSENT/LATE: Chợ vẫn mở; ban tổ chức tự tìm món hoặc chấm những gian còn đủ.
- PERSISTENT EFFECT: Kết quả thi, gian đổi vị trí, ký ức ai thực sự tìm món.
- LINKED EVENTS (không tự chain): EV-A1-SOC-003.
- DIALOGUE: tra ngân hàng riêng theo event ID, trạng thái, người có mặt; không chặn diễn biến nếu A không nói.

## EV-A1-FES-004 — Đêm lửa đầu mùa lạnh

- CATEGORY: WORLD; LOCATION: sân chung đã kiểm vị trí; STATUS: DRAFT_STORY.
- TRIGGER: `seasonal_gathering_started` (TO_BIND); GUARDS: nội dung duyệt, vị trí/cơ chế đủ, không tranh NPC/đạo cụ.
- WORLD SETUP: Nhóm cư dân tụ tập; mỗi lượt một người chọn âm thanh hoặc đồ vật để kể một chuyện ngắn. Một người tự rời vòng ngồi.
- PLAYABLE ACTION: Thi nhận diện âm thanh; chọn ở lại nghe, tìm người rời đi nếu đã quen, hoặc về nhà. Không ép đọc lời tâm sự.
- PROOF: `sound_guess_submitted`, `gathering_attended`, `optional_visit_verified`. Chỉ ghi nhánh tương ứng với thao tác thực; không đòi tất cả event ở mọi nhánh.
- BRANCHES: Tham gia chơi hoặc chỉ ngồi nghe; hỏi thăm riêng hay tôn trọng khoảng cách.
- ABSENT/LATE: Cuộc tụ họp kết thúc bình thường; người rời đi không bị giữ lại.
- PERSISTENT EFFECT: Lưu trò đã chơi, cuộc gặp riêng nếu có; không tự tiết lộ quá khứ A.
- LINKED EVENTS (không tự chain): EV-A1-SOC-002.
- DIALOGUE: tra ngân hàng riêng theo event ID, trạng thái, người có mặt; không chặn diễn biến nếu A không nói.

## EV-A1-WLD-001 — Đàn thú cắt ngang đường

- CATEGORY: DYNAMIC; LOCATION: rừng giữa nhà A và làng; STATUS: DRAFT_STORY.
- TRIGGER: `wildlife_crossing_verified` (TO_BIND); GUARDS: nội dung duyệt, vị trí/cơ chế đủ, không tranh NPC/đạo cụ.
- WORLD SETUP: Đàn thú xuất hiện ở rìa lối, di chuyển qua tán cây; đường cỏ thay đổi và dấu chân mới dần mất.
- PLAYABLE ACTION: Quan sát hướng đi; tự theo dấu qua hai đoạn địa hình đã mở; có thể chọn điểm nhìn để thấy đàn từ xa.
- PROOF: `wildlife_seen`, `trail_evidence_verified`, `observation_point_reached`. Chỉ ghi nhánh tương ứng với thao tác thực; không đòi tất cả event ở mọi nhánh.
- BRANCHES: Theo đàn, đi vòng, hoặc trở về; không bắt buộc săn.
- ABSENT/LATE: Đàn tự rời vùng; dấu còn một thời gian rồi mất.
- PERSISTENT EFFECT: Lưu phát hiện và thời điểm; không tự ghi đã săn.
- LINKED EVENTS (không tự chain): EV-A1-WLD-002.
- DIALOGUE: tra ngân hàng riêng theo event ID, trạng thái, người có mặt; không chặn diễn biến nếu A không nói.

## EV-A1-WLD-002 — Mất dấu trên nền đá

- CATEGORY: EXPLORATION; LOCATION: rừng gần hồ; STATUS: DRAFT_STORY.
- TRIGGER: `tracking_trail_split` (TO_BIND); GUARDS: nội dung duyệt, vị trí/cơ chế đủ, không tranh NPC/đạo cụ.
- WORLD SETUP: Dấu chân biến mất ở nền đá; hai hướng có tiếng động và vệt cỏ khác nhau, một hướng là dấu cũ.
- PLAYABLE ACTION: So sánh dấu ở hai nhánh, chọn điểm kiểm tiếp theo; chỉ tính tìm lại khi game xác nhận dấu đúng.
- PROOF: `clue_inspected`, `route_selected`, `animal_relocated`. Chỉ ghi nhánh tương ứng với thao tác thực; không đòi tất cả event ở mọi nhánh.
- BRANCHES: Tiếp tục hoặc dừng; chọn sai mất cơ hội ở lượt này, không mất quyền khám phá.
- ABSENT/LATE: Thú rời đi theo mô phỏng; không teleport vào tầm nhìn của A.
- PERSISTENT EFFECT: Lưu dấu đúng/sai và phát hiện; có thể tạo cơ hội săn riêng nếu đủ điều kiện.
- LINKED EVENTS (không tự chain): EV-A1-WLD-005.
- DIALOGUE: tra ngân hàng riêng theo event ID, trạng thái, người có mặt; không chặn diễn biến nếu A không nói.

## EV-A1-WLD-003 — Cái bẫy bỏ quên

- CATEGORY: DYNAMIC; LOCATION: rìa rừng xa làng; STATUS: DRAFT_STORY.
- TRIGGER: `abandoned_trap_discovered` (TO_BIND); GUARDS: nội dung duyệt, vị trí/cơ chế đủ, không tranh NPC/đạo cụ.
- WORLD SETUP: Thiết bị cũ ở mép đường có dấu động vật, một khu vực phải tránh; chưa xác định người đặt.
- PLAYABLE ACTION: Đánh dấu nơi phát hiện, báo người lớn phù hợp nếu muốn; hỗ trợ xử lý chỉ khi hệ tương tác an toàn được duyệt.
- PROOF: `hazard_marked`, `adult_notified`, `hazard_removed_verified`. Chỉ ghi nhánh tương ứng với thao tác thực; không đòi tất cả event ở mọi nhánh.
- BRANCHES: Chỉ báo, tham gia xử lý, hoặc rời đi.
- ABSENT/LATE: Người có trách nhiệm tự phát hiện và xử lý; không giữ thú mắc kẹt vô hạn.
- PERSISTENT EFFECT: Khu vực hết cảnh báo sau khi xử lý thật; không đổ lỗi vô căn cứ.
- LINKED EVENTS (không tự chain): NONE.
- DIALOGUE: tra ngân hàng riêng theo event ID, trạng thái, người có mặt; không chặn diễn biến nếu A không nói.

## EV-A1-WLD-004 — Đêm có khách ngoài vườn

- CATEGORY: DYNAMIC; LOCATION: vườn tây; STATUS: DRAFT_STORY.
- TRIGGER: `crop_disturbance_detected` (TO_BIND); GUARDS: nội dung duyệt, vị trí/cơ chế đủ, không tranh NPC/đạo cụ.
- WORLD SETUP: Dấu luống bị xáo trộn, một con thú đi qua rìa vườn lúc vắng người; Hazel và những người lớn theo dõi.
- PLAYABLE ACTION: Kiểm nơi bị ảnh hưởng, tham gia giữ đồ dùng/che luống hoặc quan sát từ nơi an toàn; không săn trong làng.
- PROOF: `crop_damage_checked`, `protection_applied_verified`. Chỉ ghi nhánh tương ứng với thao tác thực; không đòi tất cả event ở mọi nhánh.
- BRANCHES: Giúp bảo vệ phần luống đang có nguy cơ hoặc không tham gia.
- ABSENT/LATE: NPC tự xử lý; có thể mất một phần vụ nếu hệ cây trồng hỗ trợ.
- PERSISTENT EFFECT: Lưu mức ảnh hưởng và biện pháp đã thực hiện.
- LINKED EVENTS (không tự chain): NONE.
- DIALOGUE: tra ngân hàng riêng theo event ID, trạng thái, người có mặt; không chặn diễn biến nếu A không nói.

## EV-A1-WLD-005 — Cuộc săn không chắc thành công

- CATEGORY: DYNAMIC; LOCATION: vùng săn TO_BIND; STATUS: DRAFT_STORY.
- TRIGGER: `eligible_wildlife_hunt_opportunity` (TO_BIND); GUARDS: nội dung duyệt, vị trí/cơ chế đủ, không tranh NPC/đạo cụ.
- WORLD SETUP: Một cơ hội xuất hiện khi thú hợp lệ có mặt ở vùng được phép; thú có thể rời vùng trước khi A hoàn tất.
- PLAYABLE ACTION: Chọn quan sát hoặc chủ động tham gia cơ chế săn trong game; kết quả do hệ săn xác nhận, không do hội thoại.
- PROOF: `hunt_attempted`, `hunt_result_verified`. Chỉ ghi nhánh tương ứng với thao tác thực; không đòi tất cả event ở mọi nhánh.
- BRANCHES: Săn thành công, thất bại/thú thoát, chủ động bỏ; không tự cấp loot.
- ABSENT/LATE: Thú tiếp tục di chuyển; cơ hội hết hạn.
- PERSISTENT EFFECT: Lưu outcome và tác động quần thể nếu được duyệt. Không ghi thành công giả.
- LINKED EVENTS (không tự chain): NONE.
- DIALOGUE: tra ngân hàng riêng theo event ID, trạng thái, người có mặt; không chặn diễn biến nếu A không nói.

## EV-A1-EXP-001 — Lối đi hiện ra sau mưa

- CATEGORY: EXPLORATION; LOCATION: nhánh lối rừng đã mở; STATUS: DRAFT_STORY.
- TRIGGER: `wet_path_trace_visible` (TO_BIND); GUARDS: nội dung duyệt, vị trí/cơ chế đủ, không tranh NPC/đạo cụ.
- WORLD SETUP: Một vệt đi cũ hiện rõ trên đất ẩm, dẫn tới góc nhìn khu rừng khác lối chính.
- PLAYABLE ACTION: Tìm hai dấu mốc và tự đi về qua nhánh đã kiểm; không sinh đường mới.
- PROOF: `trace_seen`, `landmark_verified`, `return_path_verified`. Chỉ ghi nhánh tương ứng với thao tác thực; không đòi tất cả event ở mọi nhánh.
- BRANCHES: Đi tiếp, đánh dấu để quay lại hoặc bỏ qua.
- ABSENT/LATE: Vệt mờ đi; nhánh đường vẫn tồn tại.
- PERSISTENT EFFECT: Lưu khám phá tuyến nếu thật sự đi qua.
- LINKED EVENTS (không tự chain): NONE.
- DIALOGUE: tra ngân hàng riêng theo event ID, trạng thái, người có mặt; không chặn diễn biến nếu A không nói.

## EV-A1-EXP-002 — Vật sáng dưới bờ đá

- CATEGORY: EXPLORATION; LOCATION: bờ đá hồ; STATUS: DRAFT_STORY.
- TRIGGER: `shore_object_visible` (TO_BIND); GUARDS: nội dung duyệt, vị trí/cơ chế đủ, không tranh NPC/đạo cụ.
- WORLD SETUP: Ánh sáng đổi theo góc nhìn, một vật trôi dạt mắc ở vùng bờ có thể tiếp cận; vật cụ thể TO_DECIDE.
- PLAYABLE ACTION: Đổi góc nhìn để xác định vật; nhặt nếu tiếp cận an toàn và hệ vật phẩm hỗ trợ; hỏi chủ đồ nếu có căn cứ.
- PROOF: `object_identified`, `pickup_verified`, `ownership_verified`. Chỉ ghi nhánh tương ứng với thao tác thực; không đòi tất cả event ở mọi nhánh.
- BRANCHES: Nhặt/giữ lại để tìm chủ, chỉ ghi nhận hoặc rời đi.
- ABSENT/LATE: NPC có thể thu nhặt, hoặc vật đổi vị trí theo mô phỏng đã chốt.
- PERSISTENT EFFECT: Lưu chủ sở hữu chỉ khi xác nhận; không tự mở bí mật giấc mơ.
- LINKED EVENTS (không tự chain): NONE.
- DIALOGUE: tra ngân hàng riêng theo event ID, trạng thái, người có mặt; không chặn diễn biến nếu A không nói.

## EV-A1-EXP-003 — Tiếng gọi sau màn sương

- CATEGORY: STORY; LOCATION: rừng – cầu – làng; STATUS: DRAFT_STORY.
- TRIGGER: `adult_missing_on_local_walk` (TO_BIND); GUARDS: nội dung duyệt, vị trí/cơ chế đủ, không tranh NPC/đạo cụ.
- WORLD SETUP: Một người lớn đi lạc trong sương; tại làng người khác bắt đầu tìm. Dấu ở lối rừng dẫn hai hướng khác nhau.
- PLAYABLE ACTION: Tìm dấu đã xác minh, tìm đúng khu người ấy đang chờ và dẫn về lối an toàn; có thể báo nhóm tìm kiếm thay vì đi một mình.
- PROOF: `search_clue_verified`, `adult_located`, `safe_return_verified`. Chỉ ghi nhánh tương ứng với thao tác thực; không đòi tất cả event ở mọi nhánh.
- BRANCHES: Tự tìm, báo người làng, bỏ qua; đi sai hướng không tự nhận công.
- ABSENT/LATE: Nhóm NPC tìm và đưa người về; không biến thành mất tích vĩnh viễn.
- PERSISTENT EFFECT: Lưu ai tìm thấy và ai hỗ trợ; nhân vật được tìm có ngày nghỉ sau đó.
- LINKED EVENTS (không tự chain): EV-A1-SOC-002.
- DIALOGUE: tra ngân hàng riêng theo event ID, trạng thái, người có mặt; không chặn diễn biến nếu A không nói.

## EV-A1-EXP-004 — Trước khi đèn tắt

- CATEGORY: EXPLORATION; LOCATION: lối rừng gần cầu; STATUS: DRAFT_STORY.
- TRIGGER: `route_challenge_open` (TO_BIND); GUARDS: nội dung duyệt, vị trí/cơ chế đủ, không tranh NPC/đạo cụ.
- WORLD SETUP: Các đội có cùng ba dấu mốc và giờ kết thúc lượt thi; lựa chọn đường đi khác nhau.
- PLAYABLE ACTION: Tìm ba mốc, xác minh từng mốc, quay về trạm; không dùng waypoint tự động tìm thay A.
- PROOF: `challenge_joined`, `marker_verified`, `finish_line_crossed`. Chỉ ghi nhánh tương ứng với thao tác thực; không đòi tất cả event ở mọi nhánh.
- BRANCHES: Chấp nhận thiếu mốc để quay về sớm hoặc cố tìm mốc cuối; có thể dừng.
- ABSENT/LATE: NPC tự hoàn thành thử thách; kết quả A không tham gia là not_entered.
- PERSISTENT EFFECT: Lưu mốc đúng và thời gian từ hệ thi nếu có.
- LINKED EVENTS (không tự chain): NONE.
- DIALOGUE: tra ngân hàng riêng theo event ID, trạng thái, người có mặt; không chặn diễn biến nếu A không nói.

## EV-A1-EXP-005 — Bình minh có đàn chim

- CATEGORY: EXPLORATION; LOCATION: bờ hồ; STATUS: DRAFT_STORY.
- TRIGGER: `dawn_wildlife_window` (TO_BIND); GUARDS: nội dung duyệt, vị trí/cơ chế đủ, không tranh NPC/đạo cụ.
- WORLD SETUP: Sương tan và chim xuất hiện ở nhiều vùng bờ; chuyển động có thể quan sát từ xa.
- PLAYABLE ACTION: Tự đến một trong các điểm nhìn, quan sát/chụp nếu cơ chế có; không cần NPC để khám phá.
- PROOF: `lake_viewpoint_reached`, `wildlife_observed`. Chỉ ghi nhánh tương ứng với thao tác thực; không đòi tất cả event ở mọi nhánh.
- BRANCHES: Đợi thêm, đổi điểm nhìn hoặc đi tiếp.
- ABSENT/LATE: Cảnh qua khi hết thời điểm; có thể lặp vào dịp phù hợp.
- PERSISTENT EFFECT: Lưu các điểm nhìn thật sự phát hiện.
- LINKED EVENTS (không tự chain): NONE.
- DIALOGUE: tra ngân hàng riêng theo event ID, trạng thái, người có mặt; không chặn diễn biến nếu A không nói.

## EV-A1-DRM-001 — Cầu gỗ sau trận mưa

- CATEGORY: DYNAMIC; LOCATION: cầu nối nhà A – làng; STATUS: DRAFT_STORY.
- TRIGGER: `bridge_damage_verified` (TO_BIND); GUARDS: nội dung duyệt, vị trí/cơ chế đủ, không tranh NPC/đạo cụ.
- WORLD SETUP: Một ván cầu hỏng; nhóm cư dân cảnh báo và tổ chức sửa. Lối an toàn phải luôn còn hoặc event không mở.
- PLAYABLE ACTION: Chọn đi lối an toàn đã kiểm, tham gia một khâu mang vật liệu nhẹ hoặc tìm người hỗ trợ; theo dõi tiến độ sửa.
- PROOF: `safe_route_verified`, `material_delivered`, `bridge_repaired_verified`. Chỉ ghi nhánh tương ứng với thao tác thực; không đòi tất cả event ở mọi nhánh.
- BRANCHES: Góp công, đi vòng nếu có, chờ NPC tự xử lý.
- ABSENT/LATE: Nhóm sửa hoàn thành qua tiến độ riêng; không khóa tuyến chính.
- PERSISTENT EFFECT: Cầu có dấu vá mới; ghi người đã góp công.
- LINKED EVENTS (không tự chain): EV-A1-WRD-002.
- DIALOGUE: tra ngân hàng riêng theo event ID, trạng thái, người có mặt; không chặn diễn biến nếu A không nói.

## EV-A1-DRM-002 — Gió nổi trước giờ khai hội

- CATEGORY: DYNAMIC; LOCATION: bờ hồ / sân chung; STATUS: DRAFT_STORY.
- TRIGGER: `festival_preparing_and_wind_unsafe` (TO_BIND); GUARDS: nội dung duyệt, vị trí/cơ chế đủ, không tranh NPC/đạo cụ.
- WORLD SETUP: Đồ trang trí bị gió làm xô lệch; ban tổ chức tạm dừng các hoạt động ven nước.
- PLAYABLE ACTION: Chuyển các vật nhẹ đến vùng an toàn, kiểm vị trí đã xác nhận; lựa chọn góp ý địa điểm thay thế.
- PROOF: `decor_moved_verified`, `safe_layout_verified`. Chỉ ghi nhánh tương ứng với thao tác thực; không đòi tất cả event ở mọi nhánh.
- BRANCHES: Chuyển sân làng, thu nhỏ ở bờ nếu an toàn, hoãn; NPC có quyền quyết định cuối.
- ABSENT/LATE: Ban tổ chức tự chọn phương án an toàn.
- PERSISTENT EFFECT: Cập nhật bố cục FES-001; không cho thi ở nơi đã hủy.
- LINKED EVENTS (không tự chain): EV-A1-FES-001.
- DIALOGUE: tra ngân hàng riêng theo event ID, trạng thái, người có mặt; không chặn diễn biến nếu A không nói.

## EV-A1-DRM-003 — Cây chắn lối phụ

- CATEGORY: DYNAMIC; LOCATION: nhánh rừng đã kiểm; STATUS: DRAFT_STORY.
- TRIGGER: `fallen_tree_detected` (TO_BIND); GUARDS: nội dung duyệt, vị trí/cơ chế đủ, không tranh NPC/đạo cụ.
- WORLD SETUP: Cây đổ chặn lối phụ; xuất hiện dấu thú đi vòng; trục chính vẫn thông.
- PLAYABLE ACTION: Kiểm đường vòng, báo người có tay nghề, hỗ trợ khâu đơn giản nếu có cơ chế; theo dấu thú nếu chọn khám phá.
- PROOF: `detour_verified`, `obstacle_reported`, `clearance_verified`. Chỉ ghi nhánh tương ứng với thao tác thực; không đòi tất cả event ở mọi nhánh.
- BRANCHES: Khám phá đường khác hoặc hỗ trợ; không bắt dùng công cụ nguy hiểm.
- ABSENT/LATE: NPC xử lý khi đủ điều kiện.
- PERSISTENT EFFECT: Lối phụ thông lại sau event thật; dấu thú có thể dẫn WLD-001.
- LINKED EVENTS (không tự chain): EV-A1-WLD-001.
- DIALOGUE: tra ngân hàng riêng theo event ID, trạng thái, người có mặt; không chặn diễn biến nếu A không nói.

## EV-A1-DRM-004 — Bữa ăn chạy mưa

- CATEGORY: DYNAMIC; LOCATION: sân chung; STATUS: DRAFT_STORY.
- TRIGGER: `outdoor_meal_and_rain` (TO_BIND); GUARDS: nội dung duyệt, vị trí/cơ chế đủ, không tranh NPC/đạo cụ.
- WORLD SETUP: Mưa làm một buổi ăn bị gián đoạn; cư dân tự gom đồ, chỗ trú được kiểm trước.
- PLAYABLE ACTION: Chuyển một khay nhẹ hoặc báo người ở xa sân; tìm chỗ trú hợp lệ.
- PROOF: `meal_item_moved`, `shelter_reached`. Chỉ ghi nhánh tương ứng với thao tác thực; không đòi tất cả event ở mọi nhánh.
- BRANCHES: Giúp, trú mưa hoặc về nhà; có thể hoãn bữa nếu thiếu chỗ.
- ABSENT/LATE: Cư dân tự chuyển hoặc hủy buổi ăn.
- PERSISTENT EFFECT: Lưu vị trí/kết quả buổi ăn và người giúp.
- LINKED EVENTS (không tự chain): NONE.
- DIALOGUE: tra ngân hàng riêng theo event ID, trạng thái, người có mặt; không chặn diễn biến nếu A không nói.

## EV-A1-SOC-001 — Hai cách giữ đường rừng

- CATEGORY: SOCIAL; LOCATION: lối rừng / sân chung; STATUS: DRAFT_STORY.
- TRIGGER: `rowan_silas_disagreement_active` (TO_BIND); GUARDS: nội dung duyệt, vị trí/cơ chế đủ, không tranh NPC/đạo cụ.
- WORLD SETUP: Rowan muốn giữ hoa; Silas lo người đi vấp. Họ tự tranh luận và khảo sát đường.
- PLAYABLE ACTION: Đi kiểm hai mép đường; đề xuất phương án dựa trên bằng chứng đã kiểm hoặc để hai người tự quyết.
- PROOF: `path_evidence_verified`, `suggestion_selected`, `agreement_verified`. Chỉ ghi nhánh tương ứng với thao tác thực; không đòi tất cả event ở mọi nhánh.
- BRANCHES: Dọn tối thiểu, bố trí lại mép đường nếu hợp lý hoặc không can thiệp.
- ABSENT/LATE: Hai NPC tự tìm giải pháp.
- PERSISTENT EFFECT: Lưu phương án được họ đồng ý; không gán hai phe thù địch.
- LINKED EVENTS (không tự chain): NONE.
- DIALOGUE: tra ngân hàng riêng theo event ID, trạng thái, người có mặt; không chặn diễn biến nếu A không nói.

## EV-A1-SOC-002 — Chiếc ghế trống ở lễ hội

- CATEGORY: SOCIAL; LOCATION: sân chung / lối làng; STATUS: DRAFT_STORY.
- TRIGGER: `expected_attendee_absent` (TO_BIND); GUARDS: nội dung duyệt, vị trí/cơ chế đủ, không tranh NPC/đạo cụ.
- WORLD SETUP: Một cư dân trưởng thành vắng mặt; bạn của họ nhận ra trước A. Người ấy có thể muốn ở một mình hoặc đi lạc tùy tình tiết đã chọn.
- PLAYABLE ACTION: Hỏi người quen, kiểm nơi thường ghé, tôn trọng yêu cầu ở riêng; chỉ chuyển tìm kiếm nếu có bằng chứng đi lạc.
- PROOF: `absence_reason_verified`, `checkin_completed`. Chỉ ghi nhánh tương ứng với thao tác thực; không đòi tất cả event ở mọi nhánh.
- BRANCHES: Hỏi thăm, báo nhóm tìm, dự hội tiếp; không ép quay lại.
- ABSENT/LATE: NPC khác hỏi thăm; nếu thật sự đi lạc mở EXP-003.
- PERSISTENT EFFECT: Lưu nguyên nhân thật và hành động của A; không suy diễn.
- LINKED EVENTS (không tự chain): EV-A1-EXP-003.
- DIALOGUE: tra ngân hàng riêng theo event ID, trạng thái, người có mặt; không chặn diễn biến nếu A không nói.

## EV-A1-SOC-003 — Gian thi thiếu món

- CATEGORY: SOCIAL; LOCATION: sân thủ công / sân chung; STATUS: DRAFT_STORY.
- TRIGGER: `contest_entry_missing` (TO_BIND); GUARDS: nội dung duyệt, vị trí/cơ chế đủ, không tranh NPC/đạo cụ.
- WORLD SETUP: Một sản phẩm bị chuyển nhầm; người học lo bị đổ lỗi, Maeve chưa biết chuyện thật.
- PLAYABLE ACTION: Đối chiếu vị trí gian và người đã dời đồ; tìm vật ở nơi có bằng chứng; báo đúng người.
- PROOF: `entry_clue_verified`, `entry_found`, `owner_notified`. Chỉ ghi nhánh tương ứng với thao tác thực; không đòi tất cả event ở mọi nhánh.
- BRANCHES: Báo riêng, hỏi công khai, không tham gia; không được kết tội khi thiếu bằng chứng.
- ABSENT/LATE: Món được tìm sau buổi chấm hoặc bị bỏ lượt thi.
- PERSISTENT EFFECT: Lưu kết quả cuộc thi và mức độ hiểu lầm đã giải quyết.
- LINKED EVENTS (không tự chain): EV-A1-FES-003.
- DIALOGUE: tra ngân hàng riêng theo event ID, trạng thái, người có mặt; không chặn diễn biến nếu A không nói.

## EV-A1-WRD-001 — Bờ hồ thay đổi

- CATEGORY: WORLD; LOCATION: bờ hồ; STATUS: DRAFT_STORY.
- TRIGGER: `shore_weather_state_changed` (TO_BIND); GUARDS: nội dung duyệt, vị trí/cơ chế đủ, không tranh NPC/đạo cụ.
- WORLD SETUP: Đất và dấu bờ thay đổi theo môi trường thực có; một điểm đứng cũ có thể không thích hợp.
- PLAYABLE ACTION: Tìm góc nhìn mới trên bờ được phép; ghi nhận cảnh quan thay đổi.
- PROOF: `shore_observation_verified`. Chỉ ghi nhánh tương ứng với thao tác thực; không đòi tất cả event ở mọi nhánh.
- BRANCHES: Quan sát, quay lại sau, không làm gì.
- ABSENT/LATE: Bờ thay đổi độc lập với A.
- PERSISTENT EFFECT: Lưu snapshot khám phá; không sửa mực nước nếu engine chưa hỗ trợ.
- LINKED EVENTS (không tự chain): NONE.
- DIALOGUE: tra ngân hàng riêng theo event ID, trạng thái, người có mặt; không chặn diễn biến nếu A không nói.

## EV-A1-WRD-002 — Dấu sửa trên con đường

- CATEGORY: WORLD; LOCATION: cầu hoặc lối phụ; STATUS: DRAFT_STORY.
- TRIGGER: `community_repair_progress_changed` (TO_BIND); GUARDS: nội dung duyệt, vị trí/cơ chế đủ, không tranh NPC/đạo cụ.
- WORLD SETUP: Các nhóm tự chia việc theo tiến độ; đoạn đường thay đổi qua nhiều lần A quay lại.
- PLAYABLE ACTION: Góp một khâu nếu tự nguyện; kiểm đoạn đã sửa khi mở an toàn.
- PROOF: `repair_contribution_verified`, `repair_finished_verified`. Chỉ ghi nhánh tương ứng với thao tác thực; không đòi tất cả event ở mọi nhánh.
- BRANCHES: Góp công hoặc đi tiếp.
- ABSENT/LATE: NPC hoàn thành theo tiến độ riêng.
- PERSISTENT EFFECT: Lưu tiến độ và người đóng góp; không cấp công cho A nếu vắng.
- LINKED EVENTS (không tự chain): NONE.
- DIALOGUE: tra ngân hàng riêng theo event ID, trạng thái, người có mặt; không chặn diễn biến nếu A không nói.

## EV-A1-WRD-003 — Sáng sau đêm hội

- CATEGORY: DAILY_LIFE; LOCATION: nơi lễ hội thực diễn ra; STATUS: DRAFT_STORY.
- TRIGGER: `festival_ended` (TO_BIND); GUARDS: nội dung duyệt, vị trí/cơ chế đủ, không tranh NPC/đạo cụ.
- WORLD SETUP: Các đội tháo đèn, bảng kết quả còn lại, vài người nghỉ; mỗi vị trí phản ánh nơi hội đã tổ chức.
- PLAYABLE ACTION: Xem kết quả, ghé các điểm đã chơi, gặp NPC nếu có mặt; không bắt dọn dẹp.
- PROOF: `festival_result_viewed`, `aftermath_visited`. Chỉ ghi nhánh tương ứng với thao tác thực; không đòi tất cả event ở mọi nhánh.
- BRANCHES: Xem hậu quả hoặc đi khám phá tiếp.
- ABSENT/LATE: NPC tự dọn; bảng kết quả lưu theo thiết kế.
- PERSISTENT EFFECT: Giữ attended, contributed, contest_result và actual_location tách biệt.
- LINKED EVENTS (không tự chain): NONE.
- DIALOGUE: tra ngân hàng riêng theo event ID, trạng thái, người có mặt; không chặn diễn biến nếu A không nói.

## Quy tắc điều phối

Lưu participation riêng resolution; event có thể kết thúc khi A không ở đó. Chỉ ghi công sau proof. Mỗi lần tổ chức lễ hội có occurrence_id riêng để tránh dùng kết quả năm cũ. Khi thiếu cơ chế an toàn, không mở event hoặc dùng phiên bản không gây hại đã duyệt. Cơ chế thời tiết, lịch, săn, minigame, vật phẩm và bản đồ liên quan đều cần dev xác minh. Không tự tạo quest mới từ event, không ghi đè 24 quest quan hệ.

**JSON:** [A1_EVENT_SCRIPTS_V2.json](A1_EVENT_SCRIPTS_V2.json). **Nguồn cũ:** [Catalog V1](A1_HIGH_IMPACT_EVENTS_CATALOG_V1.md).
