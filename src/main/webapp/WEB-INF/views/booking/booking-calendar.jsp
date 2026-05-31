<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<jsp:include page="/WEB-INF/views/layout/header.jsp">
    <jsp:param name="pageTitle" value="Lịch Đặt Xe"/>
</jsp:include>

<div class="bk-page-header">
    <div>
        <h2>Lịch Đặt Xe</h2>
        <p>Xem thời gian xe đã được đặt trước.</p>
    </div>
</div>

<div class="bk-table-container">
    <div class="bk-table-toolbar">
        <div class="bk-table-search">
            <span class="material-symbols-outlined">search</span>
            <input type="text" id="searchInput" placeholder="Tìm theo tên xe, biển số..." oninput="filterTable()">
        </div>
    </div>

    <c:if test="${not empty bookings}">
        <div style="overflow-x:auto;">
            <table class="bk-table" id="calendarTable">
                <thead>
                    <tr>
                        <th>Mã Booking</th>
                        <th>Xe</th>
                        <th>Khách hàng</th>
                        <th>Ngày bắt đầu</th>
                        <th>Ngày kết thúc</th>
                        <th>Trạng thái</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="b" items="${bookings}">
                        <tr>
                            <td class="code">
                                <a href="${pageContext.request.contextPath}/bookings/detail?id=${b.bookingId}" style="color:var(--primary);text-decoration:none;">
                                    BK-${b.bookingId}
                                </a>
                            </td>
                            <td>
                                <c:if test="${not empty carMap[b.carId]}">
                                    ${carMap[b.carId].brand} ${carMap[b.carId].model}
                                    <div class="sub">${carMap[b.carId].licensePlate}</div>
                                </c:if>
                                <c:if test="${empty carMap[b.carId]}">Xe #${b.carId}</c:if>
                            </td>
                            <td>
                                <c:if test="${not empty userMap[b.customerId]}">
                                    ${userMap[b.customerId].fullName}
                                </c:if>
                                <c:if test="${empty userMap[b.customerId]}">User #${b.customerId}</c:if>
                            </td>
                            <td>
                                <fmt:parseDate value="${b.startDate}" pattern="yyyy-MM-dd'T'HH:mm" var="sd" type="both"/>
                                <fmt:formatDate value="${sd}" pattern="dd/MM/yyyy HH:mm"/>
                            </td>
                            <td>
                                <fmt:parseDate value="${b.endDate}" pattern="yyyy-MM-dd'T'HH:mm" var="ed" type="both"/>
                                <fmt:formatDate value="${ed}" pattern="dd/MM/yyyy HH:mm"/>
                            </td>
                            <td>
                                <c:choose>
                                    <c:when test="${b.status == 'PENDING'}"><span class="bk-badge bk-badge-pending"><span class="bk-badge-dot"></span> Chờ duyệt</span></c:when>
                                    <c:when test="${b.status == 'CONFIRMED'}"><span class="bk-badge bk-badge-confirmed"><span class="bk-badge-dot"></span> Đã xác nhận</span></c:when>
                                    <c:when test="${b.status == 'IN_PROGRESS'}"><span class="bk-badge bk-badge-progress"><span class="bk-badge-dot"></span> Đang thuê</span></c:when>
                                    <c:when test="${b.status == 'COMPLETED'}"><span class="bk-badge bk-badge-completed"><span class="bk-badge-dot"></span> Hoàn tất</span></c:when>
                                    <c:otherwise><span class="bk-badge">${b.status}</span></c:otherwise>
                                </c:choose>
                            </td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        </div>
    </c:if>
    <c:if test="${empty bookings}">
        <div class="bk-empty">
            <span class="material-symbols-outlined">event_busy</span>
            <h3>Chưa có lịch đặt xe</h3>
        </div>
    </c:if>
</div>

<script>
function filterTable() {
    var input = document.getElementById('searchInput').value.toLowerCase();
    var rows = document.querySelectorAll('#calendarTable tbody tr');
    rows.forEach(function(row) {
        row.style.display = row.textContent.toLowerCase().includes(input) ? '' : 'none';
    });
}
</script>

<jsp:include page="/WEB-INF/views/layout/footer.jsp"/>
