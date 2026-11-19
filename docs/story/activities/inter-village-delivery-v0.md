# Gói hoạt động — Vận chuyển hàng giữa các làng (VLA-DELIVERY-v0)

> **Đã chọn về hướng gameplay:** “Trao đồ” của Ada phải phát triển thành **vận chuyển hàng từ Làng A sang làng khác**, tạo lý do đi đường dài, khám phá vùng mới và kết bạn ngoài Làng A.
>
> **CHƯA CHỐT:** tên và vị trí làng đích, số làng, tuyến đường cụ thể, phương tiện, hệ tiền tệ, thời gian di chuyển, người nhận, phần thưởng, lịch trình giao hàng. **Không coi làng thứ hai đã xây hoặc đã có cư dân**. Ada / Hugo là tên tiếng Anh **đề xuất trong roster 30 người**, chưa canon riêng. Mã địa điểm đích tạm: `VILLAGE_DEST_TBD`.

## Tầm nhìn biên kịch

Người chơi không chạy việc giao hàng trong cùng một vòng sân; một chuyến hàng thật có **điểm xuất phát, người gửi, một tuyến vượt khỏi Làng A, một nơi nhận ở làng khác và một cuộc gặp mới**.

Vòng đời của chuyện này là: thấy Ada chuẩn bị đường xa → tò mò hỏi → Hugo giúp kiểm giỏ/xe → khi có làng đích và tuyến đường được biên kịch duyệt, nhận một kiện hàng → tự chọn lộ trình → phát hiện dấu mốc trên đường → gặp người nhận → bàn giao → NPC nhớ cách A xử lý. **Người chơi có thể từ chối và đi khám phá mà không mang hàng.**

Điều hấp dẫn không chỉ là trả hàng mà là *người ta có cuộc sống liên kết với nhau giữa các làng*, mỗi chuyến mở thêm tuyến xã hội/địa lý.

## Những người đã có trong hồ sơ Làng A

- **Ada (`VLA-18`)**: trong roster nháp đang đi trên lối mòn, mang đồ trao tay, tò mò về bên ngoài. Đây là **đầu mối đề xuất** cho tuyến giao hàng liên làng; không tự chốt Ada làm bưu tá chính thức.
- **Hugo (`VLA-19`)**: chăm xe đẩy và dây buộc hàng; phù hợp để giới thiệu **chuẩn bị hành trang và kiểm kiện** chứ không phải một NPC chỉ có chức năng bán phương tiện.
- **Peter (`VLA-17`)**: vẫn giữ vai trò chuyển giỏ và đồ **giữa các nhà trong Làng A**, phân biệt với Ada mở tuyến **liên làng**; không xóa công việc đời thường của Peter.
- **Người nhận ở làng đích**: `RECIPIENT_TBD`, **chưa đặt tên**, chưa bổ sung vào 30 dân Làng A.

## Tầng hoạt động — tiến theo khám phá, không khóa cả game

### DEL-00 — “Chuyện bên những kiện hàng” (có thể có ngay tại Làng A)
A thấy Ada kiểm các bọc hàng, Hugo kiểm dây buộc/xe. Người chơi **được hỏi**, có thể giúp thắt và kiểm kiện như một hoạt động chung. **Chưa phát nhiệm vụ liên làng vì chưa biết có tuyến đường nào/đích đến nào chính thức**. Có thể bỏ qua, không ngăn hoạt động khác.

### DEL-01 — “Chuyến đi bên ngoài rừng” (chỉ khi làng đích đã được duyệt)
Ada đang cần đưa một kiện hàng **từ Làng A đến một người ở làng khác**. A tự hỏi và có quyền nhận. Điều kiện tối thiểu:
- Làng đích và **người nhận đã được xác định thật trong câu chuyện**.
- Đường nối hai làng có thể đi, và **có ít nhất một khám phá đáng nhớ trên tuyến**; không teleport giao kiện ngay.
- Kiện hàng có nội dung phù hợp với người gửi/nhận (ví dụ đồ thủ công, hạt giống, vật dụng), **phải chốt từng chuyến**.
- Không phát sinh nhiệm vụ chỉ vì người chơi nhìn thấy Ada hoặc bước tới bản đồ.

**Trong chuyến:** người chơi chuẩn bị/nhận kiện, mang hàng theo tuyến đã chọn, có thể dừng khám phá cảnh quan, quan sát dấu đường; hàng được ghi nhận đang mang. Điểm đến là một làng khác, không phải góc đường trong Làng A.

**Khi tới làng mới:** nếu A chưa từng đặt chân tới, cái nhìn đầu tiên cho phép A **tự khám phá**. Người nhận có thể hướng dẫn ngắn tới nhà/khu sinh hoạt, nhưng không đọc lịch sử làng. Chuyện với người nhận mở ra một quan hệ mới, không tự nâng thân thiện Làng A.

**Khi giao:** cần hành động trao kiện thực tế cho `RECIPIENT_TBD`; chỉ lúc này nhiệm vụ được xác nhận hoàn tất. Đến ranh giới làng đích chưa đủ.

### DEL-02 — “Đường quen, những người quen” (đề xuất tương lai)
Sau vài lần A thật sự đi được tuyến đường và quen cư dân ở hai làng, có thể có nhiều kiểu kiện/hẹn, điểm trung chuyển hoặc người khác nhờ. **Không mở dựa vào spam lời chào hoặc đạt số điểm tình bạn đơn thuần**.

## Kịch bản hội thoại mẫu — tiếng Việt, tên NPC tiếng Anh đề xuất

- `DEL-ADA-01` **Ada** (nếu A hỏi về những kiện hàng): “Mấy món này không phải để trong làng đâu. Chúng phải đến tay người ở xa hơn.”
- `DEL-A-02` **A**: “Cậu thường đi sang làng khác à?”
- `DEL-ADA-03` **Ada**: “Có lúc. Tôi nhớ đường khá tốt, nhưng vẫn có những lối chưa từng thử.”
- `DEL-HUGO-01` **Hugo** (khi A đề nghị kiểm kiện): “Đi đường xa thì buộc chắc một chút. Không ai thích tới nơi rồi mới biết thiếu đồ.”
- `DEL-ADA-04` **Ada** (chỉ khi có **tuyến đích thật** và nhiệm vụ đủ điều kiện): “Tôi có một kiện cần gửi sang bên kia. Cậu có muốn nhận giúp chuyến này không?”
- `DEL-ADA-05` **Ada** (người chơi từ chối): “Được thôi. Tôi sẽ thu xếp cách khác.”
- `DEL-RECIPIENT-01` **Người nhận chưa đặt tên** (khi *thực sự* trao kiện): “À, đúng món tôi đang đợi. Cảm ơn cậu đã mang tới.”

**Không tự chốt** những câu trên thành lời thoại chính thức giống Thomas v1.

## Trạng thái biên kịch (hướng dẫn AI lập trình, chưa có code)

- `route_discovered`: đã tự nhận ra lối nối hai địa điểm. Không đồng nghĩa `delivery_completed`.
- `delivery_request_offered` khác với `delivery_request_accepted`. Chỉ có nhiệm vụ sau khi chọn nhận.
- `package_picked_up`: đã nhận kiện. Không được giả định đã nhận khi chọn lời thoại.
- `destination_reached`: tới làng đích. Chưa hoàn thành giao.
- `package_handed_over`: người nhận xác nhận; **đây mới là điều kiện hoàn thành**.
- `delivery_declined`: người chơi từ chối; Ada có phương án khác, không trừ tình bạn nặng.
- `delivery_unfinished`: chưa giao; có cách tiếp tục/hủy rõ, không tự bốc hơi kiện.
- `recipient_met`, `receiver_remembers_A`: chỉ khi A thật sự tương tác, không tự tạo quan hệ với 30 cư dân Làng A.

## Cách tạo động lực khám phá làng mới

Một chuyến hàng nên có **tối thiểu một phần thưởng không phải tiền**: biết thêm con đường, cảnh quan, người quen, câu chuyện, địa điểm có thể quay lại, sản phẩm đặc trưng của vùng. Đừng dùng một chuỗi "nhận → teleport → giao → +coin" để thay thế hoạt động khám phá.

**Không khóa quyền vào làng mới sau một nhiệm vụ:** người chơi vẫn có thể tự tìm đường dù không từng nhận hàng. Nhiệm vụ là **lý do hợp lý để đi**, không phải giấy phép duy nhất để qua cổng.

**Giới hạn:** không xác nhận làng mới đã có; không chọn đường núi/suối/cầu/chợ, phương tiện, tên đồ, hội thoại của người nhận trước khi cùng duyệt.
