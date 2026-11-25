# A Place to Belong — DANH MỤC SỰ KIỆN LỚN, LỄ HỘI & SĂN BẮN (V1)

> **Tình trạng: DRAFT_STORY / cần người sáng tạo chọn & duyệt từng event.** Đây là bản **nâng độ hấp dẫn** của phần sự kiện, **không xóa 24 quest NPC**, không thay lore hiện có. Người sáng tạo yêu cầu: không chỉ tưới cây/sửa ghế/bày bát; cần **lễ hội, săn, theo dấu, khám phá rủi ro, mất tích tạm thời, tranh tài, biến cố**. Các tình tiết trong tài liệu này là **đề xuất mới**, không phải asset đã có hay cơ chế đã lập trình.

**Tài liệu quy chuẩn:** [Narrative Design System](../production/NARRATIVE_DESIGN_SYSTEM_STANDARD_V1.md) · [Hunting gốc](../activities/hunting-v0.md) · [Bản đồ A1/hồ đã duyệt](../locations/a1-approved-exploration-v0.md) · [Hội thoại handoff](../production/narrative-dialogue-handoff-contract-v1.md).

> **BẢN V2 ĐÃ TÁCH RIÊNG:** [EVENT ONLY](A1_EVENT_SCRIPTS_V2.md) và [DIALOGUE ONLY](../dialogue/A1_EVENT_DIALOGUE_V2.md). V1 là nguồn ý tưởng, không dùng song song như hai nguồn trigger runtime.

## 1. Chẩn đoán vấn đề: có 'đời sống' nhưng chưa có 'điều đáng chờ'

24 nhiệm vụ đầu tiên quá thiên về việc chăm, sửa, sắp xếp. Những việc ấy **đúng làm nhịp nền**, nhưng không nên chiếm toàn bộ trải nghiệm. Game cần cảm giác **hôm nay có thể xảy ra một điều không ngờ tới**, có lúc vui và náo nhiệt, có lúc căng thẳng trong rừng, rồi mới trở về sự bình yên. Trò chơi có thể ấm áp **mà không buồn ngủ**: lễ hội có thi đua; cuộc săn có lần dấu, phán đoán và bỏ lỡ; mưa có lựa chọn đổi tuyến; NPC có mâu thuẫn và câu chuyện tồn tại qua nhiều ngày.

**Tỉ lệ biên kịch mục tiêu (đề xuất, KHÔNG phải spawn rate runtime):** khoảng 50% sinh hoạt/những cuộc gặp ngắn; 30% sự kiện có thử thách/xung đột; 20% chuỗi set-piece đặc biệt. Đừng đưa liên tiếp ba biến cố lớn trong một ngày; cần khoảng lặng để người chơi cảm được hậu quả.

**Tiêu chí 'đáng chơi':** Một event lớn phải có ít nhất **2 trong 4**: (a) hoạt động mới, (b) lựa chọn làm thay đổi diễn biến, (c) khám phá nơi/ngóc ngách khác, (d) hậu quả thấy được sau một lần quay lại. **Không có cái nào thì cắt hoặc ghép vào ambient.**

## 2. Danh mục 24 sự kiện đề xuất, chia thành 6 hệ

| ID | Tên | Nhóm | Nhịp | Khu vực | Mồi câu gameplay |
|---|---|---|---|---|---|
| EV-A1-FES-001 | Đêm đèn trên mặt hồ | Lễ hội | S | Bờ hồ A1 đã duyệt; sân chung Làng A | Đi dạo xem hội |
| EV-A1-FES-002 | Hội tìm dấu rừng | Lễ hội | A | Lối rừng đã mở gần cầu gỗ, không săn quanh nhà/làng | Chọn tuyến dò dấu, chụp/ghi nhận thú, hoặc săn tự chọn CHỈ khi loài, vùng v |
| EV-A1-FES-003 | Hội bếp và chợ chiều | Lễ hội | A | Sân chung Làng A | Chọn dự thi một món/cách bày, thử trò nếm mùi đoán nguyên liệu, trao đổi vớ |
| EV-A1-FES-004 | Đêm lửa nhỏ đầu mùa lạnh | Lễ hội | A | Sân chung hoặc khoảng sinh hoạt được duyệt, không đặt lửa trong rừng khô | Nghe chuyện, tham gia thử thách đoán âm, chủ động hỏi lý do người rời đi nế |
| EV-A1-WLD-001 | Đàn thú đi qua lối cũ | Săn bắn, rượt dấu | S | Rừng giữa Nhà A và Làng A | Theo dấu, nấp quan sát, bám theo tới vùng giới hạn, hoặc trở về kể lại cho  |
| EV-A1-WLD-002 | Con thú thoát khỏi tầm mắt | Săn bắn, rượt dấu | A | Rừng gần mép hồ; lối bộ đã mở | Tìm manh mối gãy cành/đất lún/tiếng động |
| EV-A1-WLD-003 | Cái bẫy cũ không ai nhận | Săn bắn, rượt dấu | A | Rìa rừng, xa đường dân làng | Quan sát từ xa, ghi vị trí |
| EV-A1-WLD-004 | Đêm canh vườn, không phải đêm săn | Săn bắn, rượt dấu | A | Vườn tây Làng A và rìa rừng | Đi kiểm đường vào lúc chạng vạng, quan sát hướng thú đến, giúp chọn biện ph |
| EV-A1-WLD-005 | Chuyến săn có giới hạn | Săn bắn, rượt dấu | S | Vùng rừng săn được cho phép: TO_DECIDE | Đọc dấu, chuẩn bị đồ trong game, lựa chọn mục tiêu hợp lệ, tự thực hiện gam |
| EV-A1-EXP-001 | Con đường chỉ thấy rõ sau mưa | Khám phá | A | Lối mòn rừng hiện có, nhánh đường gần cầu | Đi theo dấu, đánh dấu đường về, khám phá một chỗ ngắm rừng từ góc khác. |
| EV-A1-EXP-002 | Ánh phản chiếu dưới bờ đá | Khám phá | A | Bờ đá hồ A1 đã duyệt | Quan sát từ bờ, tìm góc nhìn, nhặt vật chỉ khi hệ vật phẩm có và vị trí an  |
| EV-A1-EXP-003 | Một tiếng gọi sau màn sương | Khám phá | S | Lối bộ nối rừng – cầu – làng | Lần theo dấu chân/vật đánh dấu, gọi đáp lại nếu ở gần, tìm đường an toàn để |
| EV-A1-EXP-004 | Thử thách quay lại trước khi đèn tắt | Khám phá | A | Rừng giữa Nhà A và Làng A | Ghi nhớ địa hình, chọn đường đi, quay về trước khi nhóm tổ chức kết thúc |
| EV-A1-EXP-005 | Chuyến đi bờ hồ khi bình minh lên | Khám phá | B | Bờ hồ A1 | Đi dạo quan sát, thử góc chụp/ghi nhật ký, lựa chọn quay lại khi trời sáng. |
| EV-A1-DRM-001 | Cầu gỗ sau cơn mưa lớn | Biến cố, nguy cơ và quyết định nhanh | S | Cầu gỗ nối Nhà A và Làng A | Thấy dấu cảnh báo, đi tìm người biết sửa, giúp mang/giữ vật liệu trong điều |
| EV-A1-DRM-002 | Gió mạnh trước đêm hội | Biến cố, nguy cơ và quyết định nhanh | A | Sân làng và bờ hồ | Cùng người làng kiểm neo, dời đồ nhẹ ra chỗ an toàn, hoặc giúp đổi cách tổ  |
| EV-A1-DRM-003 | Cây đổ ngang lối quen | Biến cố, nguy cơ và quyết định nhanh | A | Rìa rừng, nhánh phụ không phải tuyến duy nhất | Kiểm an toàn, chọn đường khác hoặc báo người phù hợp |
| EV-A1-DRM-004 | Mưa kéo dài, bữa ăn chuyển chỗ | Biến cố, nguy cơ và quyết định nhanh | A | Sân chung Làng A | Giữ khay nhẹ, báo người bên kia sân, chọn chỗ trú có thật (TO_BIND). |
| EV-A1-SOC-001 | Hai cách giữ khu rừng | Mâu thuẫn, quan hệ và chuyện cộng đồng | A | Sân chung Làng A | Nghe cả hai, kiểm đường thực tế rồi gợi cách chừa hoa mà vẫn đi thuận. |
| EV-A1-SOC-002 | Người vắng mặt ở buổi hội | Mâu thuẫn, quan hệ và chuyện cộng đồng | S | Sân chung và các lối trong Làng A | Hỏi người gần gũi, lần dấu sinh hoạt quen, hoặc để bạn của họ tự đi tìm. |
| EV-A1-SOC-003 | Buổi thi bị phá hỏng bởi hiểu lầm | Mâu thuẫn, quan hệ và chuyện cộng đồng | A | Sân thủ công và sân chung | Cùng đối chiếu lịch sắp đồ, hỏi nhiều người, tìm sản phẩm thất lạc ở khu si |
| EV-A1-WRD-001 | Bờ hồ sau mưa | Biến đổi thế giới | B | Bờ cỏ/cát/đá hồ A1 | Quan sát dấu bờ, tìm điểm đứng mới, kể lại với Evelyn nếu quen. |
| EV-A1-WRD-002 | Con đường được cả làng sửa | Biến đổi thế giới | A | Lối gần sân chung hoặc nhánh phụ ra rừng | Góp một việc thật nếu muốn |
| EV-A1-WRD-003 | Sau lễ hội: những cuộc gặp không hẹn | Biến đổi thế giới | B | Sân chung, sân thủ công, khu vườn và đường ven hồ | Nghe chuyện, xem dấu trang trí còn lại, giúp việc nhỏ nếu tự nguyện. |

**Nhịp:** S = set-piece đặc biệt, A = thử thách/biến cố có lựa chọn, B = không khí/dư âm. Đây là **mức đầu tư nội dung**, không phải mức rơi vật phẩm. Mỗi mục sau gồm sự kiện, việc làm, nhánh nếu A bỏ qua và thay đổi lâu dài.

## Lễ hội & hoạt động đông người

### EV-A1-FES-001 — Đêm đèn trên mặt hồ [S]

- **LOẠI:** EVENT / FESTIVAL; **STATUS:** DRAFT_STORY; **VÙNG:** Bờ hồ A1 đã duyệt; sân chung Làng A.
- **TRIGGER / tình huống để viết:** Tin đồn đêm hội; người làng mang đèn tới bờ nước, nhưng cơn gió bất ngờ đe dọa khu đèn.
- **A thực sự làm (không phải lời thoại):** Đi dạo xem hội; tham gia đua tìm dấu đèn thất lạc; giúp chuyển chỗ đèn; thi trò quan sát bên hồ; có thể ngồi xem.
- **LỰA CHỌN:** Giúp dựng khu đèn an toàn / tham gia trò chơi không giúp chuẩn bị / đến muộn sau hội.
- **A không tham gia / tới muộn:** Không tới: lễ vẫn diễn ra, có ảnh hưởng từ thời tiết và lời kể hôm sau; không có 'game over'.
- **DẤU VẾT + ký ức lâu dài:** Dấu đèn được để lại tạm bên lối hồ; nhân vật nhớ A giúp hay chỉ dự hội.
- **RÀNG BUỘC:** 3 giai đoạn tối thiểu; phiên bản đầy đủ ở Chuỗi A.
- **Dữ liệu cần được chốt trước khi implement:** trigger runtime, NPC có mặt/lịch, các vật tương tác, bản đồ đúng, cooldown, phê duyệt tình tiết. Không auto-start quest hoặc thêm hệ thưởng.

### EV-A1-FES-002 — Hội tìm dấu rừng [A]

- **LOẠI:** EVENT / FESTIVAL; **STATUS:** DRAFT_STORY; **VÙNG:** Lối rừng đã mở gần cầu gỗ, không săn quanh nhà/làng.
- **TRIGGER / tình huống để viết:** Ngày thi đọc dấu rừng: hai nhóm người muốn thắng bằng quan sát hoặc săn theo luật hợp lệ; một dấu thú rẽ ngoài đường đánh dấu.
- **A thực sự làm (không phải lời thoại):** Chọn tuyến dò dấu, chụp/ghi nhận thú, hoặc săn tự chọn CHỈ khi loài, vùng và cơ chế săn được duyệt.
- **LỰA CHỌN:** Thắng nhờ suy luận / trở về tay không nhưng xác định đúng đường thú / bỏ giữa cuộc thi.
- **A không tham gia / tới muộn:** Không đến: hội vẫn kết thúc, thứ hạng thuộc NPC tham gia; A có thể nghe kể.
- **DẤU VẾT + ký ức lâu dài:** Các điểm nhìn ra rừng được ghi vào sổ khám phá; dân làng nhắc đến lựa chọn không săn/săn hợp lệ.
- **RÀNG BUỘC:** Không săn con non/thú nuôi; không có vật phẩm/thưởng mặc định.
- **Dữ liệu cần được chốt trước khi implement:** trigger runtime, NPC có mặt/lịch, các vật tương tác, bản đồ đúng, cooldown, phê duyệt tình tiết. Không auto-start quest hoặc thêm hệ thưởng.

### EV-A1-FES-003 — Hội bếp và chợ chiều [A]

- **LOẠI:** EVENT / FESTIVAL; **STATUS:** DRAFT_STORY; **VÙNG:** Sân chung Làng A.
- **TRIGGER / tình huống để viết:** Mỗi nhà mang một món hoặc sản phẩm; Clara và Grace tranh luận cách bày gian, một món chính bị thiếu vào phút cuối.
- **A thực sự làm (không phải lời thoại):** Chọn dự thi một món/cách bày, thử trò nếm mùi đoán nguyên liệu, trao đổi với NPC, giúp giải quyết thiếu món bằng giải pháp thay thế.
- **LỰA CHỌN:** Giữ gian đơn giản / bày cho đẹp / đề nghị mọi người chia sẻ phần còn lại.
- **A không tham gia / tới muộn:** A vắng: vẫn có chợ; những món A chưa thử có thể chỉ được nghe kể.
- **DẤU VẾT + ký ức lâu dài:** Một vài công thức/mối quan hệ mới CHỈ KHI cơ chế và nội dung được duyệt; phản ứng NPC khác nhau.
- **RÀNG BUỘC:** Không dựng cả khu chợ mới: dùng sân chung hiện hữu; item economy TO_BIND.
- **Dữ liệu cần được chốt trước khi implement:** trigger runtime, NPC có mặt/lịch, các vật tương tác, bản đồ đúng, cooldown, phê duyệt tình tiết. Không auto-start quest hoặc thêm hệ thưởng.

### EV-A1-FES-004 — Đêm lửa nhỏ đầu mùa lạnh [A]

- **LOẠI:** EVENT / FESTIVAL; **STATUS:** DRAFT_STORY; **VÙNG:** Sân chung hoặc khoảng sinh hoạt được duyệt, không đặt lửa trong rừng khô.
- **TRIGGER / tình huống để viết:** Mọi người tụ tập kể chuyện, có phần chơi đoán âm thanh rừng và chọn một kỷ niệm muốn chia sẻ; có người bỏ về giữa chừng.
- **A thực sự làm (không phải lời thoại):** Nghe chuyện, tham gia thử thách đoán âm, chủ động hỏi lý do người rời đi nếu đủ thân.
- **LỰA CHỌN:** Chuyện vui / câu chuyện buồn / im lặng ngồi nghe; lựa chọn không ép độc thoại đời thực của A.
- **A không tham gia / tới muộn:** Lửa được dập an toàn; NPC vẫn gặp nhau kể cả A không tham gia.
- **DẤU VẾT + ký ức lâu dài:** Những người đã trò chuyện nhớ A tham dự; không tự mở bí mật giấc mơ.
- **RÀNG BUỘC:** Thời tiết mùa chỉ làm trigger khi hệ mùa có thật; lửa và collision cần review riêng.
- **Dữ liệu cần được chốt trước khi implement:** trigger runtime, NPC có mặt/lịch, các vật tương tác, bản đồ đúng, cooldown, phê duyệt tình tiết. Không auto-start quest hoặc thêm hệ thưởng.

## Săn bắn, rượt dấu & động vật

### EV-A1-WLD-001 — Đàn thú đi qua lối cũ [S]

- **LOẠI:** EVENT / HUNT_WILDLIFE; **STATUS:** DRAFT_STORY; **VÙNG:** Rừng giữa Nhà A và Làng A.
- **TRIGGER / tình huống để viết:** Dấu chân mới xuất hiện sau một đêm; một đàn thú bất ngờ cắt qua lối đi đã quen, để lại đường rẽ vào rừng sâu.
- **A thực sự làm (không phải lời thoại):** Theo dấu, nấp quan sát, bám theo tới vùng giới hạn, hoặc trở về kể lại cho người làng.
- **LỰA CHỌN:** Chỉ quan sát / săn hợp lệ nếu được duyệt / buông dấu vì không muốn làm đàn thú hoảng.
- **A không tham gia / tới muộn:** Không có A: đàn thú đi qua, cỏ đổ và dấu chân lưu một thời gian; NPC kể về đường rẽ.
- **DẤU VẾT + ký ức lâu dài:** Một 'hotspot' theo dấu xuất hiện tạm, quần thể không respawn vô hạn.
- **RÀNG BUỘC:** Chuỗi B chi tiết; loài, vũ khí và vùng săn là TO_DECIDE.
- **Dữ liệu cần được chốt trước khi implement:** trigger runtime, NPC có mặt/lịch, các vật tương tác, bản đồ đúng, cooldown, phê duyệt tình tiết. Không auto-start quest hoặc thêm hệ thưởng.

### EV-A1-WLD-002 — Con thú thoát khỏi tầm mắt [A]

- **LOẠI:** EVENT / HUNT_WILDLIFE; **STATUS:** DRAFT_STORY; **VÙNG:** Rừng gần mép hồ; lối bộ đã mở.
- **TRIGGER / tình huống để viết:** Người chơi theo dấu một con thú đơn lẻ; dấu chân đột ngột mất ở đất đá và âm thanh vang từ hướng khác.
- **A thực sự làm (không phải lời thoại):** Tìm manh mối gãy cành/đất lún/tiếng động; dự đoán hướng, quan sát nơi nó qua.
- **LỰA CHỌN:** Tiếp tục theo dấu / rút lui / thử săn nếu quy tắc săn cho phép.
- **A không tham gia / tới muộn:** Không xuất hiện đúng giờ: dấu mờ và thú rời vùng; vẫn có thể học lối rẽ.
- **DẤU VẾT + ký ức lâu dài:** Nhận diện điểm quan sát tốt, không tự sinh kho báu.
- **RÀNG BUỘC:** Không tạo boss fight hoặc 'con thú ma' chưa duyệt.
- **Dữ liệu cần được chốt trước khi implement:** trigger runtime, NPC có mặt/lịch, các vật tương tác, bản đồ đúng, cooldown, phê duyệt tình tiết. Không auto-start quest hoặc thêm hệ thưởng.

### EV-A1-WLD-003 — Cái bẫy cũ không ai nhận [A]

- **LOẠI:** EVENT / HUNT_WILDLIFE; **STATUS:** DRAFT_STORY; **VÙNG:** Rìa rừng, xa đường dân làng.
- **TRIGGER / tình huống để viết:** Một cái bẫy bỏ quên được phát hiện, có dấu thú quanh đó; nguồn gốc bẫy chưa rõ.
- **A thực sự làm (không phải lời thoại):** Quan sát từ xa, ghi vị trí; báo cho người lớn có trách nhiệm; hỗ trợ dỡ thiết bị khi có công cụ an toàn.
- **LỰA CHỌN:** Cứu an toàn nếu có cơ chế / chỉ đánh dấu và báo / không tự đụng vật nguy hiểm.
- **A không tham gia / tới muộn:** A bỏ qua: NPC thấy dấu và tự giải quyết; không để con vật bị kẹt vô thời hạn.
- **DẤU VẾT + ký ức lâu dài:** Sau xử lý khu vực an toàn hơn; Rowan chỉ nói về chăm rừng nếu có mặt.
- **RÀNG BUỘC:** Không kết luận người đặt bẫy là kẻ phản diện hoặc hướng dẫn chế tạo bẫy thật.
- **Dữ liệu cần được chốt trước khi implement:** trigger runtime, NPC có mặt/lịch, các vật tương tác, bản đồ đúng, cooldown, phê duyệt tình tiết. Không auto-start quest hoặc thêm hệ thưởng.

### EV-A1-WLD-004 — Đêm canh vườn, không phải đêm săn [A]

- **LOẠI:** EVENT / HUNT_WILDLIFE; **STATUS:** DRAFT_STORY; **VÙNG:** Vườn tây Làng A và rìa rừng.
- **TRIGGER / tình huống để viết:** Có dấu động vật tới gần luống cây; Hazel không muốn phá hoại cả vùng cây rừng để bảo vệ vườn.
- **A thực sự làm (không phải lời thoại):** Đi kiểm đường vào lúc chạng vạng, quan sát hướng thú đến, giúp chọn biện pháp xua/che luống an toàn.
- **LỰA CHỌN:** Dựng rào nhẹ khi asset có / đặt lại đồ dễ bị phá / chỉ ghi dấu để dân làng tự xử lý.
- **A không tham gia / tới muộn:** Không giúp: Hazel và những người lớn thu xếp, có thể mất ít rau nhưng làng không suy sụp.
- **DẤU VẾT + ký ức lâu dài:** Vườn đổi bố cục nhẹ, NPC nhắc việc bảo vệ luống; không biến con vật thành mục tiêu bắt buộc.
- **RÀNG BUỘC:** Đêm/weather optional; không cho săn sát khu nhà.
- **Dữ liệu cần được chốt trước khi implement:** trigger runtime, NPC có mặt/lịch, các vật tương tác, bản đồ đúng, cooldown, phê duyệt tình tiết. Không auto-start quest hoặc thêm hệ thưởng.

### EV-A1-WLD-005 — Chuyến săn có giới hạn [S]

- **LOẠI:** EVENT / HUNT_WILDLIFE; **STATUS:** DRAFT_STORY; **VÙNG:** Vùng rừng săn được cho phép: TO_DECIDE.
- **TRIGGER / tình huống để viết:** Tìm được tuyến có dấu thú hợp lệ; A phải quyết định chuẩn bị rồi thực hiện săn hay chỉ quan sát.
- **A thực sự làm (không phải lời thoại):** Đọc dấu, chuẩn bị đồ trong game, lựa chọn mục tiêu hợp lệ, tự thực hiện gameplay săn (không auto-skip qua thoại).
- **LỰA CHỌN:** Săn thành công theo cơ chế hợp lệ / trượt và thú chạy / chủ động không săn.
- **A không tham gia / tới muộn:** Không tham gia: động vật tiếp tục vòng sinh thái, không bị phạt thân thiết.
- **DẤU VẾT + ký ức lâu dài:** Khi săn nhiều ở cùng vùng, hiện diện thú có thể giảm tạm; hệ quần thể phải được duyệt.
- **RÀNG BUỘC:** Không tự chốt vũ khí/loot/giới hạn mùa, tránh máu me và trẻ em.
- **Dữ liệu cần được chốt trước khi implement:** trigger runtime, NPC có mặt/lịch, các vật tương tác, bản đồ đúng, cooldown, phê duyệt tình tiết. Không auto-start quest hoặc thêm hệ thưởng.

## Khám phá & bí ẩn đời thường

### EV-A1-EXP-001 — Con đường chỉ thấy rõ sau mưa [A]

- **LOẠI:** EVENT / EXPLORATION; **STATUS:** DRAFT_STORY; **VÙNG:** Lối mòn rừng hiện có, nhánh đường gần cầu.
- **TRIGGER / tình huống để viết:** Nước rút để lộ dấu đi lại và một lối vòng ít người chọn.
- **A thực sự làm (không phải lời thoại):** Đi theo dấu, đánh dấu đường về, khám phá một chỗ ngắm rừng từ góc khác.
- **LỰA CHỌN:** Tìm đường và quay lại / chỉ ghi nhận dấu / dừng vì đường trơn.
- **A không tham gia / tới muộn:** Bỏ qua: lối vòng vẫn có thể được tìm theo cách thường ngày.
- **DẤU VẾT + ký ức lâu dài:** A nhớ thêm đường qua rừng; không mở cửa/hang bí mật.
- **RÀNG BUỘC:** Không tạo đường mới nếu map chưa hỗ trợ; có thể dùng nhánh đã có.
- **Dữ liệu cần được chốt trước khi implement:** trigger runtime, NPC có mặt/lịch, các vật tương tác, bản đồ đúng, cooldown, phê duyệt tình tiết. Không auto-start quest hoặc thêm hệ thưởng.

### EV-A1-EXP-002 — Ánh phản chiếu dưới bờ đá [A]

- **LOẠI:** EVENT / EXPLORATION; **STATUS:** DRAFT_STORY; **VÙNG:** Bờ đá hồ A1 đã duyệt.
- **TRIGGER / tình huống để viết:** Chiều tà phản chiếu lên một khe đá khiến A tưởng có vật sáng; thực tế là ánh sáng và một vật dùng thường ngày trôi dạt (vật phải duyệt).
- **A thực sự làm (không phải lời thoại):** Quan sát từ bờ, tìm góc nhìn, nhặt vật chỉ khi hệ vật phẩm có và vị trí an toàn.
- **LỰA CHỌN:** Ghi cảnh đẹp / tìm chủ vật / rời đi.
- **A không tham gia / tới muộn:** A không đến: phản chiếu hết khi ánh sáng đổi; vật có thể được dân làng thu nhặt.
- **DẤU VẾT + ký ức lâu dài:** Nhớ một góc hồ có thể quay lại; không gắn ma thuật hay 'bí mật giấc mơ'.
- **RÀNG BUỘC:** Không lặn bắt buộc, không tự tạo kho báu.
- **Dữ liệu cần được chốt trước khi implement:** trigger runtime, NPC có mặt/lịch, các vật tương tác, bản đồ đúng, cooldown, phê duyệt tình tiết. Không auto-start quest hoặc thêm hệ thưởng.

### EV-A1-EXP-003 — Một tiếng gọi sau màn sương [S]

- **LOẠI:** EVENT / EXPLORATION; **STATUS:** DRAFT_STORY; **VÙNG:** Lối bộ nối rừng – cầu – làng.
- **TRIGGER / tình huống để viết:** Trong màn sương có tiếng ai gọi giúp, nhưng đường hướng khác với tiếng vang; người cần giúp là một cư dân hiện có bị đi lạc một đoạn.
- **A thực sự làm (không phải lời thoại):** Lần theo dấu chân/vật đánh dấu, gọi đáp lại nếu ở gần, tìm đường an toàn để người ấy quay về.
- **LỰA CHỌN:** Tìm trực tiếp / báo dân làng cùng tìm / không tham gia.
- **A không tham gia / tới muộn:** Không có A: cư dân tìm được lối về hoặc nhóm người đi tìm; ngày sau có lời kể/dấu vết.
- **DẤU VẾT + ký ức lâu dài:** NPC nhớ người giúp thật; người chơi mở góc nhìn mới về đường rừng.
- **RÀNG BUỘC:** Không cấm người chơi qua cầu, không tự xác nhận vụ mất tích nhiều năm.
- **Dữ liệu cần được chốt trước khi implement:** trigger runtime, NPC có mặt/lịch, các vật tương tác, bản đồ đúng, cooldown, phê duyệt tình tiết. Không auto-start quest hoặc thêm hệ thưởng.

### EV-A1-EXP-004 — Thử thách quay lại trước khi đèn tắt [A]

- **LOẠI:** EVENT / EXPLORATION; **STATUS:** DRAFT_STORY; **VÙNG:** Rừng giữa Nhà A và Làng A.
- **TRIGGER / tình huống để viết:** Một trò thử tìm ba mốc đường do dân làng tổ chức vào chiều muộn, mốc cuối gần cầu, tránh vùng chưa mở.
- **A thực sự làm (không phải lời thoại):** Ghi nhớ địa hình, chọn đường đi, quay về trước khi nhóm tổ chức kết thúc; không đặt deadline sinh tồn.
- **LỰA CHỌN:** Hoàn thành mốc / bỏ một mốc để về an toàn / xem thay vì chơi.
- **A không tham gia / tới muộn:** Không đi: cư dân vẫn chơi, một người có thể thắng.
- **DẤU VẾT + ký ức lâu dài:** Mở câu chuyện hài hước sau cuộc chơi, phản ứng Theo/Ada nếu họ hiện diện.
- **RÀNG BUỘC:** Không lấy mất quyền khám phá, không teleport cưỡng ép.
- **Dữ liệu cần được chốt trước khi implement:** trigger runtime, NPC có mặt/lịch, các vật tương tác, bản đồ đúng, cooldown, phê duyệt tình tiết. Không auto-start quest hoặc thêm hệ thưởng.

### EV-A1-EXP-005 — Chuyến đi bờ hồ khi bình minh lên [B]

- **LOẠI:** EVENT / EXPLORATION; **STATUS:** DRAFT_STORY; **VÙNG:** Bờ hồ A1.
- **TRIGGER / tình huống để viết:** Sương mỏng trên mặt nước, chim và thú xuất hiện khác thường; không ai nhờ A tới.
- **A thực sự làm (không phải lời thoại):** Đi dạo quan sát, thử góc chụp/ghi nhật ký, lựa chọn quay lại khi trời sáng.
- **LỰA CHỌN:** Quan sát / ngồi yên / đi tiếp ven bờ.
- **A không tham gia / tới muộn:** Không tới: cảnh đổi theo thời gian và chỉ còn lời nhắc từ NPC thích đi hồ.
- **DẤU VẾT + ký ức lâu dài:** Dấu khám phá trong journal nếu có; không tự tăng trust chỉ vì đi qua.
- **RÀNG BUỘC:** Chỉ cần ngắm vẫn có giá trị, không bắt quest.
- **Dữ liệu cần được chốt trước khi implement:** trigger runtime, NPC có mặt/lịch, các vật tương tác, bản đồ đúng, cooldown, phê duyệt tình tiết. Không auto-start quest hoặc thêm hệ thưởng.

## Biến cố, nguy cơ và quyết định nhanh

### EV-A1-DRM-001 — Cầu gỗ sau cơn mưa lớn [S]

- **LOẠI:** EVENT / EMERGENCY; **STATUS:** DRAFT_STORY; **VÙNG:** Cầu gỗ nối Nhà A và Làng A.
- **TRIGGER / tình huống để viết:** Một ván cầu lỏng sau đợt mưa làm người làng phải cảnh báo nhau; một nhóm người chuẩn bị sửa, đường vòng nếu có phải kiểm.
- **A thực sự làm (không phải lời thoại):** Thấy dấu cảnh báo, đi tìm người biết sửa, giúp mang/giữ vật liệu trong điều kiện an toàn, hoặc tìm đường vòng đã có.
- **LỰA CHỌN:** Giúp dân làng / chọn đường vòng / không tham gia.
- **A không tham gia / tới muộn:** A vắng: Owen, Theo và người khác tự xử lý sau một khoảng; không giữ cầu hỏng mãi.
- **DẤU VẾT + ký ức lâu dài:** Dấu sửa mới trên cầu, NPC nhớ ai giúp; không khóa trục đi lại duy nhất.
- **RÀNG BUỘC:** Chuỗi C; không phá cầu hoàn toàn khi thiếu phương án đi lại.
- **Dữ liệu cần được chốt trước khi implement:** trigger runtime, NPC có mặt/lịch, các vật tương tác, bản đồ đúng, cooldown, phê duyệt tình tiết. Không auto-start quest hoặc thêm hệ thưởng.

### EV-A1-DRM-002 — Gió mạnh trước đêm hội [A]

- **LOẠI:** EVENT / EMERGENCY; **STATUS:** DRAFT_STORY; **VÙNG:** Sân làng và bờ hồ.
- **TRIGGER / tình huống để viết:** Gió nổi lên đúng lúc dựng đèn, một phần đồ trang trí phải dời; người phụ trách phải quyết định mở hội ở đâu.
- **A thực sự làm (không phải lời thoại):** Cùng người làng kiểm neo, dời đồ nhẹ ra chỗ an toàn, hoặc giúp đổi cách tổ chức.
- **LỰA CHỌN:** Giữ hội ngoài bờ nếu điều kiện an toàn / thu nhỏ về sân chung / hoãn phần đèn.
- **A không tham gia / tới muộn:** Không can thiệp: NPC quyết định an toàn và điều chỉnh lễ; không tự tạo thảm họa.
- **DẤU VẾT + ký ức lâu dài:** Các buổi hội sau có khác bố trí; A được cảm ơn chỉ nếu từng làm.
- **RÀNG BUỘC:** Liên kết FES-001, không tạo hai cơn gió trùng cùng buổi.
- **Dữ liệu cần được chốt trước khi implement:** trigger runtime, NPC có mặt/lịch, các vật tương tác, bản đồ đúng, cooldown, phê duyệt tình tiết. Không auto-start quest hoặc thêm hệ thưởng.

### EV-A1-DRM-003 — Cây đổ ngang lối quen [A]

- **LOẠI:** EVENT / EMERGENCY; **STATUS:** DRAFT_STORY; **VÙNG:** Rìa rừng, nhánh phụ không phải tuyến duy nhất.
- **TRIGGER / tình huống để viết:** Một cây già ngã chắn lối phụ, để lộ dấu động vật đi vòng.
- **A thực sự làm (không phải lời thoại):** Kiểm an toàn, chọn đường khác hoặc báo người phù hợp; hỗ trợ dọn khi có cơ chế/đạo cụ được duyệt.
- **LỰA CHỌN:** Đi vòng khám phá / góp công dọn / để người có kỹ năng làm.
- **A không tham gia / tới muộn:** A không tới: Rowan và dân làng thu xếp sau thời gian hợp lý.
- **DẤU VẾT + ký ức lâu dài:** Con đường đổi silhouette và dấu đường rẽ; không làm mất quyền đi rừng.
- **RÀNG BUỘC:** Không tự cấp cưa/rìu/đồ nghề chuyên dụng.
- **Dữ liệu cần được chốt trước khi implement:** trigger runtime, NPC có mặt/lịch, các vật tương tác, bản đồ đúng, cooldown, phê duyệt tình tiết. Không auto-start quest hoặc thêm hệ thưởng.

### EV-A1-DRM-004 — Mưa kéo dài, bữa ăn chuyển chỗ [A]

- **LOẠI:** EVENT / EMERGENCY; **STATUS:** DRAFT_STORY; **VÙNG:** Sân chung Làng A.
- **TRIGGER / tình huống để viết:** Một buổi ăn ngoài trời bị mưa, mọi người phải mang đồ về chỗ trú đã có.
- **A thực sự làm (không phải lời thoại):** Giữ khay nhẹ, báo người bên kia sân, chọn chỗ trú có thật (TO_BIND).
- **LỰA CHỌN:** Cùng giúp dời / rút ngắn buổi ăn / chỉ đứng trú và xem.
- **A không tham gia / tới muộn:** Không đến: bữa ăn chuyển về trong nhà hoặc hoãn hợp lý.
- **DẤU VẾT + ký ức lâu dài:** Lần gặp sau Grace nói về buổi mưa; không tự phạt vì vắng.
- **RÀNG BUỘC:** Không tự tạo nhà ăn mới hay mưa xuyên đêm nếu weather chưa có.
- **Dữ liệu cần được chốt trước khi implement:** trigger runtime, NPC có mặt/lịch, các vật tương tác, bản đồ đúng, cooldown, phê duyệt tình tiết. Không auto-start quest hoặc thêm hệ thưởng.

## Mâu thuẫn, quan hệ và chuyện cộng đồng

### EV-A1-SOC-001 — Hai cách giữ khu rừng [A]

- **LOẠI:** EVENT / SOCIAL; **STATUS:** DRAFT_STORY; **VÙNG:** Sân chung Làng A.
- **TRIGGER / tình huống để viết:** Rowan muốn giữ vạt hoa, Silas muốn dọn lối nhanh để người đi không vấp.
- **A thực sự làm (không phải lời thoại):** Nghe cả hai, kiểm đường thực tế rồi gợi cách chừa hoa mà vẫn đi thuận.
- **LỰA CHỌN:** Ủng hộ dọn tối thiểu / thử cách khác / không xen vào.
- **A không tham gia / tới muộn:** Không tham gia: hai người thương lượng giải pháp riêng, không thù nhau vì A bỏ qua.
- **DẤU VẾT + ký ức lâu dài:** Dấu vạt hoa được giữ hoặc đường gọn hơn; quan điểm NPC khác nhau và có thể đổi.
- **RÀNG BUỘC:** Không tự chuyển thành phe phái/điểm đạo đức.
- **Dữ liệu cần được chốt trước khi implement:** trigger runtime, NPC có mặt/lịch, các vật tương tác, bản đồ đúng, cooldown, phê duyệt tình tiết. Không auto-start quest hoặc thêm hệ thưởng.

### EV-A1-SOC-002 — Người vắng mặt ở buổi hội [S]

- **LOẠI:** EVENT / SOCIAL; **STATUS:** DRAFT_STORY; **VÙNG:** Sân chung và các lối trong Làng A.
- **TRIGGER / tình huống để viết:** Đến giờ hội, một người quen không đến khiến người khác lo; họ đang ở một nơi thường ghé vì có chuyện riêng, không bị bắt cóc.
- **A thực sự làm (không phải lời thoại):** Hỏi người gần gũi, lần dấu sinh hoạt quen, hoặc để bạn của họ tự đi tìm.
- **LỰA CHỌN:** Tới hỏi thăm / nhờ người khác / dự hội bình thường.
- **A không tham gia / tới muộn:** A vắng: NPC khác tìm được người, có lời kể hậu hội.
- **DẤU VẾT + ký ức lâu dài:** Người được tìm nhớ A quan tâm, nhưng có thể nói rằng họ muốn ở một mình.
- **RÀNG BUỘC:** Không xác nhận tử vong, bí mật đen tối hay nhân vật mới.
- **Dữ liệu cần được chốt trước khi implement:** trigger runtime, NPC có mặt/lịch, các vật tương tác, bản đồ đúng, cooldown, phê duyệt tình tiết. Không auto-start quest hoặc thêm hệ thưởng.

### EV-A1-SOC-003 — Buổi thi bị phá hỏng bởi hiểu lầm [A]

- **LOẠI:** EVENT / SOCIAL; **STATUS:** DRAFT_STORY; **VÙNG:** Sân thủ công và sân chung.
- **TRIGGER / tình huống để viết:** Một sản phẩm dự thi bị đổi chỗ, Maeve và một người học tưởng ai đó cố ý làm mất.
- **A thực sự làm (không phải lời thoại):** Cùng đối chiếu lịch sắp đồ, hỏi nhiều người, tìm sản phẩm thất lạc ở khu sinh hoạt.
- **LỰA CHỌN:** Điều tra tử tế / để chủ đồ tự xử lý / nói vội khiến hiểu lầm lớn hơn trong chừng mực.
- **A không tham gia / tới muộn:** Không can thiệp: món đồ tự được tìm thấy muộn, mọi người làm hòa chậm hơn.
- **DẤU VẾT + ký ức lâu dài:** Quan hệ được sửa qua hành động, không phải cảnh A phán xét bằng một nút.
- **RÀNG BUỘC:** Không gán tội cho trẻ em khi chưa có bằng chứng.
- **Dữ liệu cần được chốt trước khi implement:** trigger runtime, NPC có mặt/lịch, các vật tương tác, bản đồ đúng, cooldown, phê duyệt tình tiết. Không auto-start quest hoặc thêm hệ thưởng.

## Biến đổi thế giới & dư âm lâu dài

### EV-A1-WRD-001 — Bờ hồ sau mưa [B]

- **LOẠI:** EVENT / WORLD; **STATUS:** DRAFT_STORY; **VÙNG:** Bờ cỏ/cát/đá hồ A1.
- **TRIGGER / tình huống để viết:** Mực nước và dấu bùn đổi sau mưa, vài đường đi bộ ven bờ nhìn khác; không cần quest.
- **A thực sự làm (không phải lời thoại):** Quan sát dấu bờ, tìm điểm đứng mới, kể lại với Evelyn nếu quen.
- **LỰA CHỌN:** Ghi chép / không làm gì.
- **A không tham gia / tới muộn:** Không tới: bờ vẫn thay đổi rồi hồi lại.
- **DẤU VẾT + ký ức lâu dài:** Nhật ký khám phá cập nhật theo điều kiện; không tự biến hồ thành vùng bí mật.
- **RÀNG BUỘC:** Cần hệ môi trường hoặc trạng thái kể chuyện phù hợp.
- **Dữ liệu cần được chốt trước khi implement:** trigger runtime, NPC có mặt/lịch, các vật tương tác, bản đồ đúng, cooldown, phê duyệt tình tiết. Không auto-start quest hoặc thêm hệ thưởng.

### EV-A1-WRD-002 — Con đường được cả làng sửa [A]

- **LOẠI:** EVENT / WORLD; **STATUS:** DRAFT_STORY; **VÙNG:** Lối gần sân chung hoặc nhánh phụ ra rừng.
- **TRIGGER / tình huống để viết:** Sau vài biến cố nhỏ, người làng quyết định cùng sửa một đoạn, chia người sửa, người nấu, người chở đồ.
- **A thực sự làm (không phải lời thoại):** Góp một việc thật nếu muốn; xem tiến độ nhiều ngày; trò chuyện về ai đã làm gì.
- **LỰA CHỌN:** Giúp một khâu / đóng góp công khác / không tham gia.
- **A không tham gia / tới muộn:** NPC vẫn tự tiến hành, hoàn thành theo tiến độ cộng đồng; A không phải thợ duy nhất.
- **DẤU VẾT + ký ức lâu dài:** Đường có dấu sửa qua vài ngày, hoạt động NPC thay đổi ở các buổi sau.
- **RÀNG BUỘC:** Không mở khu mới, không xóa công trạng NPC.
- **Dữ liệu cần được chốt trước khi implement:** trigger runtime, NPC có mặt/lịch, các vật tương tác, bản đồ đúng, cooldown, phê duyệt tình tiết. Không auto-start quest hoặc thêm hệ thưởng.

### EV-A1-WRD-003 — Sau lễ hội: những cuộc gặp không hẹn [B]

- **LOẠI:** EVENT / WORLD; **STATUS:** DRAFT_STORY; **VÙNG:** Sân chung, sân thủ công, khu vườn và đường ven hồ.
- **TRIGGER / tình huống để viết:** Sáng hôm sau sân bớt đông; từng NPC nhắc một chi tiết khác về đêm hội, có người đang dọn, người nghỉ.
- **A thực sự làm (không phải lời thoại):** Nghe chuyện, xem dấu trang trí còn lại, giúp việc nhỏ nếu tự nguyện.
- **LỰA CHỌN:** Nhắc trò đã chơi / hỏi người mình không gặp / bỏ qua.
- **A không tham gia / tới muộn:** Không đến: lời hội vẫn có thể xuất hiện ngắn trong các lượt gặp sau.
- **DẤU VẾT + ký ức lâu dài:** Sự kiện tạo ký ức chung; không chỉ reset sân về như chưa từng có gì.
- **RÀNG BUỘC:** Đoạn hồi âm quan trọng để hội không thành minigame vô nghĩa.
- **Dữ liệu cần được chốt trước khi implement:** trigger runtime, NPC có mặt/lịch, các vật tương tác, bản đồ đúng, cooldown, phê duyệt tình tiết. Không auto-start quest hoặc thêm hệ thưởng.

## 3. CHUỖI A — “Đêm đèn trên mặt hồ” (FES-001 + DRM-002 + WRD-003)

**Trọng tâm:** không chỉ một bàn đồ ăn và vài câu thoại. Người chơi được thấy **cả làng chuẩn bị một đêm náo nhiệt**, có minigame, âm nhạc nền, gió bất ngờ và hậu quả sáng hôm sau. **Lễ hội là đề xuất mới, không xác nhận đã có ánh sáng/đèn/vật thể/âm nhạc trong bản hiện tại.**

| Nhịp | Chứng kiến/tham gia | Lựa chọn của A | Hậu quả kiểm được |
|---|---|---|---|
| A0 — Tin hội | Nghe Ada kể đường xuống hồ đông hơn thường ngày; thấy Grace và Clara bàn chuyện thức ăn | Đến xem hay không | `event.fes001.announced`; không biến thành quest |
| A1 — Chuẩn bị | Một góc sân tổ chức thử **thi nhận biết tiếng chim / tìm đèn dấu / trưng bày món ăn**; NPC tự chuẩn bị | Chơi thử, phụ một phần hoặc không tham gia | Ghi `minigame_result` nếu chơi; NPC tự làm phần còn lại |
| A2 — Cơn gió | Gió mạnh, đèn ven bờ phải được chuyển khỏi nơi nguy hiểm; tổ chức không bỏ qua an toàn | Giúp chuyển; đề nghị chuyển vào sân; để NPC xử lý | `event.fes001.layout_choice` = lakeside_safe/village_square/postponed; không gán A nếu không có mặt |
| A3 — Đêm hội | Khi an toàn, người làng dự trò đoán dấu đường, trao đổi chuyện, nghe nhạc; có một khoảnh khắc nhìn ánh đèn phản chiếu mặt nước | Tham gia trò, hỏi chuyện thân thiết, hoặc chỉ ngồi ngắm | `event.fes001.attended` chỉ nếu A thực tới; thưởng là trải nghiệm/quan hệ, loot tùy duyệt |
| A4 — Sáng hôm sau | Bờ hồ im hơn, một vài chiếc đèn đã tắt, người làng dọn sân hoặc kể về đêm trước | Hỏi lại người mình lỡ gặp / đi hồ tìm điểm chụp | Mỗi NPC có phản ứng theo việc A làm, không reset trạng thái như chưa hề có hội |

**Chi tiết cuốn hút:** mini-game **dò đèn theo dấu trên đường**, **đoán nhạc/tiếng rừng** và **thi nhận ra dấu mốc quanh hồ** (không cần nhà/công trình mới). Nếu AI dev chưa có minigame: nội dung ghi `TO_BIND`, có thể cho A tham dự bằng đối thoại nhỏ mà vẫn giữ nhánh. Không giả vờ đã triển khai.

**Nhánh đặc biệt:** Nếu không có hệ weather, gió là **tình huống kể chuyện dựng riêng sau khi duyệt**; không gán điều kiện mưa/gió thực cho gameplay. Nếu có weather, sự kiện có thể đổi ngày và địa điểm. **Không để cùng lúc hai festival chiếm hết các NPC core.**

## 4. CHUỖI B — “Vết chân qua rừng” (WLD-001 → WLD-002 → WLD-005)

**Cảm giác:** hồi hộp, đuổi theo dấu thay vì đánh liên tục. **Không chốt loài thú/vũ khí/loot**; động vật hiện diện trong map không đồng nghĩa được phép săn loài đó. Săn vẫn hoàn toàn tự chọn.

| Mốc | Có thể xảy ra | Người chơi làm | Nếu không can thiệp |
|---|---|---|---|
| B0 | Sau sương/mưa, vệt đất có dấu chân mới | Nhìn dấu, chọn theo hoặc bỏ | Dấu mờ dần, đàn thú đi qua |
| B1 | Dấu tách làm hai ở chỗ đất đá, nghe tiếng động phía sau tán cây | Chọn suy luận hướng đi; thử lối vòng ít tiếng động | Con thú tự rời khỏi khu vực |
| B2 | A nhìn thấy thú từ khoảng an toàn | Quan sát, ghi nhận; nếu game đã duyệt vùng, loài và công cụ mới có thêm **nhánh săn** | Không có cơ hội săn cưỡng bức |
| B3 | Săn hợp lệ có thể thành công, trượt; hoặc A quyết định không săn | Điều khiển hành động săn do hệ gameplay xử lý, không tự báo thành công qua thoại | Thú đi khỏi và để lại khu vực vắng một thời gian |
| B4 | Lần sau quay lại, dấu rừng ít hơn hoặc xuất hiện ở hướng khác | Nhận ra hành động để lại hậu quả; hỏi cư dân biết rừng | Không bị phạt nếu chỉ quan sát; không farm vô hạn |

**Chốt điều kiện:** `wildlife_sign_found` ≠ `species_observed` ≠ `hunt_attempted` ≠ `hunt_success`. Luồng phải có **thua/thú chạy** thay vì cứ đi tới là bấm nhặt đồ. Các nhánh săn cần vùng an toàn, quần thể, loài hợp lệ và animation săn được duyệt; không viết hướng dẫn sử dụng vũ khí ngoài đời.

## 5. CHUỖI C — “Cầu qua suối không còn như cũ” (DRM-001 → WRD-002)

**Mồi mở:** một sáng A đi từ Nhà A qua rừng, nghe tiếng gỗ kêu khác thường ở cây cầu vẫn qua hằng ngày. Ván gỗ lỏng, người làng đặt cảnh báo. Đường đã quen **đột nhiên thay đổi**.

- **Nếu A tò mò:** xem chỗ ván lỏng, hỏi Owen/Theo nếu họ ở gần, giúp một thao tác an toàn; người chơi **không** tự sửa cả cây cầu bằng một nút.
- **Nếu A thích khám phá:** tìm đường vòng **chỉ khi map có một đường vòng thực đã được kiểm**, nếu không thì cầu chỉ đóng một làn/có lối tạm an toàn; không khóa tuyến Nhà A ↔ Làng A.
- **Nếu A bỏ qua:** người làng tiến hành sửa theo nhiều lượt sinh hoạt. A quay lại thấy cầu được vá, một góc vật liệu được thu dọn, NPC nhắc đã có người làm. Không tạo thất bại vì vắng mặt.
- **Nếu A giúp:** có một vài việc thật: mang vật liệu nhẹ, giữ đầu ván khi người có tay nghề chỉnh, thử đường qua khi được phép. NPC nhớ đúng A đã làm.
- **Kết:** cầu vẫn là cầu cũ; nó có dấu mới và trở thành kỷ niệm chung. Không chốt thảm họa sập cầu hoặc mở vùng mới.

**Lưu ý:** Đây là chuỗi thử nghiệm với environment object/collision `TO_BIND`. Có thể chỉ đóng tạm **một góc cầu** khi thiếu đường thay thế. Không sửa map trên nhánh biên kịch.

## 6. Sự kiện phải liên kết, không phải 24 popup rời

~~~text
FES-001 Đêm đèn bờ hồ
  ├── DRM-002 Gió trước hội ──→ FES-001 thay đổi địa điểm/giờ
  └── WRD-003 Sáng sau hội ──→ NPC nhớ người chơi / dấu trang trí

WLD-001 Đàn thú đi qua
  └── WLD-002 Mất dấu trên đá
       └── WLD-005 Theo dấu/săn hợp lệ (tùy chọn) ──→ ký ức về rừng

DRM-001 Cầu cần sửa
  └── WRD-002 Dân làng cùng sửa ──→ cảnh cầu đổi, quan hệ đổi

FES-003 Hội bếp ──→ SOC-003 Hiểu lầm đồ dự thi ──→ dịp làm hòa
SOC-002 Một người vắng hội ──→ EXP-003 Tìm đường trong sương (nếu cùng hoàn cảnh)
~~~

Các dấu mũi tên là **khả năng nối chuyện**, không phải kích hoạt tất cả cùng lúc. Cần mutex/cooldown để tránh festival, cầu, thú và hội bếp chen nhau làm NPC ở hai nơi.

## 7. Vì sao đây mới là cơ chế tạo hứng thú?

- **Đổi nhịp:** ngày thường dịu → bất ngờ (sương/mưa/dấu thú) → một quyết định → thế giới thay đổi → trở lại bình yên.
- **Không đoán trước:** thấy dấu chân chưa chắc thấy thú; hội không chắc ở bờ hồ nếu gió; dự một buổi thi không đảm bảo thắng.
- **Tính xã hội:** người làng tự tổ chức và giải quyết; A có thể tham gia hay chỉ đứng xem mà vẫn thấy sự kiện thật.
- **Địa lý có công dụng:** Nhà A, cầu, lối rừng, sân làng, vườn tây, sân thủ công và **bờ hồ đã duyệt** xuất hiện trong chuyện, không tự mở Làng B.
- **Hậu quả cụ thể:** một chỗ cầu đổi màu, dấu thú mờ đi, NPC đổi lời chào, một gian hàng ít đông hơn, đèn được chuyển chỗ.
- **Ký ức:** A có mặt/không có mặt, giúp thật/không giúp, thắng/trượt, chọn quan sát/săn đều không bị nhầm thành một ending.

## 8. Gói MVP đề xuất để test AI/gameplay trước khi viết cả trăm event

**Vòng đầu 6 event:** `FES-001` (lễ hội đèn), `DRM-002` (gió đổi hội), `WRD-003` (sáng sau hội), `WLD-001` (đàn thú qua rừng), `WLD-002` (mất dấu), `DRM-001` (cầu gỗ ván lỏng). **Hunting thành công chờ duyệt loài/vũ khí/vùng**, không nên hứa runtime ngay.

**Thử bằng 2 vòng quay lại:**
1. A chỉ đi ngắm/hỏi, không giúp: thế giới vẫn vận hành, có dấu vết hôm sau.
2. A tham gia ít nhất một việc thật: lựa chọn thay đổi hiện trường hoặc lời gặp lại, không phát thoại chung.

**Tiêu chí duyệt:** có gameplay khác nhau giữa sáu event, một ngày đáng mong chờ, hai lựa chọn thật sự khác nhánh, ít nhất một hậu quả nhìn thấy, NPC không spam quest, không biến stage direction thành thoại. **Chỉ gọi IMPLEMENTED khi game có scene/event thật và đã test.**

## 9. Quy tắc viết và bàn giao các event mới (giống chuẩn narrative V1)

Mỗi event phải có `id/category/status`, `trigger`, `guards`, `cooldown`, `NPC/location refs`, `steps`, `WORLD_ACTION events`, `PLAYER_CHOICE`, `if_absent`, `lasting_effects`, `state keys`, `expected tests`. **Tất cả trigger chưa có trong code = TO_BIND.**

**Không nhầm nhãn:** `SCENE_CONTEXT` và `WORLD_ACTION` không được phát như lời NPC. Chỉ lời `NPC_DIALOGUE/PLAYER_LINE` được phát sau khi có line ID, speaker, event và điều kiện. **Lời thoại cụ thể chưa viết trong file này**, không có nghĩa event tự phát thoại.

**Bốn cuộc thử tối thiểu:** A tham gia / A không tham gia / A tới muộn / NPC vắng; với sự kiện săn bổ sung săn thành công / thú thoát / chọn không săn. Với lễ hội bổ sung đổi nơi hoặc hoãn khi thời tiết xấu.

## 10. Những điều vẫn chưa được duyệt hoặc chưa xây

Đây là **kho ý tưởng cao trào**, chứ không khẳng định trong game đã có hội, giao diện minigame, vật phẩm, lịch bốn mùa, nhạc hội, lửa trại, cầu hỏng, NPC đi lạc hay hệ săn chạy được. **Hướng săn tùy chọn đã được chọn**, nhưng loại vũ khí, loài săn, vùng săn và cơ chế combat chưa chốt. **Hồ là địa điểm đã duyệt**; lễ hội ở hồ là tình tiết mới đang chờ duyệt. Không tự thêm phép thuật, phản diện, bí mật giấc mơ, Làng B, kho báu hay nhân vật mới chưa duyệt.

**Nguồn căn cứ:** [Canon hiện hành](../00-foundation.md) · [Hunting-v0](../activities/hunting-v0.md) · [Quy chuẩn event](../production/NARRATIVE_DESIGN_SYSTEM_STANDARD_V1.md) · [Địa lý A1](../locations/a1-approved-exploration-v0.md).
