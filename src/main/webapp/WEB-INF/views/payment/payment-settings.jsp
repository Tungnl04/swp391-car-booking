<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<jsp:include page="/WEB-INF/views/layout/header.jsp">
    <jsp:param name="pageTitle" value="Cấu Hình Thanh Toán"/>
</jsp:include>

<style>
/* ============================================================
   Payment Settings — scoped styles
   ============================================================ */
.ps-page { display: flex; flex-direction: column; gap: 24px; }

/* Tabs */
.ps-tabs { display: flex; gap: 4px; border-bottom: 2px solid var(--border-color, #e2e8f0); margin-bottom: 8px; }
.ps-tab  {
    padding: 10px 22px; font-size: 14px; font-weight: 600; cursor: pointer; border: none;
    background: transparent; color: var(--text-light, #64748b); border-radius: 8px 8px 0 0;
    transition: all .2s; position: relative; bottom: -2px;
}
.ps-tab:hover  { color: var(--primary, #6366f1); background: rgba(99,102,241,.06); }
.ps-tab.active {
    color: var(--primary, #6366f1); background: var(--card-bg, #fff);
    border: 2px solid var(--border-color, #e2e8f0); border-bottom-color: var(--card-bg, #fff);
}
.ps-panel { display: none; }
.ps-panel.active { display: block; }

/* Method Cards */
.method-grid { display: grid; grid-template-columns: repeat(auto-fill, minmax(260px, 1fr)); gap: 16px; margin: 20px 0; }
.method-card {
    border: 2px solid var(--border-color, #e2e8f0); border-radius: 14px; padding: 20px;
    display: flex; align-items: center; gap: 16px; cursor: pointer;
    transition: all .25s; background: var(--card-bg, #fff); position: relative;
}
.method-card:hover { border-color: var(--primary, #6366f1); box-shadow: 0 4px 20px rgba(99,102,241,.12); transform: translateY(-2px); }
.method-card.enabled  { border-color: #10b981; background: linear-gradient(135deg,rgba(16,185,129,.04),rgba(16,185,129,.01)); }
.method-card.disabled { opacity: .65; }
.method-icon { font-size: 32px; min-width: 48px; text-align: center; }
.method-info { flex: 1; }
.method-name { font-weight: 700; font-size: 15px; color: var(--text-primary, #1e293b); }
.method-desc { font-size: 12px; color: var(--text-light, #64748b); margin-top: 3px; }
.method-status {
    position: absolute; top: 12px; right: 12px; font-size: 11px; font-weight: 600;
    padding: 2px 8px; border-radius: 20px;
}
.status-on  { background: #d1fae5; color: #059669; }
.status-off { background: #fee2e2; color: #dc2626; }

/* Toggle Switch */
.toggle-wrap { display: flex; align-items: center; justify-content: space-between; padding: 14px 18px; border-radius: 10px; background: var(--hover-bg, #f8fafc); margin-bottom: 10px; gap: 12px; }
.toggle-label { font-size: 14px; font-weight: 500; color: var(--text-primary,#1e293b); flex: 1; }
.toggle-desc  { font-size: 12px; color: var(--text-light,#64748b); }
.toggle-switch { position: relative; display: inline-block; width: 46px; height: 24px; flex-shrink: 0; }
.toggle-switch input { opacity: 0; width: 0; height: 0; }
.toggle-slider {
    position: absolute; cursor: pointer; inset: 0; background: #cbd5e1;
    border-radius: 24px; transition: .3s;
}
.toggle-slider:before {
    content: ''; position: absolute; height: 18px; width: 18px;
    left: 3px; bottom: 3px; background: #fff; border-radius: 50%;
    transition: .3s; box-shadow: 0 1px 4px rgba(0,0,0,.2);
}
input:checked + .toggle-slider { background: #6366f1; }
input:checked + .toggle-slider:before { transform: translateX(22px); }

/* Settings Grid */
.settings-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 18px; margin-top: 16px; }
@media (max-width: 680px) { .settings-grid { grid-template-columns: 1fr; } }
.setting-field label { display: block; font-size: 13px; font-weight: 600; color: var(--text-primary,#1e293b); margin-bottom: 6px; }
.setting-field .field-desc { font-size: 11px; color: var(--text-light,#64748b); margin-bottom: 6px; }
.setting-field input, .setting-field select {
    width: 100%; padding: 9px 12px; border: 1.5px solid var(--border-color,#e2e8f0);
    border-radius: 8px; font-size: 14px; transition: border-color .2s;
    background: var(--input-bg, #fff); color: var(--text-primary,#1e293b);
    box-sizing: border-box;
}
.setting-field input:focus, .setting-field select:focus {
    outline: none; border-color: var(--primary,#6366f1);
    box-shadow: 0 0 0 3px rgba(99,102,241,.12);
}

/* Bank info section */
.bank-section { margin-top: 24px; }
.section-title { font-size: 15px; font-weight: 700; color: var(--text-primary,#1e293b); margin-bottom: 14px; padding-bottom: 8px; border-bottom: 2px solid var(--border-color,#e2e8f0); display: flex; align-items: center; gap: 8px; }

/* Alert banners */
.alert-success, .alert-error {
    padding: 12px 18px; border-radius: 10px; font-size: 14px; font-weight: 500;
    margin-bottom: 18px; display: flex; align-items: center; gap: 10px;
}
.alert-success { background: #d1fae5; color: #065f46; border: 1px solid #a7f3d0; }
.alert-error   { background: #fee2e2; color: #991b1b; border: 1px solid #fca5a5; }

/* Save button row */
.save-row { display: flex; justify-content: flex-end; margin-top: 20px; gap: 10px; }

/* Info box */
.info-box { background: rgba(99,102,241,.07); border: 1px solid rgba(99,102,241,.2); border-radius: 10px; padding: 14px 18px; font-size: 13px; color: var(--text-primary,#1e293b); margin-bottom: 18px; }
.info-box strong { color: var(--primary,#6366f1); }

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

<div class="page-content">
    <div class="ps-page">

        <%-- Toast container for screen notifications --%>
        <div class="toast-container" id="toast-container">
            <c:if test="${not empty successMsg}">
                <div class="toast toast-success" id="toast-success">
                    <div class="toast-content">
                        <span class="toast-icon">✨</span>
                        <span class="toast-message">${successMsg}</span>
                    </div>
                    <button class="toast-close" onclick="closeToast('toast-success')">&times;</button>
                </div>
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

        <div class="card">
            <div class="card-header">
                <h3>⚙️ Cấu Hình Thanh Toán</h3>
                <span style="font-size:13px;color:var(--text-light);">Chỉ Admin mới có thể thay đổi cài đặt này</span>
            </div>

            <%-- Tab Navigation --%>
            <div class="ps-tabs" style="padding: 0 24px;">
                <button class="ps-tab ${activeTab == 'methods' ? 'active' : ''}"
                        onclick="switchTab('methods', this)" type="button" id="tab-methods">
                    💳 Phương Thức Thanh Toán
                </button>
                <button class="ps-tab ${activeTab == 'settings' ? 'active' : ''}"
                        onclick="switchTab('settings', this)" type="button" id="tab-settings">
                    🔧 Cài Đặt Thanh Toán
                </button>
                <button class="ps-tab ${activeTab == 'bank' ? 'active' : ''}"
                        onclick="switchTab('bank', this)" type="button" id="tab-bank">
                    🏦 Thông Tin Ngân Hàng
                </button>
            </div>

            <div style="padding: 24px;">

                <%-- ============================================================ --%>
                <%-- TAB 1: Payment Methods Toggle                                --%>
                <%-- ============================================================ --%>
                <div id="panel-methods" class="ps-panel ${activeTab == 'methods' ? 'active' : ''}">
                    <div class="info-box">
                        <strong>ℹ️ Lưu ý:</strong> Bật/tắt phương thức thanh toán sẽ ảnh hưởng ngay đến quy trình đặt xe và ghi nhận thanh toán. Đảm bảo ít nhất một phương thức được bật.
                    </div>

                    <form method="POST" action="${pageContext.request.contextPath}/admin/payment-settings" id="form-methods">
                        <input type="hidden" name="action" value="updateMethods"/>
                        <input type="hidden" name="tab"    value="methods"/>

                        <div class="method-grid">
                            <%-- CASH --%>
                            <c:set var="cashEnabled" value="${methodMap['PAYMENT_METHOD_CASH_ENABLED'] != null && methodMap['PAYMENT_METHOD_CASH_ENABLED'].policyValue == 'true'}"/>
                            <div class="method-card ${cashEnabled ? 'enabled' : 'disabled'}" onclick="toggleMethod('PAYMENT_METHOD_CASH_ENABLED')">
                                <span class="method-status ${cashEnabled ? 'status-on' : 'status-off'}">${cashEnabled ? 'BẬT' : 'TẮT'}</span>
                                <div class="method-icon">💵</div>
                                <div class="method-info">
                                    <div class="method-name">Tiền Mặt</div>
                                    <div class="method-desc">Thanh toán trực tiếp tại quầy</div>
                                </div>
                                <label class="toggle-switch" onclick="event.stopPropagation()">
                                    <input type="checkbox" name="PAYMENT_METHOD_CASH_ENABLED" id="PAYMENT_METHOD_CASH_ENABLED" ${cashEnabled ? 'checked' : ''} onchange="updateCard(this)">
                                    <span class="toggle-slider"></span>
                                </label>
                            </div>

                            <%-- BANK TRANSFER --%>
                            <c:set var="bankEnabled" value="${methodMap['PAYMENT_METHOD_BANK_TRANSFER_ENABLED'] != null && methodMap['PAYMENT_METHOD_BANK_TRANSFER_ENABLED'].policyValue == 'true'}"/>
                            <div class="method-card ${bankEnabled ? 'enabled' : 'disabled'}" onclick="toggleMethod('PAYMENT_METHOD_BANK_TRANSFER_ENABLED')">
                                <span class="method-status ${bankEnabled ? 'status-on' : 'status-off'}">${bankEnabled ? 'BẬT' : 'TẮT'}</span>
                                <div class="method-icon">🏦</div>
                                <div class="method-info">
                                    <div class="method-name">Chuyển Khoản</div>
                                    <div class="method-desc">Chuyển khoản ngân hàng nội địa</div>
                                </div>
                                <label class="toggle-switch" onclick="event.stopPropagation()">
                                    <input type="checkbox" name="PAYMENT_METHOD_BANK_TRANSFER_ENABLED" id="PAYMENT_METHOD_BANK_TRANSFER_ENABLED" ${bankEnabled ? 'checked' : ''} onchange="updateCard(this)">
                                    <span class="toggle-slider"></span>
                                </label>
                            </div>

                            <%-- CARD --%>
                            <c:set var="cardEnabled" value="${methodMap['PAYMENT_METHOD_CARD_ENABLED'] != null && methodMap['PAYMENT_METHOD_CARD_ENABLED'].policyValue == 'true'}"/>
                            <div class="method-card ${cardEnabled ? 'enabled' : 'disabled'}" onclick="toggleMethod('PAYMENT_METHOD_CARD_ENABLED')">
                                <span class="method-status ${cardEnabled ? 'status-on' : 'status-off'}">${cardEnabled ? 'BẬT' : 'TẮT'}</span>
                                <div class="method-icon">💳</div>
                                <div class="method-info">
                                    <div class="method-name">Thẻ Tín Dụng / Ghi Nợ</div>
                                    <div class="method-desc">Visa, Mastercard, JCB</div>
                                </div>
                                <label class="toggle-switch" onclick="event.stopPropagation()">
                                    <input type="checkbox" name="PAYMENT_METHOD_CARD_ENABLED" id="PAYMENT_METHOD_CARD_ENABLED" ${cardEnabled ? 'checked' : ''} onchange="updateCard(this)">
                                    <span class="toggle-slider"></span>
                                </label>
                            </div>

                            <%-- MOMO --%>
                            <c:set var="momoEnabled" value="${methodMap['PAYMENT_METHOD_MOMO_ENABLED'] != null && methodMap['PAYMENT_METHOD_MOMO_ENABLED'].policyValue == 'true'}"/>
                            <div class="method-card ${momoEnabled ? 'enabled' : 'disabled'}" onclick="toggleMethod('PAYMENT_METHOD_MOMO_ENABLED')">
                                <span class="method-status ${momoEnabled ? 'status-on' : 'status-off'}">${momoEnabled ? 'BẬT' : 'TẮT'}</span>
                                <div class="method-icon">📱</div>
                                <div class="method-info">
                                    <div class="method-name">MoMo</div>
                                    <div class="method-desc">Ví điện tử MoMo</div>
                                </div>
                                <label class="toggle-switch" onclick="event.stopPropagation()">
                                    <input type="checkbox" name="PAYMENT_METHOD_MOMO_ENABLED" id="PAYMENT_METHOD_MOMO_ENABLED" ${momoEnabled ? 'checked' : ''} onchange="updateCard(this)">
                                    <span class="toggle-slider"></span>
                                </label>
                            </div>

                            <%-- VNPAY --%>
                            <c:set var="vnpayEnabled" value="${methodMap['PAYMENT_METHOD_VNPAY_ENABLED'] != null && methodMap['PAYMENT_METHOD_VNPAY_ENABLED'].policyValue == 'true'}"/>
                            <div class="method-card ${vnpayEnabled ? 'enabled' : 'disabled'}" onclick="toggleMethod('PAYMENT_METHOD_VNPAY_ENABLED')">
                                <span class="method-status ${vnpayEnabled ? 'status-on' : 'status-off'}">${vnpayEnabled ? 'BẬT' : 'TẮT'}</span>
                                <div class="method-icon">🔵</div>
                                <div class="method-info">
                                    <div class="method-name">VNPay</div>
                                    <div class="method-desc">Cổng thanh toán VNPay</div>
                                </div>
                                <label class="toggle-switch" onclick="event.stopPropagation()">
                                    <input type="checkbox" name="PAYMENT_METHOD_VNPAY_ENABLED" id="PAYMENT_METHOD_VNPAY_ENABLED" ${vnpayEnabled ? 'checked' : ''} onchange="updateCard(this)">
                                    <span class="toggle-slider"></span>
                                </label>
                            </div>

                            <%-- ZALOPAY --%>
                            <c:set var="zaloEnabled" value="${methodMap['PAYMENT_METHOD_ZALOPAY_ENABLED'] != null && methodMap['PAYMENT_METHOD_ZALOPAY_ENABLED'].policyValue == 'true'}"/>
                            <div class="method-card ${zaloEnabled ? 'enabled' : 'disabled'}" onclick="toggleMethod('PAYMENT_METHOD_ZALOPAY_ENABLED')">
                                <span class="method-status ${zaloEnabled ? 'status-on' : 'status-off'}">${zaloEnabled ? 'BẬT' : 'TẮT'}</span>
                                <div class="method-icon">🟢</div>
                                <div class="method-info">
                                    <div class="method-name">ZaloPay</div>
                                    <div class="method-desc">Ví điện tử ZaloPay</div>
                                </div>
                                <label class="toggle-switch" onclick="event.stopPropagation()">
                                    <input type="checkbox" name="PAYMENT_METHOD_ZALOPAY_ENABLED" id="PAYMENT_METHOD_ZALOPAY_ENABLED" ${zaloEnabled ? 'checked' : ''} onchange="updateCard(this)">
                                    <span class="toggle-slider"></span>
                                </label>
                            </div>
                        </div><%-- /method-grid --%>

                        <div class="save-row">
                            <button type="submit" class="btn btn-primary" id="btn-save-methods">💾 Lưu Phương Thức Thanh Toán</button>
                        </div>
                    </form>
                </div>

                <%-- ============================================================ --%>
                <%-- TAB 2: General Payment Settings                              --%>
                <%-- ============================================================ --%>
                <div id="panel-settings" class="ps-panel ${activeTab == 'settings' ? 'active' : ''}">
                    <div class="info-box">
                        <strong>⚙️ Cài đặt:</strong> Các thông số này kiểm soát hành vi thanh toán trong quy trình thuê xe.
                    </div>

                    <form method="POST" action="${pageContext.request.contextPath}/admin/payment-settings" id="form-settings">
                        <input type="hidden" name="action" value="updateSettings"/>
                        <input type="hidden" name="tab"    value="settings"/>

                        <div class="settings-grid">
                            <%-- Deposit Percentage --%>
                            <c:set var="depositPercentage" value="${settingMap['DEPOSIT_PERCENTAGE'] != null ? settingMap['DEPOSIT_PERCENTAGE'].policyValue : '30'}"/>
                            <div class="setting-field">
                                <label for="f-deposit">💰 Tỷ lệ đặt cọc (%)</label>
                                <div class="field-desc">Phần trăm tổng giá trị thuê xe phải đặt cọc trước</div>
                                <input type="number" id="f-deposit" name="policy_DEPOSIT_PERCENTAGE"
                                       value="${depositPercentage}" min="0" max="100" placeholder="30">
                            </div>

                            <%-- Grace Period --%>
                            <c:set var="gracePeriod" value="${settingMap['PAYMENT_GRACE_PERIOD_HOURS'] != null ? settingMap['PAYMENT_GRACE_PERIOD_HOURS'].policyValue : '24'}"/>
                            <div class="setting-field">
                                <label for="f-grace">⏱️ Thời gian gia hạn thanh toán (giờ)</label>
                                <div class="field-desc">Số giờ chờ thanh toán trước khi tự động hủy đặt xe</div>
                                <input type="number" id="f-grace" name="policy_PAYMENT_GRACE_PERIOD_HOURS"
                                       value="${gracePeriod}" min="1" max="168" placeholder="24">
                            </div>
                        </div>

                        <%-- Partial Payment Toggle --%>
                        <div style="margin-top: 20px;">
                            <div class="section-title">🔀 Tùy Chọn Nâng Cao</div>
                            <c:set var="partialAllowed" value="${settingMap['PAYMENT_PARTIAL_ALLOWED'] != null && settingMap['PAYMENT_PARTIAL_ALLOWED'].policyValue == 'true'}"/>
                            <div class="toggle-wrap">
                                <div>
                                    <div class="toggle-label">Cho phép thanh toán từng phần</div>
                                    <div class="toggle-desc">Khách hàng có thể thanh toán chưa đủ 100% giá trị thuê xe</div>
                                </div>
                                <label class="toggle-switch">
                                    <input type="checkbox" name="policy_PAYMENT_PARTIAL_ALLOWED" id="f-partial"
                                           value="true" ${partialAllowed ? 'checked' : ''}>
                                    <span class="toggle-slider"></span>
                                </label>
                            </div>
                        </div>

                        <div class="save-row">
                            <button type="submit" class="btn btn-primary" id="btn-save-settings">💾 Lưu Cài Đặt Thanh Toán</button>
                        </div>
                    </form>
                </div>

                <%-- ============================================================ --%>
                <%-- TAB 3: Bank Account Information                              --%>
                <%-- ============================================================ --%>
                <div id="panel-bank" class="ps-panel ${activeTab == 'bank' ? 'active' : ''}">
                    <div class="info-box">
                        <strong>🏦 Thông tin ngân hàng</strong> này sẽ được hiển thị trong hóa đơn và hướng dẫn chuyển khoản gửi cho khách hàng.
                    </div>

                    <form method="POST" action="${pageContext.request.contextPath}/admin/payment-settings" id="form-bank">
                        <input type="hidden" name="action" value="updateSettings"/>
                        <input type="hidden" name="tab"    value="bank"/>

                        <div class="section-title">🏦 Tài Khoản Nhận Tiền</div>
                        <div class="settings-grid">
                            <c:set var="bankName"   value="${settingMap['BANK_NAME'] != null ? settingMap['BANK_NAME'].policyValue : ''}"/>
                            <div class="setting-field">
                                <label for="f-bankname">Tên Ngân Hàng</label>
                                <div class="field-desc">Ví dụ: Vietcombank, Techcombank, VietinBank</div>
                                <input type="text" id="f-bankname" name="policy_BANK_NAME"
                                       value="${bankName}" placeholder="Vietcombank" maxlength="100">
                            </div>

                            <c:set var="bankBranch" value="${settingMap['BANK_BRANCH'] != null ? settingMap['BANK_BRANCH'].policyValue : ''}"/>
                            <div class="setting-field">
                                <label for="f-bankbranch">Chi Nhánh</label>
                                <div class="field-desc">Chi nhánh ngân hàng quản lý tài khoản</div>
                                <input type="text" id="f-bankbranch" name="policy_BANK_BRANCH"
                                       value="${bankBranch}" placeholder="Chi nhánh TP.HCM" maxlength="200">
                            </div>

                            <c:set var="accNumber" value="${settingMap['BANK_ACCOUNT_NUMBER'] != null ? settingMap['BANK_ACCOUNT_NUMBER'].policyValue : ''}"/>
                            <div class="setting-field">
                                <label for="f-accnumber">Số Tài Khoản</label>
                                <div class="field-desc">Số tài khoản nhận tiền chuyển khoản</div>
                                <input type="text" id="f-accnumber" name="policy_BANK_ACCOUNT_NUMBER"
                                       value="${accNumber}" placeholder="1234567890" maxlength="30">
                            </div>

                            <c:set var="accName" value="${settingMap['BANK_ACCOUNT_NAME'] != null ? settingMap['BANK_ACCOUNT_NAME'].policyValue : ''}"/>
                            <div class="setting-field">
                                <label for="f-accname">Tên Chủ Tài Khoản</label>
                                <div class="field-desc">Tên hiển thị khi khách chuyển khoản</div>
                                <input type="text" id="f-accname" name="policy_BANK_ACCOUNT_NAME"
                                       value="${accName}" placeholder="CONG TY TNHH CAR RENTAL" maxlength="200">
                            </div>
                        </div>

                        <%-- Preview Card --%>
                        <div class="section-title" style="margin-top:28px;">👁️ Xem Trước Thẻ Chuyển Khoản</div>
                        <div style="max-width:380px; border:2px solid #6366f1; border-radius:16px; padding:24px; background:linear-gradient(135deg,#6366f1,#8b5cf6); color:#fff; box-shadow:0 8px 24px rgba(99,102,241,.3);">
                            <div style="font-size:11px; opacity:.8; text-transform:uppercase; letter-spacing:1px; margin-bottom:4px;">Tài Khoản Nhận Tiền</div>
                            <div id="preview-bankname" style="font-size:18px; font-weight:700; margin-bottom:16px;">${not empty bankName ? bankName : 'Vietcombank'}</div>
                            <div style="font-size:11px; opacity:.7;">Số Tài Khoản</div>
                            <div id="preview-accnumber" style="font-size:22px; font-weight:800; letter-spacing:2px; margin-bottom:8px;">${not empty accNumber ? accNumber : '—'}</div>
                            <div id="preview-accname" style="font-size:14px; font-weight:600; opacity:.9;">${not empty accName ? accName : '—'}</div>
                            <div id="preview-branch" style="font-size:12px; opacity:.7; margin-top:4px;">${not empty bankBranch ? bankBranch : ''}</div>
                        </div>

                        <div class="save-row">
                            <button type="submit" class="btn btn-primary" id="btn-save-bank">💾 Lưu Thông Tin Ngân Hàng</button>
                        </div>
                    </form>
                </div>

            </div><%-- /padding--%>
        </div><%-- /card --%>
    </div><%-- /ps-page --%>
</div><%-- /page-content --%>

<script>
// ─── Tab switching ────────────────────────────────────────────────────────────
function switchTab(name, btn) {
    document.querySelectorAll('.ps-panel').forEach(p => p.classList.remove('active'));
    document.querySelectorAll('.ps-tab').forEach(b => b.classList.remove('active'));
    document.getElementById('panel-' + name).classList.add('active');
    btn.classList.add('active');
}

// ─── Method card toggle: clicking the whole card flips the checkbox ───────────
function toggleMethod(key) {
    const cb = document.getElementById(key);
    if (cb) { cb.checked = !cb.checked; updateCard(cb); }
}

// Updates card style when toggle changes
function updateCard(checkbox) {
    const card   = checkbox.closest('.method-card');
    const badge  = card.querySelector('.method-status');
    const on     = checkbox.checked;
    card.classList.toggle('enabled',  on);
    card.classList.toggle('disabled', !on);
    badge.textContent = on ? 'BẬT' : 'TẮT';
    badge.className   = 'method-status ' + (on ? 'status-on' : 'status-off');
}

// ─── Live preview for bank tab ────────────────────────────────────────────────
function livePreview(inputId, previewId) {
    const inp = document.getElementById(inputId);
    const prv = document.getElementById(previewId);
    if (inp && prv) inp.addEventListener('input', () => { prv.textContent = inp.value || '—'; });
}
livePreview('f-bankname',   'preview-bankname');
livePreview('f-accnumber',  'preview-accnumber');
livePreview('f-accname',    'preview-accname');
livePreview('f-bankbranch', 'preview-branch');

// ─── Confirm before saving ───────────────────────────────────────────────────
document.querySelectorAll('form[id^="form-"]').forEach(form => {
    form.addEventListener('submit', function(e) {
        const ok = confirm('Bạn có chắc muốn lưu các thay đổi cài đặt thanh toán?');
        if (!ok) e.preventDefault();
    });
});

// ─── Checkbox for partial payment: store as "true"/"false" string ─────────────
const partialCb = document.getElementById('f-partial');
if (partialCb) {
    partialCb.addEventListener('change', function() {
        this.value = this.checked ? 'true' : 'false';
    });
}

// ─── Toast control script ─────────────────────────────────────────────────────
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
