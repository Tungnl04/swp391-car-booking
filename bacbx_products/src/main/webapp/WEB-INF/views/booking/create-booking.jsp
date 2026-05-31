<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<jsp:include page="/WEB-INF/views/booking/booking-header.jsp">
    <jsp:param name="pageTitle" value="Tạo Đặt Xe"/>
</jsp:include>

<c:if test="${not empty error}">
    <div class="bk-alert bk-alert-error">
        <span class="material-symbols-outlined">error</span> ${error}
    </div>
</c:if>

<%-- Page Header --%>
<div class="bk-page-header">
    <div>
        <div class="bk-breadcrumb">
            <a href="${pageContext.request.contextPath}/bookings/my">Đặt xe</a>
            <span class="material-symbols-outlined">chevron_right</span>
            <span class="current">Tạo đặt xe</span>
        </div>
        <h2>Tạo đơn đặt xe mới</h2>
    </div>
    <a href="${pageContext.request.contextPath}/bookings/my" class="bk-btn bk-btn-outline">Hủy</a>
</div>

<%-- Booking Grid: Form left, Summary right --%>
<div class="bk-booking-grid">
    <%-- LEFT: Form --%>
    <div>
        <div class="bk-card">
            <div class="bk-card-title">
                <span class="material-symbols-outlined">assignment</span> Chi tiết Đặt xe
            </div>

            <form method="post" action="${pageContext.request.contextPath}/bookings/create" id="bookingForm">

                <%-- Car Selection --%>
                <div class="bk-form-section" style="margin-bottom:24px;">
                    <div class="bk-form-group">
                        <label class="bk-form-label">Chọn xe</label>
                        <div class="bk-form-input-wrap">
                            <span class="material-symbols-outlined">directions_car</span>
                            <select name="carId" id="carSelect" class="bk-form-select" required onchange="updateCarInfo()">
                                <option value="">-- Chọn xe --</option>
                                <c:forEach var="car" items="${cars}">
                                    <option value="${car.carId}"
                                            data-brand="${car.brand}"
                                            data-model="${car.model}"
                                            data-plate="${car.licensePlate}"
                                            data-price="${car.dailyRate}"
                                            ${selectedCarId == car.carId ? 'selected' : ''}>
                                        ${car.brand} ${car.model} — ${car.licensePlate}
                                    </option>
                                </c:forEach>
                            </select>
                        </div>
                    </div>
                </div>

                <hr style="border:none;border-top:1px solid var(--outline-variant);margin:24px 0;">

                <%-- Schedule --%>
                <div class="bk-form-section" style="margin-bottom:24px;">
                    <h3>Lịch trình</h3>
                    <div class="bk-form-grid">
                        <div class="bk-form-group">
                            <label class="bk-form-label">Ngày bắt đầu</label>
                            <div class="bk-form-input-wrap">
                                <span class="material-symbols-outlined">calendar_month</span>
                                <input type="date" name="startDate" id="startDate" class="bk-form-input" required onchange="calculateCost()">
                            </div>
                        </div>
                        <div class="bk-form-group">
                            <label class="bk-form-label">Giờ bắt đầu</label>
                            <div class="bk-form-input-wrap">
                                <span class="material-symbols-outlined">schedule</span>
                                <input type="time" name="startTime" id="startTime" class="bk-form-input" value="08:00" required>
                            </div>
                        </div>
                        <div class="bk-form-group">
                            <label class="bk-form-label">Ngày kết thúc</label>
                            <div class="bk-form-input-wrap">
                                <span class="material-symbols-outlined">event</span>
                                <input type="date" name="endDate" id="endDate" class="bk-form-input" required onchange="calculateCost()">
                            </div>
                        </div>
                        <div class="bk-form-group">
                            <label class="bk-form-label">Giờ kết thúc</label>
                            <div class="bk-form-input-wrap">
                                <span class="material-symbols-outlined">schedule</span>
                                <input type="time" name="endTime" id="endTime" class="bk-form-input" value="08:00" required>
                            </div>
                        </div>
                    </div>
                </div>

                <%-- Locations --%>
                <div class="bk-form-section" style="margin-bottom:24px;">
                    <h3>Địa điểm</h3>
                    <div class="bk-form-grid">
                        <div class="bk-form-group">
                            <label class="bk-form-label">Điểm nhận xe</label>
                            <div class="bk-form-input-wrap">
                                <span class="material-symbols-outlined">location_on</span>
                                <input type="text" name="pickupLocation" class="bk-form-input" placeholder="Văn phòng chính" required>
                            </div>
                        </div>
                        <div class="bk-form-group">
                            <label class="bk-form-label">Điểm trả xe</label>
                            <div class="bk-form-input-wrap">
                                <span class="material-symbols-outlined">pin_drop</span>
                                <input type="text" name="returnLocation" class="bk-form-input" placeholder="Văn phòng chính" required>
                            </div>
                        </div>
                    </div>
                </div>

                <%-- Notes --%>
                <div class="bk-form-group" style="margin-bottom:24px;">
                    <label class="bk-form-label">Ghi chú (Tùy chọn)</label>
                    <textarea name="notes" class="bk-form-textarea" rows="3" placeholder="Thêm bất kỳ yêu cầu đặc biệt hoặc ghi chú liên quan..."></textarea>
                </div>

                <%-- Actions --%>
                <div class="bk-form-actions">
                    <button type="submit" class="bk-btn bk-btn-primary" style="padding:12px 32px;">
                        <span class="material-symbols-outlined">check_circle</span> Gửi Đơn Đặt xe
                    </button>
                </div>
            </form>
        </div>
    </div>

    <%-- RIGHT: Vehicle + Cost Summary --%>
    <div>
        <%-- Selected Vehicle --%>
        <div class="bk-cost-card bk-vehicle-card" style="margin-bottom:24px;">
            <div class="header">
                <h3><span class="material-symbols-outlined">directions_car</span> Xe đã chọn</h3>
            </div>
            <div id="vehicleInfo" style="color:var(--on-surface-variant);font-size:14px;">
                <p>Vui lòng chọn xe từ danh sách bên trái.</p>
            </div>
        </div>

        <%-- Financial Summary --%>
        <div class="bk-cost-card">
            <h3><span class="material-symbols-outlined">receipt_long</span> Tóm tắt Tài chính</h3>
            <div class="bk-detail-rows">
                <div class="bk-detail-row">
                    <span class="label">Giá cơ bản (<span id="daysCount">0</span> ngày)</span>
                    <span class="value" id="baseCost">0 ₫</span>
                </div>
                <div class="bk-detail-row">
                    <span class="label">Thuế & Phí (10%)</span>
                    <span class="value" id="taxCost">0 ₫</span>
                </div>
            </div>
            <div class="bk-summary-total">
                <span class="label">Số tiền ước tính</span>
                <span class="value" id="totalCost">0 ₫</span>
            </div>
            <div class="bk-summary-highlight">
                <div>
                    <div class="label">Tiền cọc Yêu cầu</div>
                    <div style="font-size:12px;color:var(--on-surface-variant);">Tạm giữ</div>
                </div>
                <span class="value" id="depositCost">0 ₫</span>
            </div>
        </div>
    </div>
</div>

<script>
var carPrices = {};
var depositPct = ${depositPercentage != null ? depositPercentage : 30};
<c:forEach var="car" items="${cars}">
    carPrices[${car.carId}] = ${car.dailyRate};
</c:forEach>

function formatVND(num) {
    return new Intl.NumberFormat('vi-VN').format(num) + ' ₫';
}

function updateCarInfo() {
    var sel = document.getElementById('carSelect');
    var opt = sel.options[sel.selectedIndex];
    var info = document.getElementById('vehicleInfo');
    if (!opt.value) {
        info.innerHTML = '<p>Vui lòng chọn xe từ danh sách bên trái.</p>';
        return;
    }
    var brand = opt.getAttribute('data-brand');
    var model = opt.getAttribute('data-model');
    var plate = opt.getAttribute('data-plate');
    var price = parseFloat(opt.getAttribute('data-price'));
    info.innerHTML =
        '<div style="font-size:24px;font-weight:600;color:var(--on-surface);letter-spacing:-0.01em;">' + brand + ' ' + model + '</div>' +
        '<div class="bk-vehicle-specs" style="margin-top:12px;">' +
            '<div><span class="spec-label">Biển số xe</span><div class="spec-value">' + plate + '</div></div>' +
            '<div><span class="spec-label">Giá theo ngày</span><div class="spec-value">' + formatVND(price) + '</div></div>' +
        '</div>';
    calculateCost();
}

function calculateCost() {
    var carId = document.getElementById('carSelect').value;
    var sd = document.getElementById('startDate').value;
    var ed = document.getElementById('endDate').value;
    if (!carId || !sd || !ed) return;

    var start = new Date(sd);
    var end = new Date(ed);
    var days = Math.ceil((end - start) / (1000 * 60 * 60 * 24));
    if (days < 1) days = 1;

    var price = carPrices[carId] || 0;
    var base = price * days;
    var deposit = Math.ceil(base * depositPct / 100);
    var tax = base * 0.1;
    var total = base + tax;

    document.getElementById('daysCount').textContent = days;
    document.getElementById('baseCost').textContent = formatVND(base);
    document.getElementById('taxCost').textContent = formatVND(Math.round(tax));
    document.getElementById('totalCost').textContent = formatVND(Math.round(total));
    document.getElementById('depositCost').textContent = formatVND(deposit);
}

// Init if car is pre-selected
document.addEventListener('DOMContentLoaded', function() {
    var sel = document.getElementById('carSelect');
    if (sel.value) { updateCarInfo(); }
    // Set min date to today
    var today = new Date().toISOString().split('T')[0];
    document.getElementById('startDate').setAttribute('min', today);
    document.getElementById('endDate').setAttribute('min', today);
});
</script>

<jsp:include page="/WEB-INF/views/booking/booking-footer.jsp"/>
