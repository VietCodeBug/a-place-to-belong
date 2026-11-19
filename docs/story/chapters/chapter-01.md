# Chapter 01 — Một buổi sáng xa lạ

> **DRAFT · chương chưa khóa tên, nhịp và các nhiệm vụ sau cảnh đầu.**
>
> **Canon hiện có:** Sau PRO-004, nhân vật mơ thấy XXX và hóa thân thành A; ký ức đời thực mơ hồ. A có ngôi nhà cũ kỹ giữa rừng, cần được chăm sóc/sửa sang, nhưng lý do nó bị bỏ quên **chưa rõ**. Với A, ngôi nhà xa lạ nhưng có cảm giác quen mơ hồ, như thể nó đang chờ ai đó quay lại. Hành động đầu tiên: **quan sát nhà rồi bước ra ngoài**.

## Scene hiện có
| Scene | Vai trò | Kết quả | Trạng thái |
|---|---|---|---|
| [CH01-001 — Buổi sáng ở ngôi nhà xa lạ](../scenes/CH01-001.md) ([JSON](../scenes/CH01-001.json)) | Nhận quyền điều khiển, cảm căn nhà cũ, tương tác tùy chọn rồi bước ra ngoài | `ch01_first_exit_complete`; mở CH01-002 | draft |
| [CH01-002 — Bước ra ánh sáng](../scenes/CH01-002.md) ([JSON](../scenes/CH01-002.json)) | Thấy **rừng rộng, ngập nắng** trước; rồi khám phá quanh nhà và nhận ra **lối mòn mờ** gợi người từng đi qua | `ch01_outdoor_intro_complete`, mở hướng đi theo lối mòn | draft |
| [CH01-003 — Lối mòn và tiếng rìu](../scenes/CH01-003.md) ([JSON](../scenes/CH01-003.json)) | A theo lối mòn và gặp **Thomas** đang đốn củi ở bìa rừng; lời chào ngắn và các chủ đề hỏi tùy chọn | `thomas_intro_heard` nếu trò chuyện; không ép quest, tự đi tiếp hoặc về nhà | Thoại v1 đã đồng ý; dàn cảnh draft |
| [CH01-004 — Chỗ nghỉ bên đường mòn](../scenes/CH01-004.md) ([JSON](../scenes/CH01-004.json)) | Sau nơi Thomas đốn củi, A có thể tự phát hiện một chỗ nghỉ với chiếc ghế cũ được sửa một phần; không gặp thêm NPC, không nhận nhiệm vụ bắt buộc | Đi tiếp, quay lại Thomas hoặc trở về nhà; các quan sát là tùy chọn | **Đề xuất chưa duyệt** |
| [CH01-005 — Một khoảng nhỏ để bắt đầu](../scenes/CH01-005.md) ([JSON](../scenes/CH01-005.json)) | **Khi tự quay về nhà** sau khi ra ngoài, A có thể gạt lá và nhánh cây khỏi một phần bậc cửa; một thay đổi nhỏ thấy được | Không yêu cầu gặp Thomas, không buộc sửa; vẫn vào nhà hoặc khám phá tiếp | **Đề xuất mới, chưa duyệt** |
| [CH01-006 — Những mái nhà phía sau tán cây](../scenes/CH01-006.md) ([JSON](../scenes/CH01-006.json)) | Nếu tiếp tục theo lối mòn, A có thể thấy **cụm nhà nhỏ** qua rừng; dấu hiệu đời sống bằng khói bếp, phơi đồ và vườn | Không ép NPC/quest; tự tiến gần cộng đồng hoặc quay về | **Đề xuất mới, chưa duyệt** |
| [CH01-007 — Một ngày ở khu dân cư](../scenes/CH01-007.md) ([JSON](../scenes/CH01-007.json)) | **Gói nội dung thế giới mở**, không phải scene tuyến tính: tự trò chuyện, làm vườn hoặc giúp sửa đồ, ghi nhớ quan hệ | Các hoạt động độc lập; có thể từ chối/đi về; phát sinh chuyện riêng theo quan hệ về sau | **Đề xuất gameplay narrative, chưa duyệt NPC/tên** |

## Quy mô làng đầu tiên

**Đã chốt quy mô:** khu dân cư đầu tiên có **khoảng 30 cư dân**. [Hồ sơ Làng A](../locations/village-a.md) và [danh sách 30 cư dân](../characters/village-a-roster.md) vừa được thêm để xây các tuyến sống khác nhau. **Tên làng vẫn tạm**, 30 tên English mới, nhóm cư trú (11 nhà đề xuất) và tính cách mới đều **chưa duyệt**. Thomas chưa được tính vào dân số làng vì chưa chốt nơi ông sống.

**Vai trò CH01-007:** `GARDENER_01` đang được **đề xuất** là Hazel; `REPAIRER_01` được **đề xuất** là Owen. Chưa đổi mã speaker/thoại, không chỉnh đoạn Thomas đã chốt.

## Vòng chơi kể chuyện từ khu dân cư

**Hướng đã thống nhất:** đây là **game thế giới mở**, không phải chuỗi phim ngắn. Scene ID ở đây là **gói nội dung có thể gặp**, không phải điều kiện hoàn thành theo thứ tự. Khi đến khu dân cư, các hoạt động và hội thoại độc lập mở theo tình huống, mối quan hệ và việc người chơi chủ động làm. [Quy ước thế giới mở](../production/open-world-narrative-v0.md).

## Hoạt động tự do mở rộng từ Làng A

Đã chốt **hướng gameplay**: (1) vận chuyển hàng phải đi **sang làng khác**, không chỉ chuyển quanh Làng A; Ada/Hugo là phân vai dự kiến trong roster. (2) thêm **săn bắn tùy chọn** ở khu rừng, có lựa chọn theo dấu/quan sát và săn theo quy tắc sinh thái cần chốt. Hai hướng **không khóa nhau**, không bắt người chơi phải săn mới giao hàng hoặc nhận việc mới được đến làng khác. Chưa đặt tên làng đích hay loài vật. [Delivery](../activities/inter-village-delivery-v0.md) · [Hunting](../activities/hunting-v0.md).

## Ranh giới
- **Không bắt dọn/sửa ngay trong scene đầu**. Gameplay chăm nhà sẽ được thiết kế sau, không khẳng định đã tồn tại.
- Ngôi nhà **không đổ nát, không ma ám**; cảm giác "chờ ai" là tông cảm xúc, chưa là sự thật lore.
- Không tự thêm NPC, nhật ký bí mật, thư người thân, nhiệm vụ cứu rừng, hay nhân vật đã sống tại đây trước đó.
- Không quyết định ai xây nhà, ai từng sống, vì sao nó cũ, A có sẵn ký ức nào, hay kết thúc game.
- Sau khi ra ngoài, ưu tiên ngắm và khám phá rừng ngập nắng; sau đó mới thấy **lối mòn mờ**, không mở bằng thị trấn/NPC.
- **Đã chốt:** đi theo lối mòn gặp **Thomas đang đốn củi ở bìa rừng**; ông là NPC đầu tiên của tuyến mở đầu.
- **Tách thoại theo chức năng:** lần đầu giới thiệu, hỏi nhà/người quanh vùng, hỏi đường, gặp lại. Người chơi **chủ động khám phá**; Thomas không đứng giảng lore hoặc giao quest bắt buộc.
- Chưa chốt nơi ở, tuổi, nghề nghiệp thường xuyên, các quan hệ và truyện riêng của Thomas. [Hồ sơ nhân vật](../characters/thomas.md).
- Hoạt động sửa nhà chỉ được bàn/triển khai sau, không ép ở các scene này.

**Lưu ý thứ tự tự do:** CH01-004 là điểm ghé tùy chọn khi đi tiếp; CH01-005 là cảnh quay về nhà tùy chọn, **không** đòi CH01-004/Thomas làm điều kiện. CH01-006 nằm trên nhánh **tiếp tục khám phá**, không cần CH01-005 đã diễn ra. Người chơi không phải chọn vĩnh viễn giữa khám phá cộng đồng và chăm nhà. Các flag đề xuất chỉ mô tả điều thực sự quan sát/làm, chưa phải runtime.

## Các vấn đề tiếp theo để cùng chốt
1. **CH01-004 đang đề xuất** chỗ nghỉ bên đường với chiếc ghế cũ được sửa; người sáng tạo chưa duyệt. Giữ hay thay bằng dấu vết đời sống khác?
2. **CH01-005 đang đề xuất** hành động chăm bậc cửa rất nhỏ khi người chơi tự quay về. M có muốn giữ chi tiết này không, hay chọn hành động nhỏ khác trong nhà?
3. **CH01-006 đang đề xuất** cụm nhà nhỏ thấy qua tán rừng; cần duyệt địa điểm, số lượng mái nhà và có muốn cho dân cư xuất hiện từ xa hay không. Không tự đặt tên làng hay NPC.
4. **CH01-007 là bản nháp hub**. Trong bản 30 cư dân, đề xuất gắn vai chăm vườn với Hazel và vai sửa đồ với Owen; cần duyệt tên, quan hệ và hoạt động trước khi dựng.
5. Từ 30 cư dân đề xuất, chốt trước **nhóm 6–8 nhân vật tuyến sâu**, sau đó viết hội thoại/hoạt động theo lần gặp và độ quen; không phát cả 30 nhiệm vụ cùng lúc.
6. Xác định Thomas có sống trong làng không trước khi gộp ông vào tổng dân số. Xây tuyến sống riêng của Thomas và các lời nhờ phát sinh qua quan hệ.

**Liên kết:** [Nền tảng đã thống nhất](../00-foundation.md) · [Prologue](prologue.md)
