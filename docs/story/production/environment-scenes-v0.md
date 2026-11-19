# Hồ sơ bối cảnh đợt 1 — Những nơi người chơi đi qua

> **Tài liệu BIÊN KỊCH cho bản dựng thử 3D**, không phải yêu cầu vẽ/model/code. Các chi tiết được đánh dấu **[ĐÃ CHỐT]** xuất phát từ những lựa chọn đã xác nhận. **[ĐỀ XUẤT DỰNG THỬ]** là cách tổ chức không gian để các cảnh nối nhau có logic; người sáng tạo chưa duyệt bố cục cuối, kích thước, phong cách kiến trúc chi tiết.
>
> **Phạm vi:** PRO-001 → PRO-004 → CH01-001 → CH01-002 → CH01-003; bổ sung **CH01-004 (đề xuất mới, chưa duyệt)**. **Tên nhân vật dùng tiếng Anh:** Thomas đã chốt; A là ký hiệu tạm. Không tự đặt tên công ty, thành phố, địa danh, chủ nhà, cư dân mới, họ của Thomas hoặc quá khứ của A.
>
> **Mục đích của tài liệu:** cho người dựng 3D hiểu **ở đâu, có những gì, vật nào cần xuất hiện trong khung nhìn, người nào đang làm gì, và không gian thay đổi thế nào qua câu chuyện**. Không đặt các yêu cầu về polygon, kích cỡ chính xác, texture, phối màu kỹ thuật, camera engine hoặc nhiệm vụ chưa được phê duyệt. Phần Prologue có thể thể hiện bằng truyện tranh; đây vẫn là **cùng một không gian trong truyện**, không phải yêu cầu dựng mọi cảnh 3D.

## Bản đồ không gian và dòng thời gian

```text
PRO-001: Màn hình tin tức / các lát cắt đời sống
                 ↓  (văn phòng được nhìn thoáng qua)
PRO-002: CÙNG VĂN PHÒNG — bàn làm việc của nhân vật → nhận email → rời bàn
                 ↓
PRO-003: CĂN HỘ THUÊ — cùng một phòng, ba thời điểm / ba tình trạng
                 ↓
PRO-004: CÙNG CĂN HỘ — bên giường → thiếp đi → màn tối
                 ↓
CH01-001: CĂN NHÀ GỖ CŨ TRONG RỪNG — bên trong → cửa chính
                 ↓
CH01-002: NGAY NGOÀI CỬA — rừng ngập nắng → khoảng sáng → lối mòn mờ
                 ↓
CH01-003: THEO LỐI MÒN — bìa rừng có Thomas đang đốn củi
                 ↓  (CH01-004 là bản nháp mới)
CH01-004: CHỖ NGHỈ BÊN ĐƯỜNG — dấu vết được chăm sóc, có thể quay về
```

- **Bốn khu vực có thể nhận diện:** (1) văn phòng, (2) căn hộ thuê, (3) nhà cũ và phần rừng trước nhà, (4) bìa rừng nơi Thomas làm việc. Rừng và bìa rừng là **những không gian liền mạch**, không mặc định là hai map khác nhau.
- Không gian cũ **không tự biến hình** giữa các cảnh trừ khi chính nội dung đã nói thời gian trôi qua.

---

## ENV-REAL-01 — Văn phòng của nhân vật (PRO-001 cuối cảnh → PRO-002)

### Bản chất và cảm giác
**[ĐÃ CHỐT]** Một văn phòng hiện đại, ngày làm việc tưởng bình thường. Nhân vật **nhận email chấm dứt công việc tại bàn làm việc ở văn phòng**, không phải ở nhà. Cùng lúc ấy các đồng nghiệp vẫn hoạt động như không có chuyện gì. Bi kịch diễn ra âm thầm, không phải văn phòng hoang phế hay nơi hỗn loạn.

**[ĐỀ XUẤT DỰNG THỬ]** Một khu làm việc chung có cửa ra hành lang, lối đi giữa các dãy bàn, một vài cụm bàn nhân viên, cửa sổ nhìn ra thành phố không định danh. Chỉ cần dựng **một góc tầng văn phòng đủ nhìn thấy những người khác**; không cần tòa nhà nguyên khối, phòng họp đầy đủ hay sảnh công ty.

### Bố cục không gian — từ cửa bước vào
1. **Lối tiếp cận / hành lang:** Cửa dẫn vào khu nhân viên; phía trong thấy vài người đang làm việc. Đây là điểm ra cuối cảnh PRO-002 nếu cần thấy nhân vật bước đi.
2. **Lối đi chung:** Dọc các bàn nhân viên, đủ để nhận ra văn phòng không ngừng vận hành.
3. **Bàn làm việc của nhân vật:** Nằm **trong cùng khu với đồng nghiệp**, không tách thành phòng riêng. Trên bàn có **màn hình máy tính**, bàn phím, chuột, cốc nước, lịch họp/tài liệu đang làm dở. Màn hình có thể hiển thị inbox và email mất việc.
4. **Các bàn lân cận:** Vài màn hình đang sáng, ghế văn phòng, đồ dùng rất ít; một số người gõ phím hoặc đi lại. Không đặt đám đông nhìn về phía nhân vật.
5. **Nền xa:** Cửa sổ, ánh sáng ban ngày và hình khối đô thị không tên. Không có biển hiệu công ty thực, logo AI cụ thể hay địa điểm được xác định.

### Những gì người xem cần nhận ra trong các khung truyện
- **PRO001-B04 / đoạn cuối PRO-001:** thấy dãy bàn và bàn nhân vật **trước khi có email**. Đây là chính văn phòng sẽ xuất hiện ở PRO-002.
- **PRO002-B01:** nhân vật ở bàn, lịch họp và công việc còn dang dở; phía xa đồng nghiệp làm việc bình thường.
- **PRO002-B02–04:** một thông báo mới ở inbox → đọc → đọc lại/đóng; **không có màn hình sa thải khổng lồ giữa văn phòng**.
- **PRO002-B05:** khi màn hình đóng, **cùng cốc, cùng lịch, cùng đồng nghiệp** vẫn ở đó; không đổi set ngay sau khi đọc thư.
- **PRO002-B06:** nhân vật đứng lên/rời bàn hướng về lối đi; không cần hành lang dài hoặc cảnh thang máy nếu chưa chốt.

### Đạo cụ kể chuyện cần hiện diện
**Bắt buộc về nội dung:** bàn, ghế, máy tính nhận email, cốc nước, lịch họp hoặc hồ sơ công việc, bàn đồng nghiệp hoạt động xung quanh.

**Có thể thêm để không gian có đời sống:** máy in phía xa, cây trang trí, bảng lịch đội nhóm, vách ngăn thấp, ly nước trên bàn khác. Những vật này **không chứa nhiệm vụ hoặc lore**.

### Trạng thái diễn biến
- **Trước email:** bình thường, nhịp làm việc tiếp tục.
- **Khi email đến:** chỉ một thông báo nhỏ ở **máy tính nhân vật**.
- **Sau email:** không thay đổi ánh sáng đột ngột, không ai đứng dậy thông báo tin xấu; thứ đổi khác là cách **nhân vật cảm nhận** cùng căn phòng.

### Điều chưa được chốt
Quốc gia/thành phố, thời điểm lịch sử chính xác, công ty và ngành nghề, số bàn, tầng, phục trang đồng nghiệp, layout chi tiết, giới tính và tên nhân vật ngoài đời. **Đừng dùng set dressing để quyết định hộ những điều này.**

---

## ENV-REAL-02 — Căn hộ thuê (PRO-003 và PRO-004)

### Bản chất và cảm giác
**[ĐÃ CHỐT]** Đây là **căn hộ thuê nhỏ** của nhân vật ngoài đời sau khi mất việc. Bối cảnh **không đổi địa điểm** trong ba khoảnh khắc: buổi sáng sau layoff → nhiều ngày tìm việc → chiếc báo thức không còn reo. PRO-004 tiếp tục diễn ra **trong chính căn hộ ấy**, bên giường.

**[ĐỀ XUẤT DỰNG THỬ]** Căn hộ một phòng sinh hoạt chính có một góc ngủ, bàn máy tính và khu nấu ăn nhỏ. Không cần căn hộ sang trọng hay quá tồi tàn. Tất cả 3–4 nhịp truyện có thể được kể qua **một set duy nhất**.

### Bố cục nhất quán
1. **Cửa ra vào:** Một lối vào hẹp, dấu hiệu đây là nơi ở thuê; không cần hành lang cả khu chung cư.
2. **Góc ngủ:** Giường đơn hoặc giường nhỏ, chiếc **đồng hồ báo thức/điện thoại báo thức cố định**, ghế có **áo quần đi làm**. Đây là nơi mở PRO-003 và nơi kết PRO-004.
3. **Bàn làm việc tại nhà:** Bàn có laptop, hồ sơ xin việc, lịch hoặc giấy ghi chú. Đặt trong cùng phòng để từ giường hoặc từ góc cửa sổ có thể nhìn thấy.
4. **Một cửa sổ:** Nhìn ra thành phố vô danh, rèm đơn giản; ánh sáng theo thời gian quét qua **cùng bức sàn và bàn**. Cửa sổ không biến thành cảnh nhìn ra núi/rừng.
5. **Góc sinh hoạt nhỏ:** Cốc, đồ ăn đơn giản, hóa đơn; có thể có bếp tối giản hoặc kệ chứa đồ. **Không dùng sự bẩn thỉu quá mức làm ký hiệu bệnh tâm lý**.

### Đạo cụ nhất quán — đừng đổi vị trí tùy tiện
- **Chiếc báo thức:** PRO003-S01 đang reo → S02 còn cài giờ → S03 đã tắt hẹn → PRO004 nằm im bên giường.
- **Bộ đồ công sở:** PRO003-S01 vẫn vắt ở ghế; về sau không phải thay toàn bộ tủ đồ để chứng minh thất nghiệp.
- **Laptop:** S01 tài liệu công việc cũ → S02 trang xin việc và hồi đáp tự động → S03 màn hình ngủ, PRO004 không bỗng nhiên hiện một email mới.
- **Lịch/giấy ghi chú:** ngày đi làm được đánh dấu → ghi ứng tuyển → ngày trống nhiều hơn.
- **Cốc, hóa đơn, đồ ăn:** thay đổi số lượng vừa phải theo thời gian; **cùng vật/địa điểm chính** giúp người xem tự nhận ra nhịp sống đã đổi.

### Ba lát cắt trong cùng căn phòng
- **PRO003-S01 — Buổi sáng đầu:** sáng nhợt xuyên qua rèm, báo thức reo, nhân vật nhìn sang quần áo đi làm. Không phải đang ở nhà sau khi nhận email — email đã xảy ra **tại văn phòng** ở cảnh trước.
- **PRO003-S02 — Những lần gửi đi:** cùng góc phòng, ánh nắng đổi dần; giấy tờ/hóa đơn xuất hiện, laptop ứng tuyển. Không biến thành cảnh phỏng vấn giả.
- **PRO003-S03 — Chiếc báo thức im lặng:** cùng chiếc giường và cửa sổ; báo thức không reo, lịch trống, laptop tắt. Phòng yên ắng hơn.
- **PRO004 — Giấc ngủ đầu:** không chuyển sang phòng khác; nhân vật từ góc giường nằm xuống. Tiếng thành phố và quạt nhạt dần, im lặng, rồi **âm thanh chim và gió** của thế giới mơ. Không cổng phép thuật, không cảnh rừng bị lộ trước CH01-001.

### Điều chưa được chốt
Tầng, địa chỉ, dạng nhà ở cụ thể, bếp riêng hay chung, tình trạng tài chính thể hiện bằng con số, mưa hay không mưa, số ngày đã trôi qua, vị trí từng món đồ theo tọa độ. Có thể dựng một bố cục tạm **nhưng không gán là canon**.

---

## ENV-DREAM-01 — Bên trong căn nhà gỗ cũ của A (CH01-001)

### Bản chất và cảm giác
**[ĐÃ CHỐT]** Đây là nhà trong rừng của A trong giấc mơ. **Có thể sống được nhưng cũ kỹ, cần chăm sóc và sửa sang**. Không rõ vì sao nhà bị bỏ quên. A cảm thấy **xa lạ nhưng hơi quen**, chưa xác nhận quá khứ riêng của A ở đây. Việc đầu tiên là **quan sát rồi tự bước ra ngoài**; không có nhiệm vụ sửa nhà bắt buộc.

**[ĐỀ XUẤT DỰNG THỬ]** Một căn nhà gỗ quy mô khiêm tốn, **không phải nhà hoang kinh dị**. Phòng đầu tiên nhìn thấy có giường gỗ, bàn nhỏ, một cửa sổ, một cửa chính hướng ra hiên. Có thể ngăn thêm phòng khác về sau nhưng **không cần để kể được scene đầu**.

### Bố cục cảnh thức dậy
1. **Góc giường:** A mở mắt, thấy **trần gỗ cũ**, các đường ghép ván, vài chỗ phai màu. Mái và sàn vẫn chắc chắn; không thủng trời, không nấm mốc độc hại.
2. **Bàn / góc sinh hoạt:** Một chiếc bàn, ghế hoặc kệ đơn giản cũ nhưng dùng được; bề mặt ít được lau dọn. Không đặt thư có tên người, chân dung gia đình hoặc nhật ký bí mật.
3. **Cửa sổ:** Ánh sáng ấm lọt qua rèm hoặc khung cửa, nghe tiếng lá/chim; từ bên trong chỉ thấy **một phần cây xanh**, không tiết lộ toàn cảnh khu rừng.
4. **Cửa chính:** Có thể mở, dẫn ra một hiên hoặc khoảng đất trước nhà. Không khóa để bắt buộc người chơi hoàn thành quest.
5. **Dấu thời gian:** Sàn mòn nhẹ, một ghế cần nắn lại, bụi mỏng, gỗ nhạt màu, hiên chưa được chăm; **không phải bằng chứng ai đó đã chết, bỏ trốn hay đang chờ A theo nghĩa đen**.

### Trình tự cảm nhận
- Nghe tiếng chim từ PRO-004 → A mở mắt và thấy trần nhà.
- Nhìn quanh căn phòng: mọi vật lạ nhưng không quá đáng sợ.
- Nhìn qua cửa sổ: gió, nắng, cây, âm rừng; **chưa thấy toàn bộ khu rừng**.
- A tự đi ra cửa; mở cửa là lúc scene CH01-002 cho thấy rừng rộng, ngập nắng.

### Những vật cần để kể scene
Giường, trần/sàn/vách gỗ cũ, cửa sổ, bàn/ghế nhỏ, cửa chính, một ít dấu hiệu cần chăm sóc. **Không cần** hệ chế tạo, két tiền, bàn thợ mộc, NPC trong nhà hay thư bí ẩn.

### Điều chưa chốt
Ai xây, ai sở hữu trước, vì sao cũ, A đã từng ở chưa, bản vẽ đầy đủ hoặc số phòng, nội thất khác, một chiếc gương hay đồ vật quá khứ có ý nghĩa truyện.

---

## ENV-DREAM-02 — Cửa nhà, khoảng rừng ngập nắng và lối mòn (CH01-002)

### Bản chất và cảm giác
**[ĐÃ CHỐT]** Khung cảnh ngoài cửa **đầu tiên** phải là **rừng rộng lớn, ngập nắng, sống động và bình yên**. **Lối mòn mờ** chỉ được người chơi nhận ra **sau khi** đã nhìn/khám phá rừng. Căn nhà là chỗ A có thể quay về.

**[ĐỀ XUẤT DỰNG THỬ]** Từ cửa nhà nhìn ra một khoảng thoáng vừa đủ để thấy chiều sâu nhiều lớp: lớp gần là hiên/sân nhỏ, lớp giữa là cây và thảm cỏ dưới nắng, lớp xa là những tán rừng tiếp tục nối nhau. Tránh xây hàng cây/đồi chắn kín trước cửa.

### Quan hệ không gian
1. **Ngay sau lưng:** Căn nhà gỗ và lối vào vẫn nhìn thấy hoặc dễ định hướng quay lại. Không cố tình làm A lạc đường ngay.
2. **Ngay trước hiên:** Khoảng đất/cỏ tự nhiên, hơi không đồng đều; đây là nơi A cảm nhận sự thoáng đãng.
3. **Phía trước hoặc lệch một bên:** Một **khoảng sáng/điểm đứng nhìn** do nắng xuyên qua cây. Đường tới đây rất tự nhiên, không cần biển chỉ "quest".
4. **Ở rìa vùng quan sát:** **Lối mòn nhỏ**: cỏ thấp hơn quanh nó, đất có dấu chân qua lại hoặc những đoạn thưa cỏ, chỉ vừa đủ gợi có người đi. Không làm con đường đá hoàn thiện, rộng như đại lộ.
5. **Dọc lối mòn:** Cây, bụi thấp, gió trong lá; tầm nhìn thu hẹp từ từ khi A đi vào rừng. Tiếng rìu từ CH01-003 sau đó trở thành điểm hút tò mò.

### Chuyển tiếp
**Từ cửa nhà:** ưu tiên ấn tượng rừng rộng **trước**, không cho Thomas, làng hay tấm biển hướng dẫn chiếm ngay khung cảnh chính. **Sau khi khám phá:** lối mòn hiện dần như một phát hiện do A tự nhận ra, dẫn tới CH01-003.

### Điều chưa chốt
Độ cao đất, tọa độ nhà, mùa cụ thể, loại cây chủ đạo, mức độ nắng chính xác, khoảng cách lối mòn, liệu có núi/hồ/suối gần đó hay không. **Đừng tự thêm suối và thác để thay lối mòn đã chọn.**

---

## ENV-DREAM-03 — Bìa rừng nơi Thomas đốn củi (CH01-003)

### Bản chất và cảm giác
**[ĐÃ CHỐT]** A **theo lối mòn** và gặp **Thomas** đang **đốn củi bên bìa rừng**. Thomas là NPC đầu tiên của tuyến mở đầu; đang làm việc của mình, **không đứng chờ A**. Lời thoại chính thức đã đồng ý nằm trong [CH01-003](../scenes/CH01-003.md) và hồ sơ tính cách nằm tại [Thomas](../characters/thomas.md).

**[ĐỀ XUẤT DỰNG THỬ]** Một khoảng trống nhỏ ở mép tán cây, còn đủ ánh sáng để nhìn hoạt động của Thomas. Nên cảm thấy đây là **một chỗ làm việc bình thường**, không phải trại lính, đồn điền khai thác quy mô lớn hay điểm quest được dựng trang trọng.

### Quan hệ với lối mòn
1. Lối mòn từ nhà dẫn người chơi tới nơi có **tiếng bổ củi đều đặn**; từ xa có thể nghe trước khi thấy Thomas.
2. Đường cây mở ra một khoảng đủ thấy **Thomas, gốc gỗ/bệ bổ củi và vài khúc gỗ đã xếp gọn**. Không cần thêm nhà kho, xe kéo hay địa điểm sống của Thomas khi chưa chốt.
3. Thomas tự bổ/xếp củi; A có thể **đi qua mà không cần nói**. Khi A chủ động tiếp cận và bắt chuyện, Thomas tạm dừng mới nói.
4. Đường có thể tiếp tục qua bìa rừng nhưng **chưa xác định đích đến**. Người chơi có thể quay về nhà.

### Đạo cụ phục vụ câu chuyện
Gốc/bệ bổ củi, vài khúc gỗ tách hoặc xếp thành đống nhỏ, rìu Thomas sử dụng, khoảng đất bị bước chân làm mòn. Không có bảng nhiệm vụ “chặt 10 gỗ”, không có biển giới thiệu nghề nghiệp, không đặt lá thư hoặc đồ vật định mệnh bên cạnh ông.

### Tư thế và quan hệ nhân vật
- Thomas tập trung vào việc đốn củi, phản ứng bình thường khi có người tới.
- Thomas không tự gọi tên A từ xa, không nói như biết nguyên nhân xuất hiện của A.
- Khi gặp lần đầu ông giới thiệu “Thomas.”, hỏi tên A; sau đó người chơi có thể chọn **hỏi nhà / hỏi người khác / hỏi đường / rời đi**.
- Không ép người chơi nghe đủ 29 dòng transcript. **Đã chốt nội dung thoại, còn cách chia nhịp là đề xuất gameplay.**

### Điều chưa chốt
Tuổi chính xác/ngoại hình Thomas, đây có phải nghề chính của ông không, nhà ông ở đâu, lối mòn dẫn tới dân cư nào, Thomas biết gì thật về lịch sử căn nhà.

---

## Danh mục bối cảnh cần có để dựng ĐỢT 1

| Ưu tiên | Bối cảnh | Nội dung không thể thiếu về mặt kể chuyện | Scene |
|---|---|---|---|
| 1 | **Văn phòng** | Bàn nhân vật, inbox nhận email, các bàn khác vẫn có người làm | PRO-001 phần cuối, PRO-002 |
| 2 | **Căn hộ thuê** | Giường, báo thức, laptop, lịch, cửa sổ, hóa đơn; một phòng đổi trạng thái qua thời gian | PRO-003, PRO-004 |
| 3 | **Nội thất nhà A** | Giường trong nhà gỗ cũ nhưng ở được, cửa sổ sáng, cửa ra ngoài | CH01-001 |
| 4 | **Ngoại thất nhà và rừng trước nhà** | Từ cửa nhìn thấy **rừng ngập nắng**; phía sau vẫn có nhà để quay về | CH01-002 |
| 5 | **Lối mòn & bìa rừng Thomas** | Đường mờ len trong cỏ/cây, tiếng đốn củi, Thomas và bệ bổ củi | CH01-002 → CH01-003 |
| Phụ | **Các nền tin tức PRO-001** | Màn hình AI, bàn trống, khoản phải trả; có thể dùng lát cắt/bối cảnh minh họa; không đòi dựng thành phố đầy đủ | PRO-001 |

## Kiểm tra continuity bắt buộc cho người dựng từ kịch bản
1. **Không chuyển email sa thải về căn hộ.** Email đến và được đọc ở bàn làm việc tại văn phòng.
2. **Không thay set căn hộ giữa PRO-003 và PRO-004.** Cùng giường, đồng hồ, cửa sổ và bàn laptop.
3. **Căn hộ thực** và **nhà gỗ trong mơ** phải là hai địa điểm khác nhau. Ngôi nhà mơ không được kể thành tài sản vừa thừa kế hoặc vật chứng về quá khứ chưa chốt.
4. **PRO-004 kết thúc trước khi lộ toàn cảnh rừng.** A thức dậy trong nhà ở CH01-001; **chỉ khi mở cửa ở CH01-002** mới thấy rừng rộng ngập nắng.
5. **Lối mòn hiện ra sau** ấn tượng về rừng và chỉ dẫn tới Thomas ở đoạn đã viết; không tự mở làng/thị trấn/nhà Thomas.
6. **Thomas có hoạt động đời thường**, không auto thoại/quest, không tự biết lý lịch A.
7. **Không tự đặt tên** tiếng Anh cho nhân vật chưa chốt. Thomas là tên đã thống nhất, A vẫn là placeholder.
8. **Đây là kịch bản không gian**, không yêu cầu engine đổi map, làm asset hay tạo nhân vật.

## Các câu hỏi chưa chốt để khóa bối cảnh về sau
- Layout cuối cùng của văn phòng (bao nhiêu dãy bàn, cửa ra vào bên nào); phòng trọ (cửa sổ và bếp nằm đâu); nhà A (có mấy phòng).
- Các dấu hiệu đặc biệt nào nên xuất hiện xuyên nhiều lần (để người chơi tự hiểu qua môi trường), ngoài báo thức và căn nhà.
- Cấu trúc tuyến đường sau Thomas, cư dân tiếp theo và nơi Thomas sinh sống.

---

## ENV-DREAM-04 — Chỗ nghỉ sau bìa rừng (CH01-004; **đề xuất CHƯA DUYỆT**)

**Quan hệ với không gian trước:** tiếp tục theo lối mòn **sau** khoảng Thomas đang đốn củi; không yêu cầu A đã nói chuyện với Thomas. Tiếng rìu thưa dần sau lưng; không đổi sang một bản đồ hoàn toàn khác.

**Không gian đề xuất:** một khoảng đất bằng vừa đủ dưới tán cây, có ghế gỗ giản dị đã cũ, **một thanh ván có dấu hiệu được thay mới hơn**, nền đất mòn vì người đi lại, lối mòn tiếp tục khuất qua cây. Ngôi nhà A có thể quay lại theo chính đường cũ; **không** thấy ngay làng xóm, nhà Thomas hay thêm NPC.

**Mục đích trong truyện:** cho người chơi tự nhận ra có con người thường sinh hoạt và quan tâm tới nơi này, **không có đoạn giải thích bằng hội thoại**. Không mặc định Thomas hoặc ai khác đã sửa ghế.

**Đạo cụ tùy chọn, chưa duyệt:** ghế gỗ cũ, thanh ván mới, nền đất có vết chân qua, lá rơi. Không có vật phẩm nhặt, tấm thư, kho báu hay nhiệm vụ bắt buộc.

**Trạng thái tương tác:** người chơi có thể quan sát, ngồi lại một lát hoặc bỏ qua; đi tiếp hoặc quay về bất cứ lúc nào. Không đòi sửa ghế để mở đường.

**Chưa chốt:** ghế/chỗ nghỉ có giữ lại trong câu chuyện hay thay dấu vết khác; diện mạo và vị trí; đoạn đường dẫn đi đâu. Xem [CH01-004](../scenes/CH01-004.md) để duyệt trước khi triển khai 3D.

---

## ENV-DREAM-01/02 — Bậc cửa khi A tự quay về (CH01-005, **đề xuất chưa duyệt**)

**Không mở địa điểm mới:** dùng **chính ngoại thất căn nhà của A** trong CH01-001/CH01-002. Sau khi đã ra ngoài, nếu người chơi tự đi về, nhân vật nhận thấy lá khô và nhánh cây nhỏ sát bậc cửa. Người chơi có thể gạt chúng sang một bên, chỉ đủ để hiện ra một khoảng bước lên sạch hơn. **Nhà vẫn cũ và cần chăm sóc**; không sửa nguyên hiên, xây phòng mới, làm vườn hay nhặt tài nguyên.

**Continuity:** người chơi có thể đi thẳng vào nhà, đi theo lối mòn, hoặc chỉ dừng nhìn; không cần từng nói chuyện Thomas hoặc ghé ghế CH01-004. Không ai gọi A quay lại và không có thoại bắt buộc. Trạng thái có/không dọn chỉ cần nhất quán **trong phân đoạn hiện tại**, chưa đặt ra luật tồn tại qua những giấc mơ sau.

**Đạo cụ có thể xuất hiện khi duyệt:** một bậc cửa, lá rơi, nhánh cây nhỏ, khoảng đất/cỏ quanh hiên. Không thêm vật có tên chủ cũ, thư, dấu phép thuật, bàn crafting. Đây là **đề xuất kịch bản** để cân nhắc với người dựng, không phải sự thay đổi được phê duyệt của 3D.

**Nguồn:** [CH01-005](../scenes/CH01-005.md) · [CH01-005.json](../scenes/CH01-005.json).
