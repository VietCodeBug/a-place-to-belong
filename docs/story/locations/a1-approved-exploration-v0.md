# A1 — Địa lý đã đối chiếu và quy tắc viết nhiệm vụ theo bản đồ mới

> **Mục đích:** biên kịch dùng đúng các địa điểm người chơi đã có thể đi trong bản đồ mới. **Đã được người sáng tạo duyệt:** hồ A1 là điểm khám phá chính thức (ngày 21/11/2026). **Chưa được tự xem là đã duyệt:** toàn bộ chất lượng hình ảnh hoặc hành vi NPC trong bản thử nghiệm. Đây không phải nhiệm vụ sửa map/code.

## Hai nguồn kỹ thuật đã đọc

- **Làng A:** nhánh [`feature/village-a-world` tại `9cf0f45`](https://github.com/VietCodeBug/a-place-to-belong/tree/9cf0f45397e8f25aad6cf626bb0f3bd4d41bb14d) và [quy hoạch](https://github.com/VietCodeBug/a-place-to-belong/blob/9cf0f45397e8f25aad6cf626bb0f3bd4d41bb14d/docs/environment/VILLAGE_A_MASTERPLAN.md): sân chung (5.2,128), vườn tây (−7.8,120), sân thủ công phía đông (16.1,128.1), khu A05 (21.8,128.1), 21 lô ngoại thất thử, bốn ngõ thông nhau và hành lang rừng/cầu tới Làng A. Nhà A tách sâu vào rừng, không nhất thiết nhìn thấy từ làng.
- **Hồ và vùng khám phá lớn:** nhánh [`feature/a1-superworld-slice` tại `ab420bf`](https://github.com/VietCodeBug/a-place-to-belong/tree/ab420bf4e565e4d1ae807c6afb0884aaa5b95167) — [bản hồ và sinh cảnh](https://github.com/VietCodeBug/a-place-to-belong/blob/ab420bf4e565e4d1ae807c6afb0884aaa5b95167/docs/world/A1_SUPERWORLD_PHASE21.md) và [lát cắt vùng A1](https://github.com/VietCodeBug/a-place-to-belong/blob/ab420bf4e565e4d1ae807c6afb0884aaa5b95167/docs/world/A1_SUPERWORLD_SLICE.md). Hồ có bờ cỏ, bờ cát/đá, lối bến và đường nối về làng. Các khu rừng, đồng hoa, cao nguyên và nước sâu là địa hình đang có trong branch; chỉ **hồ** đã được chủ dự án duyệt cụ thể trong cuộc trao đổi này.

## Cách sử dụng cho cốt truyện

1. **Không gian tự do**: người chơi có thể tới hồ bằng đường khám phá, không cần nhận việc từ NPC hoặc đạt điểm thân thiết.
2. **Kết nối có lý do**: Evelyn có thể gợi ý tự quan sát bờ nước sau khi xem vườn; Maeve có thể có ngày nghỉ ở hồ khi đã quen thân. Những **tình tiết mới là đề xuất**, không phải spawn schedule của bản game.
3. **Giữ khung quan hệ**: nhiệm vụ 1 → lần gặp không nhiệm vụ → nhiệm vụ 2 → hai lần gặp và tâm sự → nhiệm vụ cuối. Đi hồ **không thay thế** các điều kiện quan hệ và không tăng điểm vô hạn.
4. **Không ép bơi/lặn**: các nhiệm vụ của Maeve/Evelyn chỉ dùng đường bộ và bờ hồ, tránh biến khả năng bơi chưa hoàn thiện animation thành điều kiện để mở quan hệ.
5. **Không tự thêm lore**: dưới hồ có vùng lặn và vòm đá trong map; chưa có bằng chứng để gán kho báu, nguồn gốc giấc mơ, thần linh hoặc bí mật cho các địa hình này.
6. **Không nhập nhằng tiến độ kỹ thuật**: người sáng tạo **duyệt địa điểm hồ**, không đồng nghĩa bản A1 Superworld đã được merge vào game phát hành, code NPC có lịch đi hồ, hoặc performance/mỹ thuật mọi khu đều pass.

## Hướng viết về sau

Sử dụng bờ hồ cho các cuộc trò chuyện bình thường, khám phá thiên nhiên, câu cá khi có gameplay được chốt, hoặc các sự kiện quan hệ không bắt buộc. Cao nguyên/đồng hoa có thể được cân nhắc trong tuyến NPC sau này nhưng phải bám bản đồ thật và không biến mọi nhiệm vụ thành di chuyển xa.
