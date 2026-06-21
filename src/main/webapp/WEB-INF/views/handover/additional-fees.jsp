<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<jsp:include page="/WEB-INF/views/layout/header.jsp">
    <jsp:param name="pageTitle" value="Bảng tính Phụ phí Phát sinh"/>
</jsp:include>

<div class="bk-page-header">
    <div>
        <div class="bk-breadcrumb">
            <a href="${pageContext.request.contextPath}/home">Trang chủ</a>
            <span class="material-symbols-outlined">chevron_right</span>
            <a href="${pageContext.request.contextPath}/returns">Nhận lại xe</a>
            <span class="material-symbols-outlined">chevron_right</span>
            <span class="current">Xem biên bản nhận lại xe</span>
        </div>
        <h2>Bảng tính Phụ thu & Máy tính Phụ phí</h2>
        <p>Hệ thống tự động tra cứu chính sách phạt trễ giờ, quá số km, vệ sinh và hư hỏng của nhà xe khi bàn giao xe. (BR-07)</p>
    </div>
</div>
<form method="post" action="${pageContext.request.contextPath}/additional-fees">
    <div class="bk-detail-grid">
        <%-- LEFT: Máy tính phụ thu tương tác --%>
        <div>
            <div class="bk-card">
                <div class="bk-card-title">
                    <span class="material-symbols-outlined">calculate</span> Máy tính giả lập Phụ thu nhận xe
                </div>

                <input type="hidden" name="bookingId" value="${bookingId}" />
                <input type="hidden" name="carId" value="${carId}" />
                <div class="bk-form-grid" style="gap:20px;">
                    <div class="bk-form-group">
                        <label class="bk-form-label">Số giờ trả xe trễ hạn (Giờ)</label>
                        <div class="bk-form-input-wrap">
                            <span class="material-symbols-outlined">schedule</span>
                            <input type="number" id="lateHours" class="bk-form-input" value="${returns.lateFee}" min="0" style="padding-left:40px;" />
                        </div>
                        <span style="font-size:12px;color:var(--outline);margin-top:2px;">(Quy định phạt: 100,000đ / giờ)</span>
                    </div>

                    <div class="bk-form-group">
                        <label class="bk-form-label">Quãng đường đi vượt định mức (km)</label>
                        <div class="bk-form-input-wrap">
                            <span class="material-symbols-outlined">speed</span>
                            <input type="number" id="overKm" class="bk-form-input" value="${returns.overKm} min="0" style="padding-left:40px;" />
                        </div>
                        <span style="font-size:12px;color:var(--outline);margin-top:2px;">(Quy định phạt: 5,000đ / km)</span>
                    </div>

                    <div class="bk-form-group">
                        <label class="bk-form-label">Vệ sinh khoang xe dơ bẩn</label>
                        <div class="bk-form-input-wrap">
                            <span class="material-symbols-outlined">local_laundry_service</span>
                            <select id="cleaningFee" class="bk-form-select">
                                <option value="0" ${returns.cleaningFee == 0 ? "selected" : ""}>Sạch sẽ - 0đ</option>
                                <option value="300000" ${returns.cleaningFee == 300000 ? "selected" : ""}>Quá bẩn / Mùi thuốc lá - 300,000đ</option>
                                <option value="600000" ${returns.cleaningFee == 600000 ? "selected" : ""}>Cực kỳ dơ / Nôn trớ - 600,000đ</option>
                            </select>
                        </div>
                    </div>

                    <div class="bk-form-group">
                        <label class="bk-form-label">Bồi thường hư hỏng linh kiện / mất đồ</label>
                        <div class="bk-form-input-wrap">
                            <span class="material-symbols-outlined">handyman</span>
                            <input type="number" id="damageFee" class="bk-form-input" value="${returns.damageFee + returns.lostItemFee}" min="0" style="padding-left:40px;" placeholder="Nhập số tiền..." />
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <%-- RIGHT: Bảng Tổng hợp chi phí tính toán động --%>
        <div>
            <div class="bk-cost-card">
                <h3><span class="material-symbols-outlined">receipt_long</span> Tóm tắt Phụ thu</h3>

                <div class="bk-detail-rows" style="gap:16px;">
                    <div class="bk-detail-row">
                        <span class="label">Phí trễ hạn</span>
                        <span class="value" id="resLate">0đ</span>
                    </div>
                    <div class="bk-detail-row">
                        <span class="label">Phí quá số km</span>
                        <span class="value" id="resKm">0đ</span>
                    </div>
                    <div class="bk-detail-row">
                        <span class="label">Phí dọn dẹp xe</span>
                        <span class="value" id="resClean">0đ</span>
                    </div>
                    <div class="bk-detail-row">
                        <span class="label">Phí đền bù hư hỏng</span>
                        <span class="value" id="resDamage">0đ</span>
                    </div>
                </div>

                <input type="hidden" name="lateFee" id="lateFeeInput">
                <input type="hidden" name="extraKmFee" id="kmFeeInput">
                <input type="hidden" name="cleaningFee" id="cleaningFeeInput">
                <input type="hidden" name="damageFee" id="damageInput">
                <input type="hidden" name="lostItemFee" id="lostItemInput">
                <input type="hidden" name="totalAdditionalFee" id="totalInput">

                <div class="bk-summary-total">
                    <span class="label">Tổng phụ thu</span>
                    <span class="value" id="resTotal" style="color:var(--error);font-size:24px;font-weight:800;">0đ</span>
                    ${notification}
                </div>

                <div style="margin-top:24px;display:flex;flex-direction:column;gap:12px;">
                    <button type="submit" name="action" value="save" class="bk-btn bk-btn-primary" style="width:100%;justify-content:center;">
                        <span class="material-symbols-outlined">check_circle</span> Áp dụng & Lưu biên bản
                    </button>
                    <a href="${pageContext.request.contextPath}/returns/detail?bookingId=${bookingId}&carId=${carId}" class="bk-btn bk-btn-outline" style="width:100%;justify-content:center;">
                        <span class="material-symbols-outlined">arrow_back</span> Hủy bỏ
                    </a>
                </div>
            </div>
        </div>
    </div>
</form>

<script>
    document.addEventListener("DOMContentLoaded", function () {

        document.getElementById('lateHours').addEventListener('input', recalculateFees);
        document.getElementById('overKm').addEventListener('input', recalculateFees);
        document.getElementById('damageFee').addEventListener('input', recalculateFees);
        document.getElementById('cleaningFee').addEventListener('change', recalculateFees);

        recalculateFees();
    });

    function recalculateFees() {
        // ===== INPUT LEFT =====
        let lateHours = parseFloat(document.getElementById('lateHours').value) || 0;
        let overKm = parseFloat(document.getElementById('overKm').value) || 0;
        let cleaning = parseFloat(document.getElementById('cleaningFee').value) || 0;
        let damage = parseFloat(document.getElementById('damageFee').value) || 0;

        // ===== CALCULATE =====
        let lateFee = lateHours * 100000;
        let kmFee = overKm * 5000;

        let total = lateFee + kmFee + cleaning + damage;

        // ===== RIGHT UI =====
        document.getElementById('resLate').innerText = formatMoney(lateFee);
        document.getElementById('resKm').innerText = formatMoney(kmFee);
        document.getElementById('resClean').innerText = formatMoney(cleaning);
        document.getElementById('resDamage').innerText = formatMoney(damage);
        document.getElementById('resTotal').innerText = formatMoney(total);

        // ===== HIDDEN INPUT (FOR DB) =====
        document.getElementById('lateFeeInput').value = lateFee;
        document.getElementById('kmFeeInput').value = kmFee;
        document.getElementById('cleaningFeeInput').value = cleaning;
        document.getElementById('damageInput').value = damage;
        document.getElementById('totalInput').value = total;
    }

    function formatMoney(amount) {
        return new Intl.NumberFormat('vi-VN', {
            style: 'currency',
            currency: 'VND'
        }).format(amount).replace('₫', 'đ');
    }
</script>

<jsp:include page="/WEB-INF/views/layout/footer.jsp"/>
