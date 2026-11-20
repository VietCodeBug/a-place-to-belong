# Đợt 1 — Đặc điểm nhận dạng NPC đầu tiên (bản thiết kế ngoại hình để duyệt)

> **MỤC TIÊU:** một tài liệu chung để người làm nhân vật 2D trên bản đồ 3D biết cách **phân biệt từng NPC ở mọi hướng nhìn** và để biên kịch giữ nhận dạng nhất quán trong các lần xuất hiện về sau. Đây là **brief nhận dạng nhân vật**, không phải chỉ dẫn code, không phải yêu cầu tạo asset ngay.
>
> **PHẠM VI:** **Thomas** (NPC đầu tiên đã xác nhận) + **10 cư dân đầu danh sách Làng A (VLA-01…VLA-10)** + **5 nhân vật thường có nội dung quan trọng ở giai đoạn đầu (Maeve, Evelyn, Ada, Hugo, Grace)** = **16 NPC** trong một file. Đây là **thứ tự ưu tiên thiết kế**, **không phải thứ tự người chơi bắt buộc gặp họ**. Những cư dân còn lại nằm trong [roster 30 người](village-a-roster.md).
>
> **CẤP ĐỘ CHỐT:** tên và cảnh đốn củi của **Thomas** đã chốt; **ngoại hình Thomas chưa chốt**. 30 tên English Làng A, tuổi và nghề/cá tính là **bản roster đang đề xuất**. Tất cả kiểu tóc, khuôn mặt, dáng người, quần áo, gam màu, phụ kiện và cách điệu bên dưới do biên kịch **đề xuất mới, CHƯA ĐƯỢC DUYỆT/CANON**. Không được coi các đặc điểm này là artwork đã có.

## Quy tắc nhận dạng chung

- **Phong cách tham khảo:** nhân vật 2D/sprite trong thế giới 3D phong cách **Classic Low Poly**. Chọn hình khối rõ, trang phục đời thường mộc mạc, không giáp fantasy, không lớp hoa văn nhỏ li ti. Tỉ lệ có thể stylized vừa phải nhưng dáng đi không được méo/khụy bất thường.
- **4 hướng cần nhận ra cùng một nhân vật:** chính diện, sau lưng, bên trái, bên phải. Dấu nhận dạng phải tồn tại cả khi nhân vật **không cầm đạo cụ**. Tránh dựa vào một ký hiệu chỉ thấy phía trước.
- **Mỗi NPC có ít nhất 2 dấu ổn định:** một ở silhouette (tóc, áo, hình dáng), một ở phục trang (mảng màu, túi, dây đeo). Đạo cụ chỉ là dấu thứ ba theo công việc, không cố định trong tất cả animation.
- **Bối cảnh và quan hệ không biến thành ngoại hình canon:** không suy diễn họ hàng, dân tộc, quá khứ hay chức danh từ màu tóc, tuổi ước lượng hoặc trang phục đề xuất.
- **Khác biệt với nhau:** Thomas (vai ngang + ghi-lê) ≠ Owen (tạp dề hai túi) ≠ Rowan (cổ áo dựng lệch); Hazel (búi cao + tạp dề xanh) ≠ Clara (băng đô + tạp dề san hô) ≠ Grace (búi thấp + tạp dề kem); Ada (dây chéo ngực) ≠ Hugo (dây cuộn hông).
- **Diễn xuất khi không được tương tác:** có động tác việc thường ngày riêng. Không đứng im chờ người chơi, không tự phát lore, không tự bật quest; nhiệm vụ mở về sau phụ thuộc độ thân thiết và hoàn cảnh.
- **Đề nghị kiểm duyệt asset:** bản nhận dạng nên được so trước ở 4 hướng và idle/walk, sau đó mới duyệt thêm hoạt động nghề nghiệp. Mọi biểu cảm/gait vẫn phải tự nhiên.

## Bảng nhận dạng nhanh

| ID | Nhân vật | Gặp/làm gì trong nội dung | Hai dấu nhận dạng đề xuất | Gam màu đề xuất |
|---|---|---|---|---|
| `THOMAS` | **Thomas** | Đốn củi ở bìa rừng — **đã chốt hoạt động lần gặp đầu** | Một mảng vai áo ghi-lê sẫm trên nền tay áo xanh, thắt lưng to bản; từ sau nhìn rõ dáng vai ngang và ghi-lê. | xem hồ sơ |
| `VLA-01` | **Hazel** | Chăm vườn chung · tuyến quan hệ chính | **Búi tóc cao + tạp dề xanh với một túi vuông**; nhìn sau vẫn có búi tóc và dây tạp dề chữ X. | olive / kem / vàng đất. |
| `VLA-02` | **Nora** | Chăm thảo mộc bên hiên · cư dân đời sống | **Khăn choàng vai mềm tạo tam giác rộng + búi tóc thấp**; phía sau nhìn rõ viền khăn. | tím thảo mộc / kem khói / nâu sáng. |
| `VLA-03` | **Finn** | Quan sát côn trùng · cư dân đời sống nhỏ tuổi | **Tóc xoăn xù + yếm có miếng vá lá**; từ sau thấy hai dây yếm và tóc rối. | xem hồ sơ |
| `VLA-04` | **Owen** | Sửa đồ gỗ · tuyến quan hệ chính · điểm tương tác đầu làng | **Tạp dề ngắn có hai túi lệch + tóc phủ trán**; từ sau nhìn rõ dây tạp dề và đai dụng cụ. | xem hồ sơ |
| `VLA-05` | **June** | Sắp xếp và quản lý dụng cụ chung · tuyến phụ | **Tóc bob với một kẹp tóc + ghi-lê vàng ngắn**; mặt sau có khuy/đường sống lưng nổi rõ. | vàng mù tạt / trắng ngà / xám xanh. |
| `VLA-06` | **Clara** | Nấu ăn và làm bánh · tuyến quan hệ chính | **Băng đô nút lệch + tạp dề san hô dáng tròn**; từ sau thấy nơ tạp dề ngang lưng. | xem hồ sơ |
| `VLA-07` | **Felix** | Chăm luống ngũ cốc · tuyến phụ | **Hai dây đeo quần chéo hình X từ sau**; không trùng tạp dề chữ X của Hazel vì Felix không có tạp dề. | xem hồ sơ |
| `VLA-08` | **Olive** | Vẽ tranh và phụ việc nhẹ · cư dân đời sống nhỏ tuổi | **Hai bím tóc + túi yếm có vệt màu**; từ sau thấy hai bím và dây yếm. | xem hồ sơ |
| `VLA-09` | **Rowan** | Giữ lối đi rừng và hoa dại · tuyến quan hệ chính | **Cổ áo dựng lệch + miếng vá gối**; áo khoác ngắn thay vì áo ghi-lê Thomas. | xem hồ sơ |
| `VLA-10` | **Silas** | Đan giỏ và giữ đường sạch · tuyến phụ | **Mảng áo cam + cuộn dây ở một bên hông**; nhìn sau vẫn rõ tóc xoăn tròn và tạp dề ngắn. | xem hồ sơ |
| `VLA-13` | **Maeve** | May vá và sửa đồ vải · tuyến quan hệ chính | **Một bím tóc lệch + đường chỉ chéo trên túi tạp dề**; phía sau bím vẫn nằm lệch bên để nhận ra. | xem hồ sơ |
| `VLA-15` | **Evelyn** | Giữ hạt giống và ghi mùa vụ · tuyến quan hệ chính | **Túi ba ngăn + bện tóc thành vòng thấp**; phía sau nhìn rõ túi và vạt áo khoác. | xanh bụi / lúa mì / nâu sáng. |
| `VLA-18` | **Ada** | Chuẩn bị hàng và hướng vận chuyển liên làng · tuyến quan hệ chính | **Dây chéo một bên + mái tóc lệch**; từ sau thấy dây đeo và túi nhỏ, không phụ thuộc lúc có kiện hàng. | xem hồ sơ |
| `VLA-19` | **Hugo** | Buộc kiện, kiểm xe đẩy và đồ cho đường dài · tuyến phụ | **Hai dây cuộn ngang hông + tạp dề dài**; khác Ada có dây chéo ngực, Owen có tạp dề hai túi lệch. | xanh ghi / nâu đất / kem. |
| `VLA-23` | **Grace** | Nấu bữa ăn chung · tuyến quan hệ chính | **Áo đỏ gạch + tạp dề kem rộng + búi tóc thấp**; từ sau thấy nơ tạp dề lớn, khác Clara tạp dề san hô. | xem hồ sơ |

## Hồ sơ chi tiết từng NPC

### THOMAS — Thomas

**Thông tin bám theo kịch bản:** Tên Thomas; nam; đang đốn củi; trò chuyện bình thường; không phải người tiên tri hay thầy hướng dẫn định mệnh.

**Tuổi:** Chưa chốt; đề xuất người đàn ông trưởng thành, lớn tuổi hơn A. **Vai trò:** Đốn củi ở bìa rừng — **đã chốt hoạt động lần gặp đầu**.

**Dáng và silhouette (đề xuất):** Thân trên rộng vừa phải, vai ngang nhưng không quá cơ bắp; chân đứng vững, hơi cúi trọng tâm khi làm việc. Dáng khác Owen (mảnh, gọn) và Rowan (cao, thẳng).

**Gương mặt, tóc (đề xuất):** Mặt vuông dài, gò má hơi rõ, mắt nhỏ hiền, chân mày đậm; tóc nâu sẫm có ít sợi bạc, cắt gọn; râu lún phún ngắn **đề xuất**.

**Trang phục, màu chủ đạo (đề xuất):** Áo làm việc xanh thông tối xắn tay, áo ghi-lê nâu đất không tay; quần nâu xám, ủng tối. Bảng màu: **nâu gỗ / xanh thông / xám ấm**.

**Nhận dạng ở 4 hướng (đề xuất):** Một mảng vai áo ghi-lê sẫm trên nền tay áo xanh, thắt lưng to bản; từ sau nhìn rõ dáng vai ngang và ghi-lê.

**Đạo cụ theo hoàn cảnh:** Rìu **chỉ khi đốn củi**; chỗ làm việc có bệ bổ củi và đống gỗ, không mặc định cầm rìu khi đi trò chuyện khắp nơi.

**Thói quen cử động, diễn xuất khi gặp lại:** Đặt gỗ, nhìn mặt cắt, bổ dứt khoát; dừng lại thở và đáp vài câu; sau đó quay lại công việc. Không đứng chờ A.

**Không tự chốt:** Không mặc định nghề tiều phu vĩnh viễn, quan hệ với A, nhà ở, tuổi thật hay quyền sở hữu căn nhà A.

**Trạng thái ngoại hình:** `visual_draft_not_approved`. **ID nhận dạng:** `THOMAS`.

### VLA-01 — Hazel

**Thông tin bám theo kịch bản:** Thẳng thắn, kiên nhẫn; ngại nhờ giúp; hoạt động mở đầu: chăm luống non, không phải quest đầu tiên.

**Tuổi:** 34 (tuổi đề xuất trong roster). **Vai trò:** Chăm vườn chung · tuyến quan hệ chính.

**Dáng và silhouette (đề xuất):** Dáng vừa tầm, chắc khỏe từ công việc vườn; tư thế hơi nghiêng khi xem đất, di chuyển điềm đạm. Thấp hơn Rowan, không to vai như Thomas.

**Gương mặt, tóc (đề xuất):** Mặt trái xoan hơi góc cạnh; mắt nhìn tập trung, chân mày thẳng; tóc nâu hạt dẻ búi cao gọn, vài sợi tóc vương cạnh má.

**Trang phục, màu chủ đạo (đề xuất):** Áo kem xắn tay, tạp dề làm vườn xanh olive tới gối có một túi vuông lớn; quần nâu nhạt, khăn cổ màu vàng đất. Màu: **olive / kem / vàng đất**.

**Nhận dạng ở 4 hướng (đề xuất):** **Búi tóc cao + tạp dề xanh với một túi vuông**; nhìn sau vẫn có búi tóc và dây tạp dề chữ X.

**Đạo cụ theo hoàn cảnh:** Bình tưới khi làm vườn, không phải vật cầm thường trực.

**Thói quen cử động, diễn xuất khi gặp lại:** Thử đất bằng tay, phủi đầu ngón tay, gật một cái rồi mới trả lời; càng thân càng chịu để người khác giúp.

**Không tự chốt:** Không biến Hazel thành nông dân giao 10 nhiệm vụ tưới cây liên tục.

**Trạng thái ngoại hình:** `visual_draft_not_approved`. **ID nhận dạng:** `VLA-01`.

### VLA-02 — Nora

**Thông tin bám theo kịch bản:** Nhẹ nhàng, tinh ý; nhớ những sở thích nhỏ của hàng xóm.

**Tuổi:** 63 (đề xuất). **Vai trò:** Chăm thảo mộc bên hiên · cư dân đời sống.

**Dáng và silhouette (đề xuất):** Dáng thấp và gọn, hơi khom nhẹ ở cổ khi cúi xem chậu; động tác thong thả.

**Gương mặt, tóc (đề xuất):** Mặt bầu hơi dài, nếp cười quanh mắt; tóc bạc búi thấp tròn sát gáy; không cần kính để tạo dấu nhận dạng.

**Trang phục, màu chủ đạo (đề xuất):** Áo tay dài màu tím tro, áo choàng khăn vai màu kem xám, váy/quần dài màu đất nhạt. Màu: **tím thảo mộc / kem khói / nâu sáng**.

**Nhận dạng ở 4 hướng (đề xuất):** **Khăn choàng vai mềm tạo tam giác rộng + búi tóc thấp**; phía sau nhìn rõ viền khăn.

**Đạo cụ theo hoàn cảnh:** Rổ lá nhỏ khi đang làm việc; không luôn mang chai thuốc hoặc sách phép.

**Thói quen cử động, diễn xuất khi gặp lại:** Nâng chậu bằng hai tay, vuốt lá, mỉm cười nhẹ; nói chậm.

**Không tự chốt:** Không biến bà thành thầy thuốc thần bí hoặc người biết lore giấc mơ.

**Trạng thái ngoại hình:** `visual_draft_not_approved`. **ID nhận dạng:** `VLA-02`.

### VLA-03 — Finn

**Thông tin bám theo kịch bản:** Tò mò, hay quên; hoạt động an toàn là nhìn bọ và lá.

**Tuổi:** 12 (đề xuất). **Vai trò:** Quan sát côn trùng · cư dân đời sống nhỏ tuổi.

**Dáng và silhouette (đề xuất):** Nhỏ người, vai hẹp, dáng nhún nhảy hiếu kỳ; đầu hơi lớn hơn tỉ lệ người lớn nhưng không quá chibi.

**Gương mặt, tóc (đề xuất):** Mặt tròn, mũi nhỏ, mắt tròn mở lớn; tóc xoăn rối nâu đỏ, nhiều lọn to đơn giản.

**Trang phục, màu chủ đạo (đề xuất):** Áo xanh da trời nhạt, quần yếm xanh than ngắn tới gối với **miếng vá hình lá** một bên, giày nâu đơn giản.

**Nhận dạng ở 4 hướng (đề xuất):** **Tóc xoăn xù + yếm có miếng vá lá**; từ sau thấy hai dây yếm và tóc rối.

**Đạo cụ theo hoàn cảnh:** Lá cây hoặc cuốn sổ vẽ bọ khi quan sát; **không** có vũ khí hay bẫy thú.

**Thói quen cử động, diễn xuất khi gặp lại:** Ngồi xổm nhìn đất, giữ im lặng đột ngột khi phát hiện con bọ; không chạy giẫm lên luống.

**Không tự chốt:** Không giao việc săn bắn, mang hàng nặng, công cụ nguy hiểm cho trẻ.

**Trạng thái ngoại hình:** `visual_draft_not_approved`. **ID nhận dạng:** `VLA-03`.

### VLA-04 — Owen

**Thông tin bám theo kịch bản:** Ít lời, cẩn thận, hay lo sửa đồ cho người khác mà quên cánh cửa nhà mình; hội thoại mẫu CH01-007 đã có.

**Tuổi:** 37 (đề xuất). **Vai trò:** Sửa đồ gỗ · tuyến quan hệ chính · điểm tương tác đầu làng.

**Dáng và silhouette (đề xuất):** Cao vừa, thân người thon, khuỷu tay thường kẹp gần người; dáng đứng dồn trọng tâm nhẹ về bàn làm việc. Đối lập Thomas vai ngang khỏe.

**Gương mặt, tóc (đề xuất):** Mặt dài và hơi hốc hác, mắt tập trung, chân mày mảnh; tóc đen cắt ngắn có một mảng tóc rũ trước trán; **không dùng râu đậm như Thomas**.

**Trang phục, màu chủ đạo (đề xuất):** Áo xanh than xắn tay, tạp dề da ngắn màu nâu hổ phách có **hai ngăn dụng cụ lệch bên**, quần than xám; màu: **xanh than / da hổ phách / xám**.

**Nhận dạng ở 4 hướng (đề xuất):** **Tạp dề ngắn có hai túi lệch + tóc phủ trán**; từ sau nhìn rõ dây tạp dề và đai dụng cụ.

**Đạo cụ theo hoàn cảnh:** Chốt gỗ, kẹp/bút chì khi sửa; không bắt nhân vật cầm búa ở tất cả animation.

**Thói quen cử động, diễn xuất khi gặp lại:** Kiểm mối nối trước khi sửa, hơi gõ thử bằng ngón tay, ít nói nhưng nhớ người giúp.

**Không tự chốt:** Không thay thoại đã có cho REPAIRER_01 trước khi mapping Owen được duyệt.

**Trạng thái ngoại hình:** `visual_draft_not_approved`. **ID nhận dạng:** `VLA-04`.

### VLA-05 — June

**Thông tin bám theo kịch bản:** Nhanh nhẹn, thực tế; nhắc mọi người xin phép trước khi mượn dụng cụ.

**Tuổi:** 35 (đề xuất). **Vai trò:** Sắp xếp và quản lý dụng cụ chung · tuyến phụ.

**Dáng và silhouette (đề xuất):** Dáng gọn, bước nhanh, đứng thẳng; tay thường giữ món đồ nhỏ hoặc ghi nhận vị trí đặt đồ.

**Gương mặt, tóc (đề xuất):** Mặt chữ V mềm, ánh nhìn sắc và tỉnh; tóc đen cắt bob ngang cằm, kẹp tóc sáng ở **bên phải**.

**Trang phục, màu chủ đạo (đề xuất):** Áo sơ mi trắng ngà, áo ghi-lê vàng mù tạt ngắn, quần xanh xám; thắt lưng có túi nhãn vuông. Màu: **vàng mù tạt / trắng ngà / xám xanh**.

**Nhận dạng ở 4 hướng (đề xuất):** **Tóc bob với một kẹp tóc + ghi-lê vàng ngắn**; mặt sau có khuy/đường sống lưng nổi rõ.

**Đạo cụ theo hoàn cảnh:** Bảng kê hoặc nhãn dụng cụ **khi kiểm kệ**, không luôn mang theo.

**Thói quen cử động, diễn xuất khi gặp lại:** Nhìn kệ rồi quay ngay sang người vừa đặt sai đồ; giọng nhanh, không quát tháo.

**Không tự chốt:** Không xác nhận June có quan hệ tình cảm/hôn nhân với Owen vì roster chỉ là đề xuất.

**Trạng thái ngoại hình:** `visual_draft_not_approved`. **ID nhận dạng:** `VLA-05`.

### VLA-06 — Clara

**Thông tin bám theo kịch bản:** Ấm áp, cầu toàn; câu chuyện về học cách chấp nhận bữa ăn không hoàn hảo.

**Tuổi:** 31 (đề xuất). **Vai trò:** Nấu ăn và làm bánh · tuyến quan hệ chính.

**Dáng và silhouette (đề xuất):** Dáng đầy đặn vừa phải, vai mềm, cử chỉ mở; không giống Grace lớn tuổi và dáng đĩnh đạc hơn.

**Gương mặt, tóc (đề xuất):** Gò má đầy, mắt hơi cong khi cười; tóc nâu đỏ xoăn sóng ngắn, băng đô buộc nút nhỏ lệch bên.

**Trang phục, màu chủ đạo (đề xuất):** Áo kem tay bồng gọn, tạp dề màu san hô nhạt phủ trước bụng, váy/quần nâu ấm; màu: **san hô / kem / nâu hạt dẻ**.

**Nhận dạng ở 4 hướng (đề xuất):** **Băng đô nút lệch + tạp dề san hô dáng tròn**; từ sau thấy nơ tạp dề ngang lưng.

**Đạo cụ theo hoàn cảnh:** Thìa gỗ, khăn bếp hoặc khay khi làm việc, không cầm liên tục.

**Thói quen cử động, diễn xuất khi gặp lại:** Chỉnh bát lệch một chút, rồi dần học cách thôi sửa và ngồi ăn cùng người khác.

**Không tự chốt:** Không nhầm Clara với Grace: Clara trẻ hơn, nhanh tay và chú ý hình thức món ăn.

**Trạng thái ngoại hình:** `visual_draft_not_approved`. **ID nhận dạng:** `VLA-06`.

### VLA-07 — Felix

**Thông tin bám theo kịch bản:** Hóm hỉnh, chu đáo; thường phân vân giữa tăng năng suất và để đất nghỉ.

**Tuổi:** 33 (đề xuất). **Vai trò:** Chăm luống ngũ cốc · tuyến phụ.

**Dáng và silhouette (đề xuất):** Dáng cao mảnh, cổ hơi dài, vai nghiêng theo dáng cúi xem cây.

**Gương mặt, tóc (đề xuất):** Mặt dài, cười lệch một bên; tóc nâu vàng ngắn, lọn mái dựng nhẹ; không có râu đậm.

**Trang phục, màu chủ đạo (đề xuất):** Áo vàng rơm nhạt, **hai dây đeo chéo sau lưng** giữ quần xanh rêu tối; mũ vải nhỏ có vành hẹp chỉ dùng khi ra ruộng.

**Nhận dạng ở 4 hướng (đề xuất):** **Hai dây đeo quần chéo hình X từ sau**; không trùng tạp dề chữ X của Hazel vì Felix không có tạp dề.

**Đạo cụ theo hoàn cảnh:** Một nắm hạt mẫu hoặc bó thân cây nhỏ lúc kiểm luống.

**Thói quen cử động, diễn xuất khi gặp lại:** Ngồi thấp kiểm độ khô, gãi đầu cười rồi tiếp tục đoán chuyện đất.

**Không tự chốt:** Không tự chốt Felix là chồng/bạn đời Clara khi chưa duyệt quan hệ.

**Trạng thái ngoại hình:** `visual_draft_not_approved`. **ID nhận dạng:** `VLA-07`.

### VLA-08 — Olive

**Thông tin bám theo kịch bản:** Lém lỉnh, thích màu sắc; vẽ những góc bình thường mà người lớn đi qua.

**Tuổi:** 9 (đề xuất). **Vai trò:** Vẽ tranh và phụ việc nhẹ · cư dân đời sống nhỏ tuổi.

**Dáng và silhouette (đề xuất):** Thấp, dáng nhỏ, tay vung linh hoạt nhưng chân đi tự nhiên; nhỏ hơn Finn.

**Gương mặt, tóc (đề xuất):** Mặt tròn, hai má nổi rõ, mắt sáng; tóc nâu tối buộc **hai bím nhỏ đối xứng**.

**Trang phục, màu chủ đạo (đề xuất):** Áo vàng nhạt, váy yếm xanh lam sáng có **một túi lớn với vệt màu**, giày nâu đỏ; hai dây buộc tóc đỏ đất.

**Nhận dạng ở 4 hướng (đề xuất):** **Hai bím tóc + túi yếm có vệt màu**; từ sau thấy hai bím và dây yếm.

**Đạo cụ theo hoàn cảnh:** Tờ giấy hoặc cây bút màu **chỉ lúc vẽ**.

**Thói quen cử động, diễn xuất khi gặp lại:** Ngồi chồm hổm vẽ, nghiêng đầu xem tranh, giơ cho người xem khi họ chủ động hỏi.

**Không tự chốt:** Không đặt Olive vào công việc nặng hoặc nhiệm vụ cần đi rừng một mình.

**Trạng thái ngoại hình:** `visual_draft_not_approved`. **ID nhận dạng:** `VLA-08`.

### VLA-09 — Rowan

**Thông tin bám theo kịch bản:** Điềm đạm, nguyên tắc; chăm đường nhưng không muốn phá những thứ đang sống. Không mặc định là thợ săn.

**Tuổi:** 45 (đề xuất). **Vai trò:** Giữ lối đi rừng và hoa dại · tuyến quan hệ chính.

**Dáng và silhouette (đề xuất):** Cao, vai tương đối hẹp, thân thẳng, bước dài chậm rãi; khác Thomas có trọng tâm hơi thấp.

**Gương mặt, tóc (đề xuất):** Mặt dài, quai hàm rõ, mắt điềm tĩnh; tóc đen pha bạc có một lọn kéo về phía sau, râu gần như không có.

**Trang phục, màu chủ đạo (đề xuất):** Áo khoác ngắn xanh xám rừng, cổ áo dựng một bên, quần xanh rêu xỉn có miếng vá gối màu nâu; màu: **xanh rêu xám / nâu sẫm / xám đá**.

**Nhận dạng ở 4 hướng (đề xuất):** **Cổ áo dựng lệch + miếng vá gối**; áo khoác ngắn thay vì áo ghi-lê Thomas.

**Đạo cụ theo hoàn cảnh:** Tập ghi dấu lối đi hay nhánh khô nhặt được khi làm việc; không tự cấp vũ khí săn.

**Thói quen cử động, diễn xuất khi gặp lại:** Dừng ngắm hoa dại trước khi dọn đường, nhường bước chân tránh luống cây.

**Không tự chốt:** Không đồng nhất Rowan với kiểm lâm chính thức hoặc người quản lý hệ săn bắn.

**Trạng thái ngoại hình:** `visual_draft_not_approved`. **ID nhận dạng:** `VLA-09`.

### VLA-10 — Silas

**Thông tin bám theo kịch bản:** Cởi mở, hơi hấp tấp; muốn làm nhanh nhưng dễ làm rối vật liệu.

**Tuổi:** 39 (đề xuất). **Vai trò:** Đan giỏ và giữ đường sạch · tuyến phụ.

**Dáng và silhouette (đề xuất):** Thân người vạm vừa, vai tròn hơn Owen, tay hay chuyển động nhanh; không lớn tuổi như Thomas.

**Gương mặt, tóc (đề xuất):** Mặt bầu, nụ cười rộng, chân mày rậm; tóc nâu xoăn ngắn tạo một khối tròn.

**Trang phục, màu chủ đạo (đề xuất):** Áo cam đất tay xắn, tạp dề ngắn xanh lục nhạt, dây buộc giỏ cuộn ở một bên hông; màu: **cam đất / xanh lá nhạt / kem**.

**Nhận dạng ở 4 hướng (đề xuất):** **Mảng áo cam + cuộn dây ở một bên hông**; nhìn sau vẫn rõ tóc xoăn tròn và tạp dề ngắn.

**Đạo cụ theo hoàn cảnh:** Khung đan mẫu hoặc sợi đan khi ngồi làm việc.

**Thói quen cử động, diễn xuất khi gặp lại:** Tay đan nhanh, đôi khi tháo ra làm lại; hay quay sang trò chuyện.

**Không tự chốt:** Không biến tính hấp tấp thành hoạt hình quờ quạng, cử động tay chân lỗi.

**Trạng thái ngoại hình:** `visual_draft_not_approved`. **ID nhận dạng:** `VLA-10`.

### VLA-13 — Maeve

**Thông tin bám theo kịch bản:** Tỉ mỉ, kín đáo; hay giúp người khác nhưng ngại nhờ ai giúp mình.

**Tuổi:** 27 (đề xuất). **Vai trò:** May vá và sửa đồ vải · tuyến quan hệ chính.

**Dáng và silhouette (đề xuất):** Dáng mảnh, vai hơi khép, bước nhỏ; ngồi may lưng tương đối thẳng.

**Gương mặt, tóc (đề xuất):** Mặt oval nhỏ, ánh mắt tập trung; tóc nâu đen **một bím dài đổ qua vai trái**.

**Trang phục, màu chủ đạo (đề xuất):** Áo xanh tím than, tạp dề màu kem nhạt có **một đường chỉ chéo sáng** ở túi, váy/quần dài màu xám tím; màu: **chàm / kem / tím xám**.

**Nhận dạng ở 4 hướng (đề xuất):** **Một bím tóc lệch + đường chỉ chéo trên túi tạp dề**; phía sau bím vẫn nằm lệch bên để nhận ra.

**Đạo cụ theo hoàn cảnh:** Khung thêu/vải mẫu ở bàn; không luôn cầm kim sắc khi đi bộ.

**Thói quen cử động, diễn xuất khi gặp lại:** Ngón tay lựa đường chỉ, ngập ngừng trước khi nhờ A góp ý; càng thân tư thế càng mở.

**Không tự chốt:** Không thêm bí mật gia đình hoặc xác nhận quan hệ với Arthur.

**Trạng thái ngoại hình:** `visual_draft_not_approved`. **ID nhận dạng:** `VLA-13`.

### VLA-15 — Evelyn

**Thông tin bám theo kịch bản:** Chậm rãi, quan sát giỏi; hướng dẫn kỹ năng thực tế, không giữ bí mật giấc mơ.

**Tuổi:** 68 (đề xuất). **Vai trò:** Giữ hạt giống và ghi mùa vụ · tuyến quan hệ chính.

**Dáng và silhouette (đề xuất):** Dáng nhỏ, vai hơi xuôi, lưng hơi còng nhẹ; bước ngắn chắc, không biến thành hình ảnh yếu ớt.

**Gương mặt, tóc (đề xuất):** Mặt mảnh có nếp cười nhỏ, mắt quan sát lâu; tóc trắng bạc **bện vòng thấp sau gáy**.

**Trang phục, màu chủ đạo (đề xuất):** Áo khoác xanh lam bụi dài ngang hông, khăn cổ màu lúa mì nhạt, váy/quần nâu xám; **túi hạt vuông chia ba ô** bên hông. Màu: **xanh bụi / lúa mì / nâu sáng**.

**Nhận dạng ở 4 hướng (đề xuất):** **Túi ba ngăn + bện tóc thành vòng thấp**; phía sau nhìn rõ túi và vạt áo khoác.

**Đạo cụ theo hoàn cảnh:** Một hũ hạt/nhãn giấy khi phân loại; sổ nhỏ khi ghi chép.

**Thói quen cử động, diễn xuất khi gặp lại:** Cẩn thận đóng nắp hũ, nhìn nhãn hai lần, kiên nhẫn đợi người học đọc.

**Không tự chốt:** Không tạo hình bà tiên hoặc người tiên tri.

**Trạng thái ngoại hình:** `visual_draft_not_approved`. **ID nhận dạng:** `VLA-15`.

### VLA-18 — Ada

**Thông tin bám theo kịch bản:** Năng động, tò mò; làng đích chưa xây, chỉ có hoạt động kiểm kiện và quan sát đường quanh Làng A.

**Tuổi:** 24 (đề xuất). **Vai trò:** Chuẩn bị hàng và hướng vận chuyển liên làng · tuyến quan hệ chính.

**Dáng và silhouette (đề xuất):** Dáng mảnh khỏe và linh hoạt; sải bước nhanh nhưng chân đặt đúng hướng, gọn hơn Thomas/Hugo.

**Gương mặt, tóc (đề xuất):** Mặt oval hơi nhọn, mắt sáng; tóc nâu đen ngắn ngang gáy, **mái vén lệch**.

**Trang phục, màu chủ đạo (đề xuất):** Áo khoác xanh ngọc đậm ngắn, áo trong màu kem, quần nâu sẫm, **dây đeo chéo ngực màu cam đất** nối túi vải nhỏ phía hông; màu: **xanh ngọc / cam đất / kem**.

**Nhận dạng ở 4 hướng (đề xuất):** **Dây chéo một bên + mái tóc lệch**; từ sau thấy dây đeo và túi nhỏ, không phụ thuộc lúc có kiện hàng.

**Đạo cụ theo hoàn cảnh:** Tờ kiểm kiện hoặc túi mang hàng khi chuẩn bị chuyến đi; chưa thiết kế hàng đi làng khác.

**Thói quen cử động, diễn xuất khi gặp lại:** Nhìn về cuối đường, kiểm dây kiện, quay lại hỏi Hugo; khi dừng nói chuyện vẫn có hoạt động riêng.

**Không tự chốt:** Không tạo quest giao hàng sang Làng B hoặc xác định Ada sống/chung nhà theo quan hệ nào.

**Trạng thái ngoại hình:** `visual_draft_not_approved`. **ID nhận dạng:** `VLA-18`.

### VLA-19 — Hugo

**Thông tin bám theo kịch bản:** Điềm tĩnh, hay pha trò; phân biệt vai trò chuẩn bị với Ada là người quan tâm tuyến đường.

**Tuổi:** 28 (đề xuất). **Vai trò:** Buộc kiện, kiểm xe đẩy và đồ cho đường dài · tuyến phụ.

**Dáng và silhouette (đề xuất):** Dáng thấp hơn Ada một chút nhưng vai rộng, chắc; tay giữ dây buộc vững, trọng tâm nặng hơn.

**Gương mặt, tóc (đề xuất):** Mặt tròn vuông, mắt hơi híp khi cười; tóc nâu sáng ngắn chải gọn; có một lọn dựng nhỏ.

**Trang phục, màu chủ đạo (đề xuất):** Áo xanh ghi sáng xắn tay, tạp dề da màu nâu đất dài quá hông; **hai dây buộc vắt ngang hông** tạo dấu hiệu khác Owen. Màu: **xanh ghi / nâu đất / kem**.

**Nhận dạng ở 4 hướng (đề xuất):** **Hai dây cuộn ngang hông + tạp dề dài**; khác Ada có dây chéo ngực, Owen có tạp dề hai túi lệch.

**Đạo cụ theo hoàn cảnh:** Cuộn dây/kiện khi kiểm hàng, xe đẩy chỉ ở khu chuẩn bị; không cần đẩy xe mọi lúc.

**Thói quen cử động, diễn xuất khi gặp lại:** Kiểm nút buộc bằng hai tay, kéo thử rất nhẹ; trả lời hài hước rồi tiếp tục kiểm.

**Không tự chốt:** Không mặc định Hugo là người giao hàng chính hay có quan hệ tình cảm với Ada.

**Trạng thái ngoại hình:** `visual_draft_not_approved`. **ID nhận dạng:** `VLA-19`.

### VLA-23 — Grace

**Thông tin bám theo kịch bản:** Hiền hậu nhưng có chính kiến; thường chăm người khác đến khi quên phần mình.

**Tuổi:** 49 (đề xuất). **Vai trò:** Nấu bữa ăn chung · tuyến quan hệ chính.

**Dáng và silhouette (đề xuất):** Dáng đĩnh đạc, vai đầy và đứng thẳng, chậm rãi hơn Clara; dáng gắn với người sắp bàn chung.

**Gương mặt, tóc (đề xuất):** Mặt tròn dài, cười điềm tĩnh, mắt có nếp nhỏ; tóc nâu đen điểm bạc búi thấp **tròn gọn chính giữa**.

**Trang phục, màu chủ đạo (đề xuất):** Áo màu đỏ gạch trầm, tạp dề kem bản rộng dài tới gối, khăn vai xanh than nhỏ; màu: **đỏ gạch / kem / xanh than**.

**Nhận dạng ở 4 hướng (đề xuất):** **Áo đỏ gạch + tạp dề kem rộng + búi tóc thấp**; từ sau thấy nơ tạp dề lớn, khác Clara tạp dề san hô.

**Đạo cụ theo hoàn cảnh:** Khăn bếp và khay bát khi chuẩn bị bữa chung, không luôn mang chảo.

**Thói quen cử động, diễn xuất khi gặp lại:** Đặt một chiếc bát xuống, gọi người khác vào ăn, sau khi thân sẽ biết ngồi ăn cùng họ.

**Không tự chốt:** Không đặt Grace là chủ quán café hoặc người đứng đầu làng nếu chưa chốt.

**Trạng thái ngoại hình:** `visual_draft_not_approved`. **ID nhận dạng:** `VLA-23`.

## Bàn giao giữa biên kịch và bên làm nhân vật

**Người dựng nhân vật cần giữ:** (1) ID; (2) hình dáng và hai dấu nhận dạng nếu được duyệt; (3) 4 góc nhìn; (4) đạo cụ theo hoạt động; (5) không mặc định mỗi cuộc gặp đều là nhiệm vụ.

**Chưa có dữ liệu để tự quyết:** kích thước sprite, tỷ lệ chính xác đầu/thân, số frame, bộ màu chính thức, giới tính/ngoại hình đã khóa cho các cư dân đề xuất, accent, tên họ, sắc tộc, địa điểm nhà của Thomas và tính cách mới ngoài roster.

**Các NPC chưa thuộc đợt 1:** VLA-11, 12, 14, 16, 17, 20, 21, 22, 24, 25, 26, 27, 28, 29, 30. Họ vẫn nằm trong danh sách 30 cư dân, **không bị xóa khỏi game**; chỉ chưa có đề xuất ngoại hình chi tiết ở file này.

## Tài liệu nguồn đối chiếu

- [Thomas — Character Bible](thomas.md) — thông tin Thomas và các điểm chưa chốt.
- [Làng A — roster 30 người](village-a-roster.md) — tên, tuổi gợi ý, nghề, tính cách và mã ID ổn định.
- [CH01-003](../scenes/CH01-003.md) — gặp Thomas bên bìa rừng, lời thoại v1 đã được chấp thuận.
- [CH01-007](../scenes/CH01-007.md) — hai điểm tiếp xúc trò chuyện/chăm vườn/sửa đồ của Làng A.
- [24 nhiệm vụ quan hệ của 8 cư dân chính](../quests/village-a-relationship-arcs-v0.md) — việc làm/động tác sẽ cần nhất quán ở những lần gặp lại.
