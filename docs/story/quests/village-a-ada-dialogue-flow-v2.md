# Ada (VLA-18) — Kịch bản ba nhiệm vụ theo độ thân thiết, bản 2 bàn giao rõ tình huống

> **Bản nháp biên kịch, CHƯA có engine binding.** Dùng [quy chuẩn bàn giao AI](../production/narrative-dialogue-handoff-contract-v1.md). Các đoạn **TÌNH HUỐNG**, **HÀNH ĐỘNG** và **HỆ QUẢ** KHÔNG HIỂN THỊ như lời nhân vật. Chỉ các dòng gắn mã và người nói thuộc **THOẠI** mới được phát khi sự kiện/điều kiện đúng.

**Ada không phải người giao nhiệm vụ mỗi lần gặp.** Cô chuẩn bị hành lý, quan sát lối rừng, trò chuyện với Hugo. Người chơi có thể tự tìm hồ A1 (đã duyệt), nhưng không có đơn hàng sang Làng B vì làng đó chưa được viết. Mốc tình bạn 20/50/80 chỉ là đề xuất.

## VLA18-Q1 — Những mốc đường đã biết

**TÌNH HUỐNG (không phát thoại):** Ada đứng cạnh góc chuẩn bị hành trang ở rìa Làng A, dò lại hai mốc trên lối rừng đã biết.

**ĐIỀU KIỆN:** thân thiết đề xuất ≥20; đã giúp việc nhỏ và quay lại, Ada có mặt, A chọn hỏi chuyện. Không tự mở ngay khi đủ điểm.

**MỞ LỜI (Ada, `VLA18-Q1-O1`):** “Có một đoạn đường tôi muốn kiểm lại trước khi đi xa. Cậu đi cùng một quãng được không?”

**MENU CỦA A (chỉ hiện, chưa tự nói):** Đồng ý giúp / Lần này không giúp được / Để lúc khác. Đồng ý mới nói `VLA18-Q1-A1`; từ chối mới phát `VLA18-Q1-D1`.

### VLA18-Q1-TRACE

**HÀNH ĐỘNG (không phát thoại):** A tự bước trên lối mòn ra rìa rừng, quan sát đường đi và nhận biết nơi rẽ đầu tiên. Không bật waypoint tự dẫn.

**SỰ KIỆN XÁC NHẬN:** `ada_route_path_observed` → `VLA18-Q1-TRACE.done`. **PHẢN HỒI:** Lối mòn vẫn mở kể cả khi không nhận nhiệm vụ.

**THOẠI chỉ sau khi sự kiện thật được xác nhận, đúng nhân vật hiện diện:**

- `VLA18-Q1-TRACE-L1` **Ada:** “Đi được một đoạn, cậu thấy chỗ nào dễ nhớ nhất?”
- `VLA18-Q1-TRACE-L2` **A:** “Chỗ đường tách ra cạnh hàng cây. Tôi nghĩ mình sẽ nhận ra khi quay lại.”

### VLA18-Q1-MARK

**HÀNH ĐỘNG (không phát thoại):** A quan sát đủ hai dấu mốc ở lối rừng đã mở; chọn mốc dễ nhìn hoặc mốc dễ nhớ. Không đặt vật thể mới khi chưa có asset.

**SỰ KIỆN XÁC NHẬN:** `ada_two_landmarks_verified` → `VLA18-Q1-MARK.done`. **PHẢN HỒI:** Ghi nhận hai mô tả đường đi trong sổ ký sự đề xuất; không thêm đường trên bản đồ.

**THOẠI chỉ sau khi sự kiện thật được xác nhận, đúng nhân vật hiện diện:**

- `VLA18-Q1-MARK-L1` **Ada:** “Một mốc có thể đổi theo mùa. Cậu có để ý đường đi bên dưới không?”
- `VLA18-Q1-MARK-L2` **A:** “Có. Tôi sẽ nhớ cả hướng của con đường, không chỉ một cái cây.”

### VLA18-Q1-RETURN

**HÀNH ĐỘNG (không phát thoại):** A quay về theo tuyến đã đi và tự trò chuyện với Ada tại góc chuẩn bị để xác nhận hướng về. Không dịch chuyển tức thời.

**SỰ KIỆN XÁC NHẬN:** `ada_return_route_confirmed` → `VLA18-Q1-RETURN.done`. **PHẢN HỒI:** Ada ghi nhận A biết cách trở về; chỉ khi đó mới cho hoàn tất.

**THOẠI chỉ sau khi sự kiện thật được xác nhận, đúng nhân vật hiện diện:**

- `VLA18-Q1-RETURN-L1` **Ada:** “Cậu quay lại mà không phải hỏi đường lần nào à?”
- `VLA18-Q1-RETURN-L2` **A:** “Tôi nhận ra hai mốc cũ. Có cái nhìn từ hướng về khác hẳn.”
- `VLA18-Q1-RETURN-L3` **Ada:** “Đấy, hướng về mới là điều tôi muốn kiểm.”

**LỰA CHỌN CỦA A:** Ưu tiên mốc dễ nhìn (nhớ: Ada nhớ A chú ý khả năng quan sát) · Ưu tiên hướng lối đi ổn định (nhớ: Ada nhớ A coi trọng đường trở về).

**KẾT THÚC:** Chỉ khi có đủ ba event hành động và A gặp Ada để báo, phát `VLA18-Q1-C1`: “Tốt. Biết đường quay lại quan trọng không kém đường đi.”.

**NẾU ADA TỰ LÀM:** “Tôi vừa đi xem lại hai mốc, có một chỗ nhìn từ chiều về thật khác.” — không ghi A từng tham gia.

**GẶP LẠI NẾU A GIÚP:** “Đường về hôm trước cậu nhớ khá tốt. Tôi đã ghi lại hướng ấy.”. **SINH HOẠT:** Ada vẫn rời làng theo những quãng đường quen, không biến mọi cuộc gặp thành giao hàng.

## VLA18-Q2 — Kiện hàng chuẩn bị lâu hơn dự định

**TÌNH HUỐNG (không phát thoại):** Ở góc chuẩn bị hàng, Ada và Hugo đang xem hai kiện mẫu; chỉ là chuẩn bị, KHÔNG có làng đích hay đơn hàng thật.

**ĐIỀU KIỆN:** thân thiết đề xuất ≥50; Q1 đã giải quyết + ít nhất một lần gặp thường, Ada có mặt, A chọn hỏi chuyện. Không tự mở ngay khi đủ điểm.

**MỞ LỜI (Ada, `VLA18-Q2-O1`):** “Tôi cứ muốn lên đường ngay. Nhưng Hugo bảo còn phải kiểm kiện. Cậu giúp chúng tôi chọn cách sắp không?”

**MENU CỦA A (chỉ hiện, chưa tự nói):** Đồng ý giúp / Lần này không giúp được / Để lúc khác. Đồng ý mới nói `VLA18-Q2-A1`; từ chối mới phát `VLA18-Q2-D1`.

### VLA18-Q2-INSPECT

**HÀNH ĐỘNG (không phát thoại):** A kiểm hai kiện mẫu: một kiện vật dễ hỏng, một kiện đồ dùng bền; các vật cụ thể chưa chốt, dùng nhãn đạo cụ để mô tả.

**SỰ KIỆN XÁC NHẬN:** `ada_packages_inspected` → `VLA18-Q2-INSPECT.done`. **PHẢN HỒI:** Hiển thị nhãn tình trạng kiện, không tự thêm vật phẩm vào túi A.

**THOẠI chỉ sau khi sự kiện thật được xác nhận, đúng nhân vật hiện diện:**

- `VLA18-Q2-INSPECT-L1` **Hugo:** “Cái này mà xếp dưới cùng thì đến nơi chẳng còn nguyên đâu.”
- `VLA18-Q2-INSPECT-L2` **Ada:** “Tôi đang nghĩ tới lối đi mà quên chuyện kiện có chịu được không.”

### VLA18-Q2-ARRANGE

**HÀNH ĐỘNG (không phát thoại):** A chọn thứ tự xếp sao cho đồ dễ hỏng không chịu lực; nếu chọn đè lên, Hugo yêu cầu thử lại, không ghi hoàn thành.

**SỰ KIỆN XÁC NHẬN:** `ada_safe_pack_order_selected` → `VLA18-Q2-ARRANGE.done`. **PHẢN HỒI:** Thay đổi thứ tự hai kiện trên giá/xe thử; không mở nhiệm vụ vận chuyển liên làng.

**THOẠI chỉ sau khi sự kiện thật được xác nhận, đúng nhân vật hiện diện:**

- `VLA18-Q2-ARRANGE-L1` **Hugo:** “Thế này vừa chắc, vừa còn chỗ buộc dây.”
- `VLA18-Q2-ARRANGE-L2` **Ada:** “Cậu làm tốt phần tôi hay bỏ sót.”

### VLA18-Q2-TIE_AND_CHECK

**HÀNH ĐỘNG (không phát thoại):** A giữ dây để Hugo buộc, kiểm nhãn kiện và ghi danh sách chuẩn bị; Ada xác nhận xong.

**SỰ KIỆN XÁC NHẬN:** `ada_straps_checked` → `VLA18-Q2-TIE_AND_CHECK.done`. **PHẢN HỒI:** Kiện được buộc an toàn; không có người nhận hay điểm đến chưa thiết kế.

**THOẠI chỉ sau khi sự kiện thật được xác nhận, đúng nhân vật hiện diện:**

- `VLA18-Q2-TIE_AND_CHECK-L1` **Ada:** “Có khi chuẩn bị kỹ là cách đi xa nhanh nhất.”
- `VLA18-Q2-TIE_AND_CHECK-L2` **A:** “Ít nhất sẽ không phải quay về vì quên một kiện.”

**LỰA CHỌN CỦA A:** Giữ món dễ hỏng an toàn (nhớ: Ada nhớ A ưu tiên trách nhiệm) · Xếp gọn sau khi kiểm an toàn (nhớ: Ada nhớ A chú ý cả cân nặng lẫn sự an toàn).

**KẾT THÚC:** Chỉ khi có đủ ba event hành động và A gặp Ada để báo, phát `VLA18-Q2-C1`: “Ừ. Tôi hay nhìn đường phía trước mà quên việc cần chuẩn bị.”.

**NẾU ADA TỰ LÀM:** “Hugo và tôi tự xếp lại kiện. Chúng tôi chưa đi đâu cả.” — không ghi A từng tham gia.

**GẶP LẠI NẾU A GIÚP:** “Hugo nói mấy nút buộc hôm ấy ổn lắm. Tôi cũng yên tâm hơn.”. **SINH HOẠT:** Ada và Hugo chuẩn bị hàng theo nhu cầu đời sống, chưa giao người chơi một chuyến sang Làng B.

## VLA18-QF — Một tấm ghi chú đường về

**TÌNH HUỐNG (không phát thoại):** Sau những lần gặp đủ lâu, Ada muốn để lại ghi chú hướng trở về qua những đoạn mình đã đi thật, không làm bản đồ về nơi chưa đến.

**ĐIỀU KIỆN:** thân thiết đề xuất ≥80; Q2 đã giải quyết + hai lần gặp thường + nghe tâm sự, Ada có mặt, A chọn hỏi chuyện. Không tự mở ngay khi đủ điểm.

**MỞ LỜI (Ada, `VLA18-QF-O1`):** “Tôi muốn ai đi đường này cũng biết cách trở về. Cậu giúp tôi ghi vài mốc quen nhé?”

**MENU CỦA A (chỉ hiện, chưa tự nói):** Đồng ý giúp / Lần này không giúp được / Để lúc khác. Đồng ý mới nói `VLA18-QF-A1`; từ chối mới phát `VLA18-QF-D1`.

### VLA18-QF-RECALL

**HÀNH ĐỘNG (không phát thoại):** A chọn hai mốc đã tự quan sát ở Q1, hoặc nếu Q1 được Ada tự giải quyết thì A cùng cô kiểm lại những mốc đã biết ngay quanh làng trước khi ghi.

**SỰ KIỆN XÁC NHẬN:** `ada_known_path_notes_selected` → `VLA18-QF-RECALL.done`. **PHẢN HỒI:** Không được ghi một địa điểm A chưa từng thấy như thể đã khám phá.

**THOẠI chỉ sau khi sự kiện thật được xác nhận, đúng nhân vật hiện diện:**

- `VLA18-QF-RECALL-L1` **Ada:** “Có người đi xa chỉ nhớ chỗ muốn đến. Tôi muốn họ nhớ cả lối quay về.”
- `VLA18-QF-RECALL-L2` **A:** “Mình chỉ nên ghi những đoạn chắc chắn đã biết.”

### VLA18-QF-WRITE

**HÀNH ĐỘNG (không phát thoại):** A chọn cách mô tả hướng rõ ràng: điểm bắt đầu, mốc thứ nhất, mốc thứ hai, hướng về làng. Hồ có thể là ghi chú phụ nếu A đã ghé thực tế, tuyệt đối không bắt buộc.

**SỰ KIỆN XÁC NHẬN:** `ada_return_notes_written` → `VLA18-QF-WRITE.done`. **PHẢN HỒI:** Trang ghi chép hoàn thành với đúng mốc mà A đã khám phá; chưa tạo bản đồ vật lý chính thức.

**THOẠI chỉ sau khi sự kiện thật được xác nhận, đúng nhân vật hiện diện:**

- `VLA18-QF-WRITE-L1` **Ada:** “Lời chỉ dẫn này ai mới tới có hiểu được không?”
- `VLA18-QF-WRITE-L2` **A:** “Nếu bắt đầu ở đây rồi đi theo những mốc này, tôi nghĩ họ sẽ tìm được về.”

### VLA18-QF-PLACE_AND_REVIEW

**HÀNH ĐỘNG (không phát thoại):** A cùng Ada đọc thử lại đường về, đặt bản ghi ở góc chuẩn bị, sau đó chỉ quay lại trò chuyện bình thường.

**SỰ KIỆN XÁC NHẬN:** `ada_notes_reviewed_with_npc` → `VLA18-QF-PLACE_AND_REVIEW.done`. **PHẢN HỒI:** Góc chuẩn bị có ghi chú đường về; không mở Làng B hoặc nhiệm vụ giao hàng.

**THOẠI chỉ sau khi sự kiện thật được xác nhận, đúng nhân vật hiện diện:**

- `VLA18-QF-PLACE_AND_REVIEW-L1` **Ada:** “Tôi cứ nghĩ đi xa là chuyện của những con đường chưa biết.”
- `VLA18-QF-PLACE_AND_REVIEW-L2` **A:** “Nhưng có lối về thì mới yên tâm muốn đi tiếp.”
- `VLA18-QF-PLACE_AND_REVIEW-L3` **Ada:** “Ừ. Tôi cũng muốn có một nơi để quay lại.”

**LỰA CHỌN CỦA A:** Viết chỉ dẫn ngắn, dễ hiểu (nhớ: Ada nhớ A giúp người mới đi đường) · Thêm chi tiết về hai mốc đã kiểm (nhớ: Chỉ ghi dữ kiện chắc chắn) · Thêm nhận xét về bờ hồ nếu đã tự tới (nhớ: Chỉ hiển thị nếu flag lake_discovered thật).

**KẾT THÚC:** Chỉ khi có đủ ba event hành động và A gặp Ada để báo, phát `VLA18-QF-C1`: “Hay đấy. Đi xa mà vẫn nhớ lối về.”.

**NẾU ADA TỰ LÀM:** “Tôi tự viết vài dòng về lối về. Nếu cậu thích, cứ đọc thử.” — không ghi A từng tham gia.

**GẶP LẠI NẾU A GIÚP:** “Tôi vừa xem lại ghi chú của chúng ta. Lần này tôi không quên ghi hướng về.”. **SINH HOẠT:** Ada còn chuyện đường đi, chuẩn bị kiện hàng và sở thích khám phá sau nhiệm vụ cuối; tuyến giao liên làng để riêng.

## Những cuộc gặp bình thường — KHÔNG giao nhiệm vụ

**VLA18-IL1 — Mặt trời đổi hướng** (nơi: VILLAGE_A_COURIER_CORNER).

- `VLA18-IL1-CHAT-L1` **Ada:** “Chỗ rẽ cũ nhìn khác khi nắng ở phía bên kia.”
- `VLA18-IL1-CHAT-L2` **A:** “Vậy lại có thứ cần nhớ thêm.”
- `VLA18-IL1-CHAT-L3` **Ada:** “Ừ. Nhưng hôm nay tôi chỉ ra ngồi một lúc thôi.”

**VLA18-IL2 — Một buổi không vội** (nơi: VILLAGE_A_COURIER_CORNER).

- `VLA18-IL2-CHAT-L1` **A:** “Cậu không đi kiểm kiện nữa à?”
- `VLA18-IL2-CHAT-L2` **Ada:** “Hugo đang làm nốt. Tôi muốn ngồi đây cho hết cốc nước đã.”
- `VLA18-IL2-CHAT-L3` **A:** “Nghe không giống cậu lắm.”
- `VLA18-IL2-CHAT-L4` **Ada:** “Tôi cũng thấy thế.”

**VLA18-IL3 — Đường rừng quen** (nơi: VILLAGE_A_FOREST_EDGE).

- `VLA18-IL3-CHAT-L1` **Ada:** “Hôm nay tôi đi được một quãng rồi quay lại.”
- `VLA18-IL3-CHAT-L2` **A:** “Có điều gì cần mang về à?”
- `VLA18-IL3-CHAT-L3` **Ada:** “Không. Chỉ muốn biết mình vẫn thích con đường ấy.”

**VLA18-BOND — Những người ở lại** (nơi: VILLAGE_A_COURIER_CORNER).

- `VLA18-BOND-CHAT-L1` **Ada:** “Tôi thường chỉ nghĩ đến nơi mình muốn tới.”
- `VLA18-BOND-CHAT-L2` **A:** “Còn khi cậu quay về?”
- `VLA18-BOND-CHAT-L3` **Ada:** “Tôi lại mong nhìn thấy mọi người vẫn ở đây.”
- `VLA18-BOND-CHAT-L4` **A:** “Vậy nơi để quay lại cũng quan trọng với cậu.”
- `VLA18-BOND-CHAT-L5` **Ada:** “Ừ. Có lẽ còn quan trọng hơn tôi tưởng.”

**VLA18-POST — Cuộc gặp đời thường** (nơi: VILLAGE_A_COURIER_CORNER).

- `VLA18-POST-CHAT-L1` **Ada:** “Đường vẫn ở đấy thôi. Hôm nay tôi chưa cần đi đâu.”
- `VLA18-POST-CHAT-L2` **A:** “Thế ta đứng đây một lúc nhé?”
- `VLA18-POST-CHAT-L3` **Ada:** “Ừ. Lâu lâu cũng được.”

**VLA18-LAKE — Gặp ở bờ hồ, tùy chọn** (nơi: APPROVED_A1_LAKE_SHORE).

- `VLA18-LAKE-CHAT-L1` **Ada:** “Ở đây nhìn xa được nhỉ.”
- `VLA18-LAKE-CHAT-L2` **A:** “Cậu đang tìm đường mới à?”
- `VLA18-LAKE-CHAT-L3` **Ada:** “Không. Hôm nay tôi chỉ muốn nhìn mặt nước thôi.”

## Kiểm thử bàn giao

- **first_meeting:** no Q1 offer; no auto quest
- **Q1_no_return:** Q1 not complete until player returns and reports
- **Q2_no_hugo_present:** No Hugo dialogue unless Hugo physically present; allow defer until context available
- **QF_without_lake_visit:** QF still completable; no narration that A visited lake
- **decline:** Ada can self resolve later; no line credits A; relationship stays open
- **after_QF:** ordinary dialogue remains, no Làng B auto unlock

**Hồ A1 đã được duyệt làm địa điểm khám phá; cuộc gặp Ada ven hồ chỉ là bản nháp tình huống, không phải NPC spawn. Không làm map/code.**

[Dữ liệu JSON](village-a-ada-dialogue-flow-v2.json).
