# Quy chuẩn kịch bản để AI khác không đọc lời dẫn thành lời thoại — v1

> **DRAFT — quy chuẩn bàn giao biên kịch, không phải code Godot.** Áp dụng cho các file dưới docs/story; không ghi đè lời thoại đã duyệt. Đây là tài liệu dành cho AI triển khai game, **không phải văn bản hiển thị trong game**.

## Lỗi đã xác định trong các file hiện tại

- Markdown đang đặt chỉ dẫn như **LOOK: quan sát**, **Nếu giúp:**, **Sau đó:** lẫn với lời nhân vật. Một số dòng chỉ là ghi chú biên kịch nhưng chưa gắn kiểu nội dung, dễ bị AI đọc như thoại.
- JSON tuy có speaker_id nhưng thiếu **trigger cho từng câu/nhánh**: lời thoại một beat thường chỉ là một mảng theo thứ tự, không quy định khi nào bật, A có chọn nói hay không.
- Các file cùng loại dùng keys không đồng nhất (beats[].lines / beats[].dialogue, interludes[].lines / interludes[].dialogue, file còn có talk). Không được suy đoán chúng có thể chạy bằng một parser chung.
- Ví dụ có lỗi thật: Evelyn Q2 cho chọn chỉ xem vườn, nhưng câu REPORT-X2 lại nhắc tới **ven nước** kể cả khi A chưa tới hồ.

## Phân loại nội dung bất khả nhầm

| type | Ý nghĩa | Có phát thành tiếng/lời NPC? |
|---|---|---|
| SCENE_CONTEXT | Tả vị trí, tâm trạng, ánh sáng, thói quen | **KHÔNG** |
| WORLD_ACTION | Người chơi phải thao tác vật thể/đi tới nơi; cần event xác nhận | **KHÔNG** |
| PLAYER_CHOICE | Một nút lựa chọn do người chơi tự chọn | **KHÔNG tự đọc** |
| PLAYER_LINE | Lời A phát ra, chỉ khi trigger tương ứng | **CÓ nếu được duyệt** |
| NPC_DIALOGUE | Lời NPC, bắt buộc có speaker_id + line_id + trigger | **CÓ khi guard đúng** |
| STATE_TRANSITION | Sửa flags, quest status, thay đổi thế giới | **KHÔNG** |

**Các trường mô tả** (context_vi, ambient_vi, action_vi, result_vi, designer_notes, stage, title) **KHÔNG bao giờ là lời thoại**. Chỉ các node NPC_DIALOGUE/PLAYER_LINE mới có text cần đọc. PLAYER_CHOICE là menu chứ không bắt A tự nói.

## Yêu cầu tối thiểu cho mọi node

- Mỗi câu thoại có ID ổn định, speaker_id, text hoặc line_id và **event trigger rõ ràng**. NPC phải có mặt, không tự phát lời thoại xuyên bản đồ.
- Dòng ID tham chiếu như VLA15-Q2-O1 cần tra từ arc gốc để lấy đúng text; **không đọc chuỗi ID** và không invent lời khác.
- Mỗi bước hành động có event_to_enter, action_required và on_success; không chạy LOOK → CHOOSE → REPORT thành một cutscene tự tiến.
- Mỗi nhánh có guard; nếu chưa quan sát hồ không được kể đã thấy hồ. Nếu NPC tự làm, không được cảm ơn A.
- Có lựa chọn Rời đi và từ chối. Không chặn khám phá hoặc ép người chơi nhận quest.
- Q1/Q2/QF là ba nhiệm vụ khác nhau mở theo quan hệ + cuộc gặp thường + tình huống, không phải ba lần bấm trò chuyện liên tiếp. Điểm 20/50/80 chỉ là **đề xuất cân bằng**.
- ID và đối tượng runtime Godot chưa biết để TO_BIND; không bịa node path, quest engine hoặc model chưa có.

## Hướng dẫn đọc cho AI triển khai game

1. Đọc DOC/MD cũ để hiểu tình huống, tâm lý, logic; **không đưa nguyên Markdown lên màn hình**.
2. Lấy nội dung nói thực tế từ kho dialogue line; phân loại từng câu theo sự kiện. Với thoại nhánh mới, phải có ID và điều kiện riêng.
3. Chỉ triển khai node có nhãn runtime rõ ràng; nếu chưa có đối tượng/nút tương tác ở map, ghi **unbound** và báo phần cần bổ sung; không tự nói hoàn thành.
4. Chạy ít nhất hai đường kiểm thử (đã quan sát hồ và chưa quan sát hồ), thêm nhánh từ chối/tự giải quyết. Xem [pilot Evelyn Q2](../quests/village-a-evelyn-q2-flow-v1.md).
5. Mỗi line_id phải resolve đúng duy nhất một câu. Không cho phát thoại A tự động trừ khi có node PLAYER_LINE rõ ràng.

## Checklist trước khi chấp nhận

- [ ] Không lời dẫn nào bị biến thành subtitle hay voice NPC
- [ ] NPC và A chỉ nói câu ứng với trạng thái thực
- [ ] Không phát câu thuộc lựa chọn chưa được chọn
- [ ] Không thể xong nhiệm vụ bằng cách bấm qua hội thoại nếu chưa thực hiện hành động
- [ ] NPC vắng mặt thì không có câu của NPC
- [ ] Không tự phát nhiệm vụ tiếp theo trong cùng lượt gặp
- [ ] Từ chối hoặc NPC tự xử lý vẫn có nhánh tiếp diễn
- [ ] Bản đồ hồ A1 là nơi khám phá đã duyệt; lịch NPC/quest ở hồ chỉ là đề xuất

**Tình trạng:** đây là chuẩn đề xuất v1 để chuyển đổi dần 24 nhiệm vụ, chưa có runtime parser được chứng minh. Không được tuyên bố những file playable-v1 cũ đã chạy đúng.
