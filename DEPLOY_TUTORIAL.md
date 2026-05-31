# HƯỚNG DẪN TRIỂN KHAI VÀ DEPLOY MÃ NGUỒN (DEPLOY_TUTORIAL)

Hệ thống Quản lý Thuê xe Ô tô Tự lái (Car Rental Management System)  
**Môn học:** SWP391  
**Phân hệ:** Đặt Xe (Booking Module)  
**Người thực hiện:** Bùi Xuân Bắc (HE186736)

---

## 1. Mô Tả Môi Trường Lập Trình (Development Environment)

Để đảm bảo hệ thống vận hành đúng và không xảy ra xung đột thư viện, vui lòng chuẩn bị môi trường phát triển chính xác như sau:

* **Hệ điều hành:** Windows 10 hoặc Windows 11.
* **Môi trường phát triển tích hợp (IDE):** Apache NetBeans phiên bản 30 trở lên.
* **Bộ phát triển Java (JDK):** JDK 21 (Bắt buộc, hỗ trợ các tính năng Java hiện đại và tương thích với cấu hình POM.xml).
* **Máy chủ ứng dụng (Web Server):** Apache Tomcat phiên bản 10.1.55 (Hỗ trợ Jakarta EE 10 - Servlet 6.0 / JSP 3.0).  
  * *Lưu ý:* Tomcat 9 trở xuống dùng namespace `javax.*` sẽ bị lỗi biên dịch. Tomcat 10+ bắt buộc dùng namespace `jakarta.*`.
* **Hệ quản trị cơ sở dữ liệu:** Microsoft SQL Server 2019/2022 kết hợp SQL Server Management Studio (SSMS).

---

## 2. Cấu Hình Thư Viện Và Dịch Vụ (Libraries & Services Configuration)

### A. Quản lý Thư viện qua Maven (`pom.xml`):
Dự án được quản lý bằng Maven. Các thư viện bắt buộc đã được khai báo sẵn trong `pom.xml`:

```xml
<!-- Jakarta Servlet API -->
<dependency>
    <groupId>jakarta.servlet</groupId>
    <artifactId>jakarta.servlet-api</artifactId>
    <version>6.0.0</version>
    <scope>provided</scope>
</dependency>

<!-- Jakarta Server Pages (JSP) API -->
<dependency>
    <groupId>jakarta.servlet.jsp</groupId>
    <artifactId>jakarta.servlet.jsp-api</artifactId>
    <version>3.1.1</version>
    <scope>provided</scope>
</dependency>

<!-- Jakarta Standard Tag Library (JSTL) -->
<dependency>
    <groupId>glassfish.jakarta.jstl</groupId>
    <artifactId>jakarta.jstl-api</artifactId>
    <version>3.0.0</version>
</dependency>
<dependency>
    <groupId>org.glassfish.web</groupId>
    <artifactId>jakarta.jstl</artifactId>
    <version>3.0.1</version>
</dependency>

<!-- Microsoft SQL Server JDBC Driver -->
<dependency>
    <groupId>com.microsoft.sqlserver</groupId>
    <artifactId>mssql-jdbc</artifactId>
    <version>12.6.1.jre11</version>
</dependency>
```

### B. Cấu Hình Kết Nối Cơ Sở Dữ Liệu (`db.properties`):
Thông tin kết nối SQL Server được định cấu hình tập trung tại file:  
`src/main/resources/db.properties`

Nội dung cấu hình mặc định:
```properties
db.server=localhost
db.port=1433
db.name=CarRentalDB
db.user=sa
db.password=123
db.encrypt=true
db.trustServerCertificate=true
```
*Hãy thay đổi các giá trị `db.user` và `db.password` cho phù hợp với tài khoản SQL Server trên máy tính của bạn.*

---

## 3. Các Bước Triển Khai Chi Tiết (Step-by-Step Deployment)

### Bước 1: Thiết lập Cơ sở dữ liệu
1. Mở phần mềm **SQL Server Management Studio (SSMS)** và kết nối vào Server của bạn.
2. Mở và chạy file kịch bản cấu trúc bảng tại: `database/schema.sql` để khởi tạo database `CarRentalDB` và toàn bộ các bảng dữ liệu liên quan.
3. Mở và chạy file kịch bản tạo dữ liệu mẫu tại: `database/sample-data.sql` để nhập sẵn danh sách xe, người dùng mẫu, chính sách thuê xe.

### Bước 2: Import dự án vào NetBeans
1. Mở **Apache NetBeans**.
2. Chọn **File** -> **Open Project**.
3. Duyệt đến thư mục `car-rental-management` chứa mã nguồn và nhấn **Open Project**. NetBeans sẽ tự động nhận diện dự án Maven.

### Bước 3: Cấu hình Máy chủ Web Tomcat 10.1.55 trong NetBeans
1. Chuyển sang tab **Services** trong NetBeans (nếu không thấy, chọn **Window** -> **Services**).
2. Click chuột phải vào **Servers** -> Chọn **Add Server**.
3. Chọn **Apache Tomcat or TomEE** -> Nhấn **Next**.
4. Trỏ tới thư mục cài đặt Apache Tomcat 10.1.55 trên máy tính của bạn.
5. Nhập Username/Password quản trị Tomcat và nhấn **Finish**.

### Bước 4: Kiểm tra Cấu hình Kết nối CSDL
1. Kiểm tra lại thông số kết nối cơ sở dữ liệu trong file `src/main/resources/db.properties`.
2. Đảm bảo dịch vụ SQL Server (MSSQLSERVER) đang hoạt động và cổng TCP/IP `1433` đã được kích hoạt trong *SQL Server Configuration Manager*.

### Bước 5: Build và Deploy ứng dụng
1. Click chuột phải vào tên dự án `car-rental-management` trong tab *Projects*.
2. Chọn **Clean and Build** để tải các thư viện Maven cần thiết và biên dịch mã nguồn.
3. Sau khi quá trình build thành công, click chuột phải vào dự án và chọn **Run**.
4. Chọn máy chủ **Apache Tomcat 10.1.55** đã cấu hình ở Bước 3.
5. Trình duyệt sẽ tự động mở trang chủ tại địa chỉ:  
   `http://localhost:8080/car-rental-management/`

---

## 4. Danh Sách Các URL Kiểm Thử Phân Hệ Đặt Xe
Sau khi ứng dụng khởi chạy thành công, bạn có thể đăng nhập bằng tài khoản mẫu trong Database và kiểm thử các đường dẫn sau:

* **Trang chủ danh sách xe:** `/` hoặc `/home`
* **Đăng nhập:** `/login` (Khách hàng mẫu: `customer@gmail.com` / Mật khẩu: `123`)
* **Tạo đơn đặt xe (Booking):** `/bookings/create?carId=1`
* **Xem lịch sử đặt xe cá nhân:** `/bookings/my`
* **Xem chi tiết đặt xe:** `/bookings/detail?id=<Booking_ID>`
* **Chỉnh sửa / Hủy đặt xe:** `/bookings/edit?id=<Booking_ID>`
* **Xem chính sách đặt xe:** `/bookings/policy`
* **Bảng điều khiển duyệt booking (Staff):** `/bookings/management`
