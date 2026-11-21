# Evelyn Q2 — Ví dụ một nhiệm vụ có thoại, hành động, nhánh rõ ràng (v1)

> **Bản biên kịch bàn giao, chưa phải engine code.** Không thay đổi thoại gốc đã viết, chỉ phân rõ khi nào được hiển thị. Đối chiếu [chuẩn bàn giao](../production/narrative-dialogue-handoff-contract-v1.md) và [JSON flow](village-a-evelyn-q2-flow-v1.json). Hồ A1 đã được chủ dự án duyệt làm nơi khám phá, nhưng nhiệm vụ này **không bắt** người chơi tới hồ.

## Tình huống thật

Evelyn đang ở vườn phía tây Làng A, xem cuốn sổ còn thiếu ghi chép. Khi A đã quen và từng ghé hỏi chuyện sau nhiệm vụ trước, **A có thể tự hỏi** về cuốn sổ. Nếu Evelyn bận, vắng mặt hoặc chưa đủ thân, **không phát lời nhờ**.

**Điều kiện tham khảo:** Q1 đã hoàn thành hoặc Evelyn đã tự giải quyết; tối thiểu một lần gặp đời thường sau Q1; mức thân >=50/100 *chỉ là đề xuất cân bằng*; Evelyn thực sự có mặt. Không tự nhận nhiệm vụ khi đi ngang.

## Diễn biến theo lựa chọn

### 1. Người chơi chủ động nói chuyện

**NPC nói (chỉ khi đủ điều kiện, `VLA15-Q2-O1`, Evelyn):**

> Cuốn sổ của tôi thiếu một ghi chú từ ngoài vườn. Cậu muốn thử quan sát rồi kể lại không?

**Menu của A:** "Tôi giúp bà quan sát" / "Hôm nay tôi không giúp được" / "Để khi khác nhé".

- **Đồng ý:** sau khi bấm lựa chọn, A mới nói câu gốc `VLA15-Q2-A1` và quest đổi sang `accepted`.
- **Từ chối:** Evelyn nói đúng câu gốc `VLA15-Q2-D1`, quest đổi sang `declined`, cuộc trò chuyện kết thúc. Không phát câu hoàn thành.
- **Để sau:** thoát hội thoại, không đổi trạng thái nhiệm vụ và không phạt quan hệ.

### 2. A thực sự quan sát vườn

**Hành động trong thế giới (KHÔNG phải thoại):** người chơi tự đến luống vườn, tương tác với cây/đất và ghi lại điều nhìn thấy. Chỉ sau khi hệ thống kiểm được event quan sát, `garden_observed=true`.

**Menu tùy chọn sau khi ghi vườn:** "Mang ghi chép về cho Evelyn" / "Đi dạo tới bờ hồ và ghi thêm nếu muốn" / "Làm việc khác trước".

- Chọn về luôn: A **chưa** nhìn thấy hồ, không được nói về ven nước.
- Nếu tự đi hồ: A quan sát cỏ/đất ven bờ bằng thao tác thực; sau đó `lake_observed_during_quest=true`. Không bắt bơi/lặn hoặc Evelyn phải đi theo.
- Nếu A đi chơi giữa chừng: quest vẫn ở trạng thái dở, không tự hoàn thành.

### 3. A quay lại báo cáo (hai nhánh không thể nhập nhằng)

Evelyn chỉ nói khi A **chủ động mở chủ đề báo cáo và bà có mặt**. Bắt đầu bằng câu gốc `VLA15-Q2-REPORT-X1` của Evelyn:

> Cậu về rồi à? Có điều gì đáng nhớ?

**Nhánh chỉ quan sát vườn** — `lake_observed_during_quest=false`: A nói **câu mới đã tách** `VLA15-Q2-REPORT-GARDEN-A1`:

> Tôi chỉ quan sát luống vườn. Đất vẫn ẩm, vài chiếc lá đã lớn hơn.

**Nhánh đã quan sát hồ** — `lake_observed_during_quest=true`: A nói **câu có sẵn** `VLA15-Q2-REPORT-X2`:

> Trong vườn cây mọc thành luống; ven nước thì đất và cỏ trông khác hẳn.

Cả hai nhánh dùng `VLA15-Q2-REPORT-X3` của Evelyn, rồi lời kết gốc `VLA15-Q2-C1` **chỉ khi ghi chép vườn đã được làm và báo cáo hợp lệ**:

> Rất tốt. Người sau đọc sẽ biết cậu đã thấy gì.

**Chỉ lúc này** mới đánh dấu `Q2.status=completed`. Không mở QF ngay sau cuộc nói chuyện.

### 4. Khi Evelyn làm việc một mình

Nếu A từ chối và Evelyn tự quan sát sau này, trạng thái là `resolved_without_player`, **không phải** `completed`. Lời gặp lại phải phản ánh bà đã tự làm, và cờ `garden_observed` của người chơi không được tự bật.

## Tập kiểm thử để AI lập trình xác nhận

| Trường hợp | Điều bắt buộc | Điều tuyệt đối không được xảy ra |
|---|---|---|
| A chỉ ghi vườn | Hoàn thành được Q2 | A tự kể đã thấy hồ |
| A ghé hồ rồi ghi | Ghi `lake_observed_during_quest=true`, dùng nhánh hồ | Ép bơi hoặc lấy mẫu |
| A từ chối | Evelyn nói lời từ chối rồi tiếp tục sinh hoạt | Quest hoàn thành chỉ do bấm thoại |
| A chưa đủ thân | Không có lời nhờ mới | Tự nhận Q2 khi gặp NPC |
| Evelyn không có mặt | Không phát câu của bà | Evelyn nói vọng từ xa |

## Lưu ý khi lập trình

Đây là **script/spec**, không phải cấu hình game chạy được. Đường dẫn node Godot, controller nhiệm vụ, asset tương tác, hệ tính điểm và lịch NPC còn là `TO_BIND`. Nếu engine chưa có event tương ứng, phải báo thiếu chứ không đọc đoạn mô tả như lời dẫn của NPC.

**Dữ liệu thực thi tham khảo:** [flow JSON](village-a-evelyn-q2-flow-v1.json). Tài liệu này cố ý tách câu nói khỏi hành động để AI khác có thể map đúng UI/gameplay.
