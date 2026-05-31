<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<jsp:include page="/WEB-INF/views/layout/header.jsp">
    <jsp:param name="pageTitle" value="Quản Lý Xe"/>
</jsp:include>

<%-- Calculate dynamic stats --%>
<c:set var="totalCars" value="${cars.size()}"/>
<c:set var="availableCars" value="0"/>
<c:set var="maintenanceCars" value="0"/>
<c:set var="rentedCars" value="0"/>

<c:forEach var="car" items="${cars}">
    <c:choose>
        <c:when test="${car.status == 'AVAILABLE'}"><c:set var="availableCars" value="${availableCars + 1}"/></c:when>
        <c:when test="${car.status == 'MAINTENANCE'}"><c:set var="maintenanceCars" value="${maintenanceCars + 1}"/></c:when>
        <c:when test="${car.status == 'RENTED'}"><c:set var="rentedCars" value="${rentedCars + 1}"/></c:when>
    </c:choose>
</c:forEach>

<div class="bk-page-header">
    <div>
        <h2>Đội Xe</h2>
        <p>Quản lý và giám sát tất cả tài sản của đội xe.</p>
    </div>
    <div style="display: flex; gap: 8px;">
        <a href="${pageContext.request.contextPath}/vehicles/manage?status=MAINTENANCE" class="bk-btn bk-btn-outline">
            <span class="material-symbols-outlined" style="font-size: 18px;">build</span>
            Xe đang bảo trì
        </a>
    </div>
</div>

<%-- Stats/Summary Grid --%>
<div class="bk-stats-grid">
    <div class="bk-stat-card">
        <span class="label">Tổng Số Xe</span>
        <span class="value">${totalCars}</span>
    </div>
    <div class="bk-stat-card" style="border-left: 4px solid #2E7D32;">
        <span class="label">Có Sẵn</span>
        <span class="value">${availableCars}</span>
    </div>
    <div class="bk-stat-card" style="border-left: 4px solid #F57C00;">
        <span class="label">Đang Bảo Trì</span>
        <span class="value">${maintenanceCars}</span>
    </div>
    <div class="bk-stat-card" style="border-left: 4px solid #C62828;">
        <span class="label">Đã Thuê / Ra Ngoài</span>
        <span class="value">${rentedCars}</span>
    </div>
</div>

<%-- Data Table Card --%>
<div class="bk-table-container">
    <div class="bk-table-toolbar">
        <div class="bk-table-search">
            <span class="material-symbols-outlined">search</span>
            <input type="text" id="carSearchInput" placeholder="Tìm kiếm xe, biển số..." oninput="filterCarTable()">
        </div>
        <div style="display:flex; gap:12px; align-items:center;">
            <form method="get" action="${pageContext.request.contextPath}/vehicles/manage" style="display:flex; gap:8px;">
                <select name="status" class="form-control" style="padding: 8px 12px; border-radius: 8px; border: 1px solid var(--outline-variant); font-size:14px; outline:none; background: var(--surface-container-lowest);">
                    <option value="">Tất cả trạng thái</option>
                    <option value="AVAILABLE" ${selectedStatus == 'AVAILABLE' ? 'selected' : ''}>Có sẵn</option>
                    <option value="RENTED" ${selectedStatus == 'RENTED' ? 'selected' : ''}>Đã thuê</option>
                    <option value="MAINTENANCE" ${selectedStatus == 'MAINTENANCE' ? 'selected' : ''}>Bảo trì</option>
                    <option value="INACTIVE" ${selectedStatus == 'INACTIVE' ? 'selected' : ''}>Ngưng hoạt động</option>
                </select>
                <button type="submit" class="bk-btn bk-btn-outline bk-btn-sm" style="height: 38px;">Lọc</button>
                <c:if test="${not empty selectedStatus}">
                    <a href="${pageContext.request.contextPath}/vehicles/manage" class="bk-btn bk-btn-outline bk-btn-sm" style="height: 38px; display:flex; align-items:center; justify-content:center;">Xóa lọc</a>
                </c:if>
            </form>
        </div>
    </div>

    <c:if test="${not empty cars}">
        <div style="overflow-x:auto;">
            <table class="bk-table" id="vehicleTable">
                <thead>
                    <tr>
                        <th>Tên Xe</th>
                        <th>Biển Số</th>
                        <th>Giá hàng ngày</th>
                        <th>Tiền cọc (1 ngày)</th>
                        <th style="text-align: center;">Số ghế</th>
                        <th>Trạng Thái</th>
                        <th>Bảo Trì Tiếp Theo</th>
                        <th style="text-align: right;">Hành Động</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="car" items="${cars}">
                        <c:set var="maintenance" value="${nextMaintenance[car.carId]}"/>
                        <tr>
                            <td class="font-semibold" style="color: var(--primary);">${car.brand} ${car.model} (${car.year})</td>
                            <td class="font-mono" style="font-weight: 600;">${car.licensePlate}</td>
                            <td class="font-semibold"><fmt:formatNumber value="${car.dailyRate}" type="number" groupingUsed="true"/> VND</td>
                            <td>
                                <fmt:formatNumber value="${depositAmounts[car.carId]}" type="number" groupingUsed="true"/> VND
                                <span style="font-size:11px;color:var(--text-secondary);">(${depositPercentage}%)</span>
                            </td>
                            <td style="text-align: center; font-weight: 600;">${car.seats}</td>
                            <td>
                                <c:choose>
                                    <c:when test="${car.status == 'AVAILABLE'}"><span class="inline-block px-2.5 py-1 rounded bg-[#E8F5E9] text-[#2E7D32]" style="font-size:12px; font-weight:700;">Có Sẵn</span></c:when>
                                    <c:when test="${car.status == 'MAINTENANCE'}"><span class="inline-block px-2.5 py-1 rounded bg-[#FFF3E0] text-[#EF6C00]" style="font-size:12px; font-weight:700;">Bảo Trì</span></c:when>
                                    <c:when test="${car.status == 'RENTED'}"><span class="inline-block px-2.5 py-1 rounded bg-[#FFEBEE] text-[#C62828]" style="font-size:12px; font-weight:700;">Đã Thuê</span></c:when>
                                    <c:otherwise><span class="inline-block px-2.5 py-1 rounded bg-[#ECEFF1] text-[#37474F]" style="font-size:12px; font-weight:700;">Ngưng hoạt động</span></c:otherwise>
                                </c:choose>
                            </td>
                            <td>
                                <c:choose>
                                    <c:when test="${not empty maintenance}">
                                        <span style="font-weight: 600; color: var(--primary);">${maintenance.maintenanceType}</span><br/>
                                        <span style="font-size:12px; color:var(--text-secondary);">
                                            ${maintenance.scheduledDate} &middot; ${maintenance.status}
                                        </span>
                                    </c:when>
                                    <c:when test="${car.status == 'MAINTENANCE'}">
                                        <span style="color:#EF6C00; font-weight: 600;">Đang bảo trì</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span style="color:var(--text-secondary);">—</span>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                            <td style="text-align: right;">
                                <div style="display: inline-flex; gap: 4px; justify-content: flex-end;">
                                    <a href="${pageContext.request.contextPath}/vehicles/detail?id=${car.carId}" class="text-primary hover:text-primary-container p-1.5 rounded hover:bg-surface-container-low transition-colors" title="Xem chi tiết" style="display:inline-flex; align-items:center;">
                                        <span class="material-symbols-outlined" style="font-size: 20px;">visibility</span>
                                    </a>
                                    <a href="${pageContext.request.contextPath}/maintenance?carId=${car.carId}" class="text-[#F57C00] hover:text-[#E65100] p-1.5 rounded hover:bg-surface-container-low transition-colors" title="Lịch bảo trì" style="display:inline-flex; align-items:center;">
                                        <span class="material-symbols-outlined" style="font-size: 20px;">build</span>
                                    </a>
                                </div>
                            </td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        </div>
    </c:if>
    <c:if test="${empty cars}">
        <div class="bk-empty">
            <span class="material-symbols-outlined">directions_car</span>
            <h3>Không có xe nào khớp với bộ lọc</h3>
        </div>
    </c:if>
</div>

<script>
function filterCarTable() {
    const input = document.getElementById('carSearchInput').value.toLowerCase();
    const rows = document.querySelectorAll('#vehicleTable tbody tr');
    rows.forEach(row => {
        row.style.display = row.textContent.toLowerCase().includes(input) ? '' : 'none';
    });
}
</script>

<jsp:include page="/WEB-INF/views/layout/footer.jsp"/>
