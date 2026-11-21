# Evelyn — Kịch bản tương tác 3 nhiệm vụ, vườn Làng A và hồ A1 (bản v1)

> **DRAFT biên kịch**, hồ A1 đã được m duyệt là nơi khám phá chính thức. Đường từ Làng A tới bờ hồ có trong nhánh A1 Superworld, nhưng *sự kiện nói chuyện và ghi chép của Evelyn* vẫn là đề xuất biên kịch, chưa phải NPC hay quest chạy trong Godot.

**Nhịp sống:** Evelyn phân loại hũ hạt và quan sát vườn phía tây. Bà truyền kỹ năng qua những điều có thể kiểm chứng, không biết nguồn gốc giấc mơ và không giữ bí mật phép thuật. Q1/Q2/QF mở dần sau các cuộc gặp thực sự và độ thân thiết (20/50/80 chỉ là ngưỡng thử nghiệm). A có thể từ chối, Evelyn vẫn tự giải quyết và sống tiếp.

## VLA15-Q1 — Nhãn hạt còn thiếu

**Nơi:** Vườn chung phía tây Làng A; hũ hạt và chỗ nhãn ngoài hiên gần vườn là đạo cụ gợi ý

**Hoàn cảnh:** Evelyn kiểm hai hũ cùng loại nắp; nhãn một hũ bị thiếu thông tin.

**Thoại gốc dùng lại:** `VLA15-Q1-O1` · `VLA15-Q1-A1` · `VLA15-Q1-C1` · `VLA15-Q1-D1` (không thay câu gốc).

**OBSERVE:** Quan sát hai hũ, đối chiếu dạng hạt và nhãn đang có, không mở cùng lúc hay trộn giống.

- `VLA15-Q1-OBSERVE-X1` **Evelyn:** “Hũ này thiếu một dòng, nên tôi chưa cất chung.”
- `VLA15-Q1-OBSERVE-X2` **A:** “Bà có chắc hai hũ là một loại không?”
- `VLA15-Q1-OBSERVE-X3` **Evelyn:** “Ta phải so trước, đừng dựa vào màu nắp.”

**CHECK:** Chọn xem nhãn hũ mẫu, hỏi lại Evelyn khi chưa rõ; nếu chọn đoán, bà hướng dẫn kiểm lại thay vì phạt.

- `VLA15-Q1-CHECK-X1` **A:** “Tôi chưa biết ký hiệu này nghĩa là gì.”
- `VLA15-Q1-CHECK-X2` **Evelyn:** “Thế thì hỏi. Ghi sai còn khổ hơn để trống.”
- `VLA15-Q1-CHECK-X3` **A:** “Vậy tôi đối chiếu lại hũ bên cạnh.”

**LABEL:** Chọn thông tin đã xác nhận, gắn nhãn vào đúng một hũ rồi để Evelyn kiểm và cất lại.

- `VLA15-Q1-LABEL-X1` **Evelyn:** “Đọc lại cho tôi nghe thử.”
- `VLA15-Q1-LABEL-X2` **A:** “Tên giống và ngày ghi theo mẫu, còn phần chưa chắc tôi để trống.”
- `VLA15-Q1-LABEL-X3` **Evelyn:** “Được. Một dòng đúng còn quý hơn đầy giấy đoán.”

**Lựa chọn:**
- **Đọc nhãn mẫu rồi ghi:** Evelyn nhớ A làm việc có căn cứ
- **Hỏi điều chưa biết:** Củng cố tin cậy vì không phỏng đoán
- **Đoán và sửa lại:** Evelyn gợi kiểm nhãn; không mất thiện cảm nặng

**Nếu A làm xong:** Nhãn hũ cậu giúp ghi vẫn đọc rõ. Tôi đã để nó đúng chỗ.

**Nếu Evelyn tự làm:** Tôi đã tự đối chiếu rồi bổ sung nhãn. May mà không ghi vội. (không được ghi A có công.)

**Sau đó:** Evelyn vẫn phân loại hạt và đi quan sát vườn; không tự phát Q2.

## VLA15-Q2 — Trang ghi chép từ vườn

**Nơi:** Vườn phía tây Làng A là điểm bắt buộc; bờ hồ A1 là nhánh quan sát tự chọn đã được người sáng tạo duyệt

**Hoàn cảnh:** Evelyn mở sổ, nhận ra phần ghi chép ngoài vườn đã cũ; A có thể xin ghi giúp. Nếu đã tìm được hồ, cô gợi ý quan sát so sánh ở bờ.

**Thoại gốc dùng lại:** `VLA15-Q2-O1` · `VLA15-Q2-A1` · `VLA15-Q2-C1` · `VLA15-Q2-D1` (không thay câu gốc).

**GARDEN:** A ra vườn phía tây, chọn một luống công cộng, quan sát màu lá, độ ẩm đất và giai đoạn cây; ghi lại dữ kiện nhìn thấy.

- `VLA15-Q2-GARDEN-X1` **A:** “Luống này đất ẩm, vài lá đã lớn hơn đợt trước.”
- `VLA15-Q2-GARDEN-X2` **Evelyn:** “Ghi điều cậu thấy thôi. Đừng vội cho rằng mọi luống đều giống nhau.”
- `VLA15-Q2-GARDEN-X3` **A:** “Được, tôi để phần suy đoán riêng.”

**CHOOSE_ROUTE:** Sau ghi vườn, A tự chọn quay lại Evelyn hoặc tiếp tục theo nhánh đã có sang bờ hồ. Không yêu cầu bơi/lặn, không mở khóa đường mới, không bắt lấy mẫu sinh vật.

- `VLA15-Q2-CHOOSE_ROUTE-X1` **A:** “Tôi thấy trong bản đồ còn có bờ hồ.”
- `VLA15-Q2-CHOOSE_ROUTE-X2` **Evelyn:** “Nếu cậu đã biết đường và muốn đi, thử ghi xem cỏ ven nước khác gì ở vườn.”
- `VLA15-Q2-CHOOSE_ROUTE-X3` **A:** “Không cần mang gì về ạ?”
- `VLA15-Q2-CHOOSE_ROUTE-X4` **Evelyn:** “Không. Một dòng quan sát đủ rồi.”

**REPORT:** A quay về qua tuyến tự chọn, đưa Evelyn bản ghi. Nếu đã ra hồ: thêm dữ kiện bờ cỏ/đá và nước nông, không khẳng định loài cụ thể. Nếu không: chỉ ghi vườn, quest vẫn hoàn thành.

- `VLA15-Q2-REPORT-X1` **Evelyn:** “Cậu về rồi à? Có điều gì đáng nhớ?”
- `VLA15-Q2-REPORT-X2` **A:** “Trong vườn cây mọc thành luống; ven nước thì đất và cỏ trông khác hẳn.”
- `VLA15-Q2-REPORT-X3` **Evelyn:** “Cứ ghi thế. Đúng thứ cậu nhìn thấy là được.”

**Lựa chọn:**
- **Chỉ quan sát vườn rồi trở về:** Hoàn thành Q2, không ép khám phá hồ
- **Đi thêm ra bờ hồ và ghi chép:** Evelyn nhớ A tò mò và tự tìm đường; mở lời thoại về hồ
- **Quan sát ở bờ, không hái cây:** Không tạo vật phẩm/phá sinh cảnh hay yêu cầu xuống nước

**Nếu A làm xong:** Trang cậu ghi làm tôi muốn ra vườn thêm một lượt. Nếu đã tới hồ, tôi còn muốn nghe chuyện bờ nước.

**Nếu Evelyn tự làm:** Tôi đã tự ra vườn nhìn lại một luống. Ghi chép mới cũng đủ dùng. (không được ghi A có công.)

**Sau đó:** Evelyn tiếp tục ghi mùa vụ; lời gặp lại có biến thể nếu A từng ghé hồ, và hồ vẫn mở cho người chơi dù không nhận nhiệm vụ.

## VLA15-QF — Một trang ai cũng có thể học

**Nơi:** Kệ hạt và chỗ ghi nhãn cạnh vườn Làng A; không tự dựng thư viện hoặc phòng nghiên cứu mới

**Hoàn cảnh:** Evelyn muốn để lại một hướng dẫn ngắn giúp người khác tự phân loại hũ hạt mà không cần đợi bà.

**Thoại gốc dùng lại:** `VLA15-QF-O1` · `VLA15-QF-A1` · `VLA15-QF-C1` · `VLA15-QF-D1` (không thay câu gốc).

**SELECT:** Cùng Evelyn chọn ba điều thật sự hữu ích đã được kiểm: đọc nhãn trước khi mở, quan sát hạt trước khi cất và ghi điều chắc chắn.

- `VLA15-QF-SELECT-X1` **Evelyn:** “Mấy cuốn ghi chép dày của tôi có lẽ làm người mới ngại đọc.”
- `VLA15-QF-SELECT-X2` **A:** “Vậy chọn ba việc họ có thể thử ngay.”
- `VLA15-QF-SELECT-X3` **Evelyn:** “Ừ. Không cần kể hết mọi thứ tôi từng làm.”

**WRITE:** A xếp thứ tự ba hướng dẫn ngắn và đối chiếu với hũ thực tế; nếu đã từng quan sát hồ, có thể thêm ví dụ phân biệt môi trường nhưng không xem quan sát hồ là kiến thức hạt giống.

- `VLA15-QF-WRITE-X1` **A:** “Đầu tiên là đọc nhãn, rồi mới mở hũ.”
- `VLA15-QF-WRITE-X2` **Evelyn:** “Đúng. Còn khi không chắc?”
- `VLA15-QF-WRITE-X3` **A:** “Để riêng và hỏi lại. Không đoán.”
- `VLA15-QF-WRITE-X4` **Evelyn:** “Thế là rõ rồi.”

**TRY:** Evelyn cùng A thử làm đúng ba bước với hũ mẫu, đặt tờ hướng dẫn vào kệ chung; không buộc NPC mới xuất hiện để kiểm thử.

- `VLA15-QF-TRY-X1` **Evelyn:** “Cậu có thể làm theo tờ giấy mà không hỏi tôi không?”
- `VLA15-QF-TRY-X2` **A:** “Được. Nó ghi rõ phải xem gì trước.”
- `VLA15-QF-TRY-X3` **Evelyn:** “Vậy là người khác cũng có thể tự học được.”

**Lựa chọn:**
- **Chỉ ghi ba bước dễ làm:** Hướng dẫn dễ đọc
- **Viết dài rồi rút gọn khi thử:** Evelyn nhắc chia nhỏ thông tin
- **Nếu đã đi hồ, thêm ghi chú so sánh vườn và bờ hồ ngoài phần hướng dẫn hạt:** Ghi nhận khám phá, không đổi điều kiện hoàn thành

**Nếu A làm xong:** Tờ hướng dẫn ở kệ vẫn có người xem. Có lẽ họ chẳng cần chờ tôi rảnh nữa.

**Nếu Evelyn tự làm:** Tôi tự viết bản ngắn và thử với một hũ. Hóa ra chừng ấy đã đủ. (không được ghi A có công.)

**Sau đó:** Evelyn vẫn chăm hạt, dạo vườn, ngồi ghi chép; sau QF có thể trò chuyện về hồ hoặc mùa nếu người chơi chủ động.

## Lời gặp lại và chuyện riêng, không phải quest

### VLA15-IL1 · west_garden

- `VLA15-IL1-X1` **Evelyn:** “Hôm qua tôi thấy một hũ bị đặt nhầm chỗ.”
- `VLA15-IL1-X2` **A:** “Bà lại phải sửa nhãn ạ?”
- `VLA15-IL1-X3` **Evelyn:** “Không. Chỉ cần nhìn rồi đặt đúng chỗ thôi.”

### VLA15-IL2 · west_garden

- `VLA15-IL2-X1` **A:** “Những luống ở vườn đổi khác nhanh thật.”
- `VLA15-IL2-X2` **Evelyn:** “Mỗi lần quay lại cứ thử tìm một điều nhỏ khác hôm trước.”
- `VLA15-IL2-X3` **A:** “Tôi sẽ nhìn chậm hơn.”

### VLA15-IL3 · west_garden

- `VLA15-IL3-X1` **Evelyn:** “Tôi đang thử ghi ngắn hơn. Có lẽ người khác dễ đọc hơn.”
- `VLA15-IL3-X2` **A:** “Bà vốn viết rất kỹ mà.”
- `VLA15-IL3-X3` **Evelyn:** “Kỹ không nhất thiết phải dài.”

### VLA15-BOND · west_garden

- `VLA15-BOND-X1` **Evelyn:** “Tôi không muốn ai phải nhớ mọi điều trong đầu như tôi từng làm.”
- `VLA15-BOND-X2` **A:** “Vậy bà viết để người khác dùng được?”
- `VLA15-BOND-X3` **Evelyn:** “Ừ. Điều mình biết chỉ có ích nếu có người thử rồi hiểu.”
- `VLA15-BOND-X4` **A:** “Cả lúc họ làm khác cách của bà?”
- `VLA15-BOND-X5` **Evelyn:** “Miễn họ quan sát cẩn thận và biết sửa điều chưa đúng.”

### VLA15-POST · west_garden

- `VLA15-POST-X1` **Evelyn:** “Chào cậu. Hôm nay muốn xem hạt hay chỉ đi dạo?”
- `VLA15-POST-X2` **A:** “Chỉ đi ngang qua thôi.”
- `VLA15-POST-X3` **Evelyn:** “Thế cứ đi. Đường quanh đây cũng đáng nhìn.”

### VLA15-LAKE_OPTIONAL · approved_A1_lake_shore

- `VLA15-LAKE_OPTIONAL-X1` **A:** “Ngoài này nghe tiếng nước rõ hơn ở làng.”
- `VLA15-LAKE_OPTIONAL-X2` **Evelyn:** “Cứ ngồi nhìn cũng được. Không phải ghi chép nào cũng cần mang theo giấy.”
- `VLA15-LAKE_OPTIONAL-X3` **A:** “Bà cũng có lúc không ghi gì à?”
- `VLA15-LAKE_OPTIONAL-X4` **Evelyn:** “Có chứ. Chỉ cần nhớ mình đã thấy một ngày đẹp.”

## Hồ A1 và tự do khám phá

Hồ không còn là vùng chờ duyệt: **bờ cỏ, bờ đá, bến, lối đi từ làng, vùng nước nông/sâu, hồ lớn và cao nguyên** đều là bối cảnh đã có trong map A1 được m duyệt để phát triển kịch bản. Q2 cho A cơ hội ghi quan sát ven hồ, nhưng không buộc học bơi, không lấy rong/cá hay vào vòm đá, không cần có Evelyn đi cùng để hoàn thành. Những hành trình hồ, câu cá hoặc lặn có thể được phát triển thành các tuyến riêng sau này, không gộp ép vào Evelyn.

**Không tự xác nhận:** loài cây cụ thể ở bờ hồ, nhà riêng Evelyn, vật phẩm thưởng, lịch NPC hiện có, câu thoại đã xuất hiện trong game.

[JSON chi tiết](village-a-evelyn-playable-v1.json) · [Bản đồ A1 Superworld](https://github.com/VietCodeBug/a-place-to-belong/blob/feature/a1-superworld-slice/docs/world/A1_SUPERWORLD_PHASE21.md).
