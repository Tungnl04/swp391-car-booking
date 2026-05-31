<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<aside class="sidebar" id="sidebar">
    <div class="sidebar-header">
        <h2>🚗 Thuê Xe</h2>
        <div class="subtitle">Hệ Thống Quản Lý</div>
    </div>
    <ul class="sidebar-menu">
        <li class="menu-section">Chính</li>
        <li><a href="${pageContext.request.contextPath}/home" class="${pageContext.request.servletPath == '/home' ? 'active' : ''}">🏠 Trang Chủ</a></li>
        <li><a href="${pageContext.request.contextPath}/vehicles" class="${pageContext.request.servletPath.startsWith('/vehicles') && !pageContext.request.servletPath.startsWith('/vehicles/manage') ? 'active' : ''}">🚘 Danh Sách Xe</a></li>

        <c:if test="${sessionScope.currentUser != null}">
            <li class="menu-section">Tài Khoản</li>
            <li><a href="${pageContext.request.contextPath}/profile" class="${pageContext.request.servletPath == '/profile' ? 'active' : ''}">👤 Hồ Sơ</a></li>

            <c:if test="${sessionScope.currentUser.role == 'CUSTOMER'}">
                <li class="menu-section">Đặt Xe</li>
                <li><a href="${pageContext.request.contextPath}/bookings/create" class="${pageContext.request.servletPath == '/bookings/create' ? 'active' : ''}">📝 Đặt Xe Mới</a></li>
                <li><a href="${pageContext.request.contextPath}/bookings/my" class="${pageContext.request.servletPath == '/bookings/my' ? 'active' : ''}">📋 Chuyến Đi Của Tôi</a></li>
                <li><a href="${pageContext.request.contextPath}/bookings/policy" class="${pageContext.request.servletPath == '/bookings/policy' ? 'active' : ''}">⚖️ Chính Sách Đặt Xe</a></li>
            </c:if>

            <c:if test="${sessionScope.currentUser.role == 'STAFF' || sessionScope.currentUser.role == 'ADMIN'}">
                <li class="menu-section">Nghiệp Vụ</li>
                <li><a href="${pageContext.request.contextPath}/vehicles/manage" class="${pageContext.request.servletPath.startsWith('/vehicles/manage') ? 'active' : ''}">⚙️ Quản Lý Xe</a></li>
                <li><a href="${pageContext.request.contextPath}/maintenance" class="${pageContext.request.servletPath.startsWith('/maintenance') ? 'active' : ''}">🔧 Lịch Bảo Dưỡng</a></li>
                
                <li class="menu-section">Quản Lý Đặt Xe</li>
                <li><a href="${pageContext.request.contextPath}/bookings/manage" class="${pageContext.request.servletPath == '/bookings/manage' ? 'active' : ''}">📊 Quản Lý Đặt Xe</a></li>
                <li><a href="${pageContext.request.contextPath}/bookings/approval" class="${pageContext.request.servletPath == '/bookings/approval' ? 'active' : ''}">✅ Duyệt Đặt Xe</a></li>
                <li><a href="${pageContext.request.contextPath}/bookings/calendar" class="${pageContext.request.servletPath == '/bookings/calendar' ? 'active' : ''}">📅 Lịch Đặt Xe</a></li>
                <li><a href="${pageContext.request.contextPath}/bookings/policy" class="${pageContext.request.servletPath == '/bookings/policy' ? 'active' : ''}">⚖️ Chính Sách Đặt Xe</a></li>
                
                <li class="menu-section">Hợp Đồng & Giao Nhận</li>
                <li><a href="${pageContext.request.contextPath}/contracts" class="${pageContext.request.servletPath.startsWith('/contracts') ? 'active' : ''}">📄 Quản Lý Hợp Đồng</a></li>
                <li><a href="${pageContext.request.contextPath}/handovers" class="${pageContext.request.servletPath.startsWith('/handovers') ? 'active' : ''}">🔑 Giao Xe</a></li>
                <li><a href="${pageContext.request.contextPath}/returns" class="${pageContext.request.servletPath.startsWith('/returns') ? 'active' : ''}">🔄 Nhận Lại Xe</a></li>
                <li><a href="${pageContext.request.contextPath}/additional-fees" class="${pageContext.request.servletPath.startsWith('/additional-fees') ? 'active' : ''}">💰 Phí Phát Sinh</a></li>
                <li><a href="${pageContext.request.contextPath}/payments/record" class="${pageContext.request.servletPath.startsWith('/payments/record') ? 'active' : ''}">💳 Lịch Sử Thanh Toán</a></li>
                <li><a href="${pageContext.request.contextPath}/policies" class="${pageContext.request.servletPath == '/policies' ? 'active' : ''}">⚙️ Cấu Hình Chung</a></li>

                <li class="menu-section">Báo Cáo</li>
                <li><a href="${pageContext.request.contextPath}/reports/revenue" class="${pageContext.request.servletPath == '/reports/revenue' ? 'active' : ''}">📈 Báo Cáo Doanh Thu</a></li>
                <li><a href="${pageContext.request.contextPath}/reports/vehicle-utilization" class="${pageContext.request.servletPath == '/reports/vehicle-utilization' ? 'active' : ''}">📊 Hiệu Suất Sử Dụng Xe</a></li>
            </c:if>

            <c:if test="${sessionScope.currentUser.role == 'ADMIN'}">
                <li class="menu-section">Quản Trị Hệ Thống</li>
                <li><a href="${pageContext.request.contextPath}/users" class="${pageContext.request.servletPath.startsWith('/users') ? 'active' : ''}">👥 Quản Lý Người Dùng</a></li>
                <li><a href="${pageContext.request.contextPath}/roles" class="${pageContext.request.servletPath.startsWith('/roles') ? 'active' : ''}">🔐 Phân Quyền</a></li>
                <li><a href="${pageContext.request.contextPath}/tax-invoice-settings" class="${pageContext.request.servletPath.startsWith('/tax-invoice-settings') ? 'active' : ''}">🧾 Cấu Hình Thuế & Hóa Đơn</a></li>
            </c:if>
        </c:if>
    </ul>
</aside>
