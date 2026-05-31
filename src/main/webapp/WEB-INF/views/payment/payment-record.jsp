<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c"   uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"  %>
<%
    request.setAttribute("dateTimeFormatter", java.time.format.DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm"));
%>
<jsp:include page="/WEB-INF/views/layout/header.jsp">
    <jsp:param name="pageTitle" value="Thanh Toán & Giao Dịch"/>
</jsp:include>

<div class="page-content">

    <%-- Toast container for screen notifications --%>
    <div class="toast-container" id="toast-container">
        <c:if test="${not empty sessionScope.paymentSuccess}">
            <div class="toast toast-success" id="toast-success">
                <div class="toast-content">
                    <span class="toast-icon">✨</span>
                    <span class="toast-message">${sessionScope.paymentSuccess}</span>
                </div>
                <button class="toast-close" onclick="closeToast('toast-success')">&times;</button>
            </div>
            <c:remove var="paymentSuccess" scope="session"/>
        </c:if>
        <c:if test="${not empty errorMsg}">
            <div class="toast toast-error" id="toast-error">
                <div class="toast-content">
                    <span class="toast-icon">⚠️</span>
                    <span class="toast-message">${errorMsg}</span>
                </div>
                <button class="toast-close" onclick="closeToast('toast-error')">&times;</button>
            </div>
        </c:if>
    </div>

    <%-- Record New Payment Form --%>
    <div class="card" style="margin-bottom:24px;">
        <div class="card-header">
            <h3>➕ Ghi Nhận Thanh Toán Mới</h3>
        </div>
        <div style="padding:20px;">
            <form method="POST" action="${pageContext.request.contextPath}/payments/record" id="form-record-payment">
                <div style="display:grid;grid-template-columns:1fr 1fr 1fr;gap:16px;">

                    <div class="form-group">
                        <label for="bookingId">Mã Đặt Xe *</label>
                        <input type="number" id="bookingId" name="bookingId" class="form-input" required placeholder="VD: 1">
                    </div>

                    <div class="form-group">
                        <label for="contractId">Mã Hợp Đồng</label>
                        <input type="number" id="contractId" name="contractId" class="form-input" placeholder="Để trống nếu không có">
                    </div>

                    <div class="form-group">
                        <label for="amount">Số Tiền (VND) *</label>
                        <input type="number" id="amount" name="amount" class="form-input" required min="1" placeholder="VD: 1800000">
                    </div>

                    <div class="form-group">
                        <label for="paymentType">Loại Thanh Toán *</label>
                        <select id="paymentType" name="paymentType" class="form-input" required>
                            <option value="">-- Chọn loại --</option>
                            <option value="DEPOSIT">Đặt Cọc (DEPOSIT)</option>
                            <option value="RENTAL">Tiền Thuê (RENTAL)</option>
                            <option value="ADDITIONAL_FEE">Phí Phát Sinh</option>
                            <option value="REFUND">Hoàn Tiền (REFUND)</option>
                        </select>
                    </div>

                    <div class="form-group">
                        <label for="paymentMethod">Phương Thức *</label>
                        <select id="paymentMethod" name="paymentMethod" class="form-input" required>
                            <option value="">-- Chọn phương thức --</option>
                            <%-- Only show methods that admin has enabled --%>
                            <c:if test="${enabledMethods['CASH']}">
                                <option value="CASH">💵 Tiền Mặt</option>
                            </c:if>
                            <c:if test="${enabledMethods['BANK_TRANSFER']}">
                                <option value="BANK_TRANSFER">🏦 Chuyển Khoản</option>
                            </c:if>
                            <c:if test="${enabledMethods['CARD']}">
                                <option value="CARD">💳 Thẻ Tín Dụng/Ghi Nợ</option>
                            </c:if>
                            <c:if test="${enabledMethods['MOMO']}">
                                <option value="MOMO">📱 MoMo</option>
                            </c:if>
                            <c:if test="${enabledMethods['VNPAY']}">
                                <option value="VNPAY">🔵 VNPay</option>
                            </c:if>
                            <c:if test="${enabledMethods['ZALOPAY']}">
                                <option value="ZALOPAY">🟢 ZaloPay</option>
                            </c:if>
                        </select>
                        <small style="color:var(--text-light);font-size:11px;">
                            Chỉ hiển thị các phương thức đang được bật.
                            <a href="${pageContext.request.contextPath}/admin/payment-settings" style="color:var(--primary);">Cấu hình</a>
                        </small>
                    </div>

                    <div class="form-group">
                        <label for="transactionRef">Mã Giao Dịch</label>
                        <input type="text" id="transactionRef" name="transactionRef" class="form-input" placeholder="VD: TXN-20260530-001">
                    </div>

                </div>
                <div class="form-group" style="margin-top:4px;">
                    <label for="notes">Ghi Chú</label>
                    <input type="text" id="notes" name="notes" class="form-input" placeholder="Ghi chú thêm (nếu có)">
                </div>
                <div style="display:flex;justify-content:flex-end;margin-top:16px;">
                    <button type="submit" class="btn btn-primary" id="btn-record-payment">💾 Lưu Thanh Toán</button>
                </div>
            </form>
        </div>
    </div>

    <%-- Payment History Table --%>
    <div class="card">
        <div class="card-header"><h3>📋 Lịch Sử Thanh Toán</h3></div>
        <c:if test="${not empty payments}">
            <table class="table">
                <thead>
                <tr>
                    <th>ID</th>
                    <th>Booking</th>
                    <th>Số Tiền</th>
                    <th>Loại</th>
                    <th>Phương Thức</th>
                    <th>Trạng Thái</th>
                    <th>Ngày Thanh Toán</th>
                </tr>
                </thead>
                <tbody>
                <c:forEach var="p" items="${payments}">
                    <tr>
                        <td>#${p.paymentId}</td>
                        <td>#${p.bookingId}</td>
                        <td><strong><fmt:formatNumber value="${p.amount}" pattern="#,##0"/> VND</strong></td>
                        <td><span class="badge badge-info">${p.paymentType}</span></td>
                        <td>${p.paymentMethod}</td>
                        <td>
                            <span class="badge badge-${p.status == 'COMPLETED' ? 'completed' : p.status == 'PENDING' ? 'pending' : 'cancelled'}">
                                ${p.status}
                            </span>
                        </td>
                        <td>${p.paidAt != null ? p.paidAt.format(dateTimeFormatter) : ''}</td>
                    </tr>
                </c:forEach>
                </tbody>
            </table>
        </c:if>
        <c:if test="${empty payments}">
            <div class="placeholder-content"><p>Chưa có giao dịch thanh toán nào.</p></div>
        </c:if>
    </div>
</div>

<style>
.alert-banner { padding:12px 18px; border-radius:10px; font-size:14px; font-weight:500; margin-bottom:16px; }
.alert-success { background:#d1fae5; color:#065f46; border:1px solid #a7f3d0; }
.alert-error   { background:#fee2e2; color:#991b1b; border:1px solid #fca5a5; }
.form-group    { display:flex; flex-direction:column; gap:5px; }
.form-group label { font-size:13px; font-weight:600; color:var(--text-primary,#1e293b); }
.form-input    {
    padding:9px 12px; border:1.5px solid var(--border-color,#e2e8f0);
    border-radius:8px; font-size:14px; width:100%; box-sizing:border-box;
    background:var(--input-bg,#fff); color:var(--text-primary,#1e293b); transition:border-color .2s;
}
.form-input:focus { outline:none; border-color:var(--primary,#6366f1); box-shadow:0 0 0 3px rgba(99,102,241,.12); }

/* Toast Notifications */
.toast-container {
    position: fixed;
    top: 24px;
    right: 24px;
    z-index: 9999;
    display: flex;
    flex-direction: column;
    gap: 12px;
    pointer-events: none;
}
.toast {
    pointer-events: auto;
    min-width: 320px;
    max-width: 450px;
    background: rgba(255, 255, 255, 0.9);
    backdrop-filter: blur(12px);
    -webkit-backdrop-filter: blur(12px);
    border-radius: 12px;
    padding: 16px 20px;
    box-shadow: 0 10px 30px rgba(0, 0, 0, 0.08);
    display: flex;
    align-items: center;
    justify-content: space-between;
    gap: 14px;
    transform: translateX(120%);
    transition: all 0.4s cubic-bezier(0.175, 0.885, 0.32, 1.275);
    border-left: 5px solid #6366f1;
}
.toast.show {
    transform: translateX(0);
}
.toast.fade-out {
    opacity: 0;
    transform: translateX(50px) scale(0.95);
    transition: all 0.3s ease;
}
.toast-success {
    border-left-color: #10b981;
}
.toast-error {
    border-left-color: #ef4444;
}
.toast-content {
    display: flex;
    align-items: center;
    gap: 12px;
}
.toast-icon {
    font-size: 20px;
}
.toast-message {
    font-size: 14px;
    font-weight: 600;
    color: #1e293b;
}
.toast-close {
    background: none;
    border: none;
    color: #94a3b8;
    cursor: pointer;
    font-size: 18px;
    padding: 4px;
    border-radius: 50%;
    display: flex;
    align-items: center;
    justify-content: center;
    transition: all 0.2s;
    line-height: 1;
}
.toast-close:hover {
    background: rgba(0, 0, 0, 0.05);
    color: #475569;
}
</style>

<script>
document.addEventListener('DOMContentLoaded', () => {
    const successToast = document.getElementById('toast-success');
    const errorToast = document.getElementById('toast-error');
    
    if (successToast) {
        setTimeout(() => successToast.classList.add('show'), 100);
        setTimeout(() => fadeOutToast(successToast), 4000);
    }
    if (errorToast) {
        setTimeout(() => errorToast.classList.add('show'), 100);
        setTimeout(() => fadeOutToast(errorToast), 5000);
    }
});

function closeToast(id) {
    const toast = document.getElementById(id);
    if (toast) {
        toast.classList.remove('show');
        setTimeout(() => toast.remove(), 400);
    }
}

function fadeOutToast(toast) {
    if (toast && toast.parentNode) {
        toast.classList.add('fade-out');
        setTimeout(() => toast.remove(), 300);
    }
}
</script>

<jsp:include page="/WEB-INF/views/layout/footer.jsp"/>

