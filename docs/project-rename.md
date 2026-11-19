# Rename confirmed and branches consolidated — 18/11/2026

The owner renamed GitHub to https://github.com/VietCodeBug/a-place-to-belong, repository ID1459537532. Origin and active document links are now updated. Seven retired branches are preserved as identical tags; three active branch heads remain. A README-only branding commit updates main without merging PR10. The original narrative branch/docs remain untouched. About description still needs the owner to edit it: integration PATCH is denied with HTTP403. The previous report below is historical and superseded where it says the new repository does not yet exist.

---

# A Place to Belong — branding update

Ngày 18/11/2026. Tên game: **A Place to Belong**. Tagline chính xác: **A second life, somewhere between dreams and reality.**

## Phạm vi cuối đã chốt

Người dùng tự đổi repository sang `a-place-to-belong` trong GitHub Settings. Lượt này chỉ cập nhật nhận diện bên trong project, không đổi tên nhánh, assets, gameplay hoặc kịch bản. Hai lần PATCH tên/mô tả GitHub trước đó bị integration từ chối HTTP403, không tạo thay đổi ở server. Remote và URL tài liệu tiếp tục dùng repository đang tồn tại, tránh link mới chưa có đích.

## File thay đổi

- project.godot: application name.
- scripts/ui/storybook_screens.gd: tiêu đề main menu, tagline, caption thương hiệu; không đổi callback/navigations hoặc hệ thống chơi.
- README.md: thương hiệu, định hướng mới do người dùng cung cấp, trạng thái prototype và liên kết tới tài liệu kịch bản gốc. Không tự thêm lore/quest.
- AGENTS.md: nhận diện mới và ràng buộc bảo vệ kịch bản.
- docs/project-rename.md: báo cáo này.

Tên Forest Post Café trong địa điểm, biển hiệu, lời thoại hiện có, đường dẫn asset và tài liệu lịch sử giữ nguyên để không tự viết lại nội dung game.

## Bảo toàn và kiểm tra

Trước khi commit branding, toàn bộ 10 remote branch heads và mọi tag được đối chiếu với snapshot, không thay đổi. Nhánh story/forest-post-cafe-narrative giữ commit efe69573fb8c8c08b4c143da6b9069ca70314cef. Cây docs/story giữ SHA a526ef60560d6c09a958eac810e7f588e6fa499f và toàn bộ blob gốc. Thư mục này không được copy/ghi đè sang nhánh gameplay.

Godot 4.6.3 editor import, UI regression (keyboard, debug gating và bố cục 720p/1080p), gameplay smoke (di chuyển/collision/mailbox/camera) và git diff --check được chạy. Cấu hình project ngoài dòng config/name giống nguyên bản. Không chạy lại gate V10 khóa nguyên file project.godot như một phép kiểm tra rename, vì đổi config/name là thay đổi có chủ đích được yêu cầu. Thay vào đó đối chiếu bytes toàn bộ assets/scenes/gameplay và các tham số renderer với HEAD trước branding.

Không merge PR. Commit branding trên feature/map01-lighting-presets để review trong PR #10; main giữ nguyên. README/tên game mới trên main chỉ xuất hiện khi người dùng duyệt/merge thay đổi.

## Sau khi người dùng đổi tên GitHub

URL dự kiến: https://github.com/VietCodeBug/a-place-to-belong (chỉ xác nhận sau khi đổi thành công). GitHub thường redirect URL cũ; giữ các archive/preview refs nguyên trạng. Cập nhật origin bằng:

```sh
git remote set-url origin https://github.com/VietCodeBug/a-place-to-belong.git
```

Khi tên mới tồn tại, cập nhật các URL GitHub tài liệu đang dùng và mô tả repository theo tagline. Kiểm tra lại repo binding trong Codex nếu giao diện vẫn hiển thị slug cũ; workspace /workspace/forest-post-cafe không cần đổi để game chạy. Không đổi docs/story hoặc tên nhánh story/forest-post-cafe-narrative trong bước đó.
