# Làng A — Hồ sơ cộng đồng đầu tiên

> **Quy mô chốt theo yêu cầu:** **khoảng 30 cư dân**. `VILLAGE_A` / “Làng A” chỉ là **mã địa điểm tạm**, chưa phải tên chính thức của làng hay tên khác của nhân vật A.
>
> **Biên kịch đề xuất:** 30 cư dân có tên tiếng Anh nháp; 11 nhóm hộ gia đình; 8 tuyến sâu, 10 tuyến vừa, 12 tuyến đời sống. Tất cả tên, tuổi, quan hệ, nghề, nhà ở và sự kiện mới đều **chưa thành canon** nếu m chưa duyệt.
>
> **Continuity:** Theo [CH01-006](../scenes/CH01-006.md), lần đầu chỉ thoáng thấy vài mái nhà qua tán cây. Đến [CH01-007](../scenes/CH01-007.md) mới tự đi vào sinh hoạt làng. Thomas vẫn ở khu đốn củi bìa rừng; **chưa quyết ông có sống trong làng không** và chưa tính ông vào 30 cư dân.

## Mục tiêu: một cộng đồng có thể sống mà không cần A

Từ cổng lối mòn nhìn vào, đây không phải 30 người đứng sẵn với dấu chấm than. Vài người chăm vườn, sửa đồ, mang giỏ; người lớn tuổi nghỉ ở hiên; trẻ nhỏ chơi hoặc học việc nhẹ. Nếu A chỉ đi qua, họ vẫn có lịch sinh hoạt và giao tiếp với nhau. Nếu A tới gần, một số người chủ động chào ngắn; chuyện riêng chỉ mở khi A quen biết.

## Không gian hợp lý cho quy mô ~30 người — bố cục đề xuất

- **Một đường đi chung:** nối lối từ rừng tới những cụm nhà, đủ để thấy vết đi lại và hướng di chuyển của cư dân.
- **11 nhóm cư trú** theo bản roster nháp: nhà không cần giống nhau, có hiên hoặc khoảng sân nhỏ; số công trình **chưa chốt**.
- **Góc cây/vườn chung:** gắn với lời thoại của `GARDENER_01` ở CH01-007. Không phải khu nông trại công nghiệp.
- **Góc sửa đồ và làm thủ công:** gắn với `REPAIRER_01`, có vật dụng hư thật, không trưng bày như shop nhiệm vụ.
- **Khoảng nấu ăn/sinh hoạt nhỏ:** đủ cho người trong làng trao đổi đồ hoặc dùng bữa, không mặc định có nhà hàng hoặc quán café.
- **Đường ra rừng:** vẫn nối chỗ Thomas và nhà A; không bắt phải gặp ai mới được trở về.

**Lưu ý continuity:** CH01-006 nhìn từ xa thấy **một vài mái nhà** không có nghĩa cả cộng đồng chỉ có vài căn. Đứng ở rìa rừng, phần còn lại bị cây/địa hình che, tạo quy mô 30 người mà vẫn giữ nhịp khám phá trước đó.

## Cách phân phối sự chú ý

| Mức độ | Số người | Mục tiêu biên kịch | Khi chơi |
|---|---:|---|---|
| Tuyến sâu `core` | 8 | Có câu chuyện riêng, lựa chọn và một thay đổi trong quan hệ | 1–2 hoạt động giới thiệu; các nhánh sau mới mở dần |
| Tuyến vừa `supporting` | 10 | Có tính cách, quan hệ chéo, sự kiện ngắn | Sinh hoạt đời thường, đối thoại hoặc góp phần vào sự kiện chung |
| Tuyến đời sống `ambient` | 12 | Có nhận dạng, gia đình, việc hàng ngày, có thể quen mặt A | Không đứng bất động, không giao quest vô lý |

**Không cần hiển thị cả 30 NPC ngay khi lần đầu tới:** khoảng vài người đang hoạt động tại góc vườn/đường chung; người còn lại đang ở trong nhà hoặc làm công việc khác. Số người nhìn thấy cùng lúc là lựa chọn dựng cảnh, không phải quy tắc dân số.

## Những hoạt động đầu tiên — không theo thứ tự

### VLA-E01 — Tưới luống mới

**Người liên quan:** Hazel. **Cơ hội xuất hiện:** `player_offers_help`. **A thực sự làm:** Tự cầm bình và tưới vùng cây được chỉ, đặt bình lại. **Nếu giúp / không giúp:** Giúp: luống đã tưới, Hazel nhớ; bỏ qua: Hazel tự làm sau. **Trạng thái:** đề xuất, chưa duyệt.

### VLA-E02 — Giữ chốt cửa

**Người liên quan:** Owen. **Cơ hội xuất hiện:** `player_offers_help`. **A thực sự làm:** Giữ một phần gỗ khi Owen chỉnh chốt, thử đóng/mở. **Nếu giúp / không giúp:** Giúp: chốt chắc, Owen nhớ; bỏ qua: Owen tiếp tục sửa. **Trạng thái:** đề xuất, chưa duyệt.

### VLA-E03 — Sắp một bữa nhỏ

**Người liên quan:** Clara. **Cơ hội xuất hiện:** `player_talks_about_cooking`, quan hệ `acquaintance`. **A thực sự làm:** Bày vài món lên bàn, chỉnh lại vị trí theo lời mời. **Nếu giúp / không giúp:** Bữa ăn diễn ra bất kể A có giúp hay không. **Trạng thái:** đề xuất, chưa duyệt.

### VLA-E04 — Giữ hoa bên lối đi

**Người liên quan:** Rowan. **Cơ hội xuất hiện:** `player_notices_branch_on_walkway`, quan hệ `acquaintance`. **A thực sự làm:** Chọn dọn một nhánh cây hoặc đổi vị trí đi để giữ hoa dại. **Nếu giúp / không giúp:** Đường có thay đổi nhỏ; Rowan có thể nhớ lựa chọn. **Trạng thái:** đề xuất, chưa duyệt.

### VLA-E05 — Chọn một đường chỉ

**Người liên quan:** Maeve. **Cơ hội xuất hiện:** `player_asks_about_work`, quan hệ `acquaintance`. **A thực sự làm:** Chọn trong vài cách vá món đồ bình thường, không lấy đồ từ NPC. **Nếu giúp / không giúp:** Maeve có một lựa chọn trang trí để dùng; không có thưởng bắt buộc. **Trạng thái:** đề xuất, chưa duyệt.

### VLA-E06 — Ghi nhãn cho hạt

**Người liên quan:** Evelyn. **Cơ hội xuất hiện:** `player_observes_seed_jars`, quan hệ `familiar`. **A thực sự làm:** So sánh hũ, gắn nhãn đúng trong lúc Evelyn phụ trách. **Nếu giúp / không giúp:** Kệ được sắp gọn; Evelyn biết A để ý. **Trạng thái:** đề xuất, chưa duyệt.

### VLA-E07 — Chuyến hàng sang làng khác

**Người liên quan:** Ada (chuyến đi), Hugo (chuẩn bị). **Phần có thể chơi tại Làng A:** hỏi Ada về những kiện hàng, hỗ trợ Hugo kiểm kiện. **Chuyến giao hàng thật:** chỉ mở khi làng đích, đường liên làng, hàng và người nhận đã được chốt; A **tự nhận hàng rồi vận chuyển sang làng khác để giao tận tay người nhận**, không giao vòng trong Làng A. **Nếu từ chối:** Ada tự thu xếp, người chơi vẫn có thể tự khám phá đường đi. **Quan hệ:** lời nhờ cụ thể có thể cần quen biết, nhưng đường sang làng khác không bị khóa bởi điểm tình bạn. **Trạng thái:** hướng liên làng đã chọn, dữ kiện tuyến/quest là nháp. [Chi tiết](../activities/inter-village-delivery-v0.md).

### VLA-E08 — Bày bàn rồi cùng ăn

**Người liên quan:** Grace. **Cơ hội xuất hiện:** `player_asks_to_help_at_mealtime`, quan hệ `acquaintance`. **A thực sự làm:** Chuẩn bị vài chỗ ngồi và đồ ăn, có thể dùng bữa hoặc rời đi. **Nếu giúp / không giúp:** Grace nhận ra A không chỉ đến để lấy phần thưởng. **Trạng thái:** đề xuất, chưa duyệt.

### VLA-E09 — Một trò chơi nhỏ

**Người liên quan:** Finn, Olive, Will, Kit. **Cơ hội xuất hiện:** `player_approaches_children_in_public_space`. **A thực sự làm:** Quan sát hoặc tham gia trò đoán lá/âm chim, không giao việc nguy hiểm cho trẻ. **Nếu giúp / không giúp:** Các em nhớ A đã cùng chơi, không tự mở bí mật gia đình. **Trạng thái:** đề xuất, chưa duyệt.

### VLA-E10 — Một góc sinh hoạt cần chăm

**Người liên quan:** Nhiều cư dân. **Cơ hội xuất hiện:** `small_public_area_becomes_worn_without_player_requirement`, quan hệ `familiar`. **A thực sự làm:** Ai có mặt đều có thể cùng làm một chút; A chỉ là một người trong nhóm. **Nếu giúp / không giúp:** Không tham gia: dân làng tự chăm; tham gia: một thay đổi nhỏ được ghi nhận. **Trạng thái:** đề xuất, chưa duyệt.

### VLA-E11 — Theo dấu và săn thú rừng (hoạt động mới)

**Không gian:** khu rừng có động vật, **chưa duyệt loài/vùng**. **Cơ hội xuất hiện:** A tự phát hiện dấu thú; có thể chỉ quan sát hoặc quyết định săn khi có cơ chế phù hợp. **A thực sự làm:** lần dấu, theo dõi tập tính, tự chọn săn nếu có đủ điều kiện, sau đó có thể sử dụng thành quả theo hệ vật phẩm được duyệt. **Nếu không săn:** vẫn có khám phá; không mất thiện cảm. **Hệ quả đề xuất:** chú ý giới hạn săn và sức sống của quần thể thú. **Không tự biến Rowan hay ai khác thành thợ săn.** [Chi tiết](../activities/hunting-v0.md).

## Những câu chuyện nảy sinh theo quan hệ

- Mới gặp: trao đổi một vài câu, không đọc toàn bộ tiểu sử.
- Đã có việc làm chung: NPC nhớ, nói khác khi gặp lại, đôi khi đề nghị **một hoạt động**.
- Đã quen và có sự kiện cụ thể: một **lời nhờ có lý do**, người chơi có thể đồng ý hoặc từ chối.
- Đã có tin cậy: một câu chuyện riêng với quyết định, hệ quả nhỏ trong đời sống. Không mở chỉ bằng tăng điểm friendship.
- Người chơi có thể chọn chỉ chăm nhà, đi rừng, hoặc nói chuyện một vài người mà không làm hỏng nội dung của làng.

## Các mối quan hệ chéo để làng không chỉ xoay quanh A (đề xuất)

- Hazel và Owen: người chăm vườn cần sửa dụng cụ, người sửa đồ có thể nhờ chăm cây gần nhà; hai người **tự trao đổi** mà không cần A.
- Clara và Grace: cùng quan tâm bữa ăn nhưng có phong cách khác nhau; khi cùng nấu có thể bất đồng nhỏ về cách phục vụ, không biến thành drama ác ý.
- Rowan và Theo: cả hai giữ đường đi chung; khác ý về tỉa cỏ hay giữ hoa tự nhiên.
- Maeve và Nia: trao đổi kinh nghiệm về đường chỉ và cách đan; một người thích bền, người kia thiên về chi tiết.
- Ada và Hugo: một người thích bước ra đường, một người thích chuẩn bị mọi thứ chắc chắn trước khi đi.
- Evelyn và Finn: người lớn tuổi có thể chỉ một chuyện về hạt giống; trẻ nhỏ hỏi nhiều, không biến thành tuyến lời tiên tri.

**Quan hệ gia đình cụ thể ở 11 nhà nằm trong [roster](../characters/village-a-roster.md), vẫn để nháp.** Đừng khẳng định những quan hệ này đã xảy ra trong lời thoại cho tới khi m duyệt.

## Lối ra thế giới rộng hơn

Làng A không được biến thành nơi gói hết gameplay. **Đường sang những làng khác phải là không gian có thể khám phá**, không chỉ một nút teleport. Những chuyến hàng của Ada là một động lực xã hội để đi tới làng kế tiếp; ngoài ra người chơi vẫn có thể **tự đi không cần nhận việc**. Hoạt động săn bắn tạo thêm lựa chọn khi khám phá **các vùng rừng thích hợp**, tách biệt với hệ giao hàng. **Chưa đặt tên Làng B** hoặc loài thú mới.

## Quy tắc cho các cảnh tiếp theo**Chi tiết đã viết sâu:** [Hazel — kịch bản chơi ba chặng](../quests/village-a-hazel-playable-v1.md) và [Owen — kịch bản chơi ba chặng](../quests/village-a-owen-playable-v1.md). Có tình huống ngoài quest, việc thực sự làm và nhánh NPC tự giải quyết khi A bỏ qua. Chưa tự chốt những đề xuất thành 3D asset hay game logic.

## Tuyến nhiệm vụ dài hạn — không gặp một lần rồi hết

Theo yêu cầu đã chọn, mỗi NPC tuyến sâu có **Q1 → hoạt động/lần gặp thường → Q2 → nhiều lần gặp/sự kiện quan hệ → nhiệm vụ cuối (QF)**. **Không** tự mở Q1 khi chào đầu, không mở Q2 ngay khi vừa hoàn tất Q1, không tự xuất hiện nhiệm vụ chỉ vì điểm thân thiết tăng. Cần đúng tình huống, đúng việc NPC đang làm và người chơi chủ động nhận.

Bộ bản nháp [24 nhiệm vụ của 8 cư dân chính](../quests/village-a-relationship-arcs-v0.md) và [dữ liệu JSON](../quests/village-a-relationship-arcs-v0.json) đã có từng chặng: nguyên nhân, hành động thực, lựa chọn, kết quả nếu giúp và cách NPC tự giải quyết nếu A từ chối. Sau QF cư dân **tiếp tục có đời sống**.

**Mốc thân thiết 20 / 50 / 80 trên thang 0–100 mới là đề xuất cân bằng**, không phải công thức đã chốt. Chỉ mới viết sâu cho 8 tuyến `core`; 22 NPC còn lại vẫn có đời sống và hội thoại, chưa bị ép thành 66 nhiệm vụ tiếp theo. Không thêm Làng B.

## Ngân hàng hội thoại Làng A — đã soạn bản v0, chờ duyệt

Đã viết bộ lời thoại nền cho **đủ 30 cư dân**: [Hướng dẫn](../dialogue/village-a-dialogues-guide-v0.md) · [Cư dân 01–10](../dialogue/village-a-dialogues-01-10.md) · [11–20](../dialogue/village-a-dialogues-11-20.md) · [21–30](../dialogue/village-a-dialogues-21-30.md) · [Dữ liệu hợp nhất](../dialogue/village-a-dialogues-v0.json).

Mỗi người có nhịp nói riêng và điều kiện rõ cho lúc gặp đầu, hỏi việc, đề nghị tham gia, từ chối, gặp lại hoặc quen thân. Một việc chỉ được coi là làm xong **sau khi A thật sự thao tác**, không phải vì chọn lời thoại. Các bản intro/hoạt động Hazel và Owen trong CH01-007 **được giữ nguyên và tham chiếu lại**, không viết đè.

Thêm 6 đoạn [NPC nói chuyện với nhau](../dialogue/village-a-overheard-v0.md), xảy ra khi hai cư dân có mặt và không có hội thoại của người chơi. Làng vẫn có việc riêng dù A không ghé; không tự mở quest từ câu chuyện nghe lỏm.

**Tình trạng:** bản nháp lời thoại theo 30 tên English đã đề xuất; **chưa chốt những tên đó**, câu thoại chưa duyệt cá nhân, chưa triển khai Godot. Thomas không nằm trong 30 người. Tập trung tiếp vào mối quan hệ nội làng trước, chưa viết nội dung Làng B.


- Không viết mỗi cư dân = một nhiệm vụ đánh dấu trên bản đồ. Viết **đời sống trước, lựa chọn người chơi sau**.
- Không có NPC mới tiết lộ nguồn gốc A hoặc bản chất giấc mơ vì “chỉ số thân thiện đủ cao”.
- Không chốt tất cả nghề, nhà, lịch ngày đêm hay quan hệ từ bản nháp.
- Không chỉnh hồ sơ Thomas hoặc đổi lời thoại CH01-003 đã đồng ý.
- `CH01-007` vẫn sử dụng `GARDENER_01` và `REPAIRER_01`. Gắn **tạm** Hazel và Owen để có continuity, nhưng chưa thay mã hội thoại.
- Khi m duyệt roster, mới tách **hồ sơ nhân vật độc lập** cho những tuyến sâu cần viết lời thoại nhiều lần.

**Files:** [30 cư dân](../characters/village-a-roster.md) · [Dữ liệu cư dân](../characters/village-a-roster.json) · [Dữ liệu làng](village-a.json) · [Hoạt động thế giới mở](../production/open-world-narrative-v0.md).
