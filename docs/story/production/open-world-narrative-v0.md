# Thiết kế biên kịch thế giới mở — A Place to Belong (v0)

> **ĐỊNH HƯỚNG ĐÃ THỐNG NHẤT:** Sau phần mở đầu, đây là game thế giới mở về khám phá, sinh hoạt và gắn bó với người khác; không phải bộ phim có các cảnh bắt người chơi xem theo thứ tự.
>
> **Dữ liệu bên dưới là ĐỀ XUẤT BIÊN KỊCH CHƯA DUYỆT CHI TIẾT**, dành cho AI lập trình triển khai khi người sáng tạo chọn. Không chỉnh code hay model. Tất cả thoại bằng tiếng Việt; **tên nhân vật chính thức phải bằng tiếng Anh khi được duyệt**. A là ký hiệu tạm; Thomas là tên duy nhất đã được chốt trong tuyến này.

## Nguyên tắc quan trọng

### 1. Tách **thứ tự chương truyện** khỏi **thứ tự người chơi hành động**

PRO-001 → PRO-004 và lần đầu A thức dậy là một phần mở đầu có thứ tự. Kể từ khi A được thả vào khu rừng, **chapter chỉ là nhóm nội dung**, không phải danh sách nhiệm vụ phải thực hiện tuần tự.

```text
                   NHÀ A
                 ↗   ↑   ↖
       CHĂM NHÀ    |    ĐI KHÁM PHÁ
                 ↘   |   ↙
               KHU RỪNG
                 ↙     ↘
       THOMAS             KHU DÂN CƯ
      (gặp/gúp)         /     |      \
                   LÀM VƯỜN  SỬA ĐỒ  HỎI CHUYỆN
                        \      |      /
                          QUAN HỆ
                              ↓
                    CÂU CHUYỆN CÁ NHÂN
                     (chỉ mở khi phù hợp)
```

Lối mòn, Thomas, khoảng nghỉ, và bậc cửa có thể **tồn tại song song**; không kiểm tra `CH01-004_completed` hoặc `CH01-005_completed` để cho tới khu dân cư.

### 2. Mỗi địa điểm có ít nhất **một điều người chơi chủ động làm**

Không bắt buộc mọi địa điểm phải có quest; nhưng ít nhất một vài hành động có **kết quả nhìn thấy hoặc được người khác nhớ**:
- Nhặt nhánh cây khỏi lối vào nhà: bậc cửa khác trước.
- Quan sát Thomas đốn củi hoặc chọn bắt chuyện: có/không có quan hệ, không ép phụ chặt.
- Khu dân cư: tự hỏi chuyện, đề nghị tham gia một công việc nhỏ, thấy thành quả, người kia nhớ lần giúp đó.
- Rừng: tự khám phá lối mòn/địa điểm, có thể quay về mà không bị coi là bỏ nhiệm vụ.

### 3. Phân biệt chuyện thường và **nhiệm vụ phát sinh**

| Nhãn | Khi nào có | Có tự thêm vào nhật ký nhiệm vụ không? |
|---|---|---|
| `social_talk` | Người chơi chủ động chào/hỏi | Không |
| `shared_activity` | Thấy NPC đang làm; người chơi đề nghị tham gia | Không cần; có thể hướng dẫn trực tiếp |
| `request_offered` | NPC nêu một việc nhờ cụ thể, phù hợp quan hệ và hoàn cảnh | **Chưa**, người chơi có quyền từ chối |
| `request_accepted` | Người chơi nói đồng ý | **Có thể**, nếu là nhiệm vụ dài |
| `world_discovery` | Người chơi tìm thấy dấu hiệu mới | Chỉ ghi khám phá, không đổi thành quest bắt buộc |
| `relationship_event` | Có trải nghiệm chung và quyết định mang ý nghĩa | Ghi nhận điều đã xảy ra, không bắt phải xem cutscene dài |

### 4. Hệ quan hệ là ký ức về hành động, không chỉ thanh điểm

**Các giai đoạn đề xuất (không phải số điểm bắt buộc):**
- `stranger`: chưa chào, NPC không biết tên A.
- `acquaintance`: đã gặp và trao đổi; có thể chào lại, hỏi việc đang làm.
- `familiar`: đã có hoạt động chung **và** được gặp lại; có thể nói chuyện thân mật hơn.
- `trusted`: chỉ khi người chơi cùng trải qua một sự kiện có ý nghĩa được biên kịch riêng; không đạt chỉ bằng spam lời chào.

Đặc biệt, `friendliness` (mức thân thiện trong giao tiếp) và `trust` (tin cậy) **không đồng nghĩa**. Một nhân vật có thể quý A mà vẫn chưa kể chuyện gia đình, hoặc A từng làm giúp việc mà chưa thành bạn.

**Đề xuất dữ liệu trạng thái:**
`met`, `intro_heard`, `talk_topics_seen`, `shared_activities`, `help_promised`, `help_completed`, `help_declined`, `revisited_after_help`, `trust_events`. Không công nhận quan hệ khi việc chỉ nằm trong hội thoại.

### 5. NPC không phải máy phát nhiệm vụ

- NPC có việc **đang làm trước khi A tới**, không đứng bất động với dấu chấm than.
- Không làm vẫn có kết quả tự nhiên: người chăm vườn tiếp tục chăm, người sửa đồ tự sửa chậm hơn; không khiến thế giới bị đóng băng.
- Khi A đề nghị giúp thì **có thao tác thật và dấu thay đổi**, thay vì tự chuyển đến cảnh hoàn thành.
- Không biến từ chối thành phán xét đạo đức hoặc trừ điểm nặng.
- NPC nhớ sự hỗ trợ và có thể đổi lời chào. Những câu chuyện riêng **chỉ viết/mở khi nhân vật đã có hồ sơ và tình huống phù hợp**.

## Đợt nội dung tiếp theo nên viết theo cụm, không theo hàng dài scene

**Gói HUB-01: Lần đầu đến khu dân cư** (xem [CH01-007](../scenes/CH01-007.md)):
- Vài NPC sinh hoạt trong một không gian chung; **tên, tuổi, lịch sử chưa được chốt**.
- Hai hoạt động mẫu: giúp chăm một góc vườn và giúp giữ chi tiết khi người khác sửa đồ; hai hoạt động **độc lập**.
- Nói chuyện và gặp lại phản ứng theo việc đã làm.
- Không ép phải gặp hết NPC hoặc hoàn thành hoạt động trước khi rời khu nhà.

**Gói HUB-02: Những lần quay lại (chưa viết):** lời chào theo trạng thái, nhân vật bận/rảnh, hoạt động khác vào lần sau. Không mặc định cơ chế ngày đêm đã được xây.

**Gói HUB-03: Câu chuyện cá nhân (chưa viết):** chỉ mở sau khi có đủ sự kiện quan hệ; có lựa chọn, một chi tiết thay đổi hoặc một lời hứa, không phải 10 nhiệm vụ thu thập.

**Gói NHÀ-A (đang nháp CH01-005):** hành động tự chăm nhà, thay đổi vật thể; không làm yêu cầu để mở khu dân cư.

## Quy tắc kiểm tra một nhiệm vụ trước khi duyệt

1. **Nguồn cơn:** NPC hoặc thế giới thật sự đang gặp việc gì?
2. **Hành động:** người chơi phải làm gì trên bản đồ (không chỉ chọn “Đồng ý”)?
3. **Từ chối:** không giúp thì NPC có cách sống tiếp không?
4. **Hệ quả:** có chi tiết trong thế giới hoặc quan hệ thay đổi không?
5. **Nhắc lại:** khi người chơi quay lại, NPC có nhớ trạng thái thay vì phát nguyên thoại cũ không?
6. **Thời điểm mở:** có nên chờ thân hơn hoặc dịp khác? Cảnh có chơi được nếu người chơi chưa đến Thomas/nhà không?

Nếu thiếu quá nhiều điểm trên, đó mới chỉ là **ý tưởng phim/cutscene**, chưa là hoạt động game hoàn chỉnh.

## Không tự quyết trong tài liệu này
- Tên English của hai cư dân tiếp theo, giới tính/tuổi, gia đình, nghề chính, lịch sinh hoạt, số nhà, tên làng.
- Công thức friendship point, tiền thưởng, stamina, vật phẩm, quyền sử dụng đồ người khác.
- Quy luật ngày/đêm và có tiếp nối qua nhiều giấc mơ hay không.
- Giải thích nguồn gốc XXX và A.
- Hệ thống café/bưu điện/xe đạp có mở ngay hay không.

**Mục tiêu:** chuyển hoạt động thành các câu chuyện nhỏ có thể diễn ra **bất kỳ thứ tự hợp lý nào**, không làm người chơi có cảm giác phải hoàn thành từng tập phim.
