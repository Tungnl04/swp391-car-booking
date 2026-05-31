# LỊCH SỬ COMMIT VÀ MERGE CODE - PHÂN HỆ BOOKING

Hệ thống Quản lý Thuê xe Ô tô Tự lái (Car Rental Management System)  
**Môn học:** SWP391  
**Học viên:** Bùi Xuân Bắc (Mã số SV: HE186736 / Account: BacBXHE186736)  
**Vai trò:** Developer phụ trách Phân hệ **Đặt Xe (Booking Module)**

---

## 1. Thông tin chi tiết các đợt Commit & Merge Code

| STT | Người Thực Hiện | Ngày Thực Hiện | Loại Giao Dịch | Nhánh (Branch) | Chi Tiết Nội Dung Thực Hiện / Các Tính Năng & Module |
| :--- | :--- | :--- | :--- | :--- | :--- |
| **1** | Bùi Xuân Bắc | 23/05/2026 | Commit | `bacdev` | Khởi tạo khung (Skeleton) cấu trúc cho phân hệ Đặt Xe; thiết lập Package `com.swp391.carrental.controller.booking`, viết khung Servlet và DAO cơ bản, cấu hình Javadocs tuân thủ quy tắc dự án. |
| **2** | Bùi Xuân Bắc | 29/05/2026 | Commit | `bacdev` | **Tích hợp giao diện mẫu & Thiết kế UI chi tiết:** Cấu hình mẫu CSS, tạo các file JSP cơ bản phục vụ quy trình đặt xe (`create-booking.jsp`, `my-bookings.jsp`), hoàn thiện giao diện xem danh sách xe và đặt xe. |
| **3** | Bùi Xuân Bắc | 30/05/2026 | Commit | `bacdev` | **Phát triển toàn bộ Backend và sửa đổi UI Bento cao cấp:**<br>1. Hoàn thiện Servlet `CreateBookingServlet` (xử lý đặt xe mới, ghép ngày + giờ sang `LocalDateTime` tránh lỗi crash 500, tính toán giá trị đặt cọc & tổng tiền dựa trên số ngày thuê thực tế).<br>2. Xây dựng Servlet `BookingEditServlet` phục vụ thay đổi thời gian thuê hoặc hủy đơn đặt xe (`/bookings/edit`, `/bookings/cancel`).<br>3. Tạo giao diện sửa đổi đặt xe `booking-edit.jsp` với bảng màu Indigo / Bento tinh tế, đồng bộ sidebar menu động thông qua context path để tránh lỗi active highlight.<br>4. Sửa lỗi logic model `pricePerDay` -> `dailyRate` và `rejectionReason` -> `cancelReason` trên tất cả các trang JSP để tránh lỗi runtime 500.<br>5. Đóng gói đầy đủ mã nguồn và biên dịch bằng Maven thành công không lỗi. |
| **4** | Bùi Xuân Bắc | 31/05/2026 | Merge | `bacdev` | **Đồng bộ hóa & Hoàn thiện tài liệu:**<br>1. Merge nhánh `main` vào nhánh `bacdev` để đồng bộ hóa tài nguyên giao diện `UIDesign/` mới nhất của cả nhóm.<br>2. Tạo thư mục lưu trữ sản phẩm riêng `bacbx_products/` chứa mã nguồn riêng của Bắc trước khi bàn giao tích hợp.<br>3. Viết tài liệu hướng dẫn deploy `DEPLOY_TUTORIAL.md` và tài liệu ghi lịch sử commit/merge `COMMIT_MERGE_LOG.md` theo yêu cầu của Giảng viên. |

---

## 2. Danh sách sản phẩm tính năng chi tiết đã bàn giao (Booking Module)

Dưới đây là các lớp và trang giao diện thuộc phân hệ Đặt Xe đã được hoàn thiện:

### A. Lớp Nghiệp Vụ & Dữ Liệu (Java - Backend):
* **Controllers (Servlets):**
  * `CreateBookingServlet.java`: Tiếp nhận yêu cầu đặt xe từ khách hàng, validate dữ liệu đầu vào, gọi service lưu xuống Database.
  * `BookingDetailServlet.java`: Xem chi tiết phiếu đặt xe cho Khách hàng (chỉ đọc) và Nhân viên (có nút duyệt/từ chối).
  * `BookingEditServlet.java`: Xử lý chỉnh sửa thông tin ngày/giờ thuê hoặc gửi yêu cầu hủy đơn hàng ở trạng thái `PENDING`.
  * `MyBookingsServlet.java`: Hiển thị danh sách các đơn đặt xe của tài khoản khách hàng hiện tại.
  * `BookingCalendarServlet.java` & `BookingPolicyServlet.java`: Hiển thị lịch trình đặt xe và chính sách thuê xe.
  * `BookingManagementServlet.java` & `BookingApprovalServlet.java`: Phục vụ nhân viên quản trị theo dõi trạng thái booking và thực hiện phê duyệt/từ chối.
* **Services & DAOs:**
  * `BookingService.java`: Điều phối nghiệp vụ đặt xe, kiểm tra xung đột trùng lịch thuê (BR-01, BR-02).
  * `BookingDAO.java`: Thực thi các truy vấn SQL an toàn với SQL Server (PreparedStatement) để truy xuất dữ liệu đặt xe.

### B. Trang Giao Diện (JSP & CSS - Frontend):
* `create-booking.jsp`: Form nhập thông tin đặt xe với bộ tính ngày tự động bằng JS.
* `booking-detail.jsp`: Trang chi tiết phiếu đặt xe dành cho Khách hàng (có tích hợp nút Sửa/Hủy đơn).
* `booking-detail-staff.jsp`: Trang phê duyệt của Nhân viên (nút Approve/Reject kèm lý do từ chối).
* `booking-edit.jsp`: Form sửa đổi thông tin đặt xe (tự động tính toán lại giá tiền và tiền đặt cọc theo số ngày mới).
* `booking-management.jsp` & `booking-calendar.jsp`: Quản lý và xem trực quan tiến trình các đơn đặt xe.
* `booking-header.jsp` & `booking-footer.jsp`: Thanh tiêu đề b Bento và chân trang đồng bộ, hoạt động hover/active mượt mà.
* `assets/css/booking-style.css`: File định nghĩa giao diện kính mờ (glassmorphism), tông màu tối Indigo hiện đại.
